package;

import flixel.FlxG;
import flixel.FlxObject;
import flixel.math.FlxMath;
import flixel.math.FlxPoint;
import flixel.util.FlxColor;
import flixel.util.FlxTimer;
import flixel.tweens.FlxEase;
import flixel.tweens.FlxTween;
import flixel.FlxSprite;

class GameOverState extends MusicBeatSubstate
{
	public var boyfriend:Boyfriend;
	var camFollow:FlxPoint;
	var camFollowPos:FlxObject;
	var updateCamera:Bool = false;

	var bf:FlxSprite;
	var bfretry:FlxSprite;

	var stageSuffix:String = "";

	public static var characterName:String = 'bf';
	public static var deathSoundName:String = 'fnf_loss_sfx';
	public static var loopSoundName:String = 'gameOver';
	public static var endSoundName:String = 'gameOverEnd';

	public static var instance:GameOverState;
	var curDiffic:Int;
	
	override function create()
	{
		instance = this;
		PlayState.instance.callOnLuas('onGameOverStart', []);
		PlayState.instance.setOnLuas('inGameOver', true);

		Conductor.songPosition = 0;

		FlxG.camera.flash(FlxColor.RED, 0.2);

		if(PlayState.curStage.toLowerCase() == 'animatedbg') {
			bf = new FlxSprite();
			songTing = 'chosen';
			bf.frames = Paths.getSparrowAtlas('deathAnims/TCO_Death', 'preload');
			bf.animation.addByPrefix('idle', 'TCO_DEATH instance 1', 24, false);
			bf.screenCenter();
			add(bf);
			bf.animation.play('idle');
			bf.y += 300;
			bfretry = new FlxSprite();
			bfretry.frames = Paths.getSparrowAtlas('deathAnims/TCO_Retry', 'preload');
			bfretry.animation.addByPrefix('confirm', 'TCO_CONFIRM', 24, false);
			bfretry.screenCenter();
			bfretry.visible = false;
			add(bfretry);
			bfretry.y += 300;
		}
		else if (PlayState.curStage.toLowerCase() == 'tdl')
		{
			bf = new FlxSprite();
			bf.frames = Paths.getSparrowAtlas('deathAnims/TDL_Death', 'preload');
			bf.animation.addByPrefix('idle', 'TDL_DEATH', 24, false);
			bf.animation.addByPrefix('idleDead', 'TDL_RETRY IDLE', 24, true);
			bf.animation.addByPrefix('confirm', 'TDL_RETRY', 24, false);
			bf.screenCenter();
			add(bf);
			bf.animation.play('idle');
			bf.y += 300;
		} else {
			boyfriend = new Boyfriend(0,0,characterName);
			boyfriend.x += boyfriend.positionArray[0];
			boyfriend.y += boyfriend.positionArray[1];
			add(boyfriend);
		}

		if(PlayState.curStage.toLowerCase() == 'animatedbg' || PlayState.curStage.toLowerCase() == 'tdl') 
			camFollow = new FlxPoint(bf.getGraphicMidpoint().x, bf.getGraphicMidpoint().y);
		else
			camFollow = new FlxPoint(boyfriend.getGraphicMidpoint().x, boyfriend.getGraphicMidpoint().y);


		FlxG.sound.play(Paths.sound(deathSoundName));
		Conductor.changeBPM(100);
		// FlxG.camera.followLerp = 1;
		// FlxG.camera.focusOn(FlxPoint.get(FlxG.width / 2, FlxG.height / 2));
		FlxG.camera.scroll.set();
		FlxG.camera.target = null;

		if(PlayState.curStage.toLowerCase() == 'animatedbg' || PlayState.curStage.toLowerCase() == 'tdl') 
			bf.animation.play('idle');
		else 
			boyfriend.playAnim('firstDeath');

		var exclude:Array<Int> = [];

		camFollowPos = new FlxObject(0, 0, 1, 1);
		camFollowPos.setPosition(FlxG.camera.scroll.x + (FlxG.camera.width / 2), FlxG.camera.scroll.y + (FlxG.camera.height / 2));
		add(camFollowPos);

		super.create();
	}

	override function update(elapsed:Float)
	{
		if(PlayState.curStage.toLowerCase() == 'animatedbg' || PlayState.curStage.toLowerCase() == 'tdl') 
			camFollow = new FlxPoint(bf.getGraphicMidpoint().x, bf.getGraphicMidpoint().y);
		else
			camFollow = new FlxPoint(boyfriend.getGraphicMidpoint().x, boyfriend.getGraphicMidpoint().y);

		super.update(elapsed);

		PlayState.instance.callOnLuas('onUpdate', [elapsed]);
		if(updateCamera) {
			var lerpVal:Float = CoolUtil.boundTo(elapsed * 1000, 0, 1);
			camFollowPos.setPosition(FlxMath.lerp(camFollowPos.x, camFollow.x, lerpVal), FlxMath.lerp(camFollowPos.y, camFollow.y, lerpVal));
		}

		if (controls.ACCEPT)
		{
			endBullshit();
		}

		if (controls.BACK)
		{
			FlxG.sound.music.stop();
			PlayState.deathCounter = 0;
			PlayState.seenCutscene = false;

			if (PlayState.isStoryMode)
				MusicBeatState.switchState(new MainMenuState());
			else
				MusicBeatState.switchState(new MainMenuState());

			FlxG.sound.playMusic(Paths.music('freakyMenu'));
			PlayState.instance.callOnLuas('onGameOverConfirm', [false]);
		}

		if (PlayState.curStage.toLowerCase() == 'tdl' || PlayState.curStage.toLowerCase() == 'animatedbg' && bf.animation.curAnim.name == 'idle')
			{	
				if(bf.animation.curAnim.curFrame == 7)
					{
						FlxG.camera.follow(camFollowPos, LOCKON, 1);
						updateCamera = true;
					}
				if (bf.animation.curAnim.finished)
					{
						coolStartDeath();
						if (PlayState.curStage.toLowerCase() != 'animatedbg')
							bf.animation.play('idleDead');
					}
			}
		else {
			if (boyfriend.animation.curAnim.name == 'firstDeath')
			{
				if(boyfriend.animation.curAnim.curFrame == 12)
				{
					FlxG.camera.follow(camFollowPos, LOCKON, 1);
					updateCamera = true;
				}

				if (boyfriend.animation.curAnim.finished)
				{
					coolStartDeath();
					boyfriend.startedDeath = true;
				}
			}
		}
		
		if (FlxG.sound.music.playing)
		{
			Conductor.songPosition = FlxG.sound.music.time;
		}
		PlayState.instance.callOnLuas('onUpdatePost', [elapsed]);
	}

	override function beatHit()
	{
		super.beatHit();

		///FlxG.log.add('beat');

	}

	var isEnding:Bool = false;

	function coolStartDeath(?volume:Float = 1):Void
	{
		FlxG.sound.playMusic(Paths.music(loopSoundName), volume);
	}

	function endBullshit():Void
	{
		if (!isEnding)
		{
			isEnding = true;
			if (PlayState.curStage.toLowerCase() == 'tdl')
				bf.animation.play('confirm');
			else if (PlayState.curStage.toLowerCase() == 'animatedbg') {
				bfretry.visible = true;
				bf.visible= false;
				bfretry.animation.play('confirm');
			} else 
				boyfriend.playAnim('deathConfirm', true);
				
			FlxG.sound.music.stop();
			FlxG.sound.play(Paths.music(endSoundName));
			new FlxTimer().start(0.7, function(tmr:FlxTimer)
			{
				FlxG.camera.fade(FlxColor.BLACK, 2, false, function()
				{
					PlayState.SONG = Song.loadFromJson(songTing + '-hard', songTing);
                    PlayState.isStoryMode = false;
                    PlayState.storyDifficulty = 3;
					LoadingState.loadAndSwitchState(new PlayState());
				});
			});
			PlayState.instance.callOnLuas('onGameOverConfirm', [true]);
		}
	}
}

