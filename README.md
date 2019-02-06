# Form Builder.cr

<a href='https://github.com/westonganger/form_builder.cr/releases/latest' target='_blank'><img height='21' style='border:0px;height:21px;' src='https://img.shields.io/github/tag/westonganger/form_builder.cr.svg?maxAge=360&label=version' border='0' alt='Version'></a>
<a href='https://travis-ci.org/westonganger/form_builder.cr' target='_blank'><img height='21' style='border:0px;height:21px;' src='https://travis-ci.org/westonganger/form_builder.cr.svg?branch=master' border='0' alt='Build Status'></a>
<a href='https://ko-fi.com/A5071NK' target='_blank'><img height='22' style='border:0px;height:22px;' src='https://az743702.vo.msecnd.net/cdn/kofi1.png?v=a' border='0' alt='Buy Me a Coffee'></a>

Dead simple HTML form builder for Crystal with built-in support for many popular UI libraries such as Bootstrap. Works well with your favourite Crystal web framework such as Kemal, Amber, or Lucky.

# TODO

- Complete FormBuilder::Themes class for each UI Library
- Complete all missing specs

# Features

- Easily generate styled HTML markup for forms, labels, and inputs
- Integrates with many UI libraries such as Bootstrap
- Custom theme support

# Supported UI Libraries

Out of the box Form Builder can generate HTML markup for the following UI libraries:

- Bootstrap 4 - Available form types:
  * `theme: :bootstrap_4_inline`
  * `theme: :bootstrap_4_horizontal`
- Bootstrap 3 - Available form types:
  * `theme: :bootstrap_3_inline`
  * `theme: :bootstrap_3_horizontal`
- Bootstrap 2 - Available form types:
  * `theme: :bootstrap_2_inline`
  * `theme: :bootstrap_2_horizontal`
- Bulma - `theme: :bulma`
- Foundation - `theme: :foundation`
- Materialize - `theme: :materialize`
- Milligram - `theme: :milligram`
- Semantic UI - `theme: :semantic_ui`
- None - (Default) - `theme: nil`, `theme: :default`, or simply do not provide a `:theme` argument

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
== FormBuilder.form(theme: :bootstrap_4_inline, action: "/products", method: :post, form_html: {style: "margin-top: 20px;", "data-foo" => "bar"}) do |f|
  .row
    .col-sm-6
      ### -- Field Options
      ### type : (String | Symbol)
      ### name : (String | Symbol)?
      ### label : (String | Bool)? = true

      ### -- The `input_html["value"]` option will take precedence over the :value option (except for `type: :textarea/:select`)
      ### value : (String | Symbol)?

      ### -- For the following Hash options, String keys will take precedence over any Symbol keys
      ### input_html : (Hash | NamedTuple)? ### contains attributes to be added to the input/field
      ### label_html : (Hash | NamedTuple)? ### contains attributes to be added to the label
      ### wrapper_html : (Hash | NamedTuple)? ### contains attributes to be added to the outer wrapper for the label and input

      ### -- Additional Options for `type: :select`
      ### collection : (Array(Array) | Array | Range)
      ### selected : (String | Array)?
      ### disabled : (String | Array)?

      == f.field name: "product[name]", label: "Name", type: :text

      == f.field name: "product[description]", label: "Description", type: :textarea, input_html: {class: "foobar"}, wrapper_html: {style: "margin-top: 10px"}, label_html: {style: "color: red;"}

      == f.field name: "product[file]", type: :file

    .col-sm-6
      == f.field name: "product[available]", type: :checkbox, label: "In Stock?"

      == f.field name: "product[class]", type: :radio, label: false

      == f.fieldname: "product[secret]", type: :hidden, value: "foobar"

  .row
    - collection = [["A", "Type A"], ["B" "Type B"], ["C", "Type C"]]
    == f.field name: "product[type]", label: "Type", type: :select, collection: collection, selected: ["B"], disabled: ["C"]
```

## FormBuilder in Plain Crystal Code

When using the `FormBuilder.form` method in plain Crystal code, the `<<` syntax is required to add the generated field HTML to the form HTML string, `form_html_str`

```crystal
form_html_str = FormBuilder.form(theme: :bootstrap_4_inline, action: "/products", method: :post, form_html: {style: "margin-top: 20px;", "data-foo" => "bar"}) do |f|
  f << f.field(name: "name", type: :text, label: "Name")
  f << f.field(name: "sku", type: :text, label: "SKU")
  f << "<strong>Hello World</strong>"
end
```

OR you can use the lower level `String.build` instead:

```crystal
form_html_str = String.build do |str|
  str << FormBuilder.form(theme: :bootstrap_4_inline, action: "/products", method: :post, form_html: {style: "margin-top: 20px;", "data-foo" => "bar"}) do |f|
    str << f.field(name: "name", type: :text, label: "Name")
    str << f.field(name: "sku", type: :text, label: "SKU")
    str << "<strong>Hello World</strong>"
  end
end
```

## FormBuilder without a Form

```crystal
- f = FormBuilder::Builder.new(theme: :bootstrap_4_inline)

== f.field name: "name", type: :text, label: "Name"
== f.field name: "sku", type: :text, label: "SKU"
```

## Error Handling

The form builder is capable of handling error messages too. It expects errors in the format of `Hash(String, Array(String))`

```crystal
- errors : Hash(String, Array(String)) = {"name" => ["already taken"], "sku" => ["invalid format", "cannot be blank"]}

== FormBuilder.form(theme: :bootstrap_4_inline, errors: errors) do |f|
  == f.field name: "name", type: :text, label: "Name"
  == f.field name: "sku", type: :text, label: "SKU"
```

## Custom Themes

If you need to create a custom theme simply create an initializer with the following:

```crystal
# config/initializers/form_builder.cr

module FormBuilder
  class Themes
    class Custom < Themes

      ### This method only required if your theme name doesnt perfectly match the `.underscore` of the theme class name
      def self.theme_name
        "custom"
      end

      def wrap_field(field_type : String, html_label : String?, html_field : String, field_errors : Array(String)?, wrapper_html_attributes : Hash(String, String))
        String.build do |str|
          str << "Foo to the Bar"
        end
      end

      def input_html_attributes(html_attrs : Hash(String, String), field_type : String, name : String? = nil, label_text : String? = nil)
        html_attrs["class"] = "form-label other-class"
        html_attrs["style"] = "color: blue;"
        html_attrs["data-foo"] = "bar"
        html_attrs
      end

      def label_html_attributes(html_attrs : Hash(String, String), field_type : String, name : String? = nil, label_text : String? = nil)
        html_attrs["class"] = "form-label other-class"
        html_attrs["style"] = "color: red;"
        html_attrs["data-foo"] = "bar"
        html_attrs
      end

      def form_html_attributes(html_attrs : Hash(String, String))
        html_attrs["class"] = "form-inline"
        html_attrs
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

- [Jasper Helpers](https://github.com/amberframework/jasper-helpers) for use in the [Amber framework](https://github.com/amberframework/amber)
- [SimpleForm](https://github.com/plataformatec/simple_form)

For any consulting or contract work please contact me via my company website: [Solid Foundation Web Development](https://solidfoundationwebdev.com)

[![Solid Foundation Web Development Logo](https://solidfoundationwebdev.com/logo-sm.png)](https://solidfoundationwebdev.com)
