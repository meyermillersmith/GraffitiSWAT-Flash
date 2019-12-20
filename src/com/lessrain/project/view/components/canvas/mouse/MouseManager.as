package com.lessrain.project.view.components.canvas.mouse {
	import flash.ui.Keyboard;
	import com.lessrain.project.ApplicationFacade;
	import com.lessrain.project.view.components.canvas.Canvas;
	import com.lessrain.project.view.components.sound.SoundController;
	import com.lessrain.project.view.components.toolpalette.DistanceControl;
	import com.lessrain.project.view.components.toolpalette.ToolPaletteEvent;
	import flash.display.Sprite;
	import flash.events.Event;
	import flash.events.KeyboardEvent;
	import flash.events.MouseEvent;
	import flash.filters.DropShadowFilter;
	import flash.geom.ColorTransform;
	import flash.geom.Point;
	import flash.ui.Mouse;
	import flash.ui.MouseCursor;

	/**
	 * @author lessintern
	 */
	public class MouseManager {

		private static const FRICTION : Number = .15;
		private static const SPRAY_CAN_MIN_H : int = 45;
		private static const SPRAY_CAN_MAX_H : int = 70;
		private static const SPRAY_CAN_H_DIFF : int = SPRAY_CAN_MAX_H - SPRAY_CAN_MIN_H;
		private static const ROLLER_ROTATION_ADD: Number = 5;
		private static const ROLLER_SCALE: Number =  0.4;
		private static const PEN_SCALE: Number = 6 / 25;
		private var _sprayCanCircle : Sprite;
		private var _sprayDirections : Point;
		private var _sprayExactDirections : Point;
		private var _sprayDirectionLengths : Point;
		private var _sprayDirectionExactLengths : Point;
		private var _lastDirectionTimeStamps : Point;
		private var _lastMousePos : Point;
		private var _hasChangedDirection : Point;
		private var _frictionX : Number = 0;
		private var _frictionY : Number = 0;
		private var _sprayCan : Sprite;
		private var _toolHolder : Sprite;
		private var _brush : Sprite;
		private var _brushTip : Sprite;
		private var _roller : Sprite;
		private var _rollerSleeze : Sprite;
		private var _canvas : Canvas;
		private var _container : Sprite;
		private var _originalSprayCanHeight : Number;
		private var _sprayCanTweenHelper : SprayCanTweenHelper;
		private var _mouseJustReleasedOutside : Boolean;
		private var _cross : Sprite;
		private var _usingTool : String;
		private var _drawingStraightXAxis : Boolean;
		private var _drawingStraightYAxis : Boolean;
		private var _grabModeActive : Boolean;

		public function MouseManager(canvas : Canvas, container_ : Sprite, mouseVisiblePlane : Sprite) {
			_container = container_;
			_canvas = canvas;
			_toolHolder = _container.addChild(new Sprite()) as Sprite;
			_toolHolder.visible = false;
			_toolHolder.mouseEnabled = false;

			_sprayCanCircle = _toolHolder.addChild(new Sprite()) as Sprite;

			_sprayCan = _toolHolder.addChild(ApplicationFacade.getSWFAssetInstance('SprayCan')) as Sprite;
			_sprayCan.mouseEnabled = false;
			_sprayCan.mouseChildren = false;
			_originalSprayCanHeight = _sprayCan.height;
			_sprayCanTweenHelper = new SprayCanTweenHelper(_sprayCan);

			_brush = _toolHolder.addChild(ApplicationFacade.getSWFAssetInstance('Pen')) as Sprite;
			_brush.mouseEnabled = false;
			_brush.mouseChildren = false;
			_brush.visible = false;
			_brushTip = _brush.getChildByName('tip') as Sprite;
			
			_roller = _toolHolder.addChild(ApplicationFacade.getSWFAssetInstance('Roller')) as Sprite;
			_roller.mouseEnabled = false;
			_roller.mouseChildren = false;
			_roller.visible = false;
			_rollerSleeze = _roller.getChildByName('sleeze') as Sprite;
			_roller.scaleY = _roller.scaleX = ROLLER_SCALE;
			
			_cross = _toolHolder.addChild(ApplicationFacade.getSWFAssetInstance('SprayCursor')) as Sprite;
			_cross.mouseEnabled = false;
			_cross.mouseChildren = false;
			_cross.visible = false;

			_brush.scaleY = _brush.scaleX = PEN_SCALE;

			_frictionX = mouseX;
			_frictionY = mouseY;

			_sprayDirections = new Point(0, 0);
			_sprayExactDirections = new Point(0, 0);
			_sprayDirectionExactLengths = new Point(0, 0);
			_sprayDirectionLengths = new Point(0, 0);
			_lastMousePos = new Point(0, 0);
			_lastDirectionTimeStamps = new Point(0, 0);
			_hasChangedDirection = new Point(0, 0);

			_canvas.parent.addEventListener(MouseEvent.MOUSE_OVER, setCircleVisibility);
			_canvas.parent.addEventListener(MouseEvent.MOUSE_OUT, setCircleVisibility);
			// mouseVisiblePlane.addEventListener(MouseEvent.MOUSE_OVER, setCircleVisibility);
			// mouseVisiblePlane.addEventListener(MouseEvent.MOUSE_OUT, setCircleVisibility);
			
			_usingTool = ToolPaletteEvent.SPRAY_MODE;
		}

		public function deactivateRollerKeyListeners() : void {
			_container.stage.removeEventListener(KeyboardEvent.KEY_DOWN, onPressKey);
			_container.stage.addEventListener(MouseEvent.MOUSE_WHEEL, mouseWheelHandler);
		}

		public function activateRollerKeyListeners() : void {
			_container.stage.addEventListener(KeyboardEvent.KEY_DOWN, onPressKey);
			_container.stage.addEventListener(MouseEvent.MOUSE_WHEEL, mouseWheelHandler);
		}

		private function onPressKey(event : KeyboardEvent) : void {
			switch(event.keyCode) {
				case DistanceControl.KEY_S:
				case Keyboard.RIGHT:
					_roller.rotation += ROLLER_ROTATION_ADD;
				break;
				case DistanceControl.KEY_A:
				case Keyboard.LEFT:
					_roller.rotation -= ROLLER_ROTATION_ADD;
					break;
			}
		}
		
		private function mouseWheelHandler(event : MouseEvent) : void {
			_roller.rotation += event.delta * ROLLER_ROTATION_ADD;
		}

		private function resizeSprayCan(scale : Number) : void {
			var newH : Number = SPRAY_CAN_MIN_H + scale * SPRAY_CAN_H_DIFF;
			_sprayCan.scaleY = _sprayCan.scaleX = newH / _originalSprayCanHeight;
			_sprayCan.filters = [new DropShadowFilter(4 + scale * 18, 45, 0, .2 + scale * .4)];
		}

		public function initMousePos() : void {
			_toolHolder.x = _toolHolder.width;
			_toolHolder.y = _toolHolder.height;
		}

		/**
		 * CHECK SHAKING FUNCTIONS
		 */
		public function resetSprayDirections() : void {
			_sprayDirections = new Point(0, 0);
		}

		private function checkXDirectionChanged() : void {
			if (!_canvas.isSpraying) {
				var xLength : Number = _canvas.mouseX - _lastMousePos.x;
				var xDir : Number = xLength == 0 ? _sprayExactDirections.x : ( xLength < 0 ? -1 : 1);
				if (_sprayDirections.x != 0) {
					var time : Number = timeStamp - _lastDirectionTimeStamps.x;
					if (xDir != _sprayExactDirections.x) {
						_hasChangedDirection.x = 1;
						_sprayExactDirections.x = xDir;
						_sprayDirectionExactLengths.x = Math.abs(xLength);
						if (_sprayDirectionExactLengths.x > 20) {
							checkShaking('x', time);
						}
					} else {
						_sprayDirectionExactLengths.x += Math.abs(xLength);
						if (_hasChangedDirection.x && _sprayDirectionExactLengths.x > 20) {
							checkShaking('x', time);
						}
					}
					_sprayDirectionLengths.x += Math.abs(xLength);
				} else {
					_sprayDirections.x = xDir;
					_sprayExactDirections.x = xDir;
					_lastDirectionTimeStamps.x = timeStamp;
					_sprayDirectionLengths.x = 0;
					_sprayDirectionExactLengths.x = 0;
				}
			}
		}

		private function checkYDirectionChanged() : void {
			if (!_canvas.isSpraying) {
				var yLength : Number = _canvas.mouseY - _lastMousePos.y;
				var yDir : Number = yLength == 0 ? _sprayExactDirections.y : ( yLength < 0 ? -1 : 1);
				if (_sprayDirections.y != 0) {
					var time : Number = timeStamp - _lastDirectionTimeStamps.y;
					if (yDir != _sprayExactDirections.y) {
						_hasChangedDirection.y = 1;
						_sprayExactDirections.y = yDir;
						_sprayDirectionExactLengths.y = Math.abs(yLength);
						if (_sprayDirectionExactLengths.y > 20) {
							checkShaking('y', time);
						}
					} else {
						_sprayDirectionExactLengths.y += Math.abs(yLength);
						if (_hasChangedDirection.y && _sprayDirectionExactLengths.y > 20) {
							checkShaking('y', time);
						}
					}
					_sprayDirectionLengths.y += Math.abs(yLength);
				} else {
					_sprayDirections.y = yDir;
					_sprayExactDirections.y = yDir;
					_lastDirectionTimeStamps.y = timeStamp;
					_sprayDirectionLengths.y = 0;
					_sprayDirectionExactLengths.y = 0;
				}
			}
		}

		private function checkShaking(attribute : String, time : Number) : void {
			_hasChangedDirection[attribute] = 0;
			_sprayDirections[attribute] = _sprayExactDirections[attribute];
			var isShake : Boolean = _sprayDirectionLengths[attribute] / time > 1.5 / (attribute == 'y' ? 2 : 1);
			if (isShake) {
				SoundController.getInstance().playEventSoundByID(SoundController.SprayCanShake);
			}
			_sprayDirectionLengths[attribute] = 0;
			_lastDirectionTimeStamps[attribute] = timeStamp;
		}

		/**
		 * DRAW AND POSITION MOUSE FUNCTIONS
		 */
		private function setCirclePosition(event : Event) : void {
			if (_toolHolder.x != _canvas.mouseX || _toolHolder.y != _canvas.mouseY ) {
				_toolHolder.x = _canvas.mouseX>>0;// mouse
				_toolHolder.y = _canvas.mouseY>>0;// mouse

				if (_canvas.settings.toolType == ToolPaletteEvent.SPRAY_MODE) {
					checkXDirectionChanged();
					checkYDirectionChanged();

					if (!_sprayCanTweenHelper.swaying) {
						var dist : Number = Math.abs(_canvas.mouseX - _lastMousePos.x);
						if (dist > 20) {
							_sprayCanTweenHelper.move(_lastMousePos.x < _canvas.mouseX ? 1 : -1, dist, _canvas.isSpraying);
						}
					}
				}
				_lastMousePos = new Point(_canvas.mouseX, _canvas.mouseY);
			}
			
			event.stopPropagation();
		}
		
		// usingSprayCap
		public function set usingTool (usingTool_ : String) : void {
			_usingTool = usingTool_;
			
			_sprayCan.visible = false;
			_brush.visible = false;
			_roller.visible = false; 
			deactivateRollerKeyListeners();
			
			switch(_usingTool){
				case ToolPaletteEvent.SPRAY_MODE:
					_sprayCan.visible = true;
					break;
				case ToolPaletteEvent.PEN_MODE:
					_brush.visible  = true;
					break;
				case ToolPaletteEvent.ROLLER_MODE:
					_roller.visible = true;
					activateRollerKeyListeners();
					break;		
				default:
			}
		}

		private function setCircleVisibility(event : MouseEvent) : void {
			_mouseJustReleasedOutside &&= event.type != MouseEvent.MOUSE_OVER;
			if (!_mouseJustReleasedOutside && !_grabModeActive) active = event.type == MouseEvent.MOUSE_OVER;
			_mouseJustReleasedOutside = false;
		}

		public function enterSprayMode() : void {			
			_sprayCan.visible = false;
			_brush.visible = false;
			_roller.visible = false;
			_sprayCanCircle.visible = false;
			_cross.visible = true;
			resetFriction();
			deactivateRollerKeyListeners();
		}

		public function leaveSprayMode(mouseOutside : Boolean) : void {
			_mouseJustReleasedOutside = mouseOutside;
			if (!_mouseJustReleasedOutside) {
				_cross.visible = false;
				_sprayCanCircle.visible = true;
				usingTool = _usingTool; 
			}
			if (_usingTool == ToolPaletteEvent.ROLLER_MODE){
				activateRollerKeyListeners();
			}
		}

		private function set active(_active : Boolean) : void {
//			Debug.trace('MouseManager::active:_active '+_active+' _canvas.isSpraying '+_canvas.isSpraying+' _cross.visible '+_cross.visible);
			_toolHolder.visible = _active;
			if (_toolHolder.visible) {
				_toolHolder.x = _canvas.mouseX;
				// mouse
				_toolHolder.y = _canvas.mouseY;
				// mouse
				_lastMousePos = new Point(_canvas.mouseX, _canvas.mouseY);
				Mouse.hide();
				if (!_canvas.isSpraying){
					leaveSprayMode(false);
				} else {
					_cross.visible = true;
					_sprayCanCircle.visible = false;
				}
				_canvas.parent.addEventListener(Event.ENTER_FRAME, setCirclePosition);
			} else {
				Mouse.show();
				_canvas.parent.removeEventListener(Event.ENTER_FRAME, setCirclePosition);
			}
		}

		public function drawSprayCanCircle(dotDiameter : Number, dotColor : uint, dotDistance : Number) : void {
			_canvas.canvasDrawer.clearContainer(_sprayCanCircle);
			if (_canvas.settings.usingSpray) {
				_sprayCanCircle.addChild(_canvas.canvasDrawer.drawSprayedDot(true));
				resizeSprayCan(dotDistance);
			} 
			_sprayCanCircle.width = _sprayCanCircle.height = dotDiameter;
			colorateColorSpenders(dotColor);
		}

		public function colorateColorSpenders(dotColor : uint) : void {
			var colorTransform : ColorTransform = new ColorTransform();
			colorTransform.color = dotColor;
			_brushTip.transform.colorTransform = colorTransform;
			_rollerSleeze.transform.colorTransform = colorTransform;
		}

		public function get mouseX() : Number {
			if (!_drawingStraightYAxis) _frictionX += (_canvas.mouseX - _frictionX) * FRICTION;
			return _frictionX;
		}

		public function get mouseY() : Number {
			if (!_drawingStraightXAxis) _frictionY += (_canvas.mouseY - _frictionY) * FRICTION;
			return _frictionY;
		}

		public function resetFriction() : void {
			_frictionX = _canvas.mouseX;
			_frictionY = _canvas.mouseY;
		}

		public function get timeStamp() : Number {
			return new Date().getTime();
		}

		public function set grabModeActive(_active : Boolean) : void {
			_grabModeActive = _active;
			active = !_grabModeActive;
			Mouse.cursor = _grabModeActive ? MouseCursor.HAND : MouseCursor.AUTO;
		}
		
		public function set previewModeActive(_active : Boolean) : void {
			active = !_active;
		}
		
		public function deactivate() : void {
			active = false;
		}

		public function get drawingStraight() : Boolean {
			return _drawingStraightXAxis || _drawingStraightYAxis;
		}

		public function fixateY() : void {
			_drawingStraightXAxis = true;
			_frictionY = _canvas.mouseY;
		}

		public function fixateX() : void {
			_drawingStraightYAxis = true;
			_frictionX = _canvas.mouseX;
		}

		public function set drawingStraight(drawingStraight : Boolean) : void {
			_drawingStraightXAxis = drawingStraight;
			_drawingStraightYAxis = drawingStraight;
		}
		
		public function set rollerRotation(radian : Number) : void {
			_roller.rotation = (radian / Math.PI) * 180;
		}
		
		public function set rollerScale(scale : Number) : void {
			_roller.scaleX = _roller.scaleY = ROLLER_SCALE * scale;
		}
		
		public function get rollerRotation() : Number {
			return _roller.rotation / 180 * Math.PI;
		}
	}
}
