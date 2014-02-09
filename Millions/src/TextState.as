package
{
    import org.flixel.*;

    public class TextState extends TimedState{
        public var _text:String;
        public var nextState:FlxState;
        public var timer:Number;

        public function TextState(_text:String, next:FlxState) {
            super();
            this._text = _text;
            this.nextState = next;
        }

        override public function create():void
        {
            FlxG.bgColor = 0x00000000;
            endTime = timer;

            var t:FlxText;
            t = new FlxText(0,FlxG.height/2-10,FlxG.width,_text);
            t.size = 16;
            t.alignment = "center";
            add(t);

            var c:FlxText;
            c = new FlxText(0,FlxG.height/2+100,FlxG.width,"Press the UP arrow to try again!");
            c.size = 16;
            c.alignment = "center";
            add(c);
        }

        override public function update():void
        {
            super.update();

            if(FlxG.keys.UP){
                FlxG.switchState(new PlayState());
            }
        }


    }
}