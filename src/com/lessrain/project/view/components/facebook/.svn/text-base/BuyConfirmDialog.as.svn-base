package com.lessrain.project.view.components.facebook {
	import com.lessrain.project.ApplicationFacade;
	import com.lessrain.project.model.vo.BuyableData;
	import com.lessrain.project.view.components.ConfirmationPopup;
	import com.lessrain.project.view.utils.RoundAssetButton;
	import com.lessrain.project.view.utils.SimpleTextButton;
	import com.lessrain.project.view.utils.SimpleTextfield;

	import flash.display.Bitmap;
	import flash.events.Event;
	import flash.net.URLRequest;
	import flash.net.navigateToURL;

	/**
	 * @author lessintern
	 */
	public class BuyConfirmDialog extends ConfirmationPopup {
		public static const TRY_OUT : String = "TRY_OUT";
		private var _price : SimpleTextfield;
		private var _tryButton : SimpleTextButton;
		private var _confirmTryDialog : ConfirmationPopup;

		public function BuyConfirmDialog(item:BuyableData) {
			var contentKey:String = item.isTool? 'tool.'+item.key+'.description': '';
			super('',contentKey,'buyItem.buy', '', '.popupTitle');
			
			_title = _dialogContent.addChild(new SimpleTextfield(item.title, '.buyPopupTitle')) as SimpleTextfield;
			_price = _dialogContent.addChild(new SimpleTextfield(ApplicationFacade.getCopy('surface.currency')+item.price, '.buyPopupPrice')) as SimpleTextfield;
			_price.x = _title.width - MARGIN;
			_price.y = _title.y + 5;
			
			var keyUpperCase:String = makeFirstLetterUpperCase(item.key);
			
			try{
				var image:Bitmap = ApplicationFacade.getSWFAssetInstance('BuyImage'+keyUpperCase) as Bitmap;
				if (image) addImage(image);
			}catch(e:Error){
				
			}
			
			if (_contentText) _confirmButton.y = _contentText.y + _contentText.height + MARGIN * 2;
			
			_confirmButton.y -= MARGIN;
			
			_tryButton = _dialogLowerContent.addChild(new SimpleTextButton(ApplicationFacade.getCopy('buyItem.try'), '.popupButton', 1, -1, 21, -1, true, 0xEF8F00, 0xFF7700)) as SimpleTextButton;
			_tryButton.addEventListener(SimpleTextButton.CLICK, confirmTryItem);
			_tryButton.x = _confirmButton.x + _confirmButton.width + MARGIN;
			_tryButton.y = _confirmButton.y ;
			_tryButton.enabled = !item.tested;
		}

		private function confirmTryItem(event : Event) : void {
			if (!_confirmTryDialog) {
				_confirmTryDialog = new ConfirmationPopup('tryItem.title','tryItem.content');
				_confirmTryDialog.addBlocker();
				_confirmTryDialog.addEventListener(ConfirmationPopup.CONFIRM, tryItem);
			}
			_confirmTryDialog.show();
		}

		private function tryItem(event : Event) : void {
			close();
			dispatchEvent(new Event(TRY_OUT));
		}
		
		private function makeFirstLetterUpperCase(string: String) : String {
			if(string && string.length > 0){
				string = string.substr(0,1).toUpperCase()+string.substring(1);
			}
			return string;
		}
	}
}
