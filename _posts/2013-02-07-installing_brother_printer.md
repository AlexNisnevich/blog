---
layout: post
title: Installing a Brother printer on 64-bit Ubuntu/Debian
tags: [linux, drivers, 64-bit, troubleshooting, installation]
---

The other day I had to reinstall Linux Mint Debian Edition. The reinstall process went smoothly overall,
with the only problem being, of all things, the driver for my Brother printer.

### The Problem

The problem is that [Brother's official Linux printer drivers](http://welcome.solutions.brother.com/bsc/public_s/id/linux/en/download_prn.html)
are all 32-bit, and don't appear to play nicely with 64-bit Debian-based distributions.

When I tried installing the driver directly, I got an incompatible architecture error:

{% highlight bash %}
> sudo dpkg -i cupswrapperHL2270DW-2.0.4-2.i386.deb
dpkg: error processing cupswrapperHL2270DW-2.0.4-2.i386.deb (--install):
 package architecture (i386) does not match system (amd64)
Errors were encountered while processing:
 cupswrapperHL2270DW-2.0.4-2.i386.deb
{% endhighlight %}

Now, the recommended way to resolve this is to use [MultiArch](http://wiki.debian.org/Multiarch/HOWTO), Debian's
system for handling applications and libraries of multiple architectures on one system. However, MultiArch is still
rather immature, and whenever I've tried to use it I've ended up in an unresolvable dependency hell. I wanted to
find a better way to deal with this.

My first instinct was to suppress the incompatible architecture error using `--force-architecture` or `--force-all`:

{% highlight bash %}
> sudo dpkg -i --force-all cupswrapperHL2270DW-2.0.4-2.i386.deb
dpkg: warning: overriding problem because --force enabled:
 package architecture (i386) does not match system (amd64)
(Reading database ... 171933 files and directories currently installed.)
Preparing to replace cupswrapperhl2270dw 2.0.4-2 (using cupswrapperHL2270DW-2.0.4-2.i386.deb) ...
Restarting Common Unix Printing System: cupsd.
Unpacking replacement cupswrapperhl2270dw ...
dpkg: cupswrapperhl2270dw: dependency problems, but configuring anyway as you requested:
 cupswrapperhl2270dw depends on libc6 (>= 2.3.4-1); however:
  Package libc6:i386 is not installed.
{% endhighlight %}

Hmm, no luck yet - it looks like the driver depends on the `libc6:i386` package, which I can't install without MultiArch.

Interestingly, the [Brother official FAQ](http://welcome.solutions.brother.com/bsc/public_s/id/linux/en/faq_prn.html#f00081)
suggests installing the `lib32stdc++6` package (`ia32-libs` on Ubuntu) and using `--force-architecture`, but this still didn't
work for me, even after installing `lib32stdc++6`.

### The Solution

Fortunately, a solution does exist, though it's a bit hackish: you need to remove the `libc` dependency from the package.

There are a few ways to do this:

#### Option 1: Manual modification of the package

[Yousry Abdallah recommends](https://bugs.launchpad.net/ubuntu/+source/cups/+bug/701856/comments/20)
removing the `libc` dependency from the driver:

> 1. `dpkg -x [package].deb common`
> 2. `dpkg --control [package].deb`
> 3. `vim DEBIAN/control`
> 4. remove the `"Dependency: libc (..."` line (move to line than press `'dd'` than `ESC:x`)
> 5. `cp -a DEBIAN/ common/`
> 6. `dpkb -b common [package].deb`
> 7. `dpkg --force-all -i [package].deb`
> 8. `rm -rf common DEBIAN`

#### Option 2: Official patch (Brother HL-2270DW only)

If you have a Brother HL-2270DW printer like me, then you're in luck: Brother has released a patch to resolve the issue. You can
follow the instructions [here](http://welcome.solutions.brother.com/bsc/public_s/id/linux/en/faq_prn.html#f00098) to use it.

Or you can simply download the [already-patched CUPS driver](https://docs.google.com/leaf?id=0BxKNugMxlGF7NzQwYTcyNmYtZWMxNC00MzJlLWEwZGEtM2QyNzgwN2ZhYWZh&hl=en_US),
which has been patched by [Chad Chenault](http://chadchenault.blogspot.com/2011/09/brother-hl-2270dw-printer-driver.html). If you would rather use LPR, a [patched LPR driver](https://docs.google.com/leaf?id=0BxKNugMxlGF7MjQ3ODI4MzEtMGMyYy00ZGVlLThiMjAtZjdiMjZjZjkxOWE3&hl=en_US) is also available.

Remember that you need to install the packages using the `--force-all` option:

{% highlight bash %}
> dpkg -i --force-all [package.deb]
{% endhighlight %}

I've tested the CUPS driver on Linux Mint Debian and it works perfectly. Both drivers should also work on Ubuntu 11.04 and later.

### Finishing the installation

If you're using the printer via USB, then everything should work after installing the package. Make sure your printer is plugged in,
then go to [http://localhost:631/printers](http://localhost:631/printers) and try printing a test page.

However, if you're using a network printer, then there are still a few steps left. You can
[follow this tutorial](http://community.linuxmint.com/tutorial/view/194) or [watch this video](http://www.youtube.com/watch?v=pqpWhnjemLc)
(skip to the part after the package is installed).

Good luck!
