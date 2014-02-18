package
{
    import org.flixel.*;

    public class Bulb extends FlxSprite{
        public var colors:Array = [0xffB45ED3,0xff5E81D3,0xff5ED375,0xffFCDB00];
        public var table:FlxSprite;
        public var held:Boolean = false;
        public var stuffing:Number = 0;

        public function Bulb(t:FlxSprite):void{
            table = t;
            var randx:Number = Math.random()*(table.x+table.width);
            var randy:Number = Math.random()*150;
            super(randx,randy)

            var c_rand:Number = Math.floor(Math.random()*colors.length);
            this.color = colors[c_rand];
            this.makeGraphic(10,10);
        }

        override public function update():void{
            super.update();
            borderCollide();
            acceleration.y = 100;

            if(this.held == true){
                carrying();
            }

            if(FlxG.mouse.pressed() == false){
                this.held = false;
            }
        }

        public function carry():void{
            this.held = true;
        }

        public function carrying():void{
            var m:FlxPoint = new FlxPoint(FlxG.mouse.x,FlxG.mouse.y);
            var p:FlxPoint = new FlxPoint(this.x,this.y);

            if(FlxU.getDistance(m,p) < 100){
                acceleration.y = 0;
                this.x = FlxG.mouse.x;
                this.y = FlxG.mouse.y;
            }
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