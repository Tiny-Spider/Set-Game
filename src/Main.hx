package;

import enums.GameState;
import openfl.display.Sprite;
import openfl.display.Bitmap;
import openfl.display.BitmapData;
import openfl.Lib;
import openfl.Assets;
import openfl.events.Event;
import openfl.text.TextFormat;
import openfl.text.TextFormatAlign;
import enums.Amount;
import motion.Actuate;
import utilities.Fonts;

/**
 * ...
 * @author Mark
 */
class Main extends Sprite
{
	// Inline may be removed and can then be edited in runtime, for now
	// it will use inline for performance.
	
	// Menu
	public static inline var menuLogoWidth:Int = 500;
	public static inline var menuLogoHeight:Int = 250;
	public static inline var menuButtonWidth:Int = 300;
	public static inline var menuButtonHeight:Int = 50;
	
	// Board
	public static inline var cardWidth:Int = 100;
	public static inline var cardHeight:Int = 150;
	public static inline var cardSelection:Int = 3;
	
	public static inline var boardRows:Int = 3;
	public static inline var boardColumns:Int = 4;
	public static inline var maxboardColumns:Int = 8;
	
	public static inline var buttonWidth:Int = 150;
	public static inline var buttonHeight:Int = 50;
	
	public static inline var scoreSet:Int = 1;
	public static inline var scoreFindSet:Int = -1;
	
	public static inline var messageHeight:Int = 40;
	public static inline var messageWidth:Int = 500;
	public static inline var scoreText:String = "Score: {score}";
	public static inline var messageInvalidSet:String = "The {type} does not match!";
	public static inline var messageNoSet:String = "No set could be found!";
	public static inline var messageSet:String = "Good one! +1 score";
	
	// End Screen
	public static inline var endLogoWidth:Int = 365;
	public static inline var endLogoHeight:Int = 40;
	public static inline var endButtonWidth:Int = 300;
	public static inline var endButtonHeight:Int = 50;
	public static inline var endMessageHeight:Int = 175;
	public static inline var endMessageWidth:Int = 300;
	public static inline var endMessage:String = "Final Score: {score}\nFind Used: {find}\nRows Added: {rows}\n\nWell Done!";
	
	// General
	public static var stageWidth:Int;
	public static var stageHeight:Int;
	
	public static inline var animationSpeed:Float = 1.0;
	public static inline var animationPositionSpeed:Float = 0.5;
	public static inline var paddingDistance:Int = 30;
	
	public static var defaultTextFormat:TextFormat;

	private var screenMenu:ScreenMenu;
	private var screenBoard:ScreenBoard;
	private var screenEnd:ScreenEnd;
	
	private var gameState:GameState = GameState.Menu;
	private var background:BitmapData = Assets.getBitmapData("img/background.png");
	
	public function new()
	{
		super();
		
		Actuate.apply();
		
		Fonts.init();
		defaultTextFormat = new TextFormat(Fonts.CALIBRI, 20, 0xFFFFFF);

		stageWidth = Lib.current.stage.stageWidth;
		stageHeight = Lib.current.stage.stageHeight;
		
		drawBackground();
		switchGameState(GameState.Menu);
		
		Lib.current.stage.addEventListener(Event.RESIZE, onResize);
	}
	
	public function switchGameState(gameState:GameState) {
		this.gameState = gameState;
		
		switch(gameState) {
			case GameState.Menu:
				screenMenu = new ScreenMenu(this);
				screenMenu.draw(false);
				screenMenu.x = -stageWidth;
				screenMenu.draw(true);
				addChild(screenMenu);
				
				// Fade end screen out, make a local reference otherwise new end screen might be overwritten
				if (screenEnd != null) {
					var localEndRef:ScreenEnd = screenEnd;
					Actuate.tween(localEndRef, Main.animationPositionSpeed, { x:(stageWidth * 2) }).onComplete(function() { removeChild(localEndRef); });
				}
				
			case GameState.Game:
				screenBoard = new ScreenBoard(this, boardColumns, boardRows);
				screenBoard.draw(false);
				screenBoard.x = stageWidth * 2;
				screenBoard.draw(true);
				addChild(screenBoard);
				
				// Fade menu out, make a local reference otherwise new menu might be overwritten
				if (screenMenu != null) {
					var localMenuRef:ScreenMenu = screenMenu;
					Actuate.tween(localMenuRef, Main.animationPositionSpeed, { x:-stageWidth }).onComplete(function() { removeChild(localMenuRef); });
				}
				
			case GameState.End:
				screenEnd = new ScreenEnd(this, screenBoard);
				screenEnd.draw(false);
				screenEnd.x = stageWidth * 2;
				screenEnd.draw(true);
				addChild(screenEnd);
				
				// Fade board out, make a local reference otherwise new board might be overwritten
				if (screenBoard != null) {
					var localBoardRef:ScreenBoard = screenBoard;
					Actuate.tween(localBoardRef, Main.animationPositionSpeed, { x:-stageWidth }).onComplete(function() { removeChild(localBoardRef); });
				}
		}
	}

	private function onResize(event:Event)
	{
		stageWidth = Lib.current.stage.stageWidth;
		stageHeight = Lib.current.stage.stageHeight;
		
		drawBackground();
		
		switch(gameState) {
			case GameState.Menu:
				screenMenu.draw(true);
			case GameState.Game:
				screenBoard.draw(true);
			case GameState.End:
				screenEnd.draw(true);
		}
	}
	
	private function drawBackground() {
		graphics.clear();
		graphics.beginBitmapFill(background, null, true, true);
		graphics.drawRect(0, 0, stageWidth, stageHeight);
		graphics.endFill();
	}
}
