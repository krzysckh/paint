(define save-image
  (lambda ()
    (define of (open-output-file "image.ppm"))
    (for-each (lambda (c) (write-char c of))
              (string->list
                (string-append "P3\n"
                               (number->string image-size) "\n"
                               (number->string image-size) "\n"
                               (number->string 255) "\n")))
    (for-each-pixel every-pos
                    (lambda (x y)
                      (print "")
                      (for-each (lambda (z) (print z) (display z of) (newline of))
                                (get-color-by-pos x y))))))
