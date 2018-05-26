#lang racket



(include "MudAssoc.rkt")
(include "MudObjects.rkt")
(include "MudMaze.rkt")

(require srfi/1)
(require srfi/13)
(require srfi/48)

(define (assq-ref assqlist id)
  (cadr (assq id assqlist)))
(define m (build-maze X Y)) ;;build the maze

(define objectdb (make-hash))
(define inventorydb (make-hash))
(define rooms (make-hash))
(define gem "")

;random start point location
(define (startpoint)
  (let*((start_x (random X))
        (start_y (random Y)))
  (list start_x start_y)))

;; Returns a path connecting two given cells in the maze
;; find-path :: Maze Cell Cell -> (Listof Cell)


(define (random-key-location db types)
  (for ((i (length types)))
    (add-object db (list (random X) (random Y)) (car (assq-ref types i assq)))))

(define (slist->string l)
  (string-join (map symbol->string l)))

(define (get-directions id)
  (let ((record (assq id decisiontable)))
    (let* ((result (filter (lambda (n) (number? (second n))) (cdr record)))
           (n (length result)))
      (cond ((= 0 n)
             (printf "You appear to have entered a room with no exits.\n"))
            ((= 1 n)
             (printf "You can see an exit to the ~a.\n" (slist->string (caar result))))
            (else
             (let* ((losym (map (lambda (x) (car x)) result))
                    (lostr (map (lambda (x) (slist->string x)) losym)))
               (printf "You can see exits to the ~a.\n" (string-join lostr " and "))))))))

;room allocator

(define (random-allocator db types rate)
  (for ((j X))
    (for ((i Y))
      (cond ((<= (random 100) rate)
             (cond((equal? db rooms) ; add the name to the room
                   (hash-set! db (list j i) (car( ass-ref types (random (- (length types) 1)) assq))))
                  (else ;add to objectdb
                   (add-object db (list j i) (car (ass-ref types (random (- (length types) 1)) assq))))))))))

;random gem location
(define (random-gem-location db types)
  (for ((i (length types)))
    (add-object db (list (random X) (random Y)) (car (ass-ref types i assq)))))

(define (ass-ref assqlist id x)
  (cdr (x id assqlist)))

(define (get-keywords id)
  (let ((keys (ass-ref decisiontable id assq)))
    (map (lambda (key) (car key)) keys)))


;; outputs a list in the form: (0 0 0 2 0 0)
(define (list-of-lengths keylist tokens)
  (map 
   (lambda (x)
     (let ((set (lset-intersection eq? tokens x)))
       ;; apply some weighting to the result
       (* (/ (length set) (length x)) (length set))))
   keylist))

(define (index-of-largest-number list-of-numbers)
  (let ((n (car (sort list-of-numbers >))))
    (if (zero? n)
      #f
      (list-index (lambda (x) (eq? x n)) list-of-numbers))))

(define (call-actions id tokens func)
  (let* ((record (ass-ref decisiontable 1 assv)) 
         (keylist (get-keywords 1)) 
        
         (index (index-of-largest-number (list-of-lengths keylist tokens)))) 
    (if index 
        (func (list-ref record index)) 
        #f)))

(define (door-handle gem)
  (printf "You can see the exit gate, but it is locked. \n")
  (cond ((hash-has-key? inventorydb 'bag)
         (let* ((record (hash-ref inventorydb 'bag)) 
                (result (remove (lambda (x) (string-suffix-ci? gem x)) record)) 
                (item (lset-difference equal? record result))) 
           (cond ((null? item) 
               #t))))
        (else
         #f)))
(random-allocator rooms room-type 100)       ;;allocate names to the rooms
(random-allocator objectdb objects 50)       ;;allocate items to the rooms
(random-gem-location objectdb gem_objects)   ;;allocate keys to the rooms


(define (startgame-maze)
  (let* ((gem (car (ass-ref gem_objects (random(length gem_objects)) assq)))
         (gemgate_x (random X))
         (gemgate_y (random Y))
         (start (startpoint)))
    ;(printf "~a \n" gate_x)
    ;(printf "~a \n" gate_y)
    ;(printf "~a \n" gatekey)
    (printf "~a \n " start)
    (let loop ((rid start))    
      (printf "You are in the ~a \n>" (hash-ref rooms rid))
      (let* ((input (read-line))
             (string-tokens (string-tokenize input))
             (tokens (map string->symbol string-tokens))
             (response (call-actions rid tokens cadr))) ;;get action

      
        (cond ((eq? response 'direction)
               (let* ((direction (call-actions rid tokens caar)) ;get direction typed
                      (newlocation (move-room rid direction)))  ;get future location after move
                 (cond((member direction (paths rid)) ;check if direction is in path
                       (cond ((equal? newlocation (list gemgate_x gemgate_y)) ;end of game condition
                              (cond ((not (door-handle gem))
                                     (printf "It seems that you don't have the key to open the gate. \n")
                                     (loop newlocation))
                                    (else
                                     (printf "You used the key to open the gate. You are free! \n")
                                     (exit))))
                         (else
                          (loop newlocation))));;not in the gate
   
                      (else ;;direction not in path
                       (printf "You can not go that way!\n")
                       (loop rid)))))
            
              ((eq? #f response)
               (format #t "huh? I didn't understand that!\n")
               (loop rid))
            
              ((eq? response 'look)
             ;(show-maze m rid)
               (display-objects objectdb rid)
               (loop rid))
              ((eq? response 'mudmap)
               (show-maze m rid)
             ;(display-objects objectdb rid)
               (loop rid))
            
              ((eq? response 'pick)
             ;remove item from room and put into inventory
               (handle-item 'room rid input)
               (loop rid))
            
              ((eq? response 'inventory)
               (display-inventory) ;;show inventorydb
               (loop rid))
            
              ((eq? response 'quit)
               (format #t "So Long, and Thanks for All the Fish...\n")
               (exit))
            
              ((eq? response 'drop)
               ;remove item from inventory and drop on the current room
               (handle-item 'bag rid input)
               (loop rid)))))))

(startgame-maze)
