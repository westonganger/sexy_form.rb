# Form Builder.cr

<a href='https://github.com/westonganger/form_builder.cr/releases/latest' target='_blank'><img height='21' style='border:0px;height:21px;' src='https://img.shields.io/github/tag/westonganger/form_builder.cr.svg?maxAge=360&label=version' border='0' alt='Version' /></a>
<a href='https://travis-ci.org/westonganger/form_builder.cr' target='_blank'><img height='21' style='border:0px;height:21px;' src='https://travis-ci.org/westonganger/form_builder.cr.svg?branch=master' border='0' alt='Build Status' /></a>
<a href='https://ko-fi.com/A5071NK' target='_blank'><img height='22' style='border:0px;height:22px;' src='https://az743702.vo.msecnd.net/cdn/kofi1.png?v=a' border='0' alt='Buy Me a Coffee' /></a> 

Dead simple HTML form builder for Crystal with built-in support for many popular UI libraries such as Bootstrap. Works well with your favourite Crystal web framework such as Kemal, Amber, or Lucky.

# TODO

- Figure out how to convert `**options : Object` to `OptionHash` correctly
- Complete FormBuilder::Themes class for each UI Library
- Complete all missing specs

# Features

- Easily generate styled HTML markup for forms, labels, and inputs
- Integrates with many UI libraries such as Bootstrap
- Custom theme support

# Supported UI Libraries

Out of the box Form Builder can generate HTML markup for the following UI libraries:

- Bootstrap 4 - Available form types:
  * `theme: :bootstrap_4_inline` (Default)
  * `theme: :bootstrap_4_horizontal`
- Bootstrap 3 - `theme: :bootstrap_3` - Available form types:
  * `theme: :bootstrap_3_inline` (Default)
  * `theme: :bootstrap_3_horizontal`
- Bootstrap 2 - `theme: :bootstrap_2` - Available form types:
  * `theme: :bootstrap_2_inline` (Default)
  * `theme: :bootstrap_2_horizontal`
- Bulma - `theme: :bulma`
- Foundation - `theme: :foundation`
- Materialize - `theme: :materialize`
- Milligram - `theme: :milligram`
- Semantic UI - `theme: :semantic_ui`
- None (do not provide a `:theme` argument or pass `nil`) - Will simply provide a label and input

If you dont see your favourite UI library here feel free to create a PR to add it. I recommend creating an issue to discuss it first.

# Installation

Add this to your application's shard.yml:

```yaml
dependencies:
  form_builder:
    github: westonganger/form_builder.cr
```

# Usage 

```crystal
require "form_builder"

== FormBuilder.form(theme: :bootstrap_4, action: "/products", method: :post, style: "margin-top: 20px;", "data-foo" => "bar") do |f|
  == f.field name: "product[name]", label: "Name", type: :text

  == f.field name: "product[description]", label: "Description", type: :textarea, input_html: {class: "foobar"}, wrapper_html: {style: "margin-top: 10px"}, label_html: {style: "color: red;"} 

  == f.field name: "product[available]", type: :checkbox, label: "In Stock?"

  == f.field name: "product[class]", type: :radio, label: false

  == f.field name: "product[secret]", type: :hidden, value: 'foobar'

  == f.field name: "product[file]", type: :file

  - collection = [["A", "Type A"], ["B" "Type B"], ["C", "Type C"]]
  
  ### Additional Options for type: :select
  ### collection : Array(Array) | Array | Range
  ### selected : String | Array
  ### disabled : String | Array
  == f.field name: "product[type]", label: "Type", type: :select, collection: collection, selected: product_type, disabled: disabled_product_types
```

# Error Handling

The form builder expects errors in in the following hash format.

```crystal
- errors : Hash(String, Array(String)) = {"name" => ["already taken"], "sku" => ["invalid format", "cannot be blank"]}

== FormBuilder.form(theme: :bootstrap_4, errors: errors) do |f|
  == f.field name: "name", type: :text, label: "Name"
  == f.field name: "sku", type: :text, label: "SKU"
```

# Using FormBuilder without a Form

```crystal
- f = FormBuilder::Builder.new(theme: :bootstrap_4)

== f.field name: "name", type: :text, label: "Name"
== f.field name: "sku", type: :text, label: "SKU"
```

# Custom Themes

If you need to create a custom theme simply create an initializer with the following:

```crystal
# config/initializers/form_builder.cr

module FormBuilder
  class Themes
    class Custom < Themes

      def wrap_field(field_type : String, form_type : String, label_proc : Proc?, input_proc : Proc, errors : Array(String)?, wrapper_html : OptionHash)
        "Foo to the Bar"
      end

      def field_attributes(field_type : String)
        attrs = {} of String => String
        attrs["class"] = "form-label other-class"
        attrs["style"] = ""
        attrs["data-foo"] = "bar"
        attrs
      end

      def label_attributes(field_type : String)
        attrs = {} of String => String
        attrs["class"] = "form-label other-class"
        attrs["style"] = ""
        attrs["data-foo"] = "bar"
        attrs
      end

      ### This method only required if your theme name doesnt perfectly match the `.underscore` of the theme class name
      def self.theme_name
        "custom"
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

We use Ameba, Crystal Format, and Crystal Spec. To run all of these execute the following script:

```
./bin/form_builder_spec
```

# Credits

Created & Maintained by [Weston Ganger](https://westonganger.com) - [@westonganger](https://github.com/westonganger)

For any consulting or contract work please contact me via my company website: [Solid Foundation Web Development](https://solidfoundationwebdev.com)

[![Solid Foundation Web Development Logo](https://solidfoundationwebdev.com/logo-sm.png)](https://solidfoundationwebdev.com)
