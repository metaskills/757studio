module ApplicationHelper
  
  NAV_PAGES = ['Home','Who Should Attend','Presenters','Venue']
  
  def top_nav
    content_tag :ul, :id => 'top_nav_items' do
      NAV_PAGES.collect { |p| nav_item(p) }
    end
  end
  
  def bottom_nav
    content_tag :ul, :id => 'bottom_nav_items' do
      NAV_PAGES.collect { |p| nav_item(p) }
    end
  end
  
  def nav_item(page_name)
    page_param = page_name.downcase.gsub(/\s/,'_')
    link_class = current_page == page_param ? 'active' : ''
    content_tag :li, :class => link_class do
      link_to page_name, site_path(page_param)
    end
  end
  
  def info_link(type,href)
    content_tag :li, link_to(type.to_s.titleize,href), :class => type.to_s
  end
  
  def render_schedule(list=true)
    items = [
      '5:50 pm Doors Open',
      '6:00 pm Andy Hunt',
      '7:00 pm Clinton Nixon',
      '7:45 pm Jamie Pinkham',
      '8:15 pm Mixer',
      '9:00 pm Doors Close'
    ]
    if list
      content_tag :ul, items.map{ |period| content_tag(:li,period) }
    else
      items.map { |period| content_tag(:span,period)+'<br/>' }
    end
  end
  
  def dom_loaded(snippet)
    javascript_tag <<-JavaScript
      document.observe('dom:loaded',function(){ #{snippet} });
    JavaScript
  end
  
  def button_to_link(name, link, options={})
    confirm_option = options.delete(:confirm)
    popup_option = options.delete(:popup)
    link_function = popup_option ? redirect_function(link,:new_window => true) : redirect_function(link)
    link_function = "if (confirm('#{escape_javascript(confirm_option)}')) { #{link_function}; }" if confirm_option
    button_to_function name, link_function, options
  end
  
  def redirect_function(location, options={})
    location = location.is_a?(String) ? location : url_for(location)
    if options[:new_window]
      %|window.open('#{location}')|
    else
      %|{window.location.href='#{location}'}|
    end
  end
  
  
end
