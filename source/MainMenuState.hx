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

class MainMenuState extends MusicBeatState
{
	public static var psychEngineVersion:String = '0.5'; //This is also used for Discord RPC
	public static var curSelected:Int = 0;

	var menuItems:FlxTypedGroup<FlxSprite>;
	private var camGame:FlxCamera;
	private var camAchievement:FlxCamera;
	
	var optionShit:Array<String> = [
		'freeplay',
		'credits',
		'options',	
		'secret'
	];

	var magenta:FlxSprite;
	var frame:FlxSprite;
	var camFollow:FlxObject;
	var camFollowPos:FlxObject;
	var debugKeys:Array<FlxKey>;

	var menusprite:FlxSprite;
	var glitchFrame:FlxSprite;

	var codeMenu:FlxSpriteButton;

	var secretItem:FlxSprite;

	var chromeOffset:Float = ((2 - ((0.5 / 0.5))));

	var bg:FlxSprite;

	// Buttons, fuck you Ekical
	// fuck you sovet!!!
	var freeplaybutton:FlxSprite;

	var creditsShittyButton:FlxSprite;
	
	var optionsItem:FlxSprite;

	override function create()
	{
		#if desktop
		// Updating Discord Rich Presence
		DiscordClient.changePresence("In the Menus", null);
		#end

		FlxG.mouse.visible = false;

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

		if (ClientPrefs.shaders) {
		chromeOffset /= 350;
		if (chromeOffset <= 0)
		 setChrome(0.0);
		else
		{
		setChrome(chromeOffset);
		}	
	}

		FlxG.camera.setFilters([ShadersHandler.chromaticAberration]);
		camGame.setFilters([ShadersHandler.chromaticAberration]);
		camAchievement.setFilters([ShadersHandler.chromaticAberration]);

		bg = new FlxSprite(-50, -10).loadGraphic(Paths.image('menuBG'));
		bg.scale.set(0.622, 0.622);
		bg.scrollFactor.set(0,0.09);
		bg.updateHitbox();
		bg.screenCenter();
		bg.y += 75;
		bg.x += 15;
		bg.antialiasing = ClientPrefs.globalAntialiasing;
		add(bg);

		glitchFrame = new FlxSprite(700, 50);
		glitchFrame.frames = Paths.getSparrowAtlas('mainmenu/frameimages/SecretFrame');
		glitchFrame.scale.set(0.7,0.7);
		glitchFrame.animation.addByPrefix('idle', "static frame", 24);
		glitchFrame.animation.play('idle');
		glitchFrame.scrollFactor.set();
		glitchFrame.antialiasing = ClientPrefs.globalAntialiasing;
		glitchFrame.updateHitbox();
		glitchFrame.screenCenter();
		glitchFrame.x += 200;
		glitchFrame.y -= 30;
		glitchFrame.alpha = 0;
		add(glitchFrame);



		menusprite = new FlxSprite().loadGraphic(Paths.image(''));
        menusprite.updateHitbox();
        menusprite.screenCenter(XY);
        menusprite.y -= 374;
        menusprite.x -= 640;
        menusprite.scrollFactor.set(0, 0);
        menusprite.scale.set(0.7, 0.7);
        menusprite.antialiasing = ClientPrefs.globalAntialiasing;
        add(menusprite);
		
		frame = new FlxSprite().loadGraphic(Paths.image('mainmenu/frame'));
		frame.scale.set(0.7,0.7);
		frame.scrollFactor.set();
		frame.updateHitbox();
		frame.screenCenter();
		frame.y -= 15;
		frame.antialiasing = ClientPrefs.globalAntialiasing;
		add(frame);

		camFollow = new FlxObject(0, 0, 1, 1);
		camFollowPos = new FlxObject(0, 0, 1, 1);
		add(camFollow);
		add(camFollowPos);

		magenta = new FlxSprite(-80).loadGraphic(Paths.image('menuBG'));
		magenta.scrollFactor.set(0);
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

		// fuck this button too!!!! it's shit!!!
		freeplaybutton = new FlxSprite(700, 50);
		freeplaybutton.frames = Paths.getSparrowAtlas('mainmenu/menu_play');
		freeplaybutton.scale.set(0.3, 0.3);
		freeplaybutton.animation.addByPrefix('idle', "play basic", 24);
		freeplaybutton.animation.addByPrefix('selected', "play white", 24);
		freeplaybutton.animation.play('idle');
		freeplaybutton.ID = 0;
		menuItems.add(freeplaybutton);
		freeplaybutton.scrollFactor.set();
		freeplaybutton.antialiasing = ClientPrefs.globalAntialiasing;
		freeplaybutton.updateHitbox();
		freeplaybutton.screenCenter();
		freeplaybutton.x -= 385;
		freeplaybutton.y -= 200;

		//THIS FUCKING BUTTON MAKES ME WANT TO DIE AAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAA
		creditsShittyButton = new FlxSprite(700, 50);
		creditsShittyButton.frames = Paths.getSparrowAtlas('mainmenu/menu_credits');
		creditsShittyButton.scale.set(0.3, 0.3);
		creditsShittyButton.animation.addByPrefix('idle', optionShit[1] + " basic", 24);
		creditsShittyButton.animation.addByPrefix('selected', optionShit[1] + " white", 24);
		creditsShittyButton.animation.play('idle');
		creditsShittyButton.ID = 1;
		menuItems.add(creditsShittyButton);
		creditsShittyButton.scrollFactor.set();
		creditsShittyButton.antialiasing = ClientPrefs.globalAntialiasing;
		creditsShittyButton.updateHitbox();
		creditsShittyButton.screenCenter();
		creditsShittyButton.x -= 385;
		creditsShittyButton.y -= 8;

		optionsItem = new FlxSprite(700, 50);
		optionsItem.frames = Paths.getSparrowAtlas('mainmenu/menu_options');
		optionsItem.scale.set(0.3, 0.3);
		optionsItem.animation.addByPrefix('idle', optionShit[2] + " basic", 24);
		optionsItem.animation.addByPrefix('selected', optionShit[2] + " white", 24);
		optionsItem.animation.play('idle');
		optionsItem.ID = 2;
		menuItems.add(optionsItem);
		optionsItem.scrollFactor.set();
		optionsItem.antialiasing = ClientPrefs.globalAntialiasing;
		optionsItem.updateHitbox();
		optionsItem.screenCenter();
		optionsItem.x -= 385;
		optionsItem.y += 184;		
		
		secretItem = new FlxSprite(700, 50);
		secretItem.frames = Paths.getSparrowAtlas('mainmenu/menu_secret');
		secretItem.scale.set(0.3, 0.3);
		secretItem.animation.addByPrefix('idle', optionShit[3] + " basic", 24);
		secretItem.animation.addByPrefix('selected', optionShit[3] + " white", 24);
		secretItem.animation.play('idle');
		secretItem.ID = 3;
		menuItems.add(secretItem);
		secretItem.scrollFactor.set();
		secretItem.visible = false;
		secretItem.antialiasing = ClientPrefs.globalAntialiasing;
		secretItem.updateHitbox();
		secretItem.screenCenter();
		secretItem.x += 230;
		secretItem.y += 300;
		

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
            add(codeMenu); 

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
		switch(optionShit[curSelected])
		{
            case 'freeplay':
                menusprite.loadGraphic('assets/images/mainmenu/frameimages/PlayFrame.png');
				glitchFrame.alpha = 0;
				menusprite.alpha = 1;
				frame.alpha = 1;
				setChrome(0.0);
            case 'credits':
                menusprite.loadGraphic('assets/images/mainmenu/frameimages/CreditsFrame.png');
				glitchFrame.alpha = 0;
				menusprite.alpha = 1;
				frame.alpha = 1;
				setChrome(0.0);
            case 'options':
                menusprite.loadGraphic('assets/images/mainmenu/frameimages/OptionsFrame.png');
				glitchFrame.alpha = 0;
				menusprite.alpha = 1;
				frame.alpha = 1;
				setChrome(0.0);
            case 'secret':
                glitchFrame.alpha = 1;
				menusprite.alpha = 0;
				frame.alpha = 0;
				if (ClientPrefs.shaders) {
				setChrome(chromeOffset);
				}
        }

		if (FlxG.sound.music.volume < 0.8)
		{
			FlxG.sound.music.volume += 0.5 * FlxG.elapsed;
		}

		if (FlxG.save.data.unlockedSecret ==false)
		{
			secretItem.visible =false;
		}

		if (FlxG.save.data.unlockedSecret ==false)
		{
			secretItem.visible =false;
		}

		if (FlxG.save.data.unlockedSecret ==true)
		{
			secretItem.visible =true;
		}

		if (FlxG.keys.justPressed.FIVE)
		{
			trace('Stickin: ' + FlxG.save.data.beatStickin);
			trace('Blue: ' + FlxG.save.data.beatBlue);
			trace('Secret: ' + FlxG.save.data.unlockedSecret);
			trace('Curselected: ' + curSelected);
		}

		#if debug
		if (FlxG.keys.justPressed.ONE)
		{
			FlxG.save.data.beatStickin =false;
			FlxG.save.flush();
		}
		if (FlxG.keys.justPressed.TWO)
			{
				FlxG.save.data.beatBlue =false;
				FlxG.save.flush();
			}
			if (FlxG.keys.justPressed.THREE)
				{
					FlxG.save.data.unlockedSecret =false;
					FlxG.save.flush();
				}
		#end

		var lerpVal:Float = CoolUtil.boundTo(elapsed * 7.5, 0, 1);
		camFollowPos.setPosition(FlxMath.lerp(camFollowPos.x, camFollow.x, lerpVal), FlxMath.lerp(camFollowPos.y, camFollow.y, lerpVal));

		if (!selectedSomethin)
		{
			if (controls.UI_UP_P)
			{
				FlxG.sound.play(Paths.sound('scrollMenu'));
				changeItem(-1);
			}

			if (controls.UI_DOWN_P)
			{
				FlxG.sound.play(Paths.sound('scrollMenu'));
				changeItem(1);
			}

			if (controls.BACK)
			{
				selectedSomethin = true;
				FlxG.sound.play(Paths.sound('cancelMenu'));
				MusicBeatState.switchState(new TitleState());
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

					menuItems.forEach(function(spr:FlxSprite)
					{
						if (curSelected != spr.ID)
						{
							FlxTween.tween(FlxG.camera, {zoom: 5}, 0.8, {ease: FlxEase.expoIn});
							FlxTween.tween(bg, {angle: 45}, 0.8, {ease: FlxEase.expoIn});
							FlxTween.tween(magenta, {angle: 45}, 0.8, {ease: FlxEase.expoIn});
							FlxTween.tween(bg, {alpha: 0}, 0.8, {ease: FlxEase.expoIn});
							FlxTween.tween(magenta, {alpha: 0}, 0.8, {ease: FlxEase.expoIn});
							FlxTween.tween(menusprite, {angle: 45}, 0.8, {ease: FlxEase.expoIn});
							FlxTween.tween(frame, {angle: 45}, 0.8, {ease: FlxEase.expoIn});
							FlxTween.tween(menusprite, {alpha: 0}, 0.8, {ease: FlxEase.expoIn});
							FlxTween.tween(frame, {alpha: 0}, 0.8, {ease: FlxEase.expoIn});
							FlxTween.tween(glitchFrame, {angle: 45}, 0.8, {ease: FlxEase.expoIn});
							FlxTween.tween(glitchFrame, {alpha: 0}, 0.8, {ease: FlxEase.expoIn});
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
									case 'freeplay':
										MusicBeatState.switchState(new SongSelectionState());
									case 'secret':
										if (FlxG.save.data.unlockedSecret ==true)
										{
											MusicBeatState.switchState(new CodeState());
										}
										else if (FlxG.save.data.unlockedSecret ==false) 
										{
											FlxG.camera.shake();
										}
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

		if (curSelected > 3) {
            curSelected = 0;
		}
		if (curSelected > 2 && FlxG.save.data.unlockedSecret ==false) {
			curSelected = 0;
		} else if (curSelected > 2 && FlxG.save.data.unlockedSecret ==true) {
			curSelected = 3;
		}
		if (curSelected < 0 && FlxG.save.data.unlockedSecret ==false) {
			curSelected = 2;
		} else if (curSelected < 0 && FlxG.save.data.unlockedSecret ==true) {
			curSelected = 3;
		}
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
