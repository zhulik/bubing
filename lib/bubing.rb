require 'fileutils'
load 'lib/bubing/bundler.rb'

module Bubing
  def self.bundle!(binary, directory, **args)
    Bubing::Bundler.new(binary, directory, **args).bundle!
  end
end