package
{
    import org.flixel.*;

    public class Bulb extends FlxSprite{
        [Embed(source="../assets/bulb1.png")] private var Bulb1:Class;
        [Embed(source="../assets/bulb2.png")] private var Bulb2:Class;
        [Embed(source="../assets/bulb3.png")] private var Bulb3:Class;

        [Embed(source="../assets/fullbulb1.png")] private var FullBulb1:Class;
        [Embed(source="../assets/fullbulb2.png")] private var FullBulb2:Class;
        [Embed(source="../assets/fullbulb3.png")] private var FullBulb3:Class;

        public var colors:Array = [0xffB45ED3,0xff5E81D3,0xff5ED375,0xffFCDB00];
        public var table:FlxSprite;
        public var held:Boolean = true;
        public var stuffing:Number = 0;

        public var img:Array = [Bulb1,Bulb2,Bulb3];
        public var img_full:Array = [FullBulb1,FullBulb2,FullBulb3];

        public function Bulb(t:FlxSprite,x:Number,y:Number):void{
            table = t;
            super(x,y)

            var i_rand:Number = Math.floor(Math.random()*2);
            this.loadGraphic(img[i_rand],false,false,10,10);
        }

        override public function update():void{
            super.update();
            borderCollide();
            acceleration.y = 100;

            if(FlxG.mouse.justReleased()){
                this.held = false;
            }
        }

        public function carrying(x:Number,y:Number):void{
            this.x = x;
            this.y = y;
        }

        public function borderCollide():void{
            if(x >= FlxG.width - width)
                x = FlxG.width - width;
            if(this.x <= 0)
                this.x = 0;
            if(this.y >= FlxG.height - height)
                this.y = FlxG.height - height;
            if(this.y <= 0)
                this.y = 0;
        }
    }
}