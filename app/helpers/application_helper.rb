module ApplicationHelper
  
  NAV_PAGES = ['Home','Who Should Attend','Presenters','Sponsors']
  
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
  
  
end
