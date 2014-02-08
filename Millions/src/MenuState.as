package{
    import org.flixel.*;

    public class MenuState extends FlxState{
        [Embed(source="../assets/start.png")] private var ImgBG:Class;

        override public function create():void{
            var bg:FlxSprite = new FlxSprite(0, 0, ImgBG);
            add(bg);

            var t2:FlxText;
            t2 = new FlxText(0,FlxG.height-40,FlxG.width,"SPACE to play");
            t2.alignment = "center";
            t2.color = 0xff2d686b;
            t2.size = 16;
            add(t2);

            FlxG.mouse.hide();

        }

        override public function update():void{
            super.update();

            if(FlxG.keys.SPACE){
                FlxG.switchState(new PlayState());
            }
        }
    }
}
