class HomeScreen < PM::GroupedTableScreen
  include HomeStyles

  title "Home"

  def on_load
    set_nav_bar_button :left, title: "Help", action: :help_tapped
    set_nav_bar_button :right, title: "Settings", action: :settings_tapped
#    set_nav_bar_button :right, title: "States", action: :states_tapped
  end

  def on_present
    @view_setup ||= self.set_up_view
  end

  def set_up_view
    set_attributes self.view, {
      background_color: UIColor.grayColor
    }

#    add UILabel.new, label_view # found in HomeStyles module

    true
  end

  def on_return(args={})
    if args[:settings_saved]
      @alert_box = UIAlertView.alloc.initWithTitle("Message",
        message:"Settings saved",
        delegate: nil,
        cancelButtonTitle: "ok",
        otherButtonTitles:nil)
        # Show it to the user
        @alert_box.show
#      self.title = "Saved!"
    end
  end

  def states_tapped
    open StatesScreen
  end

  def settings_tapped
#    open SettingsScreen
    open SettingsScreen.new(nav_bar: true)
  end

  def help_tapped
    open_modal HelpScreen.new(nav_bar: true)
  end

  def table_data
    [{
        cells: [
          { title: "Ticket Number", action: :ticket_search_tapped },
        ]
      }, {
        cells: [
          { title: "Barcode", action: :barcode_search_tapped },
        ]
      }]
  end

  def ticket_search_tapped
    open TicketSearchScreen.new(nav_bar: true)
  end

  def barcode_search_tapped
    open BarcodeSearchScreen.new(nav_bar: true)
  end
end
