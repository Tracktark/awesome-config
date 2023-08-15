local base = {
   _updater_callback = nil,
}
base.__index = base

function base:set_updater(updater)
   if updater["property"] ~= nil then -- Property based updater
      self._updater_callback = function()
         self:set_from_updater(updater.object[updater.property])
      end
      self._updater_callback()

      updater.object:weak_connect_signal("property::" .. updater.property, self._updater_callback)
      self.callback = function()
         updater.object[updater.property] = self:get_for_updater()
      end
   else -- Callback based updater
      self._updater_callback = function()
         updater.callback(self)
      end
      updater.object:weak_connect_signal(updater.signal, self._updater_callback)
   end
end

return base
