module MicropostsHelper

  def wrap(content)
    sanitize(raw(content.split.collect{ |s| wrap_long_string(s) }.join(" ")))
  end

  private

    def wrap_long_string(text, max_width = 30)
      zero_width_space = "&#10;"
      regex = /.{#{max_width}}/
      (text.length < max_width) ? text : text.scan(regex).join(zero_width_space)
    end
end
