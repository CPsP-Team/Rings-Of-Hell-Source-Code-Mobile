import flixel.group.FlxSpriteGroup.FlxTypedSpriteGroup;
import flixel.math.FlxMath;
import flixel.text.FlxText;
import flixel.tweens.FlxTween;
import flixel.tweens.FlxEase;
import funkin.states.MainMenuState;
import funkin.states.PlayState;
import funkin.data.Highscore;
import funkin.backend.Difficulty;
import funkin.input.Controls;
import funkin.utils.CoolUtil;
import funkin.FunkinAssets;

var songsList:Array<String> = [
	"bloodnight",
	"sussus-hillus",
	"shadow-of-divinity",
	"infinite-torment",
	"sussus-hillus-legacy",
	"shadow-of-divinity-legacy"
];

var songsGroup:FlxTypedSpriteGroup<FlxSprite>;
var songTextGroup:FlxTypedSpriteGroup<FlxTypedSpriteGroup<FlxSprite>>;
var artList:Array<FlxSprite> = [];

var songBG:FlxSprite;
var spikyBar:FlxSprite;
var spikyBarTop:FlxSprite;
var buttonUp:FlxSprite;
var buttonDown:FlxSprite;
var back:FlxSprite;

var score:FlxText;
var rank:FlxText;
var menuText:FlxText;
var scoreText:FlxText;
var rankText:FlxText;

var curStage:String = "bloodnight";
var curSelected:Int = 0;
var lerpScore:Int = 0;
var intendedScore:Int = 0;
var intendedRating:Float = 0;
var intendedCombo:String = "";

var canSelect:Bool = true;
var selectin:Bool = false;

var curDifficulty:Int = 2;

var portraitFrame:FlxSprite;
var portraitArt:FlxSprite;

final babayaga:FlxPoint = FlxPoint.weak(FlxG.width * 0.8, 510);
final color = 0xFFFFFFFF;

function onLoad()
{
	persistentUpdate = true;
	persistentDraw = true;
	PlayState.isStoryMode = false;
}

function onCreate()
{
    FunkinAssets.cache.clearStoredMemory();
	FunkinAssets.cache.clearUnusedMemory();

	if (FlxG.sound.music == null || !FlxG.sound.music.playing)
		FlxG.sound.playMusic(Paths.music('TheAmogusFunk'), 0.5, true);

	songBG = new FlxSprite(0, 80);
	songBG.antialiasing = ClientPrefs.globalAntialiasing;
	songBG.scale.set(0.6, 0.6);
	add(songBG);
	updateStageBG();

	spikyBar = new FlxSprite(80, 80);
	spikyBar.loadGraphic(Paths.image('menus/freeplay/sidebar'));
	spikyBar.antialiasing = ClientPrefs.globalAntialiasing;
	spikyBar.scale.set(0.6, 0.6);
	spikyBar.updateHitbox();
	add(spikyBar);

	spikyBarTop = new FlxSprite(0, -50);
	spikyBarTop.loadGraphic(Paths.image('menus/freeplay/sidebar-black'));
	spikyBarTop.antialiasing = ClientPrefs.globalAntialiasing;
	spikyBarTop.scale.set(0.325, 0.325);
	spikyBarTop.updateHitbox();
	add(spikyBarTop);

	menuText = new FlxText(525, 15, 0, "Freeplay", 32);
	menuText.setFormat(Paths.font("sonic-cd-menu-font.ttf"), 32, FlxColor.WHITE, "center");
	add(menuText);

    scoreText = new FlxText(babayaga.x - 145, babayaga.y - 12, 0, "Score:", 24);
	scoreText.setFormat(Paths.font("PressStart2P.ttf"), 24, color, "left");
	add(scoreText);

	score = new FlxText(babayaga.x + 5, babayaga.y - 12, 0, "0", 24);
	score.setFormat(Paths.font("PressStart2P.ttf"), 24, FlxColor.WHITE, "left");
	add(score);

	rankText = new FlxText(babayaga.x - 145, babayaga.y + 40, 0, "Accuracy:", 24);
	rankText.setFormat(Paths.font("PressStart2P.ttf"), 24, color, "left");
	add(rankText);

	rank = new FlxText(babayaga.x + 70, babayaga.y + 40, 0, "", 24);
	rank.setFormat(Paths.font("PressStart2P.ttf"), 24, color, "left");
	add(rank);

	portraitArt = new FlxSprite();
	portraitArt.antialiasing = ClientPrefs.globalAntialiasing;
	add(portraitArt);

	portraitFrame = new FlxSprite(780, 180);
	portraitFrame.loadGraphic(Paths.image('menus/freeplay/FreeBox'));
	portraitFrame.antialiasing = ClientPrefs.globalAntialiasing;
	portraitFrame.setGraphicSize(420, 260);
	portraitFrame.updateHitbox();
	add(portraitFrame);

	songsGroup = new FlxTypedSpriteGroup();
	add(songsGroup);

	songTextGroup = new FlxTypedSpriteGroup();
	add(songTextGroup);

	for (i in 0...songsList.length)
	{
		var itemGroup = new FlxTypedSpriteGroup(0, 170 + (i * 100));
		itemGroup.ID = i;

		var songBar = new FlxSprite();
		songBar.loadGraphic(Paths.image('menus/freeplay/songbar'));
		songBar.antialiasing = ClientPrefs.globalAntialiasing;
		songBar.scale.set(0.5, 0.5);
		songBar.updateHitbox();
		itemGroup.add(songBar);

		var formattedName = songsList[i].split("-").join(" ");
		var songText = new FlxText(40, 0, 350, formattedName, 22);
		songText.setFormat(Paths.font("sonic-cd-menu-font.ttf"), 22, FlxColor.WHITE, FlxTextAlign.LEFT);
		songText.antialiasing = ClientPrefs.globalAntialiasing;
		songText.wordWrap = false;
		songText.y = ((songBar.height - songText.height) / 2) + 10;
		itemGroup.add(songText);

		songTextGroup.add(itemGroup);
	}

	buttonUp = new FlxSprite(100, 160).loadGraphic(Paths.image('menus/freeplay/button-up'));
	buttonUp.scale.set(0.5, 0.5);
	buttonUp.antialiasing = ClientPrefs.globalAntialiasing;
	add(buttonUp);

	buttonDown = new FlxSprite(100, 310).loadGraphic(Paths.image('menus/freeplay/button-down'));
	buttonDown.scale.set(0.5, 0.5);
	buttonDown.antialiasing = ClientPrefs.globalAntialiasing;
	add(buttonDown);

	changeSong(0);
}

function setPortrait(songName:String)
{
	portraitArt.loadGraphic(Paths.image('menus/freeplay/portraits/' + songName));
	
	portraitArt.scale.set(1, 1);
	portraitArt.updateHitbox();

    var artW:Int = 800;
	var artH:Int = 446;

	portraitArt.setGraphicSize(artW, artH);
	portraitArt.updateHitbox();

	portraitArt.setPosition(
		portraitFrame.x + ((portraitFrame.width - portraitArt.width) * 0.5),
		portraitFrame.y + ((portraitFrame.height - portraitArt.height) * 0.5)
	);
}

function updateStageBG()
{
	switch (songsList[curSelected].toLowerCase())
	{
		case "sussus-hillus", "sussus-hillus-legacy":
			curStage = "sussus-hillus";
		case "shadow-of-divinity", "shadow-of-divinity-legacy":
			curStage = "shadow-of-divinity";
		case "infinite-torment":
			curStage = "infinite-torment";
		default:
			curStage = "bloodnight";
	}

	if (songBG != null)
	{
		songBG.loadGraphic(Paths.image('menus/freeplay/stages/' + curStage));
		songBG.updateHitbox();
	}
}

function onUpdate(elapsed:Float)
{
	if (canSelect && !selectin)
	{
		if (controls.UI_UP_P || FlxG.keys.justPressed.UP || (FlxG.mouse.overlaps(buttonUp) && FlxG.mouse.justPressed))
			changeSong(-1);
		if (controls.UI_DOWN_P || FlxG.keys.justPressed.DOWN || (FlxG.mouse.overlaps(buttonDown) && FlxG.mouse.justPressed))
			changeSong(1);

		if (controls.BACK || FlxG.keys.justPressed.ESCAPE || FlxG.keys.justPressed.BACKSPACE)
		{
			FlxG.switchState(new MainMenuState());
		}

		if (controls.ACCEPT || FlxG.keys.justPressed.ENTER || FlxG.keys.justPressed.SPACE)
			selectItem();
	}

	lerpScore = Math.floor(FlxMath.lerp(lerpScore, intendedScore, FlxMath.bound(elapsed * 24, 0, 1)));
	if (Math.abs(lerpScore - intendedScore) <= 10)
		lerpScore = intendedScore;

	score.text = Std.string(lerpScore);
	rank.text = intendedCombo;
}

function changeSong(huh:Int = 0)
{
	if (selectin)
		return;

	if (huh == 1 && curSelected < songsList.length - 1)
	{
		canSelect = false;
		FlxG.sound.play(Paths.sound('scrollMenu'), 0.4);
		FlxTween.tween(songsGroup, {x: songsGroup.x - 420}, 0.2, {
			ease: FlxEase.expoOut,
			onComplete: function(_) canSelect = true
		});
		curSelected += 1;
	}
	else if (huh == -1 && curSelected > 0)
	{
		canSelect = false;
		FlxG.sound.play(Paths.sound('scrollMenu'), 0.4);
		FlxTween.tween(songsGroup, {x: songsGroup.x + 420}, 0.2, {
			ease: FlxEase.expoOut,
			onComplete: function(_) canSelect = true
		});
		curSelected -= 1;
	}

	updateStageBG();
	setPortrait(songsList[curSelected]);

	intendedScore = Highscore.getScore(songsList[curSelected], curDifficulty);
	intendedRating = Highscore.getRating(songsList[curSelected], curDifficulty);
	intendedCombo = Std.string(Math.floor(intendedRating * 100)) + "%";

	songsGroup.forEach(function(sprite:FlxSprite)
	{
		FlxTween.tween(sprite, {alpha: sprite.ID == curSelected ? 1 : 0}, 0.2);
	});

	FlxTween.cancelTweensOf(songTextGroup);
	FlxTween.tween(songTextGroup, {y: -(curSelected * 100)}, 0.2, {ease: FlxEase.expoOut});

	songTextGroup.forEach(function(group:FlxTypedSpriteGroup<FlxSprite>)
	{
		FlxTween.cancelTweensOf(group);
		FlxTween.tween(group, {alpha: group.ID == curSelected ? 1 : 0.2}, 0.2, {ease: FlxEase.expoOut});
	});
}

function selectItem()
{
	if (selectin)
		return;

	selectin = true;
	FlxG.sound.play(Paths.sound('confirmMenu'));

	var daChoice = Paths.sanitize(songsList[curSelected]);

	var err = PlayState.prepareForSong(daChoice, curDifficulty, false);
	if (err != null)
	{
		selectin = false;
		trace(err);
		FlxG.sound.play(Paths.sound('cancelMenu'));
		return;
	}

	PlayState.isStoryMode = false;
	PlayState.storyDifficulty = curDifficulty;

	FlxG.switchState(() -> new PlayState(), true);
}