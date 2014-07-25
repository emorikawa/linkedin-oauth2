# LinkedIn

Oauth 2.0 Ruby wrapper for the [LinkedIn API](http://developer.linkedin.com).

## Installation

In Bundler:

```ruby
gem "linkedin-oauth2", "~> 1.0"
```

Otherwise:

    [sudo|rvm] gem install linkedin-oauth2

## Usage

**Step 1:** [Register](https://www.linkedin.com/secure/developer) your
application with LinkedIn. They will give you a **Client ID** (aka API
Key) and a **Client Secret** (aka Secret Key)

**Step 2:** Use your **Client ID** and **Client Secret** to obtain an **Access Token** from some user.

**Step 3:** Use an **Access Token** to query the API.

### Getting An Access Token

All LinkedIn API requests must be made in the context of an access token.
The access token encodes what LinkedIn information your AwesomeApp® can
gather on behalf of "John Doe".

There are a few different ways to get an access token from a user.

1. You can use [LinkedIn's Javascript API](https://developer.linkedin.com/documents/javascript-api-reference-0) to authenticate on the front-end and then pass the access token to the backend via [this procedure](https://developer.linkedin.com/documents/exchange-jsapi-tokens-rest-api-oauth-tokens).

1. If you use OmniAuth, I would recommend looking at [decioferreira/omniauth-linkedin-oauth2](https://github.com/decioferreira/omniauth-linkedin-oauth2) to help automate authentication.

1. You can do it manually using this linkedin-oauth2 gem and the steps
   below.

Here is how to get an access token using this linkedin-oauth2 gem:

```ruby
# It's best practice to keep secret credentials out of source code.
# You can, of course, hardcode dev keys or directly pass them in as the
# first two arguments of LinkedIn::OAuth2.new
LinkedIn.configure do |config|
  config.client_id     = ENV["LINKEDIN_CLIENT_ID"]
  config.client_secret = ENV["LINKEDIN_CLIENT_SECRET"]
end

@oauth = LinkedIn::OAuth2.new

url = @oauth.url_for_oauth_code
```

You must now load that url in a browser. It will pull up the LinkedIn
sign in box. Once LinkedIn user credentials are entered, the box will
close and redirect to your callback url, passing along with it the
**OAuth code** as a GET param.

Be sure to read the extended documentation around the LinkedIn::OAuth2
module for more options you can set.

**Note:** The **OAuth code** only lasts for ~20 seconds!

```ruby
code = "THE_OAUTH_CODE_LINKEDIN_GAVE_ME"

access_token = @oauth.get_access_token(code)
```

Now that you have an access token, you can use it to query the API.

### Using LinkedIn's API

Once you have an access token, you can query LinkedIn's API.

```ruby
@api = LinkedIn::API.new(access_token)

person = @api.profile

connections = @api.connections
```


















### Authenticate Overview

LinkedIn's API uses OAuth 2.0 for authentication. Luckily, this gem hides most of the gory details from you.

The gory details can be found [here](https://developer.linkedin.com/documents/authentication)

For legacy support of LinkedIn's OAuth 1.0a api, refer to the [pengwynn/linkedin](https://github.com/pengwynn/linkedin) gem.

Basically, you need 3 things to start using LinkedIn's API:

1. Your application's `client_id` aka **API Key**
1. Your application's `client_secret` aka **Secret Key**
1. An `access_token` from a user who authorized your app.

### If you already have a user's `access_token`
Then you have already authenticated! Encoded within that access token are
all of the permissions you have on a given user. Assuming you requested
the appropriate permissions, you can read their profile, grab connections,
etc.

    client = LinkedIn::Client.new("<your client_id>",
                                  "<your client_secret>",
                                  "<user access_token>")
    client.profile

You may also use the `set_access_token` method.

    client.set_access_token("<user access_token>", options)

### If you need to fetch an `access_token` for a user.
There are 4 steps:

1. Setup a client using your application's `client_id` and `client_secret`

    client = LinkedIn::Client.new('your_client_id', 'your_client_secret')

2. Get the `authorize_url` to bring up the page that will ask a user
   to verify permissions & grant you access.

    authorize_url = client.authorize_url

3. Once a user signs in to your OAuth 2.0 box, you will get an
   `auth_code` aka **code**. (Check in url you were directed to after a
   successful auth). Use this **auth code** to request the
   **access token**.

    access_token = client.request_access_token("<auth_code from last step>")

4. Once you have an `access_token`, you can request profile information or
   anything else you have permissions for.

    client.profile

### Profile examples
```ruby
# get the profile for the authenticated user
client.profile

# get a profile for someone found in network via ID
client.profile(:id => 'gNma67_AdI')

# get a profile for someone via their public profile url
client.profile(:url => 'http://www.linkedin.com/in/netherland')
```


More examples in the [examples folder](http://github.com/pengwynn/linkedin/blob/master/examples).

For a nice example on using this in a [Rails App](http://pivotallabs.com/users/will/blog/articles/1096-linkedin-gem-for-a-web-app).

If you want to play with the LinkedIn api without using the gem, have a look at the [apigee LinkedIn console](http://app.apigee.com/console/linkedin).

## Migration from OAuth 1.0a to OAuth 2.0
### Overall changes
* The term `consumer` is now referred to as the `client`
* The terms `token`, `consumer token`, or `consumer key` in OAuth 1.0 are now referred to as **`client_id`** in OAuth 2.0
* The terms `secret`, or `consumer secret` in OAuth 1.0 are now referred to as **`client_secret`** in OAuth 2.0
* In OAuth 1.0 there is both an `auth token` and an `auth secret`. OAuth 2.0 combines these into a single `access token`.
* The terms `auth token`, `auth key`, `auth secret`, `access secret`, `access token`, or `access key` have all been collapsed and are now referred to as the **`access token`**.
* `require` `linkedin-oauth2` instead of `linkedin`
* Removed proxy options

### Gem api changes
* In general, any place that said "consumer" now says "client"
* The `authorize_from_request` method has been deprecated. Instead
  navigate to the url from `authorize_url` then enter the returned code
  into the `request_access_token` method.
* The `authorize_from_access` method has been deprecated. Instead
  initialize the `LinkedIn::Client.new` with the `access_token`.
  `client = Linkedin::Client.new(client_id, client_secret, access_token)`


## Note on Patches/Pull Requests

* Fork the project.
* Make your feature addition or bug fix.
* Add tests for it. This is important so I don't break it in a
  future version unintentionally.
* Commit, do not mess with rakefile, version, or history.
  (if you want to have your own version, that is fine but
   bump version in a commit by itself I can ignore when I pull)
* Send me a pull request. Bonus points for topic branches.

## Testing
Run `bundle install`

## Copyright

Copyright (c) 2013 [Evan Morikawa](https://twitter.com/E0M). See LICENSE for details.
