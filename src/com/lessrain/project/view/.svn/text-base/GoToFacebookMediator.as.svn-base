package com.lessrain.project.view {
	import com.lessrain.project.ApplicationFacade;
	import com.lessrain.project.model.ApplicationParamsProxy;
	import com.lessrain.project.view.components.ConfirmationPopup;

	import org.puremvc.as3.multicore.interfaces.INotification;
	import org.puremvc.as3.multicore.patterns.mediator.Mediator;

	import flash.events.Event;
	import flash.net.URLRequest;
	import flash.net.navigateToURL;
	import flash.utils.getQualifiedClassName;

	
	/**
	 * @author torstenhartel
	 */
	public class GoToFacebookMediator extends Mediator {
	
		public static const NAME : String = getQualifiedClassName(GoToFacebookMediator);
		private var _fbid : String;
		private var _confirmLeave : ConfirmationPopup;
	
		public function GoToFacebookMediator() {
			super(NAME);
		}
	
		override public function listNotificationInterests(): Array {
			var interests : Array = new Array();
			interests.push(ApplicationFacade.GO_TO_FACEBOOK_APP);
			return interests;
		}
		
		override public function handleNotification(notification_: INotification): void {
			switch( notification_.getName()){
				case ApplicationFacade.GO_TO_FACEBOOK_APP:
					showConfirmPopup();
					break;
				default :
					break;
			}
		}

		private function showConfirmPopup() : void {
			if (!_confirmLeave) {
				_confirmLeave = new ConfirmationPopup();
				_confirmLeave.addBlocker();
				_confirmLeave.addEventListener(ConfirmationPopup.CONFIRM, leaveToFacebook);
			}
			_confirmLeave.show();
		}

		private function leaveToFacebook(event : Event) : void {
			var request:URLRequest = new URLRequest("http://apps.facebook.com/graffitiswat/?source=graffitiswat.com");
			navigateToURL(request, "_self");
		}

		override public function onRegister(): void {
			var applicationParamsProxy : ApplicationParamsProxy = ApplicationParamsProxy(facade.retrieveProxy(ApplicationParamsProxy.NAME));
			_fbid = applicationParamsProxy.getFacebookId();
		}
		
		override public function onRemove(): void {
		
		}
	}
}