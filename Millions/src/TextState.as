package
{
    import org.flixel.*;

    public class TextState extends TimedState{
        [Embed(source = '../assets/boy.png')] public static var sprite_b:Class;
        [Embed(source = '../assets/girl.png')] public static var sprite_g:Class;

        public var _text:String;
        public var nextState:FlxState;
        public var timer:Number;
        public var player:String;
        public var caller:String;
        public var p_sprite:FlxSprite;
        public var c_sprite:FlxSprite;
        public var _scale:FlxPoint = new FlxPoint(3,3);
        public var neg_scale:FlxPoint = new FlxPoint(-3,3);
        public var p_start:Number = (FlxG.width/2)-40;
        public var c_start:Number = (FlxG.width/2)-10;

        public function TextState(_text:String, next:FlxState, p:String, c:String) {
            super();
            this._text = _text;
            this.nextState = next;

            player = p;
            caller = c;
        }

        override public function create():void
        {
            FlxG.bgColor = 0xFFFFFFFF;
            endTime = timer;

            p_sprite = new FlxSprite((FlxG.width/2)-40,(FlxG.height/2)-100);
            c_sprite = new FlxSprite((FlxG.width/2)-10,(FlxG.height/2)-100);

            if(player == "boy"){
                p_sprite.loadGraphic(sprite_b, true, true, 14, 16, true);
                if(caller == "girl"){
                    c_sprite.loadGraphic(sprite_g, true, true, 14, 16, true);
                }
                if(caller == "boy"){
                    c_sprite.loadGraphic(sprite_b, true, true, 14, 16, true);
                }
            }
            if(player == "girl"){
                p_sprite.loadGraphic(sprite_g, true, true, 14, 16, true);
                if(caller == "girl"){
                    c_sprite.loadGraphic(sprite_g, true, true, 14, 16, true);
                }
                if(caller == "boy"){
                    c_sprite.loadGraphic(sprite_b, true, true, 14, 16, true);
                }
            }

            p_sprite.scale = neg_scale;
            c_sprite.scale = _scale;

            p_sprite.addAnimation("runBack", [2,3], 14, true);
            c_sprite.addAnimation("runBack", [2,3], 14, true);

            add(p_sprite);
            add(c_sprite);

            p_sprite.play("runBack");
            c_sprite.play("runBack");

            var t:FlxText;
            t = new FlxText(0,FlxG.height/2-10,FlxG.width,_text);
            t.size = 16;
            t.alignment = "center";
            t.color = 0x00000000;
            add(t);

            var c:FlxText;
            c = new FlxText(0,FlxG.height/2+100,FlxG.width,"Press the UP arrow to try again!");
            c.size = 16;
            c.alignment = "center";
            c.color = 0x00000000;
            add(c);
        }

        override public function update():void
        {
            super.update();

            if(p_sprite.x < p_start+3){
                p_sprite.x += 1;
            } else {
                p_sprite.x -= 1;
            }

            if(c_sprite.x > c_start-3){
                c_sprite.x -= 1;
            } else {
                c_sprite.x += 1;
            }

            if(FlxG.keys.UP){
                FlxG.switchState(new MenuState());
            }
        }


    }
}