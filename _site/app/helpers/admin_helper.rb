module AdminHelper
  #Creates a link to `path` for the menu bar with label `label
  #@param [String] label the label for the link
  #@param [String] path the path the link points to
  #@return [String] the html for the menubar link
  def menu_bar_link(label, path)
    style = "/admin/#{controller_name}" == path ? "active" : ''
    content_tag(:li, :class => style) do
      link_to label, path
    end
  end
end
