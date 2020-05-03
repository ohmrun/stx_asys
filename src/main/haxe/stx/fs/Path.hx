package stx.fs;

class Path{
  static public function parse(str:String):Attempt<HasDevice,Raw,PathFailure>{
    return Attempt.fromFun1Res(
      (env:HasDevice) -> 
        env.device.distro.is_windows().if_else(
          () -> new Windows().asBase(),
          () -> new Posix().asBase()
        ).parse(str.reader())
         .fold(
          (a)     -> __.success(a.with),
          (e)     -> __.failure(__.fault().of(ParseFailed(MalformedSource(e))))    
        )
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
typedef DriveDef                      = stx.core.pack.Option<String>;
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

typedef PathFailure                   = stx.fs.path.pack.PathFailure;

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


