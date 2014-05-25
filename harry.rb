# Harry
# =====
# Plugin to have :smiley: and (animated_smiley) in your jekyll blogs
# it uses the famous Emoji-Cheat-Sheet : 'http://www.emoji-cheat-sheet.com/'
# and for animated icons : 'http://www.emoticonhq.com'
#
# https://github.com/pravj/Harry

require 'net/http'
require 'fileutils'

General_Smiley_URI = 'www.emoji-cheat-sheet.com'
Animated_Smiley_URI = 'www.emoticonhq.com'

module Jekyll
  module Harry

    #Create required directory if they don't exist
    def CreateDirs()
      dirs = [ './public/smileys/animated', './public/smileys/general' ] 
      FileUtils.mkdir_p dirs
    end

    # returns an image tag, having image source as local image file
    def ImageTag(smiley, animated = false)
      if animated
        '<img src="/public/smileys/animated/'+smiley+'.gif" title="('+smiley+')" height="20px" width="20px" style="display:inline;margin:0;vertical-align:middle"/>'
      else
        '<img src="/public/smileys/general/'+smiley+'.png" title=":'+smiley+':" height="20px" width="20px" style="display:inline;margin:0;vertical-align:middle"/>'
      end
    end

    # stores an image locally, by default it store in '/public/smileys'
    def ImageStore(smiley, animated = false)
      if animated
        Net::HTTP.start(Animated_Smiley_URI) do |http|
          res = http.get('/images/Skype/'+smiley+'.gif')
          File.open('public/smileys/animated/'+smiley+'.gif', 'wb') { |file| file.write(res.body) }
	end
      else
        Net::HTTP.start(General_Smiley_URI) do |http|
          res = http.get('/graphics/emojis/'+smiley+'.png')
          File.open('public/smileys/general/'+smiley+'.png', 'wb') { |file| file.write(res.body) }
	end
      end
    end

    # checks, if a smiley actually exists or not
    def SmileyExist(smiley, animated = false)
      if animated
        uri = URI('http://' + Animated_Smiley_URI + '/images/Skype/'+ smiley + '.gif')
      else
        uri = URI('http://' + General_Smiley_URI + '/graphics/emojis/' + smiley + '.png')
      end

      res = Net::HTTP.get_response(uri)
  
      if res.code == '200'
        return true
      else
        return false
      end
    end

    # matches all :smiley: style text in content
    # but distinguish between general and animated smileys
    def Process(text)
      text.to_str.gsub(/:\(?([a-z0-9\+\-_]+)\)?:/) do |match|
	      
        # checks, if user wanted an animated smiley or not
        animated = false
        if (match.include?('(') && match.include?(')'))
          animated = true
        end

        # proposed image path, if image is locally available
	if animated
          local_image = File.join(Dir.pwd, 'public', 'smileys', 'animated', $1 + '.gif')
        else
          local_image = File.join(Dir.pwd, 'public', 'smileys', 'general', $1 + '.png')
        end

        # returns image tag, if image locally exists
        if File.exist?(local_image)
          ImageTag($1, animated)

        # image doesn't exists locally
        else
          # stores the image and returns image tag, if smiley is valid
          if SmileyExist($1, animated)
            ImageStore($1, animated)
            ImageTag($1, animated)
          else
            if animated
              '('+$1+')'
            else
              ':'+$1+':'
            end
          end
        end

      end
    end

    # function that serves as a filter in outer world 
    def Harry(text)
      CreateDirs()
      Process(text)
    end

  end
end

# registers this custom filter globally
Liquid::Template.register_filter(Jekyll::Harry)
