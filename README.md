# Chip: For easy access to micro Ruby library on a Web page

Chip is a micro program manager for Ruby.

## Featrues

  * Run and install a micro program on some Web page.
  * Chip can extend by Chip.

## Installation

Requires ruby and rubygems. Install as a gem:

    gem install chip

## Usage

### Install
If you created a awesome monky patch as [this page](https://raw.github.com/gist/1417282):

    class Fixnum
      def hour; self * 60 * 60; end
    end

you can install it:

    $ chip install https://raw.github.com/gist/1417282

And, you can use it as following code:

    # a.rb
    require "chip"
    require_chip "https://raw.github.com/gist/1417282"
    
    puts 1.hour

    $ ruby a.rb
    3600

#### Dynamic install

    # a.rb
    require "chip"
    require_chip "https://raw.github.com/gist/1425982"
    
    puts 1.minute

    $ ruby a.rb
    Installing...
    /path/to/.chip.d/https:__raw.github.com_gist_1425982.rb
    ---
    class Fixnum
      def minute; self * 60; end
    end
    ---
    Do you install above a program? [yes/no] > yes
    60

### Run

If a web page has a pre tag that first line is included `chip',

    #chip
    
      eval(     %w|   put   s("   H3429el
    l0     o6   ,_4   C52   h0i   98    62
    63          0p2455!!2   952   0".gsub
    (/     \\   d/,   '')   .tr   ("
      _",32    .chr   ))|   *''   )#

you can run it by the chip command!!:

    $ chip run https://github.com/authorNari/chip -f
    Hello, Chip!!

## Extend micro code fetcher by Chip

TODO

Example fetcher: [Twitter status fetcher](/wiki/Twitter-status-fetcher)

## Copyright

Copyright (c) 2011 nari. See MIT-LICENSE for further details.
