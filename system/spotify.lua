local awful = require "awful"
local gears = require "gears"
local reactive = require "lib.reactive"
local dbus_proxy = require "lib.dbus_proxy"

local OBJECT = "org.mpris.MediaPlayer2.spotify"

local image_path = gears.filesystem.get_cache_dir() .. "spotify_images/"
gears.filesystem.make_directories(image_path)

local proxy

local spotify = {
   available = false,
   playing = reactive {
      setter = function(_, value)
         if value then
            proxy:Play()
         else
            proxy:Pause()
         end
      end
   },
   position = reactive {
      setter = function(value)
         value = value * 1000000
         proxy:SetPosition(proxy.Metadata["mpris:trackid"], value)
      end
   }
}

local opts = {
   bus = dbus_proxy.Bus.SESSION,
   name = OBJECT,
   interface = "org.mpris.MediaPlayer2.Player",
   path = "/org/mpris/MediaPlayer2"
}
proxy = dbus_proxy.monitored.new(opts, function(p, appeared)
   if appeared then
      p:on_properties_changed(spotify.update)
      p:connect_signal(spotify.update, "Seeked")
   end
   spotify.update()
end)

function spotify.download_image()
   local filename = image_path .. string.match(spotify.image_url, "/([^/]+)$") .. ".png"

   if gears.filesystem.file_readable(filename) then
      spotify.image = filename
      return
   end

   local cmd = [[bash -c 'wget --quiet --output-document - %s | convert - %s']]
   awful.spawn.easy_async(string.format(cmd, spotify.image_url, filename), function(_, _, _, exit_code)
      if exit_code == 0 then
         spotify.image = filename
      else
         spotify.image = nil
      end
      spotify.playing:emit()
   end)
end

function spotify.update()
   spotify.available = proxy.is_connected
   if proxy.is_connected then
      spotify.image_url = proxy.Metadata["mpris:artUrl"]
      spotify.download_image()

      spotify.length = proxy.Metadata["mpris:length"]
      if spotify.length then
         spotify.length = spotify.length / 1000000
      end

      spotify.title = proxy.Metadata["xesam:title"]
      spotify.artist = proxy.Metadata["xesam:artist"][1]
      spotify.position:set_internal(proxy.Position)

      rawset(spotify.playing, "_value", proxy.PlaybackStatus == "Playing")
   end
   spotify.playing:emit()
end

function spotify.next()
   if not proxy.is_connected then return end
   proxy:Next()
end
function spotify.previous()
   if not proxy.is_connected then return end
   proxy:Previous()
end

function spotify.play_pause()
   if not proxy.is_connected then return end
   proxy:PlayPause()
end

return spotify
