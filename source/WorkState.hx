package;

import flixel.group.FlxGroup;
import flixel.text.FlxBitmapText;
import flixel.graphics.frames.FlxBitmapFont;
import flixel.FlxG;
import flixel.FlxSprite;
import flixel.ui.FlxBitmapTextButton;
import flixel.ui.FlxBar;
import flixel.FlxState;
import flixel.tweens.FlxTween;

class WorkState extends FlxState
{

    var jumps_left_txt:FlxBitmapText;
    var progress_bar:FlxBar;
    var income_rate_txt:FlxBitmapText;
    var upgrade_cost_txt:FlxBitmapText;
    var carrots_txt:FlxBitmapText;
    var upgrade_btn:FlxBitmapTextButton;
    var work_btn:FlxBitmapTextButton;
    var buy_btn:FlxBitmapTextButton;

    var work_pct:Float = 0;
    var working:Bool = false;
    var work_rate:Float = 500;

    static inline var BASE_UPGRADE_COST:Int = 100;
    static inline var BASE_JUMP_COST:Int = 200;
    var income_rate:Int = 1;
    var upgrade_cost:Int = BASE_UPGRADE_COST;
    var upgrade_level:Int = 0;


	override public function create():Void
    {
		FlxG.sound.music.pause();

        if(FlxG.save.data.u != null)
        {
            upgrade_level = FlxG.save.data.u;
            upgrade_cost = Math.ceil(BASE_UPGRADE_COST * Math.pow(1.15, upgrade_level));
            income_rate = upgrade_level + 1;
        }

		FlxG.camera.bgColor = 0xffeeeeee;
		FlxG.camera.zoom = 1;

        var txt = new FlxBitmapText(FlxBitmapFont.fromAngelCode(AssetPaths.m3x6_2x__png, AssetPaths.m3x6_2x__fnt));
		txt.text = 'You\'ve run out of jumps! You can exchange ${BASE_JUMP_COST} carrots for 1 jump, and earn carrots by using a carrot generator!';
        txt.x = FlxG.width / 2;
        txt.y = FlxG.height / 2;
        txt.autoSize = false;
        txt.fieldWidth = 300;
        txt.alignment = "center";
        txt.color = 0xff000000;
        txt.y -= 120;
        txt.x -= 150;
		add(txt);

        txt = income_rate_txt = new FlxBitmapText(FlxBitmapFont.fromAngelCode(AssetPaths.m3x6_2x__png, AssetPaths.m3x6_2x__fnt));
		txt.text = "Income Rate: " + income_rate;
        txt.alignment = "center";
        txt.color = 0xff000000;
        txt.autoSize = false;
        txt.fieldWidth = FlxG.width;
        txt.x = 0;
        txt.y = FlxG.height / 2 + 2;
		add(txt);

        txt = upgrade_cost_txt = new FlxBitmapText(FlxBitmapFont.fromAngelCode(AssetPaths.m3x6_2x__png, AssetPaths.m3x6_2x__fnt));
		txt.text = "Upgrade Cost: " + upgrade_cost;
        txt.alignment = "center";
        txt.color = 0xff000000;
        txt.autoSize = false;
        txt.fieldWidth = FlxG.width;
        txt.x = 0;
        txt.y = FlxG.height / 2 + 26;
		add(txt);

        txt = jumps_left_txt = new FlxBitmapText(FlxBitmapFont.fromAngelCode(AssetPaths.m3x6_2x__png, AssetPaths.m3x6_2x__fnt));
		txt.text = "Jumps Left: " + Reg.JUMPS_LEFT;
        txt.x = 8;
        txt.y = 8;
        txt.alignment = "center";
        txt.color = 0xff000000;
		add(txt);

        txt = carrots_txt = new FlxBitmapText(FlxBitmapFont.fromAngelCode(AssetPaths.m3x6_2x__png, AssetPaths.m3x6_2x__fnt));
		txt.text = "Carrots: " + Reg.CARROTS;
        txt.x = 8;
        txt.y = 32;
        txt.alignment = "center";
        txt.color = 0xff000000;
		add(txt);

        var btn = work_btn = new FlxBitmapTextButton(FlxG.width / 2 - 150, FlxG.height / 2 + 64, "Generate", work);
        btn.label.color = 0xff000000;
        btn.label.font = txt.font;
        btn.label.autoSize = false;
        btn.label.fieldWidth = 80;
        btn.scale.y = 1.2;
        for(o in btn.labelOffsets)
            o.y -= 1;
        add(btn);

        btn = buy_btn = new FlxBitmapTextButton(FlxG.width / 2 - 40, FlxG.height / 2 + 64, "Buy jump", buy);
        btn.label.color = 0xff000000;
        btn.label.font = txt.font;
        btn.label.autoSize = false;
        btn.label.fieldWidth = 80;
        btn.scale.y = 1.2;
        for(o in btn.labelOffsets)
            o.y -= 1;
        add(btn);

        upgrade_btn = btn = new FlxBitmapTextButton(FlxG.width / 2 + 150, FlxG.height / 2 + 64, "Upgrade", upgrade);
        btn.label.color = 0xff000000;
        btn.label.font = txt.font;
        btn.label.autoSize = false;
        btn.label.fieldWidth = 80;
        btn.scale.y = 1.2;
        for(o in btn.labelOffsets)
            o.y -= 1;
        btn.x -= btn.width;
        add(btn);

        progress_bar = new FlxBar(FlxG.width / 2 - 150, FlxG.height / 2 + 96, LEFT_TO_RIGHT, 300, 8, this, "work_pct");
        progress_bar.createFilledBar(0xffaaaaaa, 0xff000000, false);
        add(progress_bar);

        txt = new FlxBitmapText(FlxBitmapFont.fromAngelCode(AssetPaths.m3x6_2x__png, AssetPaths.m3x6_2x__fnt));
		txt.text = "Hit TAB to toggle this menu";
        txt.alignment = "center";
        txt.color = 0xff000000;
        txt.autoSize = false;
        txt.fieldWidth = FlxG.width;
        txt.x = 0;
        txt.y = FlxG.height - 24;
		add(txt);
    }

    function work()
    {
        working = true;
        work_pct = 0;
        work_btn.active = false;
        work_btn.alpha = 0.5;
    }

    function buy()
    {
        Reg.CARROTS -= BASE_JUMP_COST;
        Reg.JUMPS_LEFT++;

        FlxG.save.data.a = Reg.JUMPS_LEFT;
        FlxG.save.data.c = Reg.CARROTS;
        FlxG.save.flush();
        jumps_left_txt.text = "Jumps Left: " + Reg.JUMPS_LEFT;
        carrots_txt.text = "Carrots: " + Reg.CARROTS;
    }

    function upgrade()
    {
        Reg.CARROTS -= upgrade_cost;
        upgrade_level++;
        upgrade_cost = Math.ceil(BASE_UPGRADE_COST * Math.pow(1.15, upgrade_level));
        income_rate = upgrade_level + 1;
        
        carrots_txt.text = "Carrots: " + Reg.CARROTS;
        upgrade_cost_txt.text = "Upgrade Cost: " + upgrade_cost;
        income_rate_txt.text = "Income Rate: " + income_rate;
        
        FlxG.save.data.c = Reg.CARROTS;
        FlxG.save.data.u = upgrade_level;
    }

    override function update(dt:Float)
    {
        super.update(dt);

        if(working)
        {
            work_pct += work_rate / FlxG.updateFramerate;
            if(work_pct >= 100)
            {
                working = false;
                Reg.CARROTS += income_rate;

                FlxG.save.data.a = Reg.JUMPS_LEFT;
                FlxG.save.data.c = Reg.CARROTS;
                FlxG.save.flush();
                jumps_left_txt.text = "Jumps Left: " + Reg.JUMPS_LEFT;
                carrots_txt.text = "Carrots: " + Reg.CARROTS;
                
                work_btn.active = true;
                work_btn.alpha = 1;
            }
        }

        if(Reg.CARROTS >= upgrade_cost)
        {
            upgrade_btn.active = true;
            upgrade_btn.alpha = 1;
        }
        else
        {
            upgrade_btn.active = false;
            upgrade_btn.alpha = 0.5;
        }

        if(Reg.CARROTS >= BASE_JUMP_COST)
        {
            buy_btn.active = true;
            buy_btn.alpha = 1;
        }
        else
        {
            buy_btn.active = false;
            buy_btn.alpha = 0.5;
        }

		if(FlxG.keys.justPressed.TAB)
			FlxG.switchState(new PlayState());
    }
}