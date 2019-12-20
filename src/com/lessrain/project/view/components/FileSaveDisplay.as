package com.lessrain.project.view.components {
	import com.lessrain.project.view.utils.FullScreenManager;

	import flash.display.Sprite;
	import flash.display.StageDisplayState;

	/**
	 * @author lessintern
	 */
	public class FileSaveDisplay extends Sprite {

		private var _blocker : Blocker;

		public function FileSaveDisplay() {
			_blocker = addChild(new Blocker()) as Blocker;
		}

		public function block() : void {
			_blocker.showMsgByKey('dudes.saving');
		}

		public function hide(success:Boolean) : void {
			_blocker.showMsgByKey('dudes.saving'+(success?'.success':'.failed'));
			if (success) {
				FullScreenManager.getInstance().closeFullscreen();
			}
		}
		
		public function get active() : Boolean {
			return _blocker.visible;
		}
	}
}
