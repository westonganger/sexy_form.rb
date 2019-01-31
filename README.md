# Form Builder.cr

<a href='https://github.com/westonganger/form_builder.cr/releases/latest' target='_blank'><img height='21' style='border:0px;height:21px;' src='https://img.shields.io/github/tag/westonganger/form_builder.cr.svg?maxAge=360&label=version' border='0' alt='Version' /></a>
<a href='https://travis-ci.org/westonganger/form_builder.cr' target='_blank'><img height='21' style='border:0px;height:21px;' src='https://travis-ci.org/westonganger/form_builder.cr.svg?branch=master' border='0' alt='Build Status' /></a>
<a href='https://ko-fi.com/A5071NK' target='_blank'><img height='22' style='border:0px;height:22px;' src='https://az743702.vo.msecnd.net/cdn/kofi1.png?v=a' border='0' alt='Buy Me a Coffee' /></a> 

Dead simple HTML form builder for Crystal with built-in support for many popular UI libraries such as Bootstrap. Works well with your favourite Crystal web framework such as Kemal, Amber, or Lucky.

# TODO

- Figure out how to convert `**options : Object` to `OptionHash`
- Decide How to Implement Themes
- Implement FormBuilder::Builder according to Theme design
- Complete all missing specs

# Supported UI Libraries

Out of the box Form Builder can generate HTML markup for the following UI libraries:

- Bootstrap 4
- Bootstrap 3
- Bootstrap 2

If you dont see your favourite UI library here feel free to create a PR to add it. I recommend creating an issue to discuss it first.

# Other UI Libraries

I would like to see PR's for the following UI libraries:

- Bulma
- Foundation
- Materialize
- Milligram
- Semantic UI

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
```

```slim
== FormBuilder.form(theme: :bootstrap_4, action: "/products", method: :post, style: "margin-top: 20px;", "data-foo" => "bar") do |f|
  == f.input name: "product[name]", type: :text, ### type is also aliased as :string
  == f.input name: "product[description]", type: :textarea
  == f.input name: "product[type]", type: :select
  == f.input name: "product[available]", type: :checkbox
  == f.input name: "product[class]", type: :radio
  == f.input name: "product[secret]", type: :hidden, value: 'foobar'
  == f.input type: :submit

  == f.label "Just a label"
```

# Error Handling

The form builder expects errors in in the following hash format.

```slim
- errors : Hash(String, Array(String)) = {"name" => ["already taken"], "sku" => ["invalid format", "cannot be blank"]}

== FormBuilder.form(theme: :bootstrap_4, errors: errors) do |f|
  == f.input name: "name", type: :string
  == f.input name: "sku", type: :string
```

# Custom Themes

If you need to create a custom theme simply create an initializer with the following:

```crystal
# config/initializers/form_builder.cr

module FormBuilder::Themes

  module Custom
    # TODO: theme implementations, until then see the src for examples
  end

  module OtherCustom
    # ...
  end
  
end
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
