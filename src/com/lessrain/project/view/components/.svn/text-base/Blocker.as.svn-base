package com.lessrain.project.view.components {
	import com.greensock.TweenLite;
	import com.lessrain.project.ApplicationFacade;
	import com.lessrain.project.view.utils.SimpleTextButton;
	import com.lessrain.project.view.utils.SimpleTextfield;
	import com.lessrain.util.CallDelay;

	import flash.display.Sprite;
	import flash.events.Event;
	import flash.events.MouseEvent;

	/**
	 * @author lessintern
	 */
	public class Blocker extends Sprite {

		public static const HIDDEN : String = "blockerHidden";
		public static const CANCEL : String = "blockerCancel";
		
		private static const MARGIN_W : int = 10;
		private static const MARGIN_H : int = 20;
		
		private var _messageField : SimpleTextfield;
		private var _circles : Sprite;
		private var _isLoader : Boolean;
		private var _cancelButton : SimpleTextButton;
		private var _messageContainer : Sprite;
		private var _cancelDelay : CallDelay;
		private var _hideDelay : CallDelay;

		public function Blocker(isLoader_ : Boolean = false) {
			_isLoader = isLoader_;
			_circles = addChild(new Sprite()) as Sprite;

			var total : int = 180;
			var r : int = 4;
			for (var i : int = 0; i < total; i++) {
				var circle : Sprite = _circles.addChild(new Sprite()) as Sprite;
				circle.graphics.beginFill(0xFFFFFF, .1 * i / total);
				circle.graphics.drawCircle(20, 0, r);
				circle.graphics.endFill();
				circle.rotation = i / total * 360;
			}
			visible = false;
			addEventListener(Event.ADDED_TO_STAGE, onAddedToStage);
		}

		private function onAddedToStage(event : Event) : void {
			stage.addEventListener(Event.RESIZE, resize);
		}

		private function resize(event : Event) : void {
			if (visible) {
				graphics.clear();
				fillBackground();
				if (_circles.visible) repositionCircle();
				if (_cancelButton && _cancelButton.visible) repositionCancelButton();
				if (_messageContainer && _messageContainer.visible) repositionMessage();
			}
		}

		private function repositionCircle() : void {
			_circles.x = stage.stageWidth / 2;
			_circles.y = stage.stageHeight / 2;
		}

		private function repositionMessage() : void {
			_messageContainer.x = ((stage.stageWidth - _messageContainer.width) / 2);
			_messageContainer.y = ((stage.stageHeight - _messageContainer.height) / 2);
		}

		private function fillBackground() : void {
			graphics.beginFill(0x000000, _isLoader ? 1 : .5);
			graphics.drawRect(0, 0, stage.stageWidth, stage.stageHeight);
			graphics.endFill();
		}

		public function show(cancelOption:Boolean = false, cancelDelay:int = 0) : void {
			fillBackground();
			alpha = 1;
			animateCircle();
			visible = true;
			if (cancelOption){
				showCancelButton(cancelDelay);
			}
		}
		
		public function showCancelButton(delay:int = 0, position:Boolean = true):void{
			if (visible){
				if (delay == 0){
					if (!_cancelButton){
						_cancelButton = addChild(new SimpleTextButton(ApplicationFacade.getCopy('confirmation.cancel'), '.button', 1,-1,25)) as SimpleTextButton;
						_cancelButton.addEventListener(SimpleTextButton.CLICK, onCancel);
					}
					if (position) repositionCancelButton();
					_cancelButton.visible = true;
				} else {
					_cancelDelay = CallDelay.call(showCancelButton, delay);
				}
			}
		}

		private function onCancel(event : Event) : void {
			dispatchEvent(new Event(CANCEL));
			hide();
		}

		private function repositionCancelButton() : void {
			_cancelButton.x = (stage.stageWidth - _cancelButton.width) / 2;
			_cancelButton.y = _circles.y + _circles.height / 2 + 10;
		}

		public function removeCancelButton() : void {
			if (_cancelButton){
				_cancelButton.visible = false;
			}
			removeDelay(_cancelDelay);
		}

		public function animateCircle() : void {
			_circles.visible = true;
			repositionCircle();
			addEventListener(Event.ENTER_FRAME, renderCircle);
		}

		private function renderCircle(event : Event) : void {
			_circles.rotation += 8;
		}

		private function removeCircle() : void {
			removeEventListener(Event.ENTER_FRAME, renderCircle);
			_circles.rotation = 0;
			_circles.visible = false;
		}

		public function hide(event : Event = null) : void {
			if (visible){
				TweenLite.killTweensOf(this);
				removeEventListener(MouseEvent.CLICK, hide);
				removeCircle();
				removeCancelButton();
				removeDelay(_hideDelay);
				visible = false;
				if (_messageContainer) _messageContainer.visible = false;
				graphics.clear();
				dispatchEvent(new Event(HIDDEN));
			}
		}

		private function removeDelay(delay : CallDelay) : void {
			if (delay){
				delay.clear();
				delay.finalize();
				delay = null;
			}
		}

		public function showMsgByKey(msgKey : String) : void {
			if (!visible){
				show();
			}
			showMsg(ApplicationFacade.getCopy(msgKey));
		}
		
		public function showMsg(msg : String) : void {
			removeCircle();
			removeCancelButton();
			if (!_messageContainer) {
				_messageContainer = addChild(Sprite(ApplicationFacade.getSWFAssetInstance('PopupBackground')).getChildByName('bg')) as Sprite;
				_messageField = _messageContainer.addChild(new SimpleTextfield(msg, '.popupTitle', _messageContainer.width - MARGIN_W*2, true,true)) as SimpleTextfield;
				_messageField.x = MARGIN_W;
				_messageField.y = MARGIN_H;
			} else {
				_messageContainer.visible = true;
				_messageField.text = msg;
			}
			repositionMessage();
			removeDelay(_hideDelay);
			_hideDelay = CallDelay.call(fadeOut, 4000);
			addEventListener(MouseEvent.CLICK, hide);
		}

		public function fadeOut() : void {
			TweenLite.to(this, .2, {alpha : 0, onComplete : hide});
		}
	}
}
