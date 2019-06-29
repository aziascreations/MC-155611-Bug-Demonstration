# MC-155611 Bug Demonstration

This repo contains a couple of examples that allows you to replicate the MC-155611 bug.

## Description

When someone opens Minecraft's multiplayer menu, the game listens to ```224.0.2.60:4445``` for any message that are emitted by a LAN server so it can add it to the menu.<br>
Under normal circumstances, everything should be fine, but if you start spamming 'falsified' messages with another program, the game can encounter an unhandled ```ConcurrentModificationException``` and crash.

This bug is present in 1.7.10, 1.13.x and 1.14.3. (others versions have not been untested but they should have the same problem)

## Technical details

When minecraft announces a LAN server, it does it with a UDP packet transmitted on the previously stated IP adrress.<br>
It usually sends one every 1.5 seconds, and other Minecraft instances can uniquely identify each one by the given port number and source IP address.

But if you send 'falsified' ones at a much faster rate (100 per second), with a different port number each time, the other Minecraft instances can encounter an unhandled ```ConcurrentModificationException```.

#### Note:
I'm sorry if there isn't more details, but it's not a CVE, and the Minecraft dev team already has access to the inner workings of LAN server announcements.<br>
If you want more info, read the PureBasic example or search online.

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
