////////////////////////////////////////////////////////////////////////////////
//
//  © 2011 Valentin Simonov
//
////////////////////////////////////////////////////////////////////////////////
package ru.valyard.osc.tuio.connection
{
	import ru.valyard.osc.connection.IOSCConnection;
	import ru.valyard.osc.connection.IOSCConnectionListener;
	import ru.valyard.osc.data.OSCMessage;
	import ru.valyard.osc.tuio.data.TUIOBlob;
	import ru.valyard.osc.tuio.data.TUIOCursor;
	import ru.valyard.osc.tuio.data.TUIOObject;

	/**
	 * Incoming TUIO messages connection. Sits on top of some IOSCConnection.
	 * @author					valyard
	 */
	public class TUIOConnection implements ITUIOConnection, IOSCConnectionListener {
		
		public function TUIOConnection(connection:IOSCConnection) {
			if ( !connection ) throw new ArgumentError( "You must specify an OSC connection!" );
			this._connection = connection;
			this._connection.addListener( this );
		}
		
		//--------------------------------------------------------------------------
		//
		// Private variables
		//
		//--------------------------------------------------------------------------
		
		/**
		 * @private
		 */
		private const _cursorListeners:Vector.<ITUIOCursorListener> = new Vector.<ITUIOCursorListener>();
		
		/**
		 * @private
		 */
		private const _objectListeners:Vector.<ITUIOObjectListener> = new Vector.<ITUIOObjectListener>();
		
		/**
		 * @private
		 */
		private const _blobListeners:Vector.<ITUIOBlobListener> = new Vector.<ITUIOBlobListener>();
		
		/**
		 * @private
		 */
		private const _frameListeners:Vector.<ITUIOFrameListener> = new Vector.<ITUIOFrameListener>();
		
		/**
		 * @private
		 */
		private var _cursorListenersNum:uint;
		
		/**
		 * @private
		 */
		private var _objectListenersNum:uint;
		
		/**
		 * @private
		 */
		private var _blobListenersNum:uint;
		
		/**
		 * @private
		 */
		private var _frameListenersNum:uint;
		
		/**
		 * @private
		 */
		private const _cursorsHASH:Object = new Object();
		
		/**
		 * @private
		 */
		private const _objectsHASH:Object = new Object();
		
		/**
		 * @private
		 */
		private const _blobsHASH:Object = new Object();
		
		//--------------------------------------------------------------------------
		//
		// Public properties
		//
		//--------------------------------------------------------------------------
		
		/**
		 * @private
		 */
		private var _frame:uint;
		
		/**
		 * @inheritDoc
		 */
		public function get currentFrame():uint {
			return this._frame;
		}
		
		/**
		 * @inheritDoc
		 */
		public function get active():Boolean {
			return this._connection.active;
		}
		
		/**
		 * @private
		 */
		private var _connection:IOSCConnection;
		
		/**
		 * @inheritDoc
		 */
		public function get connection():IOSCConnection {
			return this._connection;
		}
		
		//--------------------------------------------------------------------------
		//
		// Public methods
		//
		//--------------------------------------------------------------------------
		
		/**
		 * @inheritDoc
		 */
		public function close():void {
			this._connection.close();
		}
		
		/**
		 * @inheritDoc
		 */
		public function addListener(listener:ITUIOConnectionListener):void {
			if ( listener is ITUIOCursorListener ) {
				if ( this._cursorListeners.indexOf( listener ) > -1 ) return;
				this._cursorListeners.push( listener );
				this._cursorListenersNum += 1;
			} 
			if ( listener is ITUIOBlobListener ) {
				if ( this._blobListeners.indexOf( listener ) > -1 ) return;
				this._blobListeners.push( listener );
				this._blobListenersNum += 1;
			} 
			if ( listener is ITUIOObjectListener ) {
				if ( this._objectListeners.indexOf( listener ) > -1 ) return;
				this._objectListeners.push( listener );
				this._objectListenersNum += 1;
			} 
			if ( listener is ITUIOFrameListener ) {
				if ( this._frameListeners.indexOf( listener ) > -1 ) return;
				this._frameListeners.push( listener );
				this._frameListenersNum += 1;
			}
		}
		
		/**
		 * @inheritDoc
		 */
		public function removeListener(listener:ITUIOConnectionListener):void {
			if ( listener is ITUIOCursorListener ) {
				var index:int = this._cursorListeners.indexOf( listener );
				if ( index == -1 ) return;
				this._cursorListeners.splice( index, 1 );
				this._cursorListenersNum -= 1;
			} 
			if ( listener is ITUIOBlobListener ) {
				index = this._blobListeners.indexOf( listener );
				if ( index == -1 ) return;
				this._blobListeners.splice( index, 1 );
				this._blobListenersNum -= 1;
			} 
			if ( listener is ITUIOObjectListener ) {
				index = this._objectListeners.indexOf( listener );
				if ( index == -1 ) return;
				this._objectListeners.splice( index, 1 );
				this._objectListenersNum -= 1;
			} 
			if ( listener is ITUIOFrameListener ) {
				index = this._frameListeners.indexOf( listener );
				if ( index == -1 ) return;
				this._frameListeners.splice( index, 1 );
				this._frameListenersNum -= 1;
			}
		}
		
		/**
		 * @inheritDoc
		 */
		public function receiveOSCMessage(message:OSCMessage):void {
			switch ( message[0] ) {
				
				case "fseq":
					var newFrame:uint = uint(message[1]);
					if ( newFrame != this._frame ) {
						this._frame = newFrame;
						this.dispatchNewFrame();
					}
					break;
				
				case "set":
					var is2D:Boolean = false;
					var is25D:Boolean = false;
					var is3D:Boolean = false;
					
					if ( message.address.indexOf("/tuio/2D") == 0 ) {
						is2D = true;
						var type:String = "2D";
					} else if ( message.address.indexOf("/tuio/25D") == 0 ) {
						is25D = true;
						type = "25D";
					} else if ( message.address.indexOf("/tuio/3D") == 0 ) {
						is3D = true;
						type = "3D";
					} else return;
					
					var i:uint = 1;
					if (message.address.indexOf("cur") > -1) {
						var s:Number = message[i++];
						var x:Number = message[i++];
						var y:Number = message[i++];
						if ( !is2D ) {
							var z:Number = message[i++];
						} else {
							z = 0;
						}
						var X:Number = message[i++];
						var Y:Number = message[i++];
						if ( !is2D ) {
							var Z:Number = message[i++];
						} else {
							Z = 0;
						}
						var m:Number = message[i++];
						
						var cursor:TUIOCursor = this._cursorsHASH[s];
						if ( cursor ) {
							cursor.update(x, y, z, X, Y, Z, m, this._frame);
							this.dispatchUpdateCursor(cursor);
						} else {
							cursor = new TUIOCursor(type, s, x, y, z, X, Y, Z, m, this._frame);
							this._cursorsHASH[s] = cursor;
							this.dispatchAddCursor(cursor);
						}
						
					} else if (message.address.indexOf("obj") > -1) {
						s = message[i++];
						var id:Number = message[i++];
						x = message[i++];
						y = message[i++];
						if ( !is2D ) {
							z = message[i++];
						} else {
							z = 0;
						}
						var a:Number = message[i++];
						if (is3D) {
							var b:Number = message[i++];
							var c:Number = message[i++];
						} else {
							b = 0;
							c = 0;
						}
						X = message[i++];
						Y = message[i++];
						if ( !is2D ) {
							Z = message[i++];
						} else {
							Z = 0;
						}
						var A:Number = message[i++];
						if (is3D) {
							var B:Number = message[i++];
							var C:Number = message[i++];
						} else {
							B = 0;
							C = 0;
						}
						m = message[i++];
						var r:Number = message[i++];
						
						var object:TUIOObject = this._objectsHASH[s];
						if ( object ) {
							object.update(x, y, z, a, b, c, X, Y, Z, A, B, C, m, r, this._frame);
							this.dispatchUpdateObject(object);
						} else {
							object = new TUIOObject(type, s, id, x, y, z, a, b, c, X, Y, Z, A, B, C, m, r, this._frame);
							this._objectsHASH[s] = object;
							this.dispatchAddObject(object);
						}
						
					} else if (message.address.indexOf("blb") > -1) {
						s = message[i++];
						x = message[i++];
						y = message[i++];
						if ( !is2D ) {
							z = message[i++];
						} else {
							z = 0;
						}
						a = message[i++];
						if (is3D) {
							b = message[i++];
							c = message[i++];
						} else {
							b = 0;
							c = 0;
						}
						var w:Number = message[i++];
						var h:Number = message[i++];
						if (!is3D) {
							var f:Number = message[i++];
							d = 0;
							v = 0;
						} else {
							f = 0;
							var d:Number = message[i++];
							var v:Number = message[i++];
						}
						X = message[i++];
						Y = message[i++];
						if ( !is2D ) {
							Z = message[i++];
						} else {
							Z = 0;
						}
						A = message[i++];
						if (is3D) {
							B = message[i++];
							C = message[i++];
						} else {
							B = 0;
							C = 0;
						}
						m = message[i++];
						r = message[i++];
						
						var blob:TUIOBlob = this._blobsHASH[s];
						if ( blob ) {
							blob.update(x, y, z, a, b, c, w, h, d, f, v, X, Y, Z, A, B, C, m, r, this._frame);
							this.dispatchUpdateBlob(blob);
						} else {
							blob = new TUIOBlob(type, s, x, y, z, a, b, c, w, h, d, f, v, X, Y, Z, A, B, C, m, r, this._frame);
							this._blobsHASH[s] = blob;
							dispatchAddBlob(blob);
						}
						
					} else return;
					
					break;
				
				case "alive":
					var hash:Object = new Object();
					var l:uint = message.length;
					for ( var k:uint = 1; k < l; k++ ) {
						hash[ message[k] ] = true;
					}
					
					if (message.address.indexOf("cur") > -1) {
						for each ( cursor in this._cursorsHASH ) {
							if ( !hash[cursor.sessionID] ) {
								delete this._cursorsHASH[cursor.sessionID];
								this.dispatchRemoveCursor( cursor );						
							}
						}
					} else if (message.address.indexOf("obj") > -1) {
						for each ( object in this._objectsHASH ) {
							if ( !hash[object.sessionID] ) {
								delete this._objectsHASH[object.sessionID];
								this.dispatchRemoveObject( object );						
							}
						}
					} else if (message.address.indexOf("blb") > -1) {
						for each ( blob in this._blobsHASH ) {
							if ( !hash[blob.sessionID] ) {
								delete this._blobsHASH[blob.sessionID];
								this.dispatchRemoveBlob( blob );						
							}
						}
						
					} else return;
					break;
			}
		}
		
		/**
		 * @inheritDoc
		 */
		public function getCursor(id:Number):TUIOCursor {
			return this._cursorsHASH[id];
		}
		
		/**
		 * @inheritDoc
		 */
		public function getObject(id:Number):TUIOObject {
			return this._objectsHASH[id];
		}
		
		/**
		 * @inheritDoc
		 */
		public function getBlob(id:Number):TUIOBlob {
			return this._blobsHASH[id];
		}
		
		//--------------------------------------------------------------------------
		//
		// Overriden methods
		//
		//--------------------------------------------------------------------------
		
		//--------------------------------------------------------------------------
		//
		// Private functions
		//
		//--------------------------------------------------------------------------
		
		/**
		 * @private
		 */
		private function dispatchAddCursor(cursor:TUIOCursor):void {
			for ( var i:uint; i < this._cursorListenersNum; i++ ) {
				this._cursorListeners[i].addTUIOCursor(cursor);
			}
		}
		
		/**
		 * @private
		 */
		private function dispatchUpdateCursor(cursor:TUIOCursor):void {
			for ( var i:uint; i < this._cursorListenersNum; i++ ) {
				this._cursorListeners[i].updateTUIOCursor(cursor);
			}
		}
		
		/**
		 * @private
		 */
		private function dispatchRemoveCursor(cursor:TUIOCursor):void {
			for ( var i:uint; i < this._cursorListenersNum; i++ ) {
				this._cursorListeners[i].removeTUIOCursor(cursor);
			}
		}
		
		/**
		 * @private
		 */
		private function dispatchAddObject(object:TUIOObject):void {
			for ( var i:uint; i < this._objectListenersNum; i++ ) {
				this._objectListeners[i].addTUIOObject(object);
			}
		}
		
		/**
		 * @private
		 */
		private function dispatchUpdateObject(object:TUIOObject):void {
			for ( var i:uint; i < this._objectListenersNum; i++ ) {
				this._objectListeners[i].updateTUIOObject(object);
			}
		}
		
		/**
		 * @private
		 */
		private function dispatchRemoveObject(object:TUIOObject):void {
			for ( var i:uint; i < this._objectListenersNum; i++ ) {
				this._objectListeners[i].removeTUIOObject(object);
			}
		}
		
		/**
		 * @private
		 */
		private function dispatchAddBlob(blob:TUIOBlob):void {
			for ( var i:uint; i < this._blobListenersNum; i++ ) {
				this._blobListeners[i].addTUIOBlob(blob);
			}
		}
		
		/**
		 * @private
		 */
		private function dispatchUpdateBlob(blob:TUIOBlob):void {
			for ( var i:uint; i < this._blobListenersNum; i++ ) {
				this._blobListeners[i].updateTUIOBlob(blob);
			}
		}
		
		/**
		 * @private
		 */
		private function dispatchRemoveBlob(blob:TUIOBlob):void {
			for ( var i:uint; i < this._blobListenersNum; i++ ) {
				this._blobListeners[i].removeTUIOBlob(blob);
			}
		}
		
		/**
		 * @private
		 */
		private function dispatchNewFrame():void {
			for ( var i:uint; i < this._frameListenersNum; i++ ) {
				this._frameListeners[i].newFrame(this._frame);
			}
		}
		
		//--------------------------------------------------------------------------
		//
		// Event handlers
		//
		//--------------------------------------------------------------------------
		
	}
}