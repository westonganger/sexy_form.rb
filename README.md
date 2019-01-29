[![Build Status](https://travis-ci.org/westonganger/form_builder.svg?branch=master)](https://travis-ci.org/https://travis-ci.org/westonganger/form_builder)

# Form Builder.cr

Dead simple HTML form builder for Crystal with built-in support for many popular UI libraries. Works well with your favourite web framework such as Kemal, Amber, or Lucky.

## Supported UI Libraries

Out of the box Form Builder can generate HTML markup for the following UI libraries:

- Bootstrap 4
- Bootstrap 3
- Bootstrap 2
- Bulma (PR Wanted)
- Foundation (PR Wanted)
- Materialize (PR Wanted)
- Milligram (PR Wanted)
- Semantic UI (PR Wanted)

If you dont see your favourite UI library here feel free to create a PR to add it. I recommend creating an issue to discuss it first.

## Installation

Add this to your application's shard.yml:

```yaml
dependencies:
  form_builder:
    github: westonganger/form_builder
```

## Usage 

```crystal
require "form_builder"
```

```slim
== FormBuilder.form(theme: :bootstrap_4) do |f|
  == f.input name: "product[name]", type: :string, 
  == f.input name: "product[description]", type: :text
  == f.input name: "product[type]", type: :select
  == f.input name: "product[available]", type: :checkbox
  == f.input name: "product[class]", type: :radio
  == f.input type: :submit
```

## Error Handling

The form builder expects errors in in the following hash format.

```slim
- errors = {name: ['already taken'], sku: ['invalid format', 'cannot be blank']}

== FormBuilder.form(theme: :bootstrap_4, errors: errors) do |f|
  == f.input name: "name", type: :string
  == f.input name: "sku", type: :string
```

## Credits

Created & Maintained by [Weston Ganger](https://westonganger.com) - [@westonganger](https://github.com/westonganger)

For any consulting or contract work please contact me via my company website: [Solid Foundation Web Development](https://solidfoundationwebdev.com)

[![Solid Foundation Web Development Logo](https://solidfoundationwebdev.com/logo-sm.png)](https://solidfoundationwebdev.com)
