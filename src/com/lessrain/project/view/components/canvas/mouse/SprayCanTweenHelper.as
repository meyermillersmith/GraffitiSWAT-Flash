package com.lessrain.project.view.components.canvas.mouse {
	import com.greensock.TweenLite;
	import com.greensock.easing.Sine;

	import flash.display.Sprite;

	/**
	 * @author lessintern
	 */
	public class SprayCanTweenHelper {

		private static const MAX_ANGLE : Number = 50;
		private var _tweener : BezierTweenObject;
		private var _dir : int;
		private var _angle : Number;
		private var _firstSwayAngle : Number;
		private var _sprayCan : Sprite;
		private var _numSways : Number;
		private var _remainingSways : Number;
		private var _swaying : Boolean;

		public function SprayCanTweenHelper(sprayCan_ : Sprite) {
			_sprayCan = sprayCan_;

			_tweener = new BezierTweenObject();

			angle = 0;
			_dir = 1;
		}

		public function move(direction:int,distance:Number,isSpraying:Boolean) : void {
			_dir = direction;
			_firstSwayAngle = isSpraying? 30 : Math.min(MAX_ANGLE,distance + (10));
			_numSways = Math.round( _firstSwayAngle / 24);
			_remainingSways = _numSways;
			TweenLite.killTweensOf(this);
			sway();
		}
		private function sway() : void {
			_swaying = true;
			var targetAngle:Number = _dir * (_remainingSways/_numSways) * _firstSwayAngle;
			var time:Number = .008 * Math.abs(_angle - targetAngle);
			time += time * (Math.pow((_numSways-_remainingSways),.02)/40);
			_dir *= -1;
			_remainingSways--;
			TweenLite.to(this,  time, {angle:targetAngle,ease:Sine.easeOut,onComplete:_remainingSways >= 0? sway : onStandStill});
		}
		
		private function onStandStill() : void {
			_swaying = false;
		}


		public function set angle(angle_:Number): void {
			_angle = angle_;
			_tweener.rotation = _sprayCan.rotation = _angle;
		}

		public function get angle() : Number {
			return _angle;
		}

		public function finalize() : void {
			TweenLite.killTweensOf(this);
		}

		public function get swaying() : Boolean {
			return _swaying;
		}
	}
}
