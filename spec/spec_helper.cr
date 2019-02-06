require "spec"
require "../src/form_builder"

alias StringHash = Hash(String, String)

FIELD_TYPES = {"checkbox", "file", "hidden", "password", "radio", "select", "text", "textarea"}
INPUT_TYPES = FIELD_TYPES.to_a - ["select", "textarea"]
