package;

import flixel.FlxG;
import flixel.FlxObject;
import flixel.FlxSubState;
import flixel.FlxSprite;
import flixel.math.FlxMath;
import flixel.math.FlxPoint;
import flixel.util.FlxColor;
import flixel.util.FlxTimer;
import flixel.tweens.FlxEase;
import flixel.tweens.FlxTween;

class GameOverSubstate2 extends MusicBeatSubstate
{
	var stupidDeath:FlxSprite;
	
	override public function create()
	{
		stupidDeath.frames = Paths.getSparrowAtlas('deathanims/TDL_Death', 'shared');
		stupidDeath.antialiasing = ClientPrefs.globalAntialiasing;
		stupidDeath.x -= 200;
		stupidDeath.animation.addByPrefix('death', 'TDL_DEATH', 24);
		stupidDeath.animation.addByPrefix('confirm', 'TDL_CONFIRM', 24);
		stupidDeath.animation.addByPrefix('retry', 'TDL_RETRY', 24);
		stupidDeath.animation.play('death');
		stupidDeath.screenCenter();
		stupidDeath.updateHitbox();
		add(stupidDeath);
	}
}
