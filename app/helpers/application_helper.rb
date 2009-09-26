module ApplicationHelper
  
  def top_nav(page_name)
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
