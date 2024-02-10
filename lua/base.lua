function file_exists(path)
  local f = io.open(path)
  if f then
    f:close()
    return true
  end
  return false
end

function with_file(path, mode, fn, on_error)
  local f = io.open(path, mode)
  if f then
    local result = fn(f)
    f:close()
    return result
  end
  if on_error then
    on_error()
  end
end

function write_file(path, contents)
  with_file(path, "w", function(f) f:write(contents) end)
end

function read_file(path)
  return with_file(path, "r", function(f) return f:read("*a") end)
end
