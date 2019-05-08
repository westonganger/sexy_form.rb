# Sexy Form.rb

<a href="https://badge.fury.io/rb/sexy_form" target="_blank"><img height="21" style='border:0px;height:21px;' border='0' src="https://badge.fury.io/rb/sexy_form.svg" alt="Gem Version"></a>
<a href='https://travis-ci.org/westonganger/sexy_form.rb' target='_blank'><img height='21' style='border:0px;height:21px;' src='https://travis-ci.org/westonganger/sexy_form.rb.svg?branch=master' border='0' alt='Build Status'></a>
<a href='https://rubygems.org/gems/sexy_form.rb' target='_blank'><img height='21' style='border:0px;height:21px;' src='https://ruby-gem-downloads-badge.herokuapp.com/sexy_form?label=rubygems&type=total&total_label=downloads&color=brightgreen' border='0' alt='RubyGems Downloads' /></a>
<a href='https://ko-fi.com/A5071NK' target='_blank'><img height='22' style='border:0px;height:22px;' src='https://az743702.vo.msecnd.net/cdn/kofi1.png?v=a' border='0' alt='Buy Me a Coffee'></a>


Dead simple HTML form builder for Ruby with built-in support for many popular UI libraries such as Bootstrap. Pairs nicely with any Ruby web framework such as Rails

# Features

- Easily generate HTML markup for forms, labels, inputs, help text and errors
- Integrates with many UI libraries such as Bootstrap
- Custom theme support

# Supported UI Libraries

Out of the box Form Builder can generate HTML markup for the following UI libraries:

- Bootstrap 4 
  * `theme: :bootstrap_4_vertical`
  * `theme: :bootstrap_4_inline`
  * `theme: :bootstrap_4_horizontal` or `theme: SexyForm::Themes::Bootstrap4Horizontal.new(column_classes: ["col-sm-3","col-sm-9"])`
- Bootstrap 3
  * `theme: :bootstrap_3_vertical`
  * `theme: :bootstrap_3_inline`
  * `theme: :bootstrap_3_horizontal` or `theme: SexyForm::Themes::Bootstrap3Horizontal.new(column_classes: ["col-sm-3","col-sm-9"])`
- Bootstrap 2
  * `theme: :bootstrap_2_vertical`
  * `theme: :bootstrap_2_inline`
  * `theme: :bootstrap_2_horizontal`
- Bulma
  * `theme: :bulma_vertical`
  * `theme: :bulma_horizontal`
- Foundation
  * `theme: :foundation`
- Materialize
  * `theme: :materialize`
- Milligram
  * `theme: :milligram`
- Semantic UI
  * `theme: :semantic_ui_vertical`
  * `theme: :semantic_ui_inline`
- None (Default)
  * `theme: :default`
  * `theme: nil`
  * or simply do not provide a `:theme` argument

If you dont see your favourite UI library here feel free to create a PR to add it. I recommend creating an issue to discuss it first.

# Installation

```ruby
gem "sexy_form"
```

# Usage

The following field types are supported:

- `:checkbox`
- `:file`
- `:hidden`
- `:password`
- `:radio`
- `:select`
- `:text`
- `:textarea`

## SexyForm in View Templates (Example in Slim)

```ruby
= SexyForm.form(theme: :bootstrap_4_vertical, action: "/products", method: :post, form_html: {style: "margin-top: 20px;", "data-foo" => "bar"}) do |f|
  .row.main-examples
    .col-sm-6
      ### -- Field Options
      ### type : (Required)
      ### name : (Optional)
      ### label = true : (Optional) String or Bool
      ### help_text : (Optional)

      ### value : (Optional)
      ### -- Note: The `input_html["value"]` option will take precedence over the :value option (except for `type: :textarea/:select`)

      ### errors : (Optional) String or Array of Strings
      ### -- Note: Using an Array generates a list of help text elements. If you have an Array of errors and you only want a single help text element, then join your errors array to a single String

      ### -- For the following Hash options, String keys will take precedence over any Symbol keys
      ### input_html : (Optional) Hash ### contains attributes to be added to the input/field
      ### label_html : (Optional) Hash ### contains attributes to be added to the label
      ### wrapper_html : (Optional) Hash ### contains attributes to be added to the outer wrapper for the label and input
      ### help_text_html : (Optional) Hash ### contains attributes to be added to the help text container
      ### error_html : (Optional) Hash ### contains attributes to be added to the error container(s) 
 
      = f.field name: "product[name]", label: "Name", type: :text, errors: product_errors["name"]

      = f.field name: "product[description]", label: "Description", type: :textarea, input_html: {class: "foobar"}, wrapper_html: {style: "margin-top: 10px"}, label_html: {style: "color: red;"}

      = f.field name: "product[file]", type: :file, help_text: "Must be a PDF", help_text_html: {style: "color: blue;"}

    .col-sm-6
      = f.field name: "product[available]", type: :checkbox, label: "In Stock?"

      = f.field name: "product[class]", type: :radio, label: false

      = f.field name: "product[secret]", type: :hidden, value: "foobar"

  .row.select-example
    ### -- Additional Options for `type: :select`
    ### collection: {
    ###   options : (Required) Array, Nested Array or String. Note: The non-Array String type is for passing in a pre-built html options string
    ###   selected : (Optional) String or Array of Strings
    ###   disabled : (Optional) String or Array of Strings
    ###   include_blank : (Optional) String or Bool
    ### }
    ### -- Note: String keys will take precedence over any Symbol keys

    ### -- When passing a Nested Array to collection[:options] the Option pairs are defined as: [required_value, optional_label]
    - opts = [["A", "Type A"], ["B" "Type B"], ["C", "Type C"], "Other"]

    = f.field name: "product[type]", label: "Type", type: :select, collection: {options: opts, selected: ["B"], disabled: ["C"]}
```

## SexyForm in Plain Ruby Code

When using the `SexyForm.form` method in plain Ruby code, the `<<` syntax is required to add the generated field HTML to the form HTML string

```ruby
form_html_str = SexyForm.form(theme: :bootstrap_4_vertical, action: "/products", method: :post, form_html: {style: "margin-top: 20px;", "data-foo" => "bar"}) do |f|
  f << f.field(name: "name", type: :text, label: "Name")
  f << f.field(name: "sku", type: :text, label: "SKU")
  f << %Q(<strong>Hello World</strong>"
end
```

## SexyForm without a Form

```ruby
- f = SexyForm::Builder.new(theme: :bootstrap_4_vertical)

= f.field name: "name", type: :text, label: "Name"
= f.field name: "sku", type: :text, label: "SKU"
```

## Error Handling

The form builder is capable of handling error messages too. If the `:errors` argument is provided it will generate the appropriate error help text element(s) next to the field.

```ruby
= SexyForm.form(theme: :bootstrap_4_vertical) do |f|
  = f.field name: "name", type: :text, label: "Name", errors: "cannot be blank"
  = f.field name: "sku", type: :text, label: "SKU", errors: ["must be unique", "incorrect SKU format")
```

## Custom Themes

SexyForm allows you to create custom themes very easily.

Example Usage:

```ruby
SexyForm.form(theme: :custom)
```

Example Theme Class:

```ruby
# config/initializers/sexy_form.rb

module SexyForm
  class Themes
    class Custom < BaseTheme

      ### (Optional) If your theme name doesnt perfectly match the underscored of the theme class name
      def self.theme_name
        "custom"
      end

      ### (Optional) If your theme requires additional variables similar to `Bootstrap3Horizontal.new(columns: ["col-sm-3", "col-sm-9"])`
      def initialize
        ### For an example see `lib/sexy_form/themes/bootstrap_3_horizontal.rb`
      end

      def wrap_field(field_type: , html_field: , html_label: nil, html_help_text: nil, html_errors: nil, wrapper_html_attributes: {})
        s = ""

        wrapper_html_attributes["class"] = "form-group #{wrapper_html_attributes["class"]}".strip

        ### `SexyForm.build_html_attr_string` is the one and only helper method for Themes
        ### It converts any Hash to an HTML Attributes String
        ### Example: {"class" => "foo", "data-role" => "ninja"} converts to "class=\"foo\" data-role=\"ninja\""
        attr_str = SexyForm.build_html_attr_string(wrapper_html_attributes)

        s << "#{attr_str.empty? ? "<div>" : (<div #{attr_str}>)}"

        if ["checkbox", "radio"].include?(field_type) && html_label && (i = html_label.index(">"))
          s << html_label.insert(i+1, "#{html_field} ")
        else
          s << "#{html_label}"
          s << "#{html_field}"
        end
        
        s << "#{html_help_text}"
        
        if html_errors
          s << html_errors.join
        end

        s << "</div>"

        s
      end

      def input_html_attributes(field_type: , has_errors: , html_attrs:)
        html_attrs["class"] = "form-field other-class #{html_attrs["class"]}".strip
        html_attrs["style"] = "color: blue; #{html_attrs["style"]}".strip
        
        unless html_attrs.has_key?("data-foo")
          html_attrs["data-foo"] = "bar"
        end
        
        html_attrs
      end

      def label_html_attributes(html_attrs: , field_type: , has_errors:)
        html_attrs["class"] = "form-label other-class #{html_attrs["class"]}".strip
        html_attrs["style"] = "color: red; #{html_attrs["style"]}".strip
        html_attrs
      end

      def form_html_attributes(html_attrs:)
        html_attrs["class"] = "form-inline #{html_attrs["class"]}"
        html_attrs
      end

      def build_html_help_text(help_text: , html_attrs:)
        html_attrs["class"] = "help-text #{html_attrs["class"]}".strip

        s = ""
        s << (html_attrs.empty? ? "<div>" : "<div #{build_html_attr_string(html_attrs)}>")
        s << "#{help_text}"
        s << "</div>"
        s
      end

      def build_html_error(error: , html_attrs:)
        html_attrs["class"] = "help-text error #{html_attrs["class"]}".strip
        html_attrs["style"] = "color: red; #{html_attrs["style"]}".strip

        s = ""
        s << (html_attrs.empty? ? "<div>" : "<div #{build_html_attr_string(html_attrs)}>")
        s << "#{error}"
        s << "</div>"
        s
      end

    end
  end
end
```

# Crystal Alternative

This library was originally written for Crystal language as [FormBuilder.cr](https://github.com/westonganger/form_builder.cr)

The pattern/implementation of FormBuilder.cr turned out so beautifully that I felt the desire to have the same syntax available in the Ruby language. Many Ruby developers also write Crystal and vice versa so this only made sense. What was awesome is that, the Crystal and Ruby syntax is so similar that converting Crystal code to Ruby was straight forward and quite simple.

# Credits

Created & Maintained by [Weston Ganger](https://westonganger.com) - [@westonganger](https://github.com/westonganger)

For any consulting or contract work please contact me via my company website: [Solid Foundation Web Development](https://solidfoundationwebdev.com)

[![Solid Foundation Web Development Logo](https://solidfoundationwebdev.com/logo-sm.png)](https://solidfoundationwebdev.com)
