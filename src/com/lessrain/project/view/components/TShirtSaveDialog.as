package com.lessrain.project.view.components {
	import flash.text.TextFormat;
	import flash.text.TextFormatAlign;
	import com.lessrain.project.ApplicationFacade;
	import com.lessrain.project.view.utils.AssetButton;
	import com.lessrain.project.view.utils.RoundAssetButton;
	import com.lessrain.project.view.utils.SimpleTextButton;

	import flash.events.Event;

	/**
	 * @author lessintern
	 */
	public class TShirtSaveDialog extends ConfirmationPopup {

		public static const DOWNLOAD_SHIRT : String = "downloadShirt";
		public static const POST_TO_DUDES : String = "postToDudes";

		private var _saveToAlBum : FacebookPostButton;
		private var _saveToComp : FacebookPostButton;
		private var _closeBtn : RoundAssetButton;

		public function TShirtSaveDialog() {
			super("tshirt.save.title", "tshirt.save.content");
			
			_saveToAlBum = _dialogLowerContent.addChild(new FacebookPostButton(ApplicationFacade.getCopy('toolbar.save.album.dudes'), ApplicationFacade.getCopy('toolbar.save.album.text.dudes'))) as FacebookPostButton;
			_saveToAlBum.addEventListener(SimpleTextButton.CLICK, postToAlbum);
			_saveToAlBum.x = (DIALOG_CONTENT_WIDTH - _saveToAlBum.width)/2;
			
			_saveToComp = _dialogLowerContent.addChild(new FacebookPostButton(ApplicationFacade.getCopy('toolbar.save.download.dudes'), ApplicationFacade.getCopy('toolbar.save.download.text.dudes'))) as FacebookPostButton;
			_saveToComp.addEventListener(SimpleTextButton.CLICK, download);
			_saveToComp.y = _saveToAlBum.y + _saveToAlBum.height + MARGIN;
			_saveToComp.x = (DIALOG_CONTENT_WIDTH - _saveToComp.width)/2;
			
			_contentText.y = _saveToComp.y + _saveToComp.height + MARGIN;
			_contentText.field.textColor = 0x888888;
			var alignFormat:TextFormat = _contentText.field.defaultTextFormat;
			alignFormat.align = TextFormatAlign.CENTER;
			_contentText.field.setTextFormat(alignFormat);
//			_contentText.field.appendText(' anyong??');
			
			_closeBtn = _dialogContent.addChild(new RoundAssetButton('PaletteClose')) as RoundAssetButton;
			_closeBtn.addEventListener(AssetButton.CLICK, onClose);
			_closeBtn.x = DIALOG_CONTENT_WIDTH - _closeBtn.width;

			_dialogLowerContent.removeChild(_confirmButton);
			_dialogLowerContent.removeChild(_cancelButton);
			
			addBlocker();
			
		}

		private function onClose(event : Event) : void {
			close();
		}

		private function download(event : Event) : void {
			dispatchEvent(new Event(DOWNLOAD_SHIRT));
			close();
		}

		private function postToAlbum(event : Event) : void {
			dispatchEvent(new Event(POST_TO_DUDES));
			close();
		}
	}
}
