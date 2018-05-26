

;user config
(define X 5)
(define Y 5)

;available directions
(define (paths start)
  (match-define (maze N M tbl) m)
  (map (lambda (x)
         (let ((first (map = start x))
               (second (map < start x)))
           (cond [(car first)
                  (if (cadr second) 'south 'north)]
                 [else
                  (if (car second) 'east 'west)]) ))
       (connections tbl start)))

;default functions
(struct maze (N M tbl))

(define (connections tbl c) (dict-ref tbl c '()))

(define (connect! tbl c n)
  (dict-set! tbl c (cons n (connections tbl c)))
  (dict-set! tbl n (cons c (connections tbl n))))

(define (connected? tbl a b) (member a (connections tbl b)))

(define (build-maze M N)
  (define tbl (make-hash))
  (define (visited? tbl c) (dict-has-key? tbl c))
  (define (neigbours c)
    (filter
     (match-lambda [(list i j) (and (<= 0 i (- N 1)) (<= 0 j (- M 1)))])
     (for/list ([d '((0 1) (0 -1) (-1 0) (1 0))]) (map + c d))))
  ;;generate the maze
  (let move-to-cell ([c (list (random N) (random M))])
    (for ([n (shuffle (neigbours c))] #:unless (visited? tbl n))
      (connect! tbl c n)
      (move-to-cell n)))
  ;;return the result
  (maze N M tbl))

(define (show-maze m pos)
  (match-define (maze X Y tbl) m)
  (for ([i X]) (display "+---"))
  (displayln "+")
  (for ([j Y])
    (display "|")
    (for ([i (- X 0)])
      (if (equal? (list i j) pos)
          (display " *")
          (display "  "))
      (if (connected? tbl (list i j) (list (+ 1 i ) j))
          (display "  ")
          (display " |")))
   
    (newline)
    (for ([i X])
      (if (connected? tbl (list i j) (list i (+ j 1)))
          (display "+   ")
          (display "+---")))
    (displayln "+")))

(define (move-room room input)
               (cond [(eq? input 'south)
                      (move-x room +)]
                     [(eq? input 'north)
                      (move-x room -)]
                     [(eq? input 'west)
                      (move-y room -)]
                     [(eq? input 'east)
                      (move-y room +)]))

(define (move-x room fun)
  (cons (car room) (map (lambda(x) (fun x 1)) (cdr room))))

(define (move-y room fun)
  (cons (fun (car room) 1) (cdr room)))


