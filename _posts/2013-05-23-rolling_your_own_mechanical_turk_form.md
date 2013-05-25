---
layout: post
title: Rolling Your Own Mechanical Turk Form with ExternalQuestion and Rails
tags: [amazon, mechanical turk, ruby, rails]
date: 2013-05-23
---

### Motivation

For a research project that I'm working on, I made a survey that feeds data into a Rails application. I wanted to create Mechanical Turk HITs that direct users to the survey (on my site), and send the results directly to the server. I also wanted to be able to dynamically create the HITs from within the Rails application itself.

Fortunately, the Mechanical Turk API provides a means for doing this through the [ExternalQuestion structure](http://docs.aws.amazon.com/AWSMechTurk/latest/AWSMturkAPI/ApiReference_ExternalQuestionArticle.html). Here's how I accomplished this.

### Creating the HIT

To create the HIT from within my application, I used the [ruby-aws](https://rubygems.org/gems/ruby-aws) gem. Creating HITs with it is pretty simple:

{% highlight ruby %}
require 'ruby-aws'

# For production:
# mturk = Amazon::WebServices::MechanicalTurkRequester.new :Host => :Production

# For testing:
mturk = Amazon::WebServices::MechanicalTurkRequester.new :Host => :Sandbox

mturk.createHIT(
  :Title => TITLE,
  :Description => DESCRIPTION,
  :MaxAssignments => NUM_ASSIGNMENTS,
  :Reward => { :Amount => REWARD_AMOUNT, :CurrencyCode => 'USD' },
  :Question => File.read QUESTION_PATH,
  :Keywords => KEYWORDS
)
{% endhighlight %}

Most of these parameters should be fairly straightforward. `QUESTION_PATH` is the relative path to a question XML file (I keep mine under `/app/lib/mechanical_turk_questions/`). For ExternalQuestions, the format of the XML file is very simple (the latest schema URLs can be found [here](http://docs.aws.amazon.com/AWSMechTurk/latest/AWSMturkAPI/ApiReference_WsdlLocationArticle.html#the-data-structure-schema-locations) ):

{% highlight text %}
<?xml version="1.0" encoding="UTF-8"?>
<ExternalQuestion xmlns="[URL of schema]">
  <ExternalURL>[path to survey]</ExternalURL>
  <FrameHeight>[height of frame]</FrameHeight>
</ExternalQuestion>
{% endhighlight %}

Now, running the above code should create the desired number of HITs, pointing to the desired path. Of course, before we do that we should probably set up the form itself.

### Setting up the Form

In order to integrate with Mechanical Turk, the form needs to:

- submit results to `https://www.mturk.com/mturk/externalSubmit`
- pass on the `assignmentId` parameter  (I also pass on the `hitId` parameter, just in case)

{% highlight ruby %}
class SurveyController < ApplicationController
  def show
    @assignment_id = params['assignmentId']
    @hit_id = params['hitId']

    # whatever other setup is needed for the survey
  end
end
{% endhighlight %}

The template of the form should look like this:

{% highlight erb %}
<% form_tag("https://www.mturk.com/mturk/externalSubmit", :method => "post") do |form| %>
	<!-- the actual survey goes here -->
	<% hidden_field_tag 'assignmentId', @assignment_id %>
    <% hidden_field_tag 'hitId', @hit_id %>
    <% submit_tag "Submit", :disabled => true, :id => 'submitButton' %>
<% end %>
{% endhighlight %}

To ensure that the survey is fully completed, I made the Submit button be disabed at first, and only enabled it via JavaScript once every field was filled out. This is of course strictly optional.

### Submitting the Result

When a Turker hits the Submit button in the survey, I want two things to happen:

- The results should be passed on to the server
- Amazon should be notified that the Turker completed the survey

On the server side, things are pretty simple - I gave `SurveyController` a `submit` action that handles the incoming data:

{% highlight ruby %}
class SurveyController < ApplicationController
  def submit
    # process the survey result
  end
end
{% endhighlight %}

Now comes the tricky bit - how do we get the data to both the server and to Amazon?

At first, I tried submitting the survey to my server first, then processing the data and redirecting Turkers to the Amazon URL. However, this didn't work - the Turkers all ended up receiving a **"There was a problem submitting your results"** error:

<img class="figure" src="/blog/images/problem-submitting-results.jpg">

As it turns out, Amazon only seems to allow `externalSubmit` requests that originate from the client, not ones that originate on the server or are redirected.

So, the only way to do what we want to do is to submit the form _twice_ - once to the server and once to Amazon. This is possible with a bit of jQuery trickery:

{% highlight javascript %}
$("input:submit").click(function(e) {
    e.preventDefault();

    // submit to our server
    $.ajax({
        url: "/submit",
        type: 'post',
        data: $('form').serialize(),
        success: function(result) {
            // submit to mechanical turk
            $('form').submit();
        }
    });
});
{% endhighlight %}

Now, when the submit button is clicked, the contents of the form are first serialized and passed to `/submit`, and only after that request is successfully made does the form itself submit to the `externalSubmit` URL.

### In Conclusion

Putting these pieces together, we get a pretty nifty workflow:

1. HITs can be created from within the application.
2. HITs direct Turkers to the survey within the application.
3. Turkers fill out the survey.
4. The results are submitted to the application.
5. The results are then submitted to Mechanical Turk, to credit the Turkers for their work.

The one step that's still missing is that each Turker's submission needs to be manually approved or rejected. I'm currently working on figuring out how to automatically approve/reject work - perhaps I'll write about it in a later post.
