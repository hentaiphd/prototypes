package
{
    import org.flixel.*;

    public class Potpourri extends FlxSprite{
        public var table:FlxSprite;

        public function Potpourri(t:FlxSprite):void{
            table = t;
            var rand:Number = table.x+(Math.random()*(table.width/2));
            super(rand,30);
            this.solid = true;
            this.makeGraphic(1,1);
            //FlxG.state.add(p);
        }

        override public function update():void{
            super.update();
            borderCollide();

            acceleration.x = 0;
            acceleration.y = 1000;

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