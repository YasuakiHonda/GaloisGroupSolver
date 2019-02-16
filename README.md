# GaloisGroupSolver
A Maxima package for solving polynomials based on their Galois Groups

## Motivation
Few months ago, I read a book about Galois's work on insolvability of fifth degree polynomials. The book (and many introductory books in Japan) demonstrates the Galois group concept using the solution formulae of qudratic and cubic equations. I felt that is not fair. Galois group should be computed without solving the equations. More surprisingly, there is a very little of such books that mention the possible solvability of higher degree polynomials. That is why I started on [my blog](http://maxima.hatenablog.jp/) a series of articles (in Japanese) that describe a Maxima program that performs above all.

## Goal of this package
You may know that higher degree polynomials cannot be solved because there is no formulae for solving polynomials of fifth degree or higher. That was proven many years ago by the work of mathematicians Abel, Ruffini, and Galois. However, the same theory developed by Galois also tells us that some higher degree polynomials can be solved with combination of radicals (nth-roots of numbers). This is NOT a numerical root finding, but it is truly an algebraic symbolic computation of yielding radical solutions based on coefficients of a given polynomial. I use Maxima, a free computer algebra system, for this computation.

There are two goals achieved in this package:
* To determine if a given polynomial is solvable by radicals or not
* If it is solvable, then to compute the radical solutions based on the Galois Group and Field theory

The better description of what you can do with this package is given in the next section.


## Mathematical background and description
Galois theory developed by Évariste Galois says that if a Galois group of a given polynomial is a solvable group, then the polynomial is solvable by radicals. To determine if a given polynomial is solvable or not, we need to do the followings:
* Compute a Galois group of a given polynomial
* Compute a series of normal subgroups of the Galois group
* Compute quotients of degree of a normal subgroup in the series and its descent subgroup. If all quotients are primes, then the Galois group is solvable.

For a solvable poynomial, we perform the following computation according to the computed series of normal subgroups of the Galois group:
* Starting from Q as the initial coefficient field of the given polynomial, we compute a radical to add to the coefficient field to obtain the extended field (Galois theory's conclusion on correspondance between subnormal groups reduction and normal extension of fileds).
* The above step will be repeated so that the Galois group is reduced to the trivial group, thus we obtain a splitting field of a given polynomial. 
* The obtained splitting field is a extensions of Q by radicals.

Along with computing the Galois group, we also compute a minimal polynomial of V where V is a primitive element that extends Q to the splitting field. As the Galois group is reduced and the coefficient field is extended, the minimal polynomial of V is factored into a lower degree polynomial. When the Galois group is reduced to the trivial group thus Q is extended to the splitting field, the minimal polynomial of V becomes a linear so that V is represented in terms of radicals.

Finally, we compute solutions of the original polynomial from V based on the formulae obtained in the computing of Galois group.


## Development and test environments
### Development environment 
* Maxima 5.42.1 source code distribution compiled using Lisp SBCL 1.2.11, binary distribution for 64bit darwin.
### Test environments
The program is solely written in the Maxima language, so I believe the package runs on any recent Maxima on any machine. Specific environments I tested were:
* Maxima above on Mac OS Mojave 10.14.3 on iMac (late 2013, Intel Core i5 2.7Ghz, 8GB memory)
* wxMaxima binary distribution from maxima.sourceforge.net for Windows 10

## Files and functions in this package
This package includes the following files: README.md (this file), SolveSolvable2.mac, Gal.mac, FiniteGroup.mac, ExtendedField.mac, Stage3.mac, Stage4.mac, Verify.mac, License.txt

**Important restrictions:** Polynomials dealt in this package are restricted to meet all of the following conditions:
+ Polynomials must be univariate, with variable name 'x',
+ Polynomials must be monic, meaning their highest degree coefficient must be 1,
+ Polynomials must be of degree higher than 1,
+ Polynomials must be in Z[x], meaning their coefficients must be integers,
+ Polynomials must be irreducible, meaning they cannot be factored in Q,
+ Polynomials must be separable, meaning they must not have multiple roots.

Above conditions are checked only in gal_init_polynomial_info(p).

Examples: 
+ OK: x^5-3\*x-1, x^3-3\*x+1, x^5-3, x^4+1,
+ NG: x^2+y^2-1, x^5+a\*x^4+b\*x^3+d, x^2-1, x^5+1, x+1

**SolveSolvable2.mac** This file defines a function SolveSolvable(poly) where poly is a polynomial to solve.
+ SolveSolvable(poly) integrates all the sub programs to perform computations above and print intermediate status, solutions by radicals, and numerical verification. 

**Gal.mac** This file contains functions for the followings:
+ *GalPolynomialInfo* structure to be used during the computation of Galois group
+ *gal_init_polynomial_info(p)* p:polynomial to be solved. to create and initialize the GalPolynomialInfo and return it
+ *gal_phi()* computes V by the linear combination of symbolic variables that represent solutions of polynomial p. You may need to change coefficients of the linear combination when the calcuration not correctly performed in gal_minimal_polynomial_V2() and gal_sol_V4() in the source code in SolveSolvable2.mac.
+ *gal_minimal_polynomial_V2()* fast version of computing minimal polynomial of V
+ *gal_sol_V4()* fast version of computing representations of solutions of poly by V

**FiniteGroup.mac** This file contains functions for the followings:
+ *FiniteGroup* structure to be used for group related computation
+ *gr_gen_tables()* generates group multiplication table from Galois group represented as permutation. Also, inversion table is generated.
+ *gr_mult()* and *gr_inv()* computes multiplication and inverse in the group.
+ *gr_normal_subgroup_max* computes a maximum size normal subgroup of a given finite group. It is known that there is a slight condition that the algorithm in this function may fail to produce the maximamu size normal subgroup.
+ *gr_subnormal_series()* computes comosition series of a given finite group. 

**ExtendedField.mac** This file contains functions for the followings:
C is a list of radical definitions in reverse order.
C=[[b,b^3+a+1],[a,a^2-101]] means a is one of square root of 101 and b is one of 3rd root of -a-1. 
This list of radical definitions actually can be thought of as a series of radical extensions to Q: Q(a) and Q(a,b).
+ *ef_polynomial_reduction(P,C)* where P is a polynomial and C is a list of radical definitions, and computes the remainder by elements in C.
+ *ef_mult()* computes multiplication of two polynomials in the field C.
+ *ef_divide()* computes division of two polynomials in the field C.
+ *ef_pthroot(F,p,C)* computes p-th root of a polynomial F in the field C.

**Stage3.mac, Stage4.mac** These files contain a function:
+ *StageInfo* structure to be used for reduction of Galois group and radical extension of coefficient field
+ *Stage()* accepts two normal subgroups in a composition series in neibor and computes a radical definition and a minimul polynomial of V in the extended field.

Stage3.mac uses an algorith briefly described in the Galois paper and further developed by [1], [2] and [3]. Stage4.mac uses the same computation done using Grobner basis package in Maxima.

**Verify.mac** This file is for computing numerical values of radicals and solutions represented as radicals.
+ *NumericRadicalEnv()* computes all possible combinations of numeric values of radicals. If condition is given, check and filter out any inappropritate combinations. Conditions can be computed only with Stage4.mac.
+ *Check_eq()* computes numerical values of solutions from numeric values of radicals and filter out inappropriate combinations of radicals.

## Example execution of solving a quintic polynomial
    % maxima
    Maxima 5.42.1 http://maxima.sourceforge.net
    using Lisp SBCL 1.2.11
    Distributed under the GNU Public License. See the file COPYING.
    Dedicated to the memory of William Schelter.
    The function bug_report() provides bug reporting information.
    (%i1) load("SolveSolvable2.mac");
     
    resolvante 
    generale 
     
    NOTE: To compile the system do 
    load("sym/compile"); 
    (%o1)                         SolveSolvable2.mac
    (%i2) SolveSolvable(x^3-3*x+1)$
    Minimal polynomial of V 
     3
    V  - 21 V - 37 
                     3
    Galois Group of x  - 3 x + 1 
    [ a  b  c ]
    [         ]
    [ b  c  a ] 
    [         ]
    [ c  a  b ]
    Subnormal series and quotients of orders 
    FiniteGroup[1,4,5] 
    FiniteGroup[1] 
     3
    x  - 3 x + 1 is solvable. 
    Solutions 
                2                                 2
         8 alpha  Zeta    3 alpha  Zeta    5 alpha    alpha
                1     3          1     3          1        1
    x  = -------------- + -------------- + -------- + ------ 
     1         49               7             49        7
                   2                                2
            3 alpha  Zeta     alpha  Zeta    8 alpha    2 alpha
                   1     3         1     3          1          1
    x  = (- --------------) - ------------ - -------- + -------- 
     2            49               7            49         7
                   2                                  2
            5 alpha  Zeta     2 alpha  Zeta    3 alpha    3 alpha
                   1     3           1     3          1          1
    x  = (- --------------) - -------------- + -------- - -------- 
     3            49                7             49         7
    with 
                               3                    2
    [[alpha , (- Zeta ) + alpha  + 18], [Zeta , Zeta  + Zeta  + 1]] 
           1         3         1             3      3       3
    Verification 
    Numeric calcuration of the above solutions 
    [- 1.879385241571816b0, 5.551115123125783b-17 %i + 1.532088886237956b0, 
                                  1.110223024625157b-16 %i + 3.472963553338606b-1] 
                                      3
    Numeric solutions with allroots( x  - 3 x + 1 ) 
    [x = 0.3472963553338607, x = 1.532088886237956, x = - 1.879385241571817] 


## Acknoledgements and references
I would like to thank two japanese persons who commented extensively to the articles on my blog. They are
+ ehito, whose comments are always mathematically and computationally fruitful. [ehit san's blog](http://ehito.hatenablog.com/) deals with automated theorem proving and computer algebra systems with a lot of quntifier elimination topics
+ Ikumi Keita, the alogrithm described in [Ikumi Keita san's blog](https://ikumi.que.jp/blog/) is the one I have implemented in Maxima for the first time in this course of development. Also he gave me an insightfull comments.

The following two persons published very detailed algorithms in this topic.
+ "Amature mathematician after retirement", who developed a detailed algorithm in Mathematica and sent its description to Ikumi Keita for publish on Ikumi's blog. The text is available [here](https://ikumi.que.jp/blog/wp-content/uploads/2018/09/galois-solution.pdf)
+ Akio Mimori, who put a long text about algorithms around this topic in 2013. Part of Gal.mac is based on [this text](http://scipio.secret.jp/Galois/galois_zenbun.pdf).

Unfortunately, all of the above are in Japanese. I have not yet found a good literature on the Internet regarding how to solve solvable polynomials of any order, written in English. If you find one, I would welcome to be shared.
