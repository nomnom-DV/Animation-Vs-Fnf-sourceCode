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

class FlashingState extends MusicBeatState
{
	public static var leftState:Bool = false;

	var warnText:FlxText;
	override function create()
	{
		super.create();

		var bg:FlxSprite = new FlxSprite().makeGraphic(FlxG.width, FlxG.height, FlxColor.BLACK);
		add(bg);

		warnText = new FlxText(0, 0, FlxG.width,
			"Hey there person man/woman   \n
			This song contains some flashing and it may cause a headache,\n
			Press Esc if you want to disable it or press Enter if you don't wanna disable it,\n
			\n
			Hope you enjoy this song",
			32);
		warnText.setFormat("VCR OSD Mono", 32, FlxColor.WHITE, CENTER);
		warnText.screenCenter(Y);
		add(warnText);
	}

	override function update(elapsed:Float)
	{
			if (FlxG.keys.justPressed.ENTER) {
				PlayState.SONG = Song.loadFromJson('stickin-to-it', 'Stickin-To-It');
                LoadingState.loadAndSwitchState(new PlayState());
				ClientPrefs.flashing = true;
				FlxG.sound.play(Paths.sound('cancelMenu'));
                FlxTween.tween(warnText, {alpha: 0}, 1, {
                });
			}
            if (FlxG.keys.justPressed.ESCAPE)
            {
                {
					PlayState.SONG = Song.loadFromJson('stickin-to-it', 'Stickin-To-It');
                    LoadingState.loadAndSwitchState(new PlayState());
					ClientPrefs.flashing = false;
					ClientPrefs.saveSettings();
                    FlxG.sound.play(Paths.sound('cancelMenu'));
                    FlxTween.tween(warnText, {alpha: 0}, 1, {
                    });
                }
		    }
		super.update(elapsed);
   }
}
