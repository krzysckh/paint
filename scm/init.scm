(use "core")
(use "colors")

(define win-scale 640)
(set-window-option '(noresizable))

(define image-size 16)

(define pixel-size (/ (get-window-width) image-size))

(use "scm/paint.scm")
(use "scm/save.scm")

(define on-load
  (lambda ()
    (set-window-size win-scale win-scale)
    (create-click-map
      (lambda (x y c)
        `(set-color-by-pos ,x ,y ',current-color)))))

(define update-screen
  (lambda ()
    (if (is-key-pressed "u") (undo))
    (if (is-key-pressed "c") (color-chooser))
    (if (is-key-pressed "s") (save-image))
    (if (is-key-pressed "q") (set-window-option "nowindow"))

    (set! mouse-holding #f)
    ; HACK: because of ui.scm fuckery (which DOES NOT work yet)
    (handle-click)
    (render-paint)))
