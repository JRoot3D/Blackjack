package game
{
	import flash.external.ExternalInterface;
	
	public class FacebookManager
	{
		public function FacebookManager()
		{
		}
		
		public function postToWallBlackjack():void
		{
			ExternalInterface.call("postToWallBlackjack");
		}
	}
}