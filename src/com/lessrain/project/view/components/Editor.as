package com.lessrain.project.view.components {
	import flash.events.MouseEvent;
	import com.greensock.events.LoaderEvent;
	import com.greensock.loading.ImageLoader;
	import com.lessrain.data.Size;
	import com.lessrain.debug.Debug;
	import com.lessrain.project.ApplicationFacade;
	import com.lessrain.project.model.vo.PaletteData;
	import com.lessrain.project.model.vo.SurfaceData;
	import com.lessrain.project.view.components.canvas.Canvas;
	import com.lessrain.project.view.components.facebook.FacebookConnector;
	import com.lessrain.project.view.components.palette.ColorEvent;
	import com.lessrain.project.view.components.scrollbar.Scrollbar;
	import com.lessrain.project.view.components.toolpalette.ToolPaletteEvent;

	import flash.display.Bitmap;
	import flash.display.BitmapData;
	import flash.display.DisplayObjectContainer;
	import flash.display.Sprite;
	import flash.events.Event;
	import flash.geom.Matrix;
	import flash.geom.Point;
	import flash.geom.Rectangle;


	/**
	 * @author torstenhartel
	 */
	public class Editor extends Sprite {

		public static const READY : String = "READY";
		public static const SURFACE_NOT_AVAILABLE : String = "SURFACE_NOT_AVAILABLE";
		public static const GRAB_MODE_ON : String = 'grabModeOn';
		public static const GRAB_MODE_OFF : String = 'grabModeOff';
		public static const PREVIEW_MODE_OFF : String = 'previewModeOff';
		public static const PREVIEW_ENABLED : String = "previewEnabled";
		public static const GRAB_ENABLED : String = "grabEnabled";
		private static var IMAGES_TO_LOAD : int = 2;
		private var _surface : SurfaceData;
		private var _canvas : Canvas;
		private var _mainContent : Sprite;
		private var _firstImageLoaded : Boolean;
		private var _menuBar : MenuBar;
		private var _scrollBar : Scrollbar;
		private var _imagesLoaded : Number;
		private var _paletteData : Vector.<PaletteData>;
		private var _surfaceLoaders : Vector.<ImageLoader>;
		private var _canvasBG : DisplayObjectContainer;
		private var _canvasBgURL : String;
		private var _mouseContainer : Sprite;
		private var _background : Sprite;
		private var _imagePath : String;
		private var _tempCanvasHolder : Sprite;
		private var _mainContentClipRect : Rectangle;
		private var _canvasMask : Sprite;
		private var _collabCavas : String;
		private var _grabMode : Boolean;
		private var _previewMode : Boolean;
		private var _previewEnalbed : Boolean;
		private var _grabEnabled : Boolean;
		private var _mainContentBottomY : Number;
		private var _isTShirt : Boolean;
		private var _unknownUser : Boolean;

		public function Editor(unknownUser_ : Boolean) {
			_unknownUser = unknownUser_;
			_mainContentClipRect = new Rectangle();
		}

		public function setSurface(surface_ : SurfaceData = null, collabCavas_ : String = null) : void {
			_collabCavas = collabCavas_;
			if (_surface != surface_) {
				_isTShirt =  surface_.key == 'dudes';
				_surface = surface_;
				if (_mainContent) {
					exchangeSurface();
				} else {
					initialize();
					if (_paletteData) _menuBar.setColors(_paletteData);
				}
			} else {
				_scrollBar.updateBar();
				dispatchEvent(new Event(READY));
			}
			reactivateScrollListeners();
		}

		private function initialize() : void {
			_imagePath = ApplicationFacade.getProperty('surfacesPath');
			
			_background = addChild(new Sprite()) as Sprite;
			_background.graphics.beginFill(0x000000,1);
			_background.graphics.drawRect(0, 0, 200, 200);
			_background.graphics.endFill();	
			
			var menuBarBG:Sprite = addChild(ApplicationFacade.getSWFAssetInstance('PaletteBG')) as Sprite;
			
			drawCanvasWithBackground();
			
			_canvasMask = addChild(new Sprite()) as Sprite;
			
			_scrollBar = addChild(new Scrollbar(_mainContent, _canvasBG, _tempCanvasHolder)) as Scrollbar;
			_scrollBar.addEventListener(Scrollbar.REQUEST_GRAB_MODE_ON, onGrabModeChanged);
			
			_menuBar = addChild(new MenuBar(menuBarBG,_canvas, _isTShirt, _unknownUser)) as MenuBar;
			_menuBar.y = 327 + _scrollBar.height;
			_menuBar.visible = false;
			_menuBar.addEventListener(MenuBar.POST_TO_ALBUM, postImage);
			_menuBar.addEventListener(MenuBar.POST_TO_BEST_OF, postImage);
			_menuBar.addEventListener(MenuBar.POST_TO_FRIEND_WALL, postImage);
			_menuBar.addEventListener(MenuBar.DOWNLOAD, postImage);
			_menuBar.addEventListener(MenuBar.SEND_COLLAB, postImage);
			_menuBar.addEventListener(MenuBar.SAVE_FOR_LATER, postImage);
			_menuBar.addEventListener(MenuBar.POST_TO_COMPETITION, postImage);
			_menuBar.addEventListener(MenuBar.BACK_TO_CHOOSE, backToChooseSurface);
			_menuBar.addEventListener(ColorEvent.CLICK, dispatchCurrentColor);
			_menuBar.addEventListener(MouseEvent.CLICK, returnToEditMode);
			
			stage.addEventListener(Event.RESIZE, resize);
			stage.addEventListener(Event.FULLSCREEN, resize);
		}

		private function onGrabModeChanged(event : Event) : void {
			notifyGrabModeChange(event.type == Scrollbar.REQUEST_GRAB_MODE_ON);
		}

		private function notifyGrabModeChange(on:Boolean) : void {
			Debug.trace('Editor::notifyGrabModeChange:'+(on?'ON':'OFF'));
			if (_grabMode != on){
				dispatchEvent(new Event(on? GRAB_MODE_ON: GRAB_MODE_OFF));
			}
		}


		public function setGrabMode(on:Boolean) : void {
			if (on){
				if(!_canvas.isSpraying){
					_grabMode = true;
					notifyPreviewModeOff();
					_canvas.grabModeActive  = true;
					_scrollBar.addEventListener(Scrollbar.GRAB_MODE_OFF, onGrabModeChanged);
					_scrollBar.grabModeRequestGranted();
				} else {
					_grabMode = false;
					dispatchEvent(new Event(GRAB_MODE_OFF));
				}
			} else {
				_grabMode = false;
				_canvas.grabModeActive = false;
				_scrollBar.grabModeActive = false;
				_scrollBar.removeEventListener(Scrollbar.GRAB_MODE_OFF, onGrabModeChanged);
			}
		}

		private function notifyPreviewModeOff() : void {
			if (_previewMode) dispatchEvent(new Event(PREVIEW_MODE_OFF));
		}

		public function setPreviewMode(on:Boolean) : void {
				if (on){
					notifyGrabModeChange(false);
					on = getPreviewScale() < 1;
				}
				
				if (_previewMode != on){
					_previewMode = on;
					_mainContent.mouseEnabled = !on;
					_mainContent.mouseChildren = !on;
					_canvas.previewModeActive = on;
					repositionMainContent();
				}
		}
		
		private function getPreviewScale():Number{
			var fitXScale:Number = stage.stageWidth / _canvasBG.width;
			var fitYScale:Number = _mainContentBottomY / _canvasBG.height;
			var fitScale:Number = fitXScale < fitYScale ? fitXScale : fitYScale;;
			return fitScale > 1 ? 1 : fitScale;
		}

		public function returnToEditMode(event : Event = null):void{
			notifyGrabModeChange(false);
			notifyPreviewModeOff();
		}

		private function dispatchCurrentColor(event : ColorEvent) : void {
			dispatchEvent(event);
		}

		public function onCapChanged(event : ToolPaletteEvent) : void {
			if (_canvas && _canvas.ready){
				_canvas.sizeIndex = event.toolBrushIndex;
				_canvas.capType = event.toolType;
				_canvas.dotDiameterOffset = event.toolSize;
			}
		}

		public function onDistanceChanged(number : Number) : void {
			_canvas.dotDistance = number;
		}

		private function postImage(event : Event) : void {
			_scrollBar.active = false;
			_canvas.deactivateMouse();
			dispatchEvent(event);
		}

		private function backToChooseSurface(event : Event) : void {
			_scrollBar.active = false;
			dispatchEvent(event);
		}

		private function drawCanvasWithBackground() : void {
			
			_mainContent = addChild(new Sprite()) as Sprite;
			_mainContent.visible = false;
			
			_tempCanvasHolder = _mainContent.addChild(new Sprite()) as Sprite;

			_mouseContainer = addChild(new Sprite()) as Sprite;
			_mouseContainer.mouseEnabled = false;
			_mouseContainer.mouseChildren = false;
			
			_canvas = _mainContent.addChild(new Canvas(_mouseContainer, _background, _tempCanvasHolder)) as Canvas;
			_canvas.addEventListener(Canvas.SPRAYED, onSprayed);
			_canvas.addEventListener(Canvas.CLEAR, disabledSave);

			drawSurface();
		}

		private function drawSurface() : void {
			_imagesLoaded = 0;
			_surfaceLoaders = new Vector.<ImageLoader>();

			_canvasBgURL = _imagePath + _surface.key + '/background.jpg';
			_canvasBG = addLoadedImage(_canvasBgURL);

			addLoadedImage(_imagePath + _surface.key + '/cover.png');
			if (_collabCavas) addCollabCanvas();

			_mainContent.setChildIndex(_tempCanvasHolder, 2);
			_mainContent.setChildIndex(_canvas, 1);
		}

		private function exchangeSurface() : void {
			for each (var imageLoader : ImageLoader in _surfaceLoaders) {
				_mainContent.removeChild(imageLoader.content);
				imageLoader.dispose(true);
			}
			drawSurface();
		}

		private function addLoadedImage(url : String, addToCanvas:Boolean = false) : DisplayObjectContainer {
//			Debug.trace('Editor::addLoadedImage: ' + url);
			var _imageLoader : ImageLoader = new ImageLoader(url, {onComplete : onBackgroundImageLoaded, onError : onError});
			// TODO on error!
			var content:DisplayObjectContainer = _imageLoader.content;
			content.mouseChildren = false;
			content.mouseEnabled = false;
			(addToCanvas? _canvas : _mainContent).addChild(content);
			_imageLoader.load();
			_surfaceLoaders.push(_imageLoader);
			return content;
		}

		private function addCollabCanvas() : DisplayObjectContainer {
			IMAGES_TO_LOAD++;
			return addLoadedImage(_collabCavas,true);
		}

		private function onError(event : LoaderEvent = null) : void {
			if (event.target.url == _canvasBgURL){
				if (_surface) {
					dispatchEvent(new Event(SURFACE_NOT_AVAILABLE));
				}
			} else {
				onBackgroundImageLoaded();
			}
		}

		private function onBackgroundImageLoaded(event : LoaderEvent = null) : void {
			_imagesLoaded++;
			if (_imagesLoaded == IMAGES_TO_LOAD) {
				_scrollBar.targetFriend = _canvasBG;
				resize();
				_menuBar.visible = true;
				
				_canvas.background = _canvasBG;
				_canvas.backgroundLoaded = _firstImageLoaded = true;
								
				repositionMainContent();
				_mainContent.visible = true;
				_mainContentClipRect.width = _canvasBG.width;
				_mainContentClipRect.height = _canvasBG.height;
				dispatchEvent(new Event(READY));
			}
		}
		
		private function resize(event : Event = null) : void {		
			updateMenuBar();
			
			_background.width = stage.stageWidth;
			_background.height = stage.stageHeight;
			
			
			if (event) repositionMainContent();
		}

		private function checkScrollZoom() : void {
			var bool:Boolean = getPreviewScale() < 1;
			if (_previewEnalbed != bool){
				_previewEnalbed = bool;
				if (!_previewEnalbed && _previewMode){
					notifyPreviewModeOff();
				}
				dispatchEvent(new Event(PREVIEW_ENABLED));
			}
			bool = _scrollBar.active;
			if (_grabEnabled != bool){
				_grabEnabled = bool;
				if (!_grabEnabled && _grabMode){
					notifyGrabModeChange(false);
				}
				dispatchEvent(new Event(GRAB_ENABLED));
			}
		}
		

		private function repositionMainContent() : void {
			
			var scale:Number = _previewMode ? getPreviewScale() : 1;
			_mainContent.scaleX = _mainContent.scaleY = scale;
			
			_canvasMask.graphics.clear();
			_canvasMask.graphics.beginFill(0x000000,1);
			_canvasMask.graphics.drawRect(0, _mainContentBottomY, stage.stageWidth, stage.stageHeight - _mainContentBottomY);
			_canvasMask.graphics.endFill();
			
			_mainContent.x = /* _mouseContainer.x = */ Math.round(Math.max(0,(stage.stageWidth- _canvasBG.width * _mainContent.scaleX) / 2));
			_mainContent.y = /* _mouseContainer.y = */ Math.round(_mainContentBottomY - _canvasBG.height * _mainContent.scaleX);
			
			_tempCanvasHolder.x = -_mainContent.x;
			_tempCanvasHolder.y = -_mainContent.y; 
			
			_canvas.actualiseBGPosition();
			
			_scrollBar.updateBar();
			
			checkScrollZoom();
			
			var gradientBoxMatrix:Matrix = new Matrix(); 
			gradientBoxMatrix.createGradientBox(stage.stageWidth,100, Math.PI / 2, 0, 0);
		}

		private function onSprayed(event : Event) : void {

			_menuBar.saveEnabled = true;
			_canvas.removeEventListener(Canvas.SPRAYED, onSprayed);
		}

		public function setColors(data : Vector.<PaletteData>) : void {
			if (_menuBar) _menuBar.setColors(data);
			else _paletteData = data;
		}

		private function updateMenuBar() : void {
			_menuBar.y = stage.stageHeight - _menuBar.height;
			_menuBar.update();
			_mainContentBottomY = Math.round(_menuBar.y) + MenuBar.MARGIN_TOP + 10; 
			_scrollBar.targetBottomY = _mainContentBottomY;
		}

		public function get contentHeight() : Number {
			for (var i : int = 0; i < _mainContent.numChildren; i++) {
			}
			return _mainContent.height;
		}

		public function get mainContentBitmapData() : BitmapData {
			var bitmapData : BitmapData = new BitmapData(_canvasBG.width, _canvasBG.height, true, 0x00000000);
			bitmapData.draw(_mainContent,null,null,null,_mainContentClipRect);
			addWaterMak(bitmapData);
			return bitmapData;
		}

		public function get canvasBitmapData() : BitmapData {
			var bitmapData : BitmapData = new BitmapData(_canvasBG.width, _canvasBG.height, true, 0x00000000);
			bitmapData.draw(_canvas,null,null,null,_mainContentClipRect);
			bitmapData.draw(_tempCanvasHolder,null,null,null,_mainContentClipRect);
			return bitmapData;
		}
		
		public function addWaterMak(bitmapData:BitmapData):void{
			var watermark:Bitmap = ApplicationFacade.getSWFAssetInstance("Watermark") as Bitmap;
			var matrix:Matrix = new Matrix();
			matrix.translate(bitmapData.width - watermark.width - 10, 10);
			bitmapData.draw(watermark,matrix);
		}

		public function get tShirtData() : BitmapData {
			var bitmapData : BitmapData;
			var areaSize:Size = new Size(601 , 959);
			var areaPos:Point = new Point(-383 , -259);
			var maxScale:Number = Math.sqrt( 16777215 / (areaSize.w * areaSize.h) );
			var sprayArea:Rectangle = new Rectangle(0,0,areaSize.w * maxScale, areaSize.h * maxScale);
			try{
				bitmapData = new BitmapData(sprayArea.width, sprayArea.height, true, 0x00000000);
				var matrix : Matrix = new Matrix();
				matrix.scale(maxScale, maxScale);
				matrix.translate(areaPos.x * maxScale, areaPos.y * maxScale);
	//			var rect
				bitmapData.draw(canvasBitmapData,matrix,null,null,sprayArea);
			} catch (e:Error){
				Debug.trace('Sorry, its too big yaaar, '+(sprayArea.width * sprayArea.height)+' pix >>'+e.getStackTrace(),Debug.ERROR);
			}
			return bitmapData;
		}

		public function hide() : void {
			_canvas.clear();
			visible = false;
		}

		public function get surface() : SurfaceData {
			return _surface;
		}

		public function clearSurface() : void {
			_surface = null;
			hide();
		}

		public function reactivateScrollListeners() : void {
			_scrollBar.active = true;
		}
		
		public function disabledPost(type:String):void{
			switch(type){
				case FacebookConnector.PRIVATE_POST_TYPE:
					_menuBar.disabledSaveAlbum();
					break;
				case FacebookConnector.PUBLIC_POST_TYPE:
					_menuBar.disabledSavePublic();
					break;
				case FacebookConnector.COLLAB_POST_TYPE:
					_menuBar.disabledSaveCollab();
					break;
			}
			_menuBar.saveEnabled = false;
			_canvas.addEventListener(Canvas.SPRAYED, onSprayed);
		}
		public function disabledSave(event:Event = null):void{
			_menuBar.saveEnabled = false;
			_canvas.addEventListener(Canvas.SPRAYED, onSprayed);
		}

		public function get previewEnalbed() : Boolean {
			return _previewEnalbed;
		}

		public function get grabEnabled() : Boolean {
			return _grabEnabled;
		}
	}
}
