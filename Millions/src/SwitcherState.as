package
{
    import org.flixel.*;

    public class SwitcherState extends TimedState{
        public var _text:String;
        public var nextState:FlxState;
        public var bg_sprite:FlxSprite;
        public var timer:Number;

        public function SwitcherState(_text:String, next:FlxState, timing:Number) {
            super();
            this._text = _text;
            this.nextState = next;
            timer = timing;
        }

        override public function create():void
        {
            FlxG.bgColor = 0xFFFFFFFF;
            endTime = timer;

            var t:FlxText;
            t = new FlxText(0,FlxG.height/2-10,FlxG.width,_text);
            t.size = 16;
            t.color = 0x00000000;
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