package stx.parse.path;

class Base extends ParserBase<String,Array<Token>>{
	var is_windows : Bool;
	public function new(is_windows,?id:Pos){
		this.is_windows = is_windows;
		super(Some('asys.fs.Path'),id);
	}
	private function separator(){
		return is_windows ? Separator.WinSeparator : Separator.PosixSeparator;
	}
	public function p_sep(): Parser<String,Token>{
		var sep = separator(); 
		return Parser.SyncAnon(function(ipt:Input<String>):ParseResult<String,Token>{
				return 
					if( ipt.take(1) == sep ){ 
						ipt.drop(1).ok(FPTSep);
					}else{
						ipt.fail('not a separator');
					}
			}).asParser();
	}
	public function p_root():Parser<String,Array<Token>>{
		return if(is_windows) {
				"[A-Za-z]:".regex()
				.then( Some.fn().then(FPTDrive) )
				.and(p_sep().option()).then(
					(tp) -> switch(tp.snd()){
						case Some(v) : [tp.fst(),v];
						case None		 : [tp.fst()];
					}
				);
			}else{
				p_sep().then( function(x) return [FPTDrive(None)] );
			}
	}

	public var p_up  			= 
		'..'.identifier().then ( function(x) return FPTUp );


	public var char_and_space
		= Parse.alphanum.or(Parse.whitespace);

	public var p_special_chars 
		= "[^<>:\"\\\\|?*\\/A-Za-z0-9]".regex();


	public function p_path_chars(){
		return p_sep().not()._and(char_and_space.or( p_special_chars )).one_many().token(); 
	}		
	public function p_file_chars(){
		return char_and_space.or(p_special_chars).one_many().token();
	}
	public function p_term(){
		return p_path_chars().and_(
			p_sep().not()
			.and(':'.id().not())
		).and_then(
			(str:String) -> {
				//trace(' ###$str###');
				return switch(str){
					case '.' 		: Parser.Failed('not a term');
					case '..' 	: Parser.Failed('not a term');
					default  		: 
					var all = str.split(".");
					var ext = null;
					if(all.length>1 && all[1] != null && str!='.'){
						ext = all.pop();
					}
					return if(ext==null){
						Parser.Succeed(FPTDown(str));
					}else{
						Parser.Succeed(FPTFile(all.join('.'),ext));
					}
				}
			}
		);
	}
	public function p_junction(){
		return p_term().or(p_up).or(p_down());
	}
	public function p_down(){
		return p_path_chars().and_(
			':'.id().not()
		).then( function(str) { return FPTDown(str); } );
	}
	public function p_abs(){ 
		return p_root()
		.and( p_junction().repsep0(p_sep()).option() )
		.then( 
				function(t) {
					return switch(t.cat()){
						case [Left(tk),Right(b2_opt_arr)] :
							var out = [];
							for(v in tk){
								out.push(v);
							}
							//out.push(tk.b);
							switch(b2_opt_arr){
								case Some(v) : 
									for(v0 in v){
										out.push(v0);
									}
								default : null;
							}
							out;
						default : [];
					}
				}
		);
	}
	public function p_rel_root(){
		return '.'.id().and_('.'.id().not()).and(p_sep().not()).then( (_) -> FPTRel);
	}
	public function p_rel():Parser<String,Array<Token>>{ 
		return p_rel_root().or(p_junction())
		.and(p_sep().option())
		.and(
				p_up.repsep0(p_sep()).and_(p_sep()).and_with( p_junction().repsep0(p_sep()) 
				,	function(a,b){
						//trace('$a $b');
						return a.concat(b);
					}
			).or(
				p_junction().repsep0(p_sep())
			).option()
		).then(
			(tp) -> tp.decouple(
				(tp,c:Option<Array<Token>>) -> tp.decouple(
					(a:Null<Token>,b:Option<Token>) -> switch([a,b,c]){
						case [null,None,None]							: [FPTRel];
						case [null,None,Some(v)] 	 				: [FPTRel].concat(v);
						case [head,None,Some(v)]  				: [head].concat(v);
						case [head,Some(tail),Some(v)]  	: [head,tail].concat(v);
						case [head,Some(tail),None]  			: [head,tail];
						case [head,None,None]  						: [head];
					}
				)
			)
		);
	}
	public function p_path(){
		return p_rel()
			.or(p_abs())
			.and(p_sep().option())
			.then(
				(tp) -> {
					//trace(tp);
					return ((l:Array<Token>,r:Option<Token>) -> switch(r){
						case Some(v): l.concat([v]);
						case None 	: l;
					})(tp.fst(),tp.snd());
				}
			).or(
				p_term().then(
					(x) -> [x]
				)
			).and_(Parse.eof().lookahead());
	}               
	override public function doApplyII(i:Input<String>,cont:Terminal<ParseResult<String,Array<Token>>,Noise>):Work{
		return p_path().applyII(i,cont);
	}
	public function format(arr:Array<Token>){
		var o = arr.lfold(
			function(e,init){
				switch (e) {
					case FPTUp 								: init.length > 1 ? init.pop() : null;
					case FPTDown(str) 				: init.push(str);
					case FPTDrive(Some(root)) : init.push(root);
					default 									:
				}
				return init;
			},
			[]
		);
		return o;
	}
	public function toString(n:Token){
		return switch (n){
			case FPTUp 										:	'..';
			case FPTDown(str) 						:	str;
			case FPTDrive(Some(root)) 		: root;
			case FPTDrive(None)						:	separator().toString();
			case FPTRel 									: '.';
			case FPTFile(str, null)				: str;
			case FPTFile(str,ext) 				: '$str.$ext'; 
			case FPTSep 									: separator().toString();
		}
	}
	public function asBase():Base{
		return this;
	}
	public function forward(input){
		return this.asParser().forward(input);
	}
}