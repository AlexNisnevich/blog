---
layout: post
title: A Belated Wordbots Dev Diary / Postmortem (~1 Year Post-Release)
tags: []
date: 2024-05-29
---

About a year ago, I "released"* [Wordbots](https://wordbots.io/), the tactical card game with user-created cards that I'd been working on since 2016.

_(* I say "released" in quotes because, well, this isn't really the sort of game that will ever be feature-complete, especially not as a side project. But on April 29, 2023, I declared it fully playable and ready to graduate from alpha into an eternal "beta" stage, in which I'm no longer actively developing new features but continue to fix bugs and make small improvements as time permits._)

Getting Wordbots from concept to fully-playable beta was a _journey_. It was one of the hardest things I've done in my life and far the largest project I've ever started, in all senses of the word – the biggest in scope, the most time-intensive, and the most emotionally draining to work on. Would I have started working on Wordbots if I'd known how long it would end up taking and what a torturous path I'd go on to "finish" it? I'm not sure. But in any case, I'm glad I did it, in the end.

[TODO link to a "what is wordbots?" for those who don't know?]

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
Before I talk about my successes and challenges with Wordbots, it might be helpful to throw up a little graph I made illustrating the development process as the story of git commits and releases:

<img class="figure" style="max-width: 100%" src="/blog/images/wordbots-dev-history.png" />

I should mention that I was fortunate to have a lot of help ... blah blah blah Jacob ... blah blah blah see acknowledgements ... blah blah blah commit ... blah blah blah in the end about 95% of the commits were my own, so this chart shows both the development cycle/cadence of Wordbots as a whole as well as illustrating my own personal journey working on Wordbots.

As the chart makes painfully clear, working on Wordbots was not a totally smooth process. Let me go into how it all went down ...

## <a name="history"></a>A (not so) brief history of Wordbots

### <a name="history-1"></a>The beginning (summer 2016–fall 2017)
The original idea for Wordbots came to me as I was working on open-sourcing [Montague](https://github.com/Workday/upshot-montague), the semantic parsing library that I'd worked on with [Joseph Turian]() and [Thomas Kim]() at the long-forgotten NLP startup [UPSHOT]().

At its core, Montague is a fancy CKY parser that parses a CCG grammar and maps parsed tokens to semantic definitions, given as lambda-calculus terms in a provided lexicon. It is _ancient_ technology by NLP standards (after all, the CKY parsing algorithm dates back to a 1961 paper), but we came up with a clever design that ties these concepts together in what I think is a user-friendly way. In essence, Montague took something that had been _possible_ for decades (domain-constrained semantic parsing) and made it easy (and, dare I say, even fun).

Our original use case for semantic parsing at UPSHOT was translating English to database queries – hardly riveting stuff. But as we were writing the documentation for Montague, I began to brainstorm other possible applications for it, initially just to better figure out how to communicate the breadth of what our parser was capable of. After working through [a few toy examples](), I started thinking of what semantic parsing could be used for within a gaming context. I thought back to card games I liked like Magic: the Gathering and Fluxx, where individual cards (sometimes even player-made cards, in Fluxx) could completely alter the rules of the game being played. [... positional card games ... Cosmic Encounter ...]

[game as exercise for Montague]

We open-sourced Montague in March 2016, and Joseph and I [gave a talk about it]() at the Strata conference that June. That fall, I started playing around with Montague on my own, building up a lexicon that could handle simple actions and trigger expressions like "At the end of each turn, each creature takes 1 damage" and turn them into very abstract JavaScript code. But there was still no actual game that these cards supported – it was essentially just a tech demo with a completely artificial lexicon that vaguely evoked a positional card game.

While visiting my family over Thanksgiving, I showed [my brother]() what I'd built, and he was clearly as excited about the concept as I was. He had some React experience at the time (I'd never touched React at that point) and we quickly threw together a game prototype in React over the long weekend, using Hannu Kärkkäinen's [react-hex-grid]() library for the board rendering and logic. By the end of 2016, we had some very basic rendering for board and cards – nothing resembling a game yet, but enough of a framework that we could envision a path forward:

<img class="figure" style="max-width: 50%" src="/blog/images/wordbots-f25aaa8630acada25c64eb61bbdaf0350224cbf8.png" />

I left my job at the start of 2017 and decided that I may as well take advantage of my newfound free time. I resolved to stay "funemployed" until the end of the year and try to finish Wordbots in that time period. I started working on Wordbots essentially full-time in January, gaining proficiency in the React+Redux ecosystem along the way, and Jacob and I were able to make rapid progress on the prototype. By early April, we reached our v0.1.0 milestone: a fully-functional prototype with working card creation and multiplayer gameplay, albeit limited features aside from that (and it certainly wasn't much to look at):

<img class="figure" style="max-width: 70%" src="/blog/images/wordbots-v0.2.0-alpha.png" />

Progress continued quickly as I was on a roll and working on Wordbots nonstop. By the end of April _(v0.4.0)_, we had spectator support, activated abilities, card import/export, turn timer, and a huge amount of new card mechanics. By the end of May _(v0.5.4)_: user accounts, auto-generated documentation, SFX, and more card mechanics. June _(v0.6.2)_: tutorial mode and the "Did You Mean" feature in the card creator. July _(v0.7.0)_: practice mode, in-game animations, and a major UX redesign.

We were quickly running through our feature roadmap, and an end seemed in sight. But I couldn't maintain this pace for long.

### <a name="history-2"></a>Slow but steady improvement (fall 2017–summer 2019)

I'd planned to take all of 2017 off of work, but for various reasons (including a health insurance snafu), I ended up interviewing again in the summer. I started my current job in the fall, and, coupled with a couple of big international trips that I took in quick succession, I got out of the Wordbots groove.

The next few months didn't bring a lot of major new gameplay features. I worked more on ironing out things at the margins: tweaking the UX, fixing bugs, adding new things to the parser, trying to make things more user-friendly, etc.

In April 2018, Jacob and I felt that the game was sufficiently polished for an official playtesting round. We'd shown it to a few people before, but never anything like this: we solicited participants in our social networks, ultimately sending out a link as well as a brief playtesting brief to 30 of our friends. And then we waited ... And waited ... And waited ... Of the 30 playtesters, only 3 gave us any substantial feedback at all, and hardly anyone responded at all. As far as I could tell, even people who really wanted to try Wordbots seemed to have been thoroughly stumped by the experience of trying to "play" it.

Needless to say, the failed playtest round was a demoralizing experience for us. Still, it was helpful, if disheartening, to learn that our new-player experience was garbage, and we began to rethink our priorities. One critical conversation that started from this was our attempt to answer a question that we'd been punting on up until this point: **_how could we make playing Wordbots a "fair" experience?_** After all, if players can design any cards they want, there's nothing stopping a player from making some kind of "Win the game immediately" card and stuffing their deck with it. And this would be totally legal in the only Wordbots gameplay format we had at the time (which we now call the "Anything Goes" format and discourage people from playing unless it's with their friends).

We brainstormed a few possible solutions to the fairness question:
* Use some kind of ML model to predict how powerful given cards are, and assign them costs accordingly.
* Set up a server constantly simulating games between AI players with various cards to determine empirically how effective each card is in practice.
* Set up some kind of market-based mechanic where cards could be traded for in-game currency, and how valuable a given card was would determine if it's a "fair" card or not.
* Don't try to control which cards can be made, but rather establish alternative game formats where each player is equally likely to have access to an overpowered card in-game.

We ultimately settled on the final approach as the only feasible one. Based on player feedback (thanks, Adam B!), we developed a format we called Shared-Deck (later renamed Mash-Up), where both players bring their own deck to the game, but both players' decks are shuffled into one mega-deck that both players draw from throughout the game. The Shared-Deck/Mash-Up format injected new life into Wordbots and made matches exciting again. For perhaps the first time, I actually found myself having fun playing Wordbots with people, not just developing it.

In the fall, thanks to some word-of-mouth among Jacob's friends, we'd assembled a small team of people interested in working on Wordbots and even started holding regular standups. Unfortunately, it ended up proving hard to actually divide the work, and Jacob and I still ended up doing the bulk of it. But having the regular cadence of standups helped maintain developer interest, at least amongst Jacob and myself.

Around this time, a succession of particularly hard-to-catch bugs convinced us that it would be worth it to begin migrating the codebase from Javascript to TypeScript. I was initially leery of such a massive undertaking, but was convinced to try it when it became clear that we could do it a little bit at a time, starting with the particularly brittle multiplayer code (and eventually ending, about two years later, with the React components). Little by little, we gained type-safety throughout the Wordbots client code, and, though it was a slog at times, ultimately the TypeScript refactor would pay dividends in eliminating whole classes of bugs and making major chunks of our code easier to reason about. 

In April 2019, with v0.12.0 of Wordbots, we introduced the concept of "sets", another answer to the "making Wordbots fair" question. Sets provided a way for players to curate their own collections of cards and challenge other players to make decks using only those cards. Finally, there was now a way for players to build and use thematic decks of player-made cards without worrying about huge power imbalances.

I saw the addition of sets as the last major concept to make my Wordbots vision possible, and began to think about what it would take to finally release the game to the wider world. I wrote a doc called "Wordbots: The Final Stretch", spelling out the remaining work to get Wordbots "finished" (i.e. ready to be played by people who aren't our friends), in the four categories of User-Friendliness, Robustness, Community, and Accessibility. Of course, "final stretch" turned out to be optimistic.

### <a name="history-3"></a>Distractions and demoralization (summer 2019–summer 2022)
By the summer of 2019, the amount of free time I had to spend on Wordbots plummeted once more as I began to spend every available weekend going to open houses, as part of our quixotic quest to buy a fourplex with our friends to live in – another massive "side project" with huge emotional highs and lows, that perhaps I'll write about at a later point. In December 2019, we finally closed on a fourplex that ticked off all our boxes but required renovation on a massive scale. And of course, we know what happened at the start of 2020. We were very fortunate to have the built-in community of our fourplex housemates to weather the lockdown period with, but it was still an emotionally draining period. I had the mental bandwidth to manage exactly one project in 2020, and that ended up being the home renovation work, which took the better part of the year and was all-consuming while it was happening.

When I did circle my thoughts back to Wordbots in this period, I could no longer picture the end goal, just a mountain of work that looked more and more daunting as I spent more time away from it. I began to dread the thought of working on Wordbots, but at the same time felt guilty for not working on it. There were times when I couldn't sleep because I was so angry with myself at "wasting my time", for putting so much work into this project just to abandon it ...

Throughout it all, I did manage to have intermittent bursts of motivation to work on Wordbots. I was able to finally finish that massive TypeScript refactor by the end of 2020 – it was a good thing to work on while my motivation was limited, because I could think of it almost as a puzzle, in getting all the types to line up and everything to compile, and watching our TypeScript line count go up as the Javascript line count went down provided a nice visual progress indicator, gamifying the whole thing. Also at the end of 2020, I slogged through a large refactor of how cards are stored in the backend, developing a much more robust system of metadata tracking for cards that fixed a number of bugs and enabled a lot of small quality-of-life features down the line.

During a weeklong "Wordbots retreat" in the Lost Coast (a location strategically chosen for poor network connectivity and few distractions) in summer of 2021, I powered through the work of creating the Set Draft format, a feature that we'd been discussing as a team for a while, and that quickly became my favorite way to play Wordbots. Drafting provided an elegant solution both to the "fairness" issue (since either player was equally likely to draft a given card), while also removing the friction of players having to create a deck prior to playing. With the Set Draft format implemented in v0.16.0, I could finally begin to see the path forward that had eluded me for the past couple of years.

Other than that, the major gameplay improvements during this time were all aimed at providing a better UX for new players, including a massive interface redesign, art by [Chris Wooten](), Help and Community pages, a "New Here?" feature, and more flavor throughout the game, as well as flavor text support for cards.

### <a name="history-4"></a>The final push (fall 2022–spring 2023)

I was finally able to get out of my slump and really mount a concerted effort to finish Wordbots in fall of 2022. I'd planned a two-month sabbatical from work to work on another project that fell through at the last minute, so I unexpectedly had a whole bunch of free time, so much free time that after a while I was finally able to push through my mental block and start working on Wordbots in earnest.

In October 2022, I added one final major parser feature, and one that I could only have implemented while on sabbatical because of its huge complexity: **card rewrite effects**. Finally, Wordbots had an actual gameplay mechanic that no other card game could really match – cards could rewrite the very text of other cards. It's certainly a silly addition to Wordbots, and perhaps not necessarily worth the ROI on the effort that was spent to make it possible. But it makes me smile, and so into the game it went.

I also put a lot of work into a detailed ["How It Works" page](https://app.wordbots.io/how-it-works) describing the technical background behind Wordbots. I figured that, even if Wordbots was never going to be a successful multiplayer game with a thriving community (and at this point I was resigned to this fate), at least it could be an interesting tech demo to a certain group of people like me.

Around this time, there was of course a much bigger development in the NLP world – the November 2022 release of ChatGPT, which changed the public conversation about NLP seemingly overnight. As I grappled with all my feelings about this brave new world we were entering, one thing I struggled to figure out was _what is the place of Wordbots in the new NLP world?_ After all, as cool as the Wordbots concept seemed to me, it was built on old – let's say _ancient_ technology.

I ultimately settled on the idea of Wordbots as a demonstration of the continued relevance of older NLP approaches, and the idea that, as powerful as statistical NLP is today, there is still value in symbolic AI methods. Could an LLM be used to produce code from card text the way Wordbots does? I'm sure such a thing could be implemented. But Wordbots's symbolic-AI underpinnings offer some advantages that are really useful: for example, consistency and interpretability. Each term in Wordbots's lexicon can be used repeated in consistent ways, just like natural language, and not quite how LLMs tend to work with language. And the Wordbots parser is anything but a black box: every card in the game is happy to show off its full parse tree.

This new way of thinking about the purpose of Wordbots helped inspire me over the course of the final push towards beta release, and also led me to write the slightly cheeky _"No LLMs were used in the making of Wordbots"_ disclaimer on the [About page](https://wordbots.io/about).

I began to finally work in earnest on checking off boxes on that old "Wordbots: The Final Stretch" doc I'd written way back in 2019. Much had happened since then, but the overall roadmap was still solid, and I was able to pick up where I left off. Jacob and I started a weekly tradition of Wordbots playtests with each other, and over the next few months, we found and fixed literally dozens of issues with our multiplayer implementation. Other playtests helped us identify other bugs within the game as well as missing quality-of-life features that we proceeded to add, like support for draws, more robust game disconnection handling, support for card rarities in sets, etc. By April 2023, we felt like Wordbots had finally reached the point at which it could handle an influx of new players – it could survive in the wild. We'd load-tested it to make sure the server was up to the task of handling more players, tried it out in every possible browser (including on tablets), had our close friends look at it one more time ... it was ready for beta release.

### <a name="history-5"></a>And finally, the release! (April 2023 and beyond)

On April 29, 2023, we released Wordbots v0.20.0-beta, the first version of the game to get the "beta" identifier. We were ready to show Wordbots to the world.

To me, this really meant one thing: posting it on Hacker News. I took a deep breath and made a Show HN post, writing a little bit about my motivation and process behind Wordbots and providing a link. And then ... crickets. The post got a few likes and quickly dropped off the front page.

I was crushed. Seven years of work, and all that anguish, and all I had to show for it was a multiplayer game with no players, that nobody would ever see. And of course I was mad at myself for having invested so much of my self-worth into a Hacker News post, and for not being able to appreciate Wordbots [...]

I tried posting about Wordbots on my own social media and on some subreddits, but nobody seemed interested. I resigned myself to [...]

One night, a week or so after my initial HN post, on a whim (I might have been a little tipsy) I emailed [dang](), the Hacker News moderator, asking him if I could please re-submit Wordbots to Hacker News with a more descriptive title that better explained what was so interesting about Wordbots. To my surprise, he responded and encouraged me to re-post it. [I did](https://news.ycombinator.com/item?id=35879278), and this time around the reaction was much more positive, with a constructive discussion and a whole slew of new players joining the Wordbots community and immediately creating their own unique cards.

[work after release]

[after release / current status]

### <a name="history-7"></a>Wordbots today (/post-release thoughts)

[TODO this section, or remove it?]

## <a name="what-went-right"></a>What went right

#### Sticking through to completion

...

#### Investing in developer productivity

(heavy focus on unit tests, TypeScript refactor halfway through, massive breaking changes in how cards were stored in the DB when we realized the old schema wasn't working for us anymore)

#### Soliciting feedback throughout

many of our biggest and most important features were player suggestions!

#### Me working throughout the whole stack, from the game client to the parser

(this is also slightly a con because it was a symptom of me not being able to split work / motivate others to work on wordbots, but a pro in the sense that as I lost steam on one part of the game I was able to shift gears to other parts)

#### The Wordbots concept itself

And finally, I should mention the general concept itself for Wordbots – after all, it was a strong-enough idea that the vision was able to push us through to the end despite all the challenges along the way!

## <a name="what-went-wrong"></a>What went wrong

#### Struggling with motivation

* Struggling with motivation, thinking of it as an obligation rather than a fun project half the time

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
