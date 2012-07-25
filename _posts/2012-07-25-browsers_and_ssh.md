---
layout: post
title: Refreshing Browsers over SSH
tags: [ssh, linux, browsers]
---

Today I was faced with the challenge of having to refresh a Chrome browser window on a networked Ubuntu machine via SSH. (Admittedly, I could have walked over to the computer in question and hit F5, but where's the fun in that?) This seemed like it would be simple, but I immediately ran into problems.

### Opening Chrome

My first thought was to see if Google Chrome's [command-line interface](http://peter.sh/experiments/chromium-command-line-switches/) has any support for interacting with existing windows, but unfortunately it doesn't. Oh well - if the browser is set to remember the last opened tabs, then it should just be a matter of closing and reopening the window: once I SSH in,

{% highlight bash %}
sudo killall chrome
google-chrome & > /dev/null
{% endhighlight %}

should be all it takes, right?

Well, not quite:

{% highlight bash %}
(chromium-browser:3217): Gtk-WARNING **: cannot open display:
{% endhighlight %}

Hmm, Chrome refuses to start because it can't find a display. Since we're logged in remotely, we'll need to manually set the display to be the one that is currently being used:

{% highlight bash %}
export DISPLAY=:0.0
{% endhighlight %}

After this, running `google-chrome` works. So far, so good.

Now comes the next problem: the original window was full-screen. Could I make the new instance be full-screen as well?

### Making it full screen

Suprisingly, there is no command-line switch for full-screen mode! The closest I could find was `--app`, which didn't seem to do anything. Well, if we can't start the browser full-screen, can we at least make the window full-screen after it starts?

Here the [xdotool](http://www.semicomplete.com/projects/xdotool/) keyboard/mouse simulator package can come in handy - we can use it to mimic an F11 keypress as follows:

{% highlight bash %}
# You might need to sudo apt-get install xdotool
xdotool search chrome windowactivate --sync key F11
{% endhighlight %}

Now all that's left is the matter of timing: we should only run `xdotool` once Chrome's window has opened, so let's give it a few seconds:

{% highlight bash %}
sleep 2
{% endhighlight %}

### Putting it all together

The full sequence of commands to run is:

{% highlight bash %}
export DISPLAY=:0.0
sudo killall chrome
google-chrome & > /dev/null
sleep 2
xdotool search chrome windowactivate --sync key F11
{% endhighlight %}

Since I don't want to have to enter this every time I need to refresh the browser, I saved this into a shell file on the remote machine at `~/local/bin/google-chrome-fullscreen` and assigned appropriate permissions. Now, to refresh chrome on that machine, all I need to run is:

{% highlight bash %}
ssh <host> 'google-chrome-fullscreen > /dev/null'
{% endhighlight %}

(The `> /dev/null` is necessary, apparently because otherwise the SSH session hangs while waiting for output.)

### What about other browsers?

Similar method should work for other browsers. A generic browser-refresh script that works for me is:

{% highlight bash %}
#!/bin/sh
# refresh_fullscreen

export DISPLAY=:0.0
sudo killall $1
$1 & > /dev/null
sleep 2
xdotool search $1 windowactivate --sync key F11
{% endhighlight %}

where the usage is
{% highlight bash %}
refresh_fullscreen <browser name or path>
{% endhighlight %}

I've tried this with Firefox and Chromium and it seems to work fine, but your mileage may vary.
