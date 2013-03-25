---
layout: post
title: My Experience with Steam for Linux (64-bit Linux Mint Debian Edition)
tags: [steam, linux, 64-bit, games]
date: 2013-03-25
---

I've been successfully using Steam on my 64-bit Linux Mint Debian Edition desktop for the past month, and I thought I should make a small post about how I got it working and how well various games that I've tried work. I'll try to keep this post updated as I try running more games.

### Installing Steam on Debian

Installing Steam on 64-bit Debian is a bit of a pain. After trying and failing to get it to work myself, I followed [aspensmonster's instructions](http://aspensmonster.com/2013/01/19/updated-procedures-for-installing-steam-for-linux-beta-on-debian-gnulinux-testingwheezy/), which go over everything from setting up multiarch to modifying and rebuilding the steam package to fix the bugs in it. The guide has been updated fairly regularly as new versions of Steam for Linux came out, and should be more or less up-to-date.

[This Debian install script](https://gist.github.com/grindars/4231563) may be helpful as well, but I haven't had a chance to try it.

### Games

| Worked immediately | Required modification | Works, but with issues | Couldn't get to work |
|:------------------:|:---------------------:|:----------------------:|:--------------------:|
| [Aquaria](#aquaria)| [Bastion](#bastion)   | [Dungeons of Dredmor](#dod) | [Team Fortress 2](#tf2)
| [Closure](#closure)| [Faster Than Light](#ftl) |
| [Frozen Synapse](#frozen) |
| [Gratuitous Space Battles](#gsb) |
| [VVVVVV](#vvvvvv)  |
| [World of Goo](#worldofgoo) |

#### <a id="aquaria"></a>Aquaria

*Aquaria* works perfectly from the start.

#### <a id="bastion"></a>Bastion

At first, when launching *Bastion* I just got a black screen after the Supergiant logo appeared. This is a [known issue with S3tc textures](http://ubuntuforums.org/showthread.php?p=11992661) and I could fix it by opening `/.steam/root//SteamApps/common/Bastion/Linux/run_steam.sh` (your path may differ) and editing the `./Bastion.bin.x86` line to be `force_s3tc_enable=true ./Bastion.bin.x86`.

#### <a id="closure"></a>Closure

*Closure* works perfectly from the start.

#### <a id="dod"></a>Dungeons of Dredmor

*Dungeons of Dredmor* works, but suffers from fairly noticeable lag compared to its performance on Windows. It looks like this is a [known Linux problem](http://community.gaslampgames.com/threads/dod-linux-very-slow.3635/), but I haven't been able to find a fix yet.

#### <a id="ftl"></a>Faster Than Light

*Faster Than Light* crashed on startup at first, due to my open-source video driver. There are [two possible solutions](https://wiki.archlinux.org/index.php/Steam#Problems_with_open-source_video_driver); I opted for the easy way out and simply deleted `/.steam/root/SteamApps/common/FTL\ Faster\ Than\ Light/data/amd64/lib/libstdc++.so.6` (your path may differ). *Faster Than Light* now runs perfectly, and, surprisingly, is actually much faster under Steam Linux than the standalone Linux binary of *FTL* is.

#### <a id="frozen"></a>Frozen Synapse

*Frozen Synapse* works perfectly from the start. There seems to be a bit of mouse lag, but it's hardly noticeable.

#### <a id="gsb"></a>Gratuitous Space Battles

*Gratuitous Space Battles* works perfectly from the start.

#### <a id="tf2"></a>Team Fortress 2

I haven't yet been able to get `Team Fortress 2` to work. When I try to launch it, I get the error `"Required OpenGL extension "GL_EXT_texture_compression_s3tc" is not supported. Please install S3TC texture support."`. It looks like [others have had this problem](http://steamcommunity.com/app/221410/discussions/0/864959336401282074/), but none of the fixes that I've seen mentioned work for me. However, I'm not an FPS fan, so I haven't put very much time into trying to get *TF2* to work.

#### <a id="vvvvvv"></a>VVVVVV

*VVVVVV* works perfectly from the start.

#### <a id="worldofgoo"></a>World of Goo

*World of Goo* works perfectly from the start.
