class GridPhotosScreen < PM::Screen
  include HomeStyles

  attr_accessor :ticket_nbr
  attr_accessor :photos

  def on_load
  end


  def will_appear

    set_attributes self.view, main_view_style
    unless @scroll.nil?
      @scroll.removeFromSuperview
    end

    @scroll = add UIScrollView.alloc.initWithFrame(self.view.bounds)
    @scroll.frame = self.view.bounds
    @scroll.contentSize = CGSizeMake(@scroll.frame.size.width, content_height(@scroll) + 20)

#    add_to @scroll, UILabel.new, label_style

    showProgress
    @photos = Photo.find(ticket_nbr) do |photos|
      unless photos == nil or photos.count == 0
        cust_name_label(photos.first)
        @scroll.contentSize = CGSizeMake(320, (photos.count)*80);
        photos.reverse.each_with_index do |photo, i|
          tile =  add Tile.new, { frame: CGRectMake( ((i+2).odd? ? 20 : 170),  ((i/2).to_i * 150 + 40), 130, 130) }
          add_to tile, UILabel.new, {
            text: "Loading ...",
            text_color: hex_color("8F8F8D"),
            background_color: UIColor.clearColor,
            shadow_color: UIColor.blackColor,
            text_alignment: UITextAlignmentCenter,
            font: UIFont.systemFontOfSize(15.0),
            resize: [ :left, :right, :bottom ], # ProMotion sugar here
            frame: CGRectMake(0, 0, 130, 130)
          }
          add_to @scroll, tile

          image_button = UIButton.buttonWithType(UIButtonTypeCustom)
          image_button.frame = [[0, 0], [130, 130]]
          image_button.tag = photo.capture_seq_nbr
          #          action_button.setBackgroundImage(UIImage.imageNamed('SYD_600_400.png'), forState: UIControlStateNormal)
          image_button.addTarget(self, action: "image_tapped:", forControlEvents: UIControlEventTouchUpInside)
          add_to tile, image_button

          AFMotion::Image.get("#{photo.preview_url}?email=#{NSUserDefaults.standardUserDefaults[:email]}&password=#{NSUserDefaults.standardUserDefaults[:password]}") do |result|
            image = result.object
            image_view = UIImageView.alloc.initWithImage(result.object)
            p "Image downloaded"
            image_view.frame = [[0,  0], [130, 130]]
            add_to tile, image_view
            add_to @scroll, tile
          end # End AFMotion image get
        end # End photos.each do
        @add_button =  UIButton.buttonWithType(UIButtonTypeCustom)
        @add_button.setImage(UIImage.imageNamed("icons/plus-32.png"), forState:UIControlStateNormal)
        @add_button.addTarget(self, action: :add_photo, forControlEvents:UIControlEventTouchUpInside)
        @add_button.setFrame CGRectMake(0, 0, 32, 32)
        set_nav_bar_button :right, button: UIBarButtonItem.alloc.initWithCustomView(@add_button)
      end # End photos.count == 0?
      if photos.nil?
        App.alert("Error connecting to database - check you settings")
      elsif photos.count == 0
        App.alert("No images found")
      end
      dismissProgress

    end # End Photo.find

#    set_nav_bar_button :right, system_icon: :add, action: :add_photo

    ### Refresh Button ###
#    button =  UIButton.buttonWithType(UIButtonTypeCustom)
#    button.setImage(UIImage.imageNamed("icons/refresh_shield-25.png"), forState:UIControlStateNormal)
#    button.addTarget(self, action: :tapped_refresh, forControlEvents:UIControlEventTouchUpInside)
#    button.setFrame CGRectMake(@scroll.frame.size.width - 30, 0, 32, 32)
#    add_to @scroll, button

#    set_nav_bar_button :left, button: UIBarButtonItem.alloc.initWithCustomView(button)
#    set_nav_bar_button :left, title: "Close", action: :close_tapped
  end

#  def will_appear
#    @scroll.frame = self.view.bounds
#    @scroll.contentSize = CGSizeMake(@scroll.frame.size.width, content_height(@scroll) + 20)
#  end

  def on_return(args = {})
    p args
  end

  def tapped_log
    PM.logger.info "Tapped logo!"
  end

  def tapped_refresh
    PM.logger.info "Tapped refresh"
#    open_root_screen(GridPhotosScreen.new(nav_bar: true, ticket_nbr: ticket_nbr, title: ticket_nbr))
#    open GridPhotosScreen.new(nav_bar: true, ticket_nbr: ticket_nbr, title: ticket_nbr)

#    search_screen = SearchScreen.new(nav_bar: true)
#    search_screen.set_tab_bar_item title: "Search", icon: "icons/search-25.png"
#
#    settings_screen = SettingsScreen.new(nav_bar: true)
#    settings_screen.set_tab_bar_item title: "Settings", icon: "icons/settings-25.png"
#
#    help_screen = HelpScreen.new(nav_bar: true)
#    help_screen.set_tab_bar_item title: "Help", icon: "icons/help-25.png"
#
#    open_tab_bar search_screen, settings_screen, help_screen
  end

  def close_tapped
    close
  end

  def image_tapped(sender)
    capture_seq_nbr = sender.tag
#    App.alert("#{self.ticket_nbr}")
#    open ShowPhotoScreen.new(nav_bar: true, capture_seq_nbr: capture_seq_nbr, title: "#{self.ticket_nbr}")
#    open ShowPhotoScreen.new(nav_bar: true, capture_seq_nbr: capture_seq_nbr)
    open ShowImageScreen.new(nav_bar: true, capture_seq_nbr: capture_seq_nbr)
  end

  def add_photo
#    App.alert("new photo stuff here")
#    camera_controller = CameraController.alloc.initWithNibName(nil, bundle: nil)
#    camera_controller.ticket_nbr = self.title
#    open camera_controller

    options = {
#      :title   => "Dinner this Friday?",
#      :message => "My treat!",
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

  def all_photos
    @photos
  end
end