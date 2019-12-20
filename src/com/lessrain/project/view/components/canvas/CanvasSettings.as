package com.lessrain.project.view.components.canvas {
	import com.lessrain.project.model.vo.ColorData;
	import com.lessrain.project.view.components.canvas.mouse.MouseManager;
	import com.lessrain.project.view.components.toolpalette.ToolPaletteEvent;

	/**
	 * @author lessintern
	 */
	public class CanvasSettings {

		public static const TOLERATED_DISTANCE : int = 5;
		public static const DIAMETER_MIN : int = 10;
		private static const PEN_DIAMETER_MIN : int = 6;
		private static const ROLLER_DIAMETER_MIN : int = 70;
		private static const DOT_TIME_DISTANCE_MAX : int = 2;
		private static const DOT_TIME_DISTANCE_MIN : int = 2;
		private static const DOT_TIME_DISTANCE_DIFF : int = DOT_TIME_DISTANCE_MAX - DOT_TIME_DISTANCE_MIN;
		private static const DIAMETER_MAX : int = 120;
		private static const DIAMETER_DIFF : Number = DIAMETER_MAX - DIAMETER_MIN;
		private static const ALPHA_MIN : Number = .4;
		private static const ALPHA_MAX : Number = 1;
		private static const ALPHA_DIFF : Number = ALPHA_MAX - ALPHA_MIN;
		public static const MIN_ALPHA_MULTIPLIER : Number = .5;
		private static const MAX_DISTANCE_MULTIPLIER : Number = 5;
		private static const PEN_TOLERATED_DIST_DIV : Number = 7;
		private static const ROLLER_TOLERATED_DIST_DIV : Number = 6;
		public static const ROLLER_APHA : Number = .9;
		private var _dotDiameter : Number = DIAMETER_MIN;
		private var _dotCenterAlpha : Number;
		private var _dotColor : ColorData;
		private var _dotMultiplier : Number = 1;
		private var _diameterMin : Number = DIAMETER_MIN;
		private var _diameterMax : Number = DIAMETER_MAX;
		private var _dotDistance : Number = 0;
		private var _dotDiameterOffset : Number;
		private var _toleratedDistance : Number;
		private var _dotTimeDistance : int = 2;
		private var _dotMultiplierMaxDistance : Number = _diameterMin * MAX_DISTANCE_MULTIPLIER;
		private var _toolType : String = ToolPaletteEvent.SPRAY_MODE;
		private var _mouseManager : MouseManager;
		private var _rememberDistance : Number;
		private var _sizeIndex : Number;

		public function CanvasSettings() {
			_dotColor = new ColorData(0x0088BB00,'');
		}

		public function set dotDiameterOffset(dotDiameterOffset_ : Number) : void {
			trace('CanvasSettings::dotDiameterOffset:dotDiameterOffset_ '+dotDiameterOffset_);
			_dotDiameterOffset = dotDiameterOffset_;
			_diameterMin = getCurrentCapTypeMin() + dotDiameterOffset_;
			_diameterMax = usingSpray? DIAMETER_MAX + dotDiameterOffset_ : _diameterMin;
			dotDistance = usingSpray ? _dotDistance : 0;
			if (!usingSpray){
				applyDiameterStaticSize();
			}
		}

		private function getCurrentCapTypeMin() : int {
			switch(_toolType){
				case ToolPaletteEvent.SPRAY_MODE:
					return DIAMETER_MIN;
					break;
				case ToolPaletteEvent.PEN_MODE:
					return PEN_DIAMETER_MIN;
					break;
				case ToolPaletteEvent.ROLLER_MODE:
					return ROLLER_DIAMETER_MIN;
					break;
				default:
			}
			return 0;
		}


		public function set toolType(toolType_ : String) : void {
			trace (this, "toolType_",toolType_);
			if (_toolType != toolType_) {
				_toolType = toolType_;
				
				_mouseManager.usingTool = _toolType;
				
				switch(_toolType)
				{
					case ToolPaletteEvent.SPRAY_MODE:					
						_dotDistance = _rememberDistance;
						dotDiameterOffset = _dotDiameterOffset;					
						break;
					case ToolPaletteEvent.PEN_MODE:
						_rememberDistance = _dotDistance;
//						dotDistance = _dotDistance;					
						break;
					case ToolPaletteEvent.ROLLER_MODE:
						_rememberDistance = _dotDistance;
//						dotDistance = _dotDistance;					
						break;		
					default:
				}					
			}
		}

		public function set dotDistance(dotDistance_ : Number) : void {
			_dotDistance = dotDistance_;
			var oldDiameter : Number = _dotDiameter;
			if (usingSpray){
				_dotDiameter = DIAMETER_DIFF  * dotDistance_ + _diameterMin;
			} else {
				_dotDiameter = _diameterMin;
			}
			if (_dotDiameter != oldDiameter) applyDiameter();
		}

		private function applyDiameterStaticSize() : void {
			_dotDiameter = _diameterMin;
			_toleratedDistance = usingPen? _dotDiameter / PEN_TOLERATED_DIST_DIV : _dotDiameter / ROLLER_TOLERATED_DIST_DIV;
			_mouseManager.drawSprayCanCircle(_dotDiameter, _dotColor.color, _dotDistance);
			if (usingRoller){
				_dotCenterAlpha = ROLLER_APHA;
				_mouseManager.rollerScale = _dotDiameter / ROLLER_DIAMETER_MIN;
			}
		}

		private function applyDiameter() : void {
			_dotTimeDistance = (((_dotDiameter - _diameterMin) / DIAMETER_DIFF) * DOT_TIME_DISTANCE_DIFF) + DOT_TIME_DISTANCE_MIN;
			_dotCenterAlpha = (((DIAMETER_DIFF - (_dotDiameter - _diameterMin)) / DIAMETER_DIFF) * ALPHA_DIFF) + ALPHA_MIN;
			_toleratedDistance = _dotDiameter / 7;
			_dotMultiplierMaxDistance = _diameterMin * MAX_DISTANCE_MULTIPLIER;
			_mouseManager.drawSprayCanCircle(_dotDiameter, _dotColor.color, _dotDistance);
		}

		public function set dotColor(dotColor : ColorData) : void {
			_dotColor = dotColor;
		}

		public function get usingSpray() : Boolean {
			return _toolType == ToolPaletteEvent.SPRAY_MODE;
		}

		public function get usingRoller() : Boolean {
			return _toolType == ToolPaletteEvent.ROLLER_MODE;
		}

		public function get usingPen() : Boolean {
			return _toolType == ToolPaletteEvent.PEN_MODE;
		}

		public function get dotMultiplier() : Number {
			return _dotMultiplier;
		}

		public function get dotDiameter() : Number {
			return _dotDiameter;
		}

		public function get dotColor() : ColorData {
			return _dotColor;
		}

		public function get dotCenterAlpha() : Number {
			return _dotCenterAlpha;
		}

		public function get dotTimeDistance() : int {
			return _dotTimeDistance;
		}

		public function set dotMultiplier(dotMultiplier : Number) : void {
			_dotMultiplier = dotMultiplier;
		}

		public function get toleratedDistance() : Number {
			return _toleratedDistance;
		}

		public function get dotMultiplierMaxDistance() : Number {
			return _dotMultiplierMaxDistance;
		}

		public function set mouseManager(mouseManager : MouseManager) : void {
			_mouseManager = mouseManager;
		}

		public function get dotDistance() : Number {
			return _dotDistance;
		}

		public function get toolType() : String {
			return _toolType;
		}

		public function get dotDiameterOffset() : Number {
			return _dotDiameterOffset;
		}

		public function get sizeIndex() : Number {
			return _sizeIndex;
		}

		public function set sizeIndex(sizeIndex : Number) : void {
			_sizeIndex = sizeIndex;
		}
	}
}
