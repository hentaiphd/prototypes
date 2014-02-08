package
{
    import org.flixel.*;
    [SWF(width="640", height="480", backgroundColor="#000000")]
    [Frame(factoryClass="Preloader")]

    public class Millions extends FlxGame {

        public function Millions(){
            super(640,480,MenuState,1)
        }
    }
}