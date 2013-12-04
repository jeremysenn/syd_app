class AppDelegate < PM::Delegate
  status_bar true, animation: :none

  def on_load(app, options)

#    AFMotion::Client.build_shared("#{NSUserDefaults.standardUserDefaults[:server]}/image_datas/") do
#      operation :json
#      header "Accept", "application/json"
#    end

    ### Set Demo Defaults ###
    @defaults = NSUserDefaults.standardUserDefaults
    if @defaults[:server].nil?
      @defaults[:server] = "https://www.scrapyarddog.com"
    end
    if @defaults[:email].nil?
      @defaults[:email] = "demo@tranact.com"
    end
    if @defaults[:password].nil?
      @defaults[:password] = "demouser"
    end

    search_screen = SearchScreen.new(nav_bar: true)
    search_screen.set_tab_bar_item title: "Search", icon: "icons/search-25.png"
    
    settings_screen = SettingsScreen.new(nav_bar: true)
    settings_screen.set_tab_bar_item title: "Settings", icon: "icons/settings-25.png"
    
    help_screen = HelpScreen.new(nav_bar: true)
    help_screen.set_tab_bar_item title: "Help", icon: "icons/help-25.png"

    open_tab_bar search_screen, settings_screen, help_screen
  end
  
end
