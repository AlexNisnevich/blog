---
layout: post
title: Some Words on Untrusted
tags: [untrusted, game, javascript, education, creations, greg]
draft: true
---

It's been about six months since [Greg](https://github.com/neunenak) and I released [Untrusted](http://untrustedgame.com) into the world, so I figure now's as good a time as any to write something about how Untrusted came to be.

## It All Started With a Hackathon

Greg and I had wanted to make a game for a long time, and when we decided to participate in the spring 2013 CSUA hackathon at Berkeley, we figured it was as good a time as any.

Greg had an idea for a game that would take place in a Unix filesystem, where gameplay would involve moving around the filesystem and doing different operations, and where the final level would be unbeatable unless you decompile the game and rewrite part of it. It was an interesting idea, and I'd still like to perhaps try it sometime, but we couldn't really come up with how we would implement it. I really liked the last part of the idea, though -- the bit about having to modify the code of the game to make it beatable. When we gave up on the original idea, I proposed making a game where the central idea is the the player is able to modify the underlying game code. Greg thought that sounded pretty cool, so we got to work.

### Design

The first thing we had to settle was how broad the scope of this "hacking" mechanic should be. If the player had arbitrary access to all game code, that would (a) be a nightmare to get working correctly, and (b) give the player far too much power to really make it possible for the game to be much a challenge. We decided to start by letting the player be able to modify the code that initializes each level, and see where we could go from there. We were considering given the player progressively more and more power to edit different aspects of the game, but we couldn't quite figure out how that would work (though I did later use that idea in the last level of the game, `21_endOfTheLine`).

Ok, so if the player could modify each level, what would the levels themselves be like. We decided to go with a roguelike style, because it would mean that we wouldn't have to worry about graphics (though a surprising amount of work went into finding appropriate Unicode characters for things), the level maps could be represented pretty cleanly in code, there wouldn't be too many moving parts, and, honestly, we both just really like roguelikes.

One final design hurdle was how to further limit the player's control over the code and not make all the puzzles too trivial. Since being able to edit all of the code to a level would be too much power, we decided to only make certain lines editable. Then, as an additional level of control, we added our validator mechanism (in retrospect, we probably could have done some more interesting puzzles involving validators, but mostly we've just used them for basic things like ensuring players don't create extra exits).

With these pieces in place, we had the bulk of our design ready.

### Implementation

The first steps we took in our implementation was creating the map, making it be able to load a level definition, and making the player moveable. We used the rather neat [http://ondras.github.io/rot.js/hp/](rot.js) library, which provided some nice abstractions, though we didn't end up using all that many features from it. After a couple hours of work, we had a Map class that could place objects though a simple API, as well as an interactive player object. It was time to move on to the meat of the game: the evaluator.

Actually, the evaluation part is fairly simple: we just call `eval`. Yup. We were considering building our own parser, but that would have taken way too much work for the hackathon and `eval` worked well enough for our needs that we never changed it afterwards. Of course, we do some interesting things around it: we first evaluate the player-provided `startLevel` method on a dummy map (that supports the map API but has no in-game effect and is not visible to the player) and run validators on it. We also introduced some basic security measures here and there, like making sure certain words couldn't be used (this could be easily circumvented though -- I go into some detail later about how we designed a more robust security system).

Now that we had a map that could be initialized based on user-provided code, the final piece of the puzzle was creating the editor. This actually turned out to be the hardest part of the hackathon for us. We used [CodeMirror 2](http://codemirror.net/), which supported _almost_ all of the features we wanted but was missing one big one that we had to do ourselves: uneditable lines and sections. Conceptually, this didn't seem too bad, but in between figuring out all the CodeMirror events we needed to handle and doing the right bookkeeping at all times (so that the editable areas would never move to where they shouldn't be) ended up being pretty tricky. We ended up having to make some compromises due to time pressure: for example, in the hackathon version of Untrusted, only one line can be edited at a time and you can't create new lines, so if you want to write multiple lines you have to go through the annoying process of navigating to each new line yourself. True multi-line editing was such a difficult feature to get working right with respect to uneditable areas that it took another year before it was properly implemented in Untrusted. 

We had to cut some corners, but we finally had a working game engine. The rest of the time was mostly spent coming up with levels. I'll admit that we were a bit uncreative (perhaps our creative juices were burned out by the amount of work it took to get the editor working), and so the first four levels we came up with all have a similar feel: you are surrounded by blocks and need to find a way to get through them to the exit, in the face of increasingly tricky constraints (these are, with some rearrangement and tweaking, still the first four levels of Untrusted). 

In an effort to inject a little bit of creativity into our game, Greg and I took some time off from coding and tried to each come up with a unique premise for an interesting level. I came up with an idea for a level with invisible traps that can be identified by coloring them (this became `05_minesweeper`), while Greg came up with an idea for level where the player had to bind a function call to a keystroke to get through an area (this became the basis for the function phone and `08_intoTheWoods`). We only had a couple of minutes to demo our project, so at the last minute I added a cheat key to skip between levels, so that we could present only the most interesting levels when we did our demo.

### End Result

[Here it is](http://alex.nisnevich.com/untr/hackathon/), in all of its rough hackathony glory. 

It seems a bit embarrassingly unpolished when I look back on it now, but the hackathon judges really liked our idea, and Greg and I ended up winning first place (and some swanky 27' monitors). Given the surprisingly positive reception we got, we decided to continue working on Untrusted until we felt it was complete enough to release.

We certainly didn't expect to work on it for another 14 months, though.

## The Next Year

Over the next year, we worked on Untrusted at an unpredictable pace, sometimes getting an enormous amount of new content done quickly and sometimes taking long breaks as our real lives caught up to us (for most of this time, Greg was working at Meraki, while I was doing my Masters at Berkeley).

Our first round of work on Untrusted, in the first few months after the hackathon, was primarily devoted to cleaning up our ugly hacked-together codebase, creating a build system and a better level file format (namely, our JSX format) to make our lives easier, and throwing out some ideas for new gameplay elements. Levels that we created during this time include `07_colors` and `15_exceptionalCrossing`.

Between late August and early October, we worked in some polish, adding help and menu panes, sound effects, and progress saving via localStorage. During this time, we came up with the idea for the climax of the game (at least difficulty-wise), the robot levels.

In November, Greg and I came up with our plan for how to organize the game. We decided to divide it into three chapters: the first would introduce the primary game mechanics, the second would stop holding the player's hand and keep increasing the difficulty curve, and the third would break the rules we had previously established by introducing a bunch of new crazy things, culminating in a boss fight. We also came up with a barebones plot that was a bit cliche but worked for our purposes, and after trying a few different approaches to establishing the story, we decided that conveying it entirely through code comments would be a nice touch.

Now that we finally had a blueprint for the game, progress went much quicker, and by December we had more or less finalized the first two chapters of the game. In the meantime, we also created the loading screen and credits and found most of the background music that we wanted (aside: [Free Music Archive](http://freemusicarchive.org/) is amazing).

Around New Year's, we posted our new Untrusted prototype on Facebook for our friends to playtest. One thing that we noticed was that, even after all of the security improvements we had tried to add over the past year, people still managed to find a bunch of different exploits that enabled them to arbitrarily skip levels. Now, we definitely feel that finding ways to break the system is a big part of what Untrusted is about, and we don't want to discourage it entirely, but if you can find a single exploit that lets you get around every level, that's not very fun. In light of this, we came up with a mechanism to completely prevent players from accessing methods we don't want them to access.

### Aside: Private Methods in Untrusted

Our solution to this is actually kind of cool, so I wanted to go over it briefly.

Player-accessible classes -- namely, `map`, `player`, and `dynamicObject` -- contain _exposed methods_ (that is, methods that the player is allowed to access) and _unexposed methods_ (private methods that we want to be able to access but not expose to the player). Since JavaScript doesn't really have a notion of visibility, we've had to use workarounds.

Our first approach was to simply have all unexposed methods begin with an underscore (_) and disallow that character in player-written code. This is not foolproof by any means, though, since there are a number of workarounds one could do to inject an underscore without explicitly typing one. We needed a better solution.

What we eventually came up was this wrapper function for exposed methods:

{% highlight javascript %}
function wrapExposedMethod(f, obj) {
    return function () {
        var args = arguments;
        return __game._callUnexposedMethod(function () {
            return f.apply(obj, args);
        });
    };
};
{% endhighlight %}

where `__game` is a reference to the Game object, which has a local variable `__playerCodeRunning` and the following methods:

{% highlight javascript %}
this._isPlayerCodeRunning = function () { return __playerCodeRunning; }

this._callUnexposedMethod = function(f) {
    if (__playerCodeRunning) {
        __playerCodeRunning = false;
        res = f();
        __playerCodeRunning = true;
        return res;
    } else {
        return f();
    }
};
{% endhighlight %}

Now, to enforce exposure of methods, all we need to do is (1) wrap all exposed methods with `wrapExposedMethod` and (2) check `__game._isPlayerCodeRunning()` at the beginning of each unexposed method. For example, the Map class could have methods like:

{% highlight javascript %}
this.sampleExposedMethod = wrapExposedMethod(f, function ( [args] ) {
    ...
}, this);

this.sampleUnexposedMethod = function ( [args] ) {
    if (__game._isPlayerCodeRunning()) { throw 'Forbidden method call: sampleUnexposedMethod()';}
    ...
};
{% endhighlight %}

The neat thing about this approach is that exposed methods are still able to internally call unexposed methods with no problems, but each starting method call from the executed player code has to be an exposed method.

### Anyway...

After taking some time off Untrusted to rest, we went back at it in February, and over the next two months we finished Chapter 3 and added some features our friends had requested a lot during playtesting, such as a notepad pane and the ability to share your solutions through automatic [Gist](http://gist.github.com) saving. The most requested feature, the ability to edit multiple lines at once (that is, the ability to expand and contract multi-line blocks sections in the editor, and to delete or copy multiple lines) was implemented by our friend [Dmitry](https://github.com/dmazin) (who, incidentally, also contributed a couple pieces of music). This was such a huge and difficult code contribution (due to the complicated interactions it had with the boundaries of editable sections) that we specifically credit him for "implementation of multiline editing" in our [Acknowledgements](https://github.com/AlexNisnevich/untrusted) section.

Finally, at the beginning of April 2014, Untrusted was complete and ready to be shown to the world.

<!---
Hackathon (early March 2013): 6 levels
March: first round of playtesting, code reorganization, build system
April: colors and exceptionalCrossing levels
May: dynamic objects
(June-July: break from Untrusted)
August: robot levels, help and menu panes, sound effects
September: platformer level, infinite loop prevention
October: code cleanup, localStorage
November: Chapter 1 complete, story and flavor text, teleporter level, loading screen
December: Chapter 2 complete, background music, credits, heavy-duty code cleanup and bug fixes
January 2014: second round of playtesting, security improvements
February: multiline editing, lasers level, gist saving, notepad pane
March: Chapter 3 complete, DOM and final levels, level versioning
April: final round of playtesting, release
-->

## Release & Disaster

When I [posted Untrusted to Hacker News](https://news.ycombinator.com/item?id=7547942) on the morning of April 7th, we decided we were aiming for maybe 10-20 upvotes, 50-100 if we were lucky.

We hit the front page almost immediately. Then we rose to 10th place. Then 5th. Then all the way to the top.

About an hour after the post, Untrusted began breaking: players were beating levels without advancing to the next level and getting stuck in loops. At first there were just a few isolated reports of this, but soon enough the game stopped working for everyone.

There were now thousands of people trying to play Untrusted and it wasn't working. It was a disaster.

I did my best to track down the problem. It turned out that hosting Untrusted along with all of its music (a 200MB soundtrack) on my own VPS server was a terrible decision: the server hit its bandwidth cap within an hour and the hosting provider assumed that I was getting DDOSed and began rate-limiting all requests. Now, since Untrusted loads levels through AJAX calls, this meant that everyone playing the game at the time suddenly became sporadically (and soon, completely) unable to load levels. Even worse, we hadn't considered the possibility of the AJAX level requests failing and had no built-in error handling to speak of, so the game still acted as though the next level was loaded in these situations, causing bizarre bugs all around, such as levels being overwritten by other levels. Even worse than that, since level code was constantly written to localStorage, this meant that players' game states were becoming corrupted to the point that even after this outage went away, the game would still be unplayable until they cleared localStorage.

We had to act fast. For lack of a better idea, I moved everything over to GitHub Pages and set up a server-side redirect ASAP. Until the redirect started working, I had to work on damage control in Hacker News, apologizing profusely and directing people to our GH Pages URL (until I finished setting up GH Pages, I suggested that people could clone the repository themselves and play Untrusted locally -- not the best thing to tell frustrated players but the best I could come up with at the time). I also temporarily special-cased some code in to detect when players' localStorage` was messed up and fix it as unintrusively as possible.

After the situation stabilized, we began the process of moving all the music over to Amazon CloudFront. (Theoretically GitHub Pages doesn't have any bandwidth limits, but I didn't want to surprise them with 5TB/month, which April ended up being.) CloudFront handled the load it needed very well but ended up being a little expensive, so we added a small donation button and tried some tricks to reduce requests (like not requesting music while the game is muted).

That night, Greg and I also rewrote level loading system from scratch, so that this problem could never happen again. Instead of the game making AJAX requests for each level, all the levels are now packed into an array inside the minified source as part of the build process. This took a fair bit of bash wizardry and actually ended up one of the trickiest parts of coding the game (at least in my opinion -- Greg's a lot better at bash than I am).

Over the next month, Untrusted spread rapidly through word-of-mouth on Twitter, Reddit, and Facebook (in about that order). Fortunately there were no more major outages.

## Reactions to Untrusted

If I may brag for a moment: Six months after its release to the world, Untrusted has been played 700,000 times by 380,000 players from 196 countries (top five countries, in order: United States, Russia, China, Poland, France). The Untrusted GitHub repo has been starred nearly 2000 times and forked 400 times. It's certainly become much more popular than either of us had expected from our half-baked last-minute hackathon idea last year.

A few articles have been written about us. My favorites include:

  - [see untrusted-mentions.txt]

What excites us the most is all the different ways we've seen Untrusted used. For example:

  - (e.g. schools, translations, mods)

[some words go here]

## What's Next for Untrusted?

[potential things in pipeline]

As for the game itself, [...]

  - we're no longer continually working on it
  - but we're still maintaining it -- look at bugs and pull requests
  - big push now is making the game more community-driven
    - last major feature we added: custom level support
    - related: mod support PR
      - maybe I should approve the PR before publishing this blog post

[some words go here]
