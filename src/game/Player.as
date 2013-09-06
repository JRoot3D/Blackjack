package game
{

	public class Player
	{
		private var playerHandValue:int;
		private var playerHandValueAce:int;
		private var playerBlackjack:Boolean;
		private var playerBust:Boolean;
		private var playerCardsNumeric:Array;
		private var playerCardsVisual:Array;
		private var playerCardX:int;
		private var playerCardY:int;
		private var playerCardUp:Boolean;

		private var deckOfCards:DeckOfCardsMathManager;

		public function Player()
		{
			onInit();
			deckOfCards=new DeckOfCardsMathManager;
		}

		public function onInit():void
		{
			playerHandValue=0;
			playerHandValueAce=0;
			playerBlackjack=false;
			playerBust=false;
			playerCardsNumeric=[];
			playerCardsVisual=[];
			playerCardX=100;
			playerCardUp=true;
		}

		public function getHandValue():int
		{
			return playerHandValueAce <= 21 ? playerHandValueAce : playerHandValue;
		}

		public function addCard(count:int):void
		{
			playerHandValue+=deckOfCards.getCardPrice(count);
			playerHandValueAce+=deckOfCards.getCardPrice(count);
			if (count >= 1 && count <= 4)
			{
				playerHandValueAce+=10;
			}
		}

		public function get blackjack():Boolean
		{
			return playerBlackjack;
		}

		public function set blackjack(value:Boolean):void
		{
			playerBlackjack=value;
		}

		public function get bust():Boolean
		{
			return playerBust;
		}

		public function set bust(value:Boolean):void
		{
			playerBust=value;
		}

		public function get cardsNumeric():Array
		{
			return playerCardsNumeric;
		}

		public function set cardsNumeric(value:Array):void
		{
			playerCardsNumeric=value;
		}

		public function get cardsVisual():Array
		{
			return playerCardsVisual;
		}

		public function set cardsVisual(value:Array):void
		{
			playerCardsVisual=value;
		}

		public function get cardX():int
		{
			return playerCardX+=75;
		}

		public function get cardY():int
		{
			playerCardUp=!playerCardUp;
			if (playerCardUp)
			{
				return playerCardY + 10;
			}
			else
			{
				return playerCardY
			}
		}

		public function set cardY(value:int):void
		{
			playerCardY=value;
		}
	}
}
