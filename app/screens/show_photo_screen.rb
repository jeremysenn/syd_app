class ShowPhotoScreen < PM::Screen
  attr_accessor :capture_seq_nbr#, :ticket_nbr, :sys_date_time
  
  def will_appear
    defaults = NSUserDefaults.standardUserDefaults
#    set_nav_bar_button :left, title: "Close", action: :close_tapped
#    set_nav_bar_right_button "Save", action: :save_photo
    photo_as_data = defaults["#{self.title}"]
    @photo = NSKeyedUnarchiver.unarchiveObjectWithData(photo_as_data)
    add UILabel.new, {
      text: "#{@photo.ticket_nbr} - #{@photo.sys_date_time}",
      text_color: hex_color("8F8F8D"),
      background_color: UIColor.clearColor,
      shadow_color: UIColor.blackColor,
      text_alignment: UITextAlignmentCenter,
      font: UIFont.systemFontOfSize(15.0),
      resize: [ :left, :right, :bottom ], # ProMotion sugar here
      frame: CGRectMake(10, 0, 300, 35)
    }
    show_photo
  end

  def on_load
#    unless self.ticket_nbr == ""
#      self.title = self.ticket_nbr
#    end

    button =  UIButton.buttonWithType(UIButtonTypeCustom)
    button.setImage(UIImage.imageNamed("download2_filled-25"), forState:UIControlStateNormal)
    button.addTarget(self, action: :save_photo, forControlEvents:UIControlEventTouchUpInside)
    button.setFrame CGRectMake(0, 0, 32, 32)
    set_nav_bar_button :right, button: UIBarButtonItem.alloc.initWithCustomView(button)
  end

  def close_tapped
    close
  end

  def show_photo
    showProgress
    AFMotion::Image.get(@photo.image_url) do |result|
      @image = result.object
      image_view = UIImageView.alloc.initWithImage(result.object)
#      image_view.frame = [[self.view.frame.width, 0],[@photo.width, @photo.height]]
      image_view.frame = [[0, 65],[326, 460]]
      view.addSubview image_view
    end
      dismissProgress
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
  end
end
