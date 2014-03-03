package{
    import org.flixel.*;

    public class NPC extends FlxSprite{
        [Embed(source = '../assets/boy.png')] public static var sprite_b:Class;
        [Embed(source = '../assets/girl.png')] public static var sprite_g:Class;

        public function NPC(x:Number, y:Number):void{
            super(x,y);
            loadGraphic(sprite_b, true, true, 14, 16, true);
        }


        override public function update():void{
            super.update();
        }
    }
}
