# MC-155611 Bug Demonstration

This repo contains a couple of examples that allows you to replicate the MC-155611 bug.

## Description

When someone opens Minecraft's multiplayer menu, the game listens to ```224.0.2.60:4445``` for any message that are emitted by a LAN server so it can add it to the menu.<br>
Under normal circumstances, everything should be fine, but if you start spamming "falsified" messages with another program, the game can encounter an unhandled ```ConcurrentModificationException``` and crash.

This bug is present in 1.7.10, 1.13 and 1.14.3. (Others versions have not been untested but they should have the same problem)

## Technical details

When minecraft announces a LAN server, it does it with a UDP packet transmitted on the previously stated multicast IP address.<br>
It usually sends one every 1.5 seconds, and other Minecraft instances can uniquely identify each one by the given port number and the packet's source IP address.

The packet consists of a string with the following structure `[MOTD]%s[/MOTD][AD]%d[/AD]`, where `%s` is the server MOTD, and `%d` the number port.<sup>1</sup><br>
The string uses UTF-8 variable length encoding and it cannot be bigger than 1024 bytes long.<sup>2</sup>

The bug starts when you send "falsified" packets at a much faster rate (100+ per second), with a different port number each time, which can cause the other Minecraft instances on the network to encounter an unhandled ```ConcurrentModificationException``` when they are listenning to these packets.

<sub>
1: The port number is technically an unsigned word, but Minecraft simply parses it as a string and appends it to the IP address without validating it.<br>
2: This was the maximum length that Minecraft seemed to parse.
</sub>

## How to replicate

You can either run the Python script or compile and run the PureBasic executable.<br>
Or if you are able to send falsified packets, you can do it yourself.

### PureBasic

You can just compile and run [AbuseMinecraftLanServerDiscovery.pb](PureBasic/AbuseMinecraftLanServerDiscovery.pb) and click "Ok" on the first message box.<br>
Just keep in mind that you will have to shut it down manually.

The code has been thoroughly commented to let you easily understand what is going on.

### Python

You can run [AbuseMinecraftLanServerDiscovery.py](Python/AbuseMinecraftLanServerDiscovery.py) with Python 2.7.

This method will be a bit slower than with PureBasic, but it works.

Just keep in mind that you will have to shut it down manually too.

## Links

* [Bug report](https://bugs.mojang.com/browse/MC-155611)

## License

[Unlicense](LICENSE)
