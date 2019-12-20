package com.lessrain.project.view.components.facebook {
	import com.lessrain.project.ApplicationFacade;
	import com.lessrain.project.view.components.ConfirmationPopup;
	import com.lessrain.project.view.utils.FullScreenManager;
	import com.lessrain.project.view.utils.SimpleTextfield;
	import com.lessrain.util.CallDelay;

	import flash.display.Bitmap;
	import flash.display.BitmapData;
	import flash.display.DisplayObject;
	import flash.events.Event;
	import flash.events.FocusEvent;
	import flash.events.KeyboardEvent;
	import flash.text.TextField;
	import flash.text.TextFieldType;
	import flash.text.TextFormat;
	import flash.ui.Keyboard;
	import flash.ui.Mouse;

	/**
	 * @author lessintern
	 */
	public class FacebookUploadPictureDialog extends ConfirmationPopup {
		
		protected var _captionInput : SimpleTextfield;
		private var _captionInputEmpty : Boolean = true;
		protected var _defaultCaptionText : String;
		private var _defaultCaptionFormat : TextFormat;
		private var _userCaptionFormat : TextFormat;
		private var _imageData : BitmapData;
		private var _loosingFocusFullScreen : Boolean;
		private var _fullScreenManager : FullScreenManager;

		public function FacebookUploadPictureDialog(confirmKey : String = 'uploadPicture.title') {

			super('uploadPicture.title',confirmKey,'uploadPicture.upload');

			_defaultCaptionText = ApplicationFacade.getCopy('uploadPicture.captionInput');
			_captionInput = _dialogLowerContent.addChild(new SimpleTextfield(_defaultCaptionText, '.captionInputDefault', DIALOG_CONTENT_WIDTH)) as SimpleTextfield;
			_captionInput.field.selectable = true;
			_captionInput.field.type = TextFieldType.INPUT;
			_captionInput.field.border = true;
			_captionInput.field.borderColor = 0x888888;
			_captionInput.addEventListener(KeyboardEvent.KEY_DOWN, onPressKey);
			_captionInput.addEventListener(FocusEvent.FOCUS_IN, onFocusIn);
			_captionInput.addEventListener(FocusEvent.FOCUS_OUT, onFocusOut);
			_captionInput.y = _contentText.y + _contentText.height;

			_defaultCaptionFormat = ApplicationFacade.getTextFormat('css', '.captionInputDefault');
			_userCaptionFormat = ApplicationFacade.getTextFormat('css', '.captionInput');
			
			_confirmButton.y = _captionInput.y + _captionInput.height + MARGIN * 2;
			_cancelButton.y =_confirmButton.y ;
			
			_fullScreenManager = FullScreenManager.getInstance();
		}

		public function showImage(image_ : BitmapData, postType:String) : void {
			_imageData = image_;
			addImage(new Bitmap(_imageData));
			setTitle(postType);
			resetCaption();
			show();
		}
		override public function show() : void {
			super.show();
			stage.addEventListener(Event.FULLSCREEN, onFullScreen);
		}

		private function onFullScreen(event : Event = null) : void {
				CallDelay.call(showMouse, 100);
		}

		private function showMouse() : void {
				Mouse.show();
		}

		private function setTitle(postType : String) : void {
			switch(postType){
				case FacebookConnector.PUBLIC_POST_TYPE:
					titleKey = 'uploadPicture.title.alt';
					break;
				case FacebookConnector.COMPETITION_POST_TYPE:
					titleKey = 'uploadPicture.competition.title';
					break;
				default:
					titleKey = 'uploadPicture.title';
			}
		}

		private function onFocusIn(event : FocusEvent) : void {
			if (_captionInputEmpty) {
				_captionInput.field.defaultTextFormat = _userCaptionFormat;
				_captionInput.field.text = '';
			}
			if (_fullScreenManager.isFullScreen){
				_loosingFocusFullScreen = true;
				_fullScreenManager.closeFullscreen();
			}
		}

		private function onFocusOut(event : FocusEvent) : void {
			if (!_loosingFocusFullScreen){
				trim(_captionInput.field);
				_captionInputEmpty = _captionInput.text.length == 0;
				if (_captionInputEmpty) {
					resetCaption();
				}
			} else {
				_loosingFocusFullScreen = false;
				stage.focus = _captionInput;
			}
		}

		protected function resetCaption() : void {
			_captionInputEmpty = true;
				_captionInput.field.defaultTextFormat = _defaultCaptionFormat;
				_captionInput.field.text = _defaultCaptionText;
		}

		private function trim(tf:TextField) : void {
			var trim:RegExp = /^\s+|\s+$/g;
			tf.text = tf.text.replace(trim,'');
		}

		protected function onPressKey(event : KeyboardEvent) : void {
			if (event.keyCode == Keyboard.ENTER) {
				confirm();
			}
		}

		override public function close() : void {
			super.close();
			if (_bitmap.parent) _bitmap.parent.removeChild(_bitmap);
			stage.removeEventListener(Event.FULLSCREEN, onFullScreen);
		}
		
		public function get caption() : String {
			return _captionInput.text;
		}

		public function get captionInputEmpty() : Boolean {
			return _captionInputEmpty;
		}
	}
}
