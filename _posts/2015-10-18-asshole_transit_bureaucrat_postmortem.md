---
layout: post
title: Postmortem - Asshole Transit Bureaucrat 2015
tags: [games, creations, elm, frp, ludum dare, fun, asshole transit bureaucrat 2015, jam, greg, tikhon, matt, transportation]
---

->[![Asshole Transit Bureaucrat 2015](http://i.imgur.com/sMHxmYf.png?2)](https://web.archive.org/web/20160820081148/http://ludumdare.com/compo/ludum-dare-33/?action=preview&uid=3353)<-

This postmortem's been a long time coming, in part because I don't know if I can call my team's submission to this last Ludum Dare, [Asshole Transit Bureaucrat 2015](https://web.archive.org/web/20160820081148/http://ludumdare.com/compo/ludum-dare-33/?action=preview&uid=3353), a _game_, per se. But we did end up scoring well in a few categories, so perhaps I was a bit too harsh. Let's discuss what went right and wrong.

## What went wrong

### Too much conceptual complexity

This is a bit of a common problem with me and Ludum Dare: it's been an issue with [It's Not Easy Being Muammar](https://web.archive.org/web/20160821020212/http://ludumdare.com/compo/ludum-dare-20/?action=preview&uid=3353) and, to some extent, [Asteroid Tycoon](http://alex.nisnevich.com/blog/2014/05/07/asteroid_tycoon_postmortem.html). In this case, the complexity bit us in two ways.

On the one hand, it was hard for players to understand what was going on. The goal was already a difficult one to wrap your head around (make a transit system _less_ efficient? what does that _mean_?), but the fact that the only thing you were able to control was the order of stops in a bus route made it even worse. Add to that the fact that there were some subtle issues with the buses that prevented them from always following their prescribed routes, and players were left completely clueless.

On the other hand, it was exceptionally difficult for us to actually make the damn thing work. We ended up only being able to spend maybe 20% of our time working on gameplay because just getting the traffic simulation part working took so much time and energy. It definitely shows.

### Homogenous team

[Last time around](http://alex.nisnevich.com/blog/2014/09/27/shattered_worlds_postmortem.html), we had a healthy mix of programmers, designers, artists, and musicians. This time, we just had three programmers and a part-time musician. To make matters worse, we were all the _same kind_ of programmer, more or less -- all functional programming nerds -- and so we all tended to approach problems the same way.

This experience has really hammered into me the importance of a diverse team: it would have been great to have some people on our team looking at problems from the player's perspective (something the three of us didn't do nearly enough of).

### Poor task management

Tying into the above, because Greg, Tikhon, and I all have similar interests, we all wanted to work on similar problems. And none of us is particularly good at being a taskmaster. As a result, task management was a constant issue.

One of us spent a full day working on a level editor, just because it was a fun problem, even though we couldn't even integrate it into the final game. We kept ironing out theoretical edge cases in the engine because it was technically interesting, even though we had no working game to plug it into yet. 

When we did split up tasks (one of us worked on the engine, another on the game UI), we didn't sync up about the interface we wanted well enough, with the result being that integrating all our individual work together was a minor nightmare.

All of this could have been avoided if we'd been a little more principled about how we approached tasks. In the past, Jordan and I were usually the once to figure out how to manage the team. Maybe I need to start learning how to do that on my own.

## What went right

### Sticking to it

As the last few hours of the jam approached, it was clear that, no matter what we did, we wouldn't have a finished game. At best we'd have three levels that _kinda, sorta_ worked, a hastily-put-together and not quite complete interface, and an abrupt ending.

The big question wasn't how to finish the game. It was whether to even submit it or just not bother.

I was unsure initially, but now I'm glad we submitted it, incomplete though it was. We got a ton of interesting feedback, and ended up scoring #126 in Audio and #127 in Innovation. It's not our best yet, but hey - it's better than nothing!

### The best possible aesthetics given our constraints

The look and feel of the game are something I'm proud of, especially given what we managed to accomplish with no artists or full-time musicians.

We made some good tradeoffs. For art, rather than taking the easy way out and making a purely text-oriented game (as I've [done](https://web.archive.org/web/20160818212509/http://www.ludumdare.com/compo/ludum-dare-27/?action=preview&uid=3353) [before](https://web.archive.org/web/20160818213213/http://ludumdare.com/compo/ludum-dare-22/?action=preview&uid=3353)), we painstakingly put together an almost-hypnotic minimalist traffic simulator. It's a lot of fun to look at, gameplay aside.

And for music, we only had a few hours of our Matt's time, so we had a choice. He could either make a couple really quick tracks, or a single complex and well-put-together track. We opted for the latter, and it was a good choice - it's just one track that repeats over and over, but it's a damn good one, and fits well with the aesthetics of the game.

### A sense of playfulness

_Asshole Transit Bureaucrat 2015_ was never meant to be a game that takes itself seriously. We address a topical issue, but the whole game, from the premise to the in-game text, is completely and knowingly absurd.

Not taking ourselves seriously helped us stay motivated when things weren't going well, and I think it helped our players go easy on us, too.

## What went OK

### Using Elm

Well, this is a tricky one. [Elm](http://elm-lang.org/) is my favorite programming language right now, and I was really looking forward to finally getting to use it in a Ludum Dare. But, as much as I enjoy working with it, I'm not sure whether it actually made our lives any easier (as compared to using JavaScript, which we've always done before).

The main problem with using a lesser-known language in a hackathon is the lack of frameworks and libraries that can simplify your task. In past Ludum Dares, I've managed to offload a lot of the complexity of my games onto libraries, whether it was [rot.js]() for _10 Second Roguelike_, [javascript-astar](https://github.com/bgrins/javascript-astar) for the pathfinding in _Asteroid Tycoon_, or [PhysicsJS](http://wellcaffeinated.net/PhysicsJS/) for _Shattered Worlds_. With _Asshole Transit Bureaucrat 2015_, we had to write everything from scratch (on top of the rather poorly-documented [elm-graph](https://github.com/sgraf812/elm-graph)).

On the other hand, it's not like there's a lot of traffic simulation libraries in JavaScript anyway, so maybe the issue wasn't so much our choice of language as our unusual concept.

The FRP (functional reactive programming) paradigm neither helped nor hurt us, I think. In some ways, it made it easier to reason about the motion of vehicles to think of movement as a single function from State to State, but we could probably have gotten away with the object-oriented approach of treating each car as an a separate agent. It's mostly a matter of preference.

One thing I'd like to do differently next time is to prioritize the game over the language -- in other words, use the language that makes the most sense for whatever the game concept is, be it Elm, JavaScript, or maybe something else entirely.

## In conclusion

All in all, this one didn't go so well. But at least we learned something.

Next time, hopefully we'll be able to make a complete game again.
