# Ecrire

Ecrire is a blog built *on top* of Ruby on Rails. The goal of this blog engine is to make it **easy** to start a blog while keeping control over the content. You can see this as an alternative to WordPress.

## The editor
The editor was built around the Markdown syntax. The content change as you type to offer you a very good approximation of how your post will look like once publish.

Here's the available feature:
- Headers
- Unordered list
- Ordered list
- Code with syntax highlighting
- Image with auto-upload to S3
- Links
- Bold and Italic words

More feature will be implemented as the Editor mature.

## Theme
When you start a new blog with Ecrire, it will generate a folder for you. Everything in that folder is for you to modify. You won't break anything. It also features a few characteristic that you may recognize if you are a Rails developer.

- SASS
- Coffeescript
- Assets caching through Sprockets
- View using layouts, views and partials
- Controllers
- Helpers
- Static pages

When you install your theme, the documentation will be available direclty within your blog so you can go back to it when you need it.

## How to install

```bash
$ gem install ecrire
$ ecrire new my.blog.com
$ cd my.blog.com/
$ ecrire server
```

From there, you can access your new blog via the browser and start configuring your database.
