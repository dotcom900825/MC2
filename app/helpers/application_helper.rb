# coding: utf-8
module ApplicationHelper

  def render_the_flash
    return unless flash[:notice] or flash[:error] or flash[:warning]
    the_class = flash[:error] ? 'error' : 'success'

    html = "<div class='alert alert-#{the_class}'>"
    html << "<a class='close' href='#'>×</a>"
    html << render_flash rescue nil
    html << "</div>"
  end

  def render_flash
    output = []
    for key,value in flash
      output << "<span class=\'#{key.to_s.downcase}\'>#{value}</span>"
    end if flash
    output.join("<br />\n")
  end
  
  def link_back
    backlink = request.env["HTTP_REFERER"]
    if backlink.blank? || (backlink.include? "blog/articles/new")
      backlink = '/'
    end
    link_to "×", backlink ,{:title => "关闭" ,:class => "close"}
  end

end
