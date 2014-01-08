class ImageViewController < UIViewController
#  attr_accessor :capture_seq_nbr

  def initWithImage(capture_seq_nbr)
    defaults = NSUserDefaults.standardUserDefaults
    photo_as_data = defaults["#{capture_seq_nbr}"]
    @photo = NSKeyedUnarchiver.unarchiveObjectWithData(photo_as_data)
    AFMotion::Image.get("#{@photo.image_url}?email=#{NSUserDefaults.standardUserDefaults[:email]}&password=#{NSUserDefaults.standardUserDefaults[:password]}") do |result|
      @image = result.object
    end

    # Set up scrollView
    scrollView = UIScrollView.alloc.initWithFrame(UIScreen.mainScreen.bounds)
    scrollView.scrollEnabled = false
    scrollView.clipsToBounds = true
    scrollView.contentSize = @image.size
    scrollView.minimumZoomScale = 1.0
    scrollView.maximumZoomScale = 4.0
    scrollView.zoomScale = 0.3
    scrollView.delegate = self

    # Set up imageView
    imageView = UIImageView.alloc.initWithImage(@image)
    imageView.contentMode = UIViewContentModeScaleAspectFit
    imageView.userInteractionEnabled = true
    imageView.frame = scrollView.bounds

    # Add the imageView as a subview to our scrollView
    scrollView.addSubview(imageView)
    self.view.addSubview(@scrollView)
  end

  def viewForZoomingInScrollView(scrollView)
    scrollView.subviews.first
  end
  
  def scrollViewDidZoom(scrollView)
    if scrollView.zoomScale != 1.0
      scrollView.scrollEnabled = true
    else
      scrollView.scrollEnabled = false
    end
  end
  
end