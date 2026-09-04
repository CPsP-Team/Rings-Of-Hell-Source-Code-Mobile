var sky:FlxSprite;
var moon:FlxSprite;
var mountain:FlxSprite;
var tree:FlxSprite;
var tree2:FlxSprite;
var tree3:FlxSprite;
var grass:FlxSprite;
var ded1:FlxSprite;
var ded2:FlxSprite;
var ded3:FlxSprite;
var bush:FlxSprite;

function onLoad() {
    sky = new FlxSprite(0, 300).loadGraphic(Paths.image('stages/exe/sky'));
    sky.scale.set(1.4, 1.4);
    sky.updateHitbox();
    add(sky);

    moon = new FlxSprite(0, 300).loadGraphic(Paths.image('stages/exe/moon'));
    moon.scale.set(1.4, 1.4);
    moon.updateHitbox();
    add(moon);

    mountain = new FlxSprite(0, 300).loadGraphic(Paths.image('stages/exe/mountain'));
    mountain.scale.set(1.4, 1.4);
    mountain.updateHitbox();
    add(mountain);

    tree = new FlxSprite(0, 300).loadGraphic(Paths.image('stages/exe/tree'));
    tree.scale.set(1.4, 1.4);
    tree.updateHitbox();
    add(tree);

    tree2 = new FlxSprite(0, 300).loadGraphic(Paths.image('stages/exe/tree2'));
    tree2.scale.set(1.4, 1.4);
    tree2.updateHitbox();
    add(tree2);

    tree3 = new FlxSprite(0, 300).loadGraphic(Paths.image('stages/exe/tree3'));
    tree3.scale.set(1.4, 1.4);
    tree3.updateHitbox();
    add(tree3);

    grass = new FlxSprite(0, 300).loadGraphic(Paths.image('stages/exe/grass'));
    grass.scale.set(1.4, 1.4);
    grass.updateHitbox();
    add(grass);

    ded1 = new FlxSprite(0, 300).loadGraphic(Paths.image('stages/exe/dedbuddy'));
    ded1.scale.set(1.4, 1.4);
    ded1.updateHitbox();
    add(ded1);

    ded2 = new FlxSprite(0, 300).loadGraphic(Paths.image('stages/exe/brosonkillingspree'));
    ded2.scale.set(1.4, 1.4);
    ded2.updateHitbox();
    add(ded2);
}

function onCreatePost() {
    ded3 = new FlxSprite(0, 300).loadGraphic(Paths.image('stages/exe/dedbuddyagain'));
    ded3.scale.set(1.4, 1.4);
    ded3.updateHitbox();
    add(ded3);

    bush = new FlxSprite(0, 300).loadGraphic(Paths.image('stages/exe/bush'));
    bush.scale.set(1.4, 1.4);
    bush.updateHitbox();
    add(bush);

    playHUD.timeBar.setColors(0xFF86769D, FlxColor.BLACK);
    playHUD.scoreTxt.color = 0xFF86769D;
}