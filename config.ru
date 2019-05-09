# Ensure both stdout and stderr will write synchronously.
STDOUT.sync = STDERR.sync = true

require './app'

run Rack::Cascade.new [API]
