# This makefile is for all platforms, but doesn't include support for the HD44780, OLED, or PCF8574 displays on the Raspberry Pi.

CC      = cc
CXX     = c++
CFLAGS  = -g -O3 -Wall -std=c++0x -pthread -DHAVE_LOG_H
LIBS    = -lpthread
LDFLAGS = -g

OBJECTS = \
		AMBEFEC.o BCH.o BPTC19696.o CASTInfo.o Conf.o CRC.o Display.o DMRControl.o DMRCSBK.o DMRData.o DMRDataHeader.o DMREMB.o DMREmbeddedData.o DMRFullLC.o \
		DMRLookup.o DMRLC.o DMRNetwork.o DMRShortLC.o DMRSlot.o DMRSlotType.o DMRAccessControl.o DMRTA.o DMRTrellis.o DStarControl.o DStarHeader.o \
		DStarNetwork.o DStarSlowData.o Golay2087.o Golay24128.o Hamming.o I2CController.o LCDproc.o Log.o M17Control.o M17Convolution.o M17CRC.o M17LICH.o \
		M17Network.o M17Utils.o MMDVMHost.o Modem.o ModemSerialPort.o Mutex.o NetworkInfo.o Nextion.o NullDisplay.o NullModem.o NXDNAudio.o NXDNControl.o \
		NXDNConvolution.o NXDNCRC.o NXDNFACCH1.o  NXDNIcomNetwork.o NXDNKenwoodNetwork.o NXDNLayer3.o NXDNLICH.o NXDNLookup.o NXDNNetwork.o NXDNSACCH.o \
		NXDNUDCH.o P25Audio.o P25Control.o P25Data.o P25LowSpeedData.o P25Network.o P25NID.o P25Trellis.o P25Utils.o POCSAGControl.o POCSAGNetwork.o QR1676.o \
		RemoteControl.o RS129.o RS241213.o RSSIInterpolator.o SerialController.o SerialPort.o StopWatch.o Sync.o TFTSerial.o TFTSurenoo.o Thread.o Timer.o \
		UDPSocket.o UMP.o UserDB.o UserDBentry.o Utils.o YSFControl.o YSFConvolution.o YSFFICH.o YSFNetwork.o YSFPayload.o

all:		MMDVMHost RemoteCommand

MMDVMHost:	GitVersion.h $(OBJECTS) 
		$(CXX) $(OBJECTS) $(CFLAGS) $(LIBS) -o MMDVMHost

RemoteCommand:	Log.o RemoteCommand.o UDPSocket.o
		$(CXX) Log.o RemoteCommand.o UDPSocket.o $(CFLAGS) $(LIBS) -o RemoteCommand

%.o: %.cpp
		$(CXX) $(CFLAGS) -c -o $@ $<

install:
		install -m 755 MMDVMHost /usr/local/bin/
		install -m 755 RemoteCommand /usr/local/bin/

clean:
		$(RM) MMDVMHost RemoteCommand *.o *.d *.bak *~ GitVersion.h

# Export the current git version if the index file exists, else 000...
GitVersion.h:
ifneq ("$(wildcard .git/index)","")
	echo "const char *gitversion = \"$(shell git rev-parse HEAD)\";" > $@
else
	echo "const char *gitversion = \"0000000000000000000000000000000000000000\";" > $@
endif
