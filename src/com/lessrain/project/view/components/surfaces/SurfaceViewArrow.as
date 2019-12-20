package com.lessrain.project.view.components.surfaces {
	import com.lessrain.project.view.utils.AssetButton;

	import flash.display.Sprite;

	/**
	 * @author lessintern
	 */
	public class SurfaceViewArrow extends AssetButton {

		public static const LEFT:String = 'left';
		public static const RIGHT:String = 'right';
		public static const LINE_THINCKNESS:int = 12;
		
		private var _direction : String;
		private var _disabledSprite : Sprite;
		private var _hitarea : Sprite;

		public function SurfaceViewArrow(direction : String) {
			_hitarea = addChild(new Sprite()) as Sprite;
			_direction = direction;
			_disabledSprite = makeArrow(0x444444);
			_disabledSprite.visible = false;
			super(makeArrow(0xFFFFFF), makeArrow(0xFD0035));
			addChild(_disabledSprite);
			
			_hitarea.graphics.beginFill(0xFF0000,0);
			_hitarea.graphics.drawCircle( SurfaceButton.SIZE / 2,  SurfaceButton.SIZE / 2,  SurfaceButton.SIZE / 2);
			_hitarea.graphics.endFill();
		}
		
		override public function set enabled(enabled_ : Boolean) : void {
			super.enabled = enabled_;
			_disabledSprite.visible = !enabled_;
		}

		private function makeArrow(color : uint) : Sprite {
			var arrow : Sprite = new Sprite();
			arrow.graphics.lineStyle(LINE_THINCKNESS, color, 1, false, 'normal', 'round');
			if (_direction == LEFT) {
				drawLeftArrow(arrow);
			} else {
				drawRightArrow(arrow);
			}
			arrow.x = LINE_THINCKNESS * 2/3 +(SurfaceButton.SIZE - arrow.width) / 2;
			arrow.y = LINE_THINCKNESS* 2/3  + (SurfaceButton.SIZE - arrow.height) / 2;
			return arrow;
		}

		private function drawLeftArrow(arrow : Sprite) : void {
			arrow.graphics.moveTo(20, 0);
			arrow.graphics.lineTo(0, 20);
			arrow.graphics.lineTo(20, 40);
		}

		private function drawRightArrow(arrow : Sprite) : void {
			arrow.graphics.lineTo(20, 20);
			arrow.graphics.lineTo(0, 40);
		}
	}
}
