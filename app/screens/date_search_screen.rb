class DateSearchScreen < PM::FormotionScreen
  title "Date"
  
  def will_appear
#    set_nav_bar_button :left, title: "Cancel", action: :cancel_tapped
    @search_button =  UIButton.buttonWithType(UIButtonTypeCustom)
    @search_button.setImage(UIImage.imageNamed("icons/search-25"), forState:UIControlStateNormal)
    @search_button.addTarget(self, action: :date_search, forControlEvents:UIControlEventTouchUpInside)
    @search_button.setFrame CGRectMake(0, 0, 32, 32)
    set_nav_bar_button :right, button: UIBarButtonItem.alloc.initWithCustomView(@search_button)
#    set_nav_bar_right_button "Go", action: :ticket_search
  end

  def on_load
    self.form.on_submit do |form|
      date_search
    end
  end


  def table_data
    {
      sections: [{
        rows: [{
          key: :date,
#          placeholder: "Select Date",
          value: Time.now.to_i,
          type: :date,
          auto_correction: :no,
          auto_capitalization: :none,
          text_alignment: :left
        }],
      },
      {
        rows: [{
            title: "Search",
            type: :submit,
          }]
      }]
    }
  end

  def cancel_tapped
    close
  end

  def date_search
    data = self.form.render
#    p "date: #{data[:date]}"
    p "Date: #{Time.at(data[:date]).strftime("%m/%d/%Y")}"

    open FindByDateGridPhotosScreen.new(nav_bar: true, date: data[:date], title: Time.at(data[:date]).strftime("%m/%d/%Y"))
  end

end
