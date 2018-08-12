package;

import flixel.addons.editors.tiled.TiledMap;
import flixel.addons.editors.tiled.TiledTileLayer;
import flixel.addons.editors.tiled.TiledObjectLayer;
import flixel.tile.FlxTilemap;
import flixel.group.FlxGroup;
import flixel.FlxSprite;
import flixel.text.FlxBitmapText;
import flixel.graphics.frames.FlxBitmapFont;
import flixel.math.FlxPoint;
import flixel.FlxG;

class Level extends FlxGroup
{
    var tiles:FlxGroup = new FlxGroup();
    var carrots:FlxTypedGroup<Carrot> = new FlxTypedGroup();
    var tiled_map:TiledMap = new TiledMap(AssetPaths.map__tmx);
    var carrots_taken:Array<Int> = [];

    public var player:Bunny = new Bunny();

    var cloud:FlxSprite = new FlxSprite();
    var cloud_scroll_x:Float = 0;
    var cloud_origin:FlxPoint = new FlxPoint();
    var time_elapsed:Float = 0;
    var flag_x:Float;

    public function new()
    {
        super();

        if(FlxG.save.data.ct != null)
            carrots_taken = FlxG.save.data.ct;

        cloud.loadGraphic(AssetPaths.cloud__png);
        cloud.solid = false;

        add(cloud);
        add(tiles);
        add(carrots);

        for(l in tiled_map.layers)
        {
            if(l.type == TILE)
            {
                var tl:TiledTileLayer = cast l;
                var map = new FlxTilemap();
                var ts = tiled_map.getTileSet("tiles");
                map.loadMapFromArray(tl.tileArray, tiled_map.width, tiled_map.height, AssetPaths.tiles__png,
                    tiled_map.tileWidth, tiled_map.tileHeight, OFF, ts.firstGID, 1, 1);
                map.follow();
                tiles.add(map);
            }
            else if(l.type == OBJECT)
            {
                var ol:TiledObjectLayer = cast l;
                var i:Int = 0;
                for(o in ol.objects)
                {
                    if(o.type == "Player")
                    {
                        if(FlxG.save.data.x != null && FlxG.save.data.y != null)
                        {
                            player.x = FlxG.save.data.x;
                            player.y = FlxG.save.data.y;
                        }
                        else
                        {
                            player.x = o.x;
                            player.y = o.y + tiled_map.tileHeight - player.height;
                        }
                        cloud_origin.set(cloud.x = o.x, cloud.y = o.y);
                    }
                    else if(o.type == "Text")
                    {
                        var txt = new FlxBitmapText(FlxBitmapFont.fromAngelCode(AssetPaths.m3x6__png, AssetPaths.m3x6__fnt));
                        txt.text = o.name;
                        txt.x = o.x;
                        txt.y = o.y;
                        txt.solid = false;
                        txt.fieldWidth = o.width;
                        txt.autoSize = false;
                        txt.alignment = "center";
                        add(txt);
                    }
                    else if(o.width == 5 && o.height == 12)
                    {
                        if(carrots_taken.indexOf(i) == -1)
                        {
                            var carrot = new Carrot(Math.floor(o.x / tiled_map.tileWidth) * tiled_map.tileWidth + tiled_map.tileWidth / 2 - 2, 
                                Math.floor(o.y / tiled_map.tileHeight) * tiled_map.tileHeight + tiled_map.tileHeight / 2 - 6,
                                i);
                            carrots.add(carrot);
                        }
                        i++;
                    }
                    else if(o.width == 16 && o.height == 22)
                    {
                        flag_x = o.x;
                        var flag = new FlxSprite(o.x, o.y - 22, AssetPaths.flag__png);
                        add(flag);
                    }
                }
            }
        }

        add(player);
    }

    override public function update(dt:Float)
    {
        super.update(dt);
        
        FlxG.collide(player, tiles);

        if(player.x >= flag_x)
        {
            Reg.WON = true;
            FlxG.save.data.w = true;
        }

        time_elapsed += dt;

        cloud.x = cloud_origin.x + (FlxG.camera.scroll.x + FlxG.width * 0.5 - cloud_origin.x) * 0.9;
        cloud.y = cloud_origin.y - 50 + Math.sin(time_elapsed);

        FlxG.overlap(player, carrots, carrot_overlap);
    }

    function carrot_overlap(player:Bunny, carrot:Carrot)
    {
        carrots_taken.push(carrot.id);
        carrot.destroy();
        FlxG.sound.play(AssetPaths.carrot__wav);

        Reg.CARROTS++;
        FlxG.save.data.ct = carrots_taken;
        FlxG.save.data.c = Reg.CARROTS;
        FlxG.save.flush();
    }


}