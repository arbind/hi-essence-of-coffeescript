express = require 'express'
logfmt  = require("logfmt");

allowCORS = (req, res, next)-> 
  res.header('Access-Control-Allow-Origin', '*'); next()

app   = express()
port  = process.env.PORT || 5000

app.use allowCORS
app.use logfmt.requestLogger()
app.use express.static "#{__dirname}/public"

app.listen port, -> console.log "Listening on " + port
