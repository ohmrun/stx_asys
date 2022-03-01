package stx.fs;

using stx.fs.path.Logging;

typedef LiftString            = stx.fs.path.lift.LiftString;
typedef PathParseFailure      = stx.fail.PathParseFailure;
typedef PathParseFailureSum   = stx.fail.PathParseFailure.PathParseFailureSum;

class PathApi extends Clazz{
  
}
class Path{
  static public function path(wildcard:Wildcard){
    return new PathApi();
  }
  static public function parse(str:String):Attempt<HasDevice,Raw,PathFailure>{
    return Attempt.fromFun1Produce(
      (env:HasDevice) -> {
        __.log().debug(_ -> _.pure(env));
        return Produce.fromProvide(__.option(str).map(
            (s:String) -> env.device.distro.is_windows().if_else(
              () -> new Windows().asBase(),
              () -> new Posix().asBase()
            ).asParser()
            .provide(s.reader())
            .convert(
              (res:ParseResult<String,Array<Token>>) -> __.log().through()(res).is_ok().if_else(
                ()      -> 
                  __.option(res.value)
                    .flat_map((x:Option<Array<Token>>) -> x)
                    .resolve(f -> f.explain(_ -> _.e_undefined()))
                    .map(Cluster.lift),
                ()      -> res.fails().toRes().map(x -> x.defv([])).errate( (e) -> e.toPathParseFailure().toPathFailure() ) 
            )
            )
          ).defv(Provide.pure(__.reject(__.fault().of(E_Path_PathParse(E_PathParse_EmptyInput)))))
        );
      }
    );
  }
}

/**
 * An absolute path to an `Entry`.
**/
typedef ArchiveDef                    = stx.fs.path.Archive.ArchiveDef;
typedef Archive                       = stx.fs.path.Archive;


/**
 * An absolute path with no `Entry`.
**/
typedef DirectoryDef                  = stx.fs.path.Directory.DirectoryDef;
typedef Directory                     = stx.fs.path.Directory;

/**
 * A reference to the root of a volume.
**/
typedef DriveDef                      = stx.pico.Option<String>;
typedef Drive                         = DriveDef;

/**
 * A name and possible extension of a resource found in a `Directory`;
**/
typedef EntryDef                      = stx.fs.path.Entry.EntryDef;
typedef Entry                         = stx.fs.path.Entry;


/**
  A normalized `Route` from a `Drive`..
**/
typedef Folder = {
  var drive : Drive;
  var track : Route;
}
/**
 * Info about a resource.
**/
typedef Kind = {
  final absolute:Bool;
  final normalized:Bool;

  final has_trailing_slash:Bool;
  final file:Trivalent;
}
typedef Location = {
  var drive : Drive;
  var track : Track;
  var entry : Option<Entry>;
} 

typedef Move    = stx.fs.path.Move;
typedef MoveSum = stx.fs.path.Move.MoveSum;
/**
  A valid filesystem node name.
**/
typedef Name                          = String;

typedef PathFailure                   = stx.fail.PathFailure;
typedef PathFailureSum                = stx.fail.PathFailure.PathFailureSum;

typedef AddressDef                    = stx.fs.path.Address.AddressDef;
/**
  A representation of the location of any filesystem resource.
**/
typedef Address                       = stx.fs.path.Address;
/**
 * A denormalized `Route` from a `Stem`.
**/  
typedef PortalDef = {
  var drive : Stem;
  var track : Route;
};
typedef Portal                        = PortalDef;

/**
  `Array` of parsed path `Token`s.
**/
typedef RawDef = Cluster<Token>;
typedef Raw    = stx.fs.path.Raw;
/**
 * A description of `Move`s between a `Stem` and a filesystem resource.
**/
typedef RouteDef                      = stx.fs.path.Route.RouteDef;
typedef Route                         = stx.fs.path.Route;

typedef Separator                     = stx.fs.path.Separator;


/**
  * A normalized, unidirectional description of moves between a `Stem` and a filesystem resource. 
**/
typedef TrackDef                      = stx.fs.path.Track.TrackDef;
typedef Track                         = stx.fs.path.Track;

typedef StemSum                       = stx.fs.path.Stem.StemSum;
typedef Stem                          = stx.fs.path.Stem;

typedef AttachmentDef                 = stx.fs.path.Attachment.AttachmentDef;
typedef Attachment                    = stx.fs.path.Attachment;


class LiftDrive{
  static public function canonical(drive:Drive,env:HasDevice):String{
    var sep = '${env.device.sep}';
    return switch(drive){
      case Some(name)       : 'name$sep';
      case None             :  sep;
    }
  }
}

typedef LiftAttemptHasDeviceRaw       = stx.fs.path.lift.LiftAttemptHasDeviceRaw;