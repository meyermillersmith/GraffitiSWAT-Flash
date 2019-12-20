package com.lessrain.project.view.components.surfaces {
	import com.greensock.TweenLite;
	import com.greensock.easing.Sine;
	import com.lessrain.data.Size;
	import com.lessrain.debug.Debug;
	import com.lessrain.project.ApplicationFacade;
	import com.lessrain.project.model.vo.SurfaceData;
	import com.lessrain.project.view.utils.AssetButton;
	import com.lessrain.project.view.utils.SimpleTextButton;

	import flash.display.Bitmap;
	import flash.display.Sprite;
	import flash.events.Event;

	/**
	 * @author lessintern
	 */
	public class ChooseSurfaceView extends Sprite {

		public static const ALL_THUMBS_LOADED : String = "ALL_THUMBS_LOADED";
		public static const GO_TO_ARCHIVE : String = "GO_TO_ARCHIVE";
		
		private static const MARGIN : int = 10;
		private static const BUTTON_DIST_Y : int = 160;
		private static const MAX_COLS : int = 4;
		private static const MAX_ROWS : int = 3;
		private static const MAX_WIDTH : int = MAX_COLS * SurfaceButton.SIZE + (MAX_COLS-1)*MARGIN;
		private static const MAX_HEIGHT : int = MAX_ROWS*BUTTON_DIST_Y;
		
		private var _surfaceButtons : Vector.<SurfaceButton>;
		private var _surfaceDatas : Vector.<SurfaceData>;
		private var _loadedThumbNailCount : int;
		private var _logo : Bitmap;
		private var _background : Bitmap;
		private var _backgroundSize : Size;
		private var _leftArrow : SurfaceViewArrow;
		private var _rightArrow : SurfaceViewArrow;
		private var _preview : SurfacePreview;
		private var _surfaceButtonContainers : Vector.<Sprite>;
		private var _currentContainerIndex : int = 0;
		private var _containerMaxSize : Size;
		private var _nextContainerIndex : int;
		private var _surfaceButtonHolder : Sprite;
		private var _archiveBtn : SimpleTextButton;
		private var _content : Sprite;
		

		public function ChooseSurfaceView() {
		}

		public function initialize() : void {
			_background = addChild(ApplicationFacade.getSWFAssetInstance('BackgroundHome')) as Bitmap;
			_backgroundSize = new Size(_background.width,_background.height);
			_content = addChild(new Sprite()) as Sprite;

			_logo = _content.addChild(ApplicationFacade.getSWFAssetInstance('Logo')) as Bitmap;
			_logo.y = -25;
			_logo.x = MAX_WIDTH + 145;

			_preview = _content.addChild(new SurfacePreview()) as SurfacePreview;
			_preview.y = MARGIN + BUTTON_DIST_Y + SurfaceButton.SIZE / 2;
			_preview.x = MAX_WIDTH + 35;

			_archiveBtn = new SimpleTextButton('> archive', '.button', 1, -1, 25);
			_archiveBtn.addEventListener(SimpleTextButton.CLICK, goToArchives);
			_archiveBtn.y = _logo.y + _logo.height + 10;
			_archiveBtn.x = _logo.x + 100;

			rearrange();
			stage.addEventListener(Event.RESIZE, onStageResize);
		}

		private function goToArchives(event : Event) : void {
			dispatchEvent(new Event(GO_TO_ARCHIVE));
		}

		private function onStageResize(event : Event) : void {
			rearrange();
		}

		private function rearrange() : void {
			_content.x = stage.stageWidth > getContentVisibleWidth()? (stage.stageWidth - getContentVisibleWidth()) / 2 : 0;
			_content.y = stage.stageHeight > _content.height - 5? (stage.stageHeight - _content.height - 5) / 2 : 0;
			var BGScaleX:Number = stage.stageWidth / _backgroundSize.w;
			var BGScaleY:Number = stage.stageHeight / _backgroundSize.h;
			var BGScale:Number = Math.max(BGScaleX,BGScaleY);
			_background.scaleX = _background.scaleY = BGScale < 1? 1 : BGScale;
			_background.x =stage.stageWidth - _background.width;
			_background.y =(stage.stageHeight - _background.height) / 2;
		}

		private function getContentVisibleWidth() : Number {
			return _logo.x + _logo.width;
		}


		public function setSurfaces(data : Vector.<SurfaceData>) : void {
			_surfaceDatas = data;
			_surfaceButtons = new Vector.<SurfaceButton>();
			_surfaceButtonContainers = new Vector.<Sprite>();
			_loadedThumbNailCount = 0;

			var yPos : Number = MARGIN;
			var xPos : Number = MARGIN;
			var itemsOnLine : int = 0;
			var maxItemsPerPage : int = 12;
			var maxItems : int = maxItemsPerPage;

			if (_surfaceDatas.length > 12) {
				_leftArrow = _content.addChild(new SurfaceViewArrow(SurfaceViewArrow.LEFT)) as SurfaceViewArrow;
				_leftArrow.addEventListener(AssetButton.CLICK, showMoreItemsLeft);
				_leftArrow.x = _leftArrow.y = MARGIN;
				_leftArrow.enabled = false;

				_rightArrow = _content.addChild(new SurfaceViewArrow(SurfaceViewArrow.RIGHT)) as SurfaceViewArrow;
				_rightArrow.addEventListener(AssetButton.CLICK, showMoreItemsRight);
				_rightArrow.x = SurfaceButton.SIZE * (MAX_COLS - 1) + MARGIN * MAX_COLS;
				_rightArrow.y = MARGIN + (MAX_ROWS - 1) * BUTTON_DIST_Y;

				xPos += _leftArrow.x + SurfaceButton.SIZE;
				itemsOnLine += 1;
				
				maxItemsPerPage = 10;
				var numPages:int = Math.ceil(_surfaceDatas.length / maxItemsPerPage);
				maxItems = numPages * maxItemsPerPage;
			}
			var initXPos:Number = xPos;
			var initYPos:Number = yPos;
			
			_surfaceButtonHolder = _content.addChild(new Sprite()) as Sprite;
			
			var currentContainer:Sprite = _surfaceButtonHolder.addChild(new Sprite()) as Sprite;
			_surfaceButtonContainers.push(currentContainer);

			for (var i : int = 0; i < maxItems; i++) {
				var surface : SurfaceData = i < _surfaceDatas.length ? _surfaceDatas[i] : null;
				var surfaceButton : SurfaceButton = currentContainer.addChild(new SurfaceButton(surface)) as SurfaceButton;
				surfaceButton.addEventListener(SurfaceButton.THUMBNAIL_LOADED, onThumbNailLoaded);
				surfaceButton.addEventListener(SurfaceEvent.CLICK, onSurfaceButtonClick);
				surfaceButton.addEventListener(SurfaceEvent.BUY, onSurfaceBuy);
				surfaceButton.addEventListener(SurfaceButton.ROLL_OVER, _preview.showThumb);
				surfaceButton.addEventListener(SurfaceButton.ROLL_OUT, _preview.hideThumb);
				_surfaceButtons.push(surfaceButton);

				surfaceButton.y = yPos;
				surfaceButton.x = xPos;
				xPos += SurfaceButton.SIZE + MARGIN;
				itemsOnLine++;
				if (itemsOnLine == MAX_COLS) {
					xPos = MARGIN;
					yPos += BUTTON_DIST_Y;
					itemsOnLine = 0;
				}				
				if ((i+1)%(maxItemsPerPage) == 0 && i!= maxItems-1){
					if (_surfaceButtonContainers.length == 1){
						_containerMaxSize = new Size(MAX_WIDTH+MARGIN,MAX_HEIGHT);
						var surfaceButtonMask:Sprite = _content.addChild(new Sprite()) as Sprite;
						surfaceButtonMask.graphics.beginFill(0xFF0000,.5);
						surfaceButtonMask.graphics.drawRect(0, 0, _containerMaxSize.w, _containerMaxSize.h);
						surfaceButtonMask.graphics.endFill();
						_surfaceButtonHolder.mask = surfaceButtonMask;
					}
					currentContainer = _surfaceButtonHolder.addChild(new Sprite()) as Sprite;
					currentContainer.visible = false;
					_surfaceButtonContainers.push(currentContainer);
					xPos = initXPos;
					yPos = initYPos;
					itemsOnLine = 1;
				}
			}
			rearrange();
			if (_surfaceDatas.length > 0 &&  _surfaceDatas.length < 2) _surfaceButtons[0].dispatchEvent(new SurfaceEvent(SurfaceEvent.CLICK, _surfaceButtons[0].surfaceData));
		}

		private function showMoreItemsLeft(event : Event) : void {
			showMoreItems(-1);
		}

		private function showMoreItemsRight(event : Event) : void {
			showMoreItems(1);
		}

		private function showMoreItems(direction:int) : void {
			_nextContainerIndex = _currentContainerIndex + direction;
			var nextContainer:Sprite = _nextContainerIndex > -1 && _nextContainerIndex < _surfaceButtonContainers.length? _surfaceButtonContainers[_nextContainerIndex] : null;
			if (nextContainer){
				nextContainer.x = direction*_containerMaxSize.w;
				nextContainer.visible = true;
				var currentContainer:Sprite = _surfaceButtonContainers[_currentContainerIndex];
				
				_surfaceButtonHolder.mouseChildren = false;
				
				TweenLite.killTweensOf(nextContainer);
				TweenLite.killTweensOf(currentContainer);
				TweenLite.to(currentContainer, .4, {x:-direction*_containerMaxSize.w, ease:Sine.easeOut});
				TweenLite.to(nextContainer, .4, {x:0, ease:Sine.easeOut, onComplete:replaceCurrentContainer});
			}
		}

		private function replaceCurrentContainer() : void {
			_surfaceButtonContainers[_currentContainerIndex].visible = false;
			_currentContainerIndex = _nextContainerIndex;
			_leftArrow.enabled = _currentContainerIndex > 0;
			_rightArrow.enabled = _currentContainerIndex < _surfaceButtonContainers.length - 1;
				
			_surfaceButtonHolder.mouseChildren = true;
		}


		private function onThumbNailLoaded(event : Event) : void {
			_loadedThumbNailCount++;
			if (_loadedThumbNailCount == _surfaceDatas.length) {
				if (visible) dispatchEvent(new Event(ALL_THUMBS_LOADED));
			}
		}

		private function onSurfaceButtonClick(event : SurfaceEvent) : void {
			dispatchEvent(event.clone());
		}

		private function onSurfaceBuy(event : SurfaceEvent) : void {
			dispatchEvent(event.clone());
		}

		public function onSurfaceBought(surface : SurfaceData) : void {
			for each (var surfaceButton : SurfaceButton in _surfaceButtons) {
				if (surfaceButton.surfaceData == surface) surfaceButton.bought = true;
			}
		}
	}
}
