require "./form_builder/*"

module FormBuilder
  alias OptionHash = Hash(Symbol, Nil | String | Symbol | Bool | Int8 | Int16 | Int32 | Int64 | Float32 | Float64 | Time | Bytes | Array(String) | Array(Int32) | Array(String | Int32))

  include Tags
  include Forms
end
