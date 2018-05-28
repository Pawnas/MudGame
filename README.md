# MudGame
Multi user dungeon game using Scheme, done as a University project

## Introduction to little Schemer

Scheme is one of the best programming languages when it comes to teaching recursion.
Scheme avoids putting on a lot of stress on a developer when it comes to thinking about
relationships between symbols of its own language and representing it in the computer
because scheme is inherently symbolic. Schemes natural computational mechanism is
recursion. Scheme implementations are predominantly interactive-the programmer can
immediately participate in and observe the behavior of his programs. Since scheme
focuses on recursive programming the main features of it are: car, cdr, cons, eq?, null?,
zero?, addl, subl, number?, and, or, quote, lambda, define, and cond. 

### THE PRIMITIVE CAR
The function “Car” returns the first atom of a list.

Example:
(car '(a b c))    ; 'a
(car '((a b c) x y z))    ; '(a b c)


### THE PRIMITIVE CDR
The “Cdr” of a list is the rest of the list after the first item in the list.

Example:
(cdr '(a b c))    ; '(b c)
(cdr '((a b c) x y z))    ; '(x y z)
(cdr '(hamburger))    ; '()
(cdr '((x) t r))    ; '(t r)


### THE PRIMITIVE CONS
The “Cons” function concatenates lists into one.

Example:
(cons 'peanut '(butter and jelly))
; '(peanut butter and jelly)
(cons '(banana and) '(peanut butter and jelly))
; '((banana and) peanut butter and jelly)
(cons '((help) this) '(is very ((hard) to learn)))
; '(((help) this) is very ((hard) to learn))
(cons '(a b (c)) '())
; '((a b (c)))
(cons 'a '())
; '(a)


### THE PRIMITIVE NULL?
The “null?” function checks if the list is empty and returns either True of False.

Example:
(null? '())     ; true
(null? '(a b c))    ; false


### THE PRIMITIVE EQ?
The “eq?” function takes two arguments, each must be a non-numeric atom.

Example:
(eq? 'Harry 'Harry)     ; true
(eq? 'margarine 'butter)    ; false

## Multi user dungeon game
The game consists of 4 different racket files (MudMaze, MudObjects, MudAssoc, Mudv3)
this approach of separating the given code into different files and including them in the
game engine file was found while doing online research.

## Testing

![image](https://user-images.githubusercontent.com/25343679/40592316-a6d96676-6215-11e8-83e0-d831b39f2b21.png)
![image](https://user-images.githubusercontent.com/25343679/40592329-c2025af2-6215-11e8-867e-0107f9ac60eb.png)


