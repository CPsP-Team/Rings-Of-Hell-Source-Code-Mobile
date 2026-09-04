import flixel.addons.display.FlxBackdrop;

// Day (Faker)
var sky:FlxSprite;
var ms:FlxSprite;
var clouds:FlxBackdrop;
var cliffs1:FlxSprite;
var cliffs2:FlxSprite;
var grass:FlxSprite;
var water:FlxSprite;
var fireballs:FlxSprite;

// Night (Eyx)
var sky_n:FlxSprite;
var ms_n:FlxSprite;
var clouds_n:FlxBackdrop;
var cliffs1_n:FlxSprite;
var cliffs2_n:FlxSprite;
var grass_n:FlxSprite;
var water_n:FlxSprite;
var darkness:FlxSprite;

function onLoad() {
  fakerLmao();
  eyxBalls();
  // initScript('scripts/eyxHud');
}

function onCreatePost() {
    playHUD.timeBar.setColors(0xFF3F5A6B, FlxColor.BLACK);
    playHUD.scoreTxt.color = 0xFF3F5A6B;
}

function fakerLmao() {
    sky = new FlxSprite(-250, -750).loadGraphic(Paths.image('stages/crystal-lake/day/sky'));
    sky.antialiasing = ClientPrefs.globalAntialiasing;
    sky.scale.set(0.9, 0.9);
    sky.blend = BlendMode.ADD;
    sky.updateHitbox();
    
    ms = new FlxSprite(-250, -750).loadGraphic(Paths.image('stages/crystal-lake/day/mountain'));
    ms.antialiasing = ClientPrefs.globalAntialiasing;
    ms.scale.set(0.9, 0.9);
    ms.updateHitbox();
    
    clouds = new FlxBackdrop(Paths.image('stages/crystal-lake/day/clouds'));
    //clouds.repeatAxes = FlxAxes.X;
    //clouds.antialiasing = ClientPrefs.globalAntialiasing;
    clouds.setPosition(-250, -750);
    clouds.scale.set(0.9, 0.9);
    clouds.alpha = 0.8;
    //clouds.updateHitbox();
    clouds.velocity.x = -40; 

    cliffs1 = new FlxSprite(-250, -750).loadGraphic(Paths.image('stages/crystal-lake/day/cliffs1'));
    cliffs1.antialiasing = ClientPrefs.globalAntialiasing;
    cliffs1.scale.set(0.9, 0.9);
    cliffs1.updateHitbox();
    add(cliffs1);
    
    cliffs2 = new FlxSprite(-250, -750).loadGraphic(Paths.image('stages/crystal-lake/day/cliffs2'));
    cliffs2.antialiasing = ClientPrefs.globalAntialiasing;
    cliffs2.scale.set(0.9, 0.9);
    cliffs2.updateHitbox();

    grass = new FlxSprite(-250, -750).loadGraphic(Paths.image('stages/crystal-lake/day/grass'));
    grass.antialiasing = ClientPrefs.globalAntialiasing;
    grass.scale.set(0.9, 0.9);
    grass.updateHitbox();

    water = new FlxSprite(-250, -750).loadGraphic(Paths.image('stages/crystal-lake/day/water'));
    water.antialiasing = ClientPrefs.globalAntialiasing;
    water.scale.set(0.9, 0.9);
    water.updateHitbox();
    fireballs = new FlxSprite(-250, -750).loadGraphic(Paths.image('stages/crystal-lake/day/fireballs'));
    fireballs.antialiasing = ClientPrefs.globalAntialiasing;
    fireballs.scale.set(0.9, 0.9);
    fireballs.updateHitbox();
    fireballs.blend = BlendMode.ADD;

    add(sky);
    add(ms);
    add(clouds);
    add(cliffs1);
    add(cliffs2);
    add(grass);
    add(water);
    add(fireballs);
}

function eyxBalls() {
    sky_n = new FlxSprite(-250, -750).loadGraphic(Paths.image('stages/crystal-lake/night/sky'));
    sky_n.antialiasing = ClientPrefs.globalAntialiasing;
    sky_n.scale.set(0.9, 0.9);
    sky_n.updateHitbox();

    ms_n = new FlxSprite(-250, -750).loadGraphic(Paths.image('stages/crystal-lake/night/mountain'));
    ms_n.antialiasing = ClientPrefs.globalAntialiasing;
    ms_n.scale.set(0.9, 0.9);
    ms_n.updateHitbox();

    clouds_n = new FlxBackdrop(Paths.image('stages/crystal-lake/night/clouds'));
    clouds_n.antialiasing = ClientPrefs.globalAntialiasing;
    clouds_n.setPosition(-250, -750);
    clouds_n.updateHitbox();
    clouds_n.velocity.x = -40;

    cliffs1_n = new FlxSprite(-250, -750).loadGraphic(Paths.image('stages/crystal-lake/night/cliffs1'));
    cliffs1_n.antialiasing = ClientPrefs.globalAntialiasing;
    cliffs1_n.scale.set(0.9, 0.9);
    cliffs1_n.updateHitbox();

    cliffs2_n = new FlxSprite(-250, -750).loadGraphic(Paths.image('stages/crystal-lake/night/cliffs2'));
    cliffs2_n.antialiasing = ClientPrefs.globalAntialiasing;
    cliffs2_n.scale.set(0.9, 0.9);
    cliffs2_n.updateHitbox();

    grass_n = new FlxSprite(-250, -750).loadGraphic(Paths.image('stages/crystal-lake/night/grass'));
    grass_n.antialiasing = ClientPrefs.globalAntialiasing;
    grass_n.scale.set(0.9, 0.9);
    grass_n.updateHitbox();

    water_n = new FlxSprite(-250, -750).loadGraphic(Paths.image('stages/crystal-lake/night/water'));
    water_n.antialiasing = ClientPrefs.globalAntialiasing;
    water_n.scale.set(0.9, 0.9);
    water_n.updateHitbox();
    
    darkness = new FlxSprite(-250, -750).loadGraphic(Paths.image('stages/crystal-lake/night/darkness'));
    darkness.antialiasing = ClientPrefs.globalAntialiasing;
    darkness.scale.set(0.9, 0.9);
    darkness.updateHitbox();
	
	for (sprite in [sky_n, ms_n, clouds_n, cliffs1_n, cliffs2_n, grass_n, water_n, darkness])
		sprite.alpha = 0.00001;

    add(sky_n);
    add(ms_n);
    add(clouds_n);
    add(cliffs1_n);
    add(cliffs2_n);
    add(grass_n);
    add(water_n);
    add(darkness);
}

function onStepHit() {
  if (game.curStep == 1352) 
  {
		for (spr in [sky, clouds, ms, cliffs1, cliffs2, grass, water, fireballs])
			remove(spr, true);

		for (sprite in [sky_n, ms_n, clouds_n, cliffs1_n, cliffs2_n, grass_n, water_n, darkness])
			sprite.alpha = 1;
	}
}
