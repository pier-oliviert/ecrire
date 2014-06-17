# Ecrire

![The Editor](http://f.cl.ly/items/1u0r3g0E1r3x2z1g2G1P/Screen%20Shot%202014-06-16%20at%206.19.06%20PM.png)

Starting your own blog isn't an easy task. If you've ever started one, you know how hard it is to stay focused. With ecrire, you have all the tools you need to help you get started.

The interface is light and the editor is at the forefront. Because writing, that's what we do.

And it doesn't stop there. You have the ability to change personalize each and every post like you would for a web page. You can customize your page with custom Javascript and CSS. And to make your life even easier, those two are evaluated in **real time**.

Don't worry about saving your drafts, Ecrire does it for you every half a second. We're in 2014, after all.

Ecrire is built on top of Ruby on Rails, that means that every theme you build can be built with ruby helpers and decorators while having the power to write clean HTML. Your views can be neatly organized and clean.

Same goes for your CSS and Javascript files. Ecrire comes with SASS & Bourbon for the CSS interpreter. Coffeescript is also available for your javascript.

Go ahead, try it out!


### Getting started

First, you need to have ruby version **higher than** 2.0.0.

You can install the gem with rubygems.
``` gem install ecrire ```

Then create a new blog
``` ecrire new your_blog_name ```

It will create a new blog using the default template. Before starting up your server, you will need to run Bundler to install all the dependency your blog needs.
``` bundle install ```

You are ready to go. Ecrire will launch the onboarding process until you set up your database and you create a user.

``` bundle exec ecrire server  ```

You can access the blog & configuration setup with your browser by going at the following address.
``` http://localhost:3000  ```

### Licence

The MIT License (MIT)

Copyright (c) 2014 pothibo

Permission is hereby granted, free of charge, to any person obtaining a copy
of this software and associated documentation files (the "Software"), to deal
in the Software without restriction, including without limitation the rights
to use, copy, modify, merge, publish, distribute, sublicense, and/or sell
copies of the Software, and to permit persons to whom the Software is
furnished to do so, subject to the following conditions:

The above copyright notice and this permission notice shall be included in
all copies or substantial portions of the Software.

THE SOFTWARE IS PROVIDED "AS IS", WITHOUT WARRANTY OF ANY KIND, EXPRESS OR
IMPLIED, INCLUDING BUT NOT LIMITED TO THE WARRANTIES OF MERCHANTABILITY,
FITNESS FOR A PARTICULAR PURPOSE AND NONINFRINGEMENT. IN NO EVENT SHALL THE
AUTHORS OR COPYRIGHT HOLDERS BE LIABLE FOR ANY CLAIM, DAMAGES OR OTHER
LIABILITY, WHETHER IN AN ACTION OF CONTRACT, TORT OR OTHERWISE, ARISING FROM,
OUT OF OR IN CONNECTION WITH THE SOFTWARE OR THE USE OR OTHER DEALINGS IN
THE SOFTWARE.
