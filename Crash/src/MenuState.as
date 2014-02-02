package{
    import org.flixel.*;

    public class MenuState extends FlxState{

        override public function create():void{

            var t:FlxText;
            t = new FlxText(FlxG.width-85,FlxG.height/2+20,100,"J to play");
            t.alignment = "center";
            t.color = 0xf9d0b4;
            add(t);

            FlxG.bgColor = 0xff783629;
        }

        override public function update():void{
            super.update();

            if(FlxG.keys.J){
                FlxG.switchState(new PlayState());
            }
        }
    }
}
