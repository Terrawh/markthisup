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

# Index Page
get '/' do
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

	# Render HAML Template
	haml :index
end


# Individual Article
get '/:slug' do
	# Load the articles meta
	meta = File.open("articles/#{params[:slug]}/meta.yaml") { |f| YAML.load(f) }

	# Load the articles content
	markdown = File.read("articles/#{params[:slug]}/index.md")

	# Create the article object
	@article = {
		title: meta['title'],
		slug: params[:slug],
		date: meta['date'],
		tags: meta['tags'],
		content: markdown
	}

	# Render HAML Template
	haml :article
end