class HelpScreen < PM::GroupedTableScreen
  title "Help"
  
  def will_appear
#    set_nav_bar_button :left, title: "Close", action: :close_tapped
  end

  def table_data
  [{
    title: "About",
    cells: [
      { title: "ScrapYardDog", action: :about_syd }
    ]
  }, {
    title: "Help",
    cells: [
      { title: "Support", action: :email_us }
    ]
  }]
end

  def email_us
    mailto_link = NSURL.URLWithString("mailto:info@tranact.com")
    UIApplication.sharedApplication.openURL(mailto_link)
  end

  def about_syd
    syd_link = NSURL.URLWithString("https://scrapyarddog.com/ScrapYardDog.docx")
    UIApplication.sharedApplication.openURL(syd_link)
  end
  
  def close_tapped
    close
  end
end
