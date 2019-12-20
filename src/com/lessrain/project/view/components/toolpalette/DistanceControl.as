package com.lessrain.project.view.components.toolpalette {
	import flash.ui.Keyboard;
	import com.lessrain.debug.Debug;
	import com.lessrain.project.ApplicationFacade;

	import flash.display.Sprite;
	import flash.events.Event;
	import flash.events.KeyboardEvent;
	import flash.events.MouseEvent;
	import flash.geom.ColorTransform;

	/**
	 * @author lessintern
	 */
	public class DistanceControl extends Sprite {

		public static const DISTANCE_CHANGED : String = 'distanceSet';
		public static const RIGHT_MARGIN : int = 10;
		public static const LEFT_MARGIN : int = 20;
		public static const START_DISTANCE : Number = 1 / 3;
		
		public static var KEY_A:int = 65;
		public static var KEY_S:int = 83;

		private var _bg : Sprite;
		private var _knob : Sprite;
		private var _knobMinX : Number;
		private var _knobMaxX : Number;

		public function DistanceControl() {
			var bg : Sprite = addChild(ApplicationFacade.getSWFAssetInstance('DistanceRuler')) as Sprite;
			_bg = bg.getChildByName('bg') as Sprite;
			_knob = bg.getChildByName('knob') as Sprite;
			
			
			_knobMinX = 0;			
			_knobMaxX = bg.width - _knob.width / 2;
			
			_knob.x = _knobMinX + START_DISTANCE * (_knobMaxX - _knobMinX);
			
			buttonMode = true;
			
			addEventListener(MouseEvent.MOUSE_DOWN, startDragging);
			
			var dragger:Sprite = addChild(new Sprite()) as Sprite;
			dragger.graphics.beginFill(0xFF0000,0);
			dragger.graphics.drawRect(0, 0, width, height);
			dragger.graphics.endFill();
			hitArea = dragger;
			
			addEventListener(Event.ADDED_TO_STAGE, onAddedToStage);
		}

		private function onAddedToStage(event : Event) : void {
			removeEventListener(Event.ADDED_TO_STAGE, onAddedToStage);
			activateStageListener();
		}

		private function onPressKey(event : KeyboardEvent) : void {
			switch(event.keyCode) {
				case KEY_A:
				case Keyboard.LEFT:
					_knob.x = getBoundedKnobX(_knob.x - 5);
					dispatchEvent(new Event(DISTANCE_CHANGED));
					break;
				case KEY_S:
				case Keyboard.RIGHT:
					_knob.x = getBoundedKnobX(_knob.x + 5);
					dispatchEvent(new Event(DISTANCE_CHANGED));
					break;
			}
		}

		public function setColor(color : uint) : void {
			var colorTransform : ColorTransform = _bg.transform.colorTransform;
			colorTransform.color = color;
			_bg.transform.colorTransform = colorTransform;
		}

		private function startDragging(event : MouseEvent) : void {
			drag();
			stage.addEventListener(MouseEvent.MOUSE_UP, stopDragging);
			stage.addEventListener(MouseEvent.MOUSE_MOVE, drag);
		}

		private function drag(event : MouseEvent = null) : void {
			_knob.x = getBoundedKnobX(mouseX); 
		}
		
		private function getBoundedKnobX(newX:Number):Number{
			return newX < _knobMinX? _knobMinX : (newX > _knobMaxX? _knobMaxX : newX); 
		}

		private function stopDragging(event : MouseEvent) : void {
			stage.removeEventListener(MouseEvent.MOUSE_UP, stopDragging);
			stage.removeEventListener(MouseEvent.MOUSE_MOVE, drag);
			dispatchEvent(new Event(DISTANCE_CHANGED));
		}
		
		public function get distance():Number{
			return (_knob.x - _knobMinX) / (_knobMaxX - _knobMinX);
		}

		public function activateStageListener() : void {
			Debug.trace('DistanceControl::activateStageListener:');
			stage.addEventListener(KeyboardEvent.KEY_DOWN, onPressKey);
		}
		public function deactivateStageListener() : void {
			Debug.trace('DistanceControl::deactivateStageListener:');
			stage.removeEventListener(KeyboardEvent.KEY_DOWN, onPressKey);
		}
	}
}
