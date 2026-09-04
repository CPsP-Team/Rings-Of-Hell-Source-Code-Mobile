import funkin.states.MainMenuState;
import funkin.utils.MathUtil;
import flixel.text.FlxText;
import flixel.group.FlxGroup.FlxTypedGroup;
import flixel.math.FlxMath;
import flixel.effects.FlxFlicker;
import funkin.game.shaders.CheckerboardShader;
import flixel.addons.display.FlxBackdrop;
import funkin.FunkinAssets;

var xval:Int = 25;
var rightPaneX:Float = 520;
var rowHeight:Float = 90;

var menuItems:FlxTypedGroup<FlxText>;
var creditGroup:FlxTypedGroup<FlxSprite>;
var creditTextGroup:FlxTypedGroup<FlxText>;

final optionShit:Array<String> = ['Artists', 'Programmers', 'Composers', 'Charters', 'VAs', 'Extra'];

// was gonna add this as part of an desc, but whatever
final flags:Map<String, String> = [
	'us' => 'United States',
	'ua' => 'Ukraine'
];

// Format: ['Name', 'IconKey', 'Role', 'FlagKey', 'Link', 'Description']
// I don't feel like rewriting the description to be in the correct spot, I'm tired
final creditsData:Map<String, Array<Array<String>>> = [
	'Artists' => [
		['EduMakesStuff (Inski)', 'MrEMS91', 'Owner, Artist', 'mx', 'https://www.youtube.com/@inski-fansonic99'],
        ['The Gosha', 'gosha', 'Lead Artist, Animator', 'ru', 'https://www.youtube.com/@the-gosha360'],
        ['Lakris', 'lakris', 'Lead Artist', 'ru', 'https://www.youtube.com/@Lakris44'],
        ['HyperDream', 'HyperDream', 'Artist', 'mn', 'https://youtube.com/@hyperisdreaming'],
        ['Steven', 'steven', 'Artist, Animator', 'br', 'https://youtube.com/@thestevenoficial?si=RQIxQhd3t1SuF3Rc'],
        ['Caua G.546', 'Caua', 'Artist', 'br', 'https://www.youtube.com/@cauag.546'],
		['MaysLastPlay', 'mays', 'Owner, Artist', 'ua', 'https://twitter.com/mayslastplay'],
        ['Xenz', 'minineo', 'Artist, Animator', null, 'https://youtube.com/@mini_neooo?si=CEmOrwSBkx5YS4hR'] 
	],
	'Programmers' => [
		['MaysLastPlay', 'mays', 'Owner, Lead Coder', 'ua', 'https://twitter.com/mayslastplay'],
		['Moxie-coder', 'moxie', 'Coder', 'us', 'https://github.com/moxie-coder', 'Chuu chuu~!!'],
        ['JustX', 'jason', 'Coder', 'uz', 'https://github.com/GreenColdTea'],
        ['LumixX', 'lumixx', 'Coder, Animator', 'us', 'https://youtube.com/@lumix-m7s?si=j1vgIAmL6Gthgz77'],
        ['LJeno', '2jeno', 'Coder', 'kr', 'https://youtube.com/@ljenosmusic?si=3R89zeiWKTKJRWPw'],
        ['Inakuro', 'inakuro', 'Coder', 'us', 'https://youtube.com/@inakuroashigawa?si=b-lZN1yrEYmmAMay'],
        ['StarNova', 'starnova', 'Coder', 'br', 'https://youtube.com/@starnovaoficial?si=dza2O2VJspuOJL_T'],
        ['MarioMaster', 'MasterX', 'Coder', null, 'https://youtube.com/@MarioMaster39']
	],
	'Composers' => [
        ['JayQewTwoYouTube', null, 'Musician', 'us', 'https://youtube.com/@jqssoundtest?si=cVoy7lCCaDkWw8Zx'],
        ['Hectuah', 'hec', 'Musician', 'us', 'https://www.youtube.com/@Hectort-k6k'],
        ['Grimbean', 'grimbean', 'Musician', 'ph', 'https://www.youtube.com/channel/UCHL-c0kltDHVzm4uX2S1pCQ'],
        ['LJeno', '2jeno', 'Musician', 'kr', 'https://youtube.com/@ljenosmusic?si=3R89zeiWKTKJRWPw']
        ],
	'Charters' => [
        ['Starszinark', 'Starszinark', 'Co-Owner, Charter', 'us', 'https://www.youtube.com/@Starszinark'],
        ['Cherrinum', 'cherrinum', 'Co-Owner, Charter', 'us', 'https://www.youtube.com/@The-Cherrie'],
        ['deh4nk', 'deh4nk', 'Charter', 'ru', 'https://www.youtube.com/@AleXDK_fnf'],
        ['Obscuryth', 'obscuryth', 'Charter', 'hu', 'https://obscuryth.carrd.co/'],
        ['Xenz', 'minineo', 'Charter', null, 'https://youtube.com/@mini_neooo?si=CEmOrwSBkx5YS4hR']
        ],
	'VAs' => [
        ['EduMakesStuff (Inski)', 'MrEMS91', 'Owner, Voice Actor', 'mx', 'https://www.youtube.com/@inski-fansonic99'],
        ['Grimbean', 'grimbean', 'Voice Actor', 'ph', 'https://www.youtube.com/channel/UCHL-c0kltDHVzm4uX2S1pCQ'],
        ['LJeno', '2jeno', 'Voice Actor', 'kr', 'https://youtube.com/@ljenosmusic?si=3R89zeiWKTKJRWPw'],
        ['Oblivian', 'oblivian', 'Voice Actor', null, 'https://open.spotify.com/user/3177ygrzc5itxouc2jk4kagvjeiy'],
        ['The Gosha', 'gosha', 'Voice Actor', 'ru', 'https://www.youtube.com/@the-gosha360']
    ],
	'Extra' => [
        ['Special Thanks'],
        ['Waeavy', 'lapte', 'Tester', null, 'https://www.youtube.com/@weanugget'],
        ['Elithios', 'elithios', 'Interweb Guest', 'be', 'https://www.youtube.com/@elithios_exe'],
        ['Ruisna', 'Ruisna', 'Interweb Guest', 'mx', 'https://www.youtube.com/@Ruisna'],
        ['NMV Team', 'nmv', 'NightmareVision Engine', null, 'https://github.com/NMVTeam/NightmareVision'],
        ['Twitter Inc. and other contributors', 'twitter', null, null, 'https://github.com/twitter/twemoji', 'Flag Icons used from Twemoji']
    ]
];

var bg:FlxSprite;
var bars:FlxSprite;
var bars2:FlxSprite;
var title:FlxSprite;

var blackDim:FlxSprite;
var blackSpr:FlxBackdrop;
var checkerShader:CheckerboardShader;

var curSelected:Int = 0;
var curCreditSelected:Int = 0;
var inCategory:Bool = false;
var isFlickering:Bool = false;

var scrollY:Float = 0;
var targetScrollY:Float = 0;
var currentCategoryLength:Int = 0;

var curAlpha:Float = 0;
var blackDimFade:Float = 0.000001;

final paddingShit:Float = 170;

var flagGroup:FlxTypedGroup<FlxSprite>;
var currentCategoryLinks:Array<String> = [];

var descBox:FlxSprite;
var descText:FlxText;
var currentRawList:Array<Array<String>> = [];

function isTitle(entry:Array<String>):Bool {
	return entry == null || entry.length <= 1;
}

function getVal(entry:Array<String>, index:Int, ?fallback:String = ''):String {
	if (entry != null && index < entry.length && entry[index] != null)
		return entry[index];

	return fallback;
}

function onLoad()
{
    FunkinAssets.cache.clearStoredMemory();
	FunkinAssets.cache.clearUnusedMemory();

	persistentUpdate = true;
	persistentDraw = true;

	bg = new FlxSprite().loadGraphic(Paths.image('menus/menuDesat'));
	bg.screenCenter();
	add(bg);

	blackSpr = new FlxBackdrop(FlxAxes.XY, 0.2, 0.2).makeGraphic(FlxG.width * 3, FlxG.height * 3, FlxColor.BLACK);
	blackSpr.scrollFactor.set(0.07, 0);
	add(blackSpr);

	// just so you can see the credits better, and adds some style
	blackDim = new FlxSprite(FlxG.width, FlxG.height).makeGraphic(FlxG.width * 3, FlxG.height * 3, FlxColor.BLACK);
	blackDim.scrollFactor.set(0, 0);
	blackDim.screenCenter(FlxAxes.XY);
	blackDim.alpha = 0.000001;
	
	checkerShader = new CheckerboardShader();
	checkerShader.uSpeed.value = [0.1];
	checkerShader.uSize.value = [32.0];
	// blackDim.shader = checkerShader;
	blackSpr.shader = checkerShader;
	add(blackDim);

	bars = new FlxSprite(0, 0).loadGraphic(Paths.image('menus/credits/bar'));
	bars.scrollFactor.set(0, 0);
	bars.antialiasing = ClientPrefs.globalAntialiasing;
	add(bars);

	bars2 = new FlxSprite(0, -50).loadGraphic(Paths.image('menus/credits/menus'));
	bars2.scrollFactor.set(0, 0);
	bars2.antialiasing = ClientPrefs.globalAntialiasing;
	bars2.scale.set(1, 1.5);
	add(bars2);

	title = new FlxSprite(0, -100).loadGraphic(Paths.image('menus/credits/title'));
	title.scrollFactor.set(0, 0);
	title.antialiasing = ClientPrefs.globalAntialiasing;
	add(title);

	menuItems = new FlxTypedGroup();
	add(menuItems);

	creditGroup = new FlxTypedGroup();
	add(creditGroup);

	flagGroup = new FlxTypedGroup();
	add(flagGroup);

	creditTextGroup = new FlxTypedGroup();
	add(creditTextGroup);
	
	descBox = new FlxSprite(0, FlxG.height - 75).makeGraphic(1, 1, FlxColor.BLACK);
	descBox.alpha = 0.6;
	descBox.visible = false;
	add(descBox);

	descText = new FlxText(50, FlxG.height - 65, FlxG.width - 100, "", 20);
	descText.setFormat(Paths.font('PressStart2P.ttf'), 16, FlxColor.WHITE, FlxTextAlign.CENTER, FlxTextBorderStyle.OUTLINE, FlxColor.BLACK);
	descText.visible = false;
	add(descText);

	for (i in 0...optionShit.length)
	{
		var offset:Float = 400 - (Math.max(optionShit.length, 4) - 4) * 20;
		final menuItem:FlxText = new FlxText(xval, (i * 55) + offset, 0, optionShit[i], 32);
		menuItem.setFormat(Paths.font('PressStart2P.ttf'), 28, FlxColor.WHITE, FlxTextAlign.LEFT, FlxTextBorderStyle.OUTLINE, FlxColor.BLACK);
		menuItem.ID = i;
		menuItem.antialiasing = ClientPrefs.globalAntialiasing;
		menuItems.add(menuItem);
	}

	updateMenuHighlight();
}

function onUpdate(elapsed:Float)
{
	// MUST BE AT THE TOP OTHERWISE IT WON'T RUN
	curAlpha = FlxMath.lerp(curAlpha, blackDimFade, elapsed * 5);
	blackDim.alpha = curAlpha;

	blackSpr.x -= 0.45 / (ClientPrefs.framerate / 60);
	blackSpr.y -= 0.16 / (ClientPrefs.framerate / 60);

	if (checkerShader != null)
		checkerShader.update(elapsed);

	if (inCategory)
	{
		if (isFlickering) return;
	
		if (controls.BACK || FlxG.keys.justPressed.ESCAPE || FlxG.keys.justPressed.BACKSPACE)
		{
			FlxG.sound.play(Paths.sound('cancelMenu'));
			closeCategory();
			return;
		}

		if (controls.UI_UP_P || FlxG.keys.justPressed.UP) changeCreditSelection(-1);
		else if (controls.UI_DOWN_P || FlxG.keys.justPressed.DOWN) changeCreditSelection(1);

		if (controls.ACCEPT || FlxG.keys.justPressed.ENTER || FlxG.keys.justPressed.SPACE)
		{
			final url = currentCategoryLinks[curCreditSelected];
			if (url != null && url.length > 0)
			{
				FlxG.sound.play(Paths.sound('confirmMenu'));
				isFlickering = true;

				final targetText = creditTextGroup.members[curCreditSelected];
				final targetIcon = creditGroup.members[curCreditSelected];
				final targetFlag = flagGroup.members[curCreditSelected];

				if (targetIcon != null && targetIcon.visible) FlxFlicker.flicker(targetIcon, 0.5, 0.06, true, true);
				if (targetFlag != null && targetFlag.visible) FlxFlicker.flicker(targetFlag, 0.5, 0.06, true, true);

				if (targetText != null)
				{
					FlxFlicker.flicker(targetText, 0.5, 0.06, true, true, function(flicker)
					{
						CoolUtil.browserLoad(url);
						isFlickering = false;
					});
				}
				else
				{
					CoolUtil.browserLoad(url);
					isFlickering = false;
				}
			}
		}

		scrollY = FlxMath.lerp(scrollY, targetScrollY, elapsed * 12);
		updateCreditPositions();
		return;
	}

	if (controls.BACK || FlxG.keys.justPressed.ESCAPE || FlxG.keys.justPressed.BACKSPACE)
	{
		FlxG.sound.play(Paths.sound('cancelMenu'));
		FlxG.switchState(new MainMenuState());
		return;
	}
	// TODO: mouse input
	if (controls.UI_UP_P || FlxG.keys.justPressed.UP) changeSelection(-1);
	else if (controls.UI_DOWN_P || FlxG.keys.justPressed.DOWN) changeSelection(1);

	if (controls.ACCEPT || FlxG.keys.justPressed.ENTER || FlxG.keys.justPressed.SPACE)
	{
		FlxG.sound.play(Paths.sound('confirmMenu'));
		openCategory(optionShit[curSelected]);
	}
}

function changeSelection(change:Int)
{
	FlxG.sound.play(Paths.sound('scrollMenu'));
	curSelected = (curSelected + change + optionShit.length) % optionShit.length;
	updateMenuHighlight();
}

function changeCreditSelection(change:Int)
{
	if (currentCategoryLength <= 0) return;
	
	if (descText != null)
	{
		descText.text = credits[curSelected].description;
		descText.y = FlxG.height - descText.height + descYOffset - 60;
		
		FlxTween.cancelTweensOf(descText, ['y']);
		FlxTween.tween(descText, {y: descText.y + 75}, 0.25, {ease: FlxEase.sineOut});
		
		if (descBox != null)
		{
			descBox.setGraphicSize(Std.int(descText.width + 20), Std.int(descText.height + 25));
			descBox.updateHitbox();
		}
	}
	
	FlxG.sound.play(Paths.sound('scrollMenu'));
	curCreditSelected = MathUtil.clamp(curCreditSelected + change, 0, currentCategoryLength - 1);
	targetScrollY = -curCreditSelected * rowHeight;
}

function updateMenuHighlight()
{
	menuItems.forEach(function(item:FlxText)
	{
		item.color = (item.ID == curSelected) ? FlxColor.YELLOW : FlxColor.WHITE;
	});
}

function openCategory(category:String)
{
	inCategory = true;
	curCreditSelected = 0;
	scrollY = 0;
	targetScrollY = 0;

	creditGroup.clear();
	flagGroup.clear();
	creditTextGroup.clear();
	currentCategoryLinks = [];

	blackDimFade = 0.7;

	currentRawList = creditsData.exists(category) ? creditsData.get(category) : [];
	currentCategoryLength = currentRawList.length;

	for (i in 0...currentRawList.length)
	{
		final entry = currentRawList[i];
		final name = getVal(entry, 0);
		final iconKey = getVal(entry, 1);
		final role = getVal(entry, 2, '');
		final flag = getVal(entry, 3);
		final link = getVal(entry, 4);

		currentCategoryLinks.push(link);

		if (isTitle(entry))
		{
			var emptyFlag = new FlxSprite();
			emptyFlag.visible = false;
			flagGroup.add(emptyFlag);

			var emptyIcon = new FlxSprite();
			emptyIcon.visible = false;
			creditGroup.add(emptyIcon);

			final titleText:FlxText = new FlxText(rightPaneX, 180 + (i * rowHeight), 500, '--- ' + name + ' ---', 20);
			titleText.setFormat(Paths.font('PressStart2P.ttf'), 20, FlxColor.YELLOW, FlxTextAlign.CENTER, FlxTextBorderStyle.OUTLINE, FlxColor.BLACK);
			titleText.antialiasing = ClientPrefs.globalAntialiasing;
			creditTextGroup.add(titleText);
			continue;
		}

		final flagSprite:FlxSprite = new FlxSprite(rightPaneX + paddingShit - 50, 180 + (i * rowHeight));
		if (flag != '' && Paths.fileExists('images/credits/flags/' + flag + '.png'))
		{
			flagSprite.loadGraphic(Paths.image('credits/flags/' + flag));
			flagSprite.setGraphicSize(40, 28);
			flagSprite.updateHitbox();
		}
		else
		{
			flagSprite.visible = false;
		}
		flagGroup.add(flagSprite);

		final icon:FlxSprite = new FlxSprite(rightPaneX + paddingShit, 180 + (i * rowHeight));
		if (Paths.fileExists('images/credits/' + iconKey + '.png'))
			icon.loadGraphic(Paths.image('credits/' + iconKey));
		else
			icon.loadGraphic(Paths.image('credits/missing'));

		icon.setGraphicSize(60, 60);
		icon.updateHitbox();
		creditGroup.add(icon);

		final text:FlxText = new FlxText(rightPaneX + paddingShit + 75, 180 + (i * rowHeight), 500, name + '\n' + role, 18);
		text.setFormat(Paths.font('PressStart2P.ttf'), 18, FlxColor.WHITE, FlxTextAlign.LEFT, FlxTextBorderStyle.OUTLINE, FlxColor.BLACK);
		text.antialiasing = ClientPrefs.globalAntialiasing;
		creditTextGroup.add(text);
	}

	updateExtendedDesc();
}

function changeCreditSelection(change:Int)
{
	if (currentCategoryLength <= 0) return;

	FlxG.sound.play(Paths.sound('scrollMenu'));
	curCreditSelected = MathUtil.clamp(curCreditSelected + change, 0, currentCategoryLength - 1);
	targetScrollY = -curCreditSelected * rowHeight;

	updateExtendedDesc();
}

function updateExtendedDesc()
{
	if (!inCategory || currentRawList.length <= 0)
	{
		descBox.visible = false;
		descText.visible = false;
		return;
	}

	final currentEntry = currentRawList[curCreditSelected];
	final extendedDesc:String = getVal(currentEntry, 5);
	
	if (extendedDesc == null)
	{
		descBox.visible = false;
		descText.visible = false;
		return;
	}

	if (extendedDesc == '' || extendedDesc != null && extendedDesc.length <= 0)
	{
		descBox.visible = false;
		descText.visible = false;
		return;
	}

	descText.text = extendedDesc ?? '';
	descText.visible = true;
	descBox.visible = true;

	descBox.setGraphicSize(Std.int(descText.width + 30), Std.int(descText.height + 20));
	descBox.updateHitbox();
	descBox.screenCenter(FlxAxes.X);
	descBox.y = descText.y - 10;
}

function updateCreditPositions()
{
	for (i in 0...currentCategoryLength)
	{
		final baseY = 180 + (i * rowHeight) + scrollY;

		var icon = creditGroup.members[i];
		var flag = flagGroup.members[i];
		var text = creditTextGroup.members[i];

		if (icon != null) icon.y = baseY;
		if (flag != null) flag.y = baseY + 16; // Centers 28px flag vertically against 60px icon
		if (text != null)
		{
			text.y = baseY;
			text.color = (i == curCreditSelected) ? FlxColor.YELLOW : FlxColor.WHITE;
		}
	}
}

function closeCategory()
{
	inCategory = false;
	isFlickering = false;
	creditGroup.clear();
	flagGroup.clear();
	creditTextGroup.clear();
	currentCategoryLinks = [];
	currentRawList = [];

	descBox.visible = false;
	descText.visible = false;
	blackDimFade = 0.000001;
}