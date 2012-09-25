require 'sinatra/base'
require 'sinatra/async'

class UPnPControlPoint < Sinatra::Base
  register Sinatra::Async

  configure do
    set :public_folder, Proc.new { File.join(root, "static") }
  end

  get '/' do
    @devices = env['upnp.devices']
    @friendly_names = @devices.map(&:friendly_name)
    erb :index
  end
end
