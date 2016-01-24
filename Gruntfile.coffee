module.exports = ( grunt ) ->
	grunt.initConfig
		pkg:   grunt.file.readJSON( 'package.json' )

		watch:
			gruntfile:
				files: [ "Gruntfile.coffee" ]
				options:
					reload: true

			app:
				files: [ "src/**/*.coffee" ]
				tasks: [ "newer:coffeelint:app", "newer:coffee:app" ]


		clean:
			app:
				src: ["app/*"]
			doc:
				src: ["doc/*"]


		coffee:
			app:
				expand: true
				cwd: "src/"
				src: ["**/*.coffee"]
				dest: "app/"
				ext: ".js"


		coffeelint:
			app: ["src/**/*.coffee"]
			options:
				configFile: "coffeelint.json"


		docker:
			app:
				src: [
					"src/**/*"
					"README.md"
				]
				options:
					out: "doc/"


	# Load npm modules
	grunt.loadNpmTasks( "grunt-coffeelint" )
	grunt.loadNpmTasks( "grunt-contrib-clean" )
	grunt.loadNpmTasks( "grunt-contrib-coffee" )
	grunt.loadNpmTasks( "grunt-contrib-watch" )
	grunt.loadNpmTasks( "grunt-docker" )
	grunt.loadNpmTasks( "grunt-mocha-cli" )
	grunt.loadNpmTasks( "grunt-newer" )

	# Custom tasks
	grunt.registerTask( "default", [ "build", "watch" ] )
	grunt.registerTask( "build", [ "clean", "coffeelint", "coffee", "docker" ] )
