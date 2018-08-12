package;

import flixel.FlxSprite;

class Carrot extends FlxSprite
{
    public var id:Int;

    public function new(x:Float, y:Float, id:Int)
    {
        super(x, y, AssetPaths.carrot__png);

        this.id = id;
    }
}