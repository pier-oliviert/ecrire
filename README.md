# Ecrire
[![Build Status](https://travis-ci.org/pothibo/ecrire.svg?branch=master)](https://travis-ci.org/pothibo/ecrire)

Ecrire is a blog engine built for web professionals. Most best practices comes builtin for you to quickly create powerful websites.

## How does it work?
Essentially, Ecrire is a blog engine. It provides a powerful Markdown editor, tags support, drafts, permalinks, image uploads, and everything else you would need to create a website.

Ecrire is built around the concept of themes. When you create a project with Ecrire, you are actually creating a new theme for you to customize to your needs.

## How flexible is a theme?
You can do pretty much anything you want inside a theme. It is based on Rails::Engine, a foundation block of Ruby on Rails. You can add gems, routes, controllers, views, javascript files, anything.

By default, a theme has 3 type of routes: posts, tags and static. While the first two serve dynamic contents (posts and tags), the third one is a route that handles static pages. This is useful when you want to add an about/FAQ/Contact page that doesn't change much and you want to use normal HTML to render it instead of the Markdown Editor.

Views(HTML) uses by default ERB, a Ruby + HTML template to build dynamic pages. The default theme provides tons of example on how to use ERB to build pages with content written in Markdown.


## The editor

The editor uses Markdown as its syntax. The advantage is to format your text as you type. The syntax is easy to understand and is powerful enough to let you structure your text as you type so you can focus on the content.

Here's the different structures available to you in the editor:
- Headers
- Unordered list
- Ordered list
- Code with syntax highlighting
- Image with auto-upload to S3
- Links
- Bold and Italic words

You can learn more about the syntax on [Ecrire.io](http://ecrire.io/markdown)

## Get started
First, you need to install ecrire as a gem and then create a new theme.

~~~bash
$ gem install ecrire
$ ecrire new my.blog.com
$ cd my.blog.com/
$ ecrire server
~~~

Once the server is started, you can load your browser at **http://localhost:3000** to finish the configuration.

## Go live on Heroku

Once you're ready to go live, you can use Heroku to deploy your application in production:

~~~bash
$ heroku git:remote -a name-of-your-app-on-heroku
$ git push origin heroku
$ heroku run rake db:migrate
~~~

Your blog is now up and running on Heroku! But you need to create a user on Heroku for now, here's how you do it.

~~~ruby
$ heroku run ecrire console
irb(main)> user = User.new
irb(main)> user.email = "your@email.com"
irb(main)> user.password = "yourpassword"
irb(main)> user.save!
irb(main)> exit
~~~


