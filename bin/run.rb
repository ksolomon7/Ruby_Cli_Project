require_relative '../config/environment'
require_relative '../app/models/YourEvents.rb'

app = YourEvents.new()
app.run
