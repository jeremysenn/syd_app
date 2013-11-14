class BarcodeSearchScreen < PM::Screen
  title "Barcode Search"
  attr_accessor :reader

  def will_appear

    @view_loaded ||= begin
      view.backgroundColor = UIColor.whiteColor

      # Set up a button to launch our barcode reader
#      @reader_button = add UIButton.buttonWithType(UIButtonTypeRoundedRect), {
#        frame: CGRectMake(10, 10, 200, 30)
#      }
#      @reader_button.setTitle("Launch ZBar", forState: UIControlStateNormal)
#      @reader_button.when(UIControlEventTouchUpInside) do
#        launch_zbar
#      end
      launch_zbar
    end
  end

  def launch_zbar

#    if Device.simulator?
#      App.alert("Please run this application on a device to scan bar codes.")
#      return
#    end

    ap "Scanning Screen Launched!"

    self.reader = ZBarReaderController.new
#    self.reader.sourceType = UIImagePickerControllerSourceTypePhotoLibrary
    self.reader.sourceType = camera_available ?
      UIImagePickerControllerSourceTypeCamera : UIImagePickerControllerSourceTypePhotoLibrary

    self.reader.readerDelegate = self
    open self.reader, modal: true

#    self.reader ||= ZBarReaderViewController.new
#    self.reader.readerDelegate = self
#    open self.reader, modal: true

  end

  def imagePickerController(reader, didFinishPickingMediaWithInfo:info)
    ap info
    results = info.objectForKey(ZBarReaderControllerResults)
    image = info.objectForKey(UIImagePickerControllerOriginalImage)

    # Put the scanned image on the screen
#    @img ||= add UIImageView.new, {
#      frame: CGRectMake(10, 50, 200, 200),
#    }
#    @img.image = image

    reader.dismissModalViewControllerAnimated(true)

    ap "Total scanned barcodes: #{results.count}"
    results.each do |result|
      # Should be a ZBarSymbol
      ap "--begin--"
        ap "!!Not a ZBarSymbol!!" unless result.is_a? ZBarSymbol # Sanity check
      ap "Symbol Type: #{result.typeName}"
      ap "Data String: #{result.data}"
      ap "--end--"
    end
    search_ticket(results.last.data)
  end

  def search_ticket(scanned_ticket_nbr)
    open PhotosScreen.new(nav_bar: true, ticket_nbr: scanned_ticket_nbr)
  end

  def camera_available
    UIImagePickerController.isSourceTypeAvailable(UIImagePickerControllerSourceTypeCamera)
  end
end