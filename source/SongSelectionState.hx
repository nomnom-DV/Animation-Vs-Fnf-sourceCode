package;

#if desktop
import Discord.DiscordClient;
#end
import flixel.FlxG;
import flixel.FlxObject;
import flixel.FlxSprite;
import flixel.FlxCamera;
import flixel.addons.transition.FlxTransitionableState;
import flixel.effects.FlxFlicker;
import flixel.graphics.frames.FlxAtlasFrames;
import flixel.group.FlxGroup.FlxTypedGroup;
import flixel.text.FlxText;
import flixel.math.FlxMath;
import flixel.tweens.FlxEase;
import flixel.tweens.FlxTween;
import flixel.util.FlxColor;
import lime.app.Application;
import Achievements;
import editors.MasterEditorMenu;
import flixel.input.keyboard.FlxKey;
import flixel.util.FlxTimer;
import flixel.ui.FlxSpriteButton;

using StringTools;

class SongSelectionState extends MusicBeatState
{
	public static var psychEngineVersion:String = '0.5'; //This is also used for Discord RPC
	public static var curSelected:Int = 0;

	var menuItems:FlxTypedGroup<FlxSprite>;
	private var camGame:FlxCamera;
	private var camAchievement:FlxCamera;

	var menuInfomation:FlxText;
	var greenName:FlxText;
	var blueName:FlxText;
	
	var optionShit:Array<String> = [
		'gren',
		'blue'
	];

	var magenta:FlxSprite;
	var camFollow:FlxObject;
	var camFollowPos:FlxObject;
	var debugKeys:Array<FlxKey>;

	var codeMenu:FlxSpriteButton;

	var bg:FlxSprite;

	override function create()
	{
		#if desktop
		// Updating Discord Rich Presence
		DiscordClient.changePresence("In the Menus", null);
		#end

		WeekData.setDirectoryFromWeek();
		debugKeys = ClientPrefs.copyKey(ClientPrefs.keyBinds.get('debug_1'));

		camGame = new FlxCamera();
		camAchievement = new FlxCamera();
		camAchievement.bgColor.alpha = 0;

		FlxG.cameras.reset(camGame);
		FlxG.cameras.add(camAchievement);
		FlxCamera.defaultCameras = [camGame];

		transIn = FlxTransitionableState.defaultTransIn;
		transOut = FlxTransitionableState.defaultTransOut;

		persistentUpdate = persistentDraw = true;

		var yScroll:Float = Math.max(0.25 - (0.05 * (optionShit.length - 4)), 0.1);
		bg = new FlxSprite(-80).loadGraphic(Paths.image('menuBG'));
		bg.scale.set(0.622, 0.622);
		bg.scrollFactor.set(0, yScroll);
		bg.updateHitbox();
		bg.screenCenter();
		bg.y += 75;
		bg.x += 15;
		bg.antialiasing = ClientPrefs.globalAntialiasing;
		add(bg);

		camFollow = new FlxObject(0, 0, 1, 1);
		camFollowPos = new FlxObject(0, 0, 1, 1);
		add(camFollow);
		add(camFollowPos);

		magenta = new FlxSprite(-80).loadGraphic(Paths.image('menuBG'));
		magenta.scrollFactor.set(0, yScroll);
		magenta.setGraphicSize(Std.int(magenta.width * 1.175));
		magenta.updateHitbox();
		magenta.screenCenter();
		magenta.visible = false;
		magenta.antialiasing = ClientPrefs.globalAntialiasing;
		magenta.color = 0xFFfd719b;
		add(magenta);
		// magenta.scrollFactor.set();

		menuItems = new FlxTypedGroup<FlxSprite>();
		add(menuItems);

		var greenItem:FlxSprite = new FlxSprite(700, 70);
		greenItem.frames = Paths.getSparrowAtlas('mainmenu/menu_gren');
		greenItem.scale.set(0.45, 0.45);
		greenItem.animation.addByPrefix('idle', optionShit[0] + " basic", 24);
		greenItem.animation.addByPrefix('selected', optionShit[0] + " white", 24);
		greenItem.animation.play('idle');
		greenItem.ID = 0;
		menuItems.add(greenItem);
		greenItem.scrollFactor.set();
		greenItem.antialiasing = ClientPrefs.globalAntialiasing;
		greenItem.updateHitbox();
		greenItem.screenCenter();
		greenItem.y += 25;

		var blueItem:FlxSprite = new FlxSprite(700, 50);
		blueItem.frames = Paths.getSparrowAtlas('mainmenu/menu_blue');
		blueItem.scale.set(0.45, 0.45);
		blueItem.animation.addByPrefix('idle', optionShit[1] + " basic", 24);
		blueItem.animation.addByPrefix('selected', optionShit[1] + " white", 24);
		blueItem.animation.play('idle');
		blueItem.ID = 1;
		menuItems.add(blueItem);
		blueItem.scrollFactor.set();
		blueItem.antialiasing = ClientPrefs.globalAntialiasing;
		blueItem.updateHitbox();
		blueItem.screenCenter();

		menuInfomation = new FlxText(110, 675, 1000, "Select a Song.", 28);
		menuInfomation.setFormat("VCR OSD Mono", 28, FlxColor.WHITE, CENTER, FlxTextBorderStyle.OUTLINE, FlxColor.BLACK);
		menuInfomation.scrollFactor.set(0, 0);
		menuInfomation.borderSize = 2;
		add(menuInfomation);

		greenName = new FlxText(110, 675, 1000, "Stickin To It", 28);
		greenName.setFormat("VCR OSD Mono", 28, FlxColor.WHITE, CENTER, FlxTextBorderStyle.OUTLINE, FlxColor.BLACK);
		greenName.x += 300;
		greenName.y -= 625;
		greenName.scrollFactor.set(0, 0);
		greenName.borderSize = 2;
		greenName.scale.set(0.9, 0.9);
		greenName.alpha = 0.5;
		add(greenName);

		blueName = new FlxText(110, 675, 1000, "Mastermind", 28);
		blueName.setFormat("VCR OSD Mono", 28, FlxColor.WHITE, CENTER, FlxTextBorderStyle.OUTLINE, FlxColor.BLACK);
		blueName.x -= 250;
		blueName.y -= 625;
		blueName.scrollFactor.set(0, 0);
		blueName.borderSize = 2;
		blueName.scale.set(0.9, 0.9);
		blueName.alpha = 0.5;
		add(blueName);

		/*var creditsItem:FlxSprite = new FlxSprite(700, 50);
		creditsItem.frames = Paths.getSparrowAtlas('mainmenu/menu_credits');
		creditsItem.scale.set(0.25, 0.26);
		creditsItem.animation.addByPrefix('idle', optionShit[2] + " basic", 24);
		creditsItem.animation.addByPrefix('selected', optionShit[2] + " white", 24);
		creditsItem.animation.play('idle');
		creditsItem.ID = 2;
		//menuItems.add(creditsItem);
		creditsItem.scrollFactor.set();
		creditsItem.antialiasing = ClientPrefs.globalAntialiasing;
		creditsItem.updateHitbox();
		creditsItem.screenCenter();
		creditsItem.x += 270;
		creditsItem.y += 100;
		*/

		/*var optionsItem:FlxSprite = new FlxSprite(700, 50);
		optionsItem.frames = Paths.getSparrowAtlas('mainmenu/menu_options');
		optionsItem.scale.set(0.25, 0.25);
		optionsItem.animation.addByPrefix('idle', optionShit[3] + " basic", 24);
		optionsItem.animation.addByPrefix('selected', optionShit[3] + " white", 24);
		optionsItem.animation.play('idle');
		optionsItem.ID = 3;
		//menuItems.add(optionsItem);
		optionsItem.scrollFactor.set();
		optionsItem.antialiasing = ClientPrefs.globalAntialiasing;
		optionsItem.updateHitbox();
		optionsItem.screenCenter();
		optionsItem.x += 30;
		optionsItem.y += 225;
		*/

		codeMenu = new FlxSpriteButton(875, 452, null, function()
            {
                codeMenuClick();
            });
            codeMenu.screenCenter();
            codeMenu.y -= 250;
            codeMenu.x -= 5;
            codeMenu.width = 388;
            codeMenu.height = 78;
            codeMenu.updateHitbox();
            codeMenu.visible = false;
            //add(codeMenu);

		FlxG.camera.follow(camFollowPos, null, 1);

		var versionShit:FlxText = new FlxText(12, FlxG.height - 44, 0, "Psych Engine v" + psychEngineVersion, 12);
		versionShit.scrollFactor.set();
		versionShit.setFormat("VCR OSD Mono", 16, FlxColor.WHITE, LEFT, FlxTextBorderStyle.OUTLINE, FlxColor.BLACK);
		add(versionShit);
		var versionShit:FlxText = new FlxText(12, FlxG.height - 24, 0, "Friday Night Funkin' v" + Application.current.meta.get('version'), 12);
		versionShit.scrollFactor.set();
		versionShit.setFormat("VCR OSD Mono", 16, FlxColor.WHITE, LEFT, FlxTextBorderStyle.OUTLINE, FlxColor.BLACK);
		add(versionShit);

		// NG.core.calls.event.logEvent('swag').send();

		changeItem();

		#if ACHIEVEMENTS_ALLOWED
		Achievements.loadAchievements();
		var leDate = Date.now();
		if (leDate.getDay() == 5 && leDate.getHours() >= 18) {
			var achieveID:Int = Achievements.getAchievementIndex('friday_night_play');
			if(!Achievements.isAchievementUnlocked(Achievements.achievementsStuff[achieveID][2])) { //It's a friday night. WEEEEEEEEEEEEEEEEEE
				Achievements.achievementsMap.set(Achievements.achievementsStuff[achieveID][2], true);
				giveAchievement();
				ClientPrefs.saveSettings();
			}
		}
		#end

		super.create();
	}

	#if ACHIEVEMENTS_ALLOWED
	// Unlocks "Freaky on a Friday Night" achievement
	function giveAchievement() {
		add(new AchievementObject('friday_night_play', camAchievement));
		FlxG.sound.play(Paths.sound('confirmMenu'), 0.7);
		trace('Giving achievement "friday_night_play"');
	}
	#end

	var selectedSomethin:Bool = false;

	override function update(elapsed:Float)
	{
		if (FlxG.sound.music.volume < 0.8)
		{
			FlxG.sound.music.volume += 0.5 * FlxG.elapsed;
		}

		var lerpVal:Float = CoolUtil.boundTo(elapsed * 7.5, 0, 1);
		camFollowPos.setPosition(FlxMath.lerp(camFollowPos.x, camFollow.x, lerpVal), FlxMath.lerp(camFollowPos.y, camFollow.y, lerpVal));

		if (!selectedSomethin)
		{
			if (controls.UI_RIGHT_P)
			{
				FlxG.sound.play(Paths.sound('scrollMenu'));
				changeItem(-1);
			}

			if (controls.UI_LEFT_P)
			{
				FlxG.sound.play(Paths.sound('scrollMenu'));
				changeItem(1);
			}

			if (controls.BACK)
			{
				selectedSomethin = true;
				FlxG.sound.play(Paths.sound('cancelMenu'));
				MusicBeatState.switchState(new MainMenuState());
			}

			if (controls.ACCEPT)
			{
				// never happens cuz donate is disabled
				if (optionShit[curSelected] == 'donate')
				{
					CoolUtil.browserLoad('https://ninja-muffin24.itch.io/funkin');
				}
				else
				{
					selectedSomethin = true;
					FlxG.sound.play(Paths.sound('confirmMenu'));

					//if(ClientPrefs.flashing) FlxFlicker.flicker(bg, 1.1, 0.15, false);

					menuItems.forEach(function(spr:FlxSprite)
					{
						if (curSelected != spr.ID)
						{
							FlxTween.tween(FlxG.camera, {zoom: 5}, 0.8, {ease: FlxEase.expoIn});
							FlxTween.tween(bg, {angle: 45}, 0.8, {ease: FlxEase.expoIn});
							FlxTween.tween(magenta, {angle: 45}, 0.8, {ease: FlxEase.expoIn});
							FlxTween.tween(bg, {alpha: 0}, 0.8, {ease: FlxEase.expoIn});
							FlxTween.tween(magenta, {alpha: 0}, 0.8, {ease: FlxEase.expoIn});
							FlxTween.tween(spr, {alpha: 0}, 0.4, {
								ease: FlxEase.quadOut,
								onComplete: function(twn:FlxTween)
								{
									spr.kill();
								}
							});
						}
						else
						{
							FlxFlicker.flicker(spr, 0.5, 0.06, false, false, function(flick:FlxFlicker)
							{
								var daChoice:String = optionShit[curSelected];

								switch (daChoice)
								{
									case 'blue':
										PlayState.SONG = Song.loadFromJson('blues-groove', 'Blues-Groove');
										PlayState.isStoryMode = false;
										PlayState.storyDifficulty = 1;
										PlayState.storyWeek = 1;
										new FlxTimer().start(1.5, function(tmr:FlxTimer)
										{
											LoadingState.loadAndSwitchState(new PlayState());
										});
									case 'gren':
										FlxG.switchState(new FlashingState());
									case 'credits':
										MusicBeatState.switchState(new CreditsState());
									case 'options':
										MusicBeatState.switchState(new options.OptionsState());
								}
								
							});
						}
					});
				}
			}
			#if desktop
			else if (FlxG.keys.anyJustPressed(debugKeys))
			{
				selectedSomethin = true;
				MusicBeatState.switchState(new MasterEditorMenu());
			}
			#end
		}

		super.update(elapsed);
	}

	function changeItem(huh:Int = 0)
	{
		curSelected += huh;

		if (curSelected >= menuItems.length)
			curSelected = 0;
		if (curSelected < 0)
			curSelected = menuItems.length - 1;

		menuItems.forEach(function(spr:FlxSprite)
		{
			spr.animation.play('idle');
			spr.updateHitbox();

			if (spr.ID == curSelected)
			{
				if (spr.ID == 0)
				{
					greenName.alpha = 1;
					greenName.scale.set(1, 1);
					blueName.alpha = 0.5;
					blueName.scale.set(0.9, 0.9);
				}
				else {
					greenName.alpha = 0.5;
					greenName.scale.set(0.9, 0.9);
					blueName.alpha = 1;
					blueName.scale.set(1, 1);
				}
				spr.animation.play('selected');
				var add:Float = 0;
				if(menuItems.length > 4) {
					add = menuItems.length * 8;
				}
				camFollow.setPosition(spr.getGraphicMidpoint().x, spr.getGraphicMidpoint().y - add);
				spr.centerOffsets();
			}
		});
	}

	function codeMenuClick() {
        FlxG.sound.play(Paths.sound('mouseClick'));
        LoadingState.loadAndSwitchState(new CodeState()); 
     }
}
