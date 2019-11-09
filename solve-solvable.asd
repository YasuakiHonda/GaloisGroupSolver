(defsystem solve-solvable
  :defsystem-depends-on ("maxima-file")
  :name "GaloisGroupSolver-SolveSolvable2"
  :author "Yasuaki Honda"
  :license "GNU Lesser General Public License, version 2"
  :description "Program SolveSolvable2 of GaloisGroupSolver, a Maxima package for solving polynomials based on their Galois Groups"

  :components
    ((:maxima-file "Gal")
     (:maxima-file "FiniteGroup")
     (:maxima-file "ExtendedField")
     (:maxima-file "Stage3")
     (:maxima-file "Verify")
     (:maxima-file "SolveSolvable2")))
