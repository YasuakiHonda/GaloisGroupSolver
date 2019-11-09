(defsystem step-solve
  :defsystem-depends-on ("maxima-file")
  :name "GaloisGroupSolver-SSquintic"
  :author "Yasuaki Honda"
  :license "GNU Lesser General Public License, version 2"
  :description "Program SSquintic of GaloisGroupSolver, a Maxima package for solving polynomials based on their Galois Groups"

  :components
    ((:maxima-file "Gal")
     (:maxima-file "FiniteGroup")
     (:maxima-file "ExtendedField")
     (:maxima-file "Stage4")
     (:maxima-file "Verify")
     (:maxima-file "SSquintic")))
