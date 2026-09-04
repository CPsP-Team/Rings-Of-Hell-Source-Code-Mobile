// Stage
var grass:FlxSprite;
var boxMogus:FlxSprite;
var slimeMogus:FlxSprite;
var box:FlxSprite;
var light:FlxSprite;
var particles:FlxSprite;

function onLoad()
{
	amogusStage();
}

function amogusStage()
{
	grass = new FlxSprite(-500, -250).loadGraphic(Paths.image('stages/the-fungle/grass'));
	add(grass);

	boxMogus = new FlxSprite(-120, 385);
	boxMogus.frames = Paths.getSparrowAtlas('stages/the-fungle/bgmogus_box');
	boxMogus.animation.addByPrefix('idle', 'bgmogus Vibin', 24, true);
	boxMogus.animation.play('idle');
	boxMogus.scale.set(0.25, 0.25);
	boxMogus.updateHitbox();
	add(boxMogus);

	slimeMogus = new FlxSprite(775, 420);
	slimeMogus.frames = Paths.getSparrowAtlas('stages/the-fungle/bgmogus_slime');
	slimeMogus.animation.addByPrefix('idle', 'bgmogus Vibin', 24, true);
	slimeMogus.animation.play('idle');
	slimeMogus.scale.set(0.25, 0.25);
	slimeMogus.updateHitbox();
	add(slimeMogus);

	box = new FlxSprite(-500, -250).loadGraphic(Paths.image('stages/the-fungle/box'));

	light = new FlxSprite(-500, -250).loadGraphic(Paths.image('stages/the-fungle/light'));
	light.scrollFactor.set(0.8, 0.8);
	light.blend = BlendMode.ADD;

	particles = new FlxSprite(-500, -250).loadGraphic(Paths.image('stages/the-fungle/particles'));
	particles.scale.set(1, 1);
	particles.updateHitbox();
	particles.scrollFactor.set(0.8, 0.8);
	particles.blend = BlendMode.SCREEN;
}

function onCreatePost()
{
	add(box);
	add(light);
	add(particles);
}