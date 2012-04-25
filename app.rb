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

# We want this to be super simple, even if it
# could technically be done better.
CONFIG = {

	# All your general site information
	:site_info => {
		:title        => "I Love Monsters",
		:url          => "http://blooming-leaf-7938.herokuapp.com",
		:description  => "This is the description about your site. It's awesome right?",
		:keywords     => ["something", "something else", "blog", "yeah", "like", "tags"]
	}

	# All your author information
}

helpers do

	# Get Site title
	def site_title
		return CONFIG[:site_info][:title]
	end

	# Get Site URL
	def site_url
		return CONFIG[:site_info][:url]
	end

	# Get Site description
	def site_description
		return CONFIG[:site_info][:description]
	end

	# Get author info
	def get_author

	end

	# Get All The Articles
	def get_articles
		# Setup a blank array
		@articles = []

		# Read all files in articles directory
		Dir.glob("articles/*") do |folder|
			file = File.read("#{folder}/index.md").split("---\n")

			# Load the articles meta
			meta = YAML.load(file[1])

			# Load the articles content
			markdown = file[2]

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

# Static Information page
get '/information/?' do
	haml :information
end

# RSS Route
get '/rss' do
    content_type 'application/rss+xml'
    get_articles; get_info
    haml :rss, :format => :xhtml, :escape_html => true, :layout => false
end