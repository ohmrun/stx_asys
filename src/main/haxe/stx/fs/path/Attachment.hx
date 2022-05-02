package stx.fs.path;

typedef AttachmentDef = {
  var entry : Entry;
  var track : Route;
}
/**
  A headless path to a file.
**/
@:forward abstract Attachment(AttachmentDef) from AttachmentDef to AttachmentDef{
  public function new(self) this = self;
  @:noUsing static public function lift(self:AttachmentDef):Attachment return new Attachment(self);
  @:noUsing static public function make(entry:Entry,route:Route):Attachment{
    return lift({
      entry : entry,
      track : route
    });
  }
  @:from static public function fromEntry(entry:Entry):Attachment{
    return make(entry,Route.unit());
  }

  public function prj():AttachmentDef return this;
  private var self(get,never):Attachment;
  private function get_self():Attachment return lift(this);
}