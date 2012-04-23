# Sinatra
require 'sinatra'
require 'sinatra/partial'
require 'sinatra/reloader'

# Templating
require 'haml'
require 'yaml'
require 'rdiscount'

# Set public and view directory
set :public_folder, settings.root + '/assets'
set :views, settings.root + '/views'

helpers do
	# Get Site information
	def get_info
		@info = File.open("setup.yaml") { |f| YAML.load(f) }
	end

	# Get All The Articles
	def get_articles
		# Setup a blank array
		@articles = []

		# Read all files in articles directory
		Dir.glob("articles/*") do |folder|
			# Open and read our YAML file
			meta = File.open("#{folder}/meta.yaml") { |f| YAML.load(f) }

			# Read our markdown content
			markdown = File.read("#{folder}/index.md")

			# Setup the article object
			article = {
				title: meta['title'],
				slug: folder.split('/')[1],
				date: meta['date'],
				tags: meta['tags'],
				content: markdown
			}

			# Push the article to @articles array
			@articles << article
		end
	end
end

# Index Page
get '/?' do
	get_articles
	# Render HAML Template
	haml :articles_index
end


# Individual Article
get '/post/:slug' do
	file = File.read("articles/#{params[:slug]}/index.md").split("---\n")

	# Load the articles meta
	meta = YAML.load(file[1])

	# Load the articles content
	markdown = file[2]

	# Create the article object
	@article = {
		title: meta['title'],
		slug: params[:slug],
		date: meta['date'],
		tags: meta['tags'],
		content: markdown
	}

	# Render HAML Template
	haml :single_article
end

# RSS Route
get '/rss' do
    content_type 'application/rss+xml'
    get_articles; get_info
    haml :rss, :format => :xhtml, :escape_html => true, :layout => false
end