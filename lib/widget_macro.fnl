(local stdlib-widgets
       {:widget [:calendar
                 :checkbox
                 :graph
                 :imagebox
                 :piechart
                 :progressbar
                 :separator
                 :slider
                 :systray
                 :textbox
                 :textclock]
        :container [:arcchart
                    :background
                    :constraint
                    :margin
                    :mirror
                    :place
                    :radialprogressbar
                    :rotate
                    :scroll.horizontal
                    :scroll.vertical
                    :scroll
                    :tile]
        :layout [:align.horizontal
                 :align.vertical
                 :fixed.horizontal
                 :fixed.vertical
                 :flex.horizontal
                 :flex.vertical
                 :grid
                 :grid.horizontal
                 :grid.vertical
                 :manual
                 :ratio.horizontal
                 :ratio.vertical
                 :stack]})
                 

(var widget-map nil)
(fn get-widget-map []
  (when (= widget-map nil)
    (set widget-map {})
    (each [namespace widgets (pairs stdlib-widgets)]
      (each [_ widget (ipairs widgets)]
        (tset widget-map widget namespace))))
  widget-map)

(fn find-widget [widget wibox]
  (let [namespace (. (get-widget-map) widget)]
    (if namespace
        (sym (.. (tostring wibox) :. namespace :. widget))
      (sym widget))))

(fn widget-inner [wibox name & rest_]
  (var rest rest_)
  (let [result {:widget (find-widget (tostring name) wibox)}]
    (while (> (length rest) 0)
      (case rest
        (where [inner & xs] (and (list? inner) (> (length inner) 0)))
        (do
          (table.insert result (widget-inner wibox (unpack inner)))
          (set rest xs))

        (where [symbol & xs] (sym? symbol))
        (do
          (table.insert result symbol)
          (set rest xs))

        (where [key val & xs] (= (type key) :string))
        (do
          (tset result key val)
          (set rest xs))

        _ (assert-compile false "Expected a list or keyword argument" name)))
    result))
      
  
  
(fn widget [...]
  (let [wibox (gensym :wibox)
        widgets (widget-inner wibox ...)]
    `(let [,wibox (require :wibox)]
         ((. ,wibox :widget) ,widgets))))

{: widget}

