# Mark This Up

*Mark This Up* is a simple git powered blogging platform. I say git powered, it's just a flatfile blogging platform written in Ruby, using Sinatra. It's aimed to be used with Heroku or another service like that. The code may be a bit shabby. Feel free to fork and contribute :)

## Running the app

First you need to edit the SETUP constant in app.rb:

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

Then all you need to do is run this from the project's directory.

	$ bundle install
	$ foreman start