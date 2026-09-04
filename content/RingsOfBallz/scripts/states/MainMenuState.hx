import funkin.states.options.OptionsState as OptionsMenu;
import funkin.states.FreeplayState;
import funkin.states.CreditsState;
import funkin.states.StoryMenuState;
import flixel.effects.FlxFlicker;
import flixel.group.FlxGroup.FlxTypedGroup;
import flixel.math.FlxMath;
import funkin.FunkinAssets;

import funkin.states.StoryMenuState;
import funkin.states.options.OptionsState as OptionsMenu;
import funkin.states.FreeplayState;
import funkin.states.CreditsState;
import funkin.states.TitleState;

var options:Array<String> = CoolUtil.coolTextFile(Paths.modFolders("data/config/menuItems.txt"));
var mainBg:FlxSprite;
var bars:FlxSprite;
var menuItem:FlxSprite;
var menuItems:FlxTypedGroup<FlxSprite> = new FlxTypedGroup();
var curSelected:Int = 0;
var transitioning:Bool = false;

function onCreate()
{
	FunkinAssets.cache.clearStoredMemory();
	FunkinAssets.cache.clearUnusedMemory();

	mainBg = new FlxSprite(0, 0).loadGraphic(Paths.image('menus/mainmenu/menuBG'));
	mainBg.screenCenter();
	mainBg.antialiasing = ClientPrefs.globalAntialiasing;
	mainBg.scrollFactor.set(0, 0);
	add(mainBg);

	bars = new FlxSprite(0, 0).loadGraphic(Paths.image('menus/mainmenu/menuFrames'));
	bars.updateHitbox();
	bars.antialiasing = ClientPrefs.globalAntialiasing;
	bars.scrollFactor.set(0, 0);
	add(bars);

	for (i => eyxitems in options)
	{
		menuItem = new FlxSprite(800, (i * 120) + 95 - (Math.max(eyxitems.length, 4) - 4) * 80);
		menuItem.frames = Paths.getSparrowAtlas('menus/mainmenu/' + "menu" + eyxitems);
		menuItem.animation.addByPrefix('idle', "menu" + eyxitems + " Normal", 24, false);
		menuItem.animation.addByPrefix('selected', "menu" + eyxitems + " Selected", 24, false);
		menuItem.animation.play('idle');
		menuItem.antialiasing = ClientPrefs.globalAntialiasing;
		menuItem.scale.set(1.1, 1.1);
		menuItem.scrollFactor.set(0, 0);
		menuItem.ID = i;
		menuItems.add(menuItem);
	}
	add(menuItems);

	if (menuItems.length > 0)
	{
		changeItem(0);
	}
}

var whyyouevenneedmouse:Float = 0;
function onUpdate(elapsed:Float)
{
	if (menuItems.length > 0)
	{
		if (controls.UI_UP_P)
			changeItem(-1);
		if (controls.UI_DOWN_P)
			changeItem(1);

		if (controls.ACCEPT)
			selectItem();

    #if mobile
  for (i in 0...menuItems.length) {
      if (FlxG.mouse.overlaps(menuItems.members[i])) {
                if (curSelected != i) {
                    curSelected = i;
                    changeItem(0);
                }
      }
  }
    if (FlxG.mouse.justPressed) selectItem();
    #end

	if (controls.BACK)
		FlxG.switchState(new TitleState());
  }
}
  
function changeItem(huh:Int)
{
	if (menuItems.length == 0 || transitioning)
		return;

	curSelected = FlxMath.wrap(curSelected + huh, 0, menuItems.length - 1);

	FlxG.sound.play(Paths.sound("scrollMenu"));

	menuItems.forEach(function(spr:FlxSprite)
	{
		spr.animation.play('idle');

		if (spr.ID == curSelected)
		{
			spr.animation.play('selected');
			var mid = spr.getGraphicMidpoint();
			mid.put();
		}

		spr.updateHitbox();
		spr.centerOffsets();
	});
}

function selectItem()
{
	if (menuItems.length == 0 || transitioning)
		return;

	FlxG.sound.play(Paths.sound("confirmMenu"));

	transitioning = true;

	FlxFlicker.flicker(menuItems.members[curSelected], 1, ClientPrefs.flashing ? 0.06 : 0.15, false, false, (flick:FlxFlicker) ->
	{
		var daChoice:String = options[curSelected];

		switch (daChoice)
		{
			case 'sm': FlxG.switchState(new StoryMenuState());
			case 'fr': FlxG.switchState(new FreeplayState());
			case 'cr': FlxG.switchState(new CreditsState());
			case 'st':
				FlxG.switchState(new OptionsMenu());
				OptionsMenu.onPlayState = false;
		}
	});
}
