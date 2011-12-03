# Chip: For easy access to micro Ruby library on a Web page

Chip is a micro program manager for Ruby.

## Installation

Requires ruby and rubygems. Install as a gem:

    gem install chip

## Usage

### Run
If you want to run the micro program on [this page](https://raw.github.com/gist/1415921):

    puts "Hello, world!"

you can run it by the chip command:

    $ chip run https://raw.github.com/gist/1415921
    Installing...
    https://raw.github.com/gist/1415921
    ---
    puts "Hello, world!"
    ---
    Do you install above a chip program? [yes/no] > yes
    Do you run?[yes/no] > yes
    puts "Hello, world!"

### Install
If you created a awesome monky patch as [this page](https://raw.github.com/gist/1417282):

    class Fixnum
      def hour; self * 60 * 60; end
    end

You can use it as following code:

    require "rubygems"
    require "chip"
    require_chip "https://raw.github.com/gist/1417282"
    
    puts 1.hour

    $ ruby a.rb
    3600

You can install target program when you haven't installed it:

    $ ruby h.rb
    Installing...
    https://raw.github.com/gist/1417282
    ---
    class Fixnum
      def hour; self * 60 * 60; end
    end
    ---
    Do you install above a chip program? [yes/no] > yes
    3600
