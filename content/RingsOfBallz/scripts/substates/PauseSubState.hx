import funkin.states.options.OptionsState;
import funkin.states.PlayState;
import funkin.states.MainMenuState;
import funkin.states.StoryMenuState;
import funkin.states.FreeplayState;
import funkin.utils.CoolUtil;
import funkin.FunkinAssets;
import flixel.group.FlxGroup.FlxTypedGroup;
import flixel.FlxG;
import flixel.FlxSprite;
import flixel.text.FlxText;

var sideBar:FlxSprite;
var upperBar:FlxSprite;
var lowerBar:FlxSprite;
var menuGroup:FlxTypedGroup<FlxSprite>;
var songInfoTxt:FlxText;
var pausedTxt:FlxText;
var zoneTxt:FlxText;
var customIndex:Int = 0;

final options:Array<String> = ['resume', 'restart', 'options', 'exit'];

function onCreatePost()
{
	if (grpMenuShit != null)
	{
		grpMenuShit.visible = false;
	}
	if (cornerTexts != null)
	{
		for (t in cornerTexts) t.visible = false;
	}
	menuItemsOG = ['Resume', 'Restart Song', 'Options', 'Exit to menu'];
	menuItems = menuItemsOG;
	regenMenu();
	if (grpMenuShit != null) grpMenuShit.visible = false;

	menuGroup = new FlxTypedGroup();

	sideBar = new FlxSprite().loadGraphic(Paths.image('menus/pauseStuff/SideBar'));
	sideBar.antialiasing = ClientPrefs.globalAntialiasing;
	sideBar.scrollFactor.set();
	add(sideBar);

	upperBar = new FlxSprite().loadGraphic(Paths.image('menus/pauseStuff/UpperBar'));
	upperBar.antialiasing = ClientPrefs.globalAntialiasing;
	upperBar.scrollFactor.set();
	add(upperBar);

	lowerBar = new FlxSprite().loadGraphic(Paths.image('menus/pauseStuff/LowerBar'));
	lowerBar.antialiasing = ClientPrefs.globalAntialiasing;
	lowerBar.scrollFactor.set();
	add(lowerBar);

	for (i in 0...options.length)
	{
		final spacing = 115;
		final startY = 135;
		final yPos = (i * spacing) + startY - ((options.length - 4) * (spacing / 2));

		final item = new FlxSprite(683, yPos);
		item.frames = Paths.getSparrowAtlas('menus/pauseStuff/' + options[i]);
		item.animation.addByPrefix('idle', "idle", 24, true);
		item.animation.addByPrefix('selected', "selected", 24, true);
		item.antialiasing = true;
		item.scrollFactor.set();
		item.updateHitbox();
		item.ID = i;
		menuGroup.add(item);
	}
	add(menuGroup);

	final pixelFont = Paths.font("PressStart2P.ttf");
	final songName = PlayState.SONG != null ? PlayState.SONG.song : "Unknown";
	final songDisplayName = StringTools.replace(songName, "-", " ").toUpperCase(); 

	songInfoTxt = new FlxText(28, 20, FlxG.width, songDisplayName + "\nBlueballed: " + PlayState.deathCounter);
	songInfoTxt.setFormat(pixelFont, 28, 0xFFFFFFFF, "left");
	songInfoTxt.antialiasing = false;
	songInfoTxt.scrollFactor.set();
	add(songInfoTxt);

	pausedTxt = new FlxText(180, 578, 220, "PAUSED");
	pausedTxt.setFormat(pixelFont, 28, 0xFFFFFFFF, "center");
	pausedTxt.antialiasing = false;
	pausedTxt.scrollFactor.set();
	add(pausedTxt);

	final raw = songName.toLowerCase();
	var stageName = "Unknown Zone";
	switch (raw)
	{
		case "bloodnight":
			stageName = "Crystal Lake Zone";
		case "shadow-of-divinity" | "shadow-of-divinity-legacy" | "infinite-torment":
			stageName = "Green Hill Zone";
		case "sussus-hillus" | "sussus-hillus-legacy":
			stageName = "The Fungle Map";
	}

	zoneTxt = new FlxText(28, 668, FlxG.width, stageName);
	zoneTxt.setFormat(pixelFont, 32, 0xFFFFFFFF, "left");
	zoneTxt.antialiasing = false;
	zoneTxt.scrollFactor.set();
	add(zoneTxt);

	customIndex = curSelected;
	updateMenuSprites();
}

function onChangeSelection(sel:Int)
{
	customIndex = sel;
	updateMenuSprites();
	FlxG.sound.play(Paths.sound("scrollMenu"));
	return ScriptConstants.STOP_FUNC; // skip default alphabet + extra scroll sound
}

function updateMenuSprites()
{
	if (menuGroup == null) return;

	for (item in menuGroup.members)
	{
		if (item.ID == customIndex)
		{
			item.animation.play('selected', true);
			item.alpha = 1;
		}
		else
		{
			item.animation.play('idle', true);
			item.alpha = 0.6;
		}
	}
}