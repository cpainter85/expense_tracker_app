# Replicates method as designed by: https://jeremysmith.co/posts/2015-12-09-custom-currency-input-for-simple-form/

class CurrencyInput < SimpleForm::Inputs::Base
  def input(wrapper_options)
    merged_input_options = merge_wrapper_options(input_html_options, wrapper_options)

    content_tag(:div, input_group("$", merged_input_options), class: "input-group")
  end

  private

  def input_group(currency, merged_input_options)
    "#{currency_addon(currency)} #{@builder.text_field(attribute_name, merged_input_options)}".html_safe
  end

  def currency_addon(currency)
    content_tag(:span, currency, class: "input-group-text")
  end
end