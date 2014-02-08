package
{
    import org.flixel.*;

    public class TextState extends TimedState{
        public var _text:String;
        public var nextState:FlxState;
        public var timer:Number;

        public function TextState(_text:String, next:FlxState, timing:Number) {
            super();
            this._text = _text;
            this.nextState = next;
            timer = timing;
        }

        override public function create():void
        {
            endTime = timer;

            var t:FlxText;
            t = new FlxText(0,FlxG.height/2-10,FlxG.width,_text);
            t.size = 10;
            t.alignment = "center";
            add(t);
        }

        override public function update():void
        {
            super.update();
        }

        override public function endCallback():void {
            FlxG.switchState(nextState);
        }
    }
}