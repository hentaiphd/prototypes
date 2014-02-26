package{
    import org.flixel.*;

    public class Health extends FlxSprite{

        public function Health(x:Number, y:Number):void{
            super(x,y);
            makeGraphic(10,50,0x50000000);
        }


        override public function update():void{
            super.update();
        }
    }
}
