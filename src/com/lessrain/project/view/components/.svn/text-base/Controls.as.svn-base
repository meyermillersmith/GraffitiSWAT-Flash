package com.lessrain.project.view.components {
	import flash.geom.Point;
	import com.lessrain.debug.Debug;
	import com.lessrain.project.view.components.sound.SoundController;
	import com.lessrain.project.view.utils.AssetButton;
	import com.lessrain.project.view.utils.Fader;
	import com.lessrain.project.view.utils.FullScreenManager;
	import com.lessrain.project.view.utils.RoundAssetButton;
	import com.lessrain.project.view.utils.RoundToggleButton;

	import flash.display.GradientType;
	import flash.display.Sprite;
	import flash.events.Event;
	import flash.events.FullScreenEvent;
	import flash.events.MouseEvent;
	import flash.external.ExternalInterface;
	import flash.ui.Mouse;
	import flash.ui.MouseCursor;


	/**
	 * @author lessintern
	 */
	public class Controls extends Sprite {
		
		public static const GRAB_MODE_ON:String = 'grabMode';
		public static const GRAB_MODE_OFF:String = 'grabModeOff';
		public static const PREVIEW_MODE_ON:String = 'previewMode';
		public static const PREVIEW_MODE_OFF:String = 'previewModeOff';
		
		private static const SIDE_TOP_BAR_H:int = 30;
		private static const SIDE_MARGIN_H:int = 5;
		private static const SIDE_MARGIN_W:int = 5;

		private var _soundController : SoundController;
		private var _soundButton : RoundToggleButton;
		private var _fullScreenButton : RoundAssetButton;
		private var _helpButton : RoundAssetButton;
		private var _previewButton : ControlsAlphaToggleButton;
		private var _dragButton : ControlsAlphaToggleButton;
		private var _sideButtonContainer : Sprite;
		private var _grabMode : Boolean;
		private var _previewMode : Boolean;
		private var _meemailBanner : Banner;
		private var _showBanner : Boolean;
		private var _userId : String;
		private var _grabEnabled : Boolean;
		private var _previewEnabled : Boolean;
		private var _fullScreenManager : FullScreenManager;
		private var _topBar : Sprite;
		private var _sideButtonContainerBG : Sprite;
		private var _sideButtonContainerTop : Sprite;

		public function Controls(showBanner_ : Boolean, userId_ : String) {
			_userId = userId_;
			_showBanner = showBanner_;
		}

		public function initialize() : void {
			_soundController = SoundController.getInstance();
			
			_soundButton = addChild(new RoundToggleButton('SoundOn','SoundOff',13,0x000000, 0xFFFFFF,.25)) as RoundToggleButton;
			_soundButton.addEventListener(AssetButton.CLICK, onSoundButtonClick);
			
			_fullScreenButton = addChild(new RoundToggleButton('FullScreenOn','FullScreenOff',13,0x000000,0xFFFFFF,.25)) as RoundToggleButton;
			_fullScreenButton.addEventListener(AssetButton.CLICK, onFullScreenClick);
			
			_helpButton = addChild(new RoundAssetButton('Help',13,0x000000,0xFFFFFF,.25)) as RoundAssetButton;
			_helpButton.addEventListener(AssetButton.CLICK, onHelpClick);
			_soundButton.y = _fullScreenButton.y = _helpButton.y = 10;
			
			_sideButtonContainer = addChild(new Sprite()) as Sprite;
			_sideButtonContainer.x = 70;
			
			_sideButtonContainerBG = _sideButtonContainer.addChild(new Sprite()) as Sprite;
			
			_previewButton = _sideButtonContainer.addChild(new ControlsAlphaToggleButton('Preview','Preview',25,0x888888)) as ControlsAlphaToggleButton;
			_previewButton.addEventListener(AssetButton.CLICK, onPreviewClick);
			_previewButton.enabled = false;
			
			_dragButton = _sideButtonContainer.addChild(new ControlsAlphaToggleButton('Drag','Drag',25,0x888888)) as ControlsAlphaToggleButton;
			_dragButton.addEventListener(AssetButton.CLICK, onDragClick);
			_dragButton.y = _previewButton.height + 5;
			_dragButton.enabled = false;
			
			_sideButtonContainerBG.graphics.beginFill(0xFFFFFF);
			_sideButtonContainerBG.graphics.drawRoundRect(0, 0, _sideButtonContainer.width + SIDE_MARGIN_W * 2, SIDE_TOP_BAR_H + _sideButtonContainer.height + SIDE_MARGIN_H * 2, 40);
			_sideButtonContainerBG.graphics.endFill();
			
			_sideButtonContainer.addEventListener(MouseEvent.MOUSE_OVER, showIconBG);
			
			_sideButtonContainerBG.addEventListener(MouseEvent.MOUSE_OVER, showIconDragger);
			_sideButtonContainerBG.addEventListener(MouseEvent.MOUSE_OUT, showIconDragger);
			_sideButtonContainerBG.addEventListener(MouseEvent.MOUSE_DOWN, startDragSideBG);
			_sideButtonContainerBG.mouseChildren = false;
			
			var sideButtonContainerTop:Sprite = _sideButtonContainerBG.addChild(new Sprite()) as Sprite;
			sideButtonContainerTop.graphics.beginGradientFill(GradientType.LINEAR, [0x444444, 0x111111], [1, 1], [0, 255]);
			sideButtonContainerTop.graphics.drawRoundRect(0, 0, _sideButtonContainerBG.width , 60, 40);
			sideButtonContainerTop.graphics.endFill();
			
			var sideButtonContainerTopOver:Sprite = _sideButtonContainerBG.addChild(new Sprite()) as Sprite;
			sideButtonContainerTopOver.graphics.beginFill(0xFFFFFF);
			sideButtonContainerTopOver.graphics.drawRect(0, SIDE_TOP_BAR_H, _sideButtonContainerBG.width, SIDE_TOP_BAR_H);
			sideButtonContainerTopOver.graphics.endFill();
			
			_sideButtonContainerBG.x = - SIDE_MARGIN_W;
			_sideButtonContainerBG.y = - SIDE_TOP_BAR_H - SIDE_MARGIN_H;
			_sideButtonContainerBG.alpha = 0;
			
			_meemailBanner = addChild(new Banner(_userId, 'MeeMailBanner','MeeMailBannerOver')) as Banner;
			_meemailBanner.banner.y = -5;
			
			reposition();
			stage.addEventListener(Event.RESIZE, onStageResize);
			stage.addEventListener(FullScreenEvent.FULL_SCREEN, onFullScreen);
			
			_fullScreenManager = FullScreenManager.getInstance();
		}

		private function showIconBG(event : MouseEvent) : void {
			var hide:Boolean = event.type == MouseEvent.MOUSE_OUT;
			if (hide){
				if (!_sideButtonContainerBG.hitTestPoint(stage.mouseX,stage.mouseY)){
					_sideButtonContainer.removeEventListener(MouseEvent.MOUSE_OUT, showIconBG);
					_sideButtonContainer.addEventListener(MouseEvent.MOUSE_OVER, showIconBG);
					Fader.fadeOut(_sideButtonContainerBG);
				}
			} else {
				_sideButtonContainer.addEventListener(MouseEvent.MOUSE_OUT, showIconBG);
				_sideButtonContainer.removeEventListener(MouseEvent.MOUSE_OVER, showIconBG);
				Fader.fadeIn(_sideButtonContainerBG);
			}
		}

		private function showIconDragger(event : MouseEvent) : void {
			var hide:Boolean = event.type == MouseEvent.MOUSE_OUT;
			Mouse.cursor = hide ? MouseCursor.AUTO :  MouseCursor.HAND;
		}

		private function startDragSideBG(event : MouseEvent) : void {
			_sideButtonContainer.startDrag();
			stage.addEventListener(MouseEvent.MOUSE_UP, stopDragSideBG);
		}

		private function stopDragSideBG(event : MouseEvent) : void {
			stage.removeEventListener(MouseEvent.MOUSE_UP, stopDragSideBG);
			showIconBG(new MouseEvent(MouseEvent.MOUSE_OUT));
			var stopPos:Point = _sideButtonContainer.localToGlobal(new Point(0,0));
			if (stopPos.x > (stage.stageWidth - _sideButtonContainer.width)){
				stopPos.x = (stage.stageWidth - _sideButtonContainer.width);
				_sideButtonContainer.x = _sideButtonContainer.parent.globalToLocal(stopPos).x;
			} else if (stopPos.x < 0){
				stopPos.x = 0;
				_sideButtonContainer.x = _sideButtonContainer.parent.globalToLocal(stopPos).x;
			}
			if (stopPos.y > (stage.stageHeight - _sideButtonContainer.height)){
				stopPos.y = (stage.stageHeight - _sideButtonContainer.height);
				_sideButtonContainer.y = _sideButtonContainer.parent.globalToLocal(stopPos).y;
			} else if (stopPos.y < 0){
				stopPos.y = 0;
				_sideButtonContainer.y = _sideButtonContainer.parent.globalToLocal(stopPos).y;
			}
			_sideButtonContainer.stopDrag();
		}

		private function onDragClick(event : Event) : void {
			_grabMode = (event.target as RoundToggleButton).toggled;
			if (_grabMode){
				dispatchEvent(new Event(GRAB_MODE_ON));
			}else {
				dispatchEvent(new Event(GRAB_MODE_OFF));
			}
		}

		private function onPreviewClick(event : Event) : void {
			if ((event.target as RoundToggleButton).toggled){
				dispatchEvent(new Event(PREVIEW_MODE_ON));
			}else {
				dispatchEvent(new Event(PREVIEW_MODE_OFF));
			}
		}

		private function onHelpClick(event : Event) : void {
			ExternalInterface.call('openHelp');
		}

		private function onFullScreen(event : FullScreenEvent) : void {
			_fullScreenButton.toggled = event.fullScreen;
		}

		private function onFullScreenClick(event : Event) : void {
			if ((event.target as RoundToggleButton).toggled){
				_fullScreenManager.goFullscreen(); 
			}else {
				_fullScreenManager.closeFullscreen();
			}
		}

		private function onSoundButtonClick(event : Event) : void {
			_soundController.soundOn = !(event.target as RoundToggleButton).toggled;
		}

		private function onStageResize(event : Event) : void {
			reposition();
		}

		private function reposition() : void {
			_helpButton.x = stage.stageWidth - _helpButton.width - 10;
			_soundButton.x = _helpButton.x - _soundButton.width - 5;
			_fullScreenButton.x = _soundButton.x - _fullScreenButton.width - 5;
			
			_sideButtonContainer.y = stage.stageHeight - _sideButtonContainer.height - 100;
			
			_meemailBanner.x = _fullScreenButton.x - _meemailBanner.width - 5;
		}

		public function set grabMode(grabMode : Boolean) : void {
			_grabMode = grabMode;
			_dragButton.toggled = _grabMode;
		}
		public function set previewMode(previewMode_ : Boolean) : void {
			Debug.trace('Controls::previewMode:'+previewMode_);
			_previewMode = previewMode_;
			_previewButton.toggled = previewMode_;
		}

		public function set grabEnabled(grabEnabled : Boolean) : void {
			_grabEnabled = grabEnabled;
			_dragButton.enabled = grabEnabled;
		}
		public function set previewEnabled(previewEnabled : Boolean) : void {
			_previewEnabled = previewEnabled;
			_previewButton.enabled = previewEnabled;
		}

		public function showBanner() : void {
			if (_showBanner){
				_meemailBanner.show();
			}
		}
	}
}
