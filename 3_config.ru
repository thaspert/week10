# Run this file with:
# rackup 3_config.ru

class MyApp

  def call(env)
    [ '200',
      {'Content-Type' => 'text/html'},
      ["Let's Go Hawks!"]
    ]
  end

end

run MyApp.new

# Next steps:
# \> Use another Rack app to add a Content-Length header
# \> Use another Rack app to add a Logger
# \> Use another Rack app to add an HTML footer
