import flixel.FlxSprite;
import flixel.FlxG;
import flixel.tweens.FlxTween;
import flixel.tweens.FlxEase;

var blackoutScreen:FlxSprite;

function onCreatePost()
{
	blackoutScreen = new FlxSprite().makeGraphic(FlxG.width, FlxG.height, 0xFF000000);
	blackoutScreen.cameras = [camHUD]; 
	blackoutScreen.screenCenter();
	blackoutScreen.alpha = 0;
	add(blackoutScreen);
}

function onEvent(eventName:String, value1:String, value2:String)
{
	if (eventName == 'fadeBlackout')
	{
		var duration:Float = Std.parseFloat(value2);
		if (Math.isNaN(duration) || duration <= 0) duration = 0.001; 

		if (value1 == 'black')
		{
			FlxTween.cancelTweensOf(blackoutScreen);
			FlxTween.tween(blackoutScreen, {alpha: 1}, duration, {ease: FlxEase.sineInOut});
		}
		else if (value1 == 'normal')
		{
			FlxTween.cancelTweensOf(blackoutScreen);
			FlxTween.tween(blackoutScreen, {alpha: 0}, duration, {ease: FlxEase.sineInOut});
		}
	}
}