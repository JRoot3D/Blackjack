package game
{
	import flash.display.Stage;
	import flash.events.MouseEvent;

	public class GameManager
	{
		private const MAX_BET:int=200;
		private const BET:int=20;
		private const CARD_BACK:int=53;
		private const DEALER_MAX_TO_HIT:int=17;
		private const MAX_MONEY:int=2000;

		private var gameTable:Background;

		private var gameStage:Stage;

		private var deckOfCards:DeckOfCardsMathManager;

		private var cardsArray:Array;

		private var curentBet:int=0;
		private var curentBalance:int=MAX_MONEY;

		private var dealer:Player;
		private var you:Player;

		public function GameManager(gs:Stage)
		{
			gameStage=gs;
			gameTable=new Background();
			gameTable.x=gameStage.stageWidth / 2;
			gameTable.y=gameStage.stageHeight / 2;
			gameTable.gotoAndStop("Main");
			gameTable.startGameButton.addEventListener(MouseEvent.CLICK, onStartGameButtonClickHandler);
			gameStage.addChild(gameTable);

			deckOfCards=new DeckOfCardsMathManager();

			cardsArray=deckOfCards.shufleCards();
		}

		protected function onStartGameButtonClickHandler(event:MouseEvent):void
		{
			dealer=new Player;
			you=new Player;
			gameTable.startGameButton.removeEventListener(MouseEvent.CLICK, onStartGameButtonClickHandler);
			gameTable.gotoAndStop("Game");
			initGameInterface();
		}

		private function initGameInterface():void
		{
			gameTable.betButton.addEventListener(MouseEvent.CLICK, onBetButtonClickHandler);
			gameTable.dealButton.addEventListener(MouseEvent.CLICK, onDealButtonClickHandler);
			gameTable.hitButton.addEventListener(MouseEvent.CLICK, onHitlButtonClickHandler);
			gameTable.standButton.addEventListener(MouseEvent.CLICK, onStandlButtonClickHandler);
			gameTable.newGameButton.addEventListener(MouseEvent.CLICK, onNewGameButtonClickHandler);
			gameTable.nextButton.addEventListener(MouseEvent.CLICK, onNextButtonClickHandler);

			setBetLabelText();
			setBalanceLabelText();
			setPlayerValueLabelText();
			setDealerValueLabelText();

			gameTable.standButton.enabled=false;
			gameTable.hitButton.enabled=false;
			gameTable.dealButton.enabled=false;
			gameTable.betButton.enabled=true;

			gameTable.nextButton.visible=false;
			gameTable.newGameButton.visible=false;

			clearTable();

			dealer.reinit();
			you.reinit();

			setBalanceLabelText(curentBalance.toString());

			curentBet=0;

			setPlayerMessageLabelText("Сделайте вашу ставку");
			setDealerMessageLabelText("");
		}

		private function setDealerValueLabelText(s:String=""):void
		{
			gameTable.dealerValueLabel.text=s;
		}

		private function setPlayerValueLabelText(s:String=""):void
		{
			gameTable.playerValueLabel.text=s;
		}

		private function setBalanceLabelText(s:String="0"):void
		{
			gameTable.balanceLabel.text="$" + s;
		}

		private function setBetLabelText(s:String="0"):void
		{
			gameTable.betLabel.text="$" + s;
		}

		private function setPlayerMessageLabelText(s:String=""):void
		{
			gameTable.playerMessageLabel.text="[" + s + "]";
		}

		private function setDealerMessageLabelText(s:String=""):void
		{
			gameTable.dealerMessageLabel.text="[" + s + "]";
		}

		private function placeCard(card:Card):void
		{
			gameStage.addChild(card);
		}

		private function removeCard(card:Card):void
		{
			gameStage.removeChild(card);
		}

		protected function onStandlButtonClickHandler(event:MouseEvent):void
		{
			trace("- [BTN] STAND");
			openDealer();
			gameTable.hitButton.enabled=false;
			gameTable.standButton.enabled=false;
		}

		protected function onHitlButtonClickHandler(event:MouseEvent):void
		{
			trace("- [BTN] HIT");
			newPlayerCard();
		}

		protected function onDealButtonClickHandler(event:MouseEvent):void
		{
			trace("- [BTN] DEAL");
			setPlayerMessageLabelText("Ваши действия");
			gameTable.betButton.enabled=false;
			gameTable.dealButton.enabled=false;

			gameTable.hitButton.enabled=true;
			gameTable.standButton.enabled=true;

			startPlayer();
			startDealer();
		}

		protected function onBetButtonClickHandler(event:MouseEvent):void
		{
			trace("- [BTN] BET");
			if (curentBet < MAX_BET)
			{
				if (curentBalance >= BET)
				{
					curentBalance-=BET;
					curentBet+=BET;

					setBetLabelText(curentBet.toString());
					setBalanceLabelText(curentBalance.toString());

					gameTable.dealButton.enabled=true;
				}
				else
				{
					setPlayerMessageLabelText("Деньги закончились");
					gameTable.betButton.enabled=false;
					gameTable.newGameButton.visible=true;
				}
			}

			if (curentBalance == 0 || curentBet == MAX_BET)
			{
				gameTable.betButton.enabled=false;
			}
		}

		protected function onNewGameButtonClickHandler(event:MouseEvent):void
		{
			trace("- [BTN] NEW GAME");
			curentBalance=MAX_MONEY;
			reShufle();
			initGameInterface();
		}

		protected function onNextButtonClickHandler(event:MouseEvent):void
		{
			trace("- [BTN] NEXT");
			initGameInterface();
		}

		private function newPlayerCard():void
		{
			var nextCard:Card=new Card;

			you.cardY=400;

			nextCard.x=you.cardX;
			nextCard.y=you.cardY;

			var Count:int=cardsArray.pop();

			you.add(Count);

			setPlayerValueLabelText(you.getHandValue().toString());

			nextCard.gotoAndStop(Count);
			you.cardsVisual.push(nextCard);
			you.cardsNumeric.push(Count);

			placeCard(you.cardsVisual[you.cardsVisual.length - 1]);

			if (cardsArray.length == 0)
			{
				reShufle();
			}

			if (you.getHandValue() == 21 && you.cardsNumeric.length > 2)
			{
				setPlayerMessageLabelText("Хватит");
				openDealer();
			}
			else if (you.getHandValue() > 21)
			{
				you.bust=true;
				setPlayerMessageLabelText("Перебор");
				openDealer();
			}
		}

		private function newDealerCard(hideCard:Boolean=false):void
		{
			var nextCard:Card=new Card;

			dealer.cardY=165;

			nextCard.x=dealer.cardX;
			nextCard.y=dealer.cardY;

			var Count:int=cardsArray.pop();

			dealer.add(Count);

			if (hideCard)
			{
				nextCard.gotoAndStop(CARD_BACK);
			}
			else
			{
				nextCard.gotoAndStop(Count);
				setDealerValueLabelText(dealer.getHandValue().toString());
			}
			dealer.cardsVisual.push(nextCard);
			dealer.cardsNumeric.push(Count);
			placeCard(dealer.cardsVisual[dealer.cardsVisual.length - 1]);

			if (cardsArray.length == 0)
			{
				reShufle();
			}
		}

		private function openDealer():void
		{
			var x:int=dealer.cardsVisual[1].x;
			var y:int=dealer.cardsVisual[1].y;
			var openCard:Card=new Card;

			gameTable.hitButton.enabled=false;
			gameTable.standButton.enabled=false;

			openCard.gotoAndStop(dealer.cardsNumeric[1]);
			openCard.x=x;
			openCard.y=y;

			removeCard(dealer.cardsVisual[1]);
			dealer.cardsVisual[1]=openCard;
			placeCard(dealer.cardsVisual[1]);

			setDealerValueLabelText(dealer.getHandValue().toString());

			if (!you.blackjack && !you.bust)
			{
				while (dealer.getHandValue() < DEALER_MAX_TO_HIT)
				{
					newDealerCard();
				}
			}

			if (dealer.cardsNumeric.length == 2 && dealer.getHandValue() == 21)
			{
				dealer.blackjack=true;
				setDealerMessageLabelText("Blackjack");
			}
			else if (dealer.getHandValue() > 21)
			{
				dealer.bust=true;
				setDealerMessageLabelText("Перебор");
			}

			endOfGame();
		}

		private function endOfGame():void
		{
			trace("=============================");
			trace("p BJ: " + you.blackjack);
			trace("p Bust: " + you.bust);
			trace("p Hand: " + you.getHandValue());
			trace("=============================");
			trace("d BJ: " + dealer.blackjack);
			trace("d Bust: " + dealer.bust);
			trace("d Hand: " + dealer.getHandValue());
			trace("=============================");

			if (you.blackjack && dealer.blackjack)
			{
				curentBalance+=curentBet;
				setPlayerMessageLabelText(" Blackjack ничья [ + 0 ");
			}
			else if (you.blackjack && !dealer.blackjack)
			{
				curentBalance+=curentBet * 2.5;
				setPlayerMessageLabelText(" Blackjack  [ + " + (curentBet * 1.5) + " ");
			}
			else if (!you.bust)
			{
				if (dealer.bust)
				{
					curentBalance+=curentBet * 2;
					setPlayerMessageLabelText(" Выиграли! [ + " + curentBet + " ");
				}
				else if (you.getHandValue() == dealer.getHandValue())
				{
					curentBalance+=curentBet;
					setPlayerMessageLabelText(" Ничья [ + 0 ");
				}
				else if (you.getHandValue() > dealer.getHandValue())
				{
					curentBalance+=curentBet * 2;
					setPlayerMessageLabelText(" Выиграли! [ + " + curentBet + " ");
				}
				else
				{
					setPlayerMessageLabelText(" Проиграли [ - " + curentBet + " ");
				}
			}
			else
			{
				setPlayerMessageLabelText(" Перебор [ - " + curentBet + " ");
			}

			gameTable.nextButton.visible=true;
			gameTable.newGameButton.visible=true;

		}

		private function clearTable():void
		{
			if (you.cardsVisual.length > 0)
			{
				for (var j:int=0; j < you.cardsVisual.length; j++)
				{
					removeCard(you.cardsVisual[j])
				}
			}
			if (dealer.cardsVisual.length > 0)
			{
				for (j=0; j < dealer.cardsVisual.length; j++)
				{
					removeCard(dealer.cardsVisual[j])
				}
			}
			reInitAll();
		}

		private function reInitAll():void
		{
			you.reinit();
			dealer.reinit();
			setPlayerValueLabelText();
			setDealerValueLabelText();
		}

		private function reShufle():void
		{
			cardsArray=[];
			cardsArray=deckOfCards.shufleCards();
		}

		private function startPlayer():void
		{
			newPlayerCard();
			newPlayerCard();
		}

		private function startDealer():void
		{
			newDealerCard();
			newDealerCard(true);

			if (you.cardsNumeric.length == 2 && you.getHandValue() == 21)
			{
				you.blackjack=true;
				gameTable.hitButton.enabled=false;
				gameTable.standButton.enabled=false;
				openDealer();
			}
		}
	}
}
