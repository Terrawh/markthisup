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
	# Grab all articles
	def all_articles
		# Setup a blank array
		articles = []

		# Read all files in articles directory
		Dir.glob("articles/*") do |folder|
			meta = File.open(folder + '/meta.yaml') { |f| YAML.load(f) }
			markdown = File.read(folder + '/index.md')
			article = {
				title: meta['title'],
				slug: folder.split('/')[1],
				date: meta['date'],
				tags: meta['tags'],
				content: markdown
			}
			articles << article
		end

		# Return Articles
		return articles
	end
end

get '/' do
	@articles = all_articles
	haml :index
end

get '/:slug' do
	# Load the articles meta
	meta = File.open("articles/" + params[:slug] + '/meta.yaml') { |f| YAML.load(f) }

	# Load the articles content
	markdown = File.read("articles/" + params[:slug] + '/index.md')

	# Create the article object
	@article = {
		title: meta['title'],
		slug: params[:slug],
		date: meta['date'],
		tags: meta['tags'],
		content: markdown
	}

	haml :article
end