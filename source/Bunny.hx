package;

import flixel.FlxSprite;
import flixel.FlxObject;
import flixel.FlxG;

class Bunny extends FlxSprite
{
    public function new()
    {
        super();

        loadGraphic(AssetPaths.bunny__png, true, 32, 32);
        animation.add("idle", [0], 1, true);
        animation.add("run", [1,2,3,4,5,6], 6, true);
        animation.add("jump", [8,8,9,9,10,10,11,11,12,12,13,13,11,11,14], 16, false);
        width = 8;
        height = 19;
        offset.set(13, 13);

        acceleration.set(0, 192);
    }

    override function update(dt:Float)
    {
        var dir = 0;
        if(FlxG.keys.anyPressed([LEFT, A]))
            dir--;
        if(FlxG.keys.anyPressed([RIGHT, D]))
            dir++;

        velocity.x = dir * 64;
        if(FlxG.keys.justPressed.SPACE && isTouching(FlxObject.FLOOR))
        {
            if(Reg.JUMPS_LEFT > 0)
            {
                velocity.y = -96;
                animation.play("jump");
                FlxG.sound.play(AssetPaths.jump__wav);

                Reg.JUMPS_LEFT--;
                FlxG.save.data.a = Reg.JUMPS_LEFT;
                FlxG.save.data.x = x;
                FlxG.save.data.y = y;
		        FlxG.save.flush();
            }
            else
            {
                FlxG.switchState(new WorkState());
            }
        }

        if(!isTouching(FlxObject.FLOOR))
        {
            if(animation.name != "jump")
            {
                animation.play("jump", false, false, 2);
            }
        }
        else if(velocity.y >= 0)
        {
            animation.play(dir != 0 ? "run" : "idle");
            if(justTouched(FlxObject.FLOOR))
            {
                animation.curAnim.curFrame = 4;
                FlxG.save.data.x = x;
                FlxG.save.data.y = y;
                FlxG.save.flush();
            }
        }

        if(dir != 0)
            flipX = velocity.x < 0;

        super.update(dt);
    }
}