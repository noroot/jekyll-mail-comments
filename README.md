# Jekyll Mail comments

This gem fetches email from your mailbox by filtering with specific suffix, it makes data files which you can use to generate Jekyll comments.

## How it works ? 

* You've to setup mailbox, on Jekyll pages you will have mailto link which opens native system mail client with pre filled subject. 
* Person who wants to comment message write message to your specific email address. 
* Fetch program watch for special subject suffix to distinct comments from other emails
* Fetch program generate json based data files which perfectly fits to Jekyll data system https://jekyllrb.com/docs/datafiles/


## What is the purpose ?

* Jekyll static site generator has no comments system
* Don't want to inject 3rdparty javascript code to work with SaSS comments system
* Any RDBS for static site generator is overhead


## How-to Setup

* Go to your jekyll site `cd ~/jekull_site`
* Install gem `gem install mail_comments`
* Setup credentials

There few credentials your have to setup before run:

** MC_LOGIN - Login to imap server
** MC_PASSWORD - Password for imap server
** MC_HOST - IMAP server hostname
** MC_PORT - IMAP server port 
** MC_SUBJECT_SUFFIX - Suffix to filter comments

* You have put this as environment variables `see .env.dist`
* `jekyll-mail-comments-fetch`
* After that you will get comments data files inside Jekyll data directory - **_data**

After that if new comments are present it will generate data files with comments which you can process with Jekyll with data tag.
See here. https://jekyllrb.com/docs/datafiles/ or below.

Here is how to you can include comments block into your Jekyll post template

```

	<section>
	    {% include comments-count.html replies_to=page.path %}
	    
	    {% if comment_count %}
	    <h2>Comments ({{- comment_count -}}) <small class="text-muted">Read carefuly </small> </h2>
	    {% include comments.html replies_to=page.path indent_class="ml-auto" title=page.title %}
	    {% else %}
	    <h2>No comments here yet <small class="text-muted">Write here gently</small></h2>
	    {% endif %}
	    <div class="mt-3"><a class="btn btn-outline-secondary btn-block" href="mailto:{{site.comments.email}}?subject=RE:{{page.path}}:{{site.comments.subject_suffix}}:{{post.title}}">Write a comment</a> </div>
	</section>
```
Templates can be found inside **templates** directory of this gem.


## Credits

Inspiration while searching for already existing gem for email comments

* https://stevescott.ca/2017-04-03-static-site-comments-via-email.html
* https://github.com/aioobe/dead-simple-jekyll-comments/


## Example

* https://blog.falsetrue.io
