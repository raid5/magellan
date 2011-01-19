Magellan - The API Explorer
===========================

Explore those APIs with the famous Ferdinand Magellan.

Requirements
------------
* Rails (>= 3.0.0)
* Ruby (>= 1.8.7-p302 or >= 1.9.2-p0)
* Python (2.5+)
* albino
* curb
* yajl-ruby
* xmllint
* pygments

Installation
------------
Gemfile
    gem 'albino'
    gem 'curb'
    gem 'yajl-ruby'
    
Install xmllint
    OS X - MacPorts
    $ port install libxml2

    OS X - Homebrew
    $ brew install xmllint
    
    Ubuntu/Debian
    $ apt-get install libxml2-utils
    
Python egg for pygments
    $ easy_install pygments
    
Getting Going
-------------
Start the server
    $ rails s
    
Authentication
If your API endpoint require authentication, set these up first. Currently,
HTTP Basic (username/password pair) and OAuth (access token) is supported.

Global Parameters
TODO

Endpoints
TODO

Parameter Sets
TODO
    
Contribution
------------
Many thanks for [Chris Wanstrath][3] and [Leah Culver][2] for their work on [hurl.it][1]
which this project has been influenced by.

[1]: http://github.com/defunkt/hurl
[2]: http://github.com/leah
[3]: http://github.com/defunkt
