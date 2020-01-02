Gem::Specification.new do |s|
  s.name        = 'jekyll-mail-comments'
  s.version     = '0.0.2'
  s.date        = '2022-01-01'
  s.summary     = "Email based comment system for Jekyll static site generator"
  s.description = <<DESC 
Provides html generator of threaded comments pages fetched from an IMAP for Jekyll
DESC
  s.authors     = "Dmitry Rodichev"
  s.email       = 'noroot@falsetrue.io'
  s.files = `git ls-files`.split($/)
  s.executables   = s.files.grep(%r{^bin/}).map{ |f| File.basename(f) }
  s.test_files = s.files.grep(%r{^(test|spec|features)/})

  s.add_dependency 'jekyll'
  s.homepage    = 'https://github.com/noroot/jekyll-mail-comments'
  s.license       = 'GPL-3.0'
  s.post_install_message = <<MSG
Don't forget to put credentials inside .env file, see .env.dist inside gem source.
MSG
end
