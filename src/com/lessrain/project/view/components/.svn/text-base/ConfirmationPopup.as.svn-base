package com.lessrain.project.view.components {
	import com.lessrain.data.Size;
	import com.lessrain.debug.Debug;
	import com.lessrain.project.ApplicationFacade;
	import com.lessrain.project.view.utils.AssetButton;
	import com.lessrain.project.view.utils.LessCheckBox;
	import com.lessrain.project.view.utils.PopupContainer;
	import com.lessrain.project.view.utils.RoundAssetButton;
	import com.lessrain.project.view.utils.SimpleTextButton;
	import com.lessrain.project.view.utils.SimpleTextfield;

	import flash.display.Bitmap;
	import flash.display.DisplayObject;
	import flash.display.Sprite;
	import flash.events.Event;

	/**
	 * @author lessintern
	 */
	public class ConfirmationPopup extends Sprite {

		protected static const DIALOG_WIDTH : int = 400;
		protected static const MARGIN : int = 10;
		protected static const DIALOG_CONTENT_WIDTH : int = DIALOG_WIDTH - 2 * MARGIN;
		private static const IMAGE_MAX_SIZE : Size = new Size(DIALOG_CONTENT_WIDTH, DIALOG_WIDTH - 100);
		public static const CONFIRM : String = "confirm";
		public static const CANCEL : String = "cancel";
		public static const CHECKED : String = "checked";
		
		protected var _dialogWindow : Sprite;
		private var _background : Sprite;
		protected var _title : SimpleTextfield;
		protected var _contentText : SimpleTextfield;
		protected var _confirmButton : SimpleTextButton;
		protected var _cancelButton : AssetButton;
		protected var _dialogContent : Sprite;
		protected var _dialogLowerContent : Sprite;
		private var _checkbox : LessCheckBox;
		private var _blocker : Sprite;
		protected var _bitmap : Bitmap;

		public function ConfirmationPopup(titleKey : String = '', contentKey : String = '', confirmKey : String = 'confirmation.confirm', cancelKey : String = 'confirmation.cancel', contentCss : String = '.popup') {
			PopupContainer.getInstance().addChild(this);
			_dialogWindow = addChild(new Sprite()) as Sprite;

			_background = _dialogWindow.addChild(Sprite(ApplicationFacade.getSWFAssetInstance('PopupBackground')).getChildByName('bg')) as Sprite;
			_background.width = DIALOG_WIDTH;

			_dialogContent = _dialogWindow.addChild(new Sprite()) as Sprite;
			_dialogContent.x = _dialogContent.y = MARGIN;

			_dialogLowerContent = _dialogContent.addChild(new Sprite()) as Sprite;

			if (titleKey.length > 0) {
				_title = _dialogContent.addChild(new SimpleTextfield(ApplicationFacade.getCopy(titleKey), '.popupTitle')) as SimpleTextfield;
				_dialogLowerContent.y = _title.y + _title.height + MARGIN;
			}

			if (contentKey.length > 0) _contentText = _dialogLowerContent.addChild(new SimpleTextfield(ApplicationFacade.getCopy(contentKey), contentCss, DIALOG_CONTENT_WIDTH, true, true)) as SimpleTextfield;			
			
			_confirmButton = _dialogLowerContent.addChild(new SimpleTextButton(ApplicationFacade.getCopy(confirmKey), '.popupButton', 1, -1, 21, -1, true, 0xEF8F00, 0xFF7700)) as SimpleTextButton;
			_confirmButton.addEventListener(SimpleTextButton.CLICK, confirm);
			if (_contentText) _confirmButton.y = _contentText.y + _contentText.height + MARGIN * 2;

			if (cancelKey != ''){
			_cancelButton = _dialogLowerContent.addChild(new SimpleTextButton(ApplicationFacade.getCopy(cancelKey), '.popupButton', 1)) as AssetButton;
			_cancelButton.x = _confirmButton.x + _confirmButton.width + MARGIN;
			_cancelButton.y = _confirmButton.y ;
			} else {
				_cancelButton = _dialogWindow.addChild(new RoundAssetButton('PaletteClose')) as AssetButton;
				_cancelButton.x = DIALOG_WIDTH - MARGIN - _cancelButton.width;
				_cancelButton.y = MARGIN / 2;
			}
			_cancelButton.addEventListener(SimpleTextButton.CLICK, cancel);
			
			stage.addEventListener(Event.RESIZE, resize);
		}
//
		public function addCheckbox() : void {
			_checkbox =  _dialogLowerContent.addChild(new LessCheckBox('confirmation.checkbox')) as LessCheckBox;
			_checkbox.y = _confirmButton.y + _confirmButton.height + MARGIN;
			_checkbox.alpha = .5;
			repositionDialog();
		}

		protected function addImage(bitmap_:Bitmap, inLowerContent:Boolean = false, itemAbove : DisplayObject = null) : void {
			_bitmap = bitmap_;
			_bitmap.smoothing = true;
			var scaleX:Number = IMAGE_MAX_SIZE.w / _bitmap.width;
			var scaleY:Number = IMAGE_MAX_SIZE.h / _bitmap.height;
			var scale:Number = scaleX < scaleY ? scaleX : scaleY;
			if (scale < 1) {
				_bitmap.scaleX = _bitmap.scaleY = scale;
			}
			if (_bitmap.width < IMAGE_MAX_SIZE.w){
				_bitmap.x = (IMAGE_MAX_SIZE.w - _bitmap.width) / 2;
			}
			if (!itemAbove) itemAbove = _title;
//			_bitmap.y = _title.height + MARGIN;
			
			_bitmap.y = itemAbove.y + itemAbove.height + MARGIN * (inLowerContent? 2 : 1);
			
			if (inLowerContent){
				_confirmButton.y = _bitmap.y + _bitmap.height + MARGIN * 2;
				_cancelButton.y =_confirmButton.y ;
				_dialogLowerContent.addChild(_bitmap);
			} else {
				_dialogContent.addChild(_bitmap);
			}
		}
		
		public function set cancelAllowed( isAllowed : Boolean):void{
			_cancelButton.visible = isAllowed;
		}
//
		public function addBlocker() : void {
			_blocker =  addChild(new Sprite) as Sprite;
			setChildIndex(_blocker, 0);
			resizeBlocker();
		}

		private function resizeBlocker() : void {
			_blocker.graphics.clear();
			_blocker.graphics.beginFill(0x000000 , .5);
			_blocker.graphics.drawRect(0, 0, stage.stageWidth, stage.stageHeight);
			_blocker.graphics.endFill();
		}

		protected function resize(event : Event = null) : void {
			if (visible) {
				repositionDialog();
				if (_blocker) resizeBlocker();
			}
		}

		public function show() : void {
			Debug.trace('ConfirmationPopup::show:');
			repositionDialogContent();
			if (_blocker) resizeBlocker();
			visible = true;
		}

		protected function repositionDialogContent() : void {
			if (_bitmap && _bitmap.parent == _dialogContent) _dialogLowerContent.y = _bitmap.y + _bitmap.height + MARGIN;
			_background.height = _dialogContent.y + _dialogContent.height + MARGIN * (_bitmap? 1.5 : 1);
			Debug.trace('ConfirmationPopup::repositionDialogContent:_dialogContent.height '+_dialogContent.height+' _background.height '+_background.height);
			repositionDialog();
		}

		protected function repositionDialog() : void {
			_dialogWindow.x = (stage.stageWidth - DIALOG_WIDTH) / 2;
			_dialogWindow.y = (stage.stageHeight - _dialogWindow.height) / 2;
			Debug.trace('ConfirmationPopup::repositionDialogContent:_dialogWindow.x '+_dialogWindow.x+' _dialogWindow.y '+_dialogWindow.y);
		}

		protected function confirm(event : Event = null) : void {
			if (_checkbox && _checkbox.checked){
				_checkbox.finalize();
				dispatchEvent(new Event(CHECKED));
			}
			dispatchEvent(new Event(CONFIRM));
			close();
		}

		protected function cancel(event : Event) : void {
			if (_checkbox) _checkbox.checked = false;
			dispatchEvent(new Event(CANCEL));
			close();
		}

		public function close() : void {
			visible = false;
		}
		
		public function set titleKey(titleKey_ : String) : void {
			_title.text = ApplicationFacade.getCopy(titleKey_);
		}
		
		public function set contentKey(contentKey_ : String) : void {
			_contentText.text = ApplicationFacade.getCopy(contentKey_);
		}

		public function get confirmButton() : SimpleTextButton {
			return _confirmButton;
		}
	}
}
