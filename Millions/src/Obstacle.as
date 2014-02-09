package{
    import org.flixel.*;

    public class Obstacle extends FlxSprite{
        [Embed(source = '../assets/hamster.gif')] public static var sprite:Class;

        public var runSpeed:Number = .05;

        public function Obstacle(x:Number, y:Number):void{
            super(x,y);
            loadGraphic(sprite, false, false, 21, 25);
            this.scale.x = .5;
            this.scale.y = .5;
        }

        override public function update():void{
            super.update();

        }
    }
}