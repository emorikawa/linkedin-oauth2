# LinkedIn OAuth 2.0
[![Gem Version](https://badge.fury.io/rb/linkedin-oauth2.svg)](http://badge.fury.io/rb/linkedin-oauth2)
[![Build Status](https://travis-ci.org/emorikawa/linkedin-oauth2.svg?branch=master)](https://travis-ci.org/emorikawa/linkedin-oauth2)
[![Coverage Status](https://coveralls.io/repos/emorikawa/linkedin-oauth2/badge.png)](https://coveralls.io/r/emorikawa/linkedin-oauth2)
[![Code Climate](https://codeclimate.com/github/emorikawa/linkedin-oauth2/badges/gpa.svg)](https://codeclimate.com/github/emorikawa/linkedin-oauth2)
[![Dependency Status](https://gemnasium.com/emorikawa/linkedin-oauth2.svg)](https://gemnasium.com/emorikawa/linkedin-oauth2)

OAuth 2.0 Ruby wrapper for the [LinkedIn API](http://developer.linkedin.com).

If you are using OAuth 1.0, see the [hexgnu/linkedin](https://github.com/hexgnu/linkedin)

If you are upgrading from the oauth2-v0.1.0 version of this gem, see the
[upgrade notes](#upgrading) below.

# Installation

In Bundler:

```ruby
gem "linkedin-oauth2", "~> 1.0"
```

Otherwise:

    [sudo|rvm] gem install linkedin-oauth2

# Usage

**[Step 1:](#step-1-register-your-application)** [Register](https://www.linkedin.com/secure/developer) your
application with LinkedIn. They will give you a **Client ID** (aka API
Key) and a **Client Secret** (aka Secret Key)

**[Step 2:](#step-2-getting-an-access-token)** Use your **Client ID** and **Client Secret** to obtain an **Access Token** from some user.

**[Step 3:](#step-3-using-linkedins-api)** Use an **Access Token** to query the API.

```ruby
api = LinkedIn::API.new(access_token)
me = api.profile
```

## Step 1: Register your Application

You first need to create and register an application with LinkedIn
[here](https://www.linkedin.com/secure/developer).

You will not be able to use any part of the API without registering first.

Once you have registered you will need to take note of a few key items on
your Application Details page.

1. **API Key** - We refer to this as your client id or `client_id`
1. **Secret Key** - We refer to this as your client secret or
   `client_secret`
1. **Default Scope** - This is the set of permissions you request from
   users when they connect to your app. If you want to set this on a
   request-by-request basis, you can use the `scope` option with the
   `auth_code_url` method.
1. **OAuth 2.0 Redirect URLs** - For security reasons, the url you enter
   in this box must exactly match the `redirect_uri` you use in this gem.

You do NOT need **OAuth User Token** nor **OAuth User Secret**. That is
for OAuth 1.0. This gem is for OAuth 2.0.

## Step 2: Getting An Access Token

All LinkedIn API requests must be made in the context of an access token.
The access token encodes what LinkedIn information your AwesomeApp® can
gather on behalf of "John Doe".

There are a few different ways to get an access token from a user.

1. You can use [LinkedIn's Javascript API](https://developer.linkedin.com/documents/javascript-api-reference-0) to authenticate on the front-end and then pass the access token to the backend via [this procedure](https://developer.linkedin.com/documents/exchange-jsapi-tokens-rest-api-oauth-tokens).

1. If you use OmniAuth, I would recommend looking at [decioferreira/omniauth-linkedin-oauth2](https://github.com/decioferreira/omniauth-linkedin-oauth2) to help automate authentication.

1. You can do it manually using this linkedin-oauth2 gem and the steps
   below.

Here is how to get an access token using this linkedin-oauth2 gem:

### Step 2A: Configuration

You will need to configure the following items:

1. Your **client id** (aka API Key)
1. Your **client secret** (aka Secret Key)
1. Your **redirect uri**. On LinkedIn's website you must input a list of
   valid redirect URIs. If you use the same one each time, you can set it
   in the `LinkedIn.configure` block. If your redirect uris change
   depending on business logic, you can pass it into the `auth_code_url`
   method.

```ruby
# It's best practice to keep secret credentials out of source code.
# You can, of course, hardcode dev keys or directly pass them in as the
# first two arguments of LinkedIn::OAuth2.new
LinkedIn.configure do |config|
  config.client_id     = ENV["LINKEDIN_CLIENT_ID"]
  config.client_secret = ENV["LINKEDIN_CLIENT_SECRET"]

  # This must exactly match the redirect URI you set on your application's
  # settings page. If your redirect_uri is dynamic, pass it into
  # `auth_code_url` instead.
  config.redirect_uri  = "https://getawesomeapp.io/linkedin/oauth2"
end
```

### Step 2B: Get Auth Code URL

```ruby
oauth = LinkedIn::OAuth2.new

url = oauth.auth_code_url
```

### Step 2C: User Sign In

You must now load url from Step 2B in a browser. It will pull up the
LinkedIn sign in box. Once LinkedIn user credentials are entered, the box
will close and redirect to your redirect url, passing along with it the
**OAuth code** as the `code` GET param.

Be sure to read the extended documentation around the LinkedIn::OAuth2
module for more options you can set.

**Note:** The **OAuth code** only lasts for ~20 seconds!

### Step 2D: Get Access Token

```ruby
code = "THE_OAUTH_CODE_LINKEDIN_GAVE_ME"

access_token = oauth.get_access_token(code)
```

Now that you have an access token, you can use it to query the API.

The `LinkedIn::OAuth2` inherits from [intreda/oauth2](https://github.com/intridea/oauth2)'s `OAuth2::Client` class. See that gem's [documentation](https://github.com/intridea/oauth2/blob/master/lib/oauth2/client.rb) for more usage examples.

## Step 3: Using LinkedIn's API

Once you have an access token, you can query LinkedIn's API.

Your access token encodes the permissions you're allowed to have. See Step
2 and [this LinkedIn document](https://developer.linkedin.com/documents/authentication#granting) for how to change the permissions. See each section's documentation on LinkedIn for more information on what permissions get you access to.

### People

See the Profiles of yourself and other users. See the connections of
yourslef and other users.

See https://developer.linkedin.com/documents/people

```ruby
api = LinkedIn::API.new(access_token)
```

#### Yourself

```ruby
me = api.profile
```

#### Others

```ruby
evan_morikawa = api.profile("SDmkCxL2ya")
evan_morikawa = api.profile(id: "SDmkCxL2ya")
evan_morikawa = api.profile(url: "http://www.linkedin.com/in/evanmorikawa")
```

#### Specific Fields

See [available fields here](https://developer.linkedin.com/documents/profile-fields)

```ruby
my_name = api.profile(fields: ["first-name", "last-name"])
my_job_titles = api.profile(fields: ["id", {"positions" => ["title"]}])
```

#### Multiple People

```ruby
me_and_others = api.profile(ids: ["self", "SDmkCxL2ya"])
```

#### Connections

```ruby
# Takes the same arguments as `LinkedIn::API#profile`
my_connections = api.connections
evans_connections = api.connections(id: "SDmkCxL2ya")
```

#### New Connections

```ruby
# Takes the same options argument as `LinkedIn::API#connections`
since = Time.new(2014,1,1)
my_new_connections = api.connections(since)
evans_new_connections = api.connections(since, id: "SDmkCxL2ya")
```

### People Search

Search through People

See https://developer.linkedin.com/documents/people-search-api

```ruby
api.search
api.search("Proximate")
api.search(keywords: "Proximate Olin")
api.search(keywords: "Proximate Olin", start: 10, count: 20)
api.search(school_name: "Olin College of Engineering")

api.search(fields: {facets: ["code", {buckets: ["code", "name"]}] },
                    facets: "location")

# Identify all 1st degree connections living in the San Francisco Bay Area
# See https://developer.linkedin.com/documents/people-search-api#Facets
api.search(fields: {facets: ["code", {buckets: ["code", "name", "count"]}]},
           facets: "location,network",
           facet: ["location,us:84", "network,F"])
```

### Groups

Access and interact with LinkedIn Groups

You need the "rw_groups" permission for most group actions

See https://developer.linkedin.com/documents/groups

```ruby
# My groups
api.group_suggestions
api.group_memberships

# Another group
api.group_profile(id: 12345)
api.group_posts(id: 12345, count: 10, start: 10)

# Participate
api.add_group_share(12345, title: "Hi")

api.join_group(12345)
```

### Companies

Detailed overviews of Company information

See https://developer.linkedin.com/documents/companies

```ruby
# Company info
api.company(name: "google")
api.company(id: 12345)
api.company_updates(name: "google")
api.company_statistics(name: "google")

# Info on a particular company update
api.company_update_comments(1337, name: "google")
api.company_update_likes(1337, name: "google")

# Follow/unfollow
api.follow_company(12345)
api.unfollow_company(12345)

# Need rw_company_admin
api.add_company_share(12345, content: "Hi")
```

### Jobs

A search for Jobs on LinkedIn

See https://developer.linkedin.com/documents/jobs

```ruby
# Find a job
api.job(id: 12345)

# Your jobs
api.job_bookmarks
api.job_suggestions
api.add_job_bookmark(12345)
```

### Share and Social Stream

View and update content on social streams

See https://developer.linkedin.com/documents/share-and-social-stream

```ruby
# Your news feed
api.network_updates
api.shares

api.add_share(content: "hi")
api.update_comment(12345, content: "hi")

# For a particular feed item
api.share_comments(12345)
api.share_likes(12345)

api.like_share(12345)
api.unlike_share(12345)
```

### Communications

Invitations and messages between connections apis

See https://developer.linkedin.com/documents/communications

```ruby
# Need w_messages permissions

api.send_message("Subject", "Body", ["user1234", "user3456"])
```

# Documentation

On [RubyDoc here](http://rubydoc.info/github/emorikawa/linkedin-oauth2/frames/file/README.md)

Read the source for [LinkedIn::API](https://github.com/emorikawa/linkedin-oauth2/blob/master/lib/linked_in/api.rb) and [LinkedIn::OAuth2](https://github.com/emorikawa/linkedin-oauth2/blob/master/lib/linked_in/oauth2.rb)

# Upgrading

v1.0 of linkedin-oauth2 is a near complete re-write of the gem. Its
primary goals were to:

* Better isolate OAuth 2.0 logic
* Better documentation around OAuth 2.0
* Build on top of [Faraday](https://github.com/lostisland/faraday)
* Modularize the API Endpoints
* Better cover LinkedIn's vast API & audit deprecated actions
* Achieve near perfect test coverage & code quality

There are two places you may be upgrading from:

1. oauth2-v0.1 of this linkedin-oauth2 gem
2. [hexgnu/linkedin](https://github.com/hexgnu/linkedin) OAuth 1.0 gem

### From oauth2-v0.1.0 of linkedin-oauth2

See the [README from oauth2-v0.1](https://github.com/emorikawa/linkedin-oauth2/blob/395540d029156f29d0e53f588feb31f279aa5d70/README.markdown)

* The OAuth portion has substantially changed. There should be no changes
  for the signature of API calls or the response hashes
* Some of the API calls in the oauth2-v0.1 were actually broken in the
  initial OAuth2.0 transition. Those have now been fixed.
* Instead of a single `LinkedIn::Client` object there are now two separate
  major objects.

  1. `LinkedIn::OAuth2` for performing authentication
  1. `LinkedIn::API` for accessing the API

* Requests used to be done through the `OAuth2::AccessToken` object. Now
  they are done through `LinkedIn::Connection`, which is a thin subclass of
  `Faraday::Connection`. This is composed into the main `LinkedIn::API`
  object.

### From hexgnu/linkedin OAuth 1.0

* OAuth 2.0 is substantially different then OAuth 1.0
* The actual API methods, arguments, and return values were designed to
  look the same as hexgnu/linkedin. You should only have to swap out the
  Authentication and API client construction.
* There is no more `consumer` object. Everything in OAuth 2.0 is centered
  around acquiring an **Access Token**. Use the new `LinkedIn::OAuth2`
  class to acquire the token.
* There is no more single `client` object. The equivalent is the
  `LinkedIn::API` object. The `LinkedIn::API` object only needs an access
  token to work
* Requests used to be done through an `OAuth::AccessToken` object. Now
  they are done through `LinkedIn::Connection`, which is a thin subclass of
  `Faraday::Connection`. This means that you have the full power and
  method signatures of Faraday at your disposal.

# Contributing

Please see [CONTRIBUTING.md](https://github.com/emorikawa/linkedin-oauth2/blob/master/CONTRIBUTING.md) for details.

# Credits

* [Evan Morikawa](https://twitter.com/eom) ([emorikawa](https://github.com/emorikawa))
* [Matt Kirk](http://matthewkirk.com) ([hexgnu](https://github.com/hexgnu))
* [Wynn Netherland](http://wynnetherland.com) ([pengwynn](https://github.com/pengwynn))
* Josh Kalderimis ([joshk](https://github.com/joshk))
* Erik Michaels-Ober ([sferik](https://github.com/sferik))
* And Many More [Contributors](https://github.com/emorikawa/linkedin-oauth2/graphs/contributors)

# License

Copyright :copyright: 2014-present [Evan Morikawa](https://twitter.com/e0m) 2013-2014 [Matt Kirk](http://matthewkirk.com/) 2009-11 [Wynn Netherland](http://wynnnetherland.com/) and [contributors](https://github.com/emorikawa/linkedin-oauth2/graphs/contributors). It is free software, and may be redistributed under the terms specified in the MIT-LICENSE file. See [LICENSE](https://github.com/emorikawa/linkedin-oauth2/blob/master/LICENSE) for details.
