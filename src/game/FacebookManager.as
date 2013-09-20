package game
{
	import flash.external.ExternalInterface;

	public class FacebookManager
	{
		public function FacebookManager()
		{
		}

		public function postToWall(picture:String="http://jroottestapp.hol.es/facebook/blackjack.jpg", caption:String="", description:String=""):void
		{
			ExternalInterface.call("postToWall", picture, caption, description);
		}
	}
}
