###
# Blog settings
###

Time.zone = "UTC"

activate :blog do |blog|
  blog.permalink = "{year}/{category}/{title}.html"

  blog.tag_template = "tag.html"
  blog.calendar_template = "calendar.html"

  # Enable pagination
  blog.paginate = true
  blog.per_page = 10
  blog.page_link = "page/{num}"

  # Create Category Archive pages
  blog.custom_collections = {
    category: {
      link: '/categories/{category}.html',
      template: '/category.html'
    }
  }
end

page "/feed.xml", layout: false

###
# Build up Category listing data
###
ready do
  @category_list = []
  sitemap.resources.group_by {|p| p.data["category"] }.each do |category, pages|
    @category_list << { :category => category, :pages => pages }
  end

  archive_resources = []
  blog.articles.group_by {|a| a.date.year }.each do |year, year_articles|
    archive_resources << {:year => year, :articles => year_articles}
  end
  proxy "/archives.html", "archive.html", locals: { archives: archive_resources }
end

###
# Compass
###

# Change Compass configuration
# compass_config do |config|
#   config.output_style = :compact
# end

###
# Page options, layouts, aliases and proxies
###

# Per-page layout changes:
#
# With no layout
# page "/path/to/file.html", layout: false
#
# With alternative layout
# page "/path/to/file.html", layout: :otherlayout
#
# A path which all have the same layout
# with_layout :admin do
#   page "/admin/*"
# end

# Proxy pages (http://middlemanapp.com/basics/dynamic-pages/)
# proxy "/this-page-has-no-template.html", "/template-file.html", locals: {
#  which_fake_page: "Rendering a fake page with a local variable" }

###
# Helpers
###

# Directory indexes
activate :directory_indexes

# Automatic image dimensions on image_tag helper
activate :automatic_image_sizes

# Reload the browser automatically whenever files change
# activate :livereload

# Methods defined in the helpers block are available in templates
# helpers do
#   def some_helper
#     "Helping"
#   end
# end

set :css_dir, 'stylesheets'

set :js_dir, 'javascripts'

set :images_dir, 'images'

configure :development do
  activate :livereload
end

# Build-specific configuration
configure :build do
  # For example, change the Compass output style for deployment
  activate :minify_css

  # Minify Javascript on build
  # activate :minify_javascript

  # Enable cache buster
  # activate :asset_hash

  # Use relative URLs
  # activate :relative_assets

  # Or use a different image path
  # set :http_prefix, "/Content/images/"
end

###
# Git deploy
###
activate :deploy do |deploy|
  deploy.build_before = true # default: false
  deploy.method = :git
  # Optional Settings
  # deploy.remote   = "custom-remote" # remote name or git url, default: origin
  # deploy.branch   = "custom-branch" # default: gh-pages
  # deploy.strategy = :submodule      # commit strategy: can be :force_push or :submodule, default: :force_push
end

###
# Custom Helpers
###
helpers do
  def home_meta(article)
    text = <<OUT

OUT
    ERB.new(text).result()
  end
end