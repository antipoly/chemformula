// Test file for electron configuration renderer
#import "../src/electronconfig.typ": *

#set page(width: auto, height: auto, margin: 1em)
#set text(size: 10pt)

= Electron Configuration Tests

== Test 1: Basic configuration - `ec("1s2.2s2.2p6")`
Expected: 1s with paired electrons, 2s with paired electrons, 2p with 3 paired boxes (labels on TOP)

#ec("1s2.2s2.2p6")

#line(length: 100%)

== Test 2: Explicit orbital distribution - `ec("1s2.2s2.2p[1,1,1]")`
Expected: 2p rendered as 3 boxes with 1 up arrow each, with axis labels (2p#sub[x], 2p#sub[y], 2p#sub[z]) on TOP

#ec("1s2.2s2.2p[1,1,1]")

#line(length: 100%)

== Test 3: Hybrid orbitals - `ec("1s2.2s1|2p[1,1].2p[1]")`
Expected: 1s paired, then 2s and 2p[1,1] in same grouping (3 boxes total), then 2p[1] separately

#ec("1s2.2s1|2p[1,1].2p[1]")

#line(length: 100%)

== Test 4: Partial filling (Hund's rule) - `ec("1s2.2s2.2p3")`
Expected: 2p with 3 electrons should show [up][up][up] (one in each orbital per Hund's rule)

#ec("1s2.2s2.2p3")

#line(length: 100%)

== Test 5: Carbon - `ec("1s2.2s2.2p2")`
Expected: 2p with 2 electrons: [up][up][empty]

#ec("1s2.2s2.2p2")

#line(length: 100%)

== Test 6: d-orbital - `ec("1s2.2s2.2p6.3s2.3p6.3d5")`
Expected: 3d with 5 single electrons (one per orbital per Hund's rule)

#ec("1s2.2s2.2p6.3s2.3p6.3d5")

#line(length: 100%)

== Test 7: Explicit d-orbital with axis labels - `ec("3d[2,1,1,1,0]")`
Expected: 3d with explicit distribution and axis labels on TOP (3d#sub[xy], 3d#sub[xz], etc.)

#ec("3d[2,1,1,1,0]")

#line(length: 100%)

== Test 8: Just s orbital - `ec("1s1")`
Expected: Single box with one up arrow

#ec("1s1")

#line(length: 100%)

== Test 9: f-orbital (7 orbitals) - `ec("4f7")`
Expected: 7 boxes with one electron each (Hund's rule)

#ec("4f7")
