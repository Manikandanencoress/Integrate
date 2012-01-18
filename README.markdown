To set up the project run:
(Can run from a Snow Leopard new image)

* OSX Lion: Additional notes after the following steps *

First:
    * Install XCode
    * Install Firefox >= 4.0.1
    * Get someone to give you access to the github repo (create & add SSH keys)

Then run all this:
    #install soloist
    sudo gem install soloist -v 0.0.8

    # install homebrew
    ruby -e "$(curl -fsSL https://raw.github.com/gist/323731)"
    brew install git

    mkdir -p ~/workspace && cd workspace/
    # checkout the project & submodules
    git clone git@github.com:rsposton/sumuru.git
    cd sumuru
    git submodule init && git submodule update

    LOG_LEVEL=debug soloist

    # At this point start a new shell, you'll need to pick up rvm in your path.

    rvm install ruby-1.9.2-p180
    rvm gemset create 'sumuru'
    cd ~/workspace && cd sumuru

    gem install bundler
    bundle

    bundle exec rake db:create db:migrate db:test:prepare
    bundle exec rake


To set up a heroku project, make sure you have the following Addons:
    *custom_domains:basic
    *custom_error_pages
    *hoptoad:plus
    *logging:expanded
    *newrelic
    *pgbackups:basic
    *sendgrid:free
    *shared-database:5mb
    *ssl:ip

To setup hotpoad notifications:
    rake hoptoad:heroku:add_deploy_notification --app sumuru-sandbox

* Lion Upgrade *
    * install xcode 4.x again, it will reinstall your git as well.
    * brew install imagemagick  (do it again, or your rake will complain of an 'identity' issue
    * remove nginx from ~/.install_markers
    * run 'soloist' again