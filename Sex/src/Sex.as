package
{
    import org.flixel.*;
    [SWF(width="640", height="480", backgroundColor="#000000")]
    [Frame(factoryClass="Preloader")]

    public class Sex extends FlxGame {

        public function Sex(){
            super(640,480,MenuState,1)
        }
    }
}