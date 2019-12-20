package com.lessrain.project.view.components.facebook {
	import flash.events.Event;

	/**
	 * @author lessintern
	 */
	public class FriendEvent extends Event {

		public static const CLICK : String = "clickFriend";
		private var _friend : FacebookFriend;

		public function FriendEvent(type : String, friend_ : FacebookFriend) {
			_friend = friend_;
			super(type);
		}

		public function get friend() : FacebookFriend {
			return _friend;
		}
	}
}
