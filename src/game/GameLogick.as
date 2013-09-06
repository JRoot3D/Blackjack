package game
{
	import flashx.textLayout.factory.TruncationOptions;

	public class GameLogick
	{
		private var youPlayer:Player;
		private var dealerPlayer:Player;
		private var openDealer:Boolean;
		private var balance:int;
		private var bet:int;
		private var playerMsg:String;
		private var dealerMsg:String;

		public function GameLogick(money:int)
		{
			balance=money;
			you=new Player();
			dealer=new Player();
		}

		public function onInit():void
		{
			you.onInit();
			dealer.onInit();
			openDealer=false;
			curentBet=0;
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
				if (you.getHandValue() == 21 && you.cardsNumeric.length > 2)
				{
					openDealer=true;
				}
				else if (you.getHandValue() > 21)
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
			if (you.cardsNumeric.length == 2 && you.getHandValue() == 21)
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

		public function get curentBalance():int
		{
			return balance;
		}

		public function set curentBalance(value:int):void
		{
			balance=value;
		}

		public function get curentBet():int
		{
			return bet;
		}

		public function set curentBet(value:int):void
		{
			bet=value;
		}

		public function getDealerMessage():String
		{
			if (dealer.cardsNumeric.length == 2 && dealer.getHandValue() == 21)
			{
				dealer.blackjack=true;
				dealerMsg="Blackjack";
			}
			else if (dealer.getHandValue() > 21)
			{
				dealer.bust=true;
				dealerMsg="Перебор";
			}
			return dealerMsg;
		}
	}
}
