////////////////////////////////////////////////////////////////////////////////
//
//  © 2011 Valentin Simonov
//
////////////////////////////////////////////////////////////////////////////////
package ru.valyard.osc.connection {
	
	import flash.errors.IllegalOperationError;
	import flash.events.Event;
	import flash.events.IOErrorEvent;
	import flash.events.ProgressEvent;
	import flash.events.ServerSocketConnectEvent;
	import flash.net.ServerSocket;
	import flash.net.Socket;
	import flash.utils.ByteArray;
	
	import ru.valyard.osc.IOSCMessageFactory;
	import ru.valyard.osc.data.OSCPacket;
	
	/**
	 * Client TCP OSC socket connection
	 * @param host		
	 * @param port		
	 * @param factory	factory for creating OSC messages
	 * @author					valyard
	 */
	public class TCPOSCConnection extends AbstractOSCConnection implements IOSCClientConnection {
		
		public function TCPOSCConnection(host:String = null, port:uint = 0, factory:IOSCMessageFactory = null) {
			super(factory);
			
			this._host = host;
			this._port = port;
			if ( this._host && this._port ) this.connect();
		}
		
		//--------------------------------------------------------------------------
		//
		// Private variables
		//
		//--------------------------------------------------------------------------
		
		/**
		 * @private
		 */
		private var _host:String;
		
		/**
		 * @private
		 */
		private var _port:uint;
		
		/**
		 * @private
		 */
		private var _socket:Socket;
		
		//--------------------------------------------------------------------------
		//
		// Public properties
		//
		//--------------------------------------------------------------------------
		
		/**
		 * @inheritDoc
		 */
		public function get active():Boolean {
			return this._socket && this._socket.connected;
		}
		
		//--------------------------------------------------------------------------
		//
		// Public methods
		//
		//--------------------------------------------------------------------------
		
		/**
		 * @inheritDoc
		 */
		public function connect(host:String = null, port:uint = 0):void {
			try {
				this.killSocket();
				
				this._socket = new Socket();
				this._socket.addEventListener(Event.CONNECT, this.handler_connect);
				this._socket.addEventListener(IOErrorEvent.IO_ERROR, this.handler_ioError);
				this._socket.addEventListener(IOErrorEvent.NETWORK_ERROR, this.handler_ioError);
				this._socket.addEventListener(ProgressEvent.SOCKET_DATA, this.handler_data);
				this._socket.addEventListener(Event.CLOSE, this.handler_close );
				
				if ( host ) {
					this._host = host;
				}
				if ( port ) {
					this._port = port;
				}
				this._socket.connect( this._host, this._port );
			} catch ( e:Error ) {
				super.dispatchEvent( new IOErrorEvent(IOErrorEvent.NETWORK_ERROR, false, false, e.message) );
			}
		}
		
		/**
		 * @inheritDoc
		 */
		public function send(packet:OSCPacket):void {
			if ( !this._socket || !this._socket.connected ) return;
			this._socket.writeBytes( super.factory.writeOSCPacket(packet) );
			this._socket.flush();
		}
		
		/**
		 * @inheritDoc
		 */
		public function close():void {
			this.killSocket() 
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
		private function killSocket():void {
			if ( this._socket ) {
				this._socket.removeEventListener(Event.CONNECT, this.handler_connect);
				this._socket.removeEventListener(IOErrorEvent.IO_ERROR, this.handler_ioError);
				this._socket.removeEventListener(IOErrorEvent.NETWORK_ERROR, this.handler_ioError);
				this._socket.removeEventListener(ProgressEvent.SOCKET_DATA, this.handler_data);
				this._socket.removeEventListener(Event.CLOSE, this.handler_close );
				if ( this._socket.connected ) this._socket.close();
				this._socket = null;
			}
		}
		
		//--------------------------------------------------------------------------
		//
		// Event handlers
		//
		//--------------------------------------------------------------------------
		
		/**
		 * @private
		 */
		private function handler_data(event:ProgressEvent):void {
			var buffer:ByteArray = new ByteArray();
			this._socket.readBytes( buffer, 0, this._socket.bytesAvailable );
			super.dispatchData( buffer );
		}
		
		/**
		 * @private
		 */
		private function handler_connect(event:Event):void {
			super.dispatchEvent( event );
		}
		
		/**
		 * @private
		 */
		private function handler_close(event:Event):void {
			this.killSocket();
			super.dispatchEvent( event );
		}
		
		/**
		 * @private
		 */
		private function handler_ioError(event:IOErrorEvent):void {
			this.killSocket();
			super.dispatchEvent( new IOErrorEvent(IOErrorEvent.NETWORK_ERROR, false, false, event.text) );
		}
		
	}
}