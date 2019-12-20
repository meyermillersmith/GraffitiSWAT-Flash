package com.lessrain.project.view.utils {
	import com.lessrain.project.ApplicationFacade;
	import flash.events.MouseEvent;
	import flash.display.Sprite;

	/**
	 * @author lessintern
	 */
	public class LessCheckBox extends Sprite {
		
		private static const BOX_SIZE:int = 10;
		private static const BOX_LINE:int = 2;
		private static const CHECK_SIZE:int = BOX_SIZE - BOX_LINE;

		private var _box : Sprite;
		private var _check : Sprite;
		private var _label : SimpleTextfield;

		public function LessCheckBox(label_:String, style:String = '.sample') {
			_box = addChild(new Sprite()) as Sprite;
			_box.graphics.lineStyle(BOX_LINE,0x8888FF);
			_box.graphics.beginFill(0xFFFFFF,1);
			_box.graphics.drawRect(0, 0, BOX_SIZE, BOX_SIZE);
			_box.graphics.endFill();
			
			_check = addChild(new Sprite()) as Sprite;
			_check.graphics.lineStyle(2,0x000000);
			_check.graphics.moveTo(BOX_LINE, BOX_LINE);
			_check.graphics.lineTo(CHECK_SIZE, CHECK_SIZE);
			_check.graphics.moveTo(CHECK_SIZE, BOX_LINE);
			_check.graphics.lineTo(BOX_LINE, CHECK_SIZE);
			_check.visible = false;
			_check.mouseEnabled = false;
			
			_label = addChild(new SimpleTextfield(ApplicationFacade.getCopy(label_),style)) as SimpleTextfield;
			_label.x = _box.width + 10;
			_check.y = _box.y = _label.field.textHeight - 2 - _box.height;
			
			buttonMode = true;
			addEventListener(MouseEvent.CLICK, toggleCheck);
		}

		private function toggleCheck(event : MouseEvent) : void {
			_check.visible = !_check.visible;
		}
		
		public function get checked() : Boolean {
			return _check.visible;
		}
		public function set checked(isChecked : Boolean) : void {
			_check.visible = isChecked;
		}

		public function finalize() : void {
			if (parent){
				parent.removeChild(this);
				buttonMode = false;
				removeEventListener(MouseEvent.CLICK, toggleCheck);
			}
		}
	}
}
