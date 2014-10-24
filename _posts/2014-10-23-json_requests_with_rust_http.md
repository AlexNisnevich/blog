---
layout: post
title: JSON Requests with rust-http
tags: [json, requests, rust, http, library]
---

I've been playing around with [Rust](http://www.rust-lang.org/) a lot the past couple weeks. It's a neat little language with some cool ideas (I particularly like its memory-safety features, though they take some getting used to), but sadly the ecosystem has some catching up to do.

In particular, making HTTP requests in Rust is a bit of a mess right now. The closest Rust has to a working requests library at the moment is [rust-http](https://github.com/chris-morgan/rust-http), which is not being maintained while its creator works on its forthcoming replacement, [Teepee](https://github.com/teepee/teepee). Unfortunately, rust-http's API is not the clearest to use and [its documentation](http://www.rust-ci.org/chris-morgan/rust-http/doc/http/) is rather sparse. 

The fun part, though, is that this means I've had to figure out a lot of its quirks myself.

I've been working on writing a client for a JSON API and I needed to use rust-http to make lots of JSON requests and then parse their responses as JSON, with as convenient an interface as possible. Here's what I came up with.

_(Disclaimer: I have no idea whether what follows is idiomatic Rust -- I've been using Rust for less than a month -- but it works for me.)_

Individual requests are encapsulated in a `Request` struct (`method` is a [Method](http://www.rust-ci.org/chris-morgan/rust-http/doc/http/method/enum.Method.html) and `headers` is an instance of [HeaderCollection](http://www.rust-ci.org/chris-morgan/rust-http/doc/http/headers/request/struct.HeaderCollection.html)):

{% highlight rust %}
struct Request {
  method: method::Method,
  path: String,
  headers: request::HeaderCollection,
  body: Json
}
{% endhighlight %}

The `json_request` method takes a `Request` struct and tries to make a JSON request with it, returning `Ok(Some(response: Json))` if the response is valid JSON, `Ok(None)` if the response is not valid JSON, or `Err(error)` if the request failed in some way or did not receive a 200 OK response:

{% highlight rust %}
// Makes a JSON request with headers and body and expects a JSON response
// Returns one of:
//    Ok(Some(response)) : successfully received JSON response
//    Ok(None)           : response is not valid JSON
//    Err(error)         : did not receive a 200 OK response
fn json_request(request_params: Request) -> Result<Option<Json>, String> {
  let application_json = MediaType::new("application".to_string(), "json".to_string(), vec![]);

  let url = Url::parse(request_params.path.as_slice()).ok().expect("path is not a valid URL");

  let body_str = request_params.body.to_string();
  let data: &[u8] = body_str.as_bytes();

  let mut request: RequestWriter = RequestWriter::new(request_params.method, url).unwrap();
  request.headers.content_length = Some(data.len());
  request.headers.content_type = Some(application_json);
  request.headers.accept = Some("*/*".to_string());
  request.headers.user_agent = Some("Rust".to_string()); // (some APIs require a User-Agent)
  for header in request_params.headers.iter() {
    request.headers.insert(header);
  }
  request.write(data);

  let mut response = request.read_response().ok().expect("Failed to send request");
  let response_text: String = response.read_to_string().ok().expect("Failed to read response");
  // println!("{}: {}", response.status, response_text);

  match response.status {
    status::Ok => Ok(json::from_str(response_text.as_slice()).ok()),
    _          => Err(response_text)
  }
}
{% endhighlight %}

Here's an example of how this method can be used:

{% highlight rust %}
// see http://doc.rust-lang.org/serialize/json/ to learn how to serialize datatypes into Json
// or pass your body as a raw Json string this way:
let empty_body = from_str::<Json>("{}").unwrap();

// to learn how to add custom headers to a HeaderCollection, see:
// http://www.rust-ci.org/chris-morgan/rust-http/doc/http/headers/request/struct.HeaderCollection.html
let empty_headers = request::HeaderCollection::new();

// available methods: http://www.rust-ci.org/chris-morgan/rust-http/doc/http/method/enum.Method.html
let get = method::Get;

let request = Request {
  method: get,
  path: "https://api.github.com/users/AlexNisnevich".to_string(),
  headers: empty_headers,
  body: empty_body
};

match json_request(request) {
  Ok(Some(response)) => println!("{}", response.to_pretty_str()),
  Ok(None)           => println!("JSON parsing error"),
  Err(error)         => println!("Request failed: {}", error)
}
{% endhighlight %}

And yeah, that's about it. It's still nowhere near as nice as, say, Python's [requests](http://docs.python-requests.org/en/latest/) library, but it certainly beats working directly with rust-http's low-level interface.

The [whole thing is on GitHub](https://gist.github.com/AlexNisnevich/418be2ba34e130977f5c) for your perusal.
