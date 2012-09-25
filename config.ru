require 'upnp/control_point'
require './upnp_control_point'
require 'rack/upnp_control_point'


#UPnP::ControlPoint.config { |c| c.raise_on_remote_errors = false }

use Rack::UPnPControlPoint, search_type: :root
run UPnPControlPoint
