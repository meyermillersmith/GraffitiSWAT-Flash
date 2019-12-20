package com.lessrain.project.view.components.toolpalette {
	import flash.display.BitmapData;
	import flash.display.Bitmap;
	import com.lessrain.project.view.components.palette.ToolTip;
	import com.greensock.TweenLite;
	import com.greensock.easing.Sine;
	import com.lessrain.debug.Debug;
	import com.lessrain.project.ApplicationFacade;
	import com.lessrain.project.model.vo.ColorData;
	import com.lessrain.project.model.vo.ToolData;
	import com.lessrain.project.view.components.ItemBuyEvent;
	import com.lessrain.project.view.utils.AssetButton;
	import com.lessrain.project.view.utils.Fader;
	import com.lessrain.project.view.utils.RoundAssetButton;
	import com.lessrain.project.view.utils.RoundToggleButton;
	import com.lessrain.project.view.utils.SimpleTextfield;

	import flash.display.GradientType;
	import flash.display.Shape;
	import flash.display.Sprite;
	import flash.events.Event;
	import flash.events.MouseEvent;
	import flash.filters.DropShadowFilter;
	import flash.geom.Point;


	/**
	 * @author lessintern
	 */
	public class ToolPalette extends Sprite {

		public static const DISTANCE_CHANGED : String = "distance_changed";
		private static const MARGIN : Number = 10;
		private static const CONTENT_Y : Number = 30;
		
		private static const CAP_S : Number = 0;
		private static const CAP_ADD_M : Number = 20;
		private static const CAP_ADD_L : Number = 60;
		private static const PEN_S : Number = 0;//-4;
		private static const PEN_ADD_M : Number = 8;//4;
		private static const PEN_ADD_L : Number = 16;//12;
		private static const ROLLER_S : Number = -45;
		private static const ROLLER_ADD_M : Number = 0;
		private static const ROLLER_ADD_L : Number = 45;
		//private static const ROLLER_ADD_S : Number = 200;		
		
//		private var _dragRect : Rectangle;
		private var _title : SimpleTextfield;
		private var _topBar : Sprite;
		private var _toolsHolder : Sprite;
		private var _toolsHolderBG : Sprite;
		private var _levels : Vector.<Sprite>;
		private var _toolToOpen : ToolData;
		private var _distanceControlHolder : Sprite;
//		private var _bottomBar : Sprite;
		private var _distanceControl : DistanceControl;
		private var _lowerPart : Sprite;
		private var _lowerPartY : Number;
		private var _content : Sprite;
		private var _theMask : Sprite;
		private var _closeBtn : RoundAssetButton;
		private var _closed : Boolean;
		private var _active : Boolean;
		private var _dragStartPos : Point;
		private var _allToolButtons : Vector.<ToolButton>;
		private var _disselectedActiveButtons : Vector.<ToolButton>;
		private var _tootTip : ToolTip;

		public function ToolPalette() {
			_levels = new Vector.<Sprite>();
			_allToolButtons = new Vector.<ToolButton>();
			_disselectedActiveButtons = new Vector.<ToolButton>();
			visible = false;
		}

		public function initialize() : void {
			
			_topBar = addChild(new Sprite()) as Sprite;
			_topBar.addEventListener(MouseEvent.CLICK, checkClose);

			_topBar.graphics.beginGradientFill(GradientType.LINEAR, [0x444444, 0x111111], [1, 1], [0, 255]);
			_topBar.graphics.drawRoundRect(0, 0, 230, 60, 40);
			_topBar.graphics.endFill();
			var topBarBG:BitmapData = new BitmapData(_topBar.width, _topBar.height / 2,true,0x00000000);
			topBarBG.draw(_topBar);
			_topBar.graphics.clear();
			_topBar.addChild(new Bitmap(topBarBG));
			
			

			_title = _topBar.addChild(new SimpleTextfield(ApplicationFacade.getCopy('design.palette'), '.toolPaletteTitle')) as SimpleTextfield;
			_title.x = 10;
			_title.y = (_topBar.height- _title.height) / 2 + 2;
			
			_closeBtn = _topBar.addChild(new RoundToggleButton('PaletteClose','PaletteArrow')) as RoundToggleButton;
			_closeBtn.addEventListener(AssetButton.CLICK, onClose);
			_closeBtn.x = _topBar.width - MARGIN - _closeBtn.width;
			_closeBtn.y = (_topBar.height - _closeBtn.height)/2;
			
			_content = addChild(new Sprite()) as Sprite;
			_content.y = CONTENT_Y;
			
			_lowerPart = _content.addChild(new Sprite()) as Sprite;

			_toolsHolder = _content.addChild(new Sprite()) as Sprite;

			_toolsHolderBG = _toolsHolder.addChild(new Sprite()) as Sprite;

			_toolsHolderBG.graphics.beginFill(0xFFFFFF, 1);
			_toolsHolderBG.graphics.drawRect(0, 0, 230, 170);
			_toolsHolderBG.graphics.endFill();
			
			_lowerPartY = _toolsHolder.height;
			_lowerPart.y = _lowerPartY;
			
//			_bottomBar = _lowerPart.addChild(new Sprite()) as Sprite;
//			_bottomBar.graphics.beginFill(0xFFFFFF, 1);
//			_bottomBar.graphics.drawRoundRect(0, 0, 230, 60, 40);
//			_bottomBar.graphics.endFill();
			
			_distanceControlHolder = _lowerPart.addChild(new Sprite()) as Sprite;
			
			_distanceControlHolder.graphics.beginGradientFill(GradientType.LINEAR, [0x444444, 0x111111], [1, 1], [0, 255]);
			_distanceControlHolder.graphics.drawRect(0, 0, 230, 50);
			_distanceControlHolder.graphics.endFill();
			
			_distanceControl = _distanceControlHolder.addChild(new DistanceControl()) as DistanceControl;
			_distanceControl.y = (_distanceControlHolder.height - _distanceControl.height) / 2;
			_distanceControl.x = (_distanceControlHolder.width - _distanceControl.width) / 2;
			_distanceControl.addEventListener(DistanceControl.DISTANCE_CHANGED, onDistanceChanged);
			
//			_bottomBar.y = _distanceControlHolder.height - 35;
			
			_theMask = addChild(new Sprite()) as Sprite;
			_theMask.graphics.beginFill(0xFF0000,1);
			_theMask.graphics.drawRect(0, CONTENT_Y, width, height);
			_theMask.graphics.endFill();
			
			_content.mask =_theMask;

			_topBar.addEventListener(MouseEvent.MOUSE_DOWN, startDragging);
			_toolsHolderBG.addEventListener(MouseEvent.MOUSE_DOWN, startDragging);

			x = y = MARGIN;
			
			filters = [new DropShadowFilter(6,45,0,1,21,21,.62)];
			stage.addEventListener(Event.RESIZE, onStageResize);
		}

		private function onStageResize(event : Event) : void {
		}

		private function checkClose(event : Event) : void {
			if (Math.abs(_dragStartPos.x - x) < 5 && Math.abs(_dragStartPos.y - y) < 5){
				onClose(event);
			}
		}
		private function onClose(event : Event) : void {
			if (event is MouseEvent) _closeBtn.toggled = !_closed;
			TweenLite.killTweensOf(_content);
			TweenLite.to(_content, .6, {y:_closed?CONTENT_Y:CONTENT_Y-_content.height,ease:Sine.easeOut,onComplete:onPaletteExpandDone});
			hideTip();
		}

		private function onPaletteExpandDone() : void {
			_closed = _content.y != CONTENT_Y;
		}

		public function setTools(data : Vector.<ToolData>) : void {
			drawTools(data, 0);
			drawLine();
		}

		private function drawLine() : void {
			var line:Shape = _toolsHolder.addChild(new Shape()) as Shape;
			line.y = _levels[0].height + 5;
			line.graphics.beginFill(0x99918f,1);
			line.graphics.drawRect(0, 0, _toolsHolder.width, 2);
			line.graphics.endFill();
			line.graphics.beginFill(0x99918f,.5);
			line.graphics.drawRect(0, 2, _toolsHolder.width, 5);
			line.graphics.endFill();
		}

		private function drawTools(data : Vector.<ToolData>, level : int) : void {
			if (_levels.length < level + 1) {
				_levels[level] = _toolsHolder.addChild(new Sprite()) as Sprite;
				_levels[level].x = 5;
				_levels[level].y = level == 0 ? 10 : _levels[level - 1].y + _levels[level - 1].height + 10;
			}
			var levelSprite : Sprite = _levels[level];
			var xPos : Number = 0;
			for (var i : int = 0; i < data.length; i++) {
				var toolData : ToolData = data[i];
				var toolButton : ToolButton = levelSprite.addChild(new ToolButton(toolData)) as ToolButton;
				toolButton.addEventListener(AssetButton.CLICK, onToolButtonClick);
				toolButton.addEventListener(ItemBuyEvent.BUY, onBuyTool);
				toolButton.x = xPos;
				_allToolButtons.push(toolButton);
				if (level == 0 && (toolData.hasSubTools)){
					var arrow:PaletteItemArrowButton = _toolsHolder.addChild(new PaletteItemArrowButton(1,10,0x99918f,toolButton)) as PaletteItemArrowButton;
					arrow.x = levelSprite.x + toolButton.x + ToolButton.CIRCLE_WIDTH - arrow.width;
					arrow.y = levelSprite.y + ToolButton.CIRCLE_WIDTH  - arrow.height;
					toolButton.arrowButton = arrow;
				}				
				xPos += ToolButton.CIRCLE_WIDTH + 5;
				if (i == 0) {
					selectTool(toolButton, false);
				}
			}
		}

		private function onBuyTool(event : ItemBuyEvent) : void {
			dispatchEvent(event);
		}

		private function selectTool(toolButton : ToolButton, onClick : Boolean) : void {
			var toolData : ToolData = toolButton.toolData;
			if (_tootTip && !_tootTip.toolButton.toolData.contains(toolButton.toolData)){
				hideTip();
			}
			trace (this, toolButton, "toolData.hasSubTools", toolData.hasSubTools);
			if (toolData.hasSubTools) {
				if (onClick) {
					replaceTools(toolData);
				} else {
					drawTools(toolData.subtools, toolData.level + 1);
				}
			} else {
				onToolChosen(toolData);
			}			
			
			disselectAllOthers(toolData.level , toolButton);
			
			toolButton.toggled = true;
		}
		
		private function disselectAllOthers(level : int, toolButton:ToolButton = null):void{
			var levelSprite : Sprite = _levels[level];
			for (var i : int = 0; i < levelSprite.numChildren; i++) {
				var currentButton:ToolButton = levelSprite.getChildAt(i) as ToolButton;
				if (toolButton == null){
					if (currentButton.toggled) _disselectedActiveButtons.push(currentButton);
				} else {
					var disselectedButtonIndex:int = _disselectedActiveButtons.indexOf(currentButton);
					if (disselectedButtonIndex > -1) _disselectedActiveButtons.splice(disselectedButtonIndex, 1);
				}
				if (!currentButton.toolData.locked) currentButton.toggled = currentButton == toolButton;
				
			}
		}

		private function removeSameLevelFromDisslected(toolButton:ToolButton) : void {
			
		}

		private function disselectAllButtons() : void {
			_disselectedActiveButtons = new Vector.<ToolButton>();
			for (var i : int = 0; i < _levels.length; i++) {
				disselectAllOthers(i);
			}
		}


		private function onToolButtonClick(event : Event) : void {
			selectTool(ToolButton(event.target), true);
		}

		private function onToolChosen(toolData : ToolData) : void {
			if (toolData.parent) {
				var childIndex : int = int(toolData.key.substr(toolData.key.length -1));
				switch(toolData.parent.key) {
					case "sprayCan":
						switch(childIndex) {
							case 0:
								dispatchEvent(new ToolPaletteEvent(ToolPaletteEvent.CHANGED, ToolPaletteEvent.SPRAY_MODE, CAP_S));
								break;
							case 1:
								dispatchEvent(new ToolPaletteEvent(ToolPaletteEvent.CHANGED, ToolPaletteEvent.SPRAY_MODE, CAP_ADD_M));
								break;
							case 2:
								dispatchEvent(new ToolPaletteEvent(ToolPaletteEvent.CHANGED, ToolPaletteEvent.SPRAY_MODE, CAP_ADD_L));
								break;
						}
						expandDistanceControl(true);
						break;
					case "pen":
						switch(childIndex) {
							case 0:
								dispatchEvent(new ToolPaletteEvent(ToolPaletteEvent.CHANGED, ToolPaletteEvent.PEN_MODE, PEN_S));
								break;
							case 1:
								dispatchEvent(new ToolPaletteEvent(ToolPaletteEvent.CHANGED, ToolPaletteEvent.PEN_MODE, PEN_ADD_M));
								break;
							case 2:
								dispatchEvent(new ToolPaletteEvent(ToolPaletteEvent.CHANGED, ToolPaletteEvent.PEN_MODE, PEN_ADD_L));
								break;
						}
						expandDistanceControl(false);
						break;
					case "roller":
						switch(childIndex) {
							case 0:
								trace('ToolPalette::onToolChosen:ROLLER_MODE ROLLER_S '+ROLLER_S);
								dispatchEvent(new ToolPaletteEvent(ToolPaletteEvent.CHANGED, ToolPaletteEvent.ROLLER_MODE, ROLLER_S, childIndex));
								break;
							case 1:
								trace('ToolPalette::onToolChosen:ROLLER_MODE ROLLER_ADD_M '+ROLLER_ADD_M);
								dispatchEvent(new ToolPaletteEvent(ToolPaletteEvent.CHANGED, ToolPaletteEvent.ROLLER_MODE, ROLLER_ADD_M, childIndex));
								break;
							case 2:
								trace('ToolPalette::onToolChosen:ROLLER_MODE ROLLER_ADD_L '+ROLLER_ADD_L);
								dispatchEvent(new ToolPaletteEvent(ToolPaletteEvent.CHANGED, ToolPaletteEvent.ROLLER_MODE, ROLLER_ADD_L, childIndex));
								break;
						}
						expandDistanceControl(false);
						break;	
				}
			}
		}

		private function replaceTools(toolData : ToolData) : void {
			_toolToOpen = toolData;
			Fader.fadeOut(_levels[toolData.level + 1], onOldToolsFaded);
		}

		private function onOldToolsFaded() : void {
			while (_levels[_toolToOpen.level + 1].numChildren > 0) {
				_levels[_toolToOpen.level + 1].removeChildAt(0);
			}
			drawTools(_toolToOpen.subtools, _toolToOpen.level + 1);
			Fader.fadeIn(_levels[_toolToOpen.level + 1]);
		}

		private function startDragging(event : MouseEvent) : void {
			stage.addEventListener(MouseEvent.MOUSE_UP, stopDragging);
			_dragStartPos = new Point(x,y);
			startDrag();
			hideTip();
		}

		private function stopDragging(event : MouseEvent) : void {
			stage.removeEventListener(MouseEvent.MOUSE_UP, stopDragging);
			var stopPos:Point = localToGlobal(new Point(0,0));
			if (stopPos.x > (stage.stageWidth - width)){
				stopPos.x = (stage.stageWidth - width);
				x = parent.globalToLocal(stopPos).x;
			} else if (stopPos.x < 0){
				stopPos.x = 0;
				x = parent.globalToLocal(stopPos).x;
			}
			if (stopPos.y > (stage.stageHeight - height)){
				stopPos.y = (stage.stageHeight - height);
				y = parent.globalToLocal(stopPos).y;
			} else if (stopPos.y < 0){
				stopPos.y = 0;
				y = parent.globalToLocal(stopPos).y;
			}
			stopDrag();
		}
		
		/**
		 * DISTANCE CONTROL
		 */

		private function onDistanceChanged(event : Event) : void {
			dispatchEvent(new Event(DISTANCE_CHANGED));
//			_canvas.dotDistance = _distanceControl.distance;
		} 
		
		public function get _distanceControlsDist() : Number {
			return _distanceControl.distance;
		}

		public function displayCurrentColor(color : ColorData) : void {
			_distanceControl.setColor(color.color);
		}
		
		private function expandDistanceControl(expand : Boolean) : void {
			TweenLite.killTweensOf(_lowerPart);
			TweenLite.to(_lowerPart, .4, {y : expand ? _lowerPartY : _lowerPartY - _distanceControlHolder.height, ease : Sine.easeOut});
		}

		public function get active() : Boolean {
			return visible;
		}

		public function set active(active_ : Boolean) : void {
			visible = active_;
			listenersActive  = active_;
		}

		public function set listenersActive(active_ : Boolean) : void {
			if (active_){
				_distanceControl.activateStageListener();
			} else {
				_distanceControl.deactivateStageListener();
			}
		}

		public function setInactiveLook(isInactive_ : Boolean) : void {
			if (isInactive_){
				disselectAllButtons();
			} else {
				for each (var disselectedButton : ToolButton in _disselectedActiveButtons) {
					disselectedButton.toggled = true;
				}
			}
			listenersActive  = !isInactive_;
		}

		public function onItemBought(item : ToolData) : void {
			for each (var toolButton : ToolButton in _allToolButtons) {
				if (toolButton.toolData == item){
					toolButton.update();
					selectTool(toolButton,true);
					showTip(toolButton);
					return;
				}
			}
		}

		private function showTip(toolButton : ToolButton) : void {
			if (_tootTip) _tootTip.destroy();
			_tootTip = new ToolTip(toolButton);
			_tootTip.addEventListener(ToolTip.CLOSED, hideTip);
		}

		private function hideTip(event:Event = null) : void {
			Debug.trace('ToolPalette::hideTip:event '+event);
			if (_tootTip) _tootTip.destroy();
			_tootTip = null;
		}
		
		
	}
}
