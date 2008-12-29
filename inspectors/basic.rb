class BasicInspector < Merb::Inspector
  builtin
  model Merb::Request, StringIO, IO, String, Symbol, Numeric, Class
end
