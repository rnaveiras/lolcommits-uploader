module Lolcommits
  class Uploader < Thor 
    include Thor::Actions

    desc "upload", "upload the last commit photo"
    def upload
      config                   = YAML::load(File.read(File.expand_path('~/.s3-uploader.yaml')))

      connection               = Fog::Storage.new({
        :provider              => 'AWS',
        :aws_access_key_id     => config['aws_access_key_id'],
        :aws_secret_access_key => config['aws_secret_access_key']
      })

      bucket    = connection.directories.get(config['aws_bucket_name'])

      repo      = Git.open('.')
      sha       = repo.log.first.sha[0..10]
      key       = "#{sha}.jpg"
      key_thumb = "#{sha}_thumb.jpg"

      filename  = File.join(File.expand_path('~/.lolcommits'), File.basename(repo.dir.to_s), key)
      bucket.files.create(:key => "#{File.basename(repo.dir.to_s)}/#{key}", :body => File.read(filename), :public => true, :content_type => 'image/jpeg').save
      
      if config['thumb_enable']
        filethumb = File.join(File.expand_path('~/.lolcommits'), File.basename(repo.dir.to_s), key_thumb)
        image     = Magick::Image.read(filename)
        thumb     = image.first.resize_to_fill(config['thumb_pixels']).write(filethumb)

        bucket.files.create(:key => "#{File.basename(repo.dir.to_s)}/#{key_thumb}", :body => File.read(filethumb), :public => true, :content_type => 'image/jpeg').save
      end
    end

    desc "enable", "enable uploder in post-commit"
    def enable
      repo = Git.open('.')
      append_file "#{repo.dir.to_s}/.git/hooks/post-commit", "lolcommits-uploader upload &> /dev/null &"
    end

    desc "disable", "disable uploader in post-commit"
    def disable
      repo = Git.open('.')
      gsub_file "#{repo.dir.to_s}/.git/hooks/post-commit", "lolcommits-uploader upload &> /dev/null &", ""
    end
  end
end
