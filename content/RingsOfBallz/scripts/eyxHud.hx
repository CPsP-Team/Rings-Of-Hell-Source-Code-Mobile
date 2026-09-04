// I hate this code with EVERY FIBER of my being
var customHud:FlxSprite;

final barInsetX:Float = -130;
final barInsetYUp:Float = 158;
final barInsetYDown:Float = 150;
final iconSidePadding:Float = 750;
final iconGroupOffY:Float = 30;

var iconP1BaseWidth:Float = 0; // DON'T TOUCH
var iconP2BaseWidth:Float = 0; // DON'T TOUCH

final hudYUp:Float = 455;
final hudYDown:Float = -140;

final songName = PlayState.SONG.song.toLowerCase();

function onCreatePost()
{
	if (songName == 'sussus-hillus' || songName == 'sussus-hillus-legacy')
		return;

	final hud = playHUD;
	final down = ClientPrefs.downScroll;
	
	final scoreTxtPadding:Float = (!down ? 236 : 86);

	hud.updateIconPos = false;

	iconP1BaseWidth = hud.iconP1.width;
	iconP2BaseWidth = hud.iconP2.width;

	customHud = new FlxSprite();
	customHud.loadGraphic(Paths.image('hud/eyx/eyxHUD'));
	customHud.antialiasing = ClientPrefs.globalAntialiasing;
	customHud.updateHitbox();
	customHud.screenCenter(FlxAxes.X);
	customHud.y = down ? hudYDown : hudYUp;
	customHud.scale.set(0.8, 0.8);

	hud.healthBar.scale.set(1.1, 4.9);
	hud.healthBar.updateHitbox();
	hud.healthBar.x = customHud.x + barInsetX;
	hud.healthBar.y = customHud.y + (down ? barInsetYDown : barInsetYUp);
	if (hud.healthBar.bg != null)
		hud.healthBar.bg.visible = false;

	hud.add(customHud);

	if (boyfriend != null) hud.iconP1.changeIcon(boyfriend.healthIcon);
	if (dad != null) hud.iconP2.changeIcon(dad.healthIcon);

	hud.scoreTxt.y = customHud.y + customHud.height - scoreTxtPadding;

	if (songName != 'sussus-hillus' || songName != 'sussus-hillus-legacy')
		placeIcons();

	hud.healthBar.zIndex = 1;
	customHud.zIndex = 2;
	hud.scoreTxt.zIndex = 3;
	hud.iconP1.zIndex = 3;
	hud.iconP2.zIndex = 3;
	refreshZ(hud);
}

final charsToHideNotes:Array<String> = [
	'eyx',
	'2025X-mad'
];

var curAlpha:Float = 1.0;

function onUpdatePost(elapsed:Float)
{
	var noteFade:Float = 1.0;

	if (charsToHideNotes.contains(dad.curCharacter))
	{
		noteFade = 0;
		opponentStrums.disableSusSplashes = true;
	}
	
	if (opponentStrums.disableSusSplashes)
	{
		opponentStrums.grpSusSplashes.forEachAlive(function(piss)
		{
			piss.kill();
		});
	}

	curAlpha = FlxMath.lerp(curAlpha, noteFade, elapsed * 5);
	
	opponentStrums.underlayAlphaMult = curAlpha;

	for (strum in opponentStrums.members)
	{
		if (strum != null)
		{
			strum.alpha = curAlpha;
		}
	}

	for (note in notes.members)
	{
		if (note != null && !note.mustPress)
		{
			note.alpha = curAlpha;
		}
	}
}

function placeIcons()
{
	final hud = playHUD;
	final bar = hud.healthBar;

	hud.iconP1.x = customHud.x + iconSidePadding;
	hud.iconP2.x = customHud.x + customHud.width - iconP2BaseWidth - iconSidePadding;

	hud.iconP1.y = bar.y - iconGroupOffY;
	hud.iconP2.y = bar.y - iconGroupOffY;
}