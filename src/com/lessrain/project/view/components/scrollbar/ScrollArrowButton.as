package com.lessrain.project.view.components.scrollbar {
	import com.greensock.TweenLite;
	import com.greensock.easing.Sine;
	import flash.display.Sprite;
	import flash.events.MouseEvent;

	/**
	 * @author lessintern
	 */
	public class ScrollArrowButton extends Sprite {
		
		private static const ARROW_COLOR : uint = 0x000000;
		private static const ICON_HEIGHT : int = 6;
		private static const ICON_WIDTH : int = 6;
		public static var WIDTH : int = 10;
		public static const LEFT : String = "LEFT";
		public static const RIGHT : String = "RIGHT";

		private var _arrowButtonOut : Sprite;
		private var _arrowButtonOver : Sprite;
		private var _icon : Sprite;

		public function ScrollArrowButton(outColor:uint, overColor:uint, direction:String = LEFT) {
			name = direction;
			_arrowButtonOut = addChild(new Sprite()) as Sprite;
			_arrowButtonOut.graphics.beginFill(outColor);
			_arrowButtonOut.graphics.drawRect(0, 0, WIDTH, WIDTH);
			_arrowButtonOut.graphics.endFill();
			
			_arrowButtonOver = addChild(new Sprite()) as Sprite;
			_arrowButtonOver.graphics.beginFill(overColor);
			_arrowButtonOver.graphics.drawRect(0, 0, WIDTH, WIDTH);
			_arrowButtonOver.graphics.endFill();
			_arrowButtonOver.alpha = 0;
			
			_icon = addChild(new Sprite()) as Sprite;
			_icon.graphics.beginFill(ARROW_COLOR);
			if (direction == LEFT){
			_icon.graphics.moveTo(ICON_WIDTH, 0);
			_icon.graphics.lineTo(ICON_WIDTH, ICON_HEIGHT);
			_icon.graphics.lineTo(0, ICON_HEIGHT / 2);
			_icon.graphics.lineTo(ICON_WIDTH, 0);
			} else {
			_icon.graphics.lineTo(ICON_WIDTH, ICON_HEIGHT / 2);
			_icon.graphics.lineTo(0, ICON_HEIGHT);
			_icon.graphics.lineTo(0, 0);
			}
			_icon.graphics.endFill();
			_icon.x = (WIDTH - ICON_WIDTH) / 2;
			_icon.y = (WIDTH - ICON_HEIGHT) / 2; 
			
			buttonMode = true;
			mouseChildren = false;
			addEventListener(MouseEvent.MOUSE_OVER, rollKnob);
			addEventListener(MouseEvent.MOUSE_OUT, rollKnob);
		}

		private function rollKnob(event : MouseEvent) : void {
			var b : Boolean = event.type == MouseEvent.MOUSE_OVER;
			doRoll(b);
		}

		private function doRoll(b : Boolean) : void {
			TweenLite.killTweensOf(_arrowButtonOver);
			TweenLite.to(_arrowButtonOver, .2, {alpha:b ? 1 : 0, ease:Sine.easeInOut});
		}

		public function finalize() : void {
			removeEventListener(MouseEvent.MOUSE_OVER, rollKnob);
			removeEventListener(MouseEvent.MOUSE_OUT, rollKnob);
			removeChild(_arrowButtonOut);
			_arrowButtonOut = null;
			removeChild(_arrowButtonOver);
			_arrowButtonOver = null;
			removeChild(_icon);
			_icon = null;
		}
	}
}
