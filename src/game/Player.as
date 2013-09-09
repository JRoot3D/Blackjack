package game
{

	public class Player
	{
		private var handValue:int;
		private var handValueAce:int;
		private var isBlackjack:Boolean;
		private var isBust:Boolean;
		private var cards:Array;
		private var cardsFaces:Array;
		private var cardPosX:int;
		private var cardPosY:int;
		private var isCardUp:Boolean;

		private var deckOfCards:DeckOfCardsMathManager;

		public function Player(deck:DeckOfCardsMathManager)
		{
			onInit();
			deckOfCards=deck;
		}

		public function onInit():void
		{
			handValue=0;
			handValueAce=0;
			isBlackjack=false;
			isBust=false;
			cards=[];
			cardsFaces=[];
			cardPosX=100;
			isCardUp=true;
		}

		public function getHandValue():int
		{
			return handValueAce <= 21 ? handValueAce : handValue;
		}

		public function addCard(count:int):void
		{
			handValue+=deckOfCards.getCardPrice(count);
			handValueAce+=deckOfCards.getCardPrice(count);
			if (count >= 1 && count <= 4)
			{
				handValueAce+=10;
			}
		}

		public function get blackjack():Boolean
		{
			return isBlackjack;
		}

		public function set blackjack(value:Boolean):void
		{
			isBlackjack=value;
		}

		public function get bust():Boolean
		{
			return isBust;
		}

		public function set bust(value:Boolean):void
		{
			isBust=value;
		}

		public function get cardsNumeric():Array
		{
			return cards;
		}

		public function set cardsNumeric(value:Array):void
		{
			cards=value;
		}

		public function get cardsVisual():Array
		{
			return cardsFaces;
		}

		public function set cardsVisual(value:Array):void
		{
			cardsFaces=value;
		}

		public function get cardX():int
		{
			return cardPosX+=75;
		}

		public function get cardY():int
		{
			isCardUp=!isCardUp;
			return isCardUp ? cardPosY + 10 : cardPosY;
		}

		public function set cardY(value:int):void
		{
			cardPosY=value;
		}
	}
}
