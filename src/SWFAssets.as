package {
	import flash.display.Sprite;
	/**
	 * Map linkage IDs of a library SWF fields. After the SWFAsset.swf
	 * library has been loaded into the main application, new instances of the
	 * library items can be attached to the stage like this:
	 * 
	 * <code>addChild(SWFAsset.getSWFAsset("SpriteFieldName").instance as Sprite);
	 * addChild(SWFAsset.getSWFAsset("BitmapFieldName").instance as Bitmap);</code>
	 * 
	 * @author Oliver List, Less Rain (o.list_at_lessrain.com)
	 */
	final public class SWFAssets extends Sprite 	{
		/**
		 * SPRAYING
		 */		[Embed(source="../assets/SWFAssets.swf", symbol="CanIllu")]		public var SprayCan : Class;				/*		[Embed(source="../assets/SWFAssets.swf", symbol="SprayBrush")]		public var SprayBrush : Class;		[Embed(source="../assets/SWFAssets.swf", symbol="SprayBrushC")]		public var SprayBrushC : Class;		[Embed(source="../assets/SWFAssets.swf", symbol="SprayBrushC2")]		public var SprayBrushC2 : Class;*/		[Embed(source="../assets/SWFAssets.swf", symbol="SprayBrushC3")]		public var SprayBrushC3 : Class;		[Embed(source="../assets/SWFAssets.swf", symbol="Pen")]		public var Pen : Class;		[Embed(source="../assets/SWFAssets.swf", symbol="PenTip")]		public var PenTip : Class;		[Embed(source="../assets/SWFAssets.swf", symbol="RollerIllu")]		public var Roller : Class;		[Embed(source="../assets/SWFAssets.swf", symbol="RollerSleeze")]		public var RollerSleeze : Class;		[Embed(source="../assets/SWFAssets.swf", symbol="RollerSplashSmall")]		public var RollerSplash0 : Class;		[Embed(source="../assets/SWFAssets.swf", symbol="RollerSplashMedium")]		public var RollerSplash1 : Class;		[Embed(source="../assets/SWFAssets.swf", symbol="RollerSplashLarge")]		public var RollerSplash2 : Class;		[Embed(source="../assets/SWFAssets.swf", symbol="BuyImageRoller")]		public var BuyImageRoller : Class;		[Embed(source="../assets/SWFAssets.swf", symbol="Drop")]		public var Drop : Class;		 		 /**		  * PALETTE		  */		[Embed(source="../assets/SWFAssets.swf", symbol="Arrow")]		public var Arrow : Class;		[Embed(source="../assets/SWFAssets.swf", symbol="ColorGlass")]		public var ColorGlass : Class;		[Embed(source="../assets/SWFAssets.swf", symbol="ColorGlassReflection")]		public var ColorGlassReflection : Class;		[Embed(source="../assets/SWFAssets.swf", symbol="ColorTamiyaGlass")]		public var ColorTamiyaGlass : Class;		[Embed(source="../assets/SWFAssets.swf", symbol="ColorTamiyaGlassReflection")]		public var ColorTamiyaGlassReflection : Class;		[Embed(source="../assets/SWFAssets.swf", symbol="PaletteSeperator")]		public var PaletteSeperator : Class;		 		 /**		  * CONTROLS
		  */		[Embed(source="../assets/SWFAssets.swf", symbol="DistanceRuler")]		public var DistanceRuler : Class;		[Embed(source="../assets/SWFAssets.swf", symbol="ScrollKnob")]		public var ScrollKnob : Class;		[Embed(source="../assets/SWFAssets.swf", symbol="FullScreenOn")]		public var FullScreenOn : Class;		[Embed(source="../assets/SWFAssets.swf", symbol="FullScreenOff")]		public var FullScreenOff : Class;		[Embed(source="../assets/SWFAssets.swf", symbol="SoundOff")]		public var SoundOff : Class;		[Embed(source="../assets/SWFAssets.swf", symbol="SoundOn")]		public var SoundOn : Class;		[Embed(source="../assets/SWFAssets.swf", symbol="Drag")]		public var Drag : Class;		[Embed(source="../assets/SWFAssets.swf", symbol="Preview")]		public var Preview : Class;		[Embed(source="../assets/SWFAssets.swf", symbol="Help")]		public var Help : Class;		[Embed(source="../assets/SWFAssets.swf", symbol="SprayCursor")]		public var SprayCursor : Class;		[Embed(source="../assets/SWFAssets.swf", symbol="PostFacebookButtonBG")]		public var PostFacebookButtonBG : Class;		[Embed(source="../assets/SWFAssets.swf", symbol="FBCoin")]		public var FBCoin : Class;				/**		 * TOOLS PALETTE		 */		[Embed(source="../assets/SWFAssets.swf", symbol="Lock")]		public var Lock : Class;		[Embed(source="../assets/SWFAssets.swf", symbol="PaletteClose")]		public var PaletteClose : Class;		[Embed(source="../assets/SWFAssets.swf", symbol="PaletteArrow")]		public var PaletteArrow : Class;				/**		 * BACKGROUNDS		 */		[Embed(source="../assets/SWFAssets.swf", symbol="Background")]		public var Background : Class;		[Embed(source="../assets/SWFAssets.swf", symbol="BackgroundHome")]		public var BackgroundHome : Class;		[Embed(source="../assets/SWFAssets.swf", symbol="BGLeft")]		public var BGLeft : Class;		[Embed(source="../assets/SWFAssets.swf", symbol="BGRight")]		public var BGRight : Class;		[Embed(source="../assets/SWFAssets.swf", symbol="ButtonBarBG")]		public var ButtonBarBG : Class;		[Embed(source="../assets/SWFAssets.swf", symbol="PaletteBG")]		public var PaletteBG : Class;		[Embed(source="../assets/SWFAssets.swf", symbol="PopupBackground")]		public var PopupBackground : Class;		[Embed(source="../assets/SWFAssets.swf", symbol="Bubble")]		public var Bubble : Class;		[Embed(source="../assets/SWFAssets.swf", symbol="Watermark")]		public var Watermark : Class;		  		/**		 * SOUNDS
		 */
		[Embed(source="../assets/SWFAssets.swf", symbol="SprayCanShake")]
		public var SprayCanShake : Class;		[Embed(source="../assets/SWFAssets.swf", symbol="Spray")]		public var Spray : Class;		[Embed(source="../assets/SWFAssets.swf", symbol="ChooseColor")]		public var ChooseColor : Class;		[Embed(source="../assets/SWFAssets.swf", symbol="PenDrawing")]		public var PenDrawing : Class;		[Embed(source="../assets/SWFAssets.swf", symbol="RollerDrawing")]		public var RollerDrawing : Class;				/**		 * BANNER		 */		[Embed(source="../assets/SWFAssets.swf", symbol="MeeMailBanner")]		public var MeeMailBanner : Class;		[Embed(source="../assets/SWFAssets.swf", symbol="MeeMailBannerOver")]		public var MeeMailBannerOver : Class;		 
	}
}
