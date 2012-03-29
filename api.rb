require "cuba"
require "cuba/render"
require "./launcher"

class API < Cuba

  class MockedLauncher
    def method_missing(method, *args, &block) end
    def to_s; "Mock'ed launcher" end
  end

  def self.launcher
    @@launcher ||= Launcher.new rescue nil
    @@launcher || MockedLauncher.new
  end

end

API.define do

  on root do
    res.write "Connected to #{API.launcher}."
  end

  on post do
    on ":command" do |command|
      if Launcher::COMMANDS.include? command.to_sym
        API.launcher.send command.to_sym, req["duration"]
      end
    end
  end

end

Cuba.plugin Cuba::Render
Cuba.define { run API }
