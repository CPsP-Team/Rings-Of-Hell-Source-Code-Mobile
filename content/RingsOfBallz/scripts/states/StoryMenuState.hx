import funkin.states.MainMenuState;
import funkin.states.PlayState;
import funkin.input.Controls;
import funkin.utils.CoolUtil;
import funkin.FunkinAssets;

var eyx:FlxSprite;
var bg:FlxSprite;
var weeksbox:FlxSprite;
var sprDifficulty:FlxSprite;
var leftArrow:FlxSprite;
var rightArrow:FlxSprite;
var storybox:FlxSprite;
var back:FlxSprite;

var selection:Bool = false;
var songArray:Array<String> = ['bloodnight'];
var diffs:Array<String> = ['easy', 'normal', 'hard'];
var curDifficulty:Int = 2;

var menuText:FlxText;
var storyText:FlxText;
var listText:FlxText;
var songList:FlxText;

function onLoad()
{
	persistentUpdate = true;
	persistentDraw = true;
}

function onCreate()
{
    FunkinAssets.cache.clearStoredMemory();
	FunkinAssets.cache.clearUnusedMemory();

	if (FlxG.save.data.storyProgress == null)
		FlxG.save.data.storyProgress = 0;

	songArray = ['bloodnight'];

	if (FlxG.sound.music == null || !FlxG.sound.music.playing)
		FlxG.sound.playMusic(Paths.music('TheAmogusFunk'), 0.5, true);

	bg = new FlxSprite().loadGraphic(Paths.image('menus/storymenu/eyx-bg'));
	bg.antialiasing = true;
	bg.scale.set(0.325, 0.325);
	bg.updateHitbox();
	add(bg);

	eyx = new FlxSprite(0, -60).loadGraphic(Paths.image('menus/storymenu/EYX_Render'));
	eyx.scale.set(0.38, 0.38);
	eyx.updateHitbox();
	eyx.antialiasing = ClientPrefs.globalAntialiasing;
	add(eyx);

	storybox = new FlxSprite().loadGraphic(Paths.image('menus/storymenu/menubox'));
	storybox.antialiasing = ClientPrefs.globalAntialiasing;
	storybox.scale.set(0.25, 0.25);
	storybox.updateHitbox();
	storybox.alpha = 0.75;
	add(storybox);

	weeksbox = new FlxSprite(-50, 0).loadGraphic(Paths.image('menus/storymenu/weekbox'));
	weeksbox.antialiasing = ClientPrefs.globalAntialiasing;
	weeksbox.scale.set(0.325, 0.325);
	weeksbox.updateHitbox();
	weeksbox.alpha = 0.75;
	add(weeksbox);

	menuText = new FlxText(storybox.x + 25, storybox.y + 10, 0, "Story Mode", 20);
	menuText.setFormat(Paths.font("sonic-cd-menu-font.ttf"), 20, 0xFFFFFFFF, "left");
	add(menuText);

	storyText = new FlxText(900, 50, 0, "Chaotic Execution", 24);
	storyText.setFormat(Paths.font("sonic-cd-menu-font.ttf"), 24, 0xFFFFFFFF, "right");
	add(storyText);

	listText = new FlxText(1125, 105, 0, "Includes", 16);
	listText.setFormat(Paths.font("sonic-cd-menu-font.ttf"), 16, 0xFFFFFFFF, "right");
	add(listText);

	songList = new FlxText(1100, 140, 0, songArray.join("\n"), 16);
	songList.setFormat(Paths.font("sonic-cd-menu-font.ttf"), 16, 0xFFFF0000, "right");
	add(songList);

	leftArrow = new FlxSprite(1025 - 150, 500);
	leftArrow.frames = Paths.getSparrowAtlas('menus/storymenu/campaign_menu_UI_assets');
	leftArrow.setGraphicSize(Std.int(leftArrow.width * 0.8));
	leftArrow.animation.addByPrefix('idle', "arrow left");
	leftArrow.animation.addByPrefix('press', "arrow push left");
	leftArrow.animation.play('idle');
	add(leftArrow);

	rightArrow = new FlxSprite(1025 + 180, 500);
	rightArrow.frames = Paths.getSparrowAtlas('menus/storymenu/campaign_menu_UI_assets');
	rightArrow.setGraphicSize(Std.int(rightArrow.width * 0.8));
	rightArrow.animation.addByPrefix('idle', "arrow right");
	rightArrow.animation.addByPrefix('press', "arrow push right");
	rightArrow.animation.play('idle');
	add(rightArrow);

	sprDifficulty = new FlxSprite(1210 - 70, 530);
	sprDifficulty.frames = Paths.getSparrowAtlas('menus/storymenu/difficulties');
	sprDifficulty.animation.addByPrefix('easy', 'EASY');
	sprDifficulty.animation.addByPrefix('normal', 'NORMAL');
	sprDifficulty.animation.addByPrefix('hard', 'HARD');
	sprDifficulty.scale.set(2.5, 2.5);
	sprDifficulty.animation.play(diffs[curDifficulty]);
	add(sprDifficulty);
}

function onUpdate(elapsed:Float)
{
	if (selection)
		return;

	if (leftArrow != null)
		leftArrow.animation.play(controls.UI_LEFT ? 'press' : 'idle');
	if (rightArrow != null)
		rightArrow.animation.play(controls.UI_RIGHT ? 'press' : 'idle');

	if (controls.UI_LEFT_P || FlxG.keys.justPressed.LEFT || (leftArrow != null && FlxG.mouse.overlaps(leftArrow) && FlxG.mouse.justPressed))
	{
		curDifficulty--;
		if (curDifficulty < 0)
			curDifficulty = 2;
		sprDifficulty.animation.play(diffs[curDifficulty]);
	}

	if (controls.UI_RIGHT_P || FlxG.keys.justPressed.RIGHT || (rightArrow != null && FlxG.mouse.overlaps(rightArrow) && FlxG.mouse.justPressed))
	{
		curDifficulty++;
		if (curDifficulty > 2)
			curDifficulty = 0;
		sprDifficulty.animation.play(diffs[curDifficulty]);
	}

	if (controls.BACK || FlxG.keys.justPressed.ESCAPE || FlxG.keys.justPressed.BACKSPACE)
	{
		FlxG.switchState(new MainMenuState());
	}

	if (controls.ACCEPT || FlxG.keys.justPressed.ENTER)
		selectItem();
}

function selectItem()
{
	if (selection)
		return;
	selection = true;

	FlxG.sound.play(Paths.sound('confirmMenu'));

	var playlist:Array<String> = [];
	for (s in songArray)
		playlist.push(Paths.sanitize(s));

	PlayState.isStoryMode = true;
	PlayState.storyPlaylist = playlist;
	PlayState.storyDifficulty = curDifficulty;
	PlayState.storyWeek = 1;
	PlayState.campaignScore = 0;

	var first = playlist[0];
	var err = PlayState.prepareForSong(first, curDifficulty, true);
	if (err != null)
	{
		selection = false;
		trace(err);
		FlxG.sound.play(Paths.sound('cancelMenu'));
		return;
	}

	FlxTimer.wait(1, () -> {
		FlxG.switchState(() -> new PlayState(), true);
	});
}