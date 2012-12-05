////////////////////////////////////////////////////////////////////////////////
//
//  © 2011 Valentin Simonov
//
////////////////////////////////////////////////////////////////////////////////
package ru.valyard.osc.connection {
	
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
	 * Broadcast server TCP OSC socket connection
	 * @param host		
	 * @param port		
	 * @param factory	factory for creating OSC messages
	 * @author					valyard
	 */
	public class TCPOSCServerConnection extends AbstractOSCConnection implements IOSCServerConnection {
		
		public function TCPOSCServerConnection(host:String = null, port:uint = 0, factory:IOSCMessageFactory = null) {
			super(factory);
			
			this._host = host;
			this._port = port;
			if ( this._host && this._port ) this.open();
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
		private var _clientSockets:Vector.<Socket> = new Vector.<Socket>();
		
		/**
		 * @private
		 */
		private var _serverSocket:ServerSocket;
		
		//--------------------------------------------------------------------------
		//
		// Public properties
		//
		//--------------------------------------------------------------------------
		
		/**
		 * @inheritDoc
		 */
		public function get active():Boolean {
			return this._serverSocket && this._serverSocket.bound;
		}
		
		//--------------------------------------------------------------------------
		//
		// Public methods
		//
		//--------------------------------------------------------------------------
		
		/**
		 * @inheritDoc
		 */
		public function open(host:String = null, port:uint = 0):void {
			try {		
				this.killSockets();
				
				this._serverSocket = new ServerSocket();
				this._serverSocket.addEventListener(Event.CONNECT, this.handler_connectToServer);
				this._serverSocket.addEventListener(Event.CLOSE, this.handler_close);
				
				if ( host ) {
					this._host = host;
				}
				if ( port ) {
					this._port = port;
				}
				this._serverSocket.bind( this._port, this._host );
				this._serverSocket.listen();
			} catch ( e:Error ) {
				super.dispatchEvent( new IOErrorEvent(IOErrorEvent.NETWORK_ERROR, false, false, e.message) );
			}
		}
		
		/**
		 * @inheritDoc
		 */
		public function send(packet:OSCPacket):void {
			if ( !this._clientSockets.length ) return;
			var bytes:ByteArray = super.factory.writeOSCPacket(packet);
			for each ( var socket:Socket in this._clientSockets ) {
				if ( !socket.connected ) continue;
				socket.writeBytes( bytes );
				socket.flush();
			}
		}
		
		/**
		 * @inheritDoc
		 */
		public function close():void {
			this.killSockets() 
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
		private function killSockets():void {
			this.killClientSockets();
			this.killServerSocket();
		}
		
		/**
		 * @private
		 */
		private function killClientSockets():void {
			if ( this._clientSockets.length ) {
				for each ( var socket:Socket in this._clientSockets ) {
					this.killClientSocket( socket );
				}
			}
		}
		
		/**
		 * @private
		 */
		private function killClientSocket(socket:Socket):void {
			socket.removeEventListener(IOErrorEvent.IO_ERROR, this.handler_ioError);
			socket.removeEventListener(IOErrorEvent.NETWORK_ERROR, this.handler_ioError);
			socket.removeEventListener(ProgressEvent.SOCKET_DATA, this.handler_data);
			socket.removeEventListener(Event.CLOSE, this.handler_close );
			if ( socket.connected ) socket.close();
			this._clientSockets.splice( this._clientSockets.indexOf(socket), 1 );
		}
		
		/**
		 * @private
		 */
		private function killServerSocket():void {
			if ( this._serverSocket ) {
				this._serverSocket.removeEventListener(Event.CONNECT, this.handler_connectToServer);
				this._serverSocket.removeEventListener(Event.CLOSE, this.handler_close);
				if ( this._serverSocket.bound ) this._serverSocket.close();
				this._serverSocket = null;
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
			var socket:Socket = event.target as Socket;
			socket.readBytes( buffer, 0, socket.bytesAvailable );
			super.dispatchData( buffer );
		}
		
		/**
		 * @private
		 */
		private function handler_connectToServer(event:ServerSocketConnectEvent):void {
			event.socket.addEventListener(IOErrorEvent.IO_ERROR, this.handler_ioError);
			event.socket.addEventListener(IOErrorEvent.NETWORK_ERROR, this.handler_ioError);
			event.socket.addEventListener(ProgressEvent.SOCKET_DATA, this.handler_data);
			event.socket.addEventListener(Event.CLOSE, this.handler_close );
			this._clientSockets.push( event.socket );
			super.dispatchEvent( new Event(Event.CONNECT) );
		}
		
		
		/**
		 * @private
		 */
		private function handler_close(event:Event):void {
			this.killClientSocket( event.target as Socket );
		}
		
		/**
		 * @private
		 */
		private function handler_ioError(event:IOErrorEvent):void {
			this.killClientSocket( event.target as Socket );
			super.dispatchEvent( new IOErrorEvent(IOErrorEvent.NETWORK_ERROR, false, false, event.text) );
		}
		
	}
}