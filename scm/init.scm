(use "core")
(use "colors")

(define win-scale 640)

(define image-size 32)

(set-window-size win-scale win-scale)
(set-window-option '(noresizable))

(define pixel-size (/ (get-window-width) image-size))

(use "scm/paint.scm")

(define on-load
  (lambda ()
    (create-click-map
      (lambda (x y c)
        `(set-color-by-pos ,x ,y ',current-color)))))

(define update-screen
  (lambda ()
    (if (is-key-pressed "u") (undo))
    (if (is-key-pressed "c") (color-chooser))
    (handle-click)
    (render-paint)))
