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
import flixel.FlxCamera;
import flixel.tweens.FlxEase;

class HintState extends MusicBeatState
{
    public static var leftState:Bool = false;

    public var camChosen:FlxCamera;
    public var camOther:FlxCamera;
    var chromeOffset:Float = ((2 - ((0.5 / 0.5))));

    var vengeanceText:FlxText;
    var chosenText:FlxText;
    var randomText:FlxText;
    var tipText:FlxText;

    override function create()
    {
        super.create();

        camChosen = new FlxCamera();
        camOther = new FlxCamera();
        camChosen.bgColor.alpha = 0;

        FlxG.cameras.reset(camOther);
        FlxG.cameras.add(camChosen);

        FlxCamera.defaultCameras = [camOther];


        if (ClientPrefs.shaders) {
            chromeOffset /= 350;
            if (chromeOffset <= 0)
             setChrome(chromeOffset);
            else
            {
            setChrome(chromeOffset);
            }
        }

        camChosen.setFilters([ShadersHandler.chromaticAberration]);

        var bg:FlxSprite = new FlxSprite().makeGraphic(FlxG.width, FlxG.height, FlxColor.BLACK);
        add(bg);

        vengeanceText = new FlxText(0, 0, FlxG.width, "", 20);
        vengeanceText.setFormat(Paths.font("vcr.ttf"), 20, FlxColor.RED, CENTER, FlxTextBorderStyle.OUTLINE, FlxColor.BLACK);
        vengeanceText.text = 'He is seeking for VENGEANCE';
        vengeanceText.borderSize = 1;
        vengeanceText.updateHitbox();
        vengeanceText.screenCenter();
        vengeanceText.y -= 75;
        vengeanceText.scale.set(1.5, 1.5);
        add(vengeanceText);

        randomText = new FlxText(0, 0, FlxG.width, "", 20);
        randomText.setFormat(Paths.font("vcr.ttf"), 20, FlxColor.YELLOW, CENTER, FlxTextBorderStyle.OUTLINE, FlxColor.BLACK);
        randomText.text = 'BLOXIAM was here';
        randomText.borderSize = 1;
        randomText.updateHitbox();
        randomText.screenCenter();
        randomText.y += 75;
        randomText.scale.set(1.5, 1.5);
        add(randomText);

        tipText = new FlxText(0, 0, FlxG.width, "", 20);
        tipText.setFormat(Paths.font("vcr.ttf"), 20, FlxColor.GRAY, CENTER, FlxTextBorderStyle.OUTLINE, FlxColor.BLACK);
        tipText.text = 'Go look in the main menu, something hidden is waiting there for you';
        tipText.borderSize = 1;
        tipText.updateHitbox();
        tipText.screenCenter();
        tipText.y += 150;
        tipText.scale.set(1.5, 1.5);
        add(tipText);

        chosenText = new FlxText(0, 0, FlxG.width, "", 20);
        chosenText.setFormat(Paths.font("vcr.ttf"), 20, FlxColor.WHITE, CENTER, FlxTextBorderStyle.OUTLINE, FlxColor.BLACK);
        chosenText.text = 'You have been CHOSEN';
        chosenText.borderSize = 1;
        chosenText.updateHitbox();
        chosenText.screenCenter();
        chosenText.scale.set(1.5, 1.5);
        add(chosenText);

        tipText.cameras = [camOther];
        randomText.cameras = [camOther];
        vengeanceText.cameras = [camOther];
        chosenText.cameras = [camChosen];

        trace('hints lol');
    }

    override function update(elapsed:Float)
    {
        FlxG.save.data.sugomaBalls = true;
        FlxG.save.flush();

        if(!leftState) {
            if (controls.ACCEPT || controls.BACK) {
                leftState = true;
                FlxTween.tween(chosenText, {alpha: 0}, 1, {ease: FlxEase.quadIn});
                MusicBeatState.switchState(new MainMenuState());
                FlxG.sound.play(Paths.sound('cancelMenu'));
            }
        }

        super.update(elapsed);
    }
}