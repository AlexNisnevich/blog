---
layout: post
title: "Secrets of natural language UIs: Translating English into computer actions"
tags: [talks, language, joseph, nlp, strata, upshot, ux, translation, english, sql, scala, lambda calculus]
---
[Joseph Turian](https://github.com/turian) and I gave a talk at [Strata 2016](http://conferences.oreilly.com/strata/hadoop-big-data-ca) entitled ["Secrets of natural language UIs: Translating English into computer actions"](http://conferences.oreilly.com/strata/hadoop-big-data-ca/public/schedule/detail/47360).

Here's a video:

<iframe width="560" height="315" src="https://www.youtube.com/embed/lnV2JnNBM1I" frameborder="0" allowfullscreen></iframe>

In the talk, we argue that natural-language UIs can enable users to interact with complicated data in a way that traditional UIs cannot. As an example, we discuss the implementation of [UPSHOT](http://venturebeat.com/2014/01/24/salesforce-prize-winner-upshot-teases-investors-with-voice-triggered-analytics/)'s English-to-SQL interface. 

Getting a little more hands-on, I give a quick tutorial _(starting around 7:20)_ on [CCG (combinatory categorial grammar)](https://en.wikipedia.org/wiki/Combinatory_categorial_grammar) and basic [lambda calculus](https://en.wikipedia.org/wiki/Lambda_calculus), finally culminating into a complete semantic parse of the example phrase _"top 5 opportunities in California by amount"_:

<img class="figure" src="/images/strata-2016-parse.jpg" alt="Semantic CCG parse of &quot;top 5 opportunities in California by amount&quot;" style="width: 560px;">

Leading up to the talk, we released **[montague](https://github.com/Workday/upshot-montague)**, a little CCG semantic parsing library for Scala that emphasizes simplicity and expressibility. **montague** is an open-source version of the CCG parser that [powered UPSHOT's English-to-SQL translation functionality](https://github.com/Workday/upshot-montague#background).

If you've ever wanted to try building a natural-language interface of your own but have been intimidated by the current NLP ecosystem, I think that **montague** could be a great place to start. Check out the [<tt>examples</tt> package](https://github.com/Workday/upshot-montague/tree/master/src/main/scala/com/workday/montague/example) (and [its documentation](https://github.com/Workday/upshot-montague#getting-started)) to see what programs written with **montague** look like.
