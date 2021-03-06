package game
{

	public class GameLogic
	{
		private static const BLACKJACK:int = 21;
		
		private var youPlayer:Player;
		private var dealerPlayer:Player;
		private var openDealer:Boolean;
		private var balance:int;
		private var bet:int;
		private var playerMsg:String;
		private var dealerMsg:String;

		private var deckOfCards:DeckOfCardsMathManager;

		private var cardsArray:Array;
		private var showDialog:Boolean;
		
		public function GameLogic(money:int)
		{
			balance=money;

			deckOfCards=new DeckOfCardsMathManager();
			cardsArray=deckOfCards.shufleCards();

			youPlayer=new Player(deckOfCards);
			dealerPlayer=new Player(deckOfCards);
		}

		public function onInit():void
		{
			youPlayer.onInit();
			dealerPlayer.onInit();
			showDialog=false;
			openDealer=false;
			bet=0;
			playerMsg="";
			dealerMsg="";
		}

		public function getPlayerMessage(endOfGame:Boolean=false):String
		{
			if (endOfGame)
			{
				if (you.blackjack && dealer.blackjack)
				{
					balance+=bet;
					playerMsg=" Blackjack ничья [ + 0 ";
				}
				else if (you.blackjack && !dealer.blackjack)
				{
					balance+=bet * 2.5;
					playerMsg=" Blackjack  [ + " + (bet * 1.5) + " ";
					showDialog=true;
				}
				else if (!you.bust)
				{
					if (dealer.bust)
					{
						balance+=bet * 2;
						playerMsg=" Выиграли! [ + " + bet + " ";
					}
					else if (you.getHandValue() == dealer.getHandValue())
					{
						balance+=bet;
						playerMsg=" Ничья [ + 0 ";
					}
					else if (you.getHandValue() > dealer.getHandValue())
					{
						balance+=bet * 2;
						playerMsg=" Выиграли! [ + " + bet + " ";
					}
					else
					{
						playerMsg=" Проиграли [ - " + bet + " ";
					}
				}
				else
				{
					playerMsg=" Перебор [ - " + bet + " ";
				}
			}
			else
			{
				if (you.getHandValue() == BLACKJACK && you.cardsNumeric.length > 2)
				{
					openDealer=true;
				}
				else if (you.getHandValue() > BLACKJACK)
				{
					you.bust=true;
					openDealer=true;
				}
				playerMsg="Ваши действия";
			}

			return playerMsg;
		}

		public function get you():Player
		{
			return youPlayer;
		}

		public function set you(value:Player):void
		{
			youPlayer=value;
		}

		public function get dealer():Player
		{
			return dealerPlayer;
		}

		public function set dealer(value:Player):void
		{
			dealerPlayer=value;
		}


		public function checkPlayerBlackjack():Boolean
		{
			if (you.cardsNumeric.length == 2 && you.getHandValue() == BLACKJACK)
			{
				you.blackjack=true;
			}
			else
			{
				you.blackjack=false;
			}

			return you.blackjack;
		}

		public function get openDealerFlag():Boolean
		{
			return openDealer;
		}

		public function set openDealerFlag(value:Boolean):void
		{
			openDealer=value;
		}

		public function get currentBalance():int
		{
			return balance;
		}

		public function set currentBalance(value:int):void
		{
			balance=value;
		}

		public function get currentBet():int
		{
			return bet;
		}

		public function set currentBet(value:int):void
		{
			bet=value;
		}

		public function getDealerMessage():String
		{
			if (dealer.cardsNumeric.length == 2 && dealer.getHandValue() == BLACKJACK)
			{
				dealer.blackjack=true;
				dealerMsg="Blackjack";
			}
			else if (dealer.getHandValue() > BLACKJACK)
			{
				dealer.bust=true;
				dealerMsg="Перебор";
			}
			return dealerMsg;
		}

		public function playerStopGame():Boolean
		{
			return !you.blackjack && !you.bust;
		}

		public function nextCard():int
		{
			var cardId:int;
			cardId=cardsArray.pop();

			if (cardsArray.length == 0)
			{
				reShufle();
			}

			return cardId;
		}

		public function reShufle():void
		{
			cardsArray=[];
			cardsArray=deckOfCards.shufleCards();
		}

		public function get showBlackjackDialog():Boolean
		{
			return showDialog;
		}
	}
}
