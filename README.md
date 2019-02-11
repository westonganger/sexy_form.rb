# Form Builder.cr

<a href='https://github.com/westonganger/form_builder.cr/releases/latest' target='_blank'><img height='21' style='border:0px;height:21px;' src='https://img.shields.io/github/tag/westonganger/form_builder.cr.svg?maxAge=360&label=version' border='0' alt='Version'></a>
<a href='https://travis-ci.org/westonganger/form_builder.cr' target='_blank'><img height='21' style='border:0px;height:21px;' src='https://travis-ci.org/westonganger/form_builder.cr.svg?branch=master' border='0' alt='Build Status'></a>
<a href='https://ko-fi.com/A5071NK' target='_blank'><img height='22' style='border:0px;height:22px;' src='https://az743702.vo.msecnd.net/cdn/kofi1.png?v=a' border='0' alt='Buy Me a Coffee'></a>

Dead simple HTML form builder for Crystal with built-in support for many popular UI libraries such as Bootstrap. Works well with your favourite Crystal web framework such as Kemal, Amber, or Lucky.

# TODO

- Complete all missing specs

# Features

- Easily generate HTML markup for forms, labels, inputs, help text and errors
- Integrates with many UI libraries such as Bootstrap
- Custom theme support

# Supported UI Libraries

Out of the box Form Builder can generate HTML markup for the following UI libraries:

- Bootstrap 4 
  * `theme: :bootstrap_4_vertical`
  * `theme: :bootstrap_4_inline`
  * `theme: :bootstrap_4_horizontal` or `theme: FormBuilder::Themes::Bootstrap4Horizontal.new(column_classes: ["col-sm-3","col-sm-9"])`
- Bootstrap 3
  * `theme: :bootstrap_3_vertical`
  * `theme: :bootstrap_3_inline`
  * `theme: :bootstrap_3_horizontal` or `theme: FormBuilder::Themes::Bootstrap3Horizontal.new(column_classes: ["col-sm-3","col-sm-9"])`
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

Add this to your application's shard.yml:

```yaml
dependencies:
  form_builder:
    github: westonganger/form_builder.cr
```

```crystal
require "form_builder"
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

## FormBuilder in View Templates (Kilt, Slang, ECR, etc.)

```crystal


== FormBuilder.form(theme: :bootstrap_4_vertical, action: "/products", method: :post, form_html: {style: "margin-top: 20px;", "data-foo" => "bar"}) do |f|
  .row.main-examples
    .col-sm-6
      ### -- Field Options
      ### type : (String | Symbol)
      ### name : (String | Symbol)?
      ### label : (String | Bool)? = true
      ### help_text : String?

      ### value : (String | Symbol)?
      ### -- Note: The `input_html["value"]` option will take precedence over the :value option (except for `type: :textarea/:select`)

      ### errors : (Array(String) | String)?
      ### -- Note: Array(String) generates a list of help text elements. If you have an Array of errors and you only want a single help text element, then join your errors array to a String

      ### -- For the following Hash options, String keys will take precedence over any Symbol keys
      ### input_html : (Hash | NamedTuple)? ### contains attributes to be added to the input/field
      ### label_html : (Hash | NamedTuple)? ### contains attributes to be added to the label
      ### wrapper_html : (Hash | NamedTuple)? ### contains attributes to be added to the outer wrapper for the label and input
      ### help_text_html : (Hash | NamedTuple)? ### contains attributes to be added to the outer wrapper for the label and input
 
      == f.field name: "product[name]", label: "Name", type: :text, errors: product_errors["name"]

      == f.field name: "product[description]", label: "Description", type: :textarea, input_html: {class: "foobar"}, wrapper_html: {style: "margin-top: 10px"}, label_html: {style: "color: red;"}

      == f.field name: "product[file]", type: :file, help_text: "Must be a PDF", help_text_html: {style: "color: blue;"}

    .col-sm-6
      == f.field name: "product[available]", type: :checkbox, label: "In Stock?"

      == f.field name: "product[class]", type: :radio, label: false

      == f.field name: "product[secret]", type: :hidden, value: "foobar"

  .row.select-example
    ### -- Additional Options for `type: :select`
    ### collection : (Hash | NamedTuple) = {
    ###   options : (Array(Array) | Array | String) ### Required, Note: String type is for passing in a pre-built html options string
    ###   selected : (String | Array)?
    ###   disabled : (String | Array)?
    ### }
    ### -- Note: String keys will take precedence over any Symbol keys

    ### -- When passing Array(Array) to collection[:options] the Option pairs are defined as: [required_value, optional_label]
    - opts = [["A", "Type A"], ["B" "Type B"], ["C", "Type C"]]

    == f.field name: "product[type]", label: "Type", type: :select, collection: {options: opts, selected: ["B"], disabled: ["C"]}
```

## FormBuilder in Plain Crystal Code

When using the `FormBuilder.form` method in plain Crystal code, the `<<` syntax is required to add the generated field HTML to the form HTML string

```crystal
form_html_str = FormBuilder.form(theme: :bootstrap_4_vertical, action: "/products", method: :post, form_html: {style: "margin-top: 20px;", "data-foo" => "bar"}) do |f|
  f << f.field(name: "name", type: :text, label: "Name")
  f << f.field(name: "sku", type: :text, label: "SKU")
  f << "<strong>Hello World</strong>"
end
```

OR you can use the lower level `String.build` instead:

```crystal
form_html_str = String.build do |str|
  str << FormBuilder.form(theme: :bootstrap_4_vertical, action: "/products", method: :post, form_html: {style: "margin-top: 20px;", "data-foo" => "bar"}) do |f|
    str << f.field(name: "name", type: :text, label: "Name")
    str << f.field(name: "sku", type: :text, label: "SKU")
    str << "<strong>Hello World</strong>"
  end
end
```

## FormBuilder without a Form

```crystal
- f = FormBuilder::Builder.new(theme: :bootstrap_4_vertical)

== f.field name: "name", type: :text, label: "Name"
== f.field name: "sku", type: :text, label: "SKU"
```

## Error Handling

The form builder is capable of handling error messages too. If the `:errors` argument is provided it will generate the appropriate error help text element(s) next to the field.

```crystal
== FormBuilder.form(theme: :bootstrap_4_vertical) do |f|
  == f.field name: "name", type: :text, label: "Name", errors: "cannot be blank"
  == f.field name: "sku", type: :text, label: "SKU", errors: ["must be unique", "incorrect SKU format")
```

## Custom Themes

If you need to create a custom theme simply create an initializer with the following:

```crystal
# config/initializers/form_builder.cr

module FormBuilder
  class Themes
    class Custom < Themes

      ### (Optional) If your theme name doesnt perfectly match the `.underscore` of the theme class name
      def self.theme_name
        "custom"
      end

      ### (Optional) If your theme requires additional variables similar to `Bootstrap3Horizontal.new(columns: ["col-sm-3", "col-sm-9"])`
      def initialize
        ### For an example see `src/form_builders/themes/bootstrap_3_horizontal.cr`
      end

      def wrap_field(field_type : String, html_field : String, html_label : String?, html_help_text : String?, html_errors : Array(String)?, wrapper_html_attributes : StringHash)
        String.build do |s|
          wrapper_html_attributes["class"] = "form-group #{wrapper_html_attributes["class"]?}".strip

          ### `FormBuilder.build_html_attr_string` is the one and only helper method for Themes
          ### It converts any Hash to an HTML Attributes String
          ### Example: {"class" => "foo", "data-role" => "ninja"} converts to "class=\"foo\" data-role=\"ninja\""
          attr_str = FormBuilder.build_html_attr_string(wrapper_html_attributes)

          s << "#{attr_str.empty? ? "<div>" : %(<div #{attr_str}>)}"

          if {"checkbox", "radio"}.includes?(field_type) && html_label && (i = html_label.index(">"))
            s << html_label.insert(i+1, "#{html_field} ")
          else
            s << html_label
            s << html_field
          end
          
          s << html_help_text

          s << "</div>"
        end
      end

      def input_html_attributes(html_attrs : Hash(String, String), field_type : String, has_errors? : Bool)
        html_attrs["class"] = "form-field other-class #{html_attrs["class"]?}".strip
        html_attrs["style"] = "color: blue; #{html_attrs["style"]?}".strip
        html_attrs["data-foo"] = "bar #{html_attrs["class"]?}"
        html_attrs
      end

      def label_html_attributes(html_attrs : Hash(String, String), field_type : String, has_errors? : Bool)
        html_attrs["class"] = "form-label other-class #{html_attrs["class"]?}".strip
        html_attrs["style"] = "color: red; #{html_attrs["style"]?}".strip
        html_attrs["data-foo"] = "bar #{html_attrs["class"]?}"
        html_attrs
      end

      def form_html_attributes(html_attrs : Hash(String, String))
        html_attrs["class"] = "form-inline #{html_attrs["class"]}"
        html_attrs
      end

      def build_html_help_text(help_text : String, html_attrs : StringHash)
        html_attrs["class"] = "help-text #{html_attrs["class"]?}".strip

        String.build do |s|
          s << html_attrs.empty? ? "<div>" : %(<div #{build_html_attr_string(html_attrs)}>)
          s << help_text
          s << "</div>"
        end
      end

      def build_html_error(error : String, html_attrs : StringHash)
        html_attrs["class"] = "help-text error #{html_attrs["class"]?}".strip
        html_attrs["style"] = "color: red; #{html_attrs["style"]?}".strip

        String.build do |s|
          s << html_attrs.empty? ? "<div>" : %(<div #{build_html_attr_string(html_attrs)}>)
          s << error
          s << "</div>"
        end
      end

    end
  end
end
```

Now you can use the theme just like any other built-in theme.

```crystal
FormBuilder.form(theme: :custom)
```

# Contributing

We use Ameba and Crystal Spec. To run all of these execute the following script:

```
./bin/form_builder_spec
```

# Credits

Created & Maintained by [Weston Ganger](https://westonganger.com) - [@westonganger](https://github.com/westonganger)

Project Inspired By:

- [Jasper Helpers](https://github.com/amberframework/jasper-helpers) used within the [Amber framework](https://github.com/amberframework/amber)
- [SimpleForm](https://github.com/plataformatec/simple_form)

For any consulting or contract work please contact me via my company website: [Solid Foundation Web Development](https://solidfoundationwebdev.com)

[![Solid Foundation Web Development Logo](https://solidfoundationwebdev.com/logo-sm.png)](https://solidfoundationwebdev.com)
