import flixel.math.FlxMath;
import flixel.ui.FlxBar;
import flixel.ui.FlxBar.FlxBarFillDirection;
import funkin.utils.MathUtil;

// Among Us UI
final hpFrames:Array<FlxSprite> = [];
var timeBar:FlxSprite;
var timeBarProgress:FlxBar;

var iconP1PosX:Float;
var iconP1PosY:Float;
var iconP2PosX:Float;
var iconP2PosY:Float;

function onCreatePost()
{
	for (fnfHud in [playHUD.timeBar, playHUD.timeBarBG, playHUD.timeTxt, playHUD.healthBarBG, playHUD.healthBar])
	{
		if (fnfHud != null) fnfHud.visible = false;
	}

	final pushToHUD = function(spr:Dynamic, z:Int = 0) {
		spr.cameras = [game.camHUD];
		spr.antialiasing = ClientPrefs.globalAntialiasing;
		playHUD.add(spr); // same group as the icons
	};

	final isDown = ClientPrefs.downScroll;

	final blackHPBG:FlxSprite = new FlxSprite(0, 0).loadGraphic(Paths.image("hud/draepostor/healthbar/black"));
	blackHPBG.alpha = 0.8;
	blackHPBG.scale.set(0.2, 0.2);
	blackHPBG.updateHitbox();

	if (isDown) {
		blackHPBG.x = 10;
		blackHPBG.y = 5;
	} else {
		blackHPBG.x = 10;
		blackHPBG.y = 605;
	}
	pushToHUD(blackHPBG, 0);

	final HPBar:FlxSprite = new FlxSprite(blackHPBG.x, blackHPBG.y).loadGraphic(Paths.image("hud/draepostor/healthbar/healthbar"));
	HPBar.scale.set(blackHPBG.scale.x, blackHPBG.scale.y);
	HPBar.updateHitbox();
	pushToHUD(HPBar, 1);

	for (i in 1...6)
	{
		final spr = new FlxSprite(HPBar.x, HPBar.y).loadGraphic(Paths.image("hud/draepostor/healthbar/bar" + i));
		spr.scale.set(HPBar.scale.x, HPBar.scale.y);
		spr.updateHitbox();
		spr.visible = false;
		pushToHUD(spr, 2);
		hpFrames.push(spr);
	}

	final HPBarBorder:FlxSprite = new FlxSprite(blackHPBG.x, blackHPBG.y).loadGraphic(Paths.image("hud/draepostor/healthbar/border"));
	HPBarBorder.scale.set(blackHPBG.scale.x, blackHPBG.scale.y);
	HPBarBorder.updateHitbox();
	pushToHUD(HPBarBorder, 3);

	final iconYOffset:Float = -15;
	final draepostorXOffset:Float = -10;
	final bfXOffset:Float = 280;

	iconP2PosX = blackHPBG.x + draepostorXOffset;
	iconP2PosY = blackHPBG.y + iconYOffset;

	iconP1PosX = blackHPBG.x + bfXOffset;
	iconP1PosY = blackHPBG.y + iconYOffset;

	playHUD.updateIconScale = false;
	playHUD.iconP1.scale.set(0.45, 0.45);
	playHUD.iconP2.scale.set(0.45, 0.45);
	
	playHUD.iconP1.zIndex = 10;
	playHUD.iconP2.zIndex = 10;
	playHUD.scoreTxt.zIndex = 11;

	refreshZ(playHUD);

	playHUD.scoreTxt.font = Paths.font("amongus.ttf");
	playHUD.scoreTxt.size = 28;
	playHUD.scoreTxt.updateHitbox();

	if (isDown) {
		playHUD.scoreTxt.screenCenter(FlxAxes.X);
		playHUD.scoreTxt.x += 25;
		playHUD.scoreTxt.y = 20;
		playHUD.scoreTxt.alignment = FlxTextAlign.CENTER;
		playHUD.scoreTxt.antialiasing = ClientPrefs.globalAntialiasing;
	} else {
		playHUD.scoreTxt.screenCenter(FlxAxes.X);
		playHUD.scoreTxt.x += 25;
		playHUD.scoreTxt.y = 680;
		playHUD.scoreTxt.alignment = FlxTextAlign.CENTER;
		playHUD.scoreTxt.antialiasing = ClientPrefs.globalAntialiasing;
	}

	final timeScaleX:Float = 0.18;
	final timeScaleY:Float = 0.14;

	final insetXPercent:Float = 0.08;
	final insetYPercent:Float = 0.30;

	final timeBG:FlxSprite = new FlxSprite(0, 0).loadGraphic(Paths.image('hud/draepostor/timebar/blackbar'));
	timeBG.antialiasing = ClientPrefs.globalAntialiasing;
	timeBG.cameras = [game.camHUD];
	timeBG.alpha = 0.8;
	timeBG.scale.set(timeScaleX, timeScaleY);
	timeBG.updateHitbox();
	timeBG.screenCenter(FlxAxes.X);
	timeBG.y = isDown ? 685 : -25;

	timeBar = new FlxSprite(timeBG.x, timeBG.y).loadGraphic(Paths.image('hud/draepostor/timebar/timebar'));
	timeBar.antialiasing = ClientPrefs.globalAntialiasing;
	timeBar.cameras = [game.camHUD];
	timeBar.scale.set(timeScaleX, timeScaleY);
	timeBar.updateHitbox();
	timeBar.x = timeBG.x;
	timeBar.y = timeBG.y;

	final insetX:Float = timeBar.width * insetXPercent;
	final insetY:Float = timeBar.height * insetYPercent;
	final barWidth:Int = Std.int(Math.max(1, timeBar.width - insetX * 2));
	final barHeight:Int = Std.int(Math.max(1, timeBar.height - insetY * 2));

	timeBarProgress = new FlxBar(timeBar.x + insetX - 10, timeBar.y + insetY + 10, FlxBarFillDirection.LEFT_TO_RIGHT, barWidth + 20, barHeight - 20);
	timeBarProgress.createFilledBar(0x00000000, 0xFF00FF00, true);
	timeBarProgress.setRange(0, 1);
	timeBarProgress.value = 0;
	timeBarProgress.cameras = [game.camHUD];
	timeBarProgress.numDivisions = 800;

	add(timeBG);
	add(timeBarProgress);
	add(timeBar);
}

var currentProgress:Float = 0;
var targetProgress:Float = 0;
final lerpSpeed:Float = 2;

function onUpdate(elapsed:Float)
{
	final currentHealth:Float = game.health;
	final totalFrames:Int = hpFrames.length;
	final showCount:Int = MathUtil.clamp(Std.int((currentHealth / 2) * totalFrames), 0, totalFrames);

	for (i in 0...totalFrames)
		hpFrames[i].visible = (i < showCount);

	var curTime:Float = Conductor.songPosition - ClientPrefs.noteOffset;
	if (curTime < 0) curTime = 0;

	var totalSongTime:Float = game.songLength;
	if (totalSongTime <= 0 && FlxG.sound.music != null)
		totalSongTime = FlxG.sound.music.length;
	if (totalSongTime <= 0) totalSongTime = 1;

	targetProgress = MathUtil.clamp(curTime / totalSongTime, 0, 1);
	currentProgress = FlxMath.lerp(currentProgress, targetProgress, MathUtil.clamp(elapsed * lerpSpeed, 0, 1));

	if (timeBarProgress != null)
		timeBarProgress.value = currentProgress;
}

function onUpdatePost()
{
	if (playHUD.iconP1.animation.curAnim.curFrame == 0)
		playHUD.iconP1.setPosition(iconP1PosX, iconP1PosY);
	else
		playHUD.iconP1.setPosition(iconP1PosX + 5, iconP1PosY);

	if (playHUD.iconP2.animation.curAnim.curFrame == 0)
		playHUD.iconP2.setPosition(iconP2PosX, iconP2PosY);
	else
		playHUD.iconP2.setPosition(iconP2PosX - 7, iconP2PosY);
}

function onUpdateScore()
{
	playHUD.scoreTextTwn?.cancel();
}