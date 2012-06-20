module Lolcommits
  class Uploader < Thor 
    include Thor::Actions

    desc "upload", "upload the last commit photo"
    def upload
      upload_file repo.log.first.sha[0..10]
    end

    desc "upload_all", "upload all commits photos"
    def upload_all
      Dir[File.expand_path("~/.lolcommits/#{repo_name}/*.jpg")].each do |filename|
        match = filename.match(/\/([0-9a-f]+)\.jpg$/)
        next unless match && !uploaded?(match[1])
        upload_file match[1]
      end
    end

    desc "enable", "enable uploder in post-commit"
    def enable
      append_file "#{repo.dir.to_s}/.git/hooks/post-commit", "lolcommits-uploader upload &> /dev/null &"
    end

    desc "disable", "disable uploader in post-commit"
    def disable
      gsub_file "#{repo.dir.to_s}/.git/hooks/post-commit", "lolcommits-uploader upload &> /dev/null &", ""
    end
    
    private
    
    def uploaded?(sha)
      bucket.files.head("#{repo_name}/#{sha}.jpg")
    end
    
    def config
      @config ||= YAML::load(File.read(File.expand_path('~/.s3-uploader.yaml')))
    end
    
    def connection
      @connection ||= Fog::Storage.new({
        :provider              => 'AWS',
        :aws_access_key_id     => config['aws_access_key_id'],
        :aws_secret_access_key => config['aws_secret_access_key'],
        :region => config['region']
      })
    end
    
    def bucket
      @bucket ||= connection.directories.get(config['aws_bucket_name'])
    end
    
    def repo
      @repo ||= Git.open('.')
    end
    
    def repo_name
      File.basename(repo.dir.to_s)
    end
    
    def upload_file(sha)
      key       = "#{sha}.jpg"
      key_thumb = "#{sha}_thumb.jpg"

      filename  = File.join(File.expand_path('~/.lolcommits'), repo_name, key)
      bucket.files.create(:key => "#{repo_name}/#{key}", :body => File.read(filename), :public => true, :content_type => 'image/jpeg').save
      
      if config['thumb_enable']
        filethumb = File.join(File.expand_path('~/.lolcommits'), repo_name, key_thumb)
        image     = Magick::Image.read(filename)
        thumb     = image.first.resize_to_fill(config['thumb_pixels']).write(filethumb)

        bucket.files.create(:key => "#{repo_name}/#{key_thumb}", :body => File.read(filethumb), :public => true, :content_type => 'image/jpeg').save
      end
    end
  end
end
