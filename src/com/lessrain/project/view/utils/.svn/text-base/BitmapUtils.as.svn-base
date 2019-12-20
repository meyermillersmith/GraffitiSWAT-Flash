package com.lessrain.project.view.utils {
	import flash.display.Bitmap;
	import flash.display.PixelSnapping;
	import flash.display.DisplayObject;
	import com.lessrain.data.Size;
	import flash.geom.Matrix;
	import flash.geom.Rectangle;
	import com.adobe.images.PNGEncoder;
	import com.bytearray.JPEGEncoder;
	import com.dynamicflash.util.Base64;
	import com.lessrain.util.CallDelay;

	import flash.display.BitmapData;
	import flash.display.BitmapDataChannel;
	import flash.display.Loader;
	import flash.geom.Point;
	import flash.utils.ByteArray;

	public class BitmapUtils {
	
		private static const POINT_ORIGIN : Point = new Point();
		
		private static var _jpegEncoder : JPEGEncoder;
		private static var _bmpdTemp : BitmapData;
		private static var _quality : int = -1;
	
		public static function exportJPEG(bitmapData_ : BitmapData, quality_ : uint = 75) : ByteArray {
			
			if (!bitmapData_) return null;
				
			if (!_jpegEncoder || _quality != quality_) _jpegEncoder = new JPEGEncoder(quality_);
			_quality = quality_;
				
			return _jpegEncoder.encode(bitmapData_);
		}
	
		public static function exportPNG(bitmapData_ : BitmapData) : ByteArray {
			return PNGEncoder.encode(bitmapData_);
		}
	
		public static function exportAlphaJPEG(bitmapData_ : BitmapData) : ByteArray {
			return exportJPEG(getAlphaChannel(bitmapData_));
		}
	
		public static function getAlphaChannel(bitmapData_ : BitmapData) : BitmapData {
			// Try to reuse static temp bitmap
			if (!_bmpdTemp || _bmpdTemp.width != bitmapData_.width || _bmpdTemp.height != bitmapData_.height) {
				if(_bmpdTemp) {
					_bmpdTemp.dispose();
				}
				_bmpdTemp = new BitmapData(bitmapData_.width, bitmapData_.height, false, 0x000000);
			}
	
			_bmpdTemp.copyChannel(bitmapData_, bitmapData_.rect, POINT_ORIGIN, BitmapDataChannel.ALPHA, BitmapDataChannel.RED);				
			_bmpdTemp.copyChannel(bitmapData_, bitmapData_.rect, POINT_ORIGIN, BitmapDataChannel.ALPHA, BitmapDataChannel.GREEN);				
			_bmpdTemp.copyChannel(bitmapData_, bitmapData_.rect, POINT_ORIGIN, BitmapDataChannel.ALPHA, BitmapDataChannel.BLUE);	
			return _bmpdTemp;
		}
		
		/**
		 * Decodes a Base64 encoded ByteArray that represents an image
		 * 
		 * @param encoded_	Base64 encoded string
		 * @param callback_ Callback method to be invoked when decoding is done.
		 * 					Note that the callback method must accept a Bitmap
		 * 					instance as the first argument
		 */
		public static function decodeBase64Image(encoded_ : String, callback_:Function) : void {
			var decoded : ByteArray = Base64.decodeToByteArray(encoded_);
			decodeByteArray(decoded, callback_);
		}
	
		/**
		 * Decodes an image that is stored as a ByteArray
		 * 
		 * @param ba_		ByteArray to decode
		 * @param callback_ Callback method to be invoked when decoding is done.
		 * 					Note that the callback method must accept a Bitmap
		 * 					instance as the first argument
		 */
		public static function decodeByteArray(ba_ : ByteArray, callback_:Function) : void {
			var loader : Loader = new Loader();
			loader.loadBytes(ba_);
			
			CallDelay.call(function():void {
				callback_(loader.content);
			}, 100);
		}

		public static function getCroppedBitmapData(bmd : BitmapData) : BitmapData {
			var croppedBmd:BitmapData;
			var rect:Rectangle = bmd.getColorBoundsRect(0xFFFFFF, 0x00000000, false);
			var m:Matrix = new Matrix();
			m.translate(-rect.x, -rect.y);
			croppedBmd = new BitmapData(rect.width, rect.height, true, 0x00000000);
			croppedBmd.draw(bmd, m, null, null, null, true);
			return croppedBmd;
		}
		
		public static function getResizedBitmapData(origBmd_:BitmapData, targetSize_:Size) :BitmapData
		{
			var origSize_:Size = new Size(origBmd_.width, origBmd_.height);
			var scale:Number = Math.max(targetSize_.h / origSize_.h, targetSize_.w / origSize_.w);
			
			var matrix:Matrix = new Matrix();
			matrix.scale(scale, scale);
			
			var resizedBitmapData:BitmapData = new BitmapData(Math.round(origSize_.w*scale), Math.round(origSize_.h*scale), true, 0x00000000);
			resizedBitmapData.draw(origBmd_, matrix, null, null, null, true);
			return resizedBitmapData;
		}
		
		public static function getSnapshot(do_:DisplayObject) :Bitmap
		{
			var bmd:BitmapData = new BitmapData(do_.width, do_.height, true, 0x00000000);
			bmd.draw(do_, null, null, null, null, true);
			return new Bitmap(bmd, PixelSnapping.AUTO, true);
		}
		
		public static function getFittingResizedBitmapData(origBmd_:BitmapData, targetSize_:Size, offset_:Point = null) :BitmapData
		{
			var origSize_:Size = new Size(origBmd_.width, origBmd_.height);
			var bitmapData:BitmapData = new BitmapData(targetSize_.w, targetSize_.h, true, 0x00000000);
			var offset:Point = offset_ || new Point();
			
			var scale:Number = Math.max(targetSize_.h / origSize_.h, targetSize_.w / origSize_.w);
			var xOffset:Number = -Math.max(0, Math.round(scale*origSize_.w/2 - targetSize_.w/2));
			var yOffset:Number = -Math.max(0, Math.round(scale*origSize_.h/2 - targetSize_.h/2));
			
			var matrix:Matrix = new Matrix();
			matrix.scale(scale, scale);
			matrix.translate(xOffset+offset.x, yOffset+offset.y);
			
			bitmapData.draw(origBmd_, matrix, null, null, null, true);
			return bitmapData;
		}
	}
}