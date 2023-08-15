local gtimer = require "gears".timer
local aspawn = require "awful".spawn

return function(args)
   local kill_command = args.kill_command or ("killall " .. string.match(args.command, "^[^ ]+"))
   local timer = gtimer {
      timeout = args.timeout or 5,
      single_shot = true,
   }

   timer:connect_signal("timeout", function()
      aspawn.easy_async(kill_command, function()
         aspawn.with_line_callback(args.command, {
            stdout = args.stdout,
            stderr = args.stderr,
            exit = function()
               print(args.command .. " ended, restarting")
               timer:again()
            end
         })
      end)
   end)
   timer:emit_signal "timeout"
end
