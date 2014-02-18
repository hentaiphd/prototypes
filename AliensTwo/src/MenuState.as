package{
    import org.flixel.*;

    public class MenuState extends FlxState{

        override public function create():void{
            FlxG.mouse.hide();

            var t:FlxText;
            t = new FlxText(0,0,100,"SPACE to play");
            t.alignment = "center";
            add(t);
        }

        override public function update():void{
            super.update();

            if(FlxG.keys.SPACE){
                FlxG.switchState(new PlayState());
            }
        }
    }
}
