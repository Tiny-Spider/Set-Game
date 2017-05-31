package;

import openfl.Assets;

import openfl.display.Sprite;
import openfl.display.Bitmap;
import openfl.display.BitmapData;

import motion.Actuate;
import openfl.events.MouseEvent;
import enums.GameState;

import openfl.text.TextField;
import openfl.text.TextFormat;
import openfl.text.TextFormatAlign;

/**
 * End screen class, displays logo and start button
 * @author Mark
 */
class ScreenEnd extends Sprite
{
	private var logo:Bitmap = new Bitmap(Assets.getBitmapData("img/game_over.png"));
	private var textField:TextField = new TextField();
	private var button:Button = new Button("Menu", "img/button.png", "img/button_hover.png", Main.endButtonWidth, Main.endButtonHeight);

	private var main:Main;
	
	public function new(main:Main, board:ScreenBoard)
	{
		super();
		
		this.main = main;
		
		// Logo
		logo.width = Main.endLogoWidth;
		logo.height = Main.endLogoHeight;
		logo.x = -Math.round((Main.endLogoWidth / 2));
		logo.y = -Math.round(Main.endLogoHeight + Main.paddingDistance + (Main.endMessageHeight / 2.0));
		
		addChild(logo);
		
		// Text
		textField.height = Main.endMessageHeight;
		textField.width = Main.endMessageWidth;
		textField.x = -(Main.endMessageWidth / 2.0);
		textField.y = -Math.round(Main.endMessageHeight / 2.0);
		
		var messageFormat:TextFormat = Main.defaultTextFormat.clone();
		messageFormat.align = TextFormatAlign.CENTER;
		
		textField.setTextFormat(messageFormat);
		textField.selectable = false;
		
		var text:String = Main.endMessage;
		text = StringTools.replace(text, "{score}", Std.string(board.score));
		text = StringTools.replace(text, "{find}", Std.string(board.findAmount));
		text = StringTools.replace(text, "{rows}", Std.string(board.rowAmount));
		textField.text = text; 
		
		addChild(textField);
		
		// Button
		button.addEventListener(MouseEvent.CLICK, menu);
		button.y = Math.round(Main.paddingDistance + (Main.endButtonHeight / 2.0));
		
		addChild(button);
	}
	
	private function menu(event:MouseEvent) {
		main.switchGameState(GameState.Menu);
	}
	
	public function draw(animate:Bool)
	{
		// Center the menu in the middle of the program window
		var x:Int = Math.round(Main.stageWidth / 2.0);
		var y:Int = Math.round(Main.stageHeight / 2.0);
		
		Actuate.tween(this, animate ? Main.animationPositionSpeed : 0, { x:x, y:y });
	}
}