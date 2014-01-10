class ShowImageScreen < PM::Screen
  attr_accessor :capture_seq_nbr
  include HomeStyles
  
  def will_appear
    set_attributes self.view, main_view_style

    defaults = NSUserDefaults.standardUserDefaults
    photo_as_data = defaults["#{@capture_seq_nbr}"]
    @photo = NSKeyedUnarchiver.unarchiveObjectWithData(photo_as_data)
    self.title = @photo.cust_name
    
    show_photo
  end

  def on_load
    showProgress

    # Create download button in navbar
#    @download_button =  UIButton.buttonWithType(UIButtonTypeCustom)
#    @download_button.setImage(UIImage.imageNamed("icons/download-25"), forState:UIControlStateNormal)
#    @download_button.addTarget(self, action: :save_photo, forControlEvents:UIControlEventTouchUpInside)
#    @download_button.setFrame CGRectMake(0, 0, 32, 32)
#    set_nav_bar_button :right, button: UIBarButtonItem.alloc.initWithCustomView(@download_button)

    # Create new photo button in navbar
    @add_button =  UIButton.buttonWithType(UIButtonTypeCustom)
    @add_button.setImage(UIImage.imageNamed("icons/plus-32.png"), forState:UIControlStateNormal)
    @add_button.addTarget(self, action: :add_photo, forControlEvents:UIControlEventTouchUpInside)
    @add_button.setFrame CGRectMake(0, 0, 32, 32)
    set_nav_bar_button :right, button: UIBarButtonItem.alloc.initWithCustomView(@add_button)

  end

  def close_tapped
    close(no_refresh: true)
  end

  def show_photo
    result = AFMotion::Image.get("#{@photo.image_url}?email=#{NSUserDefaults.standardUserDefaults[:email]}&password=#{NSUserDefaults.standardUserDefaults[:password]}") do |result|
      image = result.object
      setup_view(image)
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

  def setup_view(image)

    # Set up scrollView
    scrollView = UIScrollView.alloc.initWithFrame(UIScreen.mainScreen.bounds)
    scrollView.scrollEnabled = false
    scrollView.clipsToBounds = true
    scrollView.contentSize = image.size
    scrollView.minimumZoomScale = 1.0
    scrollView.maximumZoomScale = 4.0
    scrollView.zoomScale = 0.3
    scrollView.delegate = self

    # Set up imageView
    imageView = UIImageView.alloc.initWithImage(image)
    imageView.contentMode = UIViewContentModeScaleAspectFit
    imageView.userInteractionEnabled = true
    imageView.frame = scrollView.bounds

    # Add the imageView as a subview to our scrollView
    scrollView.addSubview(imageView)
    self.view.addSubview(scrollView)
    @scroll = scrollView
  end

  def viewForZoomingInScrollView(scrollView)
    scrollView.subviews.first
  end

  def scrollViewDidEndZooming(scrollView)
    if scrollView.zoomScale != 1.0
      scrollView.scrollEnabled = true
    else
      scrollView.scrollEnabled = false
    end
  end

  def shouldAutorotateToInterfaceOrientation(*)
    true
  end

  def viewDidLayoutSubviews
#    @scroll.contentSize = CGSizeMake(320, 500)
#    self.view.subviews.first.contentSize = CGSizeMake(320, 500)
    unless @scroll.nil?
      @scroll.frame = self.view.bounds
      @scroll.contentSize = [ @scroll.frame.size.width, content_height(@scroll) - 20 ]
      image_view = @scroll.subviews.first
#      image_view.contentMode = UIViewContentModeScaleAspectFit
#      image_view.userInteractionEnabled = true
#      image_view.frame = [@scroll.frame.size.width, content_height(@scroll) - 80]
      image_view.frame = CGRectMake(0, 0, @scroll.frame.size.width, content_height(@scroll) - 160)
    end
  end

  def add_photo
    options = {
      :buttons => ["Take Photo", "Choose Existing"]
    }
    alert = BW::UIAlertView.default(options) do |alert|
      if alert.clicked_button.title == "Take Photo"
        p "Take photo"
        open CameraScreen.new(nav_bar: true, ticket_nbr: @ticket_nbr, source: 'camera')
      elsif alert.clicked_button.title == "Choose Existing"
        p "Choose existing"
        open CameraScreen.new(nav_bar: true, ticket_nbr: @ticket_nbr, source: 'library')
      end
    end
    alert.show
  end

end
