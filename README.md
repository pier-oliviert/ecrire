You write code for a living and now, you feel like you could use a blog to share your experience with others. Most of us has been there.

Starting your own blog isn't easy. If you've ever started one, you know that. Not only does it require you to have something to write about, you also need to know how to write. Thinking vaguely is much easier than writing the same thing down as you need to structure your idea. Not easy!

You also want your blog to look like something that looks like you. Personality.

Because you write code for a living, you'd like to not waste too much time on your blog building everything from the ground up but you would also like to be able to change things, small HTML or CSS changes.

You might also want to show some code snippet that you've either created or found a useful use. Because you know how to code, you know how important code indentation and highlighting is. So you want that.

Ecrire is the blog engine that can do it for you.

![The Editor](https://raw2.github.com/pothibo/ecrire/gh-pages/images/editor.png)

The editor is split in two halves. The left is where you write your post. The right is where you see a live preview of what you are writing as well as some tools to help you build your post.

=== The editor

This is where you will spend most of your time. The editor is plain but powerful: it's just HTML. But why would you want HTML to be abstracted from you? You probably know HTML really well and there's nothing more flexible than that.

Above the editor, there's 3 links: Write, Stylesheet and Javascript. Write let's you write HTML while Stylesheet and Javascript let's you customize CSS and JS for this particular post. So if you want to float an image on a specific paragraph, you can. If you want to have a small button that toggles something special, you can too. You're a developer, I'm sure you'll have ideas of your own to leverage those, I sure did!

Preview and importers

By default, you have the live preview on the right side. It changes as you type HTML and CSS very useful to try many CSS configuration or when you move things around. HTML is flexible but it doesn't give you a sense of how it looks like. The preview does that for you, in real time.

There's two importers that you can use to help you write awesome post. Images and partials.

==== Images

![Image importer](https://raw2.github.com/pothibo/ecrire/gh-pages/images/images.png)

You see the dashed box there, it does what it says: It let's you upload images by dropping them from your desktop onto the dashed box. As simple as that.

Once your file is uploaded to S3, you don't need to know where your file is, you can drag the image onto the textarea and the HTML tag will be generated for you at the place you drop it. Look for yourself.

![How to import images](https://raw2.github.com/pothibo/ecrire/gh-pages/images/images.gif)

==== Partials

If you've ever done some web development, you must know what partials are. They are small HTML snippet that you reuse on different pages.

Partials can be created like post can. They have their own HTML, CSS and Javascript that can be inserted in any post you wish. If you want to write about different topic and you would like to have a form on only certain topics, it becomes easy to do with partials.

When you want to start using partials, it's as simple as working with images. You have a list of all your partials and you can drag and drop onto your textarea the partial you want, at the location you want in your text. Like the images, Ecrire will generate the HTML tag for you. And your partial will appear in your live preview like everything else.


=== Code highlighting

You're a developer and you want to show code. And you want it to look awesome.

Ecrire comes with <a href="http://prismjs.com/">prism.js</a>, a library that does code highlighting extremely well. It also supports a large array of languages and is very easy to extend to your own language if yours isn't supported.

Like everything else, code highlighting works out in the live preview as well. Line numbers and all!

=== Draft and publishing

Like any blog engine worth its pinch of salt, Ecrire saves as a draft by default so you can write your post as you wish. When you're ready, simply press the arrow on the left of **Save** and click the publish button!

=== Customize your blog

Customization is important and it shouldn't be hard to make minor changes to the look and feel of you blog. You should be able to infuse a dose of your personality without breaking a sweat. Ecrire was built using clean and modular HTML code so you can easily find your way around HTML, CSS and Javascript. Customize away!


=== Alpha!!!

This project is still in it's infancy and while everything you've read so far is working, there's still bugs, enhancements and features that are missing. Even though it's an alpha, this engine has been working flawlessly on <a href="http://pothibo.com">pothibo.com</a> for the last 2 months. So try it out, leave issues if you find any or even submit a PR, more the merrier!

=== Getting started

All the information you need to install this blog engine is found on the Wiki.

=== Licence

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
