package com.lessrain.project.view.utils {
	import flash.display.Sprite;

	/**
	 * @author lessintern
	 */
	public class PopupContainer extends Sprite {

		private static var instance : PopupContainer;
		private static var allowInstantiation : Boolean;

		public static function getInstance() : PopupContainer {
			if (instance == null) {
				allowInstantiation = true;
				instance = new PopupContainer();
				allowInstantiation = false;
			}
			return instance;
		}

		public function PopupContainer() : void {
			if (!allowInstantiation) {
				throw new Error("Error: Instantiation failed: Use PopupContainer.getInstance() instead of new.");
			}
		}
	}
}
