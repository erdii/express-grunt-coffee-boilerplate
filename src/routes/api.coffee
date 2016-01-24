class API extends require "../lib/base"
	constructor: ( app, basepath ) ->
		super

		# map routes
		app.get "#{basepath}/example", @example

		@log "info", "#{@constructor.name} loaded."
		return


	example: ( req, res ) ->
		res.send(
			timestamp: Date.now()
		)
		return

module.exports = () -> new API( arguments... )
