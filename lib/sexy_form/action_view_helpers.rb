module SexyForm
  module ActionViewHelpers
    def sexy_form(action: nil, method: "post", theme: nil, form_html: {}, &block)
      SexyForm.verify_argument_type(arg_name: :form_html, value: form_html, expected_type: Hash)

      action = action.to_s
      method = method.to_s

      builder = SexyForm::Builder.new(theme: theme)

      themed_form_html = builder.theme.form_html_attributes(html_attrs: self.safe_string_hash(form_html))

      themed_form_html["method"] = (method.to_s == "get" ? "get" : "post")

      if themed_form_html["multipart"] == true
        themed_form_html.delete("multipart")
        themed_form_html["enctype"] = "multipart/form-data"
      end

      str = ""

      str << SexyForm.build_html_element(:form, themed_form_html)

      unless ["get", "post"].include?(method.to_s)
        str << %Q(<input type="hidden" name="_method" value="#{method}")
      end

      if block_given?
        str << capture(builder, &block)
      end

      str << "</form>"

      str.html_safe
    end
  end
end

require "active_support/lazy_load_hooks"

ActiveSupport.on_load(:action_view) do
  include SexyForm::ActionViewHelpers
end
