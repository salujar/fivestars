#API Test Automation Framework (User Login and Memberships for now)

A Ruby 2.3.0 interface for FiveStars. The suite is currently using the Rspec testing framework.

#Requirements - Already pre-defined in the test spec file ~/spec/fivestars_spec.rb

* phone number and pin
* business_group_uid
* business_uid

#Installation
Clone and install
```bash
$ git clone git@github.com:yoyo4cash/fivestars.git
$ cd fivestars
$ bundle install
```

#Running the test

##Run the test via rspec
```bash
$ bundle exec rspec -fd -c ./spec/fivestars_spec.rb
```