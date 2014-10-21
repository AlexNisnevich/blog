---
layout: post
title: JSON Requests with rust-http
tags: [json, requests, rust, http, library]
---

I've been playing around with [Rust]() a lot the past couple weeks. It's a neat little language with some cool ideas (...), but sadly the ecosystem is rather sparse at the moment, to say the least.

[...]

https://gist.github.com/AlexNisnevich/418be2ba34e130977f5c

[...]

{% highlight rust %}
struct Request {
  method: method::Method,
  path: String,
  headers: request::HeaderCollection,
  body: Json
}
{% endhighlight %}

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

{% highlight rust %}
fn main() {
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
}
{% endhighlight %}
