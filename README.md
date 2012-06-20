# Lolcommits-uploader

Upload your photos to S3

## Installation

Add this line to your application's Gemfile:

    gem 'lolcommits-uploader'

And then execute:

    $ bundle

Or install it yourself as:

    $ gem install lolcommits-uploader

## Configuration

Put in your $HOME/.s3-uploader.yaml with the following:

```yaml
aws_access_key_id: WADUSKEY
aws_secret_access_key:  WADUSACCESS
aws_bucket_name: WADUSBUCKET
thumb_enable: true
thumb_pixels: 32
```

## Usage

```
Tasks:
  lolcommits-uploader disable      # disable uploader in post-commit
  lolcommits-uploader enable       # enable uploder in post-commit
  lolcommits-uploader upload       # upload the last commit photo
  lolcommits-uploader upload_all   # upload all commits photos
```

## Contributing

1. Fork it
2. Create your feature branch (`git checkout -b my-new-feature`)
3. Commit your changes (`git commit -am 'Added some feature'`)
4. Push to the branch (`git push origin my-new-feature`)
5. Create new Pull Request

## Copyright

Copyright (c) 2012 Raúl Naveiras. See LICENSE for further details.
