////////////////////////////////////////////////////////////////////////////////
//
//  © 2011 Valentin Simonov
//
////////////////////////////////////////////////////////////////////////////////
package ru.valyard.osc.connection
{
	import flash.errors.IllegalOperationError;
	import flash.events.DatagramSocketDataEvent;
	import flash.events.Event;
	import flash.events.IOErrorEvent;
	import flash.net.DatagramSocket;
	
	import ru.valyard.osc.IOSCMessageFactory;
	import ru.valyard.osc.data.OSCPacket;
	

	/**
	 * Incoming UDP OSC socket connection.
	 * @param host		
	 * @param port		
	 * @param factory	factory for creating OSC messages
	 * @author					valyard
	 */
	public class UDPOSCServerConnection extends AbstractOSCConnection implements IOSCServerConnection {
		
		public function UDPOSCServerConnection(host:String = null, port:uint = 0, factory:IOSCMessageFactory = null) {
			super(factory);
			
			this._socket.addEventListener(DatagramSocketDataEvent.DATA, this.handler_data);
			this._socket.addEventListener(Event.CONNECT, this.handler_connect);
			this._socket.addEventListener(Event.CLOSE, this.handler_close);
			this._socket.addEventListener(IOErrorEvent.IO_ERROR, this.handler_ioError);
			
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
		private const _socket:DatagramSocket = new DatagramSocket();
		
		//--------------------------------------------------------------------------
		//
		// Public properties
		//
		//--------------------------------------------------------------------------
		
		/**
		 * @inheritDoc
		 */
		public function get active():Boolean {
			return this._socket.bound;
		}
		
		//--------------------------------------------------------------------------
		//
		// Public methods
		//
		//--------------------------------------------------------------------------
		
		/**
		 * @inheritDoc
		 */
		public function open(host:String = null, port:uint = 3333):void {
			try {		
				if ( host ) {
					this._host = host;
					this._port = port;
				}
				this._socket.bind( this._port, this._host );
				this._socket.receive();
			} catch ( e:Error ) {
				super.dispatchEvent( new IOErrorEvent(IOErrorEvent.NETWORK_ERROR) );
			}
		}
		
		/**
		 * @inheritDoc
		 */
		public function send(packet:OSCPacket):void {
			throw new IllegalOperationError( "Not supported." );
		}
		
		/**
		 * @inheritDoc
		 */
		public function close():void {
			this._socket.close();
		}
			
		//--------------------------------------------------------------------------
		//
		// IOSCConnection
		//
		//--------------------------------------------------------------------------
			
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
		
		//--------------------------------------------------------------------------
		//
		// Event handlers
		//
		//--------------------------------------------------------------------------
		
		/**
		 * @private
		 */
		private function handler_data(event:DatagramSocketDataEvent):void {
			super.dispatchData( event.data );
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
			super.dispatchEvent( event );
		}
		
		/**
		 * @private
		 */
		private function handler_ioError(event:IOErrorEvent):void {
			super.dispatchEvent( event );
		}
			
	}
}