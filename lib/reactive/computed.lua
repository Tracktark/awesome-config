local reactive = require "lib.reactive.reactive"

return function (args)
   local ret = reactive {
      setter = args.setter,
      value = args.value(),
   }

   local function update()
      ret:set_internal(args.value())
   end

   for _, dependency in ipairs(args.dependencies) do
      dependency:subscribe(update)
   end
   return ret
end
