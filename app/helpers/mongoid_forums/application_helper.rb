module MongoidForums
  module ApplicationHelper
    include FormattingHelper
    # processes text with installed markup formatter
    def mongoid_forums_format(text, *options)
      text = text.gsub(URI::regexp){ |url|
        url = Addressable::URI.parse(url).normalize
        "<a href='#{url}'>#{url.display_uri}</a>"
      }.html_safe
      as_formatted_html(text)
    end

    def mongoid_forums_quote(text)
      as_quoted_text(text)
    end

    def mongoid_forums_markdown(text, *options)
      #TODO: delete deprecated method
      Rails.logger.warn("DEPRECATION: mongoid_forums_markdown is replaced by mongoid_forums_format(), and will be removed")
      forem_format(text)
    end

  end
end
