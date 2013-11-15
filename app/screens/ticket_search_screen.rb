class TicketSearchScreen < PM::FormotionScreen
  title "Ticket Search"
  
  def will_appear
#    set_nav_bar_button :left, title: "Cancel", action: :cancel_tapped
    set_nav_bar_right_button "Go", action: :ticket_search
  end


  def table_data
    {
      sections: [{
        rows: [{
          key: :ticket_nbr,
          placeholder: "Ticket Number",
          type: :string,
          auto_correction: :no,
          auto_capitalization: :none,
          text_alignment: :left
        }]
      }
      ]
    }
  end

  def cancel_tapped
    close
  end

  def ticket_search
    data = self.form.render
    p "ticket search: #{data[:ticket_nbr]}"

    if data[:ticket_nbr] == ""
      @alert_box = UIAlertView.alloc.initWithTitle("Alert",
        message:"Ticket Number cannot be blank",
        delegate: nil,
        cancelButtonTitle: "Ok",
        otherButtonTitles:nil)
      # Show it to the user
      @alert_box.show
    else
#      open PhotosScreen.new(nav_bar: true, ticket_nbr: data[:ticket_nbr])
      open GridPhotosScreen.new(nav_bar: true, ticket_nbr: data[:ticket_nbr], title: data[:ticket_nbr])
    end
  end

end
