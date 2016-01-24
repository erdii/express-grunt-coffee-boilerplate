# npm module imports
bodyParser = require "body-parser"
express = require "express"
morgan = require "morgan"
walker = require "folder-walker"

# internal module imports
path = require "path"
utils = require "./lib/utils"

# load package.json
pkg = require( "../package.json" )

class Index extends require "./lib/base"
	constructor: () ->
		super

		@xconf = @config.get("express")

		# create express app
		@app = express()

		# configure express
		@configureExpress()
		# middlewares
		@loadMiddlewares()
		# ping for monitoring
		@loadPingRoute()
		# start the server
		@startSever()
		return


	configureExpress: () =>
		@app.set "title", pkg.name
		@app.enable "trust proxy"
		@app.disable "x-powered-by"
		return


	loadMiddlewares: () =>
		@app.use bodyParser.json()
		@app.use morgan( @xconf.logger )
		return


	loadPingRoute: () =>
		@app.get "/ping", ( req, res ) ->
			res.send(
				timestamp: Date.now()
			)
			return
		return


	loadRoutes: () =>
		# scan all routes and load them
		routeStream = walker path.join( __dirname, "./routes" )

		routeStream.on "data", ( data ) ->
			ext = path.extname( data.filepath )

			if path.extname( data.filepath ) is ".js"
				basename = path.basename( data.filepath, ext )
				return if basename is "ping" # because "/ping" is already used

				# import the route and mount it
				require( data.filepath )( @app, "/" + basename )
			return
		return


	startSever: () =>
		# start the server
		@app.listen @xconf.port, () =>
			@log "#{pkg.name} listening on port #{@xconf.port}."
			return
		return

# kick it off!
new Index()
