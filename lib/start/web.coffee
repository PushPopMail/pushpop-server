#includes
path = require('path')
express = require('express')
consolidate = require('consolidate')
fs = require('fs')

#web port
port = process.env.PORT || 5000


startApis = (err, results) ->
	if err
		throw "Failed to start: #{err}"

	for k,v of results
		console.log "web: #{k}: #{JSON.stringify(v)}"

	app = express()
		.engine('html', consolidate.handlebars)
		.set('views', 'website/view')
		.set('view engine', 'html')
		.use(express.favicon())
		.use(express.logger())
    	.use(express.json())
    	.use(express.urlencoded())
		.use(express.compress())

	#Api initialization
	fs.readdir './lib/api', (err, files) ->
		for file in files
			api = file.split('.')
			if ! api || ! api[0]
				continue
			if ! situation.isDevelopment() && api[0] == 'test'
				continue
			require("../api/#{api[0]}").init(app)

	app.use(express.static(path.join(__dirname, '../../website/public')))

	app.listen port, ->
		console.log("Listening on #{port}")

startApis()
