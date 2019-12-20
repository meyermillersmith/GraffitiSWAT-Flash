package com.lessrain.project.view.utils {
	import com.lessrain.debug.Debug;
	import com.lessrain.project.view.components.Blocker;

	import flash.display.Sprite;
	import flash.display.StageDisplayState;
	import flash.events.Event;
	import flash.events.KeyboardEvent;
	import flash.ui.Keyboard;

	/**
	 * @author denise
	 */
	public final class FullScreenManager extends Sprite {
		private static var _instance : FullScreenManager;
		private static var _canInit : Boolean;
		private var _blocker : Blocker;
		
	 
		 public function FullScreenManager() {
	      if (_canInit == false) {
	        throw new Error(
	          'FlashDisplay is an singleton and cannot be instantiated.'
	        );
	      } 
			_blocker = addChild(new Blocker()) as Blocker;
			addEventListener(Event.ADDED_TO_STAGE, onAddedToStage);
		}

		private function onAddedToStage(event : Event) : void {
			removeEventListener(Event.ADDED_TO_STAGE, onAddedToStage);
			stage.addEventListener(Event.FULLSCREEN, onFullScreenChanged);
		}
		 
		 public static function getInstance():FullScreenManager {
		      if (_instance == null) {
		        _canInit = true;
		        _instance = new FullScreenManager();
		        _canInit = false;
		      }
			return _instance;
		}

		private function onFullScreenChanged(event : Event = null) : void {
			if (isFullScreen){
				stage.addEventListener(KeyboardEvent.KEY_DOWN, onPressKey);
			} else {
				stage.removeEventListener(KeyboardEvent.KEY_DOWN, onPressKey);
			}
		}

		public function closeFullscreen() : void {
			if (isFullScreen){
				stage.displayState = StageDisplayState.NORMAL;
				stage.removeEventListener(KeyboardEvent.KEY_DOWN, onPressKey);
				onFullScreenChanged();
			}
		}

		public function goFullscreen() : void {
			if (isNotFullScreen){
				stage.displayState = StageDisplayState.FULL_SCREEN;
				stage.addEventListener(KeyboardEvent.KEY_DOWN, onPressKey);
				onFullScreenChanged();
			}
		}

		private function onPressKey(event : KeyboardEvent) : void {
			Debug.trace('FullScreenManager::onPressKey:event.keyCode '+event.keyCode+' != Keyboard.SPACE '+Keyboard.SPACE+' shift '+Keyboard.SHIFT);
			if (event.keyCode != Keyboard.SPACE){
				//_blocker.showMsgByKey('fullscreen.presskey.warning');
			}
		}
		
		public function get isFullScreen() : Boolean {
			return stage.displayState == StageDisplayState.FULL_SCREEN;
		}
		
		public function get isNotFullScreen() : Boolean {
			return !isFullScreen;
		}
	}
}
