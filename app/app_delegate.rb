class AppDelegate < PM::Delegate
  status_bar true, animation: :none

  def on_load(app, options)

#    AFMotion::Client.build_shared("#{NSUserDefaults.standardUserDefaults[:server]}/image_datas/") do
#      operation :json
#      header "Accept", "application/json"
#    end

#    open HomeScreen.new(nav_bar: true)
    open_tab_bar SearchScreen.new(nav_bar: true), SettingsScreen.new(nav_bar: true), HelpScreen.new(nav_bar: true)
  end
  
end
