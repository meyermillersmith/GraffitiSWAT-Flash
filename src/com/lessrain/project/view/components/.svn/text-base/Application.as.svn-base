package com.lessrain.project.view.components 
{
	import com.lessrain.debug.Debug;
	import com.lessrain.project.ApplicationFacade;
	import com.lessrain.uicomponents.managers.ApplicationDisplayListManager;
	import com.pixelbreaker.ui.osx.MacMouseWheel;

	import flash.display.Sprite;
	import flash.events.Event;
	import flash.system.Security;


	/**
	 * @author torstenhartel
	 */
	public class Application extends Sprite {
		
		public static const STATE_LOADING	: String = 'stateLoading';
		public static const STATE_MAIN		: String = 'stateMain';
		
		public static const ACTION_COMPLETE	: String = 'actionComplete';
		
		public static const MIN_WIDTH 		: int = 760;
		
		private var _params 	: Object;
		private var _applicationDisplayListManager : ApplicationDisplayListManager;
		private var _loadingDisplay : Blocker;

		public function Application() {
			addEventListener(Event.ADDED_TO_STAGE, handleAddedToStage);
			Debug.activateLogging('php/action/secure/meeKbooZ0.php');
			Security.loadPolicyFile("https://graffiti.mee-mail.com/crossdomain.xml");
		}

		private function handleAddedToStage(event : Event) : void {
			removeEventListener(Event.ADDED_TO_STAGE, handleAddedToStage);
			startup();
			_loadingDisplay = addChild(new Blocker(true)) as Blocker;
			_loadingDisplay.show();
		}

		private function startup() : void
		{
			_params = root.loaderInfo.parameters;
			
			// Setup mousewheel for mac
			MacMouseWheel.setup(stage);
			
			// Create the ApplicationDisplayListManager for different DO levels of the app
			_applicationDisplayListManager = new ApplicationDisplayListManager();
			addChild(_applicationDisplayListManager);
			
			// Initialize the PureMVC apparatus
			ApplicationFacade.getInstance(ApplicationFacade.NAME).startup(this);
		}


		public function getParam(key_:String) : String {
			return _params[key_];
		}
		
		public function get params(): Object {
			return _params;
		}
		
		public function get applicationDisplayListManager() : ApplicationDisplayListManager {
			return _applicationDisplayListManager;
		}

		public function hideLoadingScreen() : void {
			_loadingDisplay.hide();
		}

		public function showLoadingScreen() : void {
			_loadingDisplay.show();
		}

		public function showError(surfaceTitle : String) : void {
			_loadingDisplay.showMsg(ApplicationFacade.getCopy('surface.error')+' '+surfaceTitle+'<br/> ');
		}
	}
}
