# ActsAsTemporary

On occasion I've had the need to store data for a short period of time within an application's database but did not want it to artificially inflate the ID numbers.
This gem uses a _TemporaryObject_ model that stores the "definition" (read: attributes) of a model. It can then be recalled at a later date. Upon saving a recalled object the temporary version is deleted. 

## Requirements

This project builds upon ActiveRecord. In theory this should work with nothing outside of a Rails application

## Installation

This project is distributed as a gem and it should be as simple as adding the following line to your **Gemfile**.

    gem 'acts_as_temporary', '~> 0.0.1'

You'll need to copy and run the migration from the engine.

    $ cd _/your/rails/app_
    $ rake acts_as_temporary_engine:install:migrations
    $ rake db:migrate

## Configuration

In your _{environment}.rb_ file you can set the shelf life of a temporary object with the following configuration definition:

    config.acts_as_temporary_shelf_life = 1.day # Set the duration to something that makes sense

By default the shelf life of a temporary object is _365.days_.

# Usage

## Class Methods

### can\_be\_temporary

Within the model you would like to be able to temporarily store you just need to add the following line.

    can_be_temporary

For example, if you wish to make the _Registration_ model one that can be temporary the model would look like this to start.

    class Registration < ActiveRecord::Base
      can_be_temporary
    end

### clear\_stale\_objects

Rolls through the temporary objects table and clears any old temporary objects. By default anything older than 24 hours is considered stale.

## Instance Methods

### #store

The _#store_ instance method takes the instance and stores it as a temporary object. The temporary object's ID is then stored within the objects _@temporary\_id_ instance variable.

### #recall

The _#recall_ instance method takes the ID of a temporary object and attempts to instantiate that data.

### #is_temporary?

Returns __true__ if the current object as a _@temporary\_id_.

### Example

    registration = Registration.new(params[:registration])
    registration.is_temporary? # => false
    
    registration.store # => this object's data is stored in the database and the ID of the temporary object is interally assigned
    registration.id # => nil
    registration.temporary_id # => 14123
    registration.is_temporary? # => true
    
    registration = Registration.recall(14123)
    registration.id # => nil
    registration.is_temporary? # => true


This project uses MIT-LICENSE.