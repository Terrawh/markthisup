# Sinatra
require 'sinatra'
require 'sinatra/partial'
require 'sinatra/reloader'

# Templating
require 'haml'
require 'json'
require 'yaml'
require 'rdiscount'

# Configuration
# This is run once at startup, Creating our SETUP
# Constant, that contains a list of our articles.
#
configure do
	# Set public and view directory
	set :public_folder, settings.root + '/assets'
	set :views, settings.root + '/views'

	# We want this to be super simple, even if it
	# could technically be done better.
	SETUP = {
		# All your general site information
		:site_info => {
			:title        => "I Love Monsters",
			:url          => "http://blooming-leaf-7938.herokuapp.com",
			:description  => "This is the description about your site. It's awesome right?",
			:keywords     => ["something", "something else", "blog", "yeah", "like", "tags"]
		},

		# All your author information
		:author_info  => {
			:name     => "Thomas Bates",

			# External Links
			# Req: Service title, your username and the service URL.
			:external_links => [
				{
					:service  => "Twitter",
					:username => "yoamomonstruos",
					:service_url => "http://twitter.com"
				},
				{
					:service  => "Github",
					:username => "yoamomonstruos",
					:service_url => "http://github.com"
				},
				{
					:service  => "Dribbble",
					:username => "yoamomonstruos",
					:service_url => "http://dribbble.com"
				}
			]
		},

		# Store our articles dynamically sorta.
		:articles => []
	}

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
			tags: meta['tags']
		}


		# Push the article to @articles array
		SETUP[:articles] << article
	end
end

helpers do
	# Get Site title
	def site_title
		SETUP[:site_info][:title]
	end

	# Get Site URL
	def site_url
		SETUP[:site_info][:url]
	end

	# Get Site description
	def site_description
		SETUP[:site_info][:description]
	end

	# Get author info
	def author_name
		SETUP[:author_info][:name]
	end

	# External Links
	def external_links
		SETUP[:author_info][:external_links]
	end

	# Get Articles
	def get_articles
		@articles = SETUP[:articles]
	end
end

# Index Page
get '/?' do
	# Grab all the articles
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
    "RSS WILL GO HERE"
end