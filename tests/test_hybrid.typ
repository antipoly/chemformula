// Test file for electron configuration renderer - Hybrid Orbitals
#import "../src/electronconfig.typ": *

#set page(width: auto, height: auto, margin: 1em)
#set text(size: 10pt)

= Hybrid Orbital Tests

== Test 1: Basic hybrid - `ec("1s2.2s1|2px1.2py1")`
Expected: 1s paired, then hybrid group with 2s, 2px, 2py each with labels on top

#ec("1s2.2s1|2px1.2py1")

#line(length: 100%)

== Test 2: Specific axis orbital alone - `ec("2pz1")`
Expected: Single box labeled "2pz" with one up arrow

#ec("2pz1")

#line(length: 100%)

== Test 3: sp3 hybrid notation - `ec("2s1|2px1|2py1|2pz1")`
Expected: 4 boxes: 2s, 2px, 2py, 2pz each with 1 electron and labels on top

#ec("2s1|2px1|2py1|2pz1")

#line(length: 100%)

== Test 4: Mixed - `ec("1s2.2s1|2px1|2py1.2pz1")`
Expected: 1s paired, hybrid of 2s+2px+2py, then separate 2pz

#ec("1s2.2s1|2px1|2py1.2pz1")

#line(length: 100%)

== Test 5: d-orbital specific axis - `ec("3dxy2")`
Expected: Single paired box labeled "3dxy"

#ec("3dxy2")

#line(length: 100%)

== Test 6: Full explicit p orbitals - `ec("2p[1,1,1]")`
Expected: 3 boxes with px, py, pz labels and 1 electron each

#ec("2p[1,1,1]")

#line(length: 100%)

= D-Orbital Axis Labels

The d-orbitals have 5 axis labels: `xy`, `xz`, `yz`, `x²-y²`, `z²`

== All d-orbital axes individually:

#stack(
  dir: ltr,
  spacing: 1em,
  ec("3dxy1"),
  ec("3dxz1"),
  ec("3dyz1"),
  ec("3dx²-y²1"),
  ec("3dz²1"),
)

== d-orbital hybrid (e.g., for crystal field splitting):

#ec("3dxy1|3dxz1|3dyz1")  // t2g orbitals

#ec("3dx²-y²1|3dz²1")  // eg orbitals

#line(length: 100%)

= F-Orbital Axis Labels

The f-orbitals have 7 axis labels: `z³`, `xz²`, `yz²`, `xyz`, `z(x²-y²)`, `x(x²-3y²)`, `y(3x²-y²)`

== Some f-orbital examples:

#stack(
  dir: ltr,
  spacing: 1em,
  ec("4fz³1"),
  ec("4fxz²1"),
  ec("4fyz²1"),
  ec("4fxyz1"),
)

#line(length: 100%)

= Summary of Axis Notation

- *p orbitals*: `x`, `y`, `z` → e.g., `2px1`, `2py2`, `2pz1`
- *d orbitals*: `xy`, `xz`, `yz`, `x²-y²`, `z²` → e.g., `3dxy1`, `3dz²2`
- *f orbitals*: `z³`, `xz²`, `yz²`, `xyz`, `z(x²-y²)`, `x(x²-3y²)`, `y(3x²-y²)` → e.g., `4fz³1`
