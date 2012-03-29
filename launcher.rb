require "usb"

# Usage example
#
#     launcher = Launcher.new
#     launcher.up # steps turret up, available commands are: up, down, left, right, stop, fire
#     launcher.up 500 # moves turret up for 500ms

class Launcher

  COMMANDS = { :up => "\x02\x02\x00\x00\x00\x00\x00\x00",
               :down => "\x02\x01\x00\x00\x00\x00\x00\x00",
               :left => "\x02\x04\x00\x00\x00\x00\x00\x00",
               :right => "\x02\b\x00\x00\x00\x00\x00\x00",
               :stop => "\x02 \x00\x00\x00\x00\x00\x00",
               :fire => "\x02\x10\x00\x00\x00\x00\x00\x00" }

  def initialize
    @launcher = USB.devices.select { |d| d.idVendor == 0x2123 && d.idProduct == 0x1010 }.first

    raise "No missile launcher found." unless @launcher

    @launcher.open do |h|
      begin
        h.usb_detach_kernel_driver_np 0, 0
      rescue Errno::ENODATA => e
      end
    end
  end

  def fire
    execute :fire
  end

  def method_missing(command, *args)
    if COMMANDS.keys.include? command
      duration = args.first || 25

      execute command
      sleep duration * 0.001
      execute :stop
    end
  end

  def to_s
    [@launcher.product, @launcher.manufacturer].join " by "
  end

  private

    def execute(command)
      @launcher.open { |h| h.usb_control_msg 0x21, 0x09, 0, 0, COMMANDS[command], 0 }
    end

end
