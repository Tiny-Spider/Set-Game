package;

import openfl.Assets;

import openfl.display.Sprite;
import openfl.display.Bitmap;
import openfl.display.BitmapData;

import motion.Actuate;
import openfl.events.MouseEvent;
import enums.GameState;

/**
 * Menu class, displays logo and start button
 * @author Mark
 */
class ScreenMenu extends Sprite
{
	private var logo:Bitmap = new Bitmap(Assets.getBitmapData("img/logo.png"));
	private var button:Button = new Button("New Game", "img/button.png", "img/button_hover.png", Main.menuButtonWidth, Main.menuButtonHeight);
	private var main:Main;
	
	public function new(main:Main)
	{
		super();
		
		this.main = main;
		
		// Logo
		logo.width = Main.menuLogoWidth;
		logo.height = Main.menuLogoHeight;
		logo.x = -Math.round((Main.menuLogoWidth / 2));
		logo.y = -Math.round(Main.menuLogoHeight + (Main.paddingDistance / 2));
		
		addChild(logo);
		
		// Button
		button.addEventListener(MouseEvent.CLICK, newGame);
		button.y = Math.round((Main.buttonHeight / 2) + (Main.paddingDistance / 2));
		
		addChild(button);
	}
	
	private function newGame(event:MouseEvent) {
		main.switchGameState(GameState.Game);
	}
	
	public function draw(animate:Bool)
	{
		// Center the menu in the middle of the program window
		var x:Int = Math.round(Main.stageWidth / 2);
		var y:Int = Math.round(Main.stageHeight / 2);
		
		Actuate.tween(this, animate ? Main.animationPositionSpeed : 0, { x:x, y:y });
	}
}