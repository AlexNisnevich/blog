---
layout: post
title: Dynamic Pluralization with PHP and jQuery
tags: [php, yii, javascript, jquery, grammar]
date: 2012-07-30
---

_(Note: I originally posted this on Facebook last summer, in my wild, PHP-loving days. While my toolbelt has changed since then, I still agree with the sentiment of the post, and so am reformatting it and reposting it here.)_

Here's a rather clean solution to dynamically pluralizing text that I've come up with. I wonder how other people deal with this.
 
### Background
 
Web sites incorrectly using the plural form of nouns for dynamic content (e.g. "1 comments") are a pet peeve of mine. Working on a site that displays lots of dynamic data that's refreshed via AJAX calls made me want to come up with a clean way to deal with pluralization. 
 
Of course, it's easy to write a PHP function like:

{% highlight php %}
<?php
public function pluralize($plural, $singular, $count) {
    return ($count = 1) ? $singular : $plural;
}
?>
{% endhighlight %}

and pass the current value of the data field in question. The necessity for client-side functions arises, however, when this data field dynamically changes (e.g. a user adds a comment and it's automatically added to the page through AJAX), and then "1 comment" becomes "2 comment". I couldn't find a solution online that avoids especially messy JavaScript, so I came up with a couple of my own. Both approaches have the same general idea: a PHP `pluralize()` function is called to do initial pluralization and to create the HTML structure that can then be used by a JavaScript `pluralize()` function to refresh the pluralization whenever dynamic content is changed.
 
### The Simpler Solution
 
This approach modifies the simple function above to create a pair of "singular" and "plural" spans and simply hide the one that's not used at the moment.
 
PHP code for method #1:

{% highlight php %}
<?php
public function pluralize($plural, $singular, $count, $id = "") {
    return ($count == 1) ?
        '<span class="singular'.$id.'">'.$singular.'</span>' . 
            '<span class="plural'.$id.' hidden">'.$plural.'</span>' :
        '<span class="singular'.$id.' hidden">'.$singular.'</span>' . 
            '<span class="plural'.$id.'">'.$plural.'</span>';
}
?>
{% endhighlight %}

JavaScript code for method #1:

{% highlight javascript %}
function pluralize (value, id)
{
    if (typeof id == 'undefined') {
        var id = '';
    }

    if (value == 1) {
        $(".singular"+id).show();
        $(".plural"+id).hide();
    } else {
        $(".plural"+id).show();
        $(".singular"+id).hide();
    }
}
{% endhighlight %}

CSS for methods #1 and #2:

{% highlight css %}
.hidden
{
    display: none;
}
{% endhighlight %}
 
To use this approach for a comment form like the one mentioned above, one would call `pluralize("comments", "comment", $numComments)` in the PHP, and then call `pluralize (value)` in JavaScript whenever the number of comments changes.
 
It's a little messier to use this on a page with multiple dynamic fields (e.g. a reddit-style threaded discussion where every post can have "1 point" or >1 "points"), but still possible. The `pluralize (value, id)` function allows you to only modify the pluralization of one element at a time, as long as you pass a unique ID to the `PHP pluralize()` function calls.
 
This works, but it's a little ugly to be left with a collection of spans with id's like "plural1", "plural2", "plural3", etc. For my second approach, I tried to get rid of this by structuring each "pluralization block" with a consistent hierarchy.
 
### The More Involved Solution
 
The idea here is that the PHP pluralize() function takes a single parameter $contents of the form:

{% highlight php %}
$contents = array(
    array('plain', 'There'),
    array('pluralize', 'are', 'is'),
    array('value', count($attendees)),
    array('pluralize', 'people', 'person'),
    array('plain', 'attending!')
);
{% endhighlight %}

and uses it to create an HTML hierarchy like this:

{% highlight html %}
<span class="pluralizer-container">
    There
    <span class="singular hidden">is<span>
    <span class="plural">are</span>
    <span class="value">42</span>
    <span class="singular hidden">person</span>
    <span class="plural">people</span>
    attending!
</span>
{% endhighlight %}

The code for this is pretty straightforward:

{% highlight php %}
<?php
public function pluralize ($contents) {
    $value = 0;
    $output = '<span class="pluralizer-container">';
    foreach ($contents as $element) {
        switch ($element[0]) {
            case "plain":
                $output .= $element[1] . ' ';
                break;
            case "pluralize":
                $output .= '<span class="singular">'.$element[2].'</span> ';
                $output .= '<span class="plural">'.$element[1].'</span> ';
                break;
            case "value":
                $value = $element[1];
                $output .= '<span class="value">'.$value.'</span> ';
                break;
        }
    }
    $output .= '</span>';

    if ($value == 1) {
        $output = str_replace('class="plural"', 'class="plural hidden"', $output);
    } else {
        $output = str_replace('class="singular"', 'class="singular hidden"', $output);
    }
    echo $output;
}
?>
{% endhighlight %}
 
The new JavaScript function takes advantage of this consistent layout to correctly pluralize all elements on the page at once without requiring any parameters:

{% highlight javascript %}
function pluralize() {
    $(".pluralizer-container").each( function() {
        var value = $(this).children(".value").text();
        if (value == 1) {
            $(this).children(".singular").show();
            $(this).children(".plural").hide();
        } else {
            $(this).children(".singular").hide();
            $(this).children(".plural").show();
        }
    });
}
{% endhighlight %}

As a result, the JavaScript side of things is much easier to use, at the expense of a more complicated PHP call. This approach seems more elegant to me, but it does have some drawbacks: it takes some work to create the array that describes each "pluralization block", and the JavaScript function acts on all pluralization blocks every time it's called, which is more inefficient, though I imagine the performance difference is negligible.
 
### To Wrap Up
 
Correctly pluralizing dynamic data is not especially difficult, and can be accomplished in some 40 lines of code. The two approaches I outlined both work fine and mainly differ in whether one wants to have slightly more complicated calls to the server function or the client function.
 
These approaches are easy to extend both to other languages (such as Russian, with its singular-dual-plural number system) and to other grammatical functions (such as present tense vs past tense for events). Another cool extension to this could be to integrate an automatic PHP pluralization function (I've seen a couple floating around online).
 
For those of you who use the Yii framework, I've encapsulated this functionality in a Yii widget for extra convenience. You can get it here:
[http://www.yiiframework.com/extension/pluralizer/](http://www.yiiframework.com/extension/pluralizer/)
