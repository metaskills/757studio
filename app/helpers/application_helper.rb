module ApplicationHelper
  
  def top_nav(page_name)
    page_param = page_name.downcase.gsub(/\s/,'_')
    link_class = current_page == page_param ? 'active' : ''
    content_tag :li do
      link_to page_name, site_path(page_param), :class => link_class
    end
  end
  
  
end
