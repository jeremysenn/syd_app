class HelpScreen < PM::GroupedTableScreen
  title "Help"
  
  def will_appear
#    set_nav_bar_button :left, title: "Close", action: :close_tapped
  end

  def table_data
  [{
    title: "About",
    cells: [
      { title: "ScrapYardDog", action: :about_syd },
      { title: "TranAct", action: :about_tranact }
    ]
  }, {
    title: "Help",
    cells: [
      { title: "Support", action: :email_us },
      { title: "Feedback", action: :feedback }
    ]
  }]
end

  def email_us
    mailto_link = NSURL.URLWithString("mailto:info@tranact.com")
    UIApplication.sharedApplication.openURL(mailto_link)
  end
  
  def close_tapped
    close
  end
end
