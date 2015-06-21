require 'ecrire/markdown'

require 'minitest/autorun'

class MarkdownTest < Minitest::Test

  def test_paragraph
    document = Ecrire::Markdown.parse("Hello world!\nThis is nice.")
    assert_equal '<p>Hello world!</p><p>This is nice.</p>', document.to_html
  end

  def test_header
    document = Ecrire::Markdown.parse('# test')
    assert_equal  "<h1>test</h1>", document.to_html

    document = Ecrire::Markdown.parse('## test and *some*')
    assert_equal  "<h2>test and <em>some</em></h2>", document.to_html
  end

  def test_italic
    document = Ecrire::Markdown.parse('*test*')
    assert_equal  "<p><em>test</em></p>", document.to_html
  end

  def test_bold
    document = Ecrire::Markdown.parse('**test**')
    assert_equal  "<p><strong>test</strong></p>", document.to_html
  end

  def test_bold_and_italic
    document = Ecrire::Markdown.parse('***bold and italic***')
    assert_equal  "<p><em><strong>bold and italic</strong></em></p>", document.to_html

    document = Ecrire::Markdown.parse('**bold** and *italic*')
    assert_equal  "<p><strong>bold</strong> and <em>italic</em></p>", document.to_html
  end

  def test_code_inline
    document = Ecrire::Markdown.parse("This is a ~~~ruby inline code~~~ snippet")
    assert_equal  "<p>This is a <code class='language-ruby'>inline code</code> snippet</p>", document.to_html

    document = Ecrire::Markdown.parse("This is a ~~~ruby inline code~~~ snippet. Multiple ~~~ruby instance~~~ can coexist on the same line")
    assert_equal  "<p>This is a <code class='language-ruby'>inline code</code> snippet. Multiple <code class='language-ruby'>instance</code> can coexist on the same line</p>", document.to_html
  end

  def test_code_blocks
    document = Ecrire::Markdown.parse("~~~ruby\n# A comment\nRails.application\n~~~")
    assert_equal  "<pre><header></header><code class='language-ruby'># A comment\nRails.application</code></pre>", document.to_html

    document = Ecrire::Markdown.parse("~~~ruby a title\n# A comment\nRails.application\n~~~")
    assert_equal  "<pre><header>a title</header><code class='language-ruby'># A comment\nRails.application</code></pre>", document.to_html
  end

  def test_unordered_list
    document = Ecrire::Markdown.parse("- ruby\n- Go")
    assert_equal '<ul><li>ruby</li><li>Go</li></ul>', document.to_html
  end

  def test_ordered_list
    document = Ecrire::Markdown.parse("1. Ruby\n2. **Go**")
    assert_equal '<ol><li>Ruby</li><li><strong>Go</strong></li></ol>', document.to_html
  end

  def test_lists
    document = Ecrire::Markdown.parse("1. Ruby\n2. **Go**\n- Test\n- 123")
    assert_equal '<ol><li>Ruby</li><li><strong>Go</strong></li></ol><ul><li>Test</li><li>123</li></ul>', document.to_html
  end

  def test_image
    document = Ecrire::Markdown.parse('![An Image](http://bla.com)')
    assert_equal "<figure><img src='http://bla.com' /><figcaption>An Image</figcaption></figure>", document.to_html
  end

  def test_link
    document = Ecrire::Markdown.parse('[A link](http://bla.com)')
    assert_equal "<p><a href='http://bla.com'>A link</a></p>", document.to_html
  end
end
