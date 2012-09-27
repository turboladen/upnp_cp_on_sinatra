require 'sinatra/base'

class UPnPControlPoint < Sinatra::Base
  configure do
    set :public_folder, Proc.new { File.join(root, "static") }
  end

  get '/' do
    @devices = env['upnp.devices']
    @friendly_names = @devices.map(&:friendly_name)
    haml :index
  end

  get '/:usn' do
    @device = env['upnp.devices'].find { |d| d.usn == params[:usn] }
    puts "found device: #{@device}"
    haml :device
  end
end
