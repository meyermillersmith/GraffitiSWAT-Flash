package {
	import com.lessrain.project.view.components.Application;

	import flash.display.Sprite;
	import flash.system.Security;

	public class Main extends Sprite {
		public function Main() {
			/*Security.loadPolicyFile("http://graph.facebook.com/crossdomain.xml");
			Security.loadPolicyFile("http://profile.ak.fbcdn.net/crossdomain.xml");
			Security.allowDomain("*");
			Security.allowInsecureDomain("*");*/

			Security.allowDomain("*.facebook.com");
			Security.allowDomain("profile.ak.fbcdn.net");
			Security.allowDomain("static.ak.fbcdn.net");
			Security.allowDomain("graph.facebook.com");

			Security.allowInsecureDomain("*");

			Security.loadPolicyFile("https://graph.facebook.com/crossdomain.xml");
			var application : Application = new Application();
			addChild(application);
		}
	}
}