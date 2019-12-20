package com.lessrain.project.view.components.facebook {
	import com.lessrain.project.ApplicationFacade;
	import com.lessrain.project.view.utils.AssetButton;

	import flash.display.Bitmap;
	import flash.display.BitmapData;
	import flash.display.DisplayObject;
	import flash.display.Sprite;
	import flash.events.Event;
	import flash.events.KeyboardEvent;
	import flash.events.TimerEvent;
	import flash.text.TextFieldType;
	import flash.ui.Keyboard;
	import flash.utils.Timer;

	/**
	 * @author lessintern
	 */
	public class FacebookCollabDialog extends FacebookUploadPictureDialog {

		private var _friends : Vector.<FacebookFriend>;
		private var _friendsSelector : FriendsSelector;
		private var _whileTypingTimer : Timer;
		private var _friendsSelectorContainer : Sprite;
		private var _selectedFriend : FacebookFriend;
		private var _deselectBtn : ClearTextButton;
		private var _saveEnabled : Boolean;

		public function FacebookCollabDialog() {
			super('toolbar.save');
			_defaultCaptionText = ApplicationFacade.getCopy('sendCollab.captionInput');
			_captionInput.text = _defaultCaptionText;
			
			_friendsSelectorContainer = addChild(new Sprite()) as Sprite;
			_friendsSelector = _friendsSelectorContainer.addChild(new FriendsSelector(_captionInput)) as FriendsSelector;
			_friendsSelector.x = _dialogContent.x +_dialogLowerContent.x + _captionInput.x;
			_friendsSelector.y = _dialogContent.y + _dialogLowerContent.y + _captionInput.y + _captionInput.height;
			_friendsSelector.addEventListener(FriendEvent.CLICK, onFriendClick);
			
			_whileTypingTimer = new Timer(500,1);
			_whileTypingTimer.addEventListener(TimerEvent.TIMER, updateFriends);
			
			_deselectBtn = _dialogLowerContent.addChild(new ClearTextButton(_captionInput.field.height)) as ClearTextButton;
			_deselectBtn.x = _captionInput.x + _captionInput.field.width - _deselectBtn.width;
			_deselectBtn.y = _captionInput.y+ (_captionInput.field.height - _deselectBtn.height) / 2;
			_deselectBtn.visible = false;
			_deselectBtn.addEventListener(AssetButton.CLICK, deselectFriend);
			
			_confirmButton.enabled = false;
		}

		override public function showImage(image_ : BitmapData, postType :String) : void {
			
			super.showImage(image_, postType);
			titleKey = 'sendCollab.title';
			contentKey = 'sendCollab.captionTitle';
			show();
		}
		
		override protected function addImage(bitmap_:Bitmap, inLowerContent:Boolean = false, itemAbove : DisplayObject = null) : void {
			super.addImage(bitmap_, true, _captionInput);
		}
		
		private function repositionFriendSelector() : void {
			_friendsSelectorContainer.x = _dialogWindow.x;
			_friendsSelectorContainer.y = _dialogWindow.y;
			_friendsSelector.setMaxSize();
		}

		override protected function repositionDialog() : void {
			super.repositionDialog();
			repositionFriendSelector();
		}


		public function set friends(friends : Vector.<FacebookFriend>) : void {
			_friends = friends;
		}

		private function onFriendClick(event : FriendEvent) : void {
			_saveEnabled = true;
			_selectedFriend = event.friend;
			_friendsSelector.clearFriends();
			_captionInput.field.text = _selectedFriend.name;
			_captionInput.field.type = TextFieldType.DYNAMIC;
			_deselectBtn.visible = true;
			_confirmButton.enabled = true;
		}

		private function deselectFriend(event : Event = null) : void {
			resetCaption();
			_saveEnabled = false;
			_captionInput.field.type = TextFieldType.INPUT;
			_deselectBtn.visible = false;
			_confirmButton.enabled = false;
		}
		
		override protected function onPressKey(event : KeyboardEvent) : void {
			if (_saveEnabled){
				super.onPressKey(event);
			} else if (!_friendsSelector.isEmpty){
				switch(event.keyCode){
					case Keyboard.DOWN:
						_friendsSelector.highlightItem(true);
						break;
					case Keyboard.UP:
						_friendsSelector.highlightItem(false);
						break;
					case Keyboard.ENTER:
						_friendsSelector.onPickItem();
						break;
				}
			}
			if (!_whileTypingTimer.running){
				_whileTypingTimer.start();
			}
		}

		private function updateFriends(event : TimerEvent) : void {
			var matchingFriends:Vector.<FacebookFriend> = new Vector.<FacebookFriend>();
			if (_captionInput.text != ""){
				for each (var friend : FacebookFriend in _friends) {
					if (friend.startsWith(_captionInput.text)){
						matchingFriends.push(friend);
					}
				}
			}
			if (!_friendsSelector.friends || matchingFriends.toString() != _friendsSelector.friends.toString()){
				_friendsSelector.addFriends(matchingFriends);
			}
		}

		override public function close() : void {
			super.close();
			deselectFriend();
			_friendsSelector.clearFriends();
		}

		public function get selectedFriend() : FacebookFriend {
			return _selectedFriend;
		}
	}
}
