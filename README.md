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

for example, your sample blog post in `_posts/`

    ---
      layout: post
      title: ""
    ---
      
      
      Harry Potter: :tophat:
      I know things you don't know, Tom Riddle. I know lots of important things that you don't. 
      Want to hear some, before you make another big mistake?
      
      Lord Voldemort: :imp:
      Is it love again? Dumbledore's favourite solution, love, which he claimed conquered death,
      though love did not stop him falling from the tower and breaking like an old waxwork?
      Love, which did not prevent me stamping out your Mudblood mother like a cockroach,
      and nobody seems to love you enough to run forward this time and take my curse.
      
      So what will stop you dying now when I strike?.
      If it is not love that will save you this time, you must believe that you have magic that
      I do not, or else a weapon more powerful than mine?

      Harry Potter:
      I believe both. :sunglasses:
    
sample `post layout`

    ---
    layout: default
    ---
    
    <div class="post">
      <span class="post-date">
        <a href="{{ site.baseurl }}timeline" class="timeline">
          {{ page.date | date_to_string }}
        </a>
      </span>
      <h1 class="post-title">{{ page.title }}</h1>
      <hr>
      {{ content | Harry }}
    </div>
    

* it will do magic things after all this.
  
  you will see respective smileys in your jekyll generated blog post

  `:tophat:` => :tophat:, `:imp:`=>:imp:, `:sunglasses:`=>:sunglasses:


> I made Harry to have smiley support in my [Blog](https://pravj.github.io)

> :santa: : Now there will be smileys everywhere
