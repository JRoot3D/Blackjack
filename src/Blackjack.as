package
{
	import flash.display.Sprite;

	import game.*;

	[SWF(width="800", height="600")]

	public class Blackjack extends Sprite
	{
		public function Blackjack()
		{
			var gameSession:GameManager=new GameManager(stage);
		}
	}
}
