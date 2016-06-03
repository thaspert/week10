## Run this file with:
# ruby 2a_rack_server_complete.rb

require 'rack'
require 'erb'

class MyController

  def index
    render 'index.html'
  end

  def show
    render 'show.html.erb'
  end

  def render(filename)
    content_type = (filename =~ /jpg$/ ? 'image/jpeg' : 'text/html')
    content = ERB.new(File.read("website/#{filename}")).result(binding)
    ['200', {'Content-Type' => content_type}, [content]]
  end

  def call(env)
    if env['PATH_INFO'] == '/apollo13.jpg'
      data = IO.read('website/apollo13.jpg')
      ['200', {'Content-Type' => 'image/jpeg', 'Content-Length' => data.length.to_s}, [data]]
    elsif env['PATH_INFO'] == '/'
      index
    elsif env['PATH_INFO'] == '/index.html'
      index
    elsif env['PATH_INFO'] == '/index'
      index
    elsif env['PATH_INFO'] == '/movies'
      index
    elsif env['PATH_INFO'] == '/movies/1'
      @title = "Apollo 13"
      @img = "/apollo13.jpg"
      show
    elsif env['PATH_INFO'] == '/movies/2'
      @title = "Raiders of the Lost Ark"
      @img = "/raiders.jpg"
      show
    else
      ['404', {}, [] ]
    end
  end
end

Rack::Handler::WEBrick.run MyController.new, Port: 2345
