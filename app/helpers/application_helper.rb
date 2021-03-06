module ApplicationHelper
  class HTMLwithPygments < Redcarpet::Render::HTML
    def block_code(code, language)
      sha = Digest::SHA1.hexdigest(code)
      Rails.cache.fetch ["code", language, sha].join('-') do
        Pygments.highlight(code, lexer: language)
      end
    end
  end

  def markdown(text)
    renderer = HTMLwithPygments.new(hard_wrap: true, filter_html: true)
    options = {
      autolink: true,
      no_intra_emphasis: true,
      fenced_code_blocks: true,
      lax_html_blocks: true,
      strikethrough: true,
      superscript: true
    }
    Redcarpet::Markdown.new(renderer, options).render(text).html_safe
  end

  def remove_icon
    draw_icon 'remove'
  end

  def draw_icon(icon, opts={})
    opts[:class] = "glyphicon glyphicon-#{icon} #{opts[:class]}"
    content_tag :span, nil, opts
  end

  def ejs(val)
    escape_javascript val
  end

  def get_event_type_class(event_type)
    case event_type
    when 'scrap_created'
      'label-success'
    when 'started_observing'
      'label-info'
    when 'starred'
      'label-warning'
    end
  end
end
