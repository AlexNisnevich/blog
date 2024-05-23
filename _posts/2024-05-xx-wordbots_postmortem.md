# A Belated Wordbots Dev Diary and Postmortem (~1 Year Post-Release)

About a year ago, I "released" [Wordbots](https://wordbots.io/), the tactical card game with user-created cards that I'd been working on since 2016.

_(I say "released" in quotes because this isn't really the sort of game that will ever be feature-complete, especially not as a side project. But on April 29, 2023, I declared it fully playable and ready to graduate from alpha into an eternal "beta" stage, in which I'm no longer actively developing new features but continue to fix bugs and make small improvements as time permits._)

Getting Wordbots from concept to fully-playable beta was a _journey_. It was one of the hardest things I've done in my life, and [... something about both highs and lows ...]. It was by far the largest project I've ever started, in all senses of the word – the biggest in scope, the most time-intensive, and the most emotionally draining to work on. Would I have started working on Wordbots if I'd known how long it would end up taking and what a torturous path I'd go on to "finish" it? I'm not sure. But in any case, I'm glad I did it, in the end.

[link to a "what is wordbots?" for those who don't know?]

## Table of Contents 
[TODO TOC ... this post is long enough to need it!]

## First, A Visualization!
Before I talk about my successes and challenges with Wordbots, it might be helpful to throw up a little graph I made illustrating the development process as the story of git commits and releases:
![enter image description here](https://github.com/AlexNisnevich/blog/blob/master/_notebooks/wordbots-graphs/wordbots-dev-history.png?raw=true)
I should mention that I was fortunate to have a lot of help ... blah blah blah Jacob ... blah blah blah see acknowledgements ... blah blah blah commit ... blah blah blah in the end about 95% of the commits were my own, so this chart shows both the development cycle/cadence of Wordbots as a whole as well as illustrating my own personal journey working on Wordbots.

And as you can see from the chart, working on Wordbots was not a totally smooth process ...

## A (semi-)brief history of Wordbots

### The beginning (summer 2016–fall 2017)
* original idea - came from Montague, itself an open-source version of what we were working on at Upshot (circa 2014, open sourced in early 2016). game as exercise for Montague
* threw together first pass at parser in the fall of 2016
* Jacob had some React+Redux experience already and threw together a quick game mockup in December 2016
* I started funemployment January 2017 and began working on Wordbots essentially full-time. By early April we had v0.1.0, a fully functional prototype with working card creation and multiplayer gameplay
* Progress came fast as I was on a roll and working on Wordbots nonstop: April brought spectator support, activated abilities, card import/export, turn timer, and a huge amount of new card mechanics. May brought user accounts, auto-generated documentation, SFX, and more card mechanics.  June brought tutorial mode and the "Did You Mean" feature in the creator. July: practice mode, in-game animations, UX redesign.

### Slow but steady improvement (fall 2017–summer 2019)
* In fall of 2017, I started a new job and also went on some big international trips in short succession, breaking my cycle of nonstop Wordbots work.
* The next few months didn't bring a lot of major new gameplay features, mostly tweaking the UX, fixing bugs, adding new things to the parser, trying to make things more user-friendly
* April 2018: first big playtest round, mixed results (most people just didn't play and gave no feedback)
* aftermath of playtest caused us to start thinking seriously about game formats for the first time. Ended up introducing the Shared-Deck format (May 2018) and Sets and the Set format (April 2019)
	* (later: Set Draft format (July 2021), Everything Draft format (April 2023)
* fall 2018: assembling a larger team, starting regular standups. Unfortunately, it ended up proving hard to actually divide the work, and Jacob and I still ended up doing the bulk of it. The standups helped maintain developer interest, at least among ourselves
* April 2019: v0.12.0 and the addition of Sets was what I saw as the last major "concept" of Wordbots and I began to think about what it would take to "release" the game
* summer 2018 -- Dec 2020: TypeScript refactor, not sure how much to write about this
* August 2019: revitalized after a backpacking trip, I wrote a doc called "Wordbots: The Final Stretch", spelling out the remaining work to get Wordbots "finished" (i.e. ready to be played by people who aren't our friends), in the four categories of User-Friendliness, Robustness, Community, and Accessibility. Of course, "final stretch" turned out to be optimistic.

### Distractions and demoralization (summer 2019–summer 2022)
By the summer of 2019, the amount of free time I had to spend on Wordbots began to plummet as I began to spend every available weekend going to open houses, as part of our quest to buy a fourplex with our friends to live in – another massive "side project" with huge emotional highs and lows, that perhaps I'll write about at a later point. In December 2019, we finally closed on a fourplex that ticked off all our boxes but required renovation on a massive scale. And of course, we know what happened at the start of 2020. We were very fortunate to have the built-in community of our fourplex housemates to weather the lockdown period with, but it was still an emotionally draining period. I had the mental bandwidth for exactly one project in 2020, and that ended up being the renovation work, which took the better part of the year and was all-consuming while it was happening.

When I did circle my thoughts back to Wordbots in this period, I could no longer picture the end goal, just a mountain of work that looked more and more daunting as I spent more time away from it. I began to dread the thought of working on Wordbots, but at the same time felt guilty for not working on it. There were times when I couldn't sleep because I was so angry with myself at "wasting my time" and not [...]

Throughout it all, I did manage to have intermittent bursts of motivation to work on Wordbots. I was able to finally finish the massive TypeScript refactor (that I'd started back in summer of 2018) by the end of 2020 – it was a good thing to work on while my motivation was limited, because I could think of it almost as a puzzle, in getting all the types to line up and everything to compile, and watching our TypeScript LOC count go up as the Javascript LOC count went down provided a nice visual progress indicator. Also at the end of 2020, I finished a large refactor of how cards are stored, developing a much more robust system of metadata tracking for cards that fixed a number of bugs and enabled a lot of quality-of-life features down the line.

During a weeklong "Wordbots retreat" in the Lost Coast (a location strategically chosen for poor network connectivity and few distractions) in summer of 2021, I powered through the work of creating the Set Draft format, a feature that we'd been discussing as a team for a while, and that quickly became my favorite way to play Wordbots. Drafting provided an elegant solution to both the "fairness" issue (since either player was equally likely to draft a given card), while also removing the friction of players having to create a deck prior to playing. With the Set Draft format implemented in v0.16.0, I could finally begin to see the path forward that had eluded me for the past couple of years.

Other than that, the major gameplay improvements during this time were all aimed at providing a better UX for players, especially new players: a massive interface redesign that included art by Chris Wooten (TODO link), Help and Community pages, a "New Here?" feature, more flavor throughout the game (as well flavor text support for cards), etc.

### The final push (fall 2022–spring 2023)

I was finally able to get out of my slump and really mount a concerted effort to finish Wordbots in fall of 2022. I'd planned a two-month sabbatical from work to work on another project that fell through at the last minute, so I unexpectedly had a whole bunch of free time, so much free time that after a while I was finally able to push through my mental block and start working on Wordbots in earnest.

In October 2022, I added one final major parser feature, and one that I could only have implemented while on sabbatical because of its huge complexity: **card rewrite effects**. Finally, Wordbots had an actual gameplay mechanic that no other card game could really match - cards could rewrite the very text of other cards. It's certainly a silly addition to Wordbots, and perhaps not necessarily worth the ROI on the effort that was spent to make it possible. But it makes me smile, and so into the game it went.

Other than that, I began to finally work in earnest on checking off boxes on that old "Wordbots: The Final Stretch" doc I'd written way back in 2019. Much had happened since then, but the overall roadmap was still solid, and I was able to pick up where I left off. Jacob and I started a mostly-weekly tradition of Wordbots playtests with each other, and over the next few months, we found and fixed literally dozens of issues with our multiplayer implementation. Other playtests helped us identify other bugs within the game as well as missing quality-of-life features that we proceeded to add, like support for draws, more robust game disconnection handling, support for card rarities in sets, etc. By April 2023, we felt like Wordbots had finally reached the point at which it could handle an influx of new players - it could survive in the wild. In other words, it was ready for beta release.

### An aside: Wordbots as a symbolic AI island in a sea of LLMs

But I should back up a little. As these final six months of Wordbots polishing were happening, there was of course a much bigger development in the NLP world - the November 2022 release of ChatGPT, which changed the public conversation about NLP seemingly overnight. As I starting grappling with all my feelings about this brave new world we were entering, one thing I struggled to figure out was _what was the place of Wordbots in the new NLP world?_ After all, as cool as the Wordbots concept seemed to me, it was built on old – let's say _ancient_ tech – after all, the whole parsing subsystem was really just a CKY parser with bells and whistles – 1960s-era technology. 

What I ultimately settled on was the idea of Wordbots as a demonstration of the continued relevance of older NLP approaches, and the idea that, as powerful as statistical NLP is today, there is still value in symbolic methods. 

Could an LLM be used to produce code from card text the way Wordbots does? I'm sure such a thing could be implemented. But Wordbots's symbolic-NLP underpinnings offer some advantages that are really useful: consistency and interpretability [TODO more about this]

This new way of thinking about the purpose of Wordbots helped inspire me over the course of the final push towards beta release, and also led me to write the slightly cheeky _"No LLMs were used in the making of Wordbots"_ disclaimer on the [About page](https://wordbots.io/about).

### Wordbots today (/post-release thoughts)

### And finally, the release! (May 2023)

[don't forget to mention Hacker News release and how stressful that was]

## What went right

* Sticking through to completion
* Not being afraid to invest in dev productivity (heavy focus on unit tests, TypeScript refactor halfway through, massive breaking changes in how cards were stored in the DB when we realized the old schema wasn't working for us anymore)
* soliciting feedback / playtests throughout - many of our biggest and most important features were player suggestions!
* ...

## What went wrong

* Struggling with motivation, thinking of it as an obligation rather than a fun project half the time
* Sticking to tools we knew rather than doing more initial research (React? MaterialUI? ancient version of Scala used by Montague)
* Never really figuring out how to make use of the many people I had / not doing a good job of splitting up work
* Not thinking about onboarding / new-player experience until waaay too late in the game (essentially wasting our biggest playtest as a result)
* ...

## Final Thoughts / Conclusions

## Acknowledgements

