# Harry
# =====
# Plugin to have :smiley: and (animated_smiley) in your jekyll blogs
# it uses the famous Emoji-Cheat-Sheet : 'http://www.emoji-cheat-sheet.com/'
# and for animated icons : 'http://www.emoticonhq.com'
#
# https://github.com/pravj/Harry

require 'net/http'
require 'fileutils'

Simple_URI = 'www.emoji-cheat-sheet.com'
Animated_URI = 'www.emoticonhq.com'

module Jekyll
  module Harry
    #Create required directory if they don't exist
    def createDirs():
      dirs = [ '/public/smileys/animated', '/public/smileys/simple' ] 
      FileUtils.mkdir_p dirs

    # returns an image tag, having image source as local image file
    def ImageTag(smiley, animated = false)
      if animated == true:
        '<img src="/public/smileys/'+smiley+'.gif" title="('+smiley+')" height="20px" width="20px" style="display:inline;margin:0;vertical-align:middle"/>'
      else:      
        '<img src="/public/smileys/'+smiley+'.png" title=":'+smiley+':" height="20px" width="20px" style="display:inline;margin:0;vertical-align:middle"/>'
    end

    # stores an image locally, by default it store in '/public/smileys'
    def ImageStore(smiley, animated = false)
      if animated == true:
        Net::HTTP.start(Animated_URI) do |http|
          res = http.get('/images/Skype/'+smiley+'.gif')
          File.open('public/smileys/animated'+smiley+'.gif', 'wb') { |file| file.write(res.body) }        
      else: 
        Net::HTTP.start(Simple_URI) do |http|
          res = http.get('/graphics/emojis/'+smiley+'.png')
          File.open('public/smileys/simple/'+smiley+'.png', 'wb') { |file| file.write(res.body) }        
      end
    end

    # checks, if a smiley actually exists or not
    def SmileyExist(smiley, animated = false)
      if animated == true:
        uri = URI('http://' + Animated_URI + '/images/Skype/'+ smiley + '.gif')
      else:
        uri = URI('http://' + Simple_URI + '/graphics/emojis/' + smiley + '.png')

      res = Net::HTTP.get_response(uri)
  
      if res.code == '200'
        return true
      else
        return false
      end
    end

    def Harry(text)
      # matches all :smiley: style text in content
      text.to_str.gsub(/:([a-z0-9\+\-_]+):/) do |match|

        # proposed image path, if image is locally available
        local_image = File.join(Dir.pwd, 'public', 'smileys', 'simple', $1 + '.png')

        # returns image tag, if image locally exists
        if File.exist?(local_image)
          ImageTag($1)

        # image doesn't exists locally
        else
          # stores the image and returns image tag, if smiley is valid
          if SmileyExist($1)
            ImageStore($1)
            ImageTag($1)
          else
            ':'+$1+':'
          end
        end

      end
      text.to_str.gsub(/(([a-z0-9\+\-_]+))/) do |match|

        local_image = File.join(Dir.pwd, 'public', 'smileys', 'animated', $1 + '.gif')

        if File.exist?(local_image)
          ImageTag($1)
        else
          if SmileyExist($1)
            ImageStore($1)
            ImageTag($1)
          else
            '('+$1+')'
          end
        end

    end
  end
end

# registers this custom filter globally
Liquid::Template.register_filter(Jekyll::Harry)
