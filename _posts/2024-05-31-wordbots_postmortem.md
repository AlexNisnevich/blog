---
layout: post
title: A Belated Wordbots Dev Diary / Retrospective (~1 Year Post-Release)
tags: []
date: 2024-05-29
---

About a year ago, I "released"* [Wordbots](https://wordbots.io/), the tactical card game with user-created cards that I'd been working on since 2016.

_(* I say "released" in quotes because this isn't really the sort of game that will ever become feature-complete, especially not as a side project. But on April 29, 2023, I declared it fully playable and ready to graduate from alpha into an eternal "beta" stage, in which I'm no longer actively developing new features but continue to fix bugs and make minor improvements as time permits._)

Getting Wordbots from concept to fully playable beta was a _journey_. It was one of the hardest things I've done in my life and by far the largest project I've ever started, in all senses of the word – the biggest in scope, the most time-intensive, and the most emotionally draining to work on. Would I have started working on Wordbots if I'd known how long it would take and what a torturous path I'd go on to "finish" it? I'm not sure. But in any case, I'm glad I did it.

(For those new to Wordbots, here's [a little bit about it](https://app.wordbots.io/about), and here's [more about its technical underpinnings](https://app.wordbots.io/how-it-works)!)

## <a name="toc"></a>Table of Contents
* [First, a visualization!](#visualization)
* [A (not so) brief history of Wordbots](#history)
  * [The beginning (summer 2016–fall 2017)](#history-1)
  * [Slow but steady improvement (fall 2017–summer 2019)](#history-2)
  * [Distractions and demoralization (summer 2019–summer 2022)](#history-3)
  * [The final push (fall 2022–spring 2023)](#history-4)
  * [And finally, the release! (April 2023 and beyond)](#history-5)
* [What went right](#what-went-right)
* [What went wrong](#what-went-wrong)
* [Final thoughts / Conclusions](#final-thoughts)
* [Acknowledgements](#acknowledgements)

## <a name="visualization"></a>First, a visualization!
Before I talk about my successes and challenges with Wordbots, it might be helpful to throw up a little graph I made illustrating the development process as the story of git commits and releases, from my first-ever parser commit to just after the beta release:

<img class="figure" style="max-width: 100%" src="/blog/images/wordbots-dev-history.png" />

I should mention that I was fortunate to have a lot of help throughout this process, especially from [my brother](https://github.com/jacobnisnevich) but also from a whole host of people who made contributions of code or art or playtesting or feedback, [who are credited here](https://app.wordbots.io/about). I did end up making the vast majority of commits in both the core game and the parser, so this chart simultaneously shows the development cycle/cadence of Wordbots as a whole while also illustrating my own personal journey working on it.

As the chart makes painfully clear, working on Wordbots was not a totally smooth process. Let me explain how it all went down.

## <a name="history"></a>A (not so) brief history of Wordbots

### <a name="history-1"></a>The beginning (summer 2016–fall 2017)
The original idea for Wordbots came to me as I was working on open-sourcing [Montague](https://github.com/Workday/upshot-montague), the semantic parsing library that I'd worked on with [Joseph Turian](https://github.com/turian) and Thomas Kim at the long-forgotten NLP startup [UPSHOT](https://blog.workday.com/en-us/2015/workday-acquires-upshot-strengthens-data-science-expertise.html).

At its core, Montague is a fancy CKY parser that parses a CCG grammar and maps parsed tokens to semantic definitions, given as lambda-calculus terms in a provided lexicon. It is _ancient_ technology by NLP standards (after all, the CKY parsing algorithm dates back to a 1961 paper), but we came up with a clever design that ties these concepts together in what I think is a user-friendly way. In essence, Montague took something that had been _possible_ for decades (domain-constrained semantic parsing) and made it easy (and, dare I say, even fun).

Our original use case for semantic parsing at UPSHOT was translating English to database queries – hardly riveting stuff. But as we were writing the documentation for Montague, I began to brainstorm other possible applications for it, initially just to better figure out how to communicate the breadth of what our parser was capable of. After working through [a few toy examples](https://github.com/Workday/upshot-montague?tab=readme-ov-file#getting-started), I started thinking of what semantic parsing could be used for within a gaming context. I thought back to card games like Magic: the Gathering and Fluxx, where individual cards (in Fluxx, sometimes even player-made cards!) could completely alter the game's rules. I'd also recently played and enjoyed the now-defunct online tactical card game [Atomic Brawl](https://atomicbrawl.com/) and imagined a tactical card game with cards that players could make themselves, with the card text automatically parsed and translated to a programming language, perhaps JavaScript. While writing the Montague README, I even mentioned this idea as an ["exercise for the reader"](https://github.com/Workday/upshot-montague?tab=readme-ov-file#applications):

> **Applications Exercise 5. † Game semantics.** Come up with a semantic scheme for representing rule descriptions for a simple card game (think Magic, Hearthstone, etc., but simplify!) For example, a card may say something like "Whenever your opponent loses life, draw a card". Then write a parser for it.

We open-sourced Montague in March 2016, and Joseph and I [gave a talk about it](https://www.youtube.com/watch?v=lnV2JnNBM1I) at the Strata conference that June. That fall, I started playing with my game idea, building up a lexicon in Montague that could handle simple actions and trigger expressions like "At the end of each turn, each creature takes 1 damage" and turn them into JavaScript code. But there was still no actual game that these cards supported – it was essentially just a tech demo with an artificial lexicon that vaguely evoked a positional card game.

While visiting my family over Thanksgiving, I showed [my brother Jacob](https://github.com/jacobnisnevich) what I'd built, and he was clearly as excited about the concept as I was. He had some React experience at the time (I'd never touched React at that point), and we quickly threw together a game prototype in React over the long weekend, using Hannu Kärkkäinen's [react-hex-grid](https://github.com/hellenic/react-hexgrid) library for the board rendering and logic. By the end of the year, we had a barebones UI that could render a board and cards – nothing resembling a game yet, but enough of a skeleton that we could envision a path forward:

<img class="figure" style="max-width: 50%" src="/blog/images/wordbots-f25aaa8630acada25c64eb61bbdaf0350224cbf8.png" />

I left my job at the start of 2017 and decided that I may as well take advantage of my newfound free time. I resolved to stay "funemployed" until the end of the year and try to finish Wordbots by then. I started working on Wordbots essentially full-time in January, gaining proficiency in the React ecosystem along the way, and Jacob and I were able to make rapid progress on the prototype. By early April, we reached our v0.1.0 milestone: a fully functional prototype with working card creation and multiplayer gameplay, albeit limited features aside from that (and it certainly wasn't much to look at):

<img class="figure" style="max-width: 70%" src="/blog/images/wordbots-v0.2.0-alpha.png" />

Progress continued quickly as I built up steam. By the end of April _(v0.4.0)_, we had spectator support, activated abilities, card import/export, turn timer, and a huge amount of new card mechanics. By the end of May _(v0.5.4)_: user accounts, auto-generated documentation, SFX, and more card mechanics. June _(v0.6.2)_: tutorial mode and the "Did You Mean" feature in the card creator. July _(v0.7.0)_: practice mode, in-game animations, and a major UX redesign.

We were quickly running through our feature roadmap, and an end seemed in sight. But I couldn't maintain this pace for long.

### <a name="history-2"></a>Slow but steady improvement (fall 2017–summer 2019)

I'd planned to take all of 2017 off of work, but for various reasons (including a health insurance snafu), I ended up interviewing again in the summer. I started my current job in the fall, and, coupled with a couple of big international trips that I took in quick succession, I got out of the Wordbots groove.

The next few months didn't bring many major new gameplay features. I worked more on ironing out things at the margins: tweaking the UX, fixing bugs, adding new things to the parser, and generally trying to make things more user-friendly.

In April 2018, Jacob and I felt that the game was sufficiently polished for an official playtesting round. We'd shown it to a few people before, but never anything like this: we solicited participants in our social networks, ultimately sending out a link as well as some playtesting guidelines to 30 of our friends. And then we waited ... And waited ... And waited ... Of our 30 playtesters, only 3 gave us any substantial feedback, and hardly anyone responded at all. As far as I could tell, even people who really wanted to try Wordbots seemed to have been thoroughly stumped by the experience of trying to "play" it.

Needless to say, the failed playtest round was a demoralizing experience for us. Still, it was helpful, if disheartening, to learn that our new-player user experience was, to be frank, garbage, and we began to rethink our priorities. One critical conversation that started from this was our attempt to answer a question that we'd been punting on up until this point: **_how could we make playing Wordbots a "fair" experience?_** After all, if players can design any cards they want, nothing is stopping a player from making some kind of "Win the game immediately" card and stuffing their deck with it. And this would be totally legal in the only Wordbots gameplay format that existed at the time _(we now call this the "Anything Goes" format and discourage people from playing it except with their friends)_.

We brainstormed a few possible solutions to the fairness question:
* Use some kind of ML model to predict how powerful given cards are and assign them in-game energy costs accordingly?
* Set up a server constantly simulating games between AI players with various cards to determine empirically how effective each card is in practice?
* Set up some kind of market-based mechanic where players could trade cards for in-game currency, and how valuable a given card was would determine if it was a "fair" card or not?
* Allow players to make whatever cards they want, but establish game formats where each player is equally likely to have access to an overpowered card in-game?

The final approach seemed to be the only feasible one. Based on player feedback (thanks, Adam B!), we developed a format we called Shared-Deck (later renamed Mash-Up), where both players bring their own deck to the game, but both players' decks are shuffled into one mega-deck that both players draw from throughout the game. The Shared-Deck/Mash-Up format injected new life into Wordbots and made matches exciting again. For perhaps the first time, I actually found myself having fun _playing_ Wordbots with people, not just developing it.

In the fall, thanks to some word-of-mouth among Jacob's friends, we'd assembled a small team of people interested in working on Wordbots and even started holding regular standups. Unfortunately, it ended up proving hard to divide the work, and Jacob and I still ended up doing the bulk of it. But having the regular cadence of standups helped maintain developer interest, at least amongst Jacob and myself. And our broader team provided a useful sounding board for trying new ideas and for deciding how to prioritize our work.

Around this time, a succession of particularly hard-to-catch bugs convinced us that it would be worth it to begin migrating the codebase from JavaScript to TypeScript. I was initially leery of such a massive undertaking but was convinced to try it when it became clear that we could do it a little bit at a time, starting with the particularly brittle multiplayer code (and eventually ending, about two years later, with the React components). Little by little, we gained type safety throughout the Wordbots client code. Though it was a slog at times, the TypeScript refactor ultimately paid dividends by eliminating whole classes of bugs and making significant chunks of our code easier to reason about. 

In April 2019, with v0.12.0 of Wordbots, we introduced the concept of "sets", another answer to the "making Wordbots fair" question. Sets provided a way for players to curate their own collections of cards and challenge other players to make decks using only those cards. Finally, there was now a way for players to build and use thematic decks of player-made cards without worrying about huge power imbalances.

I intended Sets to be the last major concept added to Wordbots and began to think about what it would take to finally release the game to the wider world. I wrote a document called "Wordbots: The Final Stretch," spelling out the remaining tasks needed to finish Wordbots, in the four categories of User-Friendliness, Robustness, Community, and Accessibility. Of course, "final stretch" turned out to be a little optimistic.

### <a name="history-3"></a>Distractions and demoralization (summer 2019–summer 2022)
By the summer of 2019, the amount of free time I had to spend on Wordbots plummeted once more as I began to spend every available weekend going to open houses, as part of our quixotic quest to buy a fourplex with our friends to live in – another massive "side project" with huge emotional highs and lows, that perhaps I'll write about at a later point. In December 2019, we finally closed on a fourplex that ticked off all our boxes but required renovation on a massive scale. And, of course, we know what happened at the start of 2020. We were very fortunate to have the built-in community of our fourplex housemates to weather the lockdown with, but it was still an emotionally draining time. I had the mental bandwidth to manage precisely one project in 2020, and that ended up being the home renovation work, which took the better part of the year and was all-consuming while it was happening.

When I circled my thoughts back to Wordbots in this period, I could no longer picture the end goal; it was just a mountain of work that looked more and more daunting as I spent more time away from it. I began to dread the thought of working on Wordbots, but at the same time, I felt guilty for not working on it. There were times when I couldn't sleep because I was so angry with myself at "wasting my time", for putting so much work into this project just to abandon it ...

Throughout it all, I did manage some intermittent bursts of motivation to work on Wordbots. I was able to finally finish that massive TypeScript refactor by the end of 2020 – it was a good thing to work on while my motivation was limited because I could think of it almost as a puzzle – a puzzle of getting all the types to line up and everything to compile – or as a TypeScript-vs-JavaScript game (I certainly got little dopamine bursts by watching our TypeScript line count go up as the JavaScript line count went down). Around this time, I also slogged through a significant refactor of how cards are stored in the backend, developing a much more robust system of metadata tracking for cards that fixed a number of bugs and enabled many small quality-of-life features down the line.

During a weeklong "Wordbots retreat" in the Lost Coast (a location strategically chosen for poor network connectivity and few distractions) in the summer of 2021, I powered through the work of creating the Set Draft format, a feature that we'd been discussing as a team for a while, and that quickly became my favorite way to play Wordbots. Drafting provided an elegant solution to the "fairness" issue (since either player was equally likely to draft a given card) while also removing the friction of players having to create a deck before playing. With the Set Draft format implemented in v0.16.0, I could finally see the path forward that had eluded me for the past few years.

Other than that, the major gameplay improvements during this time were all aimed at providing a better UX for new players, including a massive interface redesign, art by [Chris Wooten](https://www.artstation.com/christopherwooten), Help and Community pages, a "New Here?" feature, and more flavor throughout the game, as well as flavor text support for cards.

### <a name="history-4"></a>The final push (fall 2022–spring 2023)

I was finally able to get out of my slump and really mount a concerted effort to finish Wordbots in fall of 2022. I'd planned a two-month sabbatical from work to work on another project that fell through at the last minute, so I unexpectedly had a whole bunch of free time, so much free time that after a while I was finally able to push through my mental block and start working on Wordbots in earnest.

In October 2022, I added one final major parser feature – and one that I could only have implemented while on sabbatical because of its colossal complexity – **card rewrite effects**. Finally, Wordbots had an actual gameplay mechanic that no other card game could match – cards could rewrite the very text of other cards. It's certainly a silly addition to Wordbots and perhaps not worth the ROI on the effort spent to make it possible. But it makes me smile, and so into the game it went.

I also put a lot of work into a detailed ["How It Works" page](https://app.wordbots.io/how-it-works) describing the technical background behind Wordbots. I figured that, even if Wordbots was never going to be a successful multiplayer game with a thriving community (and at this point, I was resigned to this fate), at least it could be an interesting tech demo to a certain group of people like me.

Around this time, there was, of course, a much more significant development in the NLP world – the November 2022 release of ChatGPT, which changed the public conversation about NLP seemingly overnight. As I grappled with all my feelings about this brave new world we were entering, one thing I struggled to figure out was, _"what is the place of Wordbots in the new NLP world?"_ After all, as cool as the Wordbots concept seemed to me, it was built on old – let's say _ancient_ technology.

I ultimately settled on the idea of Wordbots as a demonstration of the continued relevance of older NLP approaches. As powerful as statistical NLP is today, there's still value in symbolic AI methods. Could an LLM be used to produce code from card text the way Wordbots does? I'm sure such a thing could be implemented. Still, Wordbots's symbolic AI underpinnings offer some valuable advantages, such as consistency and interpretability. Each term in Wordbots's lexicon can be used repeatedly in consistent, predictable ways, just like natural language works, and not quite how LLMs tend to work with language. And the Wordbots parser is anything but a black box: every card in the game is happy to show off its full parse tree:

<a href="https://app.wordbots.io/static/help/how-it-works.png"><img class="figure" style="max-width: 100%" src="https://app.wordbots.io/static/help/semantic-parse.png" /></a>

This new way of thinking about the purpose of Wordbots helped inspire me over the course of the final push towards beta release, and also led me to write the slightly cheeky _"No LLMs were used in the making of Wordbots"_ disclaimer on the [About page](https://wordbots.io/about).

I finally began to work in earnest on checking off boxes on that old "Wordbots: The Final Stretch" doc I'd written way back in 2019. Much had happened since then, but the overall roadmap was still solid, and I was able to pick up where I left off. Jacob and I started a weekly tradition of Wordbots playtests with each other, and over the next few months, we found and fixed literally dozens of issues with our multiplayer implementation. Other playtests helped us identify other bugs within the game as well as missing quality-of-life features that we proceeded to add, like support for draws, more robust game disconnection handling, support for card rarities in sets, etc. We load-tested the server to make sure it was up to the task of handling more players. We tried out the game in every possible browser (including on tablets). By April 2023, we felt Wordbots had finally reached the point at which it could handle an influx of new players – it could survive in the wild.

### <a name="history-5"></a>And finally, the release! (April 2023 and beyond)

On April 29, 2023, we released Wordbots v0.20.0-beta. We were ready to show Wordbots to the world.

To me, this really meant one thing: posting it on Hacker News. I took a deep breath and made a [Show HN post](https://news.ycombinator.com/item?id=35765274), writing a little about my motivation and process behind Wordbots and providing a link. And then ... crickets. The post got a few likes and quickly dropped off the front page.

I was crushed. Seven years of work, and all that anguish, and all I had to show for it was a multiplayer game with no players, that nobody would ever see. And of course, I was mad at myself for having invested so much of my self-worth into a Hacker News post, and for relying so much on external validation rather than just appreciating Wordbots on its own merits. After all, wasn't the journey the whole point?

I tried posting about Wordbots on some subreddits and my social media, but nobody seemed interested. I resigned myself to the idea that maybe Wordbots just isn't that cool an idea to people other than me and some of my friends ...

One night, a week or so after my initial HN post, on a whim (I might have been a little tipsy) I emailed [dang](https://www.newyorker.com/news/letter-from-silicon-valley/the-lonely-work-of-moderating-hacker-news), the Hacker News moderator, asking him if I could please re-submit Wordbots to Hacker News with a more descriptive title that better explained what was so interesting about Wordbots. To my surprise, he responded and encouraged me to re-post it. [I did](https://news.ycombinator.com/item?id=35879278), and this time around the reaction was much more positive, with a constructive discussion and a whole slew of new players joining the Wordbots community and immediately creating their own unique cards.

Wordbots never became a huge phenomenon with a super active user base. And, to be fair, I didn't expect it to (although it would have been nice!). Not having players constantly online is a bummer because when players do log in, they rarely have anyone to play with. We do have a [Discord server](https://discord.gg/uBM4UbXSPB) that is occasionally active, and some players have used it to schedule games and discuss cards they're working on. And there are definitely still a lot of cards being made, many of them by "die-hard fans," [some of whom](https://app.wordbots.io/community) have designed hundreds of their own cards(!).

I'll admit that I haven't spent as much time working on Wordbots post-release as I'd have liked. I made one big bug-fix release a few months after beta but lost steam afterward and haven't done much since. I'm definitely due for at least another round of bug fixes. But remarkably, the game has continued to function even without any intervention on my part – the server is still up, the parser still works, players are still creating cards, and occasionally games are being played, all without critical bugs. I'm pretty proud of what I've made, and I'm glad it's still bringing joy to people.

Having written all that, I think I ought to do the classic "what went right / what went wrong" retrospective. So here goes!

## <a name="what-went-right"></a>What went right

#### 1. Sticking through to completion

The single thing that I'm most glad about in the Wordbots development process is that, well ... we finished it! There were certainly various degrees of motivation throughout, and for a while there in 2020-2021, it seemed unlikely to me that I would ever be able to push this thing through to completion. Really, if there is one takeaway I want to offer from this massive, massive blog post, it's "Stick with it!" 

#### 2. Investing in developer productivity

From the very beginning, investing in developer productivity was a major priority of mine. Every change to the parser's lexicon and semantics was accompanied by added unit tests verifying that given strings parsed to the right abstract representation, and it really wouldn't have been possible to keep the parser stable without this, as even small lexical changes could have unexpected impacts on how different sentences parsed (you can check out our current test suite [here]()). And early on in the development of the game client, I built a fairly comprehensive testing harness to make sure cards behaved as expected (using Redux for state management actually made this fairly simple – we had one massive reducer that handled all in-game user interactions, and [most of our tests]() just consisted of simulating actions against this reducer and checking the resulting state).

As our work on Wordbots continued, we made a series of major refactors in 2018–2020 – chief among these being migrating the entire JavaScript codebase to TypeScript and completely overhauling how cards were stored in our Firebase database. While both of these refactors took an immense amount of work in the moment, they greatly improved our confidence in the code and the stability of the whole system, and I'm not sure we would have been able to get Wordbots to beta without them.

#### 3. Soliciting feedback throughout

So much of what makes Wordbots work today – from the game formats that make games fair to all sorts of card behaviors all the way to the look and feel of the interface itself – owe their existence to player feedback. I'm really glad that we continued to playtest Wordbots and continually showed it to new people throughout the development process (even if some of the playtest rounds were demoralizing to Jacob and I due to lack of player interest). 

I also just want to mention my immense gratitude to our mega-testers and sounding boards, who gave us the feedback and critique that led to so many features and fixes: Asali, James, Annie, Danny, Adam, Honza – thank you!

#### 4. Me working throughout the whole stack, from the game client to the parser

This can also be thought of as a con (it's really a symptom of me not being able to really build up a Wordbots team like I wanted to), but on the bright side, the fact that I had to work on every single part of Wordbots was liberating in the sense that as I lost steam working on one part of the game, I always had the option to shift gears to other parts. This proved very helpful, especially during the lower-motivation periods – oftentimes, my gateway drug for working on Wordbots was fixing parser bugs or adding new vocabulary to the parser, as these were usually such self-contained projects that it was easy to pick up and work on them for short periods of time. 

#### 5. The Wordbots concept itself

Finally, I should mention the general Wordbots concept itself as a major "pro" – after all, it was a strong enough idea that the vision was able to push us through to the end despite all the challenges along the way! I can't think of many projects I'd be able to work on through to completion for seven years, but this has definitely been one of them.

## <a name="what-went-wrong"></a>What went wrong

#### Struggling with motivation

* Struggling with motivation, thinking of it as an obligation rather than a fun project half the time

#### Making a multiplayer game in the first place?

#### Sticking to tools we knew

* Sticking to tools we knew rather than doing more initial research (React? MaterialUI? ancient version of Scala used by Montague)

#### Never finding a good way to split up work among a team

* Never really figuring out how to make use of the many people I had / not doing a good job of splitting up work

#### Not thinking about the new-player experience soon enough

* Not thinking about onboarding / new-player experience until waaay too late in the game (essentially wasting our biggest playtest as a result)

#### Spending too much time on dead ends

* spending perhaps too much time exploring dead ends or not-very-useful avenues just by being driven by what's interesting to work on rather than what is important for Wordbots ("hackathon" mentality) – examples include automated cost calculation, the automated card generation thing for tests

## <a name="final-thoughts"></a>Final Thoughts / Conclusions

[TODO this section]

## <a name="acknowledgements"></a>Acknowledgements

[TODO this section / or just link to About page?]
