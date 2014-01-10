class CameraScreen < PM::Screen
  include HomeStyles

  attr_accessor :ticket_nbr, :source

 def viewDidLoad
    view.backgroundColor = UIColor.grayColor
#    init_picker_btn
    init_image_picker
    touched# Show camera or gallery
    self.title = self.ticket_nbr
  end

  def imagePickerController(picker, didFinishPickingImage:image, editingInfo:info)
    self.dismissModalViewControllerAnimated(true)
    add_image_view(image)
    upload
#    apply_image_filter
  end

  private
  def init_picker_btn
    view.addSubview(UIButton.buttonWithType(UIButtonTypeRoundedRect).tap do |btn|
      btn.frame = [[110, 100], [100, 50]]
      btn.setTitle("New photo", forState:UIControlStateNormal)
      btn.addTarget(self, action: :touched, forControlEvents:UIControlEventTouchUpInside)
    end)
  end

  def init_image_picker
    @image_picker = UIImagePickerController.alloc.init
    @image_picker.delegate = self
    @image_picker.sourceType = (self.source == "camera") ?
      UIImagePickerControllerSourceTypeCamera : UIImagePickerControllerSourceTypePhotoLibrary
#    @image_picker.sourceType = camera_available ?
#      UIImagePickerControllerSourceTypeCamera : UIImagePickerControllerSourceTypePhotoLibrary
  end

  def add_image_view(image)
    @image_view.removeFromSuperview if @image_view
    @image_view = UIImageView.alloc.initWithImage(image)
#    @image_view.frame = [[60, 160], [200, 200]]
    @image_view.frame = [[0, 65],[326, 460]]
    view.addSubview(@image_view)

#    right_upload_button = UIBarButtonItem.alloc.initWithTitle("Upload", style: UIBarButtonItemStyleBordered, target:self, action:'upload')
#    self.navigationItem.rightBarButtonItem = right_upload_button
  end

  def upload
    p "Photo uploaded"
    showProgress
    Photo.add_photo(@image_view.image, self.ticket_nbr)

    
  end

  def touched
    presentModalViewController(@image_picker, animated:true)
  end

  def camera_available
    UIImagePickerController.isSourceTypeAvailable(UIImagePickerControllerSourceTypeCamera)
  end

  def apply_image_filter
    ci_image = CIImage.imageWithCGImage(@image_view.image.CGImage)
    filter = CIFilter.filterWithName("CIColorInvert")

    filter.setValue(ci_image, forKey:KCIInputImageKey)
    adjusted_image = filter.valueForKey(KCIOutputImageKey)

    new_image = UIImage.imageWithCIImage(adjusted_image)
    @image_view.image = new_image
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