package com.lessrain.project.view.components.canvas {
	import com.greensock.TweenLite;
	import com.greensock.easing.Sine;

	import flash.display.Sprite;
	import flash.events.Event;

	/**
	 * @author lessintern
	 */
	public class AnimatedDrop extends Sprite {

		public static const ANIM_COMPLETE : String = "dropAnimComplete";
		private var _dropBottom : Number = 0;
		private var _dropLine : Sprite;
		private var _dropCircle : Sprite;
		private var _dropBottomTarget : Number;
		private var _stopped : Boolean;
		private var _maxHeight : Number;

		public function AnimatedDrop(dotColor : uint, nuclearSize : Number, width_ : Number, maxHeight_ : Number) {
			_dropLine = addChild(new Sprite()) as Sprite;
			_dropLine.graphics.beginFill(dotColor, 1);
			_dropLine.graphics.drawRect(0, 0, width_, width_ / 2);
			_dropLine.graphics.endFill();

			_dropCircle = addChild(new Sprite()) as Sprite;
			_dropCircle.graphics.beginFill(dotColor, 1);
			_dropCircle.graphics.drawCircle(0, 0, width_ / 2);
			_dropCircle.graphics.endFill();
			_dropCircle.x = _dropLine.height;
			_dropCircle.y = _dropLine.height;
			
			_dropBottom = _dropLine.height;
			_dropBottomTarget = nuclearSize / 2 + nuclearSize / 2  * Math.random();
			
			_maxHeight=maxHeight_;
		}

		public function startAnim() : void {
			if (!_stopped){
				addEventListener(Event.ENTER_FRAME, run);
			}
		}

		private function run(event : Event) : void {
			dropBottom+= 3; 
			if (dropBottom > _maxHeight){
				stop(true);
			}
		}
		
		public function stop(hardStop:Boolean):void{
			if (!_stopped){
				_stopped = true;
				removeEventListener(Event.ENTER_FRAME, run);
				if (!hardStop){
					if (_dropBottomTarget < dropBottom + 15){
						_dropBottomTarget = dropBottom + 15;
					}
					TweenLite.to(this, 1, {dropBottom : _dropBottomTarget, onComplete : dispatchComplete, ease : Sine.easeOut});
				} else {
					dispatchComplete();
				}
			}
		}


		public function get dropBottom() : Number {
			return _dropBottom;
		}

		public function set dropBottom(dropBottom : Number) : void {
			_dropBottom = dropBottom;
			_dropLine.height = _dropBottom;
			_dropCircle.y = _dropLine.height;
		}

		private function dispatchComplete() : void {
			dispatchEvent(new Event(ANIM_COMPLETE));
		}
	}
}
