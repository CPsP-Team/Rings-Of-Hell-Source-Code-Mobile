var drainEnabled:Bool = false;
var drainAmount:Float = 0.023;
var drainLimit:Float = 0.5;

function onEvent(eventName:String, value1:String, value2:String)
{
	if (eventName == 'health drain')
	{
		value1 = value1.toLowerCase();
		if (value1 != 'on' && value1 != 'off') 
			value1 = 'on';
			
		drainEnabled = (value1 == 'on');

		if (value2 == null || StringTools.trim(value2) == "")
			value2 = "0.023, 0.5";

		var drainVars:Array<String> = value2.split(",");
		if (drainVars.length >= 2)
		{
			drainAmount = Std.parseFloat(StringTools.trim(drainVars[0]));
			drainLimit = Std.parseFloat(StringTools.trim(drainVars[1]));
		}
	}
}

function opponentNoteHit(note:Dynamic, field:Dynamic)
{
	if (drainEnabled)
	{
		if (health > drainLimit)
		{
			health -= drainAmount;
			
			if (health < drainLimit) 
				health = drainLimit; 
		}
	}
}