(import-macros {: widget} :lib.widget_macro)
(local gears (require :gears))
(local wibox (require :wibox))
(local awful (require :awful))
(local beautiful (require :beautiful))
(local spotify (require :system.spotify))

(local ICON_SIZE 30)
(local icon_path (.. (gears.filesystem.get_configuration_dir) "assets/icons/"))
(local play_image (gears.color.recolor_image (.. icon_path "play.svg") beautiful.colors.text))
(local pause_image (gears.color.recolor_image (.. icon_path "pause.svg") beautiful.colors.text))

(local cover_image (widget imagebox
                     :image spotify.image
                     :forced_width 80
                     :forced_height 80
                     :clip_shape #(gears.shape.rounded_rect $1 $2 $3 10)))
(local title (widget textbox :font "Roboto Bold 12"))
(local artist (widget textbox :font "Roboto 10"))
(local play_pause_button (widget imagebox
                           :image (gears.color.recolor_image (.. icon_path "play_next.svg") beautiful.colors.text)
                           :forced_width ICON_SIZE
                           :forced_height ICON_SIZE
                           :buttons [(awful.button [] 1 spotify.play_pause)]))

(local w
  (widget background :bg beautiful.colors.base :shape #(gears.shape.rounded_rect $1 $2 $3 10)
    (margin :margins 10
      (fixed.vertical
        (fixed.horizontal :spacing 20
          cover_image
          (place :halign "left"
            (fixed.vertical :spacing 2
              (scroll.horizontal
                :step_function wibox.container.scroll.step_functions.waiting_nonlinear_back_and_forth
                :max_size 180 :speed 80 :fps 60
                title)
              artist)))
        (place
          (margin :top 15 :bottom 5
            (fixed.horizontal :spacing 25
              (imagebox
                :image (gears.color.recolor_image (.. icon_path "play_prev.svg") beautiful.colors.text)
                :forced_width ICON_SIZE
                :forced_height ICON_SIZE
                :buttons [(awful.button [] 1 spotify.previous)])
              play_pause_button
              (imagebox
                :image (gears.color.recolor_image (.. icon_path "play_next.svg") beautiful.colors.text)
                :forced_width ICON_SIZE
                :forced_height ICON_SIZE
                :buttons [(awful.button [] 1 spotify.next)]))))))))
      

(fn update []
  (if (not spotify.available)
      (set w.visible false)

    (do
      (set w.visible true)
      (: cover_image :set_image spotify.image)
      (: title :set_text spotify.title)
      (: artist :set_text spotify.artist)
      (: play_pause_button :set_image (if (spotify.playing) pause_image play_image)))))
(update)
(: spotify.playing :subscribe update)
          
w
