Harry
=====
jekyll plugin to have :smileys: in your blogs

> Harry lets you use any smiley from the famous [emoji-cheat-sheet](https://emoji-cheat-sheet.com) in your Jekyll powered blog

How this works
==============
* Harry checks for a valid smiley on `emoji-cheat-sheet`
* if smiley is valid it saves the smiley image file to `public/smileys/`
* occurance for a smiley(`:grinning:`) is changed to respective image
* on a non-valid smiley text, it returns it, as it is.
* for example :idontexist: will result as it is.
* Basically Harry implements a new `Liquid Filter`, which parse and change smileys accordingly

How to use
==========
* create a new directory `smileys` in your project's `public/` directory
* copy `harry.rb` in plugins directory `_plugins/`(default)
* pass your content having smileys through new `Liquid Filter:Harry`. ex. {{ content | Harry }}
* it will do magic things after all this.


> I made Harry to have smiley support in my [Blog](https://pravj.github.io)

> :santa: : Now there will be smileys everywhere
