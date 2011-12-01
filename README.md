# Chips: For easy access to micro Ruby library on the Web

Chips is a micro program manager for Ruby.

## Installation

Requires ruby and rubygems. Install as a gem:

  gem install chips

## Usage
If you want to execute the micro program on [this page](https://raw.github.com/gist/1415921):

  puts "Hello, world!"

you can install it by the chip command:

  $ chip install https://raw.github.com/gist/1415921

You can use it as following code:

  require "rubygems"
  require "chips"
  require_chip "https://raw.github.com/gist/1415921"
  
  $ ruby a.rb
  Hello, world!

or, you can install target program when you haven't installed it:

  $ ruby hello_world.rb
  Installing...
  https://raw.github.com/gist/1415921
  ---
  puts "Hello, world!"
  ---
  Do you install above a chip program? [yes/no] > yes
  Hello, world!
