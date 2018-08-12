package;

import flixel.FlxState;
import flixel.text.FlxBitmapText;
import flixel.graphics.frames.FlxBitmapFont;
import flixel.FlxG;

class PlayState extends FlxState
{
	var level:Level;
	var jumps_left_txt:FlxBitmapText;
	var carrots_left_txt:FlxBitmapText;
	var won_txt:FlxBitmapText;

	override public function create():Void
	{
		super.create();

		if(FlxG.sound.music != null && FlxG.sound.music.playing)
			FlxG.sound.music.play();
		else
			FlxG.sound.playMusic(AssetPaths.bgm__ogg, 1, true);

		level = new Level();
		add(level);

		var zoom = FlxG.camera.zoom = 4;
		FlxG.camera.bgColor = 0xff5fcde4;
		FlxG.camera.follow(level.player, LOCKON, 0.05);
		FlxG.camera.snapToTarget();

		FlxG.mouse.visible = false;

		if(FlxG.save.data.a != null)
			Reg.JUMPS_LEFT = FlxG.save.data.a;
		if(FlxG.save.data.c != null)
			Reg.CARROTS = FlxG.save.data.c;

        jumps_left_txt = new FlxBitmapText(FlxBitmapFont.fromAngelCode(AssetPaths.m3x6__png, AssetPaths.m3x6__fnt));
		jumps_left_txt.scrollFactor.set(0, 0);
		jumps_left_txt.text = "Jumps Left: " + Reg.JUMPS_LEFT;
		jumps_left_txt.x = FlxG.width * 0.5 - FlxG.width / (zoom * 2) + 2;
		jumps_left_txt.y = FlxG.height * 0.5 - FlxG.height / (zoom * 2) + 2;
		jumps_left_txt.origin.set(0,0);
		jumps_left_txt.scale.set(0.5,0.5);
		jumps_left_txt.autoSize = false;
		jumps_left_txt.fieldWidth = 160;
		jumps_left_txt.alignment = "left";
		jumps_left_txt.offset.set(jumps_left_txt.width / 4, jumps_left_txt.height / 4);
		jumps_left_txt.setBorderStyle(SHADOW, 0xff5fcde4, 0.5, 1);
		add(jumps_left_txt);

        carrots_left_txt = new FlxBitmapText(FlxBitmapFont.fromAngelCode(AssetPaths.m3x6__png, AssetPaths.m3x6__fnt));
		carrots_left_txt.scrollFactor.set(0, 0);
		carrots_left_txt.text = "Carrots: " + Reg.CARROTS;
		carrots_left_txt.x = FlxG.width * 0.5 - FlxG.width / (zoom * 2) + 2;
		carrots_left_txt.y = FlxG.height * 0.5 - FlxG.height / (zoom * 2) + 8;
		carrots_left_txt.origin.set(0,0);
		carrots_left_txt.scale.set(0.5,0.5);
		carrots_left_txt.offset.set(carrots_left_txt.width / 4, carrots_left_txt.height / 4);
		carrots_left_txt.setBorderStyle(SHADOW, 0xff5fcde4, 0.5, 1);
		add(carrots_left_txt);

        won_txt = new FlxBitmapText(FlxBitmapFont.fromAngelCode(AssetPaths.m3x6__png, AssetPaths.m3x6__fnt));
		won_txt.scrollFactor.set(0, 0);
		won_txt.text = "You might have won the game. But at what cost?";
		won_txt.x = FlxG.width * 0.5 - FlxG.width / (zoom * 2) + 2;
		won_txt.y = FlxG.height * 0.5 + FlxG.height / (zoom * 2) - 4;
		won_txt.origin.set(0,0);
		won_txt.scale.set(0.5,0.5);
		won_txt.offset.set(won_txt.width / 4, won_txt.height / 4);
		won_txt.visible = false;
		add(won_txt);
	}

	override public function update(elapsed:Float):Void
	{
		super.update(elapsed);

		jumps_left_txt.text = "Jumps Left: " + Reg.JUMPS_LEFT;
		carrots_left_txt.text = "Carrots: " + Reg.CARROTS;

		if(FlxG.keys.justPressed.TAB)
			FlxG.switchState(new WorkState());

		if(level.player.y > 1500)
			FlxG.switchState(new PlayState());

		if(Reg.WON)
		{
			won_txt.visible = true;
		}
	}
}
