import flixel.tweens.FlxTween;
import flixel.tweens.FlxEase;
import flixel.util.FlxTimer;
import funkin.states.MainMenuState;
import funkin.states.FlashingState;
import funkin.FunkinAssets;

var transitioning:Bool = false;
var canAccept:Bool = false;
var built:Bool = false;

var titleBg:FlxSprite;
var titleText:FlxSprite;
var logo:FlxSprite;
var logoR:FlxSprite;
var logoO:FlxSprite;
var logoH:FlxSprite;

var hiFlashing:Bool = false;

function onLoad()
{
	persistentUpdate = true;
	persistentDraw = true;
	FlxG.mouse.visible = false;

	buildTitle();
}

function buildTitle()
{
	if (built) return;
	built = true;

	titleBg = new FlxSprite().loadGraphic(Paths.image('menus/titlemenu/menuBegin'));
	titleBg.screenCenter();
	titleBg.antialiasing = ClientPrefs.globalAntialiasing;
	add(titleBg);

	logo = new FlxSprite(270, 0).loadGraphic(Paths.image('menus/titlemenu/verylogo-new'));
	logo.scale.set(0.35, 0.35);
	logo.updateHitbox();
	add(logo);

	logoR = new FlxSprite(240, 0).loadGraphic(Paths.image('menus/titlemenu/R'));
	logoR.scale.set(0.35, 0.35);
	logoR.updateHitbox();
	add(logoR);

	logoO = new FlxSprite(240, 0).loadGraphic(Paths.image('menus/titlemenu/O'));
	logoO.scale.set(0.35, 0.35);
	logoO.updateHitbox();
	add(logoO);

	logoH = new FlxSprite(240, 0).loadGraphic(Paths.image('menus/titlemenu/H'));
	logoH.scale.set(0.35, 0.35);
	logoH.updateHitbox();
	add(logoH);

	titleText = new FlxSprite();
	titleText.antialiasing = ClientPrefs.globalAntialiasing;
	titleText.frames = Paths.getSparrowAtlas('menus/titlemenu/pressEnter');
	titleText.animation.addByPrefix('idle', "enter Loop", 24, true);
	titleText.animation.addByPrefix('press', "enter Pressed", 24, false);
	titleText.animation.play('idle');
	titleText.updateHitbox();
	titleText.screenCenter(FlxAxes.X);
	titleText.y = FlxG.height - titleText.height + 580;
	add(titleText);

	logo.alpha = logoR.alpha = logoO.alpha = logoH.alpha = titleBg.alpha = titleText.alpha = 0.00001;

	start();
}

function start()
{
	FlxTween.tween(logo, {alpha: 1}, 2);

	new FlxTimer().start(1.5, function(_)
	{
		FlxTween.tween(logoR, {x: 270, alpha: 1}, 0.5, {startDelay: 0.5, ease: FlxEase.quadOut});
		FlxTween.tween(logoO, {x: 270, alpha: 1}, 0.5, {startDelay: 1.0, ease: FlxEase.quadOut});
		FlxTween.tween(logoH, {x: 270, alpha: 1}, 0.5, {startDelay: 1.5, ease: FlxEase.quadOut});
	});

	new FlxTimer().start(3.5, function(_)
	{
        FlxG.sound.volume = FlxG.save.data.volume != null ? FlxG.save.data.volume : 1;
		FlxG.camera.flash(FlxColor.RED, 2);
		FlxG.sound.play(Paths.sound('showMoment'), 1);

		if (FlxG.sound.music == null)
			FlxG.sound.playMusic(Paths.music('freakyMenu'), 0.3, true);

		logo.alpha = titleBg.alpha = titleText.alpha = 1;
		logoR.x = logoO.x = logoH.x = 270;
		logoR.alpha = logoO.alpha = logoH.alpha = 1;
		canAccept = true;
	});
}

function onUpdate(elapsed:Float)
{
	if (FlxG.sound.music != null)
		Conductor.songPosition = FlxG.sound.music.time;

	final pressed = FlxG.keys.justPressed.ENTER || FlxG.keys.justPressed.SPACE;
	if (pressed && canAccept && !transitioning)
		pressEnter();
}

function pressEnter()
{
	transitioning = true;
	titleText.animation.play('press', true);
	
	FlxG.sound.play(Paths.sound('cancelMenu'));

	FlxTween.tween(titleBg, {alpha: 0}, 2);
	FlxTween.tween(titleText, {y: titleText.y + (FlxG.height * 1.4)}, 1.5, {ease: FlxEase.circInOut});

	FlxTween.tween(logoH, {x: 240, alpha: 0}, 0.4, {startDelay: 0.0, ease: FlxEase.quadIn});
	FlxTween.tween(logoO, {x: 240, alpha: 0}, 0.4, {startDelay: 0.3, ease: FlxEase.quadIn});
	FlxTween.tween(logoR, {x: 240, alpha: 0}, 0.4, {startDelay: 0.6, ease: FlxEase.quadIn});
	FlxTween.tween(logo, {alpha: 0}, 0.8, {startDelay: 1.1});

	new FlxTimer().start(2.75, function(_)
	{
		FlxG.switchState(() -> new MainMenuState());
	});
}