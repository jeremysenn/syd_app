class PhotosScreen < PM::Screen
  title "Photos"
  attr_accessor :ticket_nbr
  
  def will_appear
    set_nav_bar_button :left, title: "Close", action: :close_tapped
    set_nav_bar_right_button "New", action: :new_photo

    show_photos

    self.view.backgroundColor = UIColor.darkGrayColor
#    add UILabel.alloc.initWithFrame(CGRectMake(25, 50, 275, 150)), {
#      text: "Searching for Images",
#      border_style: UITextBorderStyleRoundedRect,
#      background_color: UIColor.whiteColor,
#      font: UIFont.systemFontOfSize(14),
#      number_of_lines: 0,
#      line_break_mode: UILineBreakModeWordWrap,
#      layer: {
#        border_width: 5,
#        corner_radius: 15,
#        border_color: UIColor.grayColor
#      }
#    }
  end

  def on_load
    unless self.ticket_nbr == ""
      self.title = self.ticket_nbr
    end
  end

  def close_tapped
    close
  end

  def new_photo
    p "New Photo"
#    open CameraScreen.new(nav_bar: true)
#    open CameraController.new
    camera_controller = CameraController.alloc.initWithNibName(nil, bundle: nil)
    camera_controller.ticket_nbr = self.title
    open camera_controller
#    self.navigationController.pushViewController(camera_controller, animated: true)
  end

  def show_photos
#    Photo.find(ticket_nbr)
    showProgress
    Photo.find(ticket_nbr) do |photos|
      unless photos.nil?
        add_scroll_view(photos.count)
#        add_page_control(photos.count)
        photos.each_with_index do |photo, i|
          AFMotion::Image.get(photo.url) do |result|
            image_view = UIImageView.alloc.initWithImage(result.object)
            image_view.frame = [[view.frame.width * i, 0],[photo.width, photo.height]]
            if image_view.image.nil?
              p "Image failed to load from server using AFMotion"
              BubbleWrap::HTTP.get(photo.url) do |response|
                image_view.image = UIImage.imageWithData(response.body)
                @scroll_view.addSubview image_view
                p "Second try, this time using BubbleWrap"
                if image_view.image.nil?
                  p "Crap, image is nil after second try"
                  BubbleWrap::HTTP.get(photo.url) do |response|
                    image_view.image = UIImage.imageWithData(response.body)
                    @scroll_view.addSubview image_view
                    p "Third try, again using BubbleWrap"
                    if image_view.image.nil?
                      p "Oh man, image is still nil after three tries"
                      BubbleWrap::HTTP.get(photo.url) do |response|
                        image_view.image = UIImage.imageWithData(response.body)
                        @scroll_view.addSubview image_view
                        p "Fourth try, again using BubbleWrap"
                        if image_view.image.nil?
                          p "Oh man, image is still nil after four tries"
                          BubbleWrap::HTTP.get(photo.url) do |response|
                            image_view.image = UIImage.imageWithData(response.body)
                            @scroll_view.addSubview image_view
                            p "Fifth try, again using BubbleWrap"
                            if image_view.image.nil?
                              p "Oh man, image is still nil after Five tries"
                              placeholder = UIImage.imageNamed('SYD_600_400.png')
                              image_view.image = placeholder # Put placeholder image in for now
                              @scroll_view.addSubview image_view
                            else
                              p "Image is good after fifth try"
                            end
                          end
                        else
                          p "Image is good after fourth try"
                        end
                      end
                    else
                      p "Image is good after third try"
                    end
                  end
                else
                  p "Image is good after second try"
                end
              end
            else
              p image_view.image
              @scroll_view.addSubview image_view
            end

          end #End AFMotion image get
        end #End photos.each_with_index
      end #End unless photos.nil?
      if photos.nil?
        @alert_box = UIAlertView.alloc.initWithTitle("Error",
        message:"Error connecting to database ",
        delegate: nil,
        cancelButtonTitle: "ok",
        otherButtonTitles:nil)
        # Show it to the user
        @alert_box.show
      elsif photos.count == 0
        @alert_box = UIAlertView.alloc.initWithTitle("Message",
        message:"Nothing found",
        delegate: nil,
        cancelButtonTitle: "ok",
        otherButtonTitles:nil)
        # Show it to the user
        @alert_box.show
      end
      dismissProgress
    end #End Photo.find
  end

  def add_scroll_view(number_of_pages)
    @scroll_view = UIScrollView.alloc.initWithFrame(
        CGRect.make(x: 0, y: 65, width: view.frame.width, height: view.frame.height))
    @scroll_view.contentSize = CGSizeMake(view.bounds.width * number_of_pages, view.frame.height)
    @scroll_view.pagingEnabled = true
    @scroll_view.delegate = self
    view.addSubview @scroll_view
  end

  def add_page_control(number_of_pages)
    @page_control = UIPageControl.alloc.initWithFrame [[110,340], [100, 20]]
    @page_control.numberOfPages = number_of_pages
    view.addSubview @page_control
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
end
