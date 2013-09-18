// JavaScript Document
window.fbAsyncInit = function()
{
    // init the FB JS SDK 
    FB.init({
        appId : '439035149550637',
        status : true, 
        cookie : true, 
        xfbml : true});
};

(function(d, debug)
{
    var js, id = 'facebook-jssdk', ref = d.getElementsByTagName('script')[0];
    if (d.getElementById(id)) {return;}
    js = d.createElement('script'); js.id = id; js.async = true;
    js.src = "http://connect.facebook.net/en_US/all" + (debug ? "/debug" : "") + ".js"; 
    ref.parentNode.insertBefore(js, ref);
	console.log('FB init: Done'); 
}(document, /*debug*/ false));
			
function postToWallBlackjack() {  
    FB.login(function(response) {
        if (response.authResponse) {
        FB.ui({
            method: 'feed', 
            name: 'Test App Blackjack Dialog',
            link: 'https://apps.facebook.com/439035149550637/',
            picture: 'http://jroottestapp.hol.es/facebook/blackjack.jpg',
            caption: 'Блекджек',
            description: 'Выиграл в Блекджек!!!'
        });
      } else {
        alert('User cancelled login or did not fully authorize.');
      }
    }, {scope: 'user_likes,offline_access,publish_stream'});
    return false;
}