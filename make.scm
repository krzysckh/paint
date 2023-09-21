(use "make")
; no resources

(define-resource "scm/colorscheme.scm")
(define-resource "scm/init.scm")
(define-resource "scm/paint.scm")
(define-resource "scm/save.scm")

(set-executable-name 'local "paint")
(set-executable-name 'win64 "paint.exe")

(set-target '(local win64))

(make)
