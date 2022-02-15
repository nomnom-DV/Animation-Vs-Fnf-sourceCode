package;

#if desktop
import Discord.DiscordClient;
#end
import flixel.FlxG;
import flixel.FlxObject;
import flixel.FlxSprite;
import flixel.addons.transition.FlxTransitionableState;
import flixel.effects.FlxFlicker;
import flixel.graphics.frames.FlxAtlasFrames;
import flixel.group.FlxGroup.FlxTypedGroup;
import flixel.text.FlxText;
import flixel.util.FlxColor;
import lime.app.Application;
import haxe.Exception;
using StringTools;
import flixel.util.FlxTimer;
import flixel.addons.ui.FlxInputText;
import flixel.system.FlxSound;
import flixel.tweens.FlxEase;
import flixel.tweens.FlxTween;
import flixel.math.FlxMath;
import flixel.addons.transition.FlxTransitionableState;

class CodeState extends MusicBeatState
{
  var enterCpde:FlxInputText;

  var forceCase:Int;

  var windowPopUp:FlxSprite;
  override function create()
  {

    FlxG.sound.playMusic(Paths.music('freakyMenu'), 0);
        FlxG.sound.music.fadeIn(1, 0, 0.8);

    FlxG.mouse.visible = true;

    windowPopUp = new FlxSprite(-80).loadGraphic(Paths.image('SymbolWindowPopup'));
    windowPopUp.scale.set(1.1, 1.1);
      windowPopUp.updateHitbox();
      windowPopUp.screenCenter();
    windowPopUp.x -= 25;
      windowPopUp.antialiasing = ClientPrefs.globalAntialiasing;
      add(windowPopUp);

    enterCpde = new FlxInputText(500, 350,FlxG.width,"",32,FlxColor.BLACK,FlxColor.TRANSPARENT);
    enterCpde.screenCenter();
    enterCpde.y -= 21;
    enterCpde.x += 90;
    enterCpde.scrollFactor.set();
    enterCpde.scale.set(0.4, 0.4);
    enterCpde.background = false;
    enterCpde.forceCase = 1;
    enterCpde.backgroundColor = FlxColor.TRANSPARENT;
    enterCpde.callback = function(text,action){
      if(action=='enter'){
        if(text.toUpperCase() == "CHOSEN")
          {
            FlxTween.tween(FlxG.camera, {zoom: 5}, 0.8, {ease: FlxEase.expoIn});
            LoadingState.loadAndSwitchState(new WarningState()); 
            PlayState.isStoryMode = false;
            PlayState.storyDifficulty = 3;
          }
        else if(text.toUpperCase() == "VENGEANCE")
          {
            FlxTween.tween(FlxG.camera, {zoom: 5}, 0.8, {ease: FlxEase.expoIn});
            PlayState.SONG = Song.loadFromJson('vengeance', 'vengeance');
            PlayState.isStoryMode = false;
            PlayState.storyDifficulty = 3;
            new FlxTimer().start(0.07, function(tmr:FlxTimer)
              {
                  LoadingState.loadAndSwitchState(new PlayState()); 
              });
          }
        else if(text.toUpperCase() == "BLOXIAM") 
          {
            CoolUtil.browserLoad("https://www.youtube.com/watch?v=dQw4w9WgXcQ");
          }
        else {
          //nuh uh
        }
      }
    }
    add(enterCpde);
    FlxG.mouse.visible=true;

    super.create();
  }
  var timer:Float = 0;

  override function update(elapsed:Float){
    timer += elapsed;
    FlxG.sound.music.volume = FlxMath.lerp(FlxG.sound.music.volume,.5,.1);
    if (controls.BACK && !enterCpde.hasFocus)
    {
      FlxG.sound.play(Paths.sound('cancelMenu'));
      FlxG.sound.playMusic(Paths.music('freakyMenu'), 0);

            FlxG.sound.music.fadeIn(4, 0, 0.7);
      FlxG.switchState(new MainMenuState());
      FlxG.mouse.visible=true;
    }

    if(FlxG.keys.justPressed.ESCAPE && enterCpde.hasFocus){
      enterCpde.hasFocus=false;
    }

    super.update(elapsed);
  }
  override function beatHit()
    {   
        super.beatHit();
    }
}