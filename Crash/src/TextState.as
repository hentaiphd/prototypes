package
{
    import org.flixel.*;

    public class TextState extends TimedState{
        public var _text:String;
        public var nextState:FlxState;
        public var bg_sprite:FlxSprite;
        [Embed(source="../assets/bg.png")] private var Bg:Class;

        public function TextState(_text:String, next:FlxState) {
            super();
            this._text = _text;
            this.nextState = next;
        }

        override public function create():void
        {

            bg_sprite = new FlxSprite(0,0);
            bg_sprite.loadGraphic(Bg,false,false,532,432);
            FlxG.state.add(bg_sprite);

            endTime = 1;

            var t:FlxText;
            t = new FlxText(0,FlxG.height/2-10,FlxG.width,_text);
            t.size = 16;
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