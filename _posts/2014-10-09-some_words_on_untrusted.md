---
layout: post
title: Some Words on Untrusted
tags: [untrusted, game, javascript, education, creations, greg]
draft: true
---

It's been about six months since [Greg](https://github.com/neunenak) and I released [Untrusted](http://untrustedgame.com) into the world, so I figure now's as good a time as any to write something about how Untrusted came to be.

## In the Beginning ...

Greg and I had wanted to make a game for a long time, and when we decided to participate in the spring 2013 CSUA hackathon at Berkeley, we figured it was as good a time as any. Greg had an idea for a game that would take place in a Unix filesystem, where gameplay would involve moving around the filesystem and doing different operations, and where the final level would be unbeatable unless you decompile the game and rewrite part of it. It was an interesting idea, and I'd still like to perhaps try it sometime, but we couldn't really come up with how we would implement it. I really liked the last part of the idea, though -- the bit about having to modify the code of the game to make it beatable. When we gave up on the original idea, I proposed making a game where . Greg thought that sounded pretty cool, so we got to work.

- working on Untrusted during hackathon:
  - choice of libraries: CodeMirror (I'd previously used it for PSM), rot.js (never tried before but roguelikes are cool)
  - parser or eval? parser would be too hard -- eval all the way!
  - limiting player control immediately became a challenge
    - first attempts at a fix: 
      - editable lines
        - one of the hardest parts of this - kind of a pain to get working right in CodeMirror
      - validators
      - 80-char line limit
      - simple VERBOTEN list
  - not very many gameplay elements: player, exit, block, tree, trap
  - levels
    - most of the levels were simple block manipulation (these are still levels 1-4 in Untrusted)
    - coming up with other approaches to levels was hard at the time:
      - I had the idea of making a level with invisible traps that can be identified by color (this became level 05)
      - Greg had the idea of letting the player bind functions calls to a keystroke -- this led to the function phone and what became level 08)

- winning the hackathon

- early prototype: http://alex.nisnevich.com/untr/hackathon/

## The Next Year

Over the next year, we worked on Untrusted at an unpredictable pace, sometimes getting an enormous amount of new content done quickly and sometimes taking long breaks as our real lives caught up to us (during most of that time, Greg was working at Meraki, while I was doing my Masters at Berkeley).

Our first round of work on Untrusted, in the first few months after the hackathon, was primarily devoted to cleaning up our ugly hacked-together codebase, creating a build system to make our lives easier, and throwing out some ideas for new gameplay elements. Levels that we created during this time include `07_colors` and `15_exceptionalCrossing`.

Between late August and early October, we worked in some polish, adding help and menu panes, sound effects, and progress saving via localStorage. During this time, we came up with the idea for the climax of the game (at least difficulty-wise), the robot levels.

In November, Greg and I came up with our plan for how to organize the game. We decided to divide it into three chapters: the first would introduce the primary game mechanics, the second would stop holding the player's hand and keep increasing the difficulty curve, and the third would break the rules we had previously established by introducing a bunch of new crazy things, culminating in a boss fight. We also came up with a barebones plot that was a bit cliche but worked for our purposes, and after trying a few different approaches to establishing the story, we decided that conveying it entirely through code comments would be a nice touch. Now that we finally had a blueprint for the game, progress went much quicker, and by December we had more or less finalized the first two chapters of the game. In the meantime, we also created the loading screen and credits and found most of the background music that we wanted (aside: [Free Music Archive](http://freemusicarchive.org/) is amazing).

Around New Year's, we posted our new Untrusted prototype on Facebook for our friends to playtest. One thing that we noticed was that, even after all of the security improvements we had tried to add over the past year, people still managed to find a bunch of different exploits that enabled them to arbitrarily skip levels. Now, we definitely feel that finding ways to break the system is a big part of what Untrusted is about, and we don't want to discourage it entirely, but if you can find a single exploit that lets you get around every level, that's not very fun. In light of this, we came up with a mechanism to completely prevent players from accessing methods we don't want them to access.

[security]

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

## Release

- initial spike on HN
- after an hour, dad's server couldn't handle the load
    - problem: too much bandwidth usage, esp because music
    - people became unable to load levels (because each level was a separate AJAX call)
- solutions
    - short-term solution: move to github pages ASAP
    - move music to cloudfront
    - overnight, Greg and I fixed level loading to prevent this issue from occurring again - all levels now loaded from start (except bonus levels + scripts for lvl21)

## Reactions to Untrusted

If I may brag for a moment: Six months after its release to the world, Untrusted has been played 700,000 times by 380,000 players from 196 countries (top five countries, in order: United States, Russia, China, Poland, France). The Untrusted GitHub repository has been starred nearly 2000 times and forked 400 times. It's certainly become much more popular than either of us had expected from our half-baked last-minute hackathon idea last year.

A few articles have been written about us. My favorites include:
  - [see untrusted-mentions.txt]

Far more exciting are all the different ways we've seen Untrusted used:
  - (e.g. schools, translations, mods)

[some words go here]

## What's Next for Untrusted?

[potential things in pipeline]

As for the game itself, [...]

[some words go here]
