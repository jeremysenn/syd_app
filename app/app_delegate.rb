class AppDelegate < PM::Delegate
  status_bar true, animation: :none

  def on_load(app, options)
    @defaults = NSUserDefaults.standardUserDefaults
    @defaults["one"] = "one"

    AFMotion::Client.build_shared("#{NSUserDefaults.standardUserDefaults[:server]}/image_datas/") do
      operation :json
      header "Accept", "application/json"
    end

    open HomeScreen.new(nav_bar: true)
  end
  
end
