## /TUIO/3ASObj

/TUIO/3ASObj is a library to parse TUIO.OSC messages.
Implements OSC 1.0 and TUIO 1.1.
Distributed under MIT license. Copyright © 2010 Valentin Simonov.

## Features
- One lightweight project,
- Uses listeners instead of events for performance,
- OSC message pooling to reduce GC overhead,
- Supports TCP and UDP,
- Implements most of OSC spec types,
- Supports Messages and Bundles,
- Has Client and Server implementations,
- Can support different specific OSC implementations through OSC Message Factories.

## Usage
There are several connection classes for general use: UDPOSCServerConnection (UDP server connection which listens to specific port, can't send data), TCPOSCServerConnection (TCP server which listens to specific port, can receive and broadcast data to connected users), TCPOSCConnection (TCP client which can send and receive OSC data). All of them implement IOSCConnection interface.
	
**WARNING! IF YOU STORE OSCMESSAGES IN LISTENERS YOU WILL BE SHOT!!**

To receive OSC messages one needs to add a listener to OSC connection which implements IOSCConnectionListener interface and has a public method receiveOSCMessage(message:OSCMessage):void.

connection.addListener( listener );

If for any reason you need to retrieve an empty OSCMessage, use IOSCMessageFactory.getEmptyOSCMessage and IOSCMessageFactory.returnOSCPacket after that.
	
## TUIO

To receive TUIO messages you need to create an instance of TUIOConnection which requires and instance of IOSCConnection. After that create a listener which implements ITUIOConnectionListener interface and add it to your TUIO connection.

var connection:ITUIOConnection = new TUIOConnection( 
	new UDPOSCServerConnection( "localhost", 3333 ) );
connection.addListener( myListener );
class MyListener implements ITUIOConnectionListener {
	public function addTUIOCursor(cursor:TUIOCursor) { ... }
}