Magellan - The API Explorer
===========================

Explore those APIs with the famous Ferdinand Magellan.

What Is This?
-------------
Magellan is a customizable API console written in Rails 3. It provides an interface
to test/explore any API (see Caveats) by defining the API endpoints and the
required parameters for those endpoints. You can submit data to your endpoints,
then inspect your outgoing request and the response received.

Why?
----
I noticed a lot of API console being rolled out with the latest API revisions
of a few popular sites ([Twitter console](http://dev.twitter.com/console), 
[Gowalla console](http://gowalla.com/api/explorer)) and I wanted to mess around
with the idea of creating an API console that would work for any API. Magellan
was also highly influenced by [hurl.it](http://hurl.it), created by
[Chris Wanstrath][3] and [Leah Culver][2] for the 2009 Rails Rumble. The project
started out initially as just an experiment to see what could be accomplished in
a weekend and ended up being used internally on a couple internal projects with
one of my current employers.

Caveats
-------
* No OAuth2 support (yet!)
* Cannot send POST data through the request body. All parameters are added to the query string.

What Does It Look Like?
-----------------------
Magellan makes no attempt at trying to please your eyes. I have added some simple
styling to organize the content, but any beautification is left up to you!

I have a live, running instance of the latest version up on Heroku which is
preconfigured to hit a few Twitter API endpoints (including updating the status
of my test user @ferd_magellan). The link below is the explore interface only.
Every other page is protected to prevent tampering with the demo setup.

[Heroku Instance](http://ferdinand-magellan.heroku.com/)

Requirements
------------
* Rails (>= 3.0.0)
* Ruby (>= 1.8.7-p302 or >= 1.9.2-p0)
* Python (2.5+)
* albino
* curb
* yajl-ruby
* xmllint
* simplejson
* pygments

Tested On
---------
* Mac OS X 10.6.6
* Rails 3.0.3
* Ruby 1.9.2p0 (2010-08-18 revision 29036) [x86_64-darwin10.4.0]

Issues
------
Currently the response data displayed on the page is somewhat borked. I recently
updated to the latest version of the Albino gem (used for syntax highlighting the
response) and it appears there might be a [bug](https://github.com/github/albino/issues#issue/4)
or two in the gem with the current version. I will have this resolved once I
get some feedback on the issue.

Installation (non-Gemfile dependencies)
------------
Install xmllint (used to format the XML output)

    OS X - MacPorts
    $ port install libxml2

    OS X - Homebrew
    $ brew install xmllint
    
    Ubuntu/Debian
    $ apt-get install libxml2-utils
    
Python eggs for pygments (used by the Albino gem) and simplejson (formatting)

    $ easy_install pygments simplejson

    
Getting Going
-------------
Update gems

    $ bundle
    
Setup the database

    $ rake db:migrate

Start the server

    $ rails server
   
Navigate to [http://localhost:3000/setup](http://localhost:3000/setup) to start
the configuration setup.

Typical Setup Flow
------------------
### (1) Authentication

Initially, you will need to setup up some authentications. Both 
[HTTP Basic](http://en.wikipedia.org/wiki/Basic_access_authentication)
and [OAuth 1.0](http://tools.ietf.org/html/rfc5849) are currently supported with
[OAuth2](http://oauth.net/2/) coming soon. You can setup as many authentications
as you want, but you must setup at least one default. When actually testing
out the setup APIs, you will be able to toggle between which authentication
you want to use for that request.

### (2) Global Parameters

After creating at least one default authentication, you can setup any global
parameters you plan on using across all your API requests. Both standard and
header global parameters are ALWAYS sent. Global URL parameters are only sent
if the endpoint URL specifies that parameter is needed (more on this below).

A common use for such global parameters is sending along your API key with every
request you make. Many services use this to track your usage and moderate abuse.
Another example is specifying the response format for all responses from the API.

#### Standard Parameters

Normal name/value pairs used in the query string of the request.

Name: q, Value: Stewie Griffin

http://api.example.com/users/search?q=Stewie+Griffin  

#### Header Parameters

Header parameters are name/value pairs added to the request headers.

X-Example-Key: k3mm983knmr2msi3inmsnmm299xma3m9x

#### URL Parameters

URL paramters are those used to replace URL "placeholders" specified in the
endpoint URL. The placeholder is always prefixed with a colon.

Example URL: http://api.example.com/users/:username.json

In this example, 'username' is the placeholder that you will need to create either
a global parameter for, or you can specify an endpoint parameter that will only
be used for that specific instance.

### (3) Groups, Endpoints, Parameter Sets, and Response Members

In these final steps, you can define groupings for your endpoints and multiple
parameter sets per endpoint.

#### Groups

Groups are a way of organizing endpoints. Example groups used for the Twitter
API are: 'Timeline, 'Users', 'Direct Messages', etc.

#### Endpoints

Within each group, you can define as many endpoints as needed. An endpoint is
composed of a name, description, and the URL the request will hit. Remember to
include any URL parameter placeholders when specifying the endpoint URL.

#### Parameter Sets

For each endpoint, you can define multiple sets of parameters you would like to
send to the endpoint. Each of these parameter sets can also specify a different
HTTP verb (GET, POST, PUT, DELETE). For the most part, a single parameter set
per endpoint is all that is required. In this case, just give the parameter set
the same name as the endpoint to keep things simple. Below are just two example
parameter sets for the same endpoint.

##### Parameter Set #1 for Endpoint #3

GET with screen_name = roxy, count = 20

##### Parameter Set #2 for Endpoint #3

GET with user_id = 534651, include_rts = true

#### Response Members

You can also specify example data and a description for the different elements
that are returned in the request response. This allows you to provide some
documentation for the response.

### (4) Explore

Once everything is setup, you can nagivate to Navigate to [http://localhost:3000/](http://localhost:3000/)
to start exploring those API endpoints! You may have already come across this
interface while testing our your endpoint parameter sets.

Security
--------

If you wish to expose your Magellan setup to the public, I highly recommend you
enable HTTP Basic access to everything but the explore interface. To do this,
simply follow the instructions in the provided ApplicationController. It is setup
by default to require authentication for everything but Endpoints#show.
    
Contribution
------------
Many thanks for [Chris Wanstrath][3] and [Leah Culver][2] for their work on [hurl.it][1]
which this project has been influenced by.

[1]: http://github.com/defunkt/hurl
[2]: http://github.com/leah
[3]: http://github.com/defunkt
