require 'upnp/control_point'
require './upnp_control_point'

module Rack
  class UPnPControlPoint
    def initialize(app)
      @app = app
      @devices = []
      EM.next_tick { yield @devices if block_given? }
    end

    def call(env)
      env['upnp.devices'] = @devices
      @app.call(env)
    end
  end
end

#UPnP::ControlPoint.config { |c| c.raise_on_remote_errors = false }

use Rack::UPnPControlPoint do |devices|
  @cp = UPnP::ControlPoint.new :root

  @cp.start do |new_device_queue, old_device_queue|
    new_device_queue.pop { |new_device| devices << new_device }

    old_device_queue.pop do |old_device|
      devices.reject! { |d| d.usn == old_device[:usn] }
    end
  end
end

run UPnPControlPoint


