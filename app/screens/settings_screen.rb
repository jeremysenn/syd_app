class SettingsScreen < PM::FormotionScreen
  title "Settings"

  def will_appear
#    set_nav_bar_button :left, title: "Cancel", action: :cancel_tapped
#    @save_button =  set_nav_bar_right_button "Save", action: :save

    @save_button =  UIButton.buttonWithType(UIButtonTypeCustom)
    @save_button.setImage(UIImage.imageNamed("icons/save_as-25"), forState:UIControlStateNormal)
    @save_button.addTarget(self, action: :save, forControlEvents:UIControlEventTouchUpInside)
    @save_button.setFrame CGRectMake(0, 0, 32, 32)
    set_nav_bar_button :right, button: UIBarButtonItem.alloc.initWithCustomView(@save_button)

    set_nav_bar_button :left, title: "Demo", action: :demo_reset
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

#    close settings_saved: true
    App.alert('Your settings have been saved.')
#    @save_button.enabled = false # Disable button after pressed
  end

  def demo_reset
    App.alert("Demo settings used")
    @defaults = NSUserDefaults.standardUserDefaults
    @defaults[:server] = "https://www.scrapyarddog.com"
    @defaults[:email] = "demo@tranact.com"
    @defaults[:password] = "demouser"

    open SettingsScreen.new nav_bar: true, form: {
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

end
