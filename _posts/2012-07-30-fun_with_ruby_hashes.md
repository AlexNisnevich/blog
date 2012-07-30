---
layout: post
title: Playing Around with Ruby Hashes
tags: [ruby, data structures, recursion]
---

As a relative Ruby newbie, one of the things I love about it is how easy and elegant it is to modify existing classes.

In this post I'd like to mention some of the cool things that I've discovered you can do with hashes.

### Arbitrarily deep assignment

Suppose I'm using a hash to store data that has a complicated structure. I want to be able to do something like

{% highlight ruby %}
hash[player][:stats][category][statistic] = value
{% endhighlight %}

without littering my code with a bunch of lines like

{% highlight ruby %}
hash[player] ||= {:stats => {}}
hash[player][:stats][category] ||= {}
{% endhighlight %}

In other words, I want to be able to perform abitrarily deep assignment: for a hash `h`, `h[:a][:b][:c] = 5` should be just as valid as `h[:a] = 5`, even if `h` does not yet have the key `:a`.

This is simple to implement by subclassing `Hash` and overriding the `[]` operator:

{% highlight ruby %}
class FreeformHash < Hash
  def [](key)
    unless has_key?(key)
      self[key] = FreeformHash.new
    end
    super
  end
end
{% endhighlight %}

Let's see it in action!

{% highlight bash %}
irb(main):009:0> h = FreeformHash.new
=> {}
irb(main):010:0> h[:a][:b][:c] = 5
=> 5
irb(main):011:0> h
=> {:a=>{:b=>{:c=>5}}}
{% endhighlight %}

One downside is that `[]` is now destructive, so `h[key]` will always create elements if they don't already exist. `Hash#has_key?` should always be used where appropriate to avoid unwanted keys being created.

### Default values

You might already know that `Hash.new(X)` will create a hash that returns `X` as a default value on a lookup for a nonexistent key:

{% highlight bash %}
irb(main):001:0> polite_hash = Hash.new("I'm so sorry")
=> {}
irb(main):002:0> five_hash['not a key']
=> "I'm so sorry"
{% endhighlight %}

This is all well and good, but what if I want a default value that I can modify for each key? For instance, let's say that I'm keeping track of some player statistics in a hash, and I want to be able to easily modify them without having to manually instantiate a hash for each player. My first thought is to specify a hash as a default value, as so:

{% highlight bash %}
irb(main):003:0> bad_hash = Hash.new({:wins=>0, :ties=>0, :losses=>0})
=> {}
irb(main):004:0> bad_hash[:player1]
=> {:count=>0}
irb(main):005:0> bad_hash[:player1][:wins] += 1
=> 1
irb(main):006:0> bad_hash[:player2]
=> {:wins=>1, :ties=>0, :losses=>0}
{% endhighlight %}

Uh oh, what happened here? It turns out that the default value of a hash is a single object that is used for all default values, so changing it once will change it for all default values, with nothing being stored in the hash itself: 

{% highlight bash %}
irb(main):007:0> bad_hash.default
=> {:wins=>1, :ties=>0, :losses=>0}
irb(main):008:0> bad_hash
=> {}
{% endhighlight %}

Clearly this is not the way to go.

Fortunately, Ruby provides an alternative approach to default values: you can specify a block like `{|hash, key| do_stuff}` as an argument instead, and that block will execute every time a lookup fails. While no element is added to the hash by default in this case, you can use a block of the form `{|hash, key| hash[key] = object}` to insert `key => object` into the hash on every failed lookup.

A quick example:

{% highlight bash %}
irb(main):009:0> players = Hash.new{|h, k| h[k] = {wins: 0, ties: 0, losses: 0}}
=> {}
irb(main):010:0> players[:alex][:wins] += 1
=> 1
irb(main):011:0> players[:other_player][:losses] += 1
=> 1
irb(main):012:0> players
=> {:alex=>{:wins=>1, :ties=>0, :losses=>0}, :other_player=>{:wins=>0, :ties=>0, :losses=>1}}}
{% endhighlight %}

### Deep sort

As of Ruby 1.9, hashes preserve their order of keys, but there are no methods for reordering keys. What do we do if we want to sort the elements in a hash by key?

Fortunately hashes include the [Enumerable](http://www.ruby-doc.org/core-1.9.3/Enumerable.html) module, and thus have a [sort](http://www.ruby-doc.org/core-1.9.3/Enumerable.html#method-i-sort) method, but that returns an array of pairs, not a hash. To sort a hash by key and return a hash, we need to do:

{% highlight ruby %}
Hash[h.sort]
{% endhighlight %}

where [Hash[]](http://www.ruby-doc.org/core-1.9.3/Hash.html#method-c-5B-5D) constructs a hash with given input, such as from an array.

So far so good. Now, what if we have a hash like `{y: {b: 2, a: 3}, x: {d: 4, e: 5, c: 6}}` and we want to sort at each level, getting `{x: {c: 6, d: 4, e: 5}, y: {a: 3, b: 2}}` as a result?

This can be done in one line with a recursive function:

{% highlight ruby %}
class Hash
  def deep_sort
    Hash[sort.map {|k, v| [k, v.is_a?(Hash) ? v.deep_sort : v]}]
  end
end
{% endhighlight %}

`deep_sort` works by first sorting the hash, then mapping over the elements of the hash, deep-sorting their values if possible, and finally converting the results back to a hash (because the mapping produces an array of pairs).

Now let's see it in action:

{% highlight bash %}
irb(main):006:0> unsorted_monstrosity = {y: {b: 2, a: 3}, x: {d: 4, e: 5, c: 6}}
=> {:y=>{:b=>2, :a=>3}, :x=>{:d=>4, :e=>5, :c=>6}}
irb(main):007:0> unsorted_monstrosity.deep_sort
=> {:x=>{:c=>6, :d=>4, :e=>5}, :y=>{:a=>3, :b=>2}}
{% endhighlight %}

And there we have it: three simple tricks that serve as useful examples of just how elegantly powerful Ruby can be.
