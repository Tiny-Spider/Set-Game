package;

import openfl.Assets;
import utilities.Random;
import utilities.Utils;

import openfl.display.Sprite;
import openfl.display.Bitmap;
import openfl.display.BitmapData;
import openfl.text.TextField;

import openfl.events.MouseEvent;
import motion.Actuate;

import enums.Color;
import enums.Fill;
import enums.Shape;
import enums.Amount;
import enums.GameState;
import enums.SelectionType;

/**
 * A board class that draws the game board and holds the cards
 * It also handles the rules of the game
 * @author Mark
 */
class ScreenBoard extends Sprite
{
	private var cards:Array<Card> = new Array();
	private var deck:Array<Card> = new Array();
	private var selected:Array<Card> = new Array();

	private var columns:Int;
	private var rows:Int;

	public var score:Int = 0;
	public var findAmount:Int = 0;
	public var rowAmount:Int = 0;

	private var firstDraw:Bool = true;
	private var cardBack:Bitmap = new Bitmap(Assets.getBitmapData("img/card_back.png"));

	private var scoreField:TextField = new TextField();
	private var messageField:TextField = new TextField();

	private var buttonColumn:Button = new Button("Add Column", "img/button.png", "img/button_hover.png", Main.buttonWidth, Main.buttonHeight);
	private var buttonFind:Button = new Button("Find Set", "img/button.png", "img/button_hover.png", Main.buttonWidth, Main.buttonHeight);
	private var buttonNew:Button = new Button("Exit", "img/button.png", "img/button_hover.png", Main.buttonWidth, Main.buttonHeight);

	private var main:Main;
	
	public function new(main:Main, columns:Int, rows:Int)
	{
		super();

		this.main = main;
		this.columns = columns;
		this.rows = rows;

		addScore(0);

		populateDeck();
		fillBoard();

		// Card Back
		cardBack.width = Main.cardWidth;
		cardBack.height = Main.cardHeight;

		// Text Fields
		scoreField.selectable = false;
		scoreField.defaultTextFormat = Main.defaultTextFormat;
		scoreField.height = Main.messageHeight;
		scoreField.width = Main.messageWidth;

		messageField.selectable = false;
		messageField.defaultTextFormat = Main.defaultTextFormat;
		messageField.height = Main.messageHeight;
		messageField.width = Main.messageWidth;
	}

	// Generate all cards that are suppost to be in one deck
	private function populateDeck()
	{
		deck = new Array();

		for (amount in Type.allEnums(Amount))
		{
			for (color in Type.allEnums(Color))
			{
				for (fill in Type.allEnums(Fill))
				{
					for (shape in Type.allEnums(Shape))
					{
						var card:Card = new Card(amount, color, fill, shape);
						deck.push(card);
					}
				}
			}
		}

		deck = Random.randomizeArray(deck);
	}

	// Fills and refills the board with new cards
	private function fillBoard()
	{
		var amount:Int = columns * rows;

		for (i in 0...amount)
		{
			// If amount is bigger than actual array, use push
			if (i >= cards.length)
			{
				var card:Card = deck.pop();

				if (card != null)
				{
					cards.push(card);
				}
			}
			// Otherwise direct set index
			else if (cards[i] == null)
			{
				var card:Card = deck.pop();
				cards[i] = card;
			}
		}
	}

	public function draw(animate:Bool)
	{
		removeChildren();

		// Center the board in the middle of the program window
		var x:Int = Math.round(Main.stageWidth / 2.0);
		var y:Int = Math.round(Main.stageHeight / 2.0);

		Actuate.tween(this, animate ? Main.animationPositionSpeed : 0, { x:x, y:y });

		// Calculate the negative x and y from where the cards start
		var offsetX:Int = -Math.round((((Main.cardWidth + Main.paddingDistance) * columns) - Main.cardWidth) / 2.0);
		var offsetY:Int = -Math.round((((Main.cardHeight + Main.paddingDistance) * rows) - Main.cardHeight) / 2.0);

		// Add card back pile first, so cards draw will render ontop
		if (deck.length > 0)
		{
			var cardBackX:Int = Math.round(offsetX + ((Main.cardWidth + Main.paddingDistance) * columns) - (Main.cardWidth / 2.0));
			var cardBackY:Int = Math.round(offsetY - (Main.cardHeight / 2.0));

			addChild(cardBack);

			Actuate.tween(cardBack, animate ? Main.animationSpeed : 0, { x:cardBackX, y:cardBackY });
		}

		// Position all the cards
		for (column in 0...columns)
		{
			for (row in 0...rows)
			{
				var index:Int = (rows * column) + row;
				var card:Card = cards[index];

				var posX:Int = offsetX + ((Main.cardWidth + Main.paddingDistance) * column);
				var posY:Int = offsetY + ((Main.cardHeight + Main.paddingDistance) * row);

				if (card != null)
				{
					if (card.isNew)
					{
						card.x = offsetX + ((Main.cardWidth + Main.paddingDistance) * columns);
						card.y = offsetY;
						card.isNew = false;
					}

					addChild(card);

					// Add clickevent in this class
					card.addEventListener(MouseEvent.CLICK, onCardClick);

					Actuate.tween(card, Main.animationSpeed, { x:posX, y:posY });
				}
			}
		}

		// Buttons
		offsetY = Math.round(offsetY - (-(Main.buttonHeight / 2.0) + (Main.cardHeight / 2.0)));
		offsetX = Math.round(offsetX - ((Main.buttonWidth / 2.0) + (Main.cardWidth / 2.0) + Main.paddingDistance));

		// Add row button
		buttonColumn.addEventListener(MouseEvent.CLICK, addColumn);

		addChild(buttonColumn);

		Actuate.tween(buttonColumn, animate ? Main.animationSpeed : 0, { x:offsetX, y:offsetY });

		// Add find button
		buttonFind.addEventListener(MouseEvent.CLICK, findSet);

		offsetY = offsetY + ((Main.buttonHeight + Main.paddingDistance));

		addChild(buttonFind);

		Actuate.tween(buttonFind, animate ? Main.animationSpeed : 0, { x:offsetX, y:offsetY });

		// Add new game button
		buttonNew.addEventListener(MouseEvent.CLICK, newGame);

		offsetY = offsetY + ((Main.buttonHeight + Main.paddingDistance));

		addChild(buttonNew);

		Actuate.tween(buttonNew, animate ? Main.animationSpeed : 0, { x:offsetX, y:offsetY });

		// Messages
		offsetY = Math.round((((Main.cardHeight + Main.paddingDistance) * rows) - Main.cardHeight) / 2.0) + Main.paddingDistance + Main.messageHeight;
		offsetX = offsetX + -Math.round(Main.paddingDistance + (Main.cardWidth / 2.0));

		// Add message field
		addChild(messageField);

		Actuate.tween(messageField, animate ? Main.animationSpeed : 0, { x:offsetX, y:offsetY });

		// Add score field
		offsetY = -(offsetY + Main.messageHeight);

		addChild(scoreField);

		Actuate.tween(scoreField, animate ? Main.animationSpeed : 0, { x:offsetX, y:offsetY });
	}

	private function onCardClick(event:MouseEvent)
	{
		// Check if clicked item is a Card
		if (!Std.is(event.currentTarget, Card))
		{
			return;
		}

		showMessage("", 0x000000);
		var card:Card = cast event.currentTarget;

		// If the clicked card is already selected unselect it
		if (Lambda.has(selected, card))
		{
			selected.remove(card);
			card.setSelectedType(SelectionType.None);
		}
		// Otherwise select it and check if there are #Main.cardSelection items selected
		// If so, check if it's valid and act accordingly
		else
		{
			selected.push(card);
			card.setSelectedType(SelectionType.Selected);

			if (selected.length == Main.cardSelection)
			{
				checkForMatch();
			}
		}
	}

	private function checkForMatch()
	{
		var error:String = isValid(selected);

		if (error == null)
		{
			addScore(Main.scoreSet);
			showMessage(Main.messageSet, 0x00FF00);

			var reduceRows:Bool = false;

			// Remove selected cards from board
			for (card in selected)
			{
				removeChild(card);

				var index:Int = cards.indexOf(card);
				cards[index] = null;

				// Try and reduce the rows if necessary
				if (columns > Main.boardColumns)
				{
					// Check if the cards is in the last column
					if (index < (columns * rows) - rows)
					{
						var lastCard:Card = cards.pop();
						cards[index] = lastCard;
						reduceRows = true;
					}
				}
			}

			if (reduceRows) columns--;

			fillBoard();
			draw(true);
		}
		else
		{
			showMessage(StringTools.replace(Main.messageInvalidSet, "{type}", error), 0xFF0000);

			for (card in selected)
			{
				card.setSelectedType(SelectionType.None);
			}
		}

		// Clear any suggest cards
		for (card in cards)
		{
			if (card != null && card.getSelectedType() == SelectionType.Suggested)
			{
				card.setSelectedType(SelectionType.None);
			}
		}

		// Clear selected cards
		selected = new Array();
	}

	// Add score, can be negative (penatly)
	private function addScore(score:Int)
	{
		this.score += score;
		scoreField.text = StringTools.replace(Main.scoreText, "{score}", Std.string(this.score));
	}

	// Show a message below the board
	private function showMessage(message:String, color:Int)
	{
		messageField.text = message;
		messageField.textColor = color;
	}
	
	// Show end screen
	private function newGame(event:MouseEvent) {
		main.switchGameState(GameState.End);
	}

	// Expands the board rows by one
	private function addColumn(event:MouseEvent)
	{
		rowAmount++;
		
		if (columns + 1 <= Main.maxboardColumns)
		{
			columns++;
			fillBoard();
			draw(true);
		}
	}

	private function findSet(event:MouseEvent)
	{
		findAmount++;
		
		for (cardA in cards)
		{
			if (cardA == null)
				continue;

			for (cardB in cards)
			{
				if (cardB == null || cardA == cardB)
					continue;

				for (cardC in cards)
				{
					if (cardC == null || cardA == cardC || cardB == cardC)
						continue;

					var selection : Array<Card> = [cardA, cardB, cardC];
					var error:String = isValid(selection);

					// Found a set!
					if (error == null)
					{
						addScore(Main.scoreFindSet);
						
						for (card in selected)
						{
							card.setSelectedType(SelectionType.None);
						}

						// Clear selected array
						selected = new Array();

						for (card in selection)
						{
							card.setSelectedType(SelectionType.Suggested);
						}

						return;
					}
				}
			}
		}

		// If there can't be any cards added, the game is over
		if (deck.length == 0) {
			main.switchGameState(GameState.End);
			return;
		}
		
		// Show message that there is no set found
		showMessage(Main.messageNoSet, 0xFF0000);
	}

	// Return the type that doesn't match or null if everything matches
	private function isValid(cards:Array<Card>):String
	{
		for (i in 0...cards[0].getValues().length)
		{
			var types:Array<EnumValue> = new Array();

			for (card in cards)
			{
				types.push(card.getValues()[i]);
			}

			if (!Utils.isMatch(types))
			{
				// Get enum name of the current EnumValue, split it on '.' so class name becomes free
				var array:Array<String> = Type.getEnumName(Type.getEnum(cards[0].getValues()[i])).split(".");
				// return the last item in the array (Class/Filename)
				return array[array.length - 1].toLowerCase();
			}
		}

		return null;
	}
}