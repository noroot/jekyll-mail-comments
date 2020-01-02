require 'net/imap'
require 'mail'
require 'fileutils'
require "base64"
require 'yaml'
require 'digest'


module MailComments

  class Configuration
    attr_accessor :login
    attr_accessor :password
    attr_accessor :host
    attr_accessor :port
    attr_accessor :subject_suffix

    def initialize
      @login = ENV.fetch('MC_LOGIN', '')
      @password = ENV.fetch('MC_PASSWORD', '')
      @host = ENV.fetch('MC_HOST', '')
      @port = ENV.fetch('MC_PORT', '')
      @subject_suffix = ENV.fetch('MC_SUBJECT_SUFFIX', '')     
    end
  end


  class << self
    attr_writer :configuration
  end

  def self.configuration
    @configuration ||= Configuration.new
  end

  def self.configure
    yield(configuration)
  end

  def self.fetch
    
    login = MailComments.configuration.login 
    password = MailComments.configuration.password 
    host = MailComments.configuration.host 
    port = MailComments.configuration.port 
    subject_suffix = MailComments.configuration.subject_suffix

    imap = Net::IMAP.new(host, 993, true)
    imap.login(login, password)
    imap.select("INBOX")
    cx = imap.search(["SUBJECT", subject_suffix, "UNSEEN"])
    if !cx.nil? && cx.length > 0
      puts "Comments found CX=#{cx.length}"
      comments = {}
      cx.each do |message_id| 
        msg = imap.fetch(message_id,'RFC822')[0].attr['RFC822']    
        mail = Mail.read_from_string(msg)
        if mail.multipart?
          body = mail.multipart?? mail.text_part.body.decoded : mail.html_part.body.decoded
        else
          body = mail.body.decoded
        end
        
        author = mail.header['From'].field.addrs.first.display_name    

        begin
          tmp = mail.subject.split(":")
          if tmp.length == 4
            reply_id = mail.subject.split(":")[1].strip()
            post_title = mail.subject.split(":")[3].strip()
            
            message_id = Digest::SHA1.hexdigest(mail['Message-ID'].value)
            comment = {
              title: post_title,
              reply_to: reply_id,
              id:  message_id,
              author: author,
              from: mail.from.first,
              date: mail.date,        
              text: body
            }
            file_name = "#{mail.date.strftime("%s").to_s}-#{message_id}.yaml"
            File.open("_data/comments/#{file_name}", "w") do |f|
              f.write(comment.transform_keys(&:to_s).to_yaml)
            end
            puts "Comment from #{comment[:author]} - <#{comment[:from]}> on \"#{comment[:title]}\" at #{comment[:date]}"
          else
            puts "Wrong subject for #{msg}"
          end

        rescue => e
          puts e
        end
      end
    else
      puts "No messages found."
    end

  end
end
