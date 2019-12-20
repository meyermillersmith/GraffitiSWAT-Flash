package com.lessrain.project.view.components.scrollbar {
	import com.lessrain.data.Size;

	import flash.display.DisplayObjectContainer;
	import flash.display.Sprite;
	import flash.events.Event;
	import flash.events.KeyboardEvent;
	import flash.events.MouseEvent;
	import flash.geom.Rectangle;
	import flash.ui.Keyboard;

	/**
	 * @author lessintern
	 */
	public class Scrollbar extends Sprite {

		public static const GRAB_MODE_OFF : String = 'grabModeOff';
		public static const REQUEST_GRAB_MODE_ON : String = 'requestGrabModeOn';
		private var _target : Sprite;
		private var _scrollSize : Size;
		private var _targetOutsider : Sprite;
		private var _targetDragRect : Rectangle;
		private var _grabModeActive : Boolean;
		private var _targetFriend : DisplayObjectContainer;
		private var _spaceDown : Boolean;
		private var _active : Boolean;
		private var _targetBottomY : Number;

		public function Scrollbar(target_ : Sprite, targetFriend_ : DisplayObjectContainer, targetOutsider_ : Sprite) {
			_target = target_;
			_targetFriend = targetFriend_;
			_targetOutsider = targetOutsider_;
			_targetDragRect = new Rectangle();
		}

		public function updateBar() : void {
			updateTargetDragRect();
			
			_scrollSize = new Size(stage.stageWidth, _targetBottomY);
			var valueX : Number = _targetFriend.width > 0 ? _scrollSize.w / _targetFriend.width : 1;
			var valueY : Number = _targetFriend.height > 0 ? _scrollSize.h / _targetFriend.height : 1;
			_active = valueX < 1 || valueY < 1 ;
			
			if (_active) {
				activateStageListeners();
				
			} else {
				deactivateStageListeners();
			}
		}

		private function updateTargetDragRect() : void {
			var margin:Number = stage.stageWidth -_targetFriend.width;
			_targetDragRect.x = margin > 0? _target.x : margin;
			_targetDragRect.width = margin > 0? 0 : _targetFriend.width - stage.stageWidth;
			
			updateTargetY();
		}

		private function updateTargetY() : void {
			var margin:Number = _targetBottomY - _targetFriend.height;
			_targetDragRect.y = margin > 0? _target.y : margin;
			_targetDragRect.height = margin > 0 ? 0 : _targetFriend.height - _targetBottomY;
		}

		private function onPressKey(event : KeyboardEvent) : void {
			switch(event.keyCode) {
				case Keyboard.SPACE:
					if (!_spaceDown) {
						_spaceDown = true;
						grabModeActive = true;
					}
					break;
			}
		}

		private function onReleaseKey(event : KeyboardEvent) : void {
			if (event.keyCode == Keyboard.SPACE) {
				_spaceDown = false;
				grabModeActive = false;
			}
		}
		
		public function set grabModeActive(active_ : Boolean) : void {
			if (active_){
				dispatchEvent(new Event(REQUEST_GRAB_MODE_ON));
			} else if (_grabModeActive){
				_target.removeEventListener(MouseEvent.MOUSE_DOWN, startReverseDragging);
				stage.removeEventListener(MouseEvent.MOUSE_UP, stopReverseDragging);
				stopReverseDragging();
				_grabModeActive = false;
				dispatchEvent(new Event(GRAB_MODE_OFF));
			}
		}

		public function grabModeRequestGranted() : void {
			_grabModeActive = true;
			_target.addEventListener(MouseEvent.MOUSE_DOWN, startReverseDragging);
		}


		private function startReverseDragging(event : MouseEvent) : void {
			stage.addEventListener(MouseEvent.MOUSE_UP, stopReverseDragging);
			_target.startDrag(false,_targetDragRect);
			addEventListener(Event.ENTER_FRAME, reverseRender);
		}

		private function stopReverseDragging(event : MouseEvent = null) : void {
			_target.stopDrag();
			removeEventListener(Event.ENTER_FRAME, reverseRender);
			reverseRender();
		}

		private function reverseRender(event : Event = null) : void {
			_targetOutsider.x = -_target.x;
			_targetOutsider.y = -_target.y;
		}
		
		public function set active(active_ : Boolean) : void {
			_active = active_;
			if (active_){
				updateBar();
			} else {
				deactivateStageListeners();
			}
		}

		private function activateStageListeners() : void {
			stage.addEventListener(KeyboardEvent.KEY_DOWN, onPressKey);
			stage.addEventListener(KeyboardEvent.KEY_UP, onReleaseKey);
		}

		private function deactivateStageListeners() : void {
			stage.removeEventListener(KeyboardEvent.KEY_DOWN, onPressKey);
			stage.removeEventListener(KeyboardEvent.KEY_UP, onReleaseKey);
			_spaceDown = false;
		}

		public function set targetFriend(targetFriend : DisplayObjectContainer) : void {
			_targetFriend = targetFriend;
		}

		public function get grabModeActive() : Boolean {
			return _grabModeActive;
		}

		public function get active() : Boolean {
			return _active;
		}

		public function set targetBottomY(targetBottomY : Number) : void {
			_targetBottomY = targetBottomY;
		}
	}
}
