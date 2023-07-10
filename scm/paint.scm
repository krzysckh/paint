(use "scm/colorscheme.scm")
(use "click")
(use "shapes")

(define draw-pixel
  (lambda (c x y)
    (draw-square c (* pixel-size x) (* pixel-size y) pixel-size pixel-size)))

(define get-every-pos
  (lambda (w h)
    (map (lambda (x y) (map (lambda (y) (list x y)) (range 0 h)))
         (range 0 w)
         (range 0 h))))

(define for-each-pixel
  (lambda (ep f) ; run f for every pos (ep) from get-every-pos
    (for-each (lambda (w)
                (for-each (lambda (x)
                            (f (list-ref x 1) (list-ref x 0))) w)) ep)))

(define init-canvas
  (lambda (len el)
    (if (zero? len)
      '()
      (cons el (init-canvas (- len 1) el)))))

(define get-color-by-pos
  (lambda (x y)
    (list-ref canvas (+ (* y image-size) x))))

(define canv-eq? ; HACK: why doesn't equal? just work?
  (lambda (a b)
    (not (> (sum (map (lambda (x y) (if (equal? x y) 0 1)) a b)) 0))))

(define set-color-by-pos
  (lambda (x y c)
    (define new-canvas (set-nth canvas (+ (* y image-size) x) c))
    (if (eq? (last history) #f)
      (set! history (list canvas)))
    (if (not (canv-eq? (last history) new-canvas))
      (begin
        (set! history (append history `(,new-canvas)))
        (set! canvas new-canvas))))) ; muh mutable

(define undo
  (lambda ()
    (if (> (length history) 0)
      (begin
        (set! canvas (last history))
        (set! history (reverse (cdr (reverse history))))))))

(define create-click-map ; this is a mess
  (lambda (final-f)
    (for-each-pixel
      every-pos
      (lambda (x y)
        (on-click
          `((,(* x pixel-size)
             ,(* y pixel-size))
            (,(+ pixel-size (* x pixel-size))
             ,(+ pixel-size (* y pixel-size))))
          (lambda ()
            (define mx (list-ref (get-mouse-pos) 0))
            (define my (list-ref (get-mouse-pos) 1))
            (for-each-pixel
              every-pos
              (lambda (x y)
                (if (point-in-rect?
                      `(,mx ,my)
                      `((,(* x pixel-size)
                         ,(* y pixel-size))
                        (,(+ (* x pixel-size) pixel-size)
                         ,(+ (* y pixel-size) pixel-size))))
                  (eval (final-f x y current-color))))))
                  (lambda () #t))))))

(define render-paint
  (lambda ()
    (cond
      ((eq? current-mode 'paint) (for-each-pixel
                                   every-pos
                                   (lambda (x y)
                                     (draw-pixel (get-color-by-pos x y) x y))))
      ((eq? current-mode 'color-chooser) (for-each-pixel
                                           every-pos
                                           (lambda (x y)
                                             (draw-pixel
                                               (list-ref
                                                 colorscheme
                                                 (modulo (+ x y) 16))
                                               x y)))))))

(define choose-color
  (lambda (mx my)
    (set! current-mode 'paint)
    (set! click-objs '())
    (create-click-map (lambda (x y c)
                        `(set-color-by-pos ,x ,y ',current-color)))
    (for-each-pixel every-pos
                    (lambda (x y)
                      (if (and (eq? x mx) (eq? y my))
                        (set! current-color
                          (list-ref colorscheme (modulo (+ x y) 16))))))))

(define color-chooser
  (lambda ()
    (set! current-mode 'color-chooser)
    (set! click-objs '()) ; delete clickmap
    (create-click-map (lambda (x y c)
                        `(choose-color ,x ,y)))))

(define every-pos (get-every-pos image-size image-size))
(define canvas (init-canvas (* image-size image-size) c1))
(define current-color c16)

(define history '())
(define current-mode 'paint)
