(define (problem p1) (:domain blocks) (:objects a b c) (:init (ontable a) (ontable b) (ontable c) (clear a) (clear b) (clear c) (handempty)) (:goal (and (on a b) (on b c))))
