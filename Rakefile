# -*- coding: utf-8 -*-
$:.unshift("/Library/RubyMotion/lib")
require 'motion/project/template/ios'
require "rubygems"


begin
  require 'bundler'
  Bundler.setup
  Bundler.require
  require 'formotion'
  require 'sugarcube-image'
  require 'sugarcube-factories'
rescue LoadError
end

Motion::Project::App.setup do |app|
  # Use `rake config' to see complete project settings.
  app.name = 'SYD'
  app.icons << 'SYD_57_57.png'
#  app.identifier = 'set-yours-to-run-on-device'

  #ZBar Needs These
  app.frameworks += ['AVFoundation', 'CoreMedia', 'CoreVideo', 'QuartzCore']
  app.libs += ['/usr/lib/libiconv.dylib']
  app.vendor_project('vendor/ZBarSDK', :static, :headers_dir => 'Headers')

  app.pods do
    pod 'AFNetworking' # Connect to server
    pod 'SVProgressHUD' # Spinning wheel icon
#    pod 'ZBarSDK' # Barcode scanning
  end

  app.development do
#    app.entitlements['get-task-allow'] = true
#    app.codesign_certificate = "" # The name of your certificate in the keychain
#    app.provisioning_profile = "" # The location of your development .mobileprovision file

    app.release do
     app.entitlements['get-task-allow'] = true
     app.codesign_certificate = "iPhone Distribution: Paul Colby (KSYZ5TY2K6)" # The name of your certificate in the keychain
     app.provisioning_profile = "/Users/paulcolby/Library/MobileDevice/Provisioning\ Profiles/48F7EC92-3473-4D3A-9599-0869A77CBD34.mobileprovision" # The location of your development .mobileprovision file
    end
  end
end