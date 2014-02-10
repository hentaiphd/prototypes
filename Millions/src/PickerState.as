package{
    import org.flixel.*;

    public class PickerState extends FlxState{
        public var player:String;

        public function PickerState(p:String){
            super();
            player = p;
        }

        override public function create():void{
            FlxG.bgColor = 0xFFFFFFFF;

            var t2:FlxText;
            t2 = new FlxText(0,FlxG.height/2,FlxG.width,"You just got a booty call! Who was it from?!\nLEFT if girl, RIGHT if boy");
            t2.alignment = "center";
            t2.color = 0x00000000;
            t2.size = 16;
            add(t2);

            FlxG.mouse.hide();

        }

        override public function update():void{
            super.update();

            if(player == "girl"){
                if(FlxG.keys.LEFT){
                    FlxG.switchState(new SwitcherState("She's waiting for you!!\nRace to the booty call!!!!", new PlayState("girl","girl"),3));
                }
                if(FlxG.keys.RIGHT){
                    FlxG.switchState(new SwitcherState("He's waiting for you!!\nRace to the booty call!!!!", new PlayState("girl","boy"),3));
                }
            }

            if(player == "boy"){
                if(FlxG.keys.LEFT){
                    FlxG.switchState(new SwitcherState("She's waiting for you!!\nRace to the booty call!!!!", new PlayState("boy","girl"),3));
                }
                if(FlxG.keys.RIGHT){
                    FlxG.switchState(new SwitcherState("He's waiting for you!!\nRace to the booty call!!!!", new PlayState("boy","boy"),3));
                }
            }
        }
    }
}