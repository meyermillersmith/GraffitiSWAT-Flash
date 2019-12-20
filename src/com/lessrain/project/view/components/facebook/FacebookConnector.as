package com.lessrain.project.view.components.facebook {
	import se.cambiata.utils.crypt.Simplecrypt;

	import com.facebook.graph.Facebook;
	import com.facebook.graph.core.FacebookURLDefaults;
	import com.lessrain.debug.Debug;
	import com.lessrain.project.ApplicationFacade;
	import com.lessrain.project.model.vo.BuyableData;
	import com.lessrain.project.view.components.Blocker;
	import com.lessrain.project.view.components.ConfirmationPopup;
	import com.lessrain.project.view.components.ItemBuyEvent;
	import com.lessrain.project.view.utils.Encrypt;
	import com.lessrain.project.view.utils.LessMath;
	import com.lessrain.project.view.utils.ObjectPrinter;
	import com.lessrain.project.view.utils.ObjectUtils;
	import com.lessrain.project.view.utils.URLoaderWrapper;
	import com.lessrain.project.view.utils.UploadPostHelper;

	import flash.display.BitmapData;
	import flash.display.JPEGEncoderOptions;
	import flash.display.PNGEncoderOptions;
	import flash.display.Sprite;
	import flash.events.Event;
	import flash.events.IOErrorEvent;
	import flash.events.MouseEvent;
	import flash.events.TimerEvent;
	import flash.net.URLLoader;
	import flash.net.URLLoaderDataFormat;
	import flash.net.URLRequest;
	import flash.net.URLRequestHeader;
	import flash.net.URLRequestMethod;
	import flash.net.URLVariables;
	import flash.utils.ByteArray;
	import flash.utils.Timer;

	/**
	 * @author lessintern
	 */
	public class FacebookConnector extends Sprite {
		public static var PRIVATE_POST_TYPE : String = 'private';
		public static var PUBLIC_POST_TYPE : String = 'public';
		public static const FRIEND_POST_TYPE : String = 'friend';
		public static const COLLAB_POST_TYPE : String = 'collab';
		public static const COMPETITION_POST_TYPE : String = 'competition';
		public static const SAVE_FOR_LATER_POST_TYPE : String = 'safeForLater';
		public static const DOWNLOAD : String = "download";
		private static var DEV_ACESS : String = 'AAACeGzlN9fQBAEoRDidQC1442NSo6tEuYauUHHmA0aMeE7AckoZCshSzUN7joDfohxTf9OzPCTZAVtnt7P4iSUR6BnV3qbNxupHXZApg4nTiMaoZCuMO';
		private static var SWAT_ACESS : String = 'AAABZCPuyEEkwBAADoZCQe4So7khIzoJwJYxDZBeCeKQjGcX2NppW5NBnoqaSBZBI2e5a94IP1eVXhPHbyYNxJgHjZBuyLC38mO8NycKcTPbXBe4nLB0Hy';
		private static var ACCESS_TOKEN : String = SWAT_ACESS;
		private var _uploadDialog : FacebookUploadPictureDialog;
		private var _grantDialog : ConfirmationPopup;
		private var _confirmUplaodDialog : ConfirmationPopup;
		private var _isRechecking : Boolean;
		private var _currentImage : BitmapData;
		private var _itemToBeBought : BuyableData;
		private var _reconnectTimer : Timer;
		private var _reconnectFunction : Function;
		private var _initFailed : Boolean = true;
		private var _checkPermissionsOnInit : Boolean;
		private var _blocker : Blocker;
		private var _albumId : String = "";
		private var _userId : String;
		private var _uploadInProgress : Boolean;
		private var _appId : String;
		private var _albumName : String;
		private var _currentPostType : String;
		private var _pageId : String;
		private var _userFullName : String;
		private var _rightsGranted : Boolean;
		private var _userFirstName : String;
		private var _appName : String;
		private var _pageUrl : String;
		private var _postSuccessful : Boolean;
		private var _collabSurface : String;
		private var _collabCanvas : BitmapData;
		private var _collabDialog : FacebookCollabDialog;
		private var _friends : Vector.<FacebookFriend>;
		private var _collabCanvasSrc : String;
		private var _collabImgLink : String;
		private var _collabid : String;
		private var _collaborators : Array;
		private var _savedCollabId : int;
		private var _cancelCollabMessageDialog : ConfirmationPopup;
		private var _collabImgSrc : String;
		private var _currentSurface : String;
		private var _shirtAlbumId : String;
		private var _competitionCanvas : BitmapData;
		private var _isCompetitionPost : Boolean;
		private var _competitionFilename : String;
		private var _confirmSaveDialog : ConfirmationPopup;
		private var _disconnectedDialog : ConfirmationPopup;
		private var _downloadBitmap : BitmapData;
		private var _overrideDialog : ConfirmationPopup;
		private var _collabRequestId : String;
		private var _currentImagePost : Object;
		private var _triedPHPUpload : Boolean;
		private var _confirmBuyDialog : BuyConfirmDialog;
		private var _appServerUrl : String;
		private var _appAlias : String;
		private var _albumFullDialog : ConfirmationPopup;
		private var _albumCount : int = 0;
		private var _urlLoaderWrapper : URLoaderWrapper;
		
		private static const BASE_URL_SECURE:String="https://graffiti.mee-mail.com/";
		private static const BASE_URL:String="https://graffiti.mee-mail.com";

		public function FacebookConnector(userId_ : String, userFullName_ : String, userFirstName_ : String, collabid_ : String, collabRequestId_ : String) {
			trace('FacebookConnector::FacebookConnector:facebookId_ ' + userId_);
			_userId = userId_;
			_userFullName = userFullName_;
			_userFirstName = userFirstName_;
			_appId = "139908232778316";//ApplicationFacade.getProperty('appid');
			_appServerUrl = ApplicationFacade.getProperty('appserver');
			_appAlias = ApplicationFacade.getProperty('appalias');
			_albumId = ApplicationFacade.getProperty('album_id');
			_albumCount = int(ApplicationFacade.getProperty('album_count'));
			
			if(!_appServerUrl)
			{
				_appServerUrl=BASE_URL;
			}

			if (!_albumId) _albumId = "0";

			trace('FacebookConnector::FacebookConnector:_albumId ' + _albumId + ' _albumCount ' + _albumCount);

			_collabid = int(collabid_) > 0 ? collabid_ : '';
			_collabRequestId = collabRequestId_;
			_collaborators = new Array();
			_reconnectTimer = new Timer(10000, 3);
			_reconnectTimer.addEventListener(TimerEvent.TIMER, reconnect);
			_blocker = addChild(new Blocker()) as Blocker;
			_blocker.addEventListener(Blocker.HIDDEN, onBlockerHidden);
			_blocker.addEventListener(Blocker.CANCEL, onBlockerCancel);

			Debug.user = _userId;
		}

		public function onCollabConfirmed(collaborators : String, confirmedId : String) : void {
			if (_collabid == confirmedId) {
				_collaborators = collaborators.split(',');
				for (var i : int = 0; i < _collaborators.length; i++) {
					if (_collaborators[i] == _userId) {
						_collaborators.splice(i, 1);
					}
				}
			}
		}

		private function onBlockerHidden(event : Event) : void {
			dispatchEvent(event);
		}

		private function onBlockerCancel(event : Event) : void {
			_reconnectTimer.stop();
		}

		public function initialize() : void {
			trace('FacebookConnector::initialize:');
			_albumName = ApplicationFacade.getProperty('album.private.name');
			// _publicAlbumId = ApplicationFacade.getProperty('album.public.id');
			_shirtAlbumId = ApplicationFacade.getProperty('album.shirt.id');
			_pageId = ApplicationFacade.getProperty('page.id');
			_appName = ApplicationFacade.getProperty('app.name');
			_pageUrl = ApplicationFacade.getProperty('page.url');
			trace('FacebookConnector::FacebookConnector:_pageId ' + _pageId + ' _albumName ' + _albumName);
			startReconnectTimer(initFacebook);
			initFacebook();
		}

		private function startReconnectTimer(callback : Function) : void {
			_reconnectTimer.reset();
			_reconnectFunction = callback;
			_reconnectTimer.start();
		}

		private function reconnect(event : TimerEvent) : void {
			trace('FacebookConnector::reconnect:');
			_reconnectFunction();
			if (_reconnectTimer.currentCount == _reconnectTimer.repeatCount) {
				if (_reconnectFunction == initFacebook) {
					_initFailed = true;
					if (_checkPermissionsOnInit) alertDisconnected();
					trace('FacebookConnector::reconnect: _initFailed' + _initFailed);
				} else {
					alertDisconnected();
					trace('FacebookConnector::reconnect:alertDisconnected!_initFailed?' + _initFailed, Debug.ERROR);
				}
				_reconnectTimer.reset();
			}
		}

		private function alertDisconnected() : void {
			if (!_disconnectedDialog) {
				_disconnectedDialog = new ConfirmationPopup('facebook.disconnected.title', 'facebook.disconnected.content', 'facebook.disconnected.ok', 'facebook.disconnected.cancel');
				_disconnectedDialog.addEventListener(ConfirmationPopup.CANCEL, _blocker.hide);
				_disconnectedDialog.confirmButton.addEventListener(MouseEvent.CLICK, downloadGraffiti);
			}
			_disconnectedDialog.show();
			// dispatchEvent(new Event(DISCONNECTED));
		}

		private function downloadGraffiti(event : Event) : void {
			if (_currentSurface && _currentSurface != '') {
				_downloadBitmap = isCompetitionPost ? _competitionCanvas : _currentImage;
				dispatchEvent(new Event(DOWNLOAD));
				_blocker.hide();
			}
		}

		private function initFacebook() : void {
			trace('FacebookConnector::initFacebook: _isRechecking ' + _isRechecking);
			var opts : Object = new Object;
			opts.status = true;
			opts.xfbml = true;
			opts.version = "v2.2";
			opts.fileUpload=true;
			opts.frictionlessRequests = true;
			// V 2.0
			// Facebook.init(_appId, handleInit,{frictionlessRequests: true});
			Facebook.init(_appId, handleInit, opts);
		}

		private function handleInit(response : Object, fail : Object) : void {
			trace("FacebookConnector::handleInit: " + ObjectUtils.inspect(handleInit));
			trace('FacebookConnector::handleInit: result ' + response + ' fail ' + fail + ' Facebook.getAuthResponse().uid ' + Facebook.getAuthResponse().uid);
			// trace('FacebookConnector::handleInit: result ' + response + ' fail ' + fail+' Facebook.getAuthResponse().uid '+Facebook.getAuthResponse().uid);
			if (!fail) {
				_reconnectTimer.reset();
				_initFailed = false;
				getAlbumIdFromFB();

				if (_checkPermissionsOnInit) checkPermissions();

				if (_userId == '100002004384271') {
					// getAcessTokens();
				}
				getAllFriends();
			}
		}

		private function getAllFriends() : void {
			Facebook.api("me/friends?fields=name,id,picture&", handleGetAllFriends);
		}

		private function handleGetAllFriends(response : Object, fail : Object) : void {
			if (response != null) {
				_friends = new Vector.<FacebookFriend>();
				for (var i : int = 0; i < response.length; i++) {
					var friend : FacebookFriend = new FacebookFriend(response[i]);
					_friends.push(friend);
				}
				if (_collabDialog) {
					_collabDialog.friends = _friends;
				}
			}
		}

		public function postCollab(fullImage : BitmapData, canvas : BitmapData, surfaceKey : String) : void {
			_collabCanvas = canvas;
			_collabSurface = surfaceKey;
			_collabCanvasSrc = null;
			_collabImgLink = null;

			postToFacebook(fullImage, surfaceKey, COLLAB_POST_TYPE);
		}

		public function postCompetition(fullImage : BitmapData, canvas : BitmapData, surfaceKey : String) : void {
			_competitionCanvas = canvas;
			postToFacebook(fullImage, surfaceKey, COMPETITION_POST_TYPE, true);
		}

		public function saveForLater(canvas : BitmapData, surfaceKey : String) : void {
			_collabSurface = surfaceKey;
			_collabCanvas = canvas;
			_currentPostType = SAVE_FOR_LATER_POST_TYPE;
			_blocker.show();
			saveCollab(_userId);
		}

		public function setFriendIds(friendIds : String) : void {
			trace('FacebookConnector::setFriendIds:' + friendIds);
		}

		public function postToFacebook(currentImage_ : BitmapData, currentSurface_ : String, postType_ : String, isCompetitionPost_ : Boolean = false) : void {
			trace('FacebookConnector::postToFacebook:postType_ ' + postType_);

			_isCompetitionPost = isCompetitionPost_;
			_postSuccessful = false;
			_currentPostType = postType_;
			_currentImage = currentImage_;
			_currentSurface = currentSurface_;
			handlePostToFacebook();
		}

		public function handlePostToFacebook() : void {
			_isRechecking = false;
			_blocker.show();
			if (_rightsGranted) {
				showSaveDialog();
			} else {
				// _blocker.showCancelButton(60000);
				checkPermissions();
			}
			postToFriendWall({link:'hi'}, null);
			// showUploadDialog();
		}

		private function checkPermissions() : void {
			trace('FacebookConnector::checkPermissions: _reconnectingAttemps ');
			startReconnectTimer(sendCheckPermissions);
			sendCheckPermissions();
		}

		private function sendCheckPermissions() : void {
			trace('FacebookConnector::sendCheckPermissions: _initFailed ' + _initFailed);
			if (_initFailed) {
				_checkPermissionsOnInit = true;
				initialize();
			} else {
				Facebook.api("/me/permissions", handlePermissionsChecked);
			}
		}

		private function handlePermissionsChecked(result : Object, fail : Object) : void {
			trace('FacebookConnector::handlePermissionsChecked: result ' + ObjectPrinter.print(result) + ' fail ' + ObjectPrinter.print(fail) + ' _isRechecking ' + _isRechecking);
			if (!fail) {
				_reconnectTimer.reset();

				trace(ObjectUtils.inspect(result));
				if (result) {
					_blocker.removeCancelButton();

					var userPhotos : Boolean = false;
					var publicProfile : Boolean = false;

					var i : int = 0;
					var l : int = result.length;

					while (i < l) {
						if (result[i].permission) {
							if (result[i].permission == "public_profile") {
								if (result[i].status) {
									if (result[i].status == "granted") {
										publicProfile = true;
									}
								}
							}

							if (result[i].permission == "user_photos") {
								if (result[i].status) {
									if (result[i].status == "granted") {
										userPhotos = true;
									}
								}
							}
						}
						++i;
					}

					// if (result[0].publish_stream && result[0].publish_stream == '1' && result[0].user_photos && result[0].user_photos == '1') {
					if (userPhotos && publicProfile) {
						_rightsGranted = true;
						showSaveDialog();
					} else if (!_isRechecking) {
						showGrantDialog();
					} else {
						_blocker.showMsgByKey('facebook.permissions.fail');
					}
				}
			} else {
				trace('FacebookConnector::handlePermissionsChecked: FAIL ' + fail);
			}
		}

		private function askPermissions(event : Event = null) : void {
			trace('FacebookConnector::askPermissions:');
			var permissions : Object = {scope:"user_photos, publish_stream"};
			if (_userId == '100002004384271') {
				//permissions['scope'] += ",offline_access,manage_pages";
			}
			Facebook.login(handlePermissionsGranted, permissions);
		}

		public function showSaveDialog() : void {
			trace('FacebookConnector::showUploadDialog: ');
			_blocker.removeCancelButton();
			if (isCollabPost) {
				if (!_collabDialog) {
					_collabDialog = new FacebookCollabDialog();
					_collabDialog.addEventListener(ConfirmationPopup.CANCEL, _blocker.hide);
					_collabDialog.addEventListener(ConfirmationPopup.CONFIRM, upload);
					if (_friends) _collabDialog.friends = _friends;
				}
				_collabDialog.showImage(_currentImage, _currentPostType);
			} else {
				if (!_uploadDialog) {
					_uploadDialog = new FacebookUploadPictureDialog();
					_uploadDialog.addEventListener(ConfirmationPopup.CANCEL, _blocker.hide);
					_uploadDialog.addEventListener(ConfirmationPopup.CONFIRM, upload);
				}
				_uploadDialog.showImage(_currentImage, _currentPostType);
			}
		}

		public function showGrantDialog() : void {
			trace('FacebookConnector::showGrantDialog:');
			if (!_grantDialog) {
				_grantDialog = new ConfirmationPopup('facebook.grantRights.title', 'facebook.grantRights.content', 'facebook.grantRights.ok', 'facebook.grantRights.cancel');
				_grantDialog.addEventListener(ConfirmationPopup.CANCEL, _blocker.hide);
				_grantDialog.confirmButton.addEventListener(MouseEvent.CLICK, onGrantClicked);
			}
			_grantDialog.show();
		}

		private function onGrantClicked(event : MouseEvent) : void {
			trace('FacebookConnector::onGrantClicked: _grantDialog.close();');
			// _grantDialog.close();
			askPermissions();
		}

		private function handlePermissionsGranted(result : Object, fail : Object) : void {
			trace('FacebookConnector::handlePermissionsGranted: result' + ObjectPrinter.print(result) + ' fail ' + ObjectPrinter.print(fail));
			// if (!fail) {
			_isRechecking = true;
			// _reconnectTimer.reset();
			checkPermissions();
			// }
			// getAcessTokens();
		}

		private function getAcessTokens() : void {
			Facebook.api('/me/accounts', getAccessTokenResponse);
		}

		private function getAccessTokenResponse(response : Object, fail : Object) : void {
			trace('FacebookConnector::getAccessTokenResponse:' + response);
			if (response != null) {
				trace('FacebookConnector::getAccessTokenResponse:response.l ' + response.length);
				for (var i : int = 0; i < response.length; i++) {
					trace('FacebookConnector::getAccessTokenResponse: response[i]id ' + response[i]['id']);
					trace('FacebookConnector::getAccessTokenResponse: response[i]name ' + response[i]['name']);
					trace('FacebookConnector::getAccessTokenResponse: response[i]category ' + response[i]['category']);
					trace('FacebookConnector::getAccessTokenResponse: response[i]access_token ' + response[i]['access_token']);
				}
			} else {
				trace('FacebookConnector::getAccessTokenResponse:FAIL:' + ObjectPrinter.print(fail), Debug.ERROR);
				_blocker.showMsgByKey('upload.fail');
			}
		}

		private function promptUpload(isNewAlbum : Boolean) : void {
			var titleKey : String = 'facebook.confirmUpload.title.alt';
			var contentKey : String = 'facebook.confirmUpload.content.alt';

			if (isNewAlbum) {
				titleKey = 'facebook.confirmUpload.title';
				contentKey = 'facebook.confirmUpload.content' + (isPublicPost ? '.public' : '');
			} else if (isCompetitionPost) {
				titleKey = 'facebook.confirmUpload.competition.title';
				contentKey = 'facebook.confirmUpload.competition.content';
			}
			if (!_confirmUplaodDialog) {
				_confirmUplaodDialog = new ConfirmationPopup(titleKey, contentKey, 'facebook.confirmUpload.ok', 'facebook.confirmUpload.cancel') as ConfirmationPopup;
				_confirmUplaodDialog.addEventListener(ConfirmationPopup.CANCEL, _blocker.hide);
				_confirmUplaodDialog.confirmButton.addEventListener(MouseEvent.CLICK, uploadToFacebook);
			}
			_confirmUplaodDialog.titleKey = titleKey;
			_confirmUplaodDialog.contentKey = contentKey;
			_confirmUplaodDialog.cancelAllowed = !isCompetitionPost;
			_confirmUplaodDialog.show();
		}

		private function upload(event : Event) : void {
			switch(_currentPostType) {
				case COMPETITION_POST_TYPE:
					saveCompetitionEntry();
					break;
				default:
					uploadToFacebook(event);
			}
		}

		private function uploadToFacebook(event : Event) : void {
			// _blocker.showCancelButton(60000);
			_uploadInProgress = true;

			var uploadDialog : FacebookUploadPictureDialog = isCollabPost ? _collabDialog : _uploadDialog;

			var caption : String;

			if (isCollabPost) {
				caption = 'Collaboration sent to ' + _collabDialog.selectedFriend.name;
			} else {
				if (uploadDialog.captionInputEmpty) {
					caption = '';
				} else {
					caption = uploadDialog.caption;
				}
			}

			// _currentImagePost = {message:caption,// caption+'made using '+ _appName + ' (' + _pageUrl + ')' ,
			// fileName:'graffiti_swat_' + _currentSurface + '_' + new Date().getTime() + '.jpg', source:getCurrentImageCompressed()};

			var url : String =  "https://graph.facebook.com/"+_albumId + "/photos";
			var fileName : String = 'graffiti_swat_' + _currentSurface + '_' + new Date().getTime() + '.jpg';

			_currentImagePost = {};
			_currentImagePost.message = caption;
			_currentImagePost.fileName=fileName;
			// param.no_story = _objectQueue.no_story;
			_currentImagePost.access_token = Facebook.getAccessToken();
			_currentImagePost.source=getCurrentImageCompressed();
			_currentImagePost.no_story=false;
		
			var urlRequest : URLRequest = new URLRequest();
			urlRequest.url = url;
			urlRequest.requestHeaders.push(new URLRequestHeader('Content-Type', 'multipart/form-data; boundary=' + UploadPostHelper.getBoundary()));
			urlRequest.method = URLRequestMethod.POST;
			urlRequest.data = UploadPostHelper.getPostData(fileName, _currentImagePost.source, "source", _currentImagePost);
			
			
			
			

			/*_currentImagePost = {
			message : caption,  
			source : getCurrentImageCompressed()
			};*/

			// var imagePost : Object = {message : caption+'made using '+ _appName + ' (' + _pageUrl + ')' , fileName : 'Graffiti_' + (new Date()).getTime()+'.jpg', image : getCurrentImageCompressed()};

			_triedPHPUpload = false;

			if (_albumId.length > 0 && _albumId != "0") {
				// trace(ObjectUtils.inspect(_currentImagePost));

				// Facebook.api(_albumId + '/photos', handlePostAlbumComplete, _currentImagePost, 'POST');
				trace('FacebookConnector::uploadToFacebook: _triedPHPUpload' + _triedPHPUpload);

				clearUrlLoaderWrapper();

				if (!_urlLoaderWrapper) {
					_urlLoaderWrapper = new URLoaderWrapper();
				}
				_urlLoaderWrapper.loadRequest(uploadImageToAlbumCallback, urlRequest, URLLoaderDataFormat.BINARY);
				// uploadViaPHP(_currentImagePost);
				if (!isCollabPost) _blocker.animateCircle();
				// _blocker.showMsgByKey('upload.inprocess'+(isPublicPost?'.public':''));
			} else {
				getAlbumIdFromFB();
			}
		}

		private function clearUrlLoaderWrapper() : void {
			if (_urlLoaderWrapper) {
				_urlLoaderWrapper.dispose();
				_urlLoaderWrapper = null;
			}
		}

		private function uploadImageToAlbumCallback(type_ : String, data_ : Object) : void {
			clearUrlLoaderWrapper();
			
			trace(ObjectUtils.inspect(data_));

			if (type_ == URLoaderWrapper.ERROR) {
				handlePostAlbumComplete(null, {error:"ERROR"});
				return;
			}
			if (data_) {
				var result : Object = JSON.parse(data_.data);
				trace(ObjectUtils.inspect(result));
				if (result.id) {
					handlePostAlbumComplete(result, null);
					return;
				}
			}
			handlePostAlbumComplete(null, {error:"ERROR"});
		}

		private function uploadViaPHP(imagePost : Object) : void {
			_triedPHPUpload = true;
			// Facebook.api(_albumId + '/photos', handlePostAlbumComplete, imagePost, 'POST');

			var bytes : ByteArray = imagePost.source;

			var variables : URLVariables = new URLVariables();
			variables.message = imagePost.message;
			variables.filename = imagePost.fileName;
			variables.albumId = _albumId;
			variables.access_token = Facebook.getAccessToken();
			variables.source=imagePost.source;

			var request : URLRequest = new URLRequest(BASE_URL_SECURE+"php/action/secure/chr0MeEx7.php" + '?' + variables.toString());
			var header : URLRequestHeader = new URLRequestHeader("Content-type", "application/octet-stream");
			// var loader: URLLoader = new URLLoader();
			request.requestHeaders.push(header);
			request.method = URLRequestMethod.POST;
			request.data = bytes;

			var loader : URLLoader = new URLLoader(request);
			loader.addEventListener(Event.COMPLETE, handlePostAlbumPHPComplete);
			loader.addEventListener(IOErrorEvent.IO_ERROR, handlePostAlbumPHPComplete);
			loader.load(request);
		}

		private function addCollaborators() : String {
			return isCollab ? ((_collaborators.length > 0 ? _collaborators.length + ' ' : '') + 'other ' + (_collaborators.length != 1 ? 'people' : 'person')) : '';
		}

		private function getCurrentImageCompressed() : ByteArray {
			// return new JPEGEncoder(80).encode(_currentImage);
			var b:BitmapData=_currentImage.clone();
			return b.encode(b.rect, new JPEGEncoderOptions(80));
		}

		private function handlePostAlbumPHPComplete(event : Event) : void {
			var json : Object;
			var response : Object;
			var fail : Object;

			if (event.type == Event.COMPLETE) {
				try {
					var jsonString : String = event.target.data;
					json = JSON.parse(jsonString);
					if (json["1"]) {
						fail = json["1"];
						response = json["0"];
					} else {
						response = json;
					}
				} catch(error : Error) {
					trace('FacebookConnector::handlePostAlbumPHPComplete:' + jsonString, Debug.ERROR);
					fail = {"error":"flash:could not parse " + event.target.data};
				}
			} else {
				trace('FacebookConnector::handlePostAlbumPHPComplete:' + event.toString(), Debug.ERROR);
				fail = {"error":"flash:event.type is " + event.toString()};
			}
			handlePostAlbumComplete(response, fail);
		}

		private function handlePostAlbumComplete(response : Object, fail : Object) : void {
			_uploadInProgress = false;
			_postSuccessful = response != null && response.id;
			if (_postSuccessful) {
				trace('FacebookConnector::handlePostAlbumComplete: Successfully uploaded response.id ' + response.id);
				if (isPublicPost) {
					saveGalleryEntry(response.id);
				} else if (!isCollabPost) {
					_blocker.showMsgByKey('upload.inprocess' + (isPublicPost ? '.public' : ''));
				}

				if (isFriendWallPost || isCollabPost || isCollab) {
					getPhotoSrc(response.id);
				}
				// if(_collaborators.length > 0){
				// var tags : String = "[[id : "+_userId+"]";
				// for each (var collaborator : String in _collaborators) {
				// tags +=",[id : "+collaborator+"]";
				// Facebook.api(response.id + '/tags', handleTagComplete, {to : collaborator, x : 0, y : 0}, 'POST');
				// }
				// tags +="]";
				// var tagPost : Object = {tags : tags};
				// Facebook.api(response.id + '/tags', handleTagComplete, {to : _userId, x : 0, y : 0}, 'POST');
				// }
			} else {
				// if (_triedPHPUpload || !_currentImagePost){
				if (response && response["error"] && response["error"]["code"] == "321") {
					handleAlbumFull();
				} else {
					if (_triedPHPUpload) {
						trace('FacebookConnector::handlePostAlbumComplete:FAIL:' + ObjectPrinter.print(fail) + ':RESPONSE:' + ObjectPrinter.print(response), Debug.ERROR);
						_blocker.showMsgByKey('upload.fail');
					} else {
						uploadViaPHP(_currentImagePost);
					}
				}
				// } else {
				// uploadViaPHP(_currentImagePost);
				// }
			}
		}

		private function handleAlbumFull() : void {
			promptRenameAlbum();
		}

		private function promptRenameAlbum() : void {
			if (!_albumFullDialog) {
				_albumFullDialog = new ConfirmationPopup('facebook.albumFull.title', 'facebook.albumFull.content', 'facebook.albumFull.ok', 'facebook.albumFull.cancel') as ConfirmationPopup;
				_albumFullDialog.addEventListener(ConfirmationPopup.CANCEL, _blocker.hide);
				_albumFullDialog.confirmButton.addEventListener(MouseEvent.CLICK, createAlbum);
			}
			_albumFullDialog.show();
		}

		private function handleTagComplete(response : Object, fail : Object) : void {
			trace('FacebookConnector::handleTagComplete:response ' + response + ' fail ' + fail);
		}

		private function getPhotoSrc(photoId : String) : void {
			trace('FacebookConnector::getPhotoSrc:');
			var callback : Function;
			if (isCollabPost) {
				trace('FacebookConnector::getPhotoSrc:isCollabPost');
				callback = prepareSaveCollab;
			} else if (isFriendWallPost) {
				trace('FacebookConnector::getPhotoSrc:isFriendWallPost');
				callback = postToFriendWall;
			} else if (isCollab) {
				trace('FacebookConnector::getPhotoSrc:isCollab');
				callback = completeCollab;
			}

			if (callback != null) Facebook.api(photoId, callback);
		}

		private function postToFriendWall(response : Object, fail : Object) : void {
			if (response != null) {
				trace('FacebookConnector::handleGetPhotoSrc: Successfully uploaded response ' + response + ' name ' + response['link']);
				// ExternalInterface.call('showMultiFriendsDialog');
				// ExternalInterface.call('pissoff');
			} else {
				trace('FacebookConnector::postToFriendWall:FAIL:' + ObjectPrinter.print(fail), Debug.ERROR);
				_blocker.showMsgByKey('wallpost.fail');
			}
		}

		private function postLinkToWall(response : Object, fail : Object) : void {
			if (response != null) {
				trace('FacebookConnector::handleGetPhotoSrc: Successfully uploaded response ' + response + ' name ' + response['link']);
				var link : String = response['link'];
				var wallPost : Object = {link:link};
				Facebook.api('links', handleFeedComplete, wallPost, 'POST');
			} else {
				trace('FacebookConnector::postLinkToWall:FAIL:' + ObjectPrinter.print(fail), Debug.ERROR);
				_blocker.showMsgByKey('wallpost.fail');
			}
		}

		private function localizeVarByLocaleKey(localeKey : String, variableKey : String, variable : String) : String {
			return localizeVar(ApplicationFacade.getCopy(localeKey), variableKey, variable);
		}

		private function localizeVarByPropertyKey(localeKey : String, variableKey : String, variable : String) : String {
			return localizeVar(ApplicationFacade.getProperty(localeKey), variableKey, variable);
		}

		private function localizeVar(localized : String, variableKey : String, variable : String) : String {
			variableKey = '$' + variableKey + '$';
			var variableStart : int = localized.indexOf(variableKey);
			if (variableStart >= 0) {
				localized = localized.substring(0, variableStart) + variable + localized.substring(variableStart + variableKey.length);
			}
			return localized;
		}

		private function handleFeedComplete(response : Object, fail : Object) : void {
			_postSuccessful = response != null;
			if (_postSuccessful) {
				trace('FacebookConnector::handleUploadComplete: Successfully uploaded response' + response);
			} else {
				trace('FacebookConnector::handleFeedComplete:RESPONSE:' + ObjectPrinter.print(response) + ':FAIL:' + ObjectPrinter.print(fail), Debug.ERROR);
				_blocker.showMsgByKey('wallpost.fail');
			}
		}

		private function getAlbumIdFromFB() : void {
			var values : * = {"fields":"name,id"};

			if (_albumId.length == 0 || _albumId == "0") {
				trace('FacebookConnector::getAlbumId:');
				Facebook.api('/me/albums', handleGetUserAlbums, values);
			} else {
				Facebook.api('/' + _albumId, handleVerifyAlbumId, values);
			}
		}

		private function handleVerifyAlbumId(response : Object, fail : Object) : void {
			trace('FacebookConnector::handleVerifyAlbumId: response ' + response + ' fail ' + fail + ' r ' + ObjectPrinter.print(response) + ' f ' + ObjectPrinter.print(fail));
			if (!response || !response.id) {
				trace('FacebookConnector::handleVerifyAlbumId:' + _albumId + ':RESPONSE:' + ObjectPrinter.print(response) + ',FAIL:' + ObjectPrinter.print(fail) + '[' + fail + ']', Debug.ERROR);
				_albumId = "";
				getAlbumIdFromFB();
			}
		}

		private function handleGetUserAlbums(response : Object, fail : Object) : void {
			trace('FacebookConnector::handleGetAlbums: response ' + ObjectPrinter.print(response));
			if (response != null) {
				for (var key : String in response) {
					if (response[key]['name'] == _albumName) {
						trace('FacebookConnector::handleGetUserAlbums:foundPrivate');
						_albumId = response[key]['id'];
						saveAlbumId(true);
						if (_uploadInProgress) promptUpload(false);
						break;
					}
				}
				trace('FacebookConnector::handleGetUserAlbums:_albumId ' + _albumId + ' _albumId.length ' + _albumId.length + ' _uploadInProgress ' + _uploadInProgress);
				// if(!_albumId)_albumId="0";
				if ((_albumId.length == 0 || _albumId == "0") && _uploadInProgress) {
					createAlbum();
				}
			} else {
				if (_uploadInProgress) {
					_blocker.showMsgByKey('upload.fail');
					trace('FacebookConnector::handleGetUserAlbums:RESPONSE:' + ObjectPrinter.print(response) + ',FAIL:' + ObjectPrinter.print(fail) + '--fail:' + fail, Debug.ERROR);
				}
			}
		}

		private function createAlbum(event : Event = null) : void {
			trace('FacebookConnector::createAlbum: ' + _albumCount);
			_albumCount++;
			if (_albumCount > 1) {
				_albumName = _albumName + ' ' + _albumCount;
			}
			var privacy : String = '{"value":"EVERYONE",value:"EVERYONE"}';
			var values : Object = {message:ApplicationFacade.getCopy('facebook.album.description'), name:_albumName};
			if (isPublicPost) {
				values.privacy = privacy;
			}

			Facebook.api('/me/albums', handleCreatedAlbum, values, 'POST');
		}

		private function handleCreatedAlbum(response : Object, fail : Object) : void {
			trace('FacebookConnector::handleCreatedAlbum: ' + ObjectUtils.inspect(response));
			if (response && response['id']) {
				_albumId = response['id'];
				saveAlbumId();
				promptUpload(true);
			} else {
				trace('FacebookConnector::handleCreatedAlbum:RESPONSE:' + ObjectPrinter.print(response) + 'FAIL:' + ObjectPrinter.print(fail), Debug.ERROR);
				_blocker.showMsgByKey('upload.fail');
			}
		}

		private function saveAlbumId(existing : Boolean = false) : void {
			var variables : URLVariables = new URLVariables();
			var key : String = Encrypt.createRandomKey(LessMath.rand(5, 10));

			variables.chunks = Simplecrypt.encrypt(_userId, key);
			variables.gid = key;
			variables.album_id = _albumId;
			variables.existing = (_albumCount > 0 && existing).toString();
			trace('FacebookConnector::saveAlbumId:_albumCount ' + _albumCount + ' existing ' + existing + ' variables.existing ' + variables.existing);

			var request : URLRequest = new URLRequest(BASE_URL_SECURE+"php/action/secure/K8MmI11Ee.php");
			request.method = URLRequestMethod.POST;
			request.data = variables;

			var loader : URLLoader = new URLLoader(request);
			loader.addEventListener(Event.COMPLETE, handleSaveAlbumIdComplete);
			loader.addEventListener(IOErrorEvent.IO_ERROR, handleSaveAlbumIdComplete);
			loader.load(request);
		}

		private function handleSaveAlbumIdComplete(event : Event) : void {
			if (event.type == Event.COMPLETE) {
				trace('handleSaveAlbumIdComplete: ' + ObjectUtils.inspect(event.target.data));
				try {
					var jsonString : String = event.target.data;
					var response : Object = JSON.parse(jsonString);
					if (response && response["album_count"]) {
						_albumCount = int(response["album_count"]);
					} else {
						trace('FacebookConnector::handlePostAlbumPHPComplete:' + jsonString, Debug.ERROR);
					}
				} catch(error : Error) {
					trace('FacebookConnector::handlePostAlbumPHPComplete:' + jsonString, Debug.ERROR);
				}
			} else {
				trace('FacebookConnector::handleSaveAlbumIdComplete:' + ObjectPrinter.print(event), Debug.ERROR);
			}
		}

		private function prepareSaveCollab(response : Object, fail : Object) : void {
			trace("prepareSaveCollab: "+ObjectUtils.inspect(response));
			if (response != null) {
				_collabImgLink = response['link'];
				_collabImgSrc = response['picture'];
			}
			saveCollab(_collabDialog.selectedFriend.fbid, response['link']);
		}

		private function saveCollab(recipient : String, albumlink : String = '', overrideGraffiti : Boolean = false) : void {
			trace('FacebookConnector::saveCollab:_collabImgLink ' + _collabImgLink);

			var bytes : ByteArray = _collabCanvas.encode(_collabCanvas.rect, new PNGEncoderOptions(false));
			// PNGEncoder.encode(_collabCanvas);

			var variables : URLVariables = new URLVariables();
			variables.filename = 'graffiti_swat_' + _collabSurface + '_' + new Date().getTime() + '.png';
			variables.fbid = _userId;
			variables.friend_id = recipient;
			variables.surface_key = _collabSurface;
			variables.collab_id = _collabid.toString();
			variables.overrideGraffiti = overrideGraffiti.toString();

			var key : String = Encrypt.createRandomKey(LessMath.rand(5, 10));
			variables.chunks = Simplecrypt.encrypt(_appId, key);
			variables.gid = key;

			if (albumlink != '') {
				variables.albumlink = albumlink;
			}

			_collabCanvasSrc = variables.filename;

			var request : URLRequest = new URLRequest(BASE_URL_SECURE+"php/action/secure/s5ni4FSiizo0.php" + '?' + variables.toString());
			var header : URLRequestHeader = new URLRequestHeader("Content-type", "application/octet-stream");
			// var loader: URLLoader = new URLLoader();
			request.requestHeaders.push(header);
			request.method = URLRequestMethod.POST;
			request.data = bytes;

			var loader : URLLoader = new URLLoader(request);
			loader.addEventListener(Event.COMPLETE, onCollabSaved);
			loader.addEventListener(IOErrorEvent.IO_ERROR, onCollabSaved);
			loader.load(request);
			// send fb message
		}

		private function onCollabSaved(event : Event) : void {
			_savedCollabId = int(event.target.data);
			if (event.type == Event.COMPLETE && (isSaveForLater || _savedCollabId > 0)) {
				if (isSaveForLater) {
					if (_savedCollabId > 0) {
						_blocker.showMsgByKey('upload.saveforlater.sucess');
					} else {
						var response : Array = String(event.target.data).split('::');
						var status : String = response.length > 0 ? response[0] : response.toString();
						var error_key : String = response.length > 1 ? response[1] : '';

						if (error_key == 'cant_save_twice') {
							showOverrideDialog();
						} else {
							trace('FacebookConnector::onCollabSaved:saveForLater:FAIL:' + event.target.data, Debug.ERROR);
							_blocker.showMsgByKey('saveForLater.failed.db');
						}
					}
				} else {
					sendCollabRequest();
				}
				// completeCollabRequest();
			} else {
				trace('FacebookConnector::onCollabSaved:' + (isSaveForLater ? 'saveForLater' : 'sendCollab') + ':FAIL:(data=' + event.target.data + ',event.type=' + event.type + ')', Debug.ERROR);
				_blocker.showMsgByKey((isSaveForLater ? 'saveForLater' : 'sendCollab') + '.failed.db');
			}
		}

		private function showOverrideDialog() : void {
			if (!_overrideDialog) {
				_overrideDialog = new ConfirmationPopup('saveForLater.override.title', 'saveForLater.override.content', 'saveForLater.override.confirm') as ConfirmationPopup;
				_overrideDialog.addEventListener(ConfirmationPopup.CANCEL, _blocker.hide);
				_overrideDialog.confirmButton.addEventListener(MouseEvent.CLICK, overrideSavedGraffiti);
			}
			_overrideDialog.show();
		}

		private function overrideSavedGraffiti(event : MouseEvent) : void {
			saveCollab(_userId, '', true);
		}

		private function sendCollabRequest(event : Event = null) : void {
			var name : String = localizeVarByLocaleKey('facebook.sendCollab.name', 'username', _userFirstName);
			name = localizeVar(name, 'friendname', _collabDialog.selectedFriend.name);

			var values : Object = {to:_collabDialog.selectedFriend.fbid, message:name, data:{type:'collab', collab_id:_savedCollabId}};
			Facebook.ui('apprequests', values, handleCollabSent);
		}

		private function handleCollabSent(response : Object, fail : Object = null) : void {
			trace('FacebookConnector::handleCollabSent: ' + response);
			if (response) {
				var requestID : String = response['request'];
				if (requestID && requestID != '') {
					saveCollabRequestId(requestID);
				}
				_blocker.showMsgByKey('sendCollab.message.success');
			} else {
				if (!_cancelCollabMessageDialog) {
					_cancelCollabMessageDialog = new ConfirmationPopup('sendCollab.message.cancel.title', 'sendCollab.message.cancel.content', 'sendCollab.message.cancel.confirm') as ConfirmationPopup;
					_cancelCollabMessageDialog.addEventListener(ConfirmationPopup.CANCEL, cancelCollab);
					_cancelCollabMessageDialog.confirmButton.addEventListener(MouseEvent.CLICK, sendCollabRequest);
				}
				_cancelCollabMessageDialog.show();
			}
		}

		private function saveCollabRequestId(requestID : String) : void {
			var variables : URLVariables = new URLVariables();
			var key : String = Encrypt.createRandomKey(LessMath.rand(5, 10));

			variables.chunks = Simplecrypt.encrypt(_savedCollabId.toString(), key);
			variables.gid = key;
			variables.request_id = requestID;

			var request : URLRequest = new URLRequest(BASE_URL_SECURE+"php/action/secure/l00nIZ998.php");
			request.method = URLRequestMethod.POST;
			request.data = variables;

			var loader : URLLoader = new URLLoader(request);
			loader.load(request);
		}

		private function cancelCollab(event : Event) : void {
			_postSuccessful = false;
			_blocker.hide();

			var variables : URLVariables = new URLVariables();
			var key : String = Encrypt.createRandomKey(LessMath.rand(5, 10));

			variables.chunks = Simplecrypt.encrypt(_userId, key);
			variables.gid = key;
			variables.collab_id = _savedCollabId.toString();

			var request : URLRequest = new URLRequest(BASE_URL_SECURE+"php/action/secure/n8i9SPi45iZ.php");
			request.method = URLRequestMethod.POST;
			request.data = variables;

			var loader : URLLoader = new URLLoader(request);
			loader.load(request);
		}

		private function completeCollab(response : Object, fail : Object = null) : void {
			trace('FacebookConnector::completeCollab:response ' + response + ' fail ' + fail);
			if (response) {
				var variables : URLVariables = new URLVariables();
				var key : String = Encrypt.createRandomKey(LessMath.rand(5, 10));

				variables.chunks = Simplecrypt.encrypt(_userId, key);
				variables.gid = key;
				variables.collab_id = _collabid.toString();
				variables.albumlink = response['link'];

				var request : URLRequest = new URLRequest(BASE_URL_SECURE+"php/action/secure/u4Pn3_ISWzIli0.php");
				request.method = URLRequestMethod.POST;
				request.data = variables;

				var loader : URLLoader = new URLLoader(request);
				loader.load(request);

				// completeCollabRequest();
			}
		}

		// private function completeCollabRequest() : void {
		// trace('FacebookConnector::completeCollabRequest:'+'/'+_collabRequestId);
		// if (_collabRequestId && _collabRequestId != '') Facebook.api(_collabRequestId, onDeletedRequest , {method : 'delete'} , 'POST');
		// }
		// private function onDeletedRequest(response : Object, fail : Object = null) : void {
		// trace('FacebookConnector::onDeletedRequest:response '+response+' fail '+fail);
		// if (response){
		// _collabRequestId = '';
		// }
		// }
		private function saveGalleryEntry(imageid : String) : void {
			var bytes : ByteArray = getCurrentImageCompressed();

			var variables : URLVariables = new URLVariables();
			variables.fbid = imageid;
			variables.uid = _userId;
			variables.surface_key = _currentSurface;
			variables.caption = _uploadDialog.captionInputEmpty ? '' : _uploadDialog.caption;
			variables.filename = 'graffiti_swat_' + _currentSurface + '_' + new Date().getTime();

			var key : String = Encrypt.createRandomKey(LessMath.rand(5, 10));
			variables.chunks = Simplecrypt.encrypt(_appId, key);
			variables.gid = key;

			if (isCollab) {
				variables.collab_id = _collabid;
				variables.collaborators = _collaborators.toString();
			} else if (isCompetitionPost) {
				variables.pngSrc = _competitionFilename;
			}

			var request : URLRequest = new URLRequest(BASE_URL_SECURE+"php/action/secure/k27bo0HjWx.php" + '?' + variables.toString());
			var header : URLRequestHeader = new URLRequestHeader("Content-type", "application/octet-stream");
			// var loader: URLLoader = new URLLoader();
			request.requestHeaders.push(header);
			request.method = URLRequestMethod.POST;
			request.data = bytes;

			var loader : URLLoader = new URLLoader(request);
			loader.addEventListener(Event.COMPLETE, onGalleryEntrySaved);
			loader.addEventListener(IOErrorEvent.IO_ERROR, onGalleryEntrySaved);
			loader.load(request);
		}

		private function onGalleryEntrySaved(event : Event) : void {
			var status : String = 'failed';
			var entryId : String = '';
			var entrySrc : String = '';
			if (event.type == Event.COMPLETE) {
				var response : Array = String(event.target.data).split('::');
				status = response.length > 0 ? response[0] : response.toString();
				entryId = response.length > 1 ? response[1] : '';
				entrySrc = response.length > 2 ? response[2] : '';
				trace('FacebookConnector::onGalleryEntrySaved: Successfully uploaded entryId ' + entryId + ' entrySrc ' + entrySrc);
			}
			if ( status == 'success') {
				completeGalleryPost(entryId, entrySrc);
			} else {
				_blocker.showMsgByKey('upload.public.fail');
			}
		}

		private function completeGalleryPost(entryId : String, entrySrc : String) : void {
			_blocker.showMsgByKey('upload.inprocess' + (isPublicPost ? '.public' : ''));
			postGalleryPicToWall(entryId, entrySrc);
		}

		private function postGalleryPicToWall(entryId : String, entrySrc : String) : void {
			if (entryId != '' && entrySrc != '') {
				trace('FacebookConnector::handleGetPhotoSrc: Successfully uploaded entryId ' + entryId + ' entrySrc ' + entrySrc);
				// var picture : String = localizeVarByPropertyKey('facebook.feed.gallery.picture','src',entrySrc);
				var caption : String = ApplicationFacade.getProperty('page.url');
				var link : String = localizeVarByPropertyKey('facebook.feed.gallery.link', 'id', entryId);
				link = localizeVar(link, 'appserver', _appServerUrl);

				var imageCaption : String = _uploadDialog.captionInputEmpty ? ApplicationFacade.getCopy('facebook.feed.gallery.noimagetitle') : '"' + _uploadDialog.caption + '"' ;
				var message : String = localizeVarByLocaleKey('facebook.feed.gallery' + (isCompetitionPost ? '.competition' : '') + '.message', 'graffTitle', imageCaption);
				var name : String;
				if (_userFullName == null) {
					name = ApplicationFacade.getCopy('facebook.feed.gallery' + (isCompetitionPost ? '.competition' : '') + '.name.alt');
				} else {
					name = localizeVarByLocaleKey('facebook.feed.gallery' + (isCompetitionPost ? '.competition' : '') + '.name', 'userFirstName', _userFirstName);
				}
				trace('FacebookConnector::handleGetPhotoSrc:name ' + name);
				var description : String = ApplicationFacade.getCopy('facebook.feed.gallery.description');
				// var source:String = ApplicationFacade.getCopy('facebook.feed.gallery.source');

				var wallPost : Object = {message:message, link:link,/*picture : picture, */ caption:caption, name:name, description:description};
				
				//trace(ObjectUtils.inspect(wallPost));
				Facebook.api('me/feed', handleFeedComplete, wallPost, 'POST');
			} else {
				trace('FacebookConnector::postGalleryPicToWall:FAIL: entryId=' + entryId + ', entrySrc=' + entrySrc, Debug.ERROR);
				_blocker.showMsgByKey('wallpost.fail');
			}
		}

		/*
		 * WORKS, BUT A STORY IS WAY SMALLER AND INVISIBLE
		 */
		// private function postGalleryPicAsStory(entryId : String, entrySrc : String):void{
		// if (entryId != '') {
		// trace('FacebookConnector::postGalleryPicAsStory: Successfully uploaded entryId ' + entryId + ' entrySrc ' + entrySrc);
		//
		// var graffitiLink : String = localizeVarByPropertyKey('facebook.feed.gallery.link','id',entryId);
		// graffitiLink= localizeVar(graffitiLink,'appalias',_appAlias);
		//
		// var graffiti : Object = {"graffiti" : graffitiLink};
		//
		// var openstory : String = 'me/'+_appAlias+':post';
		// trace('FacebookConnector::postGalleryPicAsStory: openstory ' + openstory + ' graffiti ' + ObjectPrinter.print(graffiti));
		//
		// Facebook.api(openstory, handleFeedComplete, graffiti, 'POST');
		// } else {
		// trace('FacebookConnector::postGalleryPicAsStory:FAIL: entryId='+entryId+', entrySrc='+entrySrc, Debug.ERROR);
		// _blocker.showMsgByKey('wallpost.fail');
		// }
		// }
		private function saveCompetitionEntry() : void {
			var bytes : ByteArray = _competitionCanvas.encode(_competitionCanvas.rect, new PNGEncoderOptions(false));
			// PNGEncoder.encode(_competitionCanvas);

			var variables : URLVariables = new URLVariables();
			variables.fbid = _userId;
			variables.filename = 'graffiti_swat_' + _currentSurface + '_' + new Date().getTime();

			var key : String = Encrypt.createRandomKey(LessMath.rand(5, 10));
			variables.chunks = Simplecrypt.encrypt(_appId, key);
			variables.gid = key;

			var request : URLRequest = new URLRequest(BASE_URL_SECURE+"php/action/secure/12KB700u.php" + '?' + variables.toString());
			var header : URLRequestHeader = new URLRequestHeader("Content-type", "application/octet-stream");
			// var loader: URLLoader = new URLLoader();
			request.requestHeaders.push(header);
			request.method = URLRequestMethod.POST;
			request.data = bytes;

			var loader : URLLoader = new URLLoader(request);
			loader.addEventListener(Event.COMPLETE, onCompetitionEntrySaved);
			loader.addEventListener(IOErrorEvent.IO_ERROR, onCompetitionEntrySaved);
			loader.load(request);
		}

		private function onCompetitionEntrySaved(event : Event) : void {
			var status : String = 'failed';
			var filename : String = '';
			if (event.type == Event.COMPLETE) {
				var response : Array = String(event.target.data).split('::');
				status = response.length > 0 ? response[0] : response.toString();
				filename = response.length > 1 ? response[1] : '';
			}
			if ( status == 'success' && filename != '') {
				_competitionFilename = filename;
				promptUpload(false);
			} else {
				_blocker.showMsgByKey('upload.public.fail');
			}
		}

		public function promptBuyItem(item : BuyableData) : void {
			_itemToBeBought = item;
			if (_userId != "-1") {
				_blocker.show();
				if (!_confirmBuyDialog) {
					_confirmBuyDialog = new BuyConfirmDialog(item) as BuyConfirmDialog;
					_confirmBuyDialog.addEventListener(ConfirmationPopup.CANCEL, _blocker.hide);
					_confirmBuyDialog.addEventListener(BuyConfirmDialog.TRY_OUT, tryItem);
					_confirmBuyDialog.addEventListener(ConfirmationPopup.CONFIRM, buyItem);
				}
				_confirmBuyDialog.show();
			}
		}

		private function buyItem(event : Event = null) : void {
			_confirmBuyDialog.close();
			_blocker.show(true, 30000);
			_itemToBeBought = _itemToBeBought;

			var request : URLRequest = new URLRequest(BASE_URL_SECURE+"php/facebook/init_payment.php?item_key=" + _itemToBeBought.key + "&item_type=" + _itemToBeBought.type + "&fbid=" + _userId);
			request.method = URLRequestMethod.GET;

			var loader : URLLoader = new URLLoader(request);
			loader.addEventListener(Event.COMPLETE, onInitPayment);
			loader.load(request);
		}

		private function onInitPayment(event : Event) : void {
			var json : Object;
			var jsonString : String = event.target.data;
			json = JSON.parse(jsonString);
			var data : Object = {action:"purchaseitem", product:ApplicationFacade.getProperty('app.baseUrl') + "php/facebook/item_object.php?item_key=" + _itemToBeBought.key + "&item_type=" + _itemToBeBought.type, quantity:1, request_id:json['request_id']};
			Facebook.ui("pay", data, handleBuyItem);
		}

		private function handleBuyItem(response : Object) : void {
			for (var id:String in response) {
				var value : Object = response[id];

				trace(id + " = " + value);
			}

			if (response && response['signed_request']) {
				var request : URLRequest = new URLRequest(BASE_URL_SECURE+"php/facebook/check_payment.php?signed_request=" + response['signed_request']);
				request.method = URLRequestMethod.GET;

				var loader : URLLoader = new URLLoader(request);
				loader.addEventListener(Event.COMPLETE, onPaymentCheck);
				loader.load(request);
			}

			_blocker.hide();
		}

		private function onPaymentCheck(event : Event) : void {
			var json : Object;
			var jsonString : String = event.target.data;
			json = JSON.parse(jsonString);
			if (json['status'] == 'completed') {
				onItemBoughtSuccess();
			} else {
			}
		}

		private function onItemBoughtSuccess() : void {
			trace('FacebookConnector::onItemBoughtSuccess:');
			_itemToBeBought.bought = true;
			dispatchEvent(new ItemBuyEvent(ItemBuyEvent.BOUGHT, _itemToBeBought));
		}

		private function tryItem(event : Event = null) : void {
			trace('FacebookConnector::tryItem:');
			var variables : URLVariables = new URLVariables();
			var key : String = Encrypt.createRandomKey(LessMath.rand(5, 10));

			variables.chunks = Simplecrypt.encrypt(_userId, key);
			variables.gid = key;
			variables.item_key = _itemToBeBought.key;
			variables.item_type = _itemToBeBought.type;

			var request : URLRequest = new URLRequest(BASE_URL_SECURE+"php/action/secure/yAt8MiR0o.php");
			request.method = URLRequestMethod.POST;
			request.data = variables;

			var loader : URLLoader = new URLLoader(request);
			loader.addEventListener(Event.COMPLETE, onTriedItemSaved);
			loader.addEventListener(IOErrorEvent.IO_ERROR, onTriedItemSaved);
			loader.load(request);
		}

		private function onTriedItemSaved(event : Event) : void {
			var status : String = 'failed';
			if (event.type == Event.COMPLETE) {
				status = String(event.target.data);
			}

			trace('FacebookConnector::onTriedItemSaved:status ' + status + ' event.type? ' + event.type);
			if ( status == 'settled' ) {
				onItemBoughtSuccess();
				_blocker.hide();
			} else {
				_blocker.showMsgByKey(status == 'canceled' ? 'tryItem.failed.db' : 'tryItem.failed.ioerror');
			}
		}

		public function get isPublicPost() : Boolean {
			return _currentPostType == PUBLIC_POST_TYPE || isCompetitionPost;
		}

		public function get isFriendWallPost() : Boolean {
			return _currentPostType == FRIEND_POST_TYPE;
		}

		public function get isCollabPost() : Boolean {
			return _currentPostType == COLLAB_POST_TYPE;
		}

		public function get isCompetitionPost() : Boolean {
			return _currentPostType == COMPETITION_POST_TYPE;
		}

		public function get isSaveForLater() : Boolean {
			return _currentPostType == SAVE_FOR_LATER_POST_TYPE;
		}

		public function get isCollab() : Boolean {
			return _collabid != "";
		}

		public function get postSuccessful() : Boolean {
			return _postSuccessful;
		}

		public function get currentPostType() : String {
			return _currentPostType;
		}

		public function get downloadBitmap() : BitmapData {
			return _downloadBitmap;
		}

		public function get currentSurface() : String {
			return _currentSurface;
		}
	}
}
