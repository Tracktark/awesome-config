local reactive = require "lib.reactive.reactive"
local computed = require "lib.reactive.computed"

return setmetatable({
   reactive = reactive,
   computed = computed,
}, {
   __call = function(_, ...) return reactive(...) end
})
