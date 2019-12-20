package com.lessrain.project {
	import com.lessrain.project.controller.LoadingStateEnterCommand;
	import com.lessrain.project.controller.MainStateEnterCommand;
	import com.lessrain.project.controller.AssetsParseCommand;
	import com.lessrain.project.controller.StartupCommand;
	import com.lessrain.project.view.components.Application;
	import com.lessrain.puremvc.assets.model.AssetsProxy;
	import com.lessrain.puremvc.assets.model.CopyProxy;
	import com.lessrain.puremvc.assets.model.PropertiesProxy;
	import com.lessrain.puremvc.assets.model.SWFAssetsProxy;
	import com.lessrain.puremvc.assets.model.StyleSheetsProxy;

	import org.puremvc.as3.multicore.patterns.facade.Facade;

	import flash.text.TextFormat;
	import flash.utils.getQualifiedClassName;

	/**
	 * @author Oliver List, Less Rain (o.list_at_lessrain.com)
	 */
	public class ApplicationFacade extends Facade 
	{

		public static const NAME : String = getQualifiedClassName(ApplicationFacade);

		/*******************************************************************
		 * Notification constants
		 *******************************************************************/

		/*
		 * Startup the PMVC apparatus
		 */
		public static const STARTUP : String = "startup";
		public static const MAIN_STATE_ENTER : String = "mainStateEnter";
		public static const LOADING_STATE_ENTER : String = "loadingStateEnter";
		public static const STATE_READY : String = "stateReady";
		
		/*
		 * Custum notifications
		 */
		public static const PREPARE_SAVE_IMAGE : String = "prepareSaveImage";
		public static const SAVE_IMAGE_PREPARED : String = "saveImagePrepared";
		public static const SAVE_IMAGE : String = "saveImage";
		public static const IMAGE_SAVED : String = "imageSaved";
		public static const SAVE_IMAGE_FAILED : String = "saveImageFailed";
		
		public static const SHOW_CHOOSE_SURFACE_VIEW : String = "showChooseSurfaceView";
		public static const ALL_THUMBS_LOADED : String = "allThumbsLoaded";
		public static const SURFACE_CHOSEN : String = "surfaceChosen";
		public static const ITEM_BUY : String = "itemBuy";
		public static const ITEM_BOUGHT : String = "itemBought";
		
		public static const EDITOR_READY : String = "editorReady";
		public static const SURFACE_NOT_AVAILABLE : String = "surfaceNotAvailable";
		
		public static const TOOL_CHANGED : String = "toolChanged";
		public static const COLOR_CHANGED : String = "colorChanged";
		public static const DISTANCE_CHANGED : String = "distanceChanged";
		
		public static const SHOW_ARCHIVE : String = "showArchive";
		public static const ARCHIVE_READY : String = "archiveReady";
		
		public static const POST_TO_FACEBOOK : String = "postToFacebook";
		public static const FACEBOOK_POST_DONE : String = "facebookPostDone";
		public static const SEND_COLLAB : String = "sendCollab";
		public static const SEND_COMPETITION : String = "sendCompetition";
		public static const SAVE_FOR_LATER : String = "safeForLater";
		public static const COLLAB_CONFIRMED : String = "collab_confirmed";
		public static const GRAB_MODE:String = "grabMode";
		public static const PREVIEW_MODE : String = "previewMode";
		public static const PREVIEW_ENABLED : String = "previewEnabled";
		public static const GRAB_ENABLED : String = "grabEnabled";
		public static const PALETTE_CLICKED : String = "paletteClicked";
		public static const GO_TO_FACEBOOK_APP : String = "goToFacebookApp";

		public static function getInstance( key : String ) : ApplicationFacade 
		{
			if (instanceMap[ key ] == null) 
			{
				instanceMap[ key ] = new ApplicationFacade(key);
			}
			return instanceMap[ key ] as ApplicationFacade;
		}
		
		/**
		 * Convenience access to assets through the main apps Application Facade
		 */
		public static function getAsset(key_ : String) : * 
		{
			var assetProxy : AssetsProxy = AssetsProxy(getInstance(NAME).retrieveProxy(AssetsProxy.NAME));
			return assetProxy.getAsset(key_);
		}

		/**
		 * Convenience access to text translations through the main apps Application Facade
		 */
		public static function getCopy(key_ : String) : String 
		{
			var copyProxy : CopyProxy = getInstance(NAME).retrieveProxy(CopyProxy.NAME) as CopyProxy;
			if (copyProxy) return copyProxy.getValue(key_);
			else return null;
		}

		/**
		 * Convenience access to properties through the main apps Application Facade
		 */
		public static function getProperty(key_ : String) : String 
		{
			var propertiesProxy : PropertiesProxy = getInstance(NAME).retrieveProxy(PropertiesProxy.NAME) as PropertiesProxy;
			if (propertiesProxy) return propertiesProxy.getProperty(key_);
			else return null;
		}

		/**
		 * Convenience access to swf assets through the main apps Application Facade
		 */
		public static function getSWFAssetClass(key_ : String) : Class 
		{
			var swfAssetsProxy : SWFAssetsProxy = getInstance(NAME).retrieveProxy(SWFAssetsProxy.NAME) as SWFAssetsProxy;
			if (swfAssetsProxy) return swfAssetsProxy.getSWFAssetClass(key_);
			else return null;
		}

		/**
		 * Convenience access to swf assets through the main apps Application Facade
		 */
		public static function getSWFAssetInstance(key_ : String) : *
		{
			var swfAssetsProxy : SWFAssetsProxy = getInstance(NAME).retrieveProxy(SWFAssetsProxy.NAME) as SWFAssetsProxy;
			if (swfAssetsProxy) return new (swfAssetsProxy.getSWFAssetClass(key_))();
			else return null;
		}

		/**
		 * Convenience access to stylesheets through the main apps Application Facade
		 */
		public static function getTextFormat(key_ : String, styleName_ : String) : TextFormat 
		{
			var styleSheetsProxy : StyleSheetsProxy = getInstance(NAME).retrieveProxy(StyleSheetsProxy.NAME) as StyleSheetsProxy;
			if (styleSheetsProxy) return styleSheetsProxy.getTextFormat(key_, styleName_);
			else return null;
		}

		public function ApplicationFacade( key : String ) 
		{
			super(key);	
		}

		public function startup(application_ : Application) : void 
		{
			sendNotification(STARTUP, application_);
		}

		override protected function initializeController() : void 
		{
			super.initializeController();
			
			registerCommand(STARTUP, StartupCommand);			registerCommand(LOADING_STATE_ENTER, LoadingStateEnterCommand);			registerCommand(AssetsProxy.ASSETS_LOADED, AssetsParseCommand);
						registerCommand(MAIN_STATE_ENTER, MainStateEnterCommand);		}
	}
}