package
{
    import org.flixel.*;

    public class DHPoint extends FlxPoint
    {
        public function DHPoint(x:Number, y:Number)
        {
            super(x, y);
        }

        public function normalized():DHPoint
        {
            return new DHPoint(this.x/this._length(),
                               this.y/this._length());
        }

        public function _length():Number
        {
            return Math.sqrt(this.x*this.x + this.y*this.y)
        }
    }
}
