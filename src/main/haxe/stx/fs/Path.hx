package stx.fs;

typedef LiftString = stx.fs.path.lift.LiftString;

class PathApi extends Clazz{
  
}
class Path{
  static public function path(wildcard:Wildcard){
    return new PathApi();
  }
  static public function parse(str:String):Attempt<HasDevice,Raw,PathFailure>{
    return Attempt.fromFun1Produce(
      (env:HasDevice) -> {
        return Produce.fromProvide(__.option(str).map(
          (s:String) -> env.device.distro.is_windows().if_else(
            () -> new Windows().asBase(),
            () -> new Posix().asBase()
          ).asParser()
           .forward(s.reader())
           .convert(
             (res:ParseResult<String,Array<Token>>) -> res.fold(
              (a)     -> __.accept((a.with.defv([]):Raw)),
              (e)     -> e.toRes().errate( (e) -> e.toPathParseFailure().toPathFailure() ) 
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
typedef ArchiveDef                    = stx.fs.path.pack.Archive.ArchiveDef;
typedef Archive                       = stx.fs.path.pack.Archive;


/**
 * An absolute path with no `Entry`.
**/
typedef DirectoryDef                  = stx.fs.path.pack.Directory.DirectoryDef;
typedef Directory                     = stx.fs.path.pack.Directory;

/**
 * A reference to the root of a volume.
**/
typedef DriveDef                      = stx.pico.Option<String>;
typedef Drive                         = DriveDef;

/**
 * A name and possible extension of a resource found in a `Directory`;
**/
typedef EntryDef                      = stx.fs.path.pack.Entry.EntryDef;
typedef Entry                         = stx.fs.path.pack.Entry;


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
  public var absolute(default,null):Bool;
  public var normalised(default,null):Bool;

  public var has_trailing_slash(default,null):Bool;
  public var has_ext(default,null):Bool;
}
typedef Location = {
  var drive : Drive;
  var track : Track;
  var entry : Option<Entry>;
} 

/**
  * A parsed token to walk the directory tree.
**/
enum MoveSum{
  Into(name:String);
  From;
}
typedef Move                          = MoveSum;
/**
  A valid filesystem node name.
**/
typedef Name                          = String;

typedef PathFailure                   = stx.fail.PathFailure;

typedef AddressDef                    = stx.fs.path.pack.Address.AddressDef;
/**
  A representation of the location of any filesystem resource.
**/
typedef Address                       = stx.fs.path.pack.Address;
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
typedef RawDef = Array<Token>;
typedef Raw    = stx.fs.path.pack.Raw;
/**
 * A description of `Move`s between a `Stem` and a filesystem resource.
**/
typedef RouteDef                      = stx.fs.path.pack.Route.RouteDef;
typedef Route                         = stx.fs.path.pack.Route;

typedef Separator                     = stx.fs.path.pack.Separator;

/**
 * Represents the root of a volume, whether named or not.
**/
enum StemDef{
  Here;
  Root(drive:Drive);
}
typedef Stem                          = StemDef;

/**
  * A normalized, unidirectional description of moves between a `Stem` and a filesystem resource. 
**/
typedef TrackDef                      = stx.fs.path.pack.Track.TrackDef;
typedef Track                         = stx.fs.path.pack.Track;

typedef AttachmentDef                 = stx.fs.path.pack.Attachment.AttachmentDef;
typedef Attachment                    = stx.fs.path.pack.Attachment;


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