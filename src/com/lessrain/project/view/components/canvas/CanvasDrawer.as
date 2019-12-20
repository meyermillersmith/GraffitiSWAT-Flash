package com.lessrain.project.view.components.canvas {
	import com.lessrain.project.ApplicationFacade;
	import com.lessrain.project.view.components.canvas.mouse.MouseManager;
	import com.lessrain.project.view.components.toolpalette.ToolPaletteEvent;
	import com.lessrain.project.view.utils.LessMath;

	import flash.display.Bitmap;
	import flash.display.BitmapData;
	import flash.display.BlendMode;
	import flash.display.DisplayObject;
	import flash.display.DisplayObjectContainer;
	import flash.display.IBitmapDrawable;
	import flash.display.Sprite;
	import flash.events.Event;
	import flash.events.KeyboardEvent;
	import flash.events.TimerEvent;
	import flash.geom.ColorTransform;
	import flash.geom.Matrix;
	import flash.geom.Point;
	import flash.geom.Rectangle;
	import flash.ui.Keyboard;
	import flash.utils.Timer;

	/**
	 * @author lessintern
	 */
	public class CanvasDrawer extends Sprite{
		
		public static const DRIP_TIME_SPRAY:int = 1000;
		public static const DRIP_TIME_ROLLER:int = 300;

		private var _mouseManager : MouseManager;
		private var _settings : CanvasSettings;
		private var _lastDotPos : Point;
		private var _dot : Sprite;
		private var _dripped : Boolean;
		private var _canvasBitmap : Bitmap;
		private var _undoCanvas : Bitmap;
		private var _background : DisplayObjectContainer;
		private var _dripStartTimer : Timer;
		private var _darkenTimer : Timer;
		private var _dripContainer : Sprite;
		private var _drawFunction : Function;
		private var _drawRect : Rectangle;
		private var _tempCanvas : Bitmap;
		private var _brushKey : String = "SprayBrushC3";
		private var _drawingStraight : Boolean;
		private var _isDripping : Boolean;
		private var _currentDripAnim : DripAnimation;
		private var _runningDripAnims : Vector.<DripAnimation>;
		private var _numDrips : int = 0;
		private var _numberOfRolls:int = 0;
		private var _currentRollerRotation:Number = 0;
		private var _currentAlphaMultiplier : Number;

		public function CanvasDrawer(mouseManager_ : MouseManager, settings_ : CanvasSettings, background_ : DisplayObjectContainer, _tempCanvasHolder : Sprite) {
			_mouseManager = mouseManager_;
			_settings = settings_;
			_background = background_;
			
			_tempCanvas = _tempCanvasHolder.addChild(new Bitmap()) as Bitmap;
			_tempCanvas.bitmapData = getNewTempCanvasBitmapData();
			
			_canvasBitmap = addChild(new Bitmap(getNewCanvasBitmapData())) as Bitmap;
			_canvasBitmap.smoothing = true;
			_undoCanvas = addChild(new Bitmap(getNewCanvasBitmapData())) as Bitmap;
			_undoCanvas.smoothing = true;

			_dripContainer = _tempCanvasHolder.addChild(new Sprite()) as Sprite;
			
			setDripTime(DRIP_TIME_SPRAY,true);
			_dripStartTimer.addEventListener(TimerEvent.TIMER, startDarkening);
			_darkenTimer.addEventListener(TimerEvent.TIMER, darken);
			_darkenTimer.addEventListener(TimerEvent.TIMER_COMPLETE, drip);
			_runningDripAnims = new Vector.<DripAnimation>();

			_drawFunction = interpolate;
			activateKeyListeners();
		}

		private function setDripTime(dripTime:Number, initial : Boolean) : void {
			var darkenTime : Number = dripTime/10;
			if (initial){
				_dripStartTimer = new Timer(dripTime);
				_darkenTimer = new Timer(darkenTime);
			} else {
				_dripStartTimer.delay = dripTime;
				_darkenTimer.delay = darkenTime;
			}
		}
		
		public function deactivateKeyListeners() : void {
			_tempCanvas.stage.removeEventListener(KeyboardEvent.KEY_DOWN, onPressKey);
			_tempCanvas.stage.removeEventListener(KeyboardEvent.KEY_UP, onReleaseKey);
		}

		public function activateKeyListeners() : void {
			_tempCanvas.stage.addEventListener(KeyboardEvent.KEY_DOWN, onPressKey);
			_tempCanvas.stage.addEventListener(KeyboardEvent.KEY_UP, onReleaseKey);
		}

		private function onPressKey(event : KeyboardEvent) : void {
			if(event.keyCode == Keyboard.SHIFT || event.keyCode == Keyboard.UP ){
				drawingStraight = true;
			}
		}

		private function onReleaseKey(event : KeyboardEvent) : void {
			if(event.keyCode == Keyboard.SHIFT || event.keyCode == Keyboard.UP ){
 				drawingStraight = false;
			}
		}

		public function get drawingStraight() : Boolean {
			return _drawingStraight;
		}

		public function set drawingStraight(drawingStraight : Boolean) : void {
			if (_drawingStraight != drawingStraight){
				_drawingStraight = drawingStraight;
				_mouseManager.drawingStraight = false;
			}
		}

		public function startSpraying() : void {
			_numberOfRolls = 0;
			_currentRollerRotation  = _mouseManager.rollerRotation;
			_currentAlphaMultiplier = 1;
			printUndoStep();
			spraySingleDot();
		}

		public function printUndoStep() : void {
			if (_undoCanvas.width > 0) {
				drawOnBackground(_canvasBitmap,_undoCanvas);
				undo();
			}
			if (_currentDripAnim){
				_currentDripAnim.printAfterFinish = true;
				_currentDripAnim = null;
			}
		}

		public function draw(event : Event = null) : void {
			var firstPoint : Point = _lastDotPos;
			var xLength : Number = _mouseManager.mouseX - firstPoint.x;
			var yLength : Number = _mouseManager.mouseY- firstPoint.y;
			var xLengthAbs : Number = Math.abs(xLength);
			var yLengthAbs : Number = Math.abs(yLength);
			if (_drawingStraight && !_mouseManager.drawingStraight){
				
				if (xLengthAbs > yLengthAbs){
					_mouseManager.fixateY();
				} else if (yLengthAbs > xLengthAbs){
					_mouseManager.fixateX();
				}
			}

			var length : Number = Math.sqrt(LessMath.pow2(xLength) + LessMath.pow2(yLength));
			if (length > _settings.toleratedDistance) {
				stopDripTimers();
				_drawFunction(event);
			} else {
				if (_settings.usingSpray || rollerCanDrip) {
					_dripStartTimer.start();
					_dripped = true;
				}
			}
		}
		
		/**
		 * INTERPOLATE DOTS / CURVES
		 */

		public function interpolate(event : Event = null) : void {
			var firstPoint : Point = _lastDotPos;
			if (!event && !_drawingStraight) _mouseManager.resetFriction();
			var mousePos: Point = new Point(_mouseManager.mouseX, _mouseManager.mouseY);
			var xLength : Number = mousePos.x - firstPoint.x;
			var yLength : Number = mousePos.y - firstPoint.y;

			var length : Number = Math.sqrt(LessMath.pow2(xLength) + LessMath.pow2(yLength));
			if (length > _settings.toleratedDistance) {
				var angleX : Number = Math.asin(xLength / length);
				var angleY : Number = Math.asin(yLength / length);
				var numParts : Number = Math.ceil(length / _settings.toleratedDistance);
				var dotDistance : Number = length / numParts;

				var oriMultiplier : Number = _settings.dotMultiplier;
				var targetMultiplier : Number;
				if (length < 10) {
					targetMultiplier = 1;
				} else if (length > _settings.dotMultiplierMaxDistance) {
					targetMultiplier = CanvasSettings.MIN_ALPHA_MULTIPLIER;
				} else {
					targetMultiplier = CanvasSettings.MIN_ALPHA_MULTIPLIER + ((_settings.dotMultiplierMaxDistance - length) / _settings.dotMultiplierMaxDistance) * (1 - CanvasSettings.MIN_ALPHA_MULTIPLIER);
				}
				
				var i : Number = dotDistance;
				while (i < length) {
					_settings.dotMultiplier = oriMultiplier + (targetMultiplier - oriMultiplier) * (i / length);
					sprayDot(firstPoint.x + Math.sin(angleX) * i, firstPoint.y + Math.sin(angleY) * i,false);
					i += dotDistance;
				}
				if (!event){
					sprayDot(mousePos.x, mousePos.y,false);
				}
			}
		}
		
		public function interpolateRoller(event : Event = null) : void {
			//trace (this, "interpolateRoller");
			var firstPoint : Point = _lastDotPos;
			if (!event && !_drawingStraight) _mouseManager.resetFriction();
			var mousePos: Point = new Point(_mouseManager.mouseX, _mouseManager.mouseY);
			var xLength : Number = mousePos.x - firstPoint.x;
			var yLength : Number = mousePos.y - firstPoint.y;
			var length : Number = Math.sqrt(LessMath.pow2(xLength) + LessMath.pow2(yLength));
			
			if (length > 0){
				var radians:Number = Math.atan2(yLength,xLength);
				radians-=Math.PI/2;
				_currentRollerRotation = radians;
			}
			if (length > _settings.toleratedDistance) {
				
				var angleX : Number = Math.asin(xLength / length);
				var angleY : Number = Math.asin(yLength / length);
				var numParts : Number = Math.ceil(length / _settings.toleratedDistance);
				var dotDistance : Number = length / numParts;

				var i : Number = dotDistance;
				while (i < length) {
					//_settings.dotMultiplier = oriMultiplier + (targetMultiplier - oriMultiplier) * (i / length);
					 sprayDot(firstPoint.x + Math.sin(angleX) * i, firstPoint.y + Math.sin(angleY) * i,false);
//					sprayDot(mousePos.x, mousePos.y,false, _rollRotation);
					i += dotDistance;
				}
			
				if (!event){
					 sprayDot(mousePos.x, mousePos.y,false);
				}
			}
		}
		
		public function drawCurvedLines(event : Event = null) : void {
			interpolate(event);
		}
		
		/**
		 * SPRAY A DOT
		 */

		public function spraySingleDot(e : Event = null) : void {
			//trace ("spraySingleDot");
			//_rollRotation = 0;
			sprayDot(_mouseManager.mouseX, _mouseManager.mouseY, false);
		}

		private function sprayDot(x_ : Number, y_ : Number, debug : Boolean = false) : void {
			
			_lastDotPos = new Point(x_, y_);
					
			var diameter : Number;
			//var diameter : Number = debug ? debugDiameter : _settings.dotDiameter * (pen ? 1 : _settings.dotMultiplier);
			var translationMatrix : Matrix = new Matrix();
			var transform : ColorTransform = new ColorTransform();
			transform.color = _settings.dotColor.color;
			_currentAlphaMultiplier = 1;
			
			switch(_settings.toolType){
				case ToolPaletteEvent.SPRAY_MODE:					
					diameter = _settings.dotDiameter * _settings.dotMultiplier;
					translationMatrix.rotate(2 * Math.PI * Math.random());
					_currentAlphaMultiplier = _settings.dotCenterAlpha * _settings.dotMultiplier;
					break;
				case ToolPaletteEvent.PEN_MODE:
					diameter = _settings.dotDiameter;
					break;
				case ToolPaletteEvent.ROLLER_MODE:
					diameter = _settings.dotDiameter;
					_currentAlphaMultiplier = _settings.dotCenterAlpha - (_numberOfRolls > 15? (_numberOfRolls - 15) * 0.005 : 0);
					//translationMatrix.rotate(2 * Math.PI * Math.random());
					_numberOfRolls++;
					var rnd:Number = Math.random();
					if (rnd >= 3/4){
						translationMatrix.a=-1;
					}else if (rnd >= 2/4){
						translationMatrix.d=-1;
					}else if (rnd >= 1/4){
						translationMatrix.a=-1;
						translationMatrix.d=-1;
					}
//					_dot.rotation = _currentRollerRotation;		
					translationMatrix.rotate(_currentRollerRotation);
					break;		
				default:
			}
			
			// Size	
			transform.alphaMultiplier = _currentAlphaMultiplier;
			translationMatrix.scale(diameter/_dot.width, diameter/_dot.width);				
			translationMatrix.translate(x_, y_);
			
			//trace ("rollRotation_",rollRotation_);
				
			// Color
			drawOnBackground(_tempCanvas, _dot, translationMatrix, transform, null);
		}
		
		public function flipHorizontal(dsp:DisplayObject):void
{
var matrix:Matrix = dsp.transform.matrix;
matrix.a=-1;
matrix.tx=dsp.width+dsp.x;
dsp.transform.matrix=matrix;
}

public function flipVertical(dsp:DisplayObject):void
{
var matrix:Matrix = dsp.transform.matrix;
matrix.d=-1;
matrix.ty=dsp.height+dsp.y;
dsp.transform.matrix=matrix;
}
		
		private function drawOnBackground(bitmap:Bitmap, source:IBitmapDrawable, matrix:Matrix = null, colorTransform:ColorTransform = null, blendMode_:String = null):void{
			if (bitmap == _tempCanvas){
				//matrix = new Matrix();
				bitmap.bitmapData.draw(source,matrix,colorTransform,null,_drawRect);			
			} else {

				 if (source == _tempCanvas || source is DripAnimation) {
					if (!matrix) matrix = new Matrix();
					matrix.translate(-_background.parent.x, -_background.parent.y);
				 }
				bitmap.bitmapData.draw(source,matrix,colorTransform,blendMode_);
			}
			//bitmap.rotation = rotation_;
		}
		
		

		public function drawSprayedDot(mouseDot : Boolean = false) : Sprite {			
			applyCapType();
			if (mouseDot){
				var transform : ColorTransform = new ColorTransform();
				transform.color = _settings.dotColor.color;
				_dot.transform.colorTransform = transform;
				_dot.alpha = _settings.dotCenterAlpha;
			}
			return _dot;
		}
		
		
		public function applyCapType() : void {		
//			trace('CanvasDrawer::applyCapType: '+_settings.toolType+' _settings.sizeIndex '+_settings.sizeIndex);
			
			switch(_settings.toolType){
				case ToolPaletteEvent.SPRAY_MODE:					
					_dot = ApplicationFacade.getSWFAssetInstance(_brushKey);
					_drawFunction = interpolate;	
					setDripTime(DRIP_TIME_SPRAY, false);				
					break;
				case ToolPaletteEvent.PEN_MODE:
					_dot = ApplicationFacade.getSWFAssetInstance("PenTip");
					_drawFunction = drawCurvedLines;					
					break;
				case ToolPaletteEvent.ROLLER_MODE:
//					trace('CanvasDrawer::applyCapType:RollerSplash'+_settings.sizeIndex);		
					_dot = ApplicationFacade.getSWFAssetInstance("RollerSplash"+_settings.sizeIndex);	
					_drawFunction = interpolateRoller;
					setDripTime(DRIP_TIME_ROLLER, false);
					break;		
				default:
			}
		}
		

		public function stopSpraying() : void {
			drawOnBackground(_undoCanvas, _tempCanvas);
			_tempCanvas.bitmapData = getNewTempCanvasBitmapData();
			stopDripTimers();
			if (_settings.usingRoller) _mouseManager.rollerRotation = _currentRollerRotation;
			drawingStraight = false;
			if (_currentDripAnim){
				_currentDripAnim.addEventListener(DripAnimation.ANIM_COMPLETE, drawDrops);
				_currentDripAnim.stop();
			}
		}


		/**
		 * DRIPPING
		 */
		private function stopDripTimers() : void {
			_dripStartTimer.stop();
			_darkenTimer.reset();
			_dripped = false;
			
		}

		private function startDarkening(event : Event = null) : void {
			_dripStartTimer.stop();
			if (_currentDripAnim){
				_currentDripAnim.addEventListener(DripAnimation.ANIM_COMPLETE, drawDrops);
				_currentDripAnim.stop();
			}
			_darkenTimer.repeatCount = 5 / _currentAlphaMultiplier;
			_darkenTimer.start();
		}

		private function drip(event : TimerEvent) : void {
			_darkenTimer.reset();
			var globalMousePos:Point = new Point(_mouseManager.mouseX, _mouseManager.mouseY);
			var maxHeight:Number = _tempCanvas.height - _mouseManager.mouseY;
			if (ToolPaletteEvent.ROLLER_MODE) maxHeight = Math.min(_tempCanvas.height, 80);
			_currentDripAnim = _dripContainer.addChild(new DripAnimation(_settings.dotColor.color, _settings.dotDiameter, globalMousePos.x, globalMousePos.y, maxHeight)) as DripAnimation;
			_currentDripAnim.addEventListener(DripAnimation.ANIM_COMPLETE, drawDrops);
			_currentDripAnim.startAnim();
			_currentDripAnim.name = 'drips_'+_numDrips;
			_numDrips++;
			_runningDripAnims.push(_currentDripAnim);
			_isDripping = true;
		}

		private function drawDrops(event:Event) : void {
			var dripAnim:DripAnimation = event.target as DripAnimation;
			var transparency:ColorTransform = new ColorTransform();
			transparency.alphaMultiplier = .9;
			drawOnBackground(dripAnim.printAfterFinish ? _canvasBitmap : _undoCanvas, dripAnim,null,transparency,BlendMode.LAYER);
			finalizeDripAnim(dripAnim);
		}
		
		
		
		
		private function finalizeDripAnim(dripAnim:DripAnimation):void{
			dripAnim.removeEventListener(DripAnimation.ANIM_COMPLETE, drawDrops);
			dripAnim.finalize();
			_runningDripAnims.splice(_runningDripAnims.indexOf(dripAnim), 1);
			_dripContainer.removeChild(dripAnim);
			if (dripAnim == _currentDripAnim) _currentDripAnim = null;
		}

		private function darken(event : TimerEvent) : void {
			spraySingleDot();
		}
		
		public function get rollerCanDrip() : Boolean {
			return _settings.usingRoller && _currentAlphaMultiplier > 0.6;
		}

		/**
		 * UTILS
		 */
		public function clear(event : Event = null) : void {
			if (_canvasBitmap) {
				_canvasBitmap.bitmapData = getNewCanvasBitmapData();
				undo();
				undoDripping(true);
			}
		}

		public function undo(event : Event = null) : void {
			_undoCanvas.bitmapData = getNewCanvasBitmapData();
			if (event) undoDripping();
		}
		
		private function undoDripping(clearAll:Boolean = false):void{
			if (_currentDripAnim){
				killDripAnim(_currentDripAnim);
				if (clearAll){
					while (_runningDripAnims.length >0){
						killDripAnim(_runningDripAnims[0]);
					}
				}
			}
		}

		private function killDripAnim(dripAnim : DripAnimation) : void {
				dripAnim.stop(true);
				finalizeDripAnim(dripAnim);
		}

		private function getNewTempCanvasBitmapData() : BitmapData {
			var  b:BitmapData = new BitmapData(_background.stage.stageWidth, _background.stage.stageHeight, true, 0x00000000);
			return b;
		}

		private function getNewCanvasBitmapData() : BitmapData {
			var  b:BitmapData = new BitmapData(_background.width, _background.height, true, 0x00000000);
			return b;
		}
		
		
		public function clearContainer(sprite : Sprite) : void {
			while (sprite.numChildren > 0) {
				sprite.removeChildAt(0);
			}
		}

		public function set background(background_ : DisplayObjectContainer) : void {
			_background = background_;
			clear();
		}

		public function makeDrawRect() : void {
			var x1:Number = Math.max(0,_background.parent.x);
			var y1:Number = Math.max(0,_background.parent.y);
			var x2:Number = Math.min(stage.stageWidth,_background.width +_background.parent.x);
			var y2:Number = Math.min(stage.stageHeight,_background.height +_background.parent.y);
			_drawRect = new Rectangle (x1, y1,x2 - x1, y2 - y1);
			var tempCanvasCopy:BitmapData = _tempCanvas.bitmapData;
			_tempCanvas.bitmapData = getNewTempCanvasBitmapData();
			_tempCanvas.bitmapData.draw(tempCanvasCopy);
		}

		public function get drawFunction() : Function {
			return _drawFunction;
		}
	}
}
