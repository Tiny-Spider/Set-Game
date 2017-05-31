package;

import openfl.Assets;

import openfl.display.Sprite;
import openfl.display.Bitmap;
import openfl.display.BitmapData;

import openfl.events.MouseEvent;

import utilities.Utils;

import enums.Color;
import enums.Fill;
import enums.Shape;
import enums.Amount;
import enums.SelectionType;

/**
 * Card class that hold all necessary card data
 * @author Mark
 */
class Card extends Sprite
{
	public var amount:Amount;
	public var color:Color;
	public var fill:Fill;
	public var shape:Shape;

	public var isNew:Bool = true;
	
	private var card:Bitmap;

	private var selection:Bitmap = new Bitmap();
	private var selectionType:SelectionType = SelectionType.None;

	public function new(amount:Amount, color:Color, fill:Fill, shape:Shape)
	{
		super();

		this.amount = amount;
		this.color = color;
		this.fill = fill;
		this.shape = shape;

		// Card
		card = new Bitmap(Assets.getBitmapData(getFileName()));

		card.width = Main.cardWidth;
		card.height = Main.cardHeight;
		card.x = -(Main.cardWidth / 2.0);
		card.y = -(Main.cardHeight / 2.0);

		addChild(card);

		// Selection Outline
		selection.x = card.x;
		selection.y = card.y;

		addChild(selection);
	}

	// Set the selected type
	public function setSelectedType(selectionType:SelectionType)
	{
		this.selectionType = selectionType;
		
		switch (selectionType)
		{
			case SelectionType.Selected:
				selection.bitmapData = Assets.getBitmapData("img/selection.png");
			case SelectionType.Suggested:
				selection.bitmapData = Assets.getBitmapData("img/suggestion.png");
			default:
				selection.bitmapData = null;
				return;
		}
		
		selection.width = card.width;
		selection.height = card.height;
	}

	// Get the selected type
	public function getSelectedType():SelectionType
	{
		return selectionType;
	}

	// Returns all the card values with their according type as string
	public function getValues():Array<EnumValue>
	{
		return [amount, color, fill, shape];
	}

	// Returns the correct filename based on the card's values that can be found in img/cards/
	private function getFileName():String
	{
		return "img/cards/" + Std.string(Utils.getIntValue(amount)).toLowerCase() + "_" + Std.string(color).toLowerCase() + "_" + Std.string(fill).toLowerCase() + "_" + Std.string(shape).toLowerCase() + ".png";
	}
}