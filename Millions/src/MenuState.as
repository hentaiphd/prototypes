package{
    import org.flixel.*;

    public class MenuState extends FlxState{

        override public function create():void{
            FlxG.bgColor = 0xFFFFFFFF;

            var t2:FlxText;
            t2 = new FlxText(0,FlxG.height/2,FlxG.width,"LEFT to play girl, RIGHT to play boy");
            t2.alignment = "center";
            t2.color = 0x00000000;
            t2.size = 16;
            add(t2);

            FlxG.mouse.hide();

        }

        override public function update():void{
            super.update();

            if(FlxG.keys.LEFT){
                FlxG.switchState(new PickerState("girl"));
            }
            if(FlxG.keys.RIGHT){
                FlxG.switchState(new PickerState("boy"));
            }
        }
    }
}
