package;

import flixel.FlxG;
import flixel.FlxSprite;
import flixel.FlxSubState;
import flixel.text.FlxText;
import flixel.util.FlxColor;
import flixel.effects.FlxFlicker;
import lime.app.Application;
import flixel.addons.transition.FlxTransitionableState;
import flixel.tweens.FlxTween;
import flixel.util.FlxTimer;

class WarningState extends MusicBeatState
{
	public static var leftState:Bool = false;

	var warnText:FlxText;
	var warnText2:FlxText;
	override function create()
	{
		super.create();

		var bg:FlxSprite = new FlxSprite().makeGraphic(FlxG.width, FlxG.height, FlxColor.BLACK);
		add(bg);

		warnText = new FlxText(0, 0, FlxG.width,
			"Hey there person man/woman   \n
			This song contains an animated background and it may cause a headache,\n
			Press Esc if you want to disable it or press Enter if you don't wanna disable it,\n
			\n
			Hope you enjoy this song",
			32);
		warnText.setFormat("VCR OSD Mono", 32, FlxColor.WHITE, CENTER);
		warnText.screenCenter(Y);
		add(warnText);
		
		warnText2 = new FlxText(5, 5, FlxG.width,
			"Warning: Press M to go to TitleState.",
			32);
		warnText2.setFormat("VCR OSD Mono", 32, FlxColor.WHITE, CENTER);
		add(warnText2);
	}

	override function update(elapsed:Float)
	{
			if (controls.ACCEPT) {
                PlayState.animatedbgdisable = false;
				FlxG.sound.play(Paths.sound('cancelMenu'));
                PlayState.SONG = Song.loadFromJson('chosen', 'chosen');
                LoadingState.loadAndSwitchState(new PlayState());
                FlxTween.tween(warnText, {alpha: 0}, 1, {
                });
			}
            else if (controls.BACK) 
            {
                {
                    PlayState.animatedbgdisable = true;
                    FlxG.sound.play(Paths.sound('cancelMenu'));
                    PlayState.SONG = Song.loadFromJson('chosen', 'chosen');
                    LoadingState.loadAndSwitchState(new PlayState());
                    FlxTween.tween(warnText, {alpha: 0}, 1, {
                    });
                }
		    }
		super.update(elapsed);
   }
}
