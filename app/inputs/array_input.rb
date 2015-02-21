class ArrayInput < SimpleForm::Inputs::StringInput
  include ActionView::Helpers::TagHelper
  include ActionView::Context

  TEXT_FIELD_CLASSES = "text optional array-element"

  def input(_wrapper_options)
    input_html_options[:type] ||= input_type

    content_tag(:div, class: "array-input") do
      Array(attributes).map do |element|
        text_field_for(element)
      end.join.html_safe + add_field_html
    end
  end

  def input_type
    :text
  end

  private

  def attributes
    object.public_send(attribute_name)
  end

  def text_field_for(element)
    @builder.text_field(
      nil,
      input_html_options.merge(
        value: element,
        name: "#{object_name}[#{attribute_name}][]",
        class: TEXT_FIELD_CLASSES
      )
    )
  end

  def add_field_html
    <<-HTML.html_safe
      <a href="#" onclick="add_field()" class="add">Add URL</a>
      <script>
        function add_field(e)
        {
          var form = $(".input.organization_urls .array")[0],
          input = document.createElement("input");
          input.setAttribute("class", "#{TEXT_FIELD_CLASSES}");
          input.setAttribute("id", "organization_");
          input.setAttribute("name", "organization[urls][]");
          input.setAttribute("type", "text");
          add_link = $(".input.organization_urls .add")[0];
          form.insertBefore(input, add_link);
        };
      </script>
    HTML
  end
end
