package game
{
	import flash.display.Stage;
	import flash.events.MouseEvent;

	public class GameManager
	{
		private const CARD_BACK:int=53;
		
		private const MAX_BET:int=200;
		private const BET:int=20;
		private const DEALER_MAX_TO_HIT:int=17;
		private const MAX_MONEY:int=2000;

		private var gameTable:Background;

		private var gameStage:Stage;

		private var gameStatus:GameLogic;

		public function GameManager(gStage:Stage)
		{
			gameStage=gStage;
			gameTable=new Background();
			gameTable.x=gameStage.stageWidth / 2;
			gameTable.y=gameStage.stageHeight / 2;
			gameTable.gotoAndStop("Main");
			gameTable.startGameButton.addEventListener(MouseEvent.CLICK, onStartGameButtonClickHandler);
			gameStage.addChild(gameTable);

			gameStatus=new GameLogic(MAX_MONEY);
		}

		protected function onStartGameButtonClickHandler(event:MouseEvent):void
		{
			gameTable.startGameButton.removeEventListener(MouseEvent.CLICK, onStartGameButtonClickHandler);
			gameTable.gotoAndStop("Game");
			gameTable.betButton.addEventListener(MouseEvent.CLICK, onBetButtonClickHandler);
			gameTable.dealButton.addEventListener(MouseEvent.CLICK, onDealButtonClickHandler);
			gameTable.hitButton.addEventListener(MouseEvent.CLICK, onHitlButtonClickHandler);
			gameTable.standButton.addEventListener(MouseEvent.CLICK, onStandlButtonClickHandler);
			gameTable.newGameButton.addEventListener(MouseEvent.CLICK, onNewGameButtonClickHandler);
			gameTable.nextButton.addEventListener(MouseEvent.CLICK, onNextButtonClickHandler);
			initGameInterface();
		}

		private function initGameInterface():void
		{
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

			gameStatus.onInit();

			setBalanceLabelText(gameStatus.currentBalance.toString());

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
			if (gameStatus.currentBet < MAX_BET)
			{
				if (gameStatus.currentBalance >= BET)
				{
					gameStatus.currentBalance-=BET;
					gameStatus.currentBet+=BET;

					setBetLabelText(gameStatus.currentBet.toString());
					setBalanceLabelText(gameStatus.currentBalance.toString());

					gameTable.dealButton.enabled=true;
				}
				else
				{
					setPlayerMessageLabelText("Деньги закончились");
					gameTable.betButton.enabled=false;
					gameTable.newGameButton.visible=true;
				}
			}

			if (gameStatus.currentBalance == 0 || gameStatus.currentBet == MAX_BET)
			{
				gameTable.betButton.enabled=false;
			}
		}

		protected function onNewGameButtonClickHandler(event:MouseEvent):void
		{
			trace("- [BTN] NEW GAME");
			gameStatus.currentBalance=MAX_MONEY;
			gameStatus.reShufle();
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

			gameStatus.you.cardY=400;

			nextCard.x=gameStatus.you.cardX;
			nextCard.y=gameStatus.you.cardY;

			var Count:int=gameStatus.nextCard();

			gameStatus.you.addCard(Count);

			setPlayerValueLabelText(gameStatus.you.getHandValue().toString());

			nextCard.gotoAndStop(Count);
			gameStatus.you.cardsVisual.push(nextCard);
			gameStatus.you.cardsNumeric.push(Count);

			placeCard(gameStatus.you.cardsVisual[gameStatus.you.cardsVisual.length - 1]);

			setPlayerMessageLabelText(gameStatus.getPlayerMessage());

			if (gameStatus.openDealerFlag)
			{
				openDealer();
			}
		}

		private function newDealerCard(hideCard:Boolean=false):void
		{
			var nextCard:Card=new Card;

			gameStatus.dealer.cardY=165;

			nextCard.x=gameStatus.dealer.cardX;
			nextCard.y=gameStatus.dealer.cardY;

			var Count:int=gameStatus.nextCard();

			gameStatus.dealer.addCard(Count);

			if (hideCard)
			{
				nextCard.gotoAndStop(CARD_BACK);
			}
			else
			{
				nextCard.gotoAndStop(Count);
				setDealerValueLabelText(gameStatus.dealer.getHandValue().toString());
			}
			gameStatus.dealer.cardsVisual.push(nextCard);
			gameStatus.dealer.cardsNumeric.push(Count);
			placeCard(gameStatus.dealer.cardsVisual[gameStatus.dealer.cardsVisual.length - 1]);
		}

		private function openDealer():void
		{
			var x:int=gameStatus.dealer.cardsVisual[1].x;
			var y:int=gameStatus.dealer.cardsVisual[1].y;

			var openCard:Card=new Card;

			gameTable.hitButton.enabled=false;
			gameTable.standButton.enabled=false;

			openCard.gotoAndStop(gameStatus.dealer.cardsNumeric[1]);
			openCard.x=x;
			openCard.y=y;

			removeCard(gameStatus.dealer.cardsVisual[1]);
			gameStatus.dealer.cardsVisual[1]=openCard;
			placeCard(gameStatus.dealer.cardsVisual[1]);

			setDealerValueLabelText(gameStatus.dealer.getHandValue().toString());

			if (gameStatus.playerStopGame())
			{
				while (gameStatus.dealer.getHandValue() < DEALER_MAX_TO_HIT)
				{
					newDealerCard();
				}
			}
			setDealerMessageLabelText(gameStatus.getDealerMessage());
			setPlayerMessageLabelText(gameStatus.getPlayerMessage(true));
			gameTable.nextButton.visible=true;
			gameTable.newGameButton.visible=true;
		}

		private function clearTable():void
		{
			for each (var playerCards:Card in gameStatus.you.cardsVisual)
			{
				removeCard(playerCards);
			}

			for each (var dealerCards:Card in gameStatus.dealer.cardsVisual)
			{
				removeCard(dealerCards);
			}

			gameStatus.onInit();
			setPlayerValueLabelText();
			setDealerValueLabelText();
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

			if (gameStatus.checkPlayerBlackjack())
			{
				gameTable.hitButton.enabled=false;
				gameTable.standButton.enabled=false;
				openDealer();
			}
		}
	}
}
