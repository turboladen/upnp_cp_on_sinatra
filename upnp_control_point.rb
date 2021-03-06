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
    haml :device
  end

  get '/:usn/:service_type/:action_name' do
    device = env['upnp.devices'].find { |d| d.usn == params[:usn] }
    if device && device.has_services?
      service = device.service_list.find { |s| s.service_type == params[:service_type] }
      result = service.send(params[:action_name], params[:in])

      body result.to_json
    else
      not_found
    end
  end
end
