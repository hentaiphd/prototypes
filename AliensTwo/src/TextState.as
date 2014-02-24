package
{
    import org.flixel.*;

    public class TextState extends TimedState{
        [Embed(source="../assets/glass.mp3")] private var GlassSound:Class;
        public var _text:String;
        public var nextState:FlxState;
        public var ending:String;

        public function TextState(_text:String, end:String) {
            super();
            this._text = _text;
            //this.nextState = next;
            ending = end;
            FlxG.bgColor = 0xff000000;
        }

        override public function create():void
        {
            endTime = 4;

            if(ending == "end 1"){
                FlxG.play(GlassSound);
            }

            var t:FlxText;
            t = new FlxText(0,FlxG.height/2-10,FlxG.width,_text);
            t.size = 16;
            if(ending == "end 2"){
                t.size = 12;
            }
            t.alignment = "center";
            add(t);
        }

        override public function update():void
        {
            super.update();
        }

        override public function endCallback():void {
            if(ending == "end 1"){
                FlxG.switchState(new TextState("You stuffed 0 bulbs.","end 2"));
            } else if (ending == "end 2"){
                FlxG.switchState(new MenuState());
            } else if(ending == "nope"){
                FlxG.switchState(new PlayState());
            }

        }
    }
}
