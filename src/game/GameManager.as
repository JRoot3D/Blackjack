package game
{
	import flash.display.Loader;
	import flash.display.MovieClip;
	import flash.display.Stage;
	import flash.events.Event;
	import flash.events.MouseEvent;
	import flash.net.URLRequest;
	import flash.system.ApplicationDomain;

	public class GameManager
	{
		private static const CARD_BACK:int=53;
		private static const MAX_BET:int=200;
		private static const BET:int=20;
		private static const DEALER_MAX_TO_HIT:int=17;
		private static const MAX_MONEY:int=2000;
		
		private static const BACKGROUND:String="Background";
		private static const CARD:String="Card";
		private static const BLACKJACK_DIALOG:String="BlackjackDialog";
		
		private static const GAME:String="Game";
		private static const MAIN:String="Main";
		
		private static const PLACE_A_BET:String="Сделайте вашу ставку";
		private static const YOUR_ACTION:String="Ваши действия";
		private static const MONEY_GONE:String="Деньги закончились";
		
		
		private var gameStage:Stage;
		private var loader:Loader;
		private var appDomain:ApplicationDomain;

		private var Card:Class;
		private var BlackjackDialog:Class;
		
		private var gameStatus:GameLogic;

		private var gameTable:MovieClip;
		private var blackjackDialog:MovieClip;

		public function GameManager(gStage:Stage)
		{
			gameStage=gStage;

			loader=new Loader();
			loader.contentLoaderInfo.addEventListener(Event.COMPLETE, completeHandler);
			loader.load(new URLRequest("assets/GameRes.swf"));

			gameStatus=new GameLogic(MAX_MONEY);
		}

		private function completeHandler(event:Event):void
		{
			appDomain=loader.contentLoaderInfo.applicationDomain;

			if (appDomain.hasDefinition(BACKGROUND))
			{
				var Background:Class=appDomain.getDefinition(BACKGROUND) as Class;
				gameTable=new Background();

				gameTable.x=gameStage.stageWidth / 2;
				gameTable.y=gameStage.stageHeight / 2;
				gameTable.gotoAndStop(MAIN);
				gameTable.startGameButton.addEventListener(MouseEvent.CLICK, onStartGameButtonClickHandler);
				gameStage.addChild(gameTable);
			}

			if (appDomain.hasDefinition(CARD))
			{
				Card=appDomain.getDefinition(CARD) as Class;
			}
			
			if (appDomain.hasDefinition(BLACKJACK_DIALOG))
			{
				BlackjackDialog=appDomain.getDefinition(BLACKJACK_DIALOG) as Class;
			}
		}

		protected function onStartGameButtonClickHandler(event:MouseEvent):void
		{
			gameTable.startGameButton.removeEventListener(MouseEvent.CLICK, onStartGameButtonClickHandler);
			gameTable.gotoAndStop(GAME);
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

			setPlayerMessageLabelText(PLACE_A_BET);
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

		private function placeCard(card:MovieClip):void
		{
			gameStage.addChild(card);
		}

		private function removeCard(card:MovieClip):void
		{
			gameStage.removeChild(card);
		}

		protected function onStandlButtonClickHandler(event:MouseEvent):void
		{
			openDealer();
			gameTable.hitButton.enabled=false;
			gameTable.standButton.enabled=false;
		}

		protected function onHitlButtonClickHandler(event:MouseEvent):void
		{
			newPlayerCard();
		}

		protected function onDealButtonClickHandler(event:MouseEvent):void
		{
			setPlayerMessageLabelText(YOUR_ACTION);
			gameTable.betButton.enabled=false;
			gameTable.dealButton.enabled=false;

			gameTable.hitButton.enabled=true;
			gameTable.standButton.enabled=true;

			startPlayer();
			startDealer();
		}

		protected function onBetButtonClickHandler(event:MouseEvent):void
		{
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
					setPlayerMessageLabelText(MONEY_GONE);
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
			gameStatus.currentBalance=MAX_MONEY;
			gameStatus.reShufle();
			initGameInterface();
		}

		protected function onNextButtonClickHandler(event:MouseEvent):void
		{
			initGameInterface();
		}

		private function newPlayerCard():void
		{
			var nextCard:MovieClip=new Card();

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
			var nextCard:MovieClip=new Card();

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

			var openCard:MovieClip=new Card();

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
			
			if(gameStatus.showBlackjackDialog)
			{
				blackjackDialog = new BlackjackDialog();
				blackjackDialog.okButton.addEventListener(MouseEvent.CLICK, okButtonClickHandler);
				blackjackDialog.x=gameStage.stageWidth / 2;
				blackjackDialog.y=gameStage.stageHeight / 2;
				gameStage.addChild(blackjackDialog);
			}
			else
			{
				gameTable.nextButton.visible=true;
				gameTable.newGameButton.visible=true;	
			}			
		}
		
		protected function okButtonClickHandler(event:MouseEvent):void
		{			
			if(blackjackDialog.postToWallCheckBox.selected)
			{
				var facebookManager:FacebookManager = new FacebookManager;
				facebookManager.postToWallBlackjack();				
			}				
			blackjackDialog.okButton.removeEventListener(MouseEvent.CLICK, okButtonClickHandler);
			gameStage.removeChild(blackjackDialog);
			gameTable.nextButton.visible=true;
			gameTable.newGameButton.visible=true;
		}

		private function clearTable():void
		{
			for each (var playerCards:MovieClip in gameStatus.you.cardsVisual)
			{
				removeCard(playerCards);
			}

			for each (var dealerCards:MovieClip in gameStatus.dealer.cardsVisual)
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
