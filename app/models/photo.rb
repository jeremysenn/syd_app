class Photo
  PROPERTIES = [:preview_url, :image_url, :width, :height, :capture_seq_nbr, :ticket_nbr, :sys_date_time, :cust_name, :cust_nbr]
  PROPERTIES.each { |prop|
    attr_accessor prop
  }
#  attr_accessor :preview_url, :width, :height, :capture_seq_nbr, :ticket_nbr, :sys_date_time

  AFMotion::Client.build_shared("#{NSUserDefaults.standardUserDefaults[:server]}/image_datas/") do
    operation :json
    header "Accept", "application/json"
  end
  
  def initialize(attrs)
    @preview_url = attrs[:preview_url]
    @image_url = attrs[:image_url]
    @capture_seq_nbr = attrs[:capture_seq_nbr]
    @ticket_nbr = attrs[:ticket_nbr]
    @sys_date_time = attrs[:sys_date_time]
    @cust_name = attrs[:cust_name]
    @cust_nbr = attrs[:cust_nbr]
    @width = 326.0
    @height = 460.0
  end

  # called when an object is loaded from NSUserDefaults
  # this is an initializer, so should return `self`

  def initWithCoder(decoder)
#    self.init
    PROPERTIES.each { |prop|
      value = decoder.decodeObjectForKey(prop.to_s)
      self.send((prop.to_s + "=").to_s, value) if value
    }
    self
  end

  # called when saving an object to NSUserDefaults
  def encodeWithCoder(encoder)
    PROPERTIES.each { |prop|
      encoder.encodeObject(self.send(prop), forKey: prop.to_s)
    }
  end

  def save
    defaults = NSUserDefaults.standardUserDefaults
    defaults["#{self.capture_seq_nbr}"] = NSKeyedArchiver.archivedDataWithRootObject(self)
  end

#  def self.load
#    defaults = NSUserDefaults.standardUserDefaults
#    data = defaults["#{self.capture_seq_nbr}"]
#    # protect against nil case
#    NSKeyedUnarchiver.unarchiveObjectWithData(data) if data
#  end

  
  def self.find(ticket_number, &block)
    AFMotion::Client.shared.get("#{ticket_number}/ticket_search?email=#{NSUserDefaults.standardUserDefaults[:email]}&password=#{NSUserDefaults.standardUserDefaults[:password]}") do |result|
      if result.success?
        json = result.object
        p json
        photos = json.map{|item| Photo.new(item)} # SYD Implementation
#        defaults = NSUserDefaults.standardUserDefaults
        photos.each do |photo|
          photo.save
#          photo_as_data = NSKeyedArchiver.archivedDataWithRootObject(photo)
#          defaults["#{photo.capture_seq_nbr}"] = photo_as_data
        end
        block.call(photos)
      else
        #something went wrong
        @alert_box = UIAlertView.alloc.initWithTitle("Error",
          message:"Something went wrong with connection to server",
          delegate: nil,
          cancelButtonTitle: "ok",
          otherButtonTitles:nil)
        # Show it to the user
        @alert_box.show
        block.call(nil)
      end
    end
  end

#  def self.find(ticket_number, &block)
#    BW::HTTP.get("http://localhost:3000/image_datas/#{ticket_number}") do |response|
#      result_data = BW::JSON.parse(response.body.to_str)
#      if result_data.nil?
#        block.call(nil)
#      else
#        p result_data["image_data"]
#        image_data = result_data["image_data"]
#        image = Image.new(image_data)
#        block.call(image)
#      end
#    end
#  end

  ### POST NEW PICTURE USING BUBBLEWRAP ###
  def self.add_photo(photo, ticket_nbr, &block)
#    photoImageData = UIImage.UIImageJPEGRepresentation(photo, 1)
#    BW::HTTP.post("http://localhost:3000/pictures/#{ticket_nbr}/create_picture_from_json", payload: {photo: photoImageData}) do |response|
#      p response
##      block.call
#    end

    photoImageData = UIImage.UIImageJPEGRepresentation(photo, 1)
    encodedData = [photoImageData].pack("m0")
    picture_data = {ticket_nbr: ticket_nbr, photo: encodedData, email: NSUserDefaults.standardUserDefaults[:email],
      password: NSUserDefaults.standardUserDefaults[:password]}
      BW::HTTP.post("#{NSUserDefaults.standardUserDefaults[:server]}/pictures/create_picture_from_json", {payload: picture_data}) do |response|
#      BW::HTTP.post("http://localhost:3000/pictures/create_picture_from_json", {payload: picture_data}) do |response|
        if response.ok?
          json = BW::JSON.parse(response.body.to_str)
#          p json['id']
#          App.alert("Done uploading")
          @alert_box = UIAlertView.alloc.initWithTitle("Message",
          message:"Done uploading",
          delegate: nil,
          cancelButtonTitle: "ok",
          otherButtonTitles:nil)
          @alert_box.show
        elsif response.status_code.to_s =~ /40\d/
#          App.alert("Login failed")
          @alert_box = UIAlertView.alloc.initWithTitle("Error",
          message:"Login failed",
          delegate: nil,
          cancelButtonTitle: "ok",
          otherButtonTitles:nil)
          @alert_box.show
        else
          unless response.error_message == ""
#            App.alert(response.error_message)
            @alert_box = UIAlertView.alloc.initWithTitle("Photo uploaded",
            message: response.error_message,
            delegate: nil,
            cancelButtonTitle: "ok",
            otherButtonTitles:nil)
            @alert_box.show
          else
#            App.alert("Done uploading")
            @alert_box = UIAlertView.alloc.initWithTitle("Message",
            message: "Done uploading",
            delegate: nil,
            cancelButtonTitle: "ok",
            otherButtonTitles:nil)
            @alert_box.show
          end
          SVProgressHUD.dismiss
        end
      end
  end

  ### POST NEW PICTURE USING AFMOTION ###
#  def self.add_photo(photo, ticket_nbr, &block)
#    client = AFMotion::Client.build("http://localhost:3000/pictures/#{ticket_nbr}/") do
#      header "Accept", "application/json"
#      operation :json
#    end
#
#    image = photo
#    data = UIImagePNGRepresentation(image)
#
#    client.multipart.post("create_picture_from_json") do |result, form_data|
#      if form_data
#        # Called before request runs
#        # see: https://github.com/AFNetworking/AFNetworking/wiki/AFNetworking-FAQ
#        form_data.appendPartWithFileData(photo: data, name: "avatar")
#      elsif result.success?
#
#      else
#
#      end
#    end
#  end
end