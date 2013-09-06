package game
{

	public class DeckOfCardsMathManager
	{
		private const PRICE_JQK:int=10;
		private var baseCards:Array=[];
		private var priceCards:Array=[];


		public function DeckOfCardsMathManager()
		{
			initArrays();
		}

		private function initArrays():void
		{
			for (var i:int=1; i <= 52; i++)
			{
				baseCards.push(i);
			}

			for (i=1; i <= 10; i++)
			{
				for (var j:int=0; j < 4; j++)
				{
					priceCards.push(i);
				}
			}
			for (i=0; i < 12; i++)
			{
				priceCards.push(PRICE_JQK);
			}
		}

		private static function randomShufle(a:*, b:*):Number
		{
			return Math.random() < 0.5 ? -1 : 1;
		}

		public function shufleCards():Array
		{
			var array:Array=baseCards.concat();
			array.sort(randomShufle);
			return array;
		}

		public function getCardPrice(Count:int):int
		{
			return priceCards[Count - 1];
		}
	}
}
