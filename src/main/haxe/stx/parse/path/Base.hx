package stx.parse.path;

using stx.parse.path.Base;

function id(str) return __.parse().id(str);
function reg(str) return __.parse().reg(str);
function log(wildcard){
	return stx.Log.ZERO.tag('stx/parse/path');
}
class Base extends ParserCls<String,Cluster<Token>>{
	var is_windows : Bool;
	public function new(is_windows,?id:Pos){
		this.is_windows = is_windows;
		super(Some('asys.fs.Path'),id);
	}
	private function separator(){
		return is_windows ? Separator.WinSeparator : Separator.PosixSeparator;
	}
	public function p_sep(): Parser<String,Token>{
		return Parsers.When(
			string -> {
				return string == separator();	
			},
			Some('p_sep')
		).asParser().then(
			_ -> FPTSep
		).with_tag('p_sep');
	}
	public function p_root():Parser<String,Cluster<Token>>{
		__.log().trace(is_windows);
		return if(is_windows) {
				"[A-Za-z]:".reg()
				.then( Some.fn().then(FPTDrive) )
				.and(p_sep().option()).then(
					(tp) -> switch(tp.snd()){
						case Some(v) : [tp.fst(),v];
						case None		 : [tp.fst()];
					}
				);
			}else{
				inspect(p_sep().then( function(x) return [FPTDrive(None)] ));
			}
	}

	public var p_up  			= 
		'..'.id().then ( function(x) return FPTUp ).with_tag('p_up');


	public var char_and_space
		= Parse.alphanum.or(Parse.whitespace).with_tag('char_and_space');

	public var p_special_chars 
		= "[^<>:\"\\\\|?*\\/A-Za-z0-9]".reg().with_tag('p_special_chars');


	public function p_path_chars(){
		final not_sep = p_sep().not().tag_error('p_path_chars.p_sep');
		final char 		= char_and_space.or(p_special_chars); 
		return 
			not_sep._and(char.or(".".id()))
			.and(
				not_sep._and(char).many()
			).then(
				__.decouple(
					(x:String,r:Cluster<String>) -> r.cons(x)
				)
			).tokenize()
			 .with_tag('p_path_chars'); 
	}		
	public function p_file_chars(){
		return char_and_space.or(p_special_chars).one_many().tokenize().with_tag('p_file_chars');
	}
	static function spect<I,O>(parser:Parser<I,O>,?pos:Pos){
		return parser;
	}
	static function inspect<I,O>(parser:Parser<I,O>,?pos:Pos){
		return Parsers.Inspect(
			parser,
			__.log().printer(pos),((x:ParseResult<I,O>) -> x.toString()).fn().then(__.log().printer(pos)));
	}
	public function p_term(){
		//__.log().debug('pterm');
		return p_path_chars().and_(
			':'.id().not()
		).and_then(
			(str:String) -> {
				__.log().trace(' ###$str###');
				return switch(str){
					case '.' 		: Parsers.Failed('not a term');
					case '..' 	: Parsers.Failed('not a term');
					default  		: 
						var all = str.split(".");
						var ext = null;
						if(all.length>1 && all[1] != null && str!='.'){
							ext = all.pop();
						}
					return if(ext==null){
						Parsers.Succeed(FPTDown(str));
					}else{
						Parsers.Succeed(FPTFile(all.join('.'),ext));
					}
				}
			}
		).with_tag('p_term');
	}
	public function p_junction(){
		return inspect(p_term().or(p_up).or(p_down()));
	}
	public function p_down(){
		return p_path_chars().and_(
			':'.id().not()
		).then( function(str) { return FPTDown(str); } );
	}
	public function p_body(){
		return inspect(p_junction().rep1sep0(p_sep()));
	}
	public function p_abs(){ 
		return p_root()
		.and( p_body().option() )
		.then( 
			function(t) {
				__.log().trace('${t.tup()}');
				return switch(t.tup()){
					case tuple2(tk,b2_opt_arr) :
						var out = [];
						for(v in tk){ 
							out.push(v); 
						}
						for(v0 in b2_opt_arr){ 
							for(v1 in v0){
								out.push(v1); 
							}
						}
						out;
					default : [];
				}
			}
		);
	}
	public function p_rel_root(){
		return '.'.id().and_('.'.id().not().and(p_sep().option())).then( (_) -> FPTRel);
	}
	public function p_rel():Parser<String,Cluster<Token>>{ 
		return p_rel_root().or(p_junction())
		.and(p_sep().option().with_tag("HSDF"))
		.and(
				p_up.repsep0(p_sep()).and_(p_sep()).and_with(p_junction().repsep0(p_sep()) 
				,function(a,b){
					trace('$a $b');
					return a.concat(b);
				}
			).or(
				p_junction().repsep0(p_sep())
			).option()
		).then(
			(tp) -> tp.decouple(
				(tp,c:StdOption<Cluster<Token>>) -> tp.decouple(
					(a:Null<Token>,b:Option<Token>) -> switch([a,b,c]){
						case [null,None,None]							: [FPTRel].imm();
						case [null,None,Some(v)] 	 				: [FPTRel].imm().concat(v);
						case [head,None,Some(v)]  				: [head].imm().concat(v);
						case [head,Some(tail),Some(v)]  	: [head,tail].imm().concat(v);
						case [head,Some(tail),None]  			: [head,tail].imm();
						case [head,None,None]  						: [head].imm();
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
					__.log().debug('${tp.tup()}');
					return ((l:Cluster<Token>,r:Option<Token>) -> switch(r){
						case Some(v): l.concat([v]);
						case None 	: l;
					})(tp.fst(),tp.snd());
				}
			).or(
				p_term().then(
					(x) -> [x]
				)
			).and_(Parsers.Eof().lookahead());
	}               
	public function defer(i:ParseInput<String>,cont:Terminal<ParseResult<String,Cluster<Token>>,Noise>):Work{
		return p_path().defer(i,cont);
	}
	public function format(arr:Cluster<Token>){
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
	public function stringify(n:Token){
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
	public function provide(input){
		return this.asParser().provide(input);
	}
}