package{
    import org.flixel.*;

    public class ChatBox extends FlxSprite{

        public function ChatBox(x:Number, y:Number):void{
            super(x,y);
            makeGraphic(250,50,0x50000000);
        }


        override public function update():void{
            super.update();
        }
    }
}

