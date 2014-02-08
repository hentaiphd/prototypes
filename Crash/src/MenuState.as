package{
    import org.flixel.*;

    public class MenuState extends FlxState
    {
        [Embed(source="../assets/bg.png")] private var Bg:Class;
        [Embed(source = "../assets/ocean.mp3")] private var BGM:Class;
        public var bg_sprite:FlxSprite;

        override public function create():void
        {

            bg_sprite = new FlxSprite(0,0);
            bg_sprite.loadGraphic(Bg,false,false,532,432);
            FlxG.state.add(bg_sprite);

            var t:FlxText;
            t = new FlxText(0,FlxG.height/2-50,FlxG.width,"tap SPACE to swim and catch a wave");
            t.size = 16;
            t.alignment = "center";
            add(t);

            var t2:FlxText;
            t2 = new FlxText(0,FlxG.height/2-10,FlxG.width,"but don't get crushed!");
            t2.size = 16;
            t2.alignment = "center";
            add(t2);

            FlxG.playMusic(BGM, 1);
        }

        override public function update():void{
            super.update();

            if(FlxG.keys.SPACE){
                FlxG.switchState(new PlayState());
            }
        }
    }
}
