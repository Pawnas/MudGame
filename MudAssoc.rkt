


(define objects '((0 "a silver dagger")
                  (1 "a gold coin")
                  (2 "a bow")
                  (3 "a arrows")
                  (4 "a gem")
                  (5 "a gem")
                  (6 "a gem")))



(define room-type '( (0 "Entrance")
                     (1 "hall")
                     (2 "hallway")
                     (3 "corridor")
                     (4 "lobby")
                     (5 "greyroom")
                     (6 "washroom")
                     (7 "pass")))

(define gem_objects '((0 "a grey gem")
                      (1 "a yellow gem")
                      (2 "a black gem")
                      (3 "a white gem")
                      (4 "a blue gem")))




(define look '(((directions) look) ((look) look) ((examine room) look)))
(define quit '(((exit game) quit) ((quit game) quit) ((exit) quit) ((quit) quit)))
(define pick '(((get) pick) ((pickup) pick) ((pick) pick)))
(define put '(((put) drop) ((drop) drop) ((place) drop) ((remove) drop)))
(define inventory '(((inventory) inventory) ((bag) inventory)))

(define directions '(((south) direction) ((north) direction) ((west) direction) ((east) direction)))

(define mudmap '(((map) mudmap) ((show map) mudmap)((see map) mudmap) ((look map) mudmap)))

(define actions `(,@look ,@quit ,@pick ,@put ,@inventory,@directions,@mudmap))


(define decisiontable `((1 ,@actions)
                        (2 ((south) 1) ,@actions )
                        (3 ,@actions)))

  