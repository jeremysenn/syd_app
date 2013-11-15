class GridPhotosScreen < PM::Screen
  include HomeStyles

#  title "Grid Photos"
  attr_accessor :ticket_nbr

  def will_appear
    set_attributes self.view, main_view_style
    unless @scroll.nil?
      @scroll.removeFromSuperview
    end

    @scroll = add UIScrollView.alloc.initWithFrame(self.view.bounds)
    @scroll.frame = self.view.bounds
    @scroll.contentSize = CGSizeMake(@scroll.frame.size.width, content_height(@scroll) + 20)

    add_to @scroll, UILabel.new, label_style
    showProgress
    Photo.find(ticket_nbr) do |photos|
      unless photos.nil?
        @scroll.contentSize = CGSizeMake(320, (photos.count)*80);
        photos.each_with_index do |photo, i|
          tile =  add Tile.new, { frame: CGRectMake( ((i+2).odd? ? 20 : 170),  ((i/2).to_i * 150 + 40), 130, 130) }
          add_to @scroll, tile
          
          image_button = UIButton.buttonWithType(UIButtonTypeCustom)
          image_button.frame = [[0, 0], [130, 130]]
          image_button.tag = photo.capture_seq_nbr
          #          action_button.setBackgroundImage(UIImage.imageNamed('SYD_600_400.png'), forState: UIControlStateNormal)
          image_button.addTarget(self, action: "image_tapped:", forControlEvents: UIControlEventTouchUpInside)
          add_to tile, image_button

          AFMotion::Image.get(photo.url) do |result|
            image_view = UIImageView.alloc.initWithImage(result.object)
            if image_view.image.nil?
              p "Image failed to load from server using AFMotion"
              BubbleWrap::HTTP.get(photo.url) do |response|
                image_view.image = UIImage.imageWithData(response.body)
                p "Second try, this time using BubbleWrap"
                if image_view.image.nil?
                  p "Image failed to load from server on second try"
                  BubbleWrap::HTTP.get(photo.url) do |response|
                    image_view.image = UIImage.imageWithData(response.body)
                    p "Third try"
                    if image_view.image.nil?
                      p "Image failed to load from server on third try"
                      BubbleWrap::HTTP.get(photo.url) do |response|
                        image_view.image = UIImage.imageWithData(response.body)
                        p "Fourth try"
                        if image_view.image.nil?
                          p "Image failed to load from server on fourth try"
                          BubbleWrap::HTTP.get(photo.url) do |response|
                            image_view.image = UIImage.imageWithData(response.body)
                            p "Fifth try"
                            if image_view.image.nil?
                              p "Image failed to load from server on fifth try"
                              BubbleWrap::HTTP.get(photo.url) do |response|
                                image_view.image = UIImage.imageWithData(response.body)
                                p "Sixth try"
                              end # End fifth bubblewrap get
                            else
                              p "Image is good on fifth try"
                              image_view.frame = [[0,  0], [130, 130]]
                              add_to tile, image_view
                              add_to @scroll, tile
                            end # End fifth image.nil?
                          end # End fourth bubblewrap get
                        else
                          p "Image is good on fourth try"
                          image_view.frame = [[0,  0], [130, 130]]
                          add_to tile, image_view
                          add_to @scroll, tile
                        end # End fourth image.nil?
                      end # End third bubblewrap get
                    else
                      p "Image is good on third try"
                      image_view.frame = [[0,  0], [130, 130]]
                      add_to tile, image_view
                      add_to @scroll, tile
                    end # End third image.nil?
                  end # End second bubblewrap get
                else
                  p "Image is good on second try"
                  image_view.frame = [[0,  0], [130, 130]]
                  add_to tile, image_view
                  add_to @scroll, tile
                end # End second image.nil?
              end # End first bubblewrap get
            else
              p "Image is good on first try"
              image_view.frame = [[0,  0], [130, 130]]
              add_to tile, image_view
              add_to @scroll, tile
            end # End first image.nil?
          end # End AFMotion image get
        end # End photos.each do
      end # End photos.nil?
      if photos.nil?
        App.alert("Error connecting to database")
      elsif photos.count == 0
        App.alert("No images found")
      end
      dismissProgress
    end # End Photo.find

    set_nav_bar_button :right, system_icon: :add, action: :add_photo

    button =  UIButton.buttonWithType(UIButtonTypeCustom)
    button.setImage(UIImage.imageNamed("logo"), forState:UIControlStateNormal)
    button.addTarget(self, action: :tapped_logo, forControlEvents:UIControlEventTouchUpInside)
    button.setFrame CGRectMake(0, 0, 32, 32)

#    set_nav_bar_button :left, button: UIBarButtonItem.alloc.initWithCustomView(button)
    set_nav_bar_button :left, title: "Close", action: :close_tapped
  end

#  def will_appear
#    @scroll.frame = self.view.bounds
#    @scroll.contentSize = CGSizeMake(@scroll.frame.size.width, content_height(@scroll) + 20)
#  end

  def add_note
    open AddNoteScreen
  end

  def tapped_log
    PM.logger.info "Tapped logo!"
  end

  def close_tapped
    close
  end

  def image_tapped(sender)
    capture_seq_nbr = sender.tag
    App.alert("#{capture_seq_nbr}")
  end

  def add_photo
#    App.alert("new photo stuff here")
    camera_controller = CameraController.alloc.initWithNibName(nil, bundle: nil)
    camera_controller.ticket_nbr = self.title
    open camera_controller
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