import flixel.FlxSprite;
import flixel.FlxG;
import flixel.tweens.FlxTween;
import flixel.tweens.FlxEase;

var flashScreen:FlxSprite;

function onCreatePost()
{
	flashScreen = new FlxSprite().makeGraphic(FlxG.width, FlxG.height, 0xFFFF0000);
	flashScreen.cameras = [camOther];
	flashScreen.scrollFactor.set(0, 0);
	flashScreen.scale.set(2, 2);
	flashScreen.screenCenter();
	flashScreen.alpha = 0;
	add(flashScreen);
}

function onEvent(eventName:String, value1:String, value2:String)
{
	if (eventName == 'Flash Camera')
	{
		var duration:Float = Std.parseFloat(value1);
		if (Math.isNaN(duration) || duration <= 0) duration = 1.0;

		flashScreen.alpha = 1;
		FlxTween.cancelTweensOf(flashScreen);
		FlxTween.tween(flashScreen, {alpha: 0}, duration, {ease: FlxEase.linear});
	}
}