package utilities;

import enums.Amount;

/**
 * Utility class that handles random things
 * @author Mark
 */
class Utils
{

	/**
	 * Returns actual int value of the Amount enum since numbers are not allowed as values
	 */
	public static function getIntValue(amount:Amount):Int
	{
		switch (amount)
		{
			case Amount.One: return 1;
			case Amount.Two: return 2;
			case Amount.Three: return 3;
		}

		return 0;
	}

	/**
	 * Returns true if all values are the same or all values are different
	 * Can check against almost anything and any amount
	 */
	public static function isMatch<T>(values:Array<T>):Bool
	{
		var list:List<T> = new List<T>();

		for (value in values)
		{
			if (!Lambda.has(list, value))
			{
				list.add(value);
			}
		}

		return list.length == 1 || list.length == values.length;
	}
}