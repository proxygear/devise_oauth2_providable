# A great fork of : devise_oauth2_providable

My probleme with original devise_oauth2_providable gem was :
 * It was dedicated only to ActiveRecord ORM, I'm using Mongoid
 * It forces to use provided models, I needed to plug behaviour in my own models

## ORM Behaviour Gems

This version contains the default behaviour for ActiveRecord.
If you need something else you can :
 * use Mongoid Behaviour : https://github.com/proxygear/devise_oauth2_providable_mongoid
 * create your own ... Ask help if you need ;)

````.rb
gem 'devise_oauth2_providable', :git => 'https://github.com/proxygear/devise_oauth2_providable.git'

# The :branch => :mongo_mapper_orm is not necessary anymore. I did merge it into the master.
gem 'devise_oauth2_providable_mongoid', :git => 'https://github.com/proxygear/devise_oauth2_providable_mongoid.git'
````

## Model Configuration

Feel free to use the names you want :
Create a config/initializer/oauth2_providable_models.rb initializer file.

````.rb
Devise::Oauth2Providable.configure_models() do |abstract|
  abstract.client_sym = :my_client_app
  abstract.refresh_token_sym = :refresh_token
  abstract.authorization_code_sym = :tmp_authorization_code
  abstract.access_token_sym = :access_token
end
````

## Code quality & Specs

Those gem were created in a kind of rush period ...
It works (1 year in production) but could be improved.
If you so desire, for the fate of code beauty, simply pull request.

## Support

If you have any problem, just contact me, issue on github, scream ...
Thank you.

Here is the original README stuff.

# devise_oauth2_providable (ORIGINAL README)

Rails3 engine that brings OAuth2 Provider support to your application.

Current OAuth2 Specification Draft:
http://tools.ietf.org/html/draft-ietf-oauth-v2-22

## Features

* integrate OAuth2 authentication with Devise authenthentication stack
* one-stop-shop includes all Models, Controllers and Views to get up and
  running quickly
* All server requests support authentication via bearer token included in
the request.  http://tools.ietf.org/html/draft-ietf-oauth-v2-bearer-04
* customizable mount point for oauth2 routes (ex: /oauth2 vs /oauth)


## Requirements

* Devise authentication library
* Rails 3.1 or higher

## Installation

#### Install gem
```ruby
# Gemfile
gem 'devise_oauth2_providable'
```

#### Migrate database for Oauth2 models
```
$ rake devise_oauth2_providable:install:migrations
$ rake db:migrate
```

#### Add Oauth2 Routes
```ruby
# config/routes.rb
Rails.application.routes.draw do
  # oauth routes can be mounted to any path (ex: /oauth2 or /oauth)
  mount Devise::Oauth2Providable::Engine => '/oauth2'
end
```

#### Configure User for supported Oauth2 flows
```ruby
class User
  # NOTE: include :database_authenticatable configuration
  # if supporting Resource Owner Password Credentials Grant Type
  devise :oauth2_providable, 
    :oauth2_password_grantable,
    :oauth2_refresh_token_grantable,
    :oauth2_authorization_code_grantable
end
```

#### (optional) Configure token expiration settings
```ruby
# config/application.rb
config.devise_oauth2_providable.access_token_expires_in         = 1.second # 15.minute default
config.devise_oauth2_providable.refresh_token_expires_in        = 1.minute # 1.month default
config.devise_oauth2_providable.authorization_token_expires_in  = 5.seconds # 1.minute default
```

## Models

### Client
registered OAuth2 client for storing the unique client_id and
client_secret.

### AccessToken
http://tools.ietf.org/html/draft-ietf-oauth-v2-15#section-1.3

Short lived token used by clients to perform subsequent requests (see
bearer token spec)

expires after 15min by default.  to customize the duration of the access token:

```ruby
ABSTRACT(:access_token).default_lifetime = 1.minute
```

### RefreshToken
http://tools.ietf.org/html/draft-ietf-oauth-v2-15#section-1.5

Long lived token used by clients to request new access tokens without
requiring user intervention to re-authorize.

expires after 1 month by default. to customize the duration of refresh token:

```ruby
ABSTRACT(:refresh_token).default_lifetime = 1.year
```

### AuthorizationCode
http://tools.ietf.org/html/draft-ietf-oauth-v2-15#section-1.4.1

*Very* short lived token created to allow a client to request an access
token after a user has gone through the authorization flow.

expires after 1min by default. to customize the duration of the
authorization code:

```ruby
Devise::Oauth2Providable.models.authorization_code.default_lifetime = 5.minutes
```

## Routes

### /oauth2/authorize
http://tools.ietf.org/html/draft-ietf-oauth-v2-15#section-2.1

Endpoint to start client authorization flow.  Models, controllers and
views are included for out of the box deployment.

Supports the Authorization Code and Implicit grant types.

### /oauth2/token
http://tools.ietf.org/html/draft-ietf-oauth-v2-15#section-2.2

Endpoint to request access token.  See grant type documentation for
supported flows.

## Grant Types

### Resource Owner Password Credentials Grant Type
http://tools.ietf.org/html/draft-ietf-oauth-v2-15#section-4.3

in order to use the Resource Owner Password Credentials Grant Type, your
Devise model *must* be configured with the :database_authenticatable option

### Client Credentials Grant Type
http://tools.ietf.org/html/draft-ietf-oauth-v2-15#section-4.4

### Authorization Code Grant Type
http://tools.ietf.org/html/draft-ietf-oauth-v2-15#section-4.1

### Implicit Grant Type
http://tools.ietf.org/html/draft-ietf-oauth-v2-15#section-4.2

### Refresh Token Grant Type
http://tools.ietf.org/html/draft-ietf-oauth-v2-15#section-6

## Contributing
 
* Fork the project
* Fix the issue
* Add unit tests
* Submit pull request on github

See CONTRIBUTORS.txt for list of project contributors

## Copyright

Copyright (c) 2011 Socialcast, Inc. 
See LICENSE.txt for further details.

