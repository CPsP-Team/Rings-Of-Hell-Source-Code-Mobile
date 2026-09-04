function onLoad() {
	var MajinBG = new FlxSprite(-600, -300).loadGraphic(Paths.image('stages/fun-stage/MajinBG'));
	MajinBG.scale.set(1.5, 1.5);
	MajinBG.updateHitbox();
	add(MajinBG);

	var MajinBG2 = new FlxSprite(-600, -300).loadGraphic(Paths.image('stages/fun-stage/MajinBG2'));
	MajinBG2.scale.set(1.5, 1.5);
	MajinBG2.updateHitbox();
	add(MajinBG2);

	var MajinBG3 = new FlxSprite(-600, -300).loadGraphic(Paths.image('stages/fun-stage/MajinBG3'));
	MajinBG3.scale.set(1.5, 1.5);
	MajinBG3.updateHitbox();
	add(MajinBG3);

	var MajinBG4 = new FlxSprite(-600, -300).loadGraphic(Paths.image('stages/fun-stage/MajinBG4'));
	MajinBG4.scale.set(1.5, 1.5);
	MajinBG4.updateHitbox();
	add(MajinBG4);
}

function onCreatePost() {
	var MajinBG5 = new FlxSprite(-600, -300).loadGraphic(Paths.image('stages/fun-stage/MajinBG5'));
	MajinBG5.scale.set(1.5, 1.5);
	MajinBG5.updateHitbox();
	add(MajinBG5);

    playHUD.timeBar.setColors(0xFF0D1EC3, FlxColor.BLACK);
    playHUD.scoreTxt.color = 0xFF0D1EC3;
}