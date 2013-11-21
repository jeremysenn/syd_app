class ShowPhotoScreen < PM::Screen
  attr_accessor :capture_seq_nbr#, :ticket_nbr, :sys_date_time
  include HomeStyles
  
  def will_appear
    set_attributes self.view, main_view_style

    defaults = NSUserDefaults.standardUserDefaults
#    set_nav_bar_button :left, title: "Close", action: :close_tapped
#    set_nav_bar_right_button "Save", action: :save_photo
    photo_as_data = defaults["#{@capture_seq_nbr}"]
    @photo = NSKeyedUnarchiver.unarchiveObjectWithData(photo_as_data)
    self.title = @photo.cust_name
#    cust_name_label(@photo)
    
    show_photo
  end

  def on_load
#    unless self.ticket_nbr == ""
#      self.title = self.ticket_nbr
#    end
    showProgress
    @download_button =  UIButton.buttonWithType(UIButtonTypeCustom)
    @download_button.setImage(UIImage.imageNamed("icons/download-25"), forState:UIControlStateNormal)
    @download_button.addTarget(self, action: :save_photo, forControlEvents:UIControlEventTouchUpInside)
    @download_button.setFrame CGRectMake(0, 0, 32, 32)
    set_nav_bar_button :right, button: UIBarButtonItem.alloc.initWithCustomView(@download_button)
  end

  def close_tapped
    close
  end

  def show_photo
#    showProgress
    AFMotion::Image.get("#{@photo.image_url}?email=#{NSUserDefaults.standardUserDefaults[:email]}&password=#{NSUserDefaults.standardUserDefaults[:password]}") do |result|
      @image = result.object
      tile =  add Tile.new, { frame: CGRectMake(0, 65, self.view.frame.width, self.view.frame.height) }
      add_to view, tile
      image_view = UIImageView.alloc.initWithImage(result.object)
#      image_view.frame = [[self.view.frame.width, 0],[@photo.width, @photo.height]]
      image_view.frame = [[0, 0],[326, 460]]
#      image_view.frame = [[0, 0],[self.view.frame.width, self.view.frame.height]]
      add_to tile, image_view
#      view.addSubview image_view
      dismissProgress
    end
      
  end

  #Show spinner
  def showProgress
    unless block_given?
      SVProgressHUD.show
    else
      SVProgressHUD.showWithStatus "#{yield}"
    end
  end

  #Hide spinner
  def dismissProgress
    unless block_given?
      SVProgressHUD.dismiss
    else
      SVProgressHUD.showSuccessWithStatus "#{yield}"
    end
  end

  def save_photo
    App.alert("Image saved!")
    UIImageWriteToSavedPhotosAlbum(@image, nil, nil , nil)
    @download_button.enabled = false
  end

  def cust_name_label(photo)
    unless photo.cust_name.nil?
      add_to @scroll, UILabel.new, {
        text: "#{photo.cust_name}",
        text_color: hex_color("8F8F8D"),
        background_color: UIColor.clearColor,
        shadow_color: UIColor.blackColor,
        text_alignment: UITextAlignmentCenter,
        font: UIFont.systemFontOfSize(15.0),
        resize: [ :left, :right, :bottom ], # ProMotion sugar here
        frame: CGRectMake(10, 0, 300, 35)
      }
    end
  end
end
