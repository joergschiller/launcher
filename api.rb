require "cuba"
require "./launcher"

class API < Cuba

  @@launcher = Launcher.new

  def self.launcher
    @@launcher
  end

end

API.define do

  on root do
    res.write "Connected to #{API.launcher.launcher.product} by #{API.launcher.launcher.manufacturer}"
  end

  on "execute" do
    on post do
      on param("command") do |command|
        if Launcher::COMMANDS.include? command.to_sym
          API.launcher.send command.to_sym
        end
      end
    end
  end

end

Cuba.define do
  run API
end
