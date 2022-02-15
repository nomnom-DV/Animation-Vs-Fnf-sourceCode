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
import flixel.ui.FlxSpriteButton;

class CodeState extends MusicBeatState
{
  var enterCpde:FlxInputText;

  var forceCase:Int;

  var goodText:FlxText;
  var lengthText:FlxText;
  var resetText:FlxText;
  var invalidText:FlxText;

  var ok:FlxSpriteButton;
  var cancel:FlxSpriteButton;
  var exit:FlxSpriteButton;
  var advanced:FlxSpriteButton;

  var image:FlxSprite;

  var windowPopUp:FlxSprite;
  override function create()
  {
    FlxG.mouse.visible = true;

    windowPopUp = new FlxSprite(-80).loadGraphic(Paths.image('SymbolWindowPopup'));
    windowPopUp.scale.set(1.1, 1.1);
    windowPopUp.updateHitbox();
    windowPopUp.screenCenter();
    windowPopUp.x -= 25;
    windowPopUp.antialiasing = ClientPrefs.globalAntialiasing;
    add(windowPopUp);

    enterCpde = new FlxInputText(500, 350,FlxG.width,"",32,FlxColor.BLACK,FlxColor.TRANSPARENT);
    enterCpde.caretColor = FlxColor.TRANSPARENT;
    enterCpde.screenCenter();
    enterCpde.y -= 21;
    enterCpde.x += 90;
    enterCpde.scrollFactor.set();
    enterCpde.scale.set(0.4, 0.4);
    enterCpde.background = false;
    enterCpde.forceCase = 2;
    enterCpde.maxLength = 15;
    enterCpde.backgroundColor = FlxColor.TRANSPARENT;
    enterCpde.callback = function(text,action){
      if(action=='enter'){
        if(text.toLowerCase() == "chosen")
          {
            goodText.alpha = 1;
            new FlxTimer().start(0.5, function(tmr:FlxTimer)
              {
               FlxTween.tween(goodText, {alpha: 0}, 0.45, {ease: FlxEase.quadIn});
              });
              new FlxTimer().start(0.8, function(tmr:FlxTimer)
                {
                  FlxTween.tween(FlxG.camera, {zoom: 5}, 0.2, {ease: FlxEase.expoIn});
                  PlayState.isStoryMode = false;
                  PlayState.storyDifficulty = 3;
                });
                new FlxTimer().start(1, function(tmr:FlxTimer)
                  {
                    LoadingState.loadAndSwitchState(new WarningState()); 
                  });
          }
        else if(text.toLowerCase() == "vengeance")
          {
            goodText.alpha = 1;
            new FlxTimer().start(0.5, function(tmr:FlxTimer)
             {
              FlxTween.tween(goodText, {alpha: 0}, 0.45, {ease: FlxEase.quadIn});
             });
            new FlxTimer().start(0.8, function(tmr:FlxTimer)
              {
                FlxTween.tween(FlxG.camera, {zoom: 5}, 0.2, {ease: FlxEase.expoIn});
                PlayState.SONG = Song.loadFromJson('vengeance', 'vengeance');
                PlayState.isStoryMode = false;
                PlayState.storyDifficulty = 3;
              });
            new FlxTimer().start(1, function(tmr:FlxTimer)
              {
                  LoadingState.loadAndSwitchState(new PlayState()); 
              });
          }
        else if(text.toLowerCase() == "bloxiam") 
          {
            image.alpha = 1;
            new FlxTimer().start(2.5, function(tmr:FlxTimer)
              {
                FlxTween.tween(image, {alpha: 0}, 0.45, {ease: FlxEase.quadIn});
              });
          }
        else {
          //nuh uh
        }
      }
    }
    add(enterCpde);
    FlxG.mouse.visible=true;

    invalidText = new FlxText(0, 0, FlxG.width, "", 20);
		invalidText.setFormat(Paths.font("tahoma.ttf"), 100, FlxColor.RED, FlxTextBorderStyle.OUTLINE,FlxColor.RED);
		invalidText.screenCenter();
    invalidText.y += 25;
		invalidText.scrollFactor.set();
		invalidText.borderSize = 0.1;
    invalidText.alpha = 0;
    invalidText.scale.set(0.15, 0.15);
    invalidText.text = 'Invalid Code, try another one';
    add(invalidText);

    goodText = new FlxText(0, 0, FlxG.width, "", 20);
		goodText.setFormat(Paths.font("tahoma.ttf"), 100, FlxColor.GREEN, FlxTextBorderStyle.OUTLINE,FlxColor.GREEN);
		goodText.screenCenter();
    goodText.y += 25;
		goodText.scrollFactor.set();
		goodText.borderSize = 0.1;
    goodText.alpha = 0;
    goodText.scale.set(0.15, 0.15);
    goodText.text = 'Valid Code, loading...';
    add(goodText);

        image = new FlxSprite().loadGraphic(Paths.image('bloxiam', 'preload'));
		image.antialiasing = ClientPrefs.globalAntialiasing;
		image.updateHitbox();
        image.screenCenter();
		image.alpha = 0;
        add(image);

    super.create();
  }
  var timer:Float = 0;

  override function update(elapsed:Float){
    timer += elapsed;
    FlxG.sound.music.volume = FlxMath.lerp(FlxG.sound.music.volume,.5,.1);
    if (controls.BACK && !enterCpde.hasFocus)
    {
      FlxG.sound.play(Paths.sound('cancelMenu'));

      FlxG.switchState(new MainMenuState());
      FlxG.mouse.visible=false;
    }

    if (FlxG.keys.justPressed.ANY) {
      FlxG.sound.play(Paths.sound('keyboardPress'));
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