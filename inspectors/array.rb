class ArrayInspector < Merb::Inspector
  builtin
  model Array
  lead  :size=>[40,20,15]
end
