convict = require "convict"

convict.addFormat(
	name: "bool"
	validate: () -> true
	coerce: ( val ) -> ( val )
)

conf = convict(
	env:
		doc: "The application environment.",
		format: [ "production", "development", "test" ]
		default: "development"
		env: "NODE_ENV"

	express:
		ip:
			doc: "The IP address to bind."
			format: "ipaddress"
			default: "127.0.0.1"
			env: "IP_ADDRESS"

		port:
			doc: "The port to bind."
			format: "port"
			default: 3000
			env: "PORT"

		logger:
			doc: "Morgan's log mode."
			format: [ "dev", "combined", "common", "short", "tiny" ]
			default: "dev"
			env: "MORGAN"

	log:
		enabled:
			doc: "enable log output."
			format: "bool"
			default: true
			env: "LOG_ENABLED"
)

# Load environment dependent configuration
env = conf.get "env"
confPath = "./config/#{env}.json"

try
	conf.loadFile confPath
catch err
	if err.code is "ENOENT"
		console.log "Could not read #{confPath}"
	else
		throw err

# Perform validation
conf.validate(
	strict: true
)

console.log "configuration", conf.toString()
module.exports = conf
