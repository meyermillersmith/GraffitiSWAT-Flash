package com.lessrain.project.view.components.facebook {
	import com.lessrain.debug.Debug;
	import com.lessrain.project.view.utils.AssetButton;
	import com.lessrain.project.view.utils.SimpleTextfield;

	import flash.display.Sprite;
	import flash.events.Event;
	import flash.geom.Point;

	/**
	 * @author lessintern
	 */
	public class FriendsSelector extends Sprite {

		private var _container : Sprite;
		private var _inputField : SimpleTextfield;
		private var _friendItems : Vector.<FriendsSelectorItem>;
		private var _highlightedItem : FriendsSelectorItem;
		private var _friends : Vector.<FacebookFriend>;
		private var _maxItems:int;

		public function FriendsSelector(inputField_ : SimpleTextfield) {
			_inputField = inputField_;
			_container = addChild(new Sprite()) as Sprite;
			_friendItems = new Vector.<FriendsSelectorItem>();
		}

		public function setMaxSize() : void {
			var maxHeight:Number = stage.stageHeight - localToGlobal(new Point()).y;
			var oldMaxItems:int = _maxItems;
			_maxItems = Math.floor(maxHeight/FriendsSelectorItem.HEIGHT);
			if (oldMaxItems != _maxItems){
				if (_friendItems.length > 0 && ( _maxItems < _friends.length || oldMaxItems < _friends.length)){
					refreshFriends();
				}
			}
		}

		public function addFriends(friends : Vector.<FacebookFriend>) : void {
			_friends = friends;
			refreshFriends();
		}

		private function refreshFriends() : void {
			clearFriends();
			var i:int = 0;
			for each (var friend : FacebookFriend in _friends) {
				var friendSelectorItem:FriendsSelectorItem = _container.addChild(new FriendsSelectorItem(friend,_inputField.width)) as FriendsSelectorItem;
				friendSelectorItem.y = FriendsSelectorItem.HEIGHT * i;
				friendSelectorItem.addEventListener(AssetButton.CLICK, onFriendClick);
				friendSelectorItem.addEventListener(AssetButton.ROLL_OVER, onFriendRollOver);
				friendSelectorItem.addEventListener(AssetButton.ROLL_OUT, onFriendRollOut);
				friendSelectorItem.index = _friendItems.length;
				_friendItems.push(friendSelectorItem);
				i++;
				if (i == _maxItems){
					break;
				}
			}
		}


		private function onFriendClick(event : Event) : void {
			dispatchEvent(new FriendEvent(FriendEvent.CLICK, FriendsSelectorItem(event.target).friend));
		}

		public function clearFriends() : void {
			while(_container.numChildren > 0){
				_container.removeChildAt(0);
			}
			_friendItems = new Vector.<FriendsSelectorItem>();
			_highlightedItem = null;
			Debug.trace('FriendsSelector::clearFriends:_highlightedItem = null');
		}

		private function onFriendRollOver(event : Event) : void {
			if(_highlightedItem) _highlightedItem.deactivate();
			_highlightedItem = event.target as FriendsSelectorItem;
		}

		private function onFriendRollOut(event : Event) : void {
			if (_highlightedItem == event.target as FriendsSelectorItem){
				_highlightedItem = null;
				Debug.trace('FriendsSelector::onFriendRollOut:_highlightedItem = null');
			}
		}

		public function highlightItem(downKey : Boolean) : void {
			var foundItem:FriendsSelectorItem = getNextItem(downKey?1:-1);
			if (foundItem){
				foundItem.activate();
			}
		}

		private function getNextItem(direction : int) : FriendsSelectorItem {
			Debug.trace('FriendsSelector::getNextItem:direction '+direction+' _friends.length '+_friendItems.length+' highghted '+(_highlightedItem?_highlightedItem.index:'NULL'));
			if (_friendItems.length > 0){
				var currentIndex:int = _highlightedItem?_highlightedItem.index : direction > 0? -1 : 0;
				Debug.trace('FriendsSelector::getNextItem:currentIndex '+currentIndex);
				currentIndex+=direction;
				if (currentIndex < 0){
					currentIndex = currentIndex + _friendItems.length;
				} else if (currentIndex >= _friendItems.length){
					currentIndex = currentIndex - _friendItems.length;
				}
				Debug.trace('FriendsSelector::getNextItem: currentIndex '+currentIndex);
				return currentIndex > -1 && currentIndex <  _friendItems.length? _friendItems[currentIndex] : null;
			} else return null;
		}

		public function onPickItem() : void {
			if(_highlightedItem) _highlightedItem.select();
		}

		public function get friends() : Vector.<FacebookFriend> {
			return _friends;
		}

		public function get isEmpty() : Boolean {
			return _friendItems.length == 0;
		}
	}
}
