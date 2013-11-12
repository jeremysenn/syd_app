# -*- coding: utf-8 -*-
$:.unshift("/Library/RubyMotion2.7/lib")
require 'motion/project/template/ios'
require "rubygems"
require 'bundler'
#Bundler.require

begin
  require 'bundler'
  Bundler.require
  require 'formotion'
rescue LoadError
end

Motion::Project::App.setup do |app|
  # Use `rake config' to see complete project settings.
  app.name = 'SYD'
  app.icons << 'SYD_57_57.png'

  app.pods do
    pod 'AFNetworking'
    pod 'SVProgressHUD'
  end
end
