package com.lessrain.project.view.components {
	import com.lessrain.project.model.ApplicationParamsProxy;
	import com.lessrain.project.view.utils.FullScreenManager;
	import com.lessrain.project.ApplicationFacade;
	import com.lessrain.project.model.vo.PaletteData;
	import com.lessrain.project.view.components.canvas.Canvas;
	import com.lessrain.project.view.components.palette.ColorEvent;
	import com.lessrain.project.view.components.palette.PaletteView;
	import com.lessrain.project.view.utils.AssetButton;
	import com.lessrain.project.view.utils.SimpleTextButton;

	import flash.display.Sprite;
	import flash.events.Event;
	import flash.events.MouseEvent;
	import flash.filters.DropShadowFilter;

	/**
	 * @author lessintern
	 */
	public class MenuBar extends Sprite {
		
		public static var fbID:String;

		public static const POST_TO_ALBUM : String = "post_to_album";
		public static const POST_TO_BEST_OF : String = "post_to_bestof";
		public static const POST_TO_FRIEND_WALL : String = "post_to_friend_wall";
		public static const SEND_COLLAB : String = "send_collab";
		public static const SAVE_FOR_LATER : String = "SAVE_FOR_LATER";
		public static const DOWNLOAD : String = "dowload";
		public static const POST_TO_COMPETITION : String = "post_to_competition";
		public static const BACK_TO_CHOOSE : String = "back_to_choose_surface";
		public static const MARGIN_TOP : int = 60;
		public static const MARGIN : int = 10;
		private var _palette : PaletteView;
		private var _clearBtn : SimpleTextButton;
		private var _canvas : Canvas;
		private var _saveBtn : SimpleTextButton;
		// private var _postPublicBtn : SimpleTextButton;
		private var _backBtn : SimpleTextButton;
		private var _undoBtn : SimpleTextButton;
		private var _clearConfirmationPopup : ConfirmationPopup;
		private var _backConfirmationPopup : ConfirmationPopup;
		private var _confirmFunction : Function;
		private var _buttonBar : Sprite;
		private var _paletteBG : Sprite;
		private var _buttonBarBG : Sprite;
		private var _paletteChooserContainer : Sprite;
		private var _postButtonContainer : Sprite;
		private var _saveOptionScreen : Sprite;
		private var _enabled : Boolean = true;
		private var _saveToAlBum : FacebookPostButton;
		private var _saveToGallery : FacebookPostButton;
		private var _postToFriend : FacebookPostButton;
		private var _sendCollab : FacebookPostButton;
		private var _saveToComp : FacebookPostButton;
		private var _isTShirt : Boolean;
		private var _tShirtDialog : TShirtSaveDialog;
		private var _saveforLater : FacebookPostButton;
		private var _unknownUser : Boolean;
		
		private function block():void
		{
			//if(fbID=='100003971116234')_saveToGallery.enabled = false;
			if(fbID=='100006532718341')_saveToGallery.enabled = false;
			if(fbID=='100004308514523')_saveToGallery.enabled = false;
			if(fbID=='100006337728885')_saveToGallery.enabled = false;
			if(fbID=='100002641444189')_saveToGallery.enabled = false;
			
		}

		public function MenuBar(paletteBG_ : Sprite, canvas_ : Canvas, isTShirt_ : Boolean, unknownUser_ : Boolean) {
			_canvas = canvas_;
			_isTShirt = isTShirt_;
			_unknownUser = unknownUser_;

			_paletteChooserContainer = addChild(new Sprite()) as Sprite;

			_paletteBG = paletteBG_;
			_paletteBG.y = y;

			_buttonBarBG = addChild(ApplicationFacade.getSWFAssetInstance('ButtonBarBG')) as Sprite;

			_palette = addChild(new PaletteView()) as PaletteView;
			_palette.y = _paletteBG.height - _buttonBarBG.height - _palette.height - MARGIN;
			_palette.x = MARGIN;
			// _bInput.x + _bInput.width + 50;
			_palette.addEventListener(ColorEvent.CLICK, onColorClicked);

			_palette.w = canvas_.stage.stageWidth - MARGIN;

			_buttonBar = addChild(new Sprite()) as Sprite;

			_backBtn = _buttonBar.addChild(new SimpleTextButton(ApplicationFacade.getCopy('toolbar.back'), '.button', 1, -1, 25)) as SimpleTextButton;
			_backBtn.addEventListener(SimpleTextButton.CLICK, backToChooseSurface);
			_backBtn.x = MARGIN;
			
			if (_unknownUser) _backBtn.enabled = false;

			_clearBtn = _buttonBar.addChild(new SimpleTextButton(ApplicationFacade.getCopy('toolbar.clear'), '.button', 1, -1, 25)) as SimpleTextButton;
			_clearBtn.addEventListener(SimpleTextButton.CLICK, confirmClear);
			_clearBtn.x = _backBtn.x + _backBtn.width + MARGIN;

			_undoBtn = _buttonBar.addChild(new SimpleTextButton(ApplicationFacade.getCopy('toolbar.undo'), '.button', 1, -1, 25)) as SimpleTextButton;
			_undoBtn.addEventListener(SimpleTextButton.CLICK, _canvas.undo);
			_undoBtn.x = _clearBtn.x + _clearBtn.width + MARGIN;

			// _paletteBG.height = _palette.height + _palette.x + MARGIN;
			_buttonBarBG.y = _paletteBG.height - _buttonBarBG.height;
			_buttonBar.y = _buttonBarBG.y + MARGIN;

			_postButtonContainer = _buttonBar.addChild(new Sprite()) as Sprite;

			
			
			_saveBtn = _postButtonContainer.addChild(new SimpleTextButton(ApplicationFacade.getCopy('toolbar.save'), '.saveButton', 1, -1, 25, -1, true,0xFFFFFF,0xFFC020)) as SimpleTextButton;
			saveEnabled = false;

			drawSaveOptions();

			displayCurrentColor();
		}

		private function toggleOptionsVisible(event : Event) : void {
			_saveOptionScreen.visible = event.type == AssetButton.ROLL_OVER || event.type == MouseEvent.MOUSE_OVER;
			_saveBtn.doRoll(_saveOptionScreen.visible);
		}

		private function drawSaveOptions() : void {
			_saveOptionScreen = _postButtonContainer.addChild(new Sprite()) as Sprite;
			var buttonHolder : Sprite = _saveOptionScreen.addChild(new Sprite()) as Sprite;
			buttonHolder.x = buttonHolder.y = 5;
			
			if(!_isTShirt){
				_sendCollab = buttonHolder.addChild(new FacebookPostButton(ApplicationFacade.getCopy('toolbar.save.collab'), ApplicationFacade.getCopy('toolbar.save.collab.text'))) as FacebookPostButton;
				_sendCollab.addEventListener(SimpleTextButton.CLICK, sendCollaboration);
				_saveToAlBum = buttonHolder.addChild(new FacebookPostButton(ApplicationFacade.getCopy('toolbar.save.album'), ApplicationFacade.getCopy('toolbar.save.album.text'))) as FacebookPostButton;
				_saveToAlBum.addEventListener(SimpleTextButton.CLICK, postToAlbum);
				_saveToAlBum.y = _sendCollab.height + 5;
				_saveToGallery = buttonHolder.addChild(new FacebookPostButton(ApplicationFacade.getCopy('toolbar.save.public'), ApplicationFacade.getCopy('toolbar.save.public.text'))) as FacebookPostButton;
				_saveToGallery.addEventListener(SimpleTextButton.CLICK, postToGallery);
				_saveToGallery.y = _saveToAlBum.y + _saveToAlBum.height + 5;
			} else {
				_saveToGallery = buttonHolder.addChild(new FacebookPostButton(ApplicationFacade.getCopy('toolbar.save.competition'), ApplicationFacade.getCopy('toolbar.save.competition.text'))) as FacebookPostButton;
				_saveToGallery.addEventListener(SimpleTextButton.CLICK, uploadShirtForCompetition);
			}
			
			/*_postToFriend = buttonHolder.addChild(new FacebookPostButton(ApplicationFacade.getCopy('toolbar.share.wall'), ApplicationFacade.getCopy('toolbar.save.public.text'))) as FacebookPostButton;
			_postToFriend.addEventListener(SimpleTextButton.CLICK, postToFriendWall);
			_postToFriend.y = _saveToGallery.y+_saveToGallery.height + 5;*/
			_saveToComp = buttonHolder.addChild(new FacebookPostButton(ApplicationFacade.getCopy('toolbar.save.download'), ApplicationFacade.getCopy('toolbar.save.download.text'))) as FacebookPostButton;
			_saveToComp.addEventListener(SimpleTextButton.CLICK, download);
			_saveToComp.y = _saveToGallery.y+_saveToGallery.height + 5;
			_saveforLater = buttonHolder.addChild(new FacebookPostButton(ApplicationFacade.getCopy('toolbar.save.later'), ApplicationFacade.getCopy('toolbar.save.later.text'))) as FacebookPostButton;
			_saveforLater.addEventListener(SimpleTextButton.CLICK, saveForLater);
			_saveforLater.y = _saveToComp.y+_saveToComp.height + 5;

			var triangleX : Number = (_saveOptionScreen.width - 30) / 2;
			_saveOptionScreen.graphics.beginFill(0x000000, 1);
			_saveOptionScreen.graphics.drawRoundRect(0, 0, _saveOptionScreen.width + 5, _saveOptionScreen.height + 10, 20);
			_saveOptionScreen.graphics.moveTo(triangleX, _saveOptionScreen.height);
			_saveOptionScreen.graphics.lineTo(triangleX + 30, _saveOptionScreen.height);
			_saveOptionScreen.graphics.lineTo(triangleX + 15, _saveOptionScreen.height + 15);
			_saveOptionScreen.graphics.moveTo(triangleX, _saveOptionScreen.height - 15);
			_saveOptionScreen.graphics.endFill();

			_saveOptionScreen.filters = [new DropShadowFilter(6, 45, 0, 1, 21, 21, .62)];

			_saveOptionScreen.y = - _saveOptionScreen.height;
			_saveBtn.x = triangleX + 15 - _saveBtn.width / 2;

			_saveOptionScreen.graphics.beginFill(0xFF0000, 0);
			_saveOptionScreen.graphics.drawRect(0, 0, _postButtonContainer.width, _postButtonContainer.height);
			_saveOptionScreen.graphics.endFill();

			_saveOptionScreen.visible = false;
			
			
			
			block();
			
			if (_unknownUser){
				_saveToGallery.enabled = false;
				_saveforLater.enabled = false;
				_sendCollab.enabled = false;
				_saveToAlBum.enabled = false;
			}
		}
		

		private function confirmClear(event : Event) : void {
			if (!_clearConfirmationPopup) {
				_clearConfirmationPopup = makeConfirmationPopup(_canvas.clear);
			}
			_clearConfirmationPopup.show();
		}

		private function confirmBack(event : Event) : void {
			if (!_backConfirmationPopup) {
				_backConfirmationPopup = makeConfirmationPopup(backToChooseSurface);
			}
			_backConfirmationPopup.show();
		}

		private function makeConfirmationPopup(callback : Function) : ConfirmationPopup {
			var confirmationPopup : ConfirmationPopup = new ConfirmationPopup('confirm.clear.title', 'confirm.clear.content');
			if (callback == _canvas.clear) confirmationPopup.addCheckbox();
			confirmationPopup.addBlocker();
			confirmationPopup.addEventListener(ConfirmationPopup.CONFIRM, callback);
			confirmationPopup.addEventListener(ConfirmationPopup.CHECKED, onShowNoMore);
			return confirmationPopup;
		}

		private function onShowNoMore(event : Event) : void {
			if (event.target == _clearConfirmationPopup) {
				_clearBtn.removeEventListener(SimpleTextButton.CLICK, confirmClear);
				_clearBtn.addEventListener(SimpleTextButton.CLICK, _canvas.clear);
			} /*else {
				_backBtn.removeEventListener(SimpleTextButton.CLICK, confirmBack);
				_backBtn.addEventListener(SimpleTextButton.CLICK, backToChooseSurface);
			} */
		}

		private function postToGallery(event : Event) : void {
			dispatchEvent(new Event(POST_TO_BEST_OF));
		}

		private function postToFriendWall(event : Event) : void {
			dispatchEvent(new Event(POST_TO_FRIEND_WALL));
		}

		private function postToAlbum(event : Event) : void {
			dispatchEvent(new Event(POST_TO_ALBUM));
		}

		private function download(event : Event) : void {
			dispatchEvent(new Event(DOWNLOAD));
		}

		private function sendCollaboration(event : Event) : void {
			dispatchEvent(new Event(SEND_COLLAB));
		}

		private function saveForLater(event : Event) : void {
			dispatchEvent(new Event(SAVE_FOR_LATER));
		}

		private function backToChooseSurface(event : Event = null) : void {
			FullScreenManager.getInstance().closeFullscreen();
			dispatchEvent(new Event(BACK_TO_CHOOSE));
		}

		public function setColors(data : Vector.<PaletteData>) : void {
			_palette.init(data);
			if (_palette.activeColor) {
				_canvas.dotColor = _palette.activeColor;
				displayCurrentColor();
			}
		}

		private function onColorClicked(event : ColorEvent) : void {
			_canvas.dotColor = event.color;
			displayCurrentColor();
		}

		private function displayCurrentColor() : void {
			dispatchEvent(new ColorEvent(ColorEvent.CLICK, _canvas.dotColor));
			_canvas.addEventListener(Canvas.SPRAYED, onColorSprayed);
		}

		private function onColorSprayed(event : Event) : void {
			_canvas.removeEventListener(Canvas.SPRAYED, onColorSprayed);
			palette.markCurrentColorUsed();
		}

		public function update() : void {
			// var toolbarwidth : Number = Math.min(Math.max(Application.MIN_WIDTH, stage.stageWidth), mainContentWidth);
			var toolbarwidth : Number = stage.stageWidth;
			if (width != toolbarwidth) {
				_paletteBG.width = _buttonBarBG.width = toolbarwidth;

				_palette.w = toolbarwidth - MARGIN;

				_postButtonContainer.x = (toolbarwidth - _postButtonContainer.width ) / 2;
			}
		}

		public function get palette() : PaletteView {
			return _palette;
		}

		override public function get height() : Number {
			return _paletteBG.height;
		}

		override public function set y(y_ : Number) : void {
			super.y = y_;
			_paletteBG.y = y_;
		}

		public function set saveEnabled(enabled_ : Boolean) : void {
			if (_enabled != enabled_) {
				_enabled = enabled_;
				if (enabled_) {
					_saveBtn.enabled = true;
					if (!_isTShirt && !_unknownUser){
						_saveToAlBum.enabled = true;
						_saveToGallery.enabled = true;
						block();
						_sendCollab.enabled = true;
					}
					_postButtonContainer.addEventListener(MouseEvent.MOUSE_OVER, toggleOptionsVisible);
					_postButtonContainer.addEventListener(MouseEvent.MOUSE_OUT, toggleOptionsVisible);
				} else {
					_saveBtn.enabled = false;
					_postButtonContainer.removeEventListener(MouseEvent.MOUSE_OVER, toggleOptionsVisible);
					_postButtonContainer.removeEventListener(MouseEvent.MOUSE_OUT, toggleOptionsVisible);
				}
			}
		}

		public function disabledSaveAlbum() : void {
			if (!_isTShirt) _saveToAlBum.enabled = false;
		}

		public function disabledSavePublic() : void {
			if (!_isTShirt) _saveToGallery.enabled = false;
			disabledSaveAlbum();
		}

		public function disabledSaveCollab() : void {
			if (!_isTShirt) _sendCollab.enabled = false;
			disabledSaveAlbum();
		}
		
		
		private function uploadShirtForCompetition(event:Event) : void {
			dispatchEvent(new Event(POST_TO_COMPETITION));
		}

//		private function openTShirtDialog(event:Event) : void {
//			if (!_tShirtDialog){
//				_tShirtDialog = new TShirtSaveDialog();
//				_tShirtDialog.addEventListener(TShirtSaveDialog.DOWNLOAD_SHIRT, download);
//				_tShirtDialog.addEventListener(TShirtSaveDialog.POST_TO_DUDES, postToAlbum);
//			}
//			_tShirtDialog.show();
//		}
	}
}
