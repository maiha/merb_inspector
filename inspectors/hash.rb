class HashInspector < Merb::Inspector
  builtin
  model Hash
  lead  :size=>[40,20,15]
end
