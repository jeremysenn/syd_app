class SettingsScreen < PM::FormotionScreen
  title "Settings"
  
  def will_appear
#    set_nav_bar_button :left, title: "Cancel", action: :cancel_tapped
    set_nav_bar_right_button "Save", action: :save
  end


  def table_data
    {
      sections: [{
        title: "Web Application URL",
        rows: [{
          key: :server,
          value: NSUserDefaults.standardUserDefaults[:server],
          placeholder: "https://www.scrapyarddog.com",
          type: :string,
          auto_correction: :no,
          auto_capitalization: :none,
          text_alignment: :left
        }]
      },
        {
          title: "User details",
          rows: [{
              title: "Email",
              key: :email,
              value: NSUserDefaults.standardUserDefaults[:email],
              placeholder: "me@mail.com",
              type: :email,
              auto_correction: :no,
              auto_capitalization: :none
            }, {
              title: "Password",
              key: :password,
              value: NSUserDefaults.standardUserDefaults[:password],
              placeholder: "required",
              type: :string,
              secure: true
            }]
        }
      ]
    }
  end

  def cancel_tapped
    close
  end

  def save
    if @defaults.nil?
      @defaults = NSUserDefaults.standardUserDefaults
    end

    data = self.form.render
    @defaults["server"] = data[:server]
    p @defaults["server"]
    @defaults["email"] = data[:email]
    p @defaults["email"]
    @defaults["password"] = data[:password]
    p @defaults["password"]

    close settings_saved: true
    @alert_box = UIAlertView.alloc.initWithTitle("Done",
      message:"Your settings have been saved",
      delegate: nil,
      cancelButtonTitle: "ok",
      otherButtonTitles:nil)
      @alert_box.show
  end

end
