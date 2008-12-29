class BasicInspector < Merb::Inspector
  model Merb::Request, StringIO, IO, String, Symbol, Numeric, Class
end
