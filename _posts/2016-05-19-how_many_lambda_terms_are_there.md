---
layout: post
title: How many closed lambda-calculus terms are there of a given length?
tags: [math, theory, lambda calculus, ruby, integers]
---

_**Update (6/2/16):** Reddit user [u/julesjacobs](https://www.reddit.com/u/julesjacobs) has managed to find [an elegant recurrence relation for this problem](https://www.reddit.com/r/math/comments/4kftx8/how_many_closed_lambdacalculus_terms_are_there_of/d3f4b52)! As it turns out, my approach slightly undercounted the number of terms (for length 10, I calculated 893 terms, while the true answer is 893), but was correct for N<10. Fun fact: there are 147677899847908815123862539373715632995852464035157843195311323850864810096812226643364709183774473672545 terms of length 100._

I thought of this question a few months ago, and, as far as I can tell, nobody has really done any work on it before. And I'm not surprised – it doesn't seem to really be a question of any practical significance, just an idle curiosity.

But hey, let's think it though. How would we go about calculating the number of distinct [closed lambda terms](https://en.wikipedia.org/wiki/Lambda_calculus#Free_and_bound_variables) of length N?

### Defining the problem

To start, let's lay down some ground rules for what we mean by "distinct terms". First off, `λx.x` and `λy.y` are clearly equivalent for our purposes – no question about that. So terms that are alpha-equivalent (in other words, equivalent to each other if bound variables are changed) should not be treated as distinct.

Also, it's clear that we must follow some kind of conventions, or else we'd get some silly "distinct" terms: for example, we really shouldn't treat `(MN)P` and `(MNP)` as different terms! Somewhat arbitrarily, I chose to follow the [notation rules listed on Wikipedia](https://en.wikipedia.org/wiki/Lambda_calculus#Notation):

1. Outer parentheses are always dropped: `(MN)` -> `MN`
2. Applications are assumed to be left associative: `((MN)P)` -> `MNP`
3. The body of an abstraction extends as far right as possible: `λx.(MN)` -> `λx.MN`
4. A sequence of abstractions is contracted: `λx.λy.λz.N` -> `λxyz.N`

Finally, as far as counting length goes, `λ`, `.`, `(`, `)`, and variables count as a single character each, and we will ignore any whitespace.

### Time for some counting!

So, now that we've fully stated what it is we're counting, let's give it a shot.

The shortest possible closed lambda term is `λa.a`, so there are none of length 3 or less, and only one distinct term of length 4.

How about length 5? We only have space for a single λ, and we can either take one or two variables. In the former case, we have `λa.aa`, and in the latter case, we have `λab.a` and `λab.b`. So, there are 3 terms of length 5.

How about length 6? It's starting to get harder to count them all, but some work gives us 8 in total:

{% highlight text %}
λa.aaa,
λab.aa,
λab.ab,
λab.ba,
λab.bb,
λabc.a,
λabc.b,
λabc.c
{% endhighlight %}

And so on. As long as we stick to terms with a single λ and no parentheses, it doesn't actually seem too hard to quantify the number of distinct terms (for example, for length 6 there are `1^3 + 2^2 + 3^1 = 8` and for length 7 there are `1^4 + 2^3 + 3^2 + 4^1 = 22` such terms).

But things get tricky once we get to length 8, because suddenly we're faced with terms that look like `λa.a(aa)` and `λa.aλb.a`. Eep, accounting for these definitely makes our task a lot trickier.

Eventually I gave up on trying to find a closed form that accounts for all of these cases, and decided to take the computational approach.

### The computational approach

First I wrote a `find_patterns` function that finds all possible "λ patterns" up to a given length (where a "λ pattern" is a λ term with all variable slots instead occupied by the symbol `X`.

It works by alternating _Search_ and _Simplify_ steps until the results stabilize. In the _Search_ step, patterns of length N are created through _abstraction_ (creating `λX.[term]` for every term of length N-3) or through _application_ (combining terms `M` and `N` into `(MN)` and `(NM)`).

In the _Simplify_ step, the [notation rules listed above](https://en.wikipedia.org/wiki/Lambda_calculus#Notation) are applied to all candidate patterns, potentially reducing their lengths.

Here's what the function looks like in Ruby:

{% highlight ruby %}
def find_patterns(max_n)
  patterns = Hash.new { |h, k| h[k] = [] }
  patterns[1] = ["X"] # in "patterns", X is a placeholder for variables

  # Alternate between search and simplify steps many times 
  # to build up the set of candidate patterns
  (max_n / 2 + 1).times do
    # Search
    (2..(max_n + 2)).each do |n|  # we need to go up to max_n + 2 
                                  # to get accurate patterns up to max_n
      if n > 3
        # Building up new terms through abstraction
        patterns[n] += patterns[n-3].map {|p| "λX.#{p}"}

        # Building up new terms through application
        (1...(n-2)).each {|j|
          k = n - j - 2
          patterns[j].each {|p1|
            patterns[k].each {|p2|
              patterns[n] << "(#{p1}#{p2})"
              patterns[n] << "(#{p2}#{p1})"
            }
          }
        }
      end

      patterns[n].uniq!
    end

    # Simplify (https://en.wikipedia.org/wiki/Lambda_calculus#Notation)
    # Note: the (M N) P => M N P rule is harder to encode, 
    #       but fortunately doesn't come up in N<=10 at all!
    simplified_patterns = patterns.values.reduce(&:+)
    5.times do
      simplified_patterns.map! {|p|
        p.gsub!(/λ(X+)\.λ(X+)\./, 'λ\1\2.')
        p.gsub!(/^\((.*)\)$/, '\1') if p.gsub(/^\((.*)\)$/, '\1').balanced_parentheses?
        p.gsub!(/\.\((.*)\)/, '.\1') if p.gsub(/\.\((.*)\)/, '.\1').balanced_parentheses?
        p
      }.uniq!
    end

    # Reassign to buckets by length
    patterns = Hash.new { |h, k| h[k] = [] }
    simplified_patterns.each {|p|
      patterns[p.size] << p
    }
  end

  patterns.keep_if {|k, v| k <= max_n }

  # Filter out patterns that cannot be combinators (don't start with λ)
  patterns = Hash[patterns.map {|k, v| [k, v.keep_if {|p| p.start_with? "λ"}]}]
end
{% endhighlight %}

After `find_patterns` runs, it returns a dictionary mapping each length to a list of candidate patterns. For example, the patterns for length 8 are `["λX.X(XX)", "λX.XXXXX", "λX.XλX.X", "λXX.XXXX", "λXXX.XXX", "λXXXX.XX", "λXXXXX.X"]`.

Each pattern is then passed into a `combinators_by_pattern` method that finds all possible closed terms that follow that pattern, by first filling in the variable bounds and then filling in the remaining slots in every possible way:

{% highlight ruby %}
def combinators_by_pattern(pattern)
  # First fill in variable bounds
  bound_variables = []
  next_bound_variable = "`"  # a - 1

  5.times do
    pattern.match(/λ(X+)\./) {|m| 
      vars = ""
      m[1].chars.each {|c| vars << next_bound_variable.next! }
      bound_variables += vars.chars

      pattern.sub!(/λ(X+)\./, "λ#{vars}.")
    }
  end

  # Then fill in the slots
  # NOTE: λ expressions inside parentheses pose a challenge for this naive
  #       implementation of "bounded variables". But fortunately it's not an issue in N<=10!
  combinators = [pattern]
  10.times do
    combinators.each do |c|
      if c.include? "X"
        idx = c.index("X")
        combinators.delete(c)
        combinators += bound_variables.select {|v| c.slice(0, idx).include? v} # has this variable appeared yet?
                                      .map {|v| c.sub("X", v)}
      end
    end
  end
  combinators
end
{% endhighlight %}

This little program is definitely not 100% correct – it (1) doesn't properly handle λ expressions inside parentheses, and (2) doesn't follow the `(MN)P` -> `MNP` simplification rule – but neither of those cases come up in the `N<=10` case, so I'm reasonably confident in the results I've gotten up to that point.

Also, the runtime complexity is exponential, so it can't really run for much higher `N` anyway!

Regardless of these flaws, I've put the code, along with some results, [up on GitHub](https://github.com/AlexNisnevich/lambda-terms), for anyone who wants to play with it.

### A260661

The folks at the Online Encyclopedia of Integer Sequences have been kind enough to accept my humble sequence of values for `1 <= N <= 10` as Sequence [A260661](https://oeis.org/A260661)!

Though the entry doesn't have as many terms as I would have liked to calculate, I'm pretty excited about my first OEIS entry. I feel like I've finally "made it" in some sense as a hobbyist mathematician.

### Exercises for the reader

I've reached the limit of what I can do with this problem, but there are still things that I'm curious about!

First and foremost, finding any accurate results at all for `N > 10` would be interesting. I have some preliminary results from my script (`11: 3678, 12: 16299, 13: 77108`), but I'm hesitant to trust them due to the issues mentioned above.

A real breakthrough would come if anyone can find a way to accurately compute results in faster-than-exponential time. In particular, I'm not ruling out a possible closed-form solution, although it would have to be pretty complex to encompass all of the notational rules.

Happy hunting!