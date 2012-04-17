# 
# http://www.somic.org/2011/03/04/how-i-organize-posts-in-jekyll/
# 
# {% for category in site.sorted_categories %}
# here is a category name - {{ category | first }}
# here is the number of posts in this category - {{ category | last | size }}
# {% for post in category.last %}
# posts in this category - {{ post.url }} {{ post.date | date_to_string }}
# {% endfor %}
# {% endfor %}
# 
# 
module Jekyll
  class SortedCategoriesBuilder < Generator
  
    safe true
    priority :high

    def generate(site)
      site.config['sorted_categories'] = site.categories.map { |cat, posts|
        [ cat, posts.size, posts ] }.sort { |a,b| b[1] <=> a[1] }
    end

  end
end