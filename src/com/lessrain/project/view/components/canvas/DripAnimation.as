package com.lessrain.project.view.components.canvas {
	import flash.display.BlendMode;
	import com.lessrain.util.CallDelay;

	import flash.display.Sprite;
	import flash.events.Event;

	/**
	 * @author lessintern
	 */
	public class DripAnimation extends Sprite {

		public static const ANIM_COMPLETE : String = "dropAnimComplete";
		private var _numDrops : int;
		private var _finishedDrops : int;
		private var _dotColor : uint;
		private var _nuclearSize : Number;
		private var _idealWidth : Number;
		private var _dripAnim : Sprite;
		private var _dropsMinX : Number;
		private var _drops : Vector.<AnimatedDrop>;
		private var _printAfterFinish : Boolean;
		private var _stopped : Boolean;
		private var _maxHeight : Number;

		public function DripAnimation(dotColor : uint, dotDiameter : Number, mouseX_ : Number, mouseY_ : Number, maxHeight_ : Number) {
			_dotColor = dotColor;
			_nuclearSize = (.6 * dotDiameter );
			_idealWidth  = _nuclearSize / 7.5;
			_idealWidth *= (200 - _nuclearSize) / 200;
			_dripAnim = addChild(new Sprite()) as Sprite;
			_numDrops  = Math.round(Math.random() * 1) + 2;
			
			_dripAnim.x = mouseX_ - (_nuclearSize / 2);
			_dripAnim.y = mouseY_;
			
			_maxHeight = maxHeight_;
			
			_dropsMinX = _nuclearSize / 4;
			
			alpha = .9;
			blendMode = BlendMode.LAYER;
			
			_drops = new Vector.<AnimatedDrop>();
			
		}

		public function startAnim() : void {
			var numDropMin1:int = _numDrops - 1;
			for (var i : int = 0; i < _numDrops; i++) {
				var dropWidth:Number = _idealWidth - (_idealWidth/4) + (_idealWidth * 2 / 4) * Math.random();
				var drop : AnimatedDrop = _dripAnim.addChild(new AnimatedDrop(_dotColor, _nuclearSize, dropWidth, _maxHeight)) as AnimatedDrop;
				drop.x = (((1 / _numDrops) / 2 + (i / _numDrops)) * _nuclearSize) + ((Math.random()*_nuclearSize/10) -_nuclearSize/20);
				CallDelay.call(drop.startAnim, Math.random() * 1000);
				drop.x = _dropsMinX + ((_nuclearSize/(2*numDropMin1)) * i);
				var dropSpace:Number = (_nuclearSize / 2)/(numDropMin1);
				if (i == 0){
					drop.x += (dropSpace / 2) * Math.random();
				} else if(i == numDropMin1){
					drop.x -=  (dropSpace / 2) * Math.random();
				}else {
					drop.x = drop.x - ( dropSpace / 2 ) + dropSpace * Math.random();
				}
				
				drop.addEventListener(AnimatedDrop.ANIM_COMPLETE, onDropComplete);
				_drops.push(drop);
			}
		}

		public function stop(hardStop:Boolean = false) : void {
			if (!_stopped){
				for each (var drop : AnimatedDrop in _drops) {
					drop.stop(hardStop);
				}
				if (hardStop){
					drop.removeEventListener(AnimatedDrop.ANIM_COMPLETE, onDropComplete);
					finalize();
				}
				_stopped = true;
			}
		}


		private function onDropComplete(event : Event) : void {
			_finishedDrops++;
			if (_finishedDrops == _numDrops){
				for each (var drop : AnimatedDrop in _drops) {
					drop.removeEventListener(AnimatedDrop.ANIM_COMPLETE, onDropComplete);
				}
				dispatchEvent(new Event(ANIM_COMPLETE));
			}
		}

		public function finalize() : void {
			while (_drops.length > 0){
				_dripAnim.removeChild(_drops.pop());
			}
		}

		public function get printAfterFinish() : Boolean {
			return _printAfterFinish;
		}

		public function set printAfterFinish(printAfterFinish : Boolean) : void {
			_printAfterFinish = printAfterFinish;
		}
	}
}
