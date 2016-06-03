# Run this file with:
# ruby 2_rack_server.rb

require 'rack'

class MyController

  def call(env)
    [ '200',
      {'Content-Type' => 'text/html'},
      ["Hello World!"]
    ]
  end

end

Rack::Handler::WEBrick.run MyController.new


# Next steps:
#
# |> Content-Length header
# |> Echo env contents
# |> Return different HTML strings based on request path
# |> Return 404 if path not recognized
# |> Support image files
# |> Render file contents instead of hardcoded html
# |> Support ERB templates
