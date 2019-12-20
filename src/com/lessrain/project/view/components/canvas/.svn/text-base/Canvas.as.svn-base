package com.lessrain.project.view.components.canvas {
	import com.lessrain.debug.Debug;
	import com.lessrain.project.model.vo.ColorData;
	import com.lessrain.project.view.components.canvas.mouse.MouseManager;
	import com.lessrain.project.view.components.sound.SoundController;
	import com.lessrain.project.view.components.toolpalette.DistanceControl;
	import com.lessrain.project.view.components.toolpalette.ToolPaletteEvent;

	import flash.display.DisplayObjectContainer;
	import flash.display.Sprite;
	import flash.events.Event;
	import flash.events.MouseEvent;


	/**
	 * @author lessintern
	 */
	public class Canvas extends Sprite {

		public static const SPRAYED : String = "colorSprayed";
		public static const CLEAR : String = "canvasCleared";
		private var _soundController : SoundController = SoundController.getInstance();
		private var _mouseManager : MouseManager;
		private var _settings : CanvasSettings;
		private var _canvasDrawer : CanvasDrawer;
		private var _mouseContainer : Sprite;
		private var _backgroundLoaded : Boolean;
		private var _addedToStage : Boolean;
		private var _isSpraying : Boolean;
		private var _background : DisplayObjectContainer;
		private var _ready : Boolean;
		private var _mouseVisiblePlane : Sprite;
		private var _tempCanvasHolder : Sprite;
		private var _mouseOutsideWindow : Boolean;

		public function Canvas(mouseContainer_ : Sprite, mouseVisiblePlane_ : Sprite, tempCanvasHolder_ : Sprite) {
			_mouseContainer = mouseContainer_;
			_mouseVisiblePlane = mouseVisiblePlane_;
			_tempCanvasHolder = tempCanvasHolder_;
			_settings = new CanvasSettings();
			addEventListener(Event.ADDED_TO_STAGE, onAddedToStage);
		}

		private function onAddedToStage(event : Event) : void {
			addedToStage = true;
		}

		private function init() : void {
			if (_canvasDrawer) {
				_canvasDrawer.clear();
			} else {
				_mouseManager = new MouseManager(this, _mouseContainer, _mouseVisiblePlane);
				_settings.mouseManager = _mouseManager;
				_canvasDrawer = addChild(new CanvasDrawer(_mouseManager, _settings, _background, _tempCanvasHolder)) as CanvasDrawer;				

				dotDistance = DistanceControl.START_DISTANCE;

				_mouseManager.initMousePos();

				removeEventListener(Event.ADDED_TO_STAGE, onAddedToStage);
				parent.addEventListener(MouseEvent.MOUSE_DOWN, startSpraying);
				
				_ready = true;
			}
		}

		private function startSpraying(event : MouseEvent) : void {
			_isSpraying = true;
			if (_settings.toolType == ToolPaletteEvent.SPRAY_MODE) {
				if (!_soundController.isPlaying) _soundController.playEventSoundByID(SoundController.Spray, 1, 0, 100000);
				_settings.dotMultiplier = 1;
			}
			if (_settings.toolType == ToolPaletteEvent.ROLLER_MODE) {
				//if (!_soundController.isPlaying) 
				_soundController.playEventSoundByID(SoundController.RollerDrawing, 1, 0, 0);
			}
			_mouseManager.enterSprayMode();
			_canvasDrawer.startSpraying();
			parent.removeEventListener(MouseEvent.MOUSE_OVER, startSpraying);
			parent.addEventListener(Event.ENTER_FRAME, _canvasDrawer.draw);
			stage.addEventListener(MouseEvent.MOUSE_UP, stopSpraying);
			stage.addEventListener(MouseEvent.MOUSE_OUT, onMouseOut);
			stage.addEventListener(MouseEvent.MOUSE_OVER, onMouseOver);
			dispatchEvent(new Event(SPRAYED));
		}

		private function stopSpraying(event : MouseEvent = null) : void {
			parent.removeEventListener(Event.ENTER_FRAME, _canvasDrawer.draw);
			if (event) {
				stage.removeEventListener(MouseEvent.MOUSE_UP, stopSpraying);
//				parent.removeEventListener(MouseEvent.MOUSE_OVER, startSpraying);
			}
			if (_isSpraying && !_mouseOutsideWindow) finishSpraying();
			if (event)  _soundController.stop();
			_mouseManager.resetSprayDirections();
			_canvasDrawer.stopSpraying();
			_mouseManager.leaveSprayMode(_mouseOutsideWindow);
			_isSpraying = false;
			stage.removeEventListener(MouseEvent.MOUSE_OUT, onMouseOut);
			stage.removeEventListener(MouseEvent.MOUSE_OVER, onMouseOver);
		}

		private function onMouseOut(event : Event) : void {
			_mouseOutsideWindow = true;
		}

		private function onMouseOver(event : MouseEvent) : void {
			_mouseOutsideWindow = false;
		}


		private function finishSpraying() : void {
			_canvasDrawer.drawFunction();
		}

		/**
		 * DRAW FUNCTIONS
		 */
		public function clear(event : Event = null) : void {
			if (_canvasDrawer) _canvasDrawer.clear(event);
			dispatchEvent(new Event(CLEAR));
			Debug.clear();
		}

		public function undo(event : Event = null) : void {
			_canvasDrawer.undo(event);
		}
		
		/**
		 * SETTINGS
		 */
		public function set dotColor(dotColor : ColorData) : void {
			_settings.dotColor = dotColor;
			trace ("--> dotColor");
			if (_mouseManager) _mouseManager.drawSprayCanCircle(_settings.dotDiameter, _settings.dotColor.color, _settings.dotDistance);
		}

		public function set capType(capType_ : String) : void {
			trace (this, "capType_", capType_);
			_settings.toolType = capType_;
			_canvasDrawer.applyCapType();
		}

		public function set sizeIndex(sizeIndex_ : Number) : void {
			_settings.sizeIndex = sizeIndex_;
		}

		public function set dotDiameterOffset(dotDiameterOffset_ : Number) : void {
			_settings.dotDiameterOffset = dotDiameterOffset_;
		}

		public function set dotDistance(dotDistance_ : Number) : void {
			_settings.dotDistance = dotDistance_;
		}

		public function get dotMultiplier() : Number {
			return _settings.dotMultiplier;
		}

		public function get dotDiameter() : Number {
			return _settings.dotDiameter;
		}

		public function get dotColor() : ColorData {
			return _settings.dotColor;
		}

		/**
		 * GETTERS SETTERS
		 */
		public function set backgroundLoaded(backgroundLoaded : Boolean) : void {
			_backgroundLoaded = backgroundLoaded;
			if (_addedToStage && _backgroundLoaded) init();
		}

		public function set addedToStage(addedToStage : Boolean) : void {
			_addedToStage = addedToStage;
			if (_addedToStage && _backgroundLoaded) init();
		}

		public function set background(background_ : DisplayObjectContainer) : void {
			_background = background_;
			if (_canvasDrawer) _canvasDrawer.background = background_;
		}

		public function actualiseBGPosition():void{
			if (_canvasDrawer) _canvasDrawer.makeDrawRect();
		}

		
		public function set grabModeActive(_active : Boolean) : void {
			_mouseManager.grabModeActive = _active;
			if (_active){
				parent.removeEventListener(MouseEvent.MOUSE_DOWN, startSpraying);
			} else {
				parent.addEventListener(MouseEvent.MOUSE_DOWN, startSpraying);
			}
		}
		
		public function set previewModeActive(_active : Boolean) : void {
			_mouseManager.previewModeActive = _active;
		}

		public function deactivateMouse() : void {
			_mouseManager.deactivate();
		}

		public function get isSpraying() : Boolean {
			return _isSpraying;
		}

		public function get settings() : CanvasSettings {
			return _settings;
		}

		public function get canvasDrawer() : CanvasDrawer {
			return _canvasDrawer;
		}

		public function get ready() : Boolean {
			return _ready;
		}

		override public function get parent() : DisplayObjectContainer {
			return super.parent;
		}
		
		override public function get mouseX():Number{
//			Debug.trace('Canvas::mouseX:'+_tempCanvas.mouseX+' super '+super.mouseX);
			return _tempCanvasHolder.mouseX;
		}
		
		override public function get mouseY():Number{
			return _tempCanvasHolder.mouseY;
		}
	}
}
