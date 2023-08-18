local reactive = {}

function reactive.__call(self, arg)
   if arg == nil then
      return self:get()
   else
      self:set(arg)
   end
end

function reactive.__index(self, key)
   if key == "value" then
      return self:get()
   else
      return reactive[key]
   end
end
function reactive.__newindex(self, key, val)
   if key == "value" then
      return self:set(val)
   else
      error("Cannot set '" .. key .. "' on a reactive object, perhaps you meant 'value." .. key .. "'")
   end
end

--- Creates a new reactive value.
function reactive.new(args)
   local value, setter
   if type(args) == "table" then
      value = args.value
      setter = args.setter
   else
      value = args
   end

   local self = {
      _weak_callbacks = setmetatable({}, {__mode = "kv"}),
      _strong_callbacks = {},
      _value = value,
   }
   if setter == false then
      setter = function() error("This reactive value is read only") end
   end
   if setter ~= nil then
      self.set = setter
   end

   return setmetatable(self, reactive)
end

--- Connect a callback to this value.
--- This callback will be called every time the value changes.
--- @param func function Callback to connect
function reactive:subscribe(func)
   assert(type(func) == "function", "Callback must be a function")
   assert(self._weak_callbacks[func] == nil, "Trying to connect a strong callback which is already connected weakly")
   self._strong_callbacks[func] = true
end

--- Weakly connect a handler to this value.
--- This allows the callback to be garbage collected and will automatically unsubscribe it when that happens.
--- @param func function Handler to connect
function reactive:subscribe_weak(func)
   assert(type(func) == "function", "Callback must be a function")
   assert(self._strong_callbacks[func] == nil, "Trying to connect a weak callback which is already connected strongly")
   self._weak_callbacks[func] = true
end

--- Disconnect a handler from this value.
--- This function will disconnect both weak and strong handlers.
--- @param func function Handler to disconnect
function reactive:unsubscribe(func)
   self._strong_callbacks[func] = nil
   self._weak_callbacks[func] = nil
end

function reactive:set(value)
   self:set_internal(value)
end

function reactive:get()
   return self._value
end

function reactive:set_internal(value)
   if self._value == value then return end
   rawset(self, "_value", value)
   self:emit(value)
end

function reactive:emit(value)
   for func in pairs(self._strong_callbacks) do
      func(value, self)
   end
   for func in pairs(self._weak_callbacks) do
      func(value, self)
   end
end


return setmetatable(reactive, {__call = function(f, ...) return f.new(...) end})
