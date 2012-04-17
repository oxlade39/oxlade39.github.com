## Strip the leading tab from the text
## Used to include .md from another file
## http://stackoverflow.com/questions/8772404/jekyll-not-interpreting-markdown
## 
module Jekyll
  module UnindentFilter
    def unindent input
      input.lstrip
    end
  end
end

Liquid::Template.register_filter Jekyll::UnindentFilter