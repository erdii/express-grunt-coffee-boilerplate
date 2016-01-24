class Base
	constructor: () ->
		@pkg = require "../../package.json"
		@config = require( "./config" )

		if @config.get( "log" ).enabled
			@log = require( "debug" )( @pkg.name + ":" + @constructor.name )
		else
			@log = () ->
				return
		return

module.exports = Base
