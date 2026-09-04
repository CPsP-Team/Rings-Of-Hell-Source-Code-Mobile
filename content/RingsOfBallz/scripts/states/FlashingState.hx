import flixel.FlxSprite;
import flixel.text.FlxText;
import flixel.text.FlxTextFormat;
import flixel.text.FlxTextFormatMarkerPair;
import flixel.util.FlxTimer;
import flixel.tweens.FlxTween;
import flixel.tweens.FlxEase;
import funkin.states.FlashingState;

var textWarn:FlxText;
var textDesc:FlxText;
var textPress:FlxText;
var eyxJump:FlxSprite;
var accepted:Bool = false;
var canAccept:Bool = false;

function onLoad()
{
	if (!ClientPrefs.disableWarning)
	{
		textWarn = new FlxText(0, 0, 0, "Warning", 64);
		textWarn.setFormat(Paths.font("sonic-cd-menu-font.ttf"), 64, FlxColor.WHITE, "center");
		textWarn.screenCenter();
		add(textWarn);

		textDesc = new FlxText(0, 420, FlxG.width, "This mod contains *Flashing Lights*, *Gore*, *Jumpscares* and _Shaders_.\n\nProceed with caution.", 20);
		textDesc.setFormat(Paths.font("sonic-cd-menu-font.ttf"), 20, FlxColor.WHITE, "center");
		textDesc.applyMarkup(textDesc.text, [
			new FlxTextFormatMarkerPair(new FlxTextFormat(0xFFFF0000), "*"),
			new FlxTextFormatMarkerPair(new FlxTextFormat(0xFF0011FF), "#"),
			new FlxTextFormatMarkerPair(new FlxTextFormat(0xFFFFFF00), "_")
		]);
		textDesc.alpha = 0;
		add(textDesc);

		if (Defines.defines.exists('desktop'))
			textPress = new FlxText(0, 650, FlxG.width, "Press ENTER to continue.", 20);
		else
			textPress = new FlxText(0, 650, FlxG.width, "Tap to continue.", 20);

		textPress.setFormat(Paths.font("sonic-cd-menu-font.ttf"), 20, FlxColor.WHITE, "center");
		textPress.alpha = 0;
		add(textPress);

		eyxJump = new FlxSprite().loadGraphic(Paths.image("menus/eyxjumpscare"));
		eyxJump.setGraphicSize(Std.int(eyxJump.width * 0.35));
		eyxJump.updateHitbox();
		eyxJump.screenCenter();
		eyxJump.visible = false;
		eyxJump.alpha = 0;
		add(eyxJump);

		startTextShit();
	}
}

function onCreate()
{
	if (ClientPrefs.disableWarning)
	{
		FlxG.switchState(new funkin.states.TitleState());
		return;
	}
	FlxG.sound.volume = FlxG.save.data.volume != null ? FlxG.save.data.volume : 1;
}

function startTextShit()
{
	new FlxTimer().start(2.5, function(tmr:FlxTimer)
	{
		FlxTween.tween(textWarn, {
			y: 60,
			"scale.x": 0.7,
			"scale.y": 0.7
		}, 0.75, {ease: FlxEase.outCubic});

		new FlxTimer().start(0.75, function(tmr:FlxTimer)
		{
			FlxTween.tween(textDesc, {
				y: 340,
				alpha: 1
			}, 1.5, {ease: FlxEase.outCubic, onComplete: function(ass) canAccept = true});
		});

		new FlxTimer().start(1.5, function(tmr:FlxTimer)
		{
			FlxTween.tween(textPress, {
				y: 580,
				alpha: 1
			}, 1.75, {ease: FlxEase.outCubic});
		});
	});
}

function onUpdate(elapsed:Float)
{
	if ((controls.ACCEPT || FlxG.mouse.justPressed) && !accepted && canAccept)
	{
		accepted = true;

		textWarn.visible = false;
		textDesc.visible = false;
		textPress.visible = false;

		FlashingState.leftState = true;

		new FlxTimer().start(2.0, function(tmr:FlxTimer)
		{
			eyxJump.visible = true;
			FlxG.sound.play(Paths.sound("eyx_laugh"));

			FlxTween.tween(eyxJump, {
				alpha: 0.2
			}, 0.3, {ease: FlxEase.elasticOut});

			new FlxTimer().start(4.0, function(tmr:FlxTimer)
			{
				FlxTween.tween(eyxJump, {
					alpha: 0.0
				}, 0.1, {ease: FlxEase.elasticOut});
				FlxG.switchState(new funkin.states.TitleState());
			});
		});
	}
}
