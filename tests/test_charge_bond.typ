#import "../src/chemformula.typ": ch, bond

#set page(width: auto, height: auto, margin: 1em)

= Vertical Alignment Visual Test

== Baseline Reference Lines

Each bond type with reference lines to check vertical centering:

#table(
  columns: 4,
  stroke: 0.5pt + gray,
  [Bond Type], [Raw Bond], [With Text], [In Formula],
  
  [Single],
  box(
    width: 3em,
    height: 1.5em,
    stroke: 0.5pt + red,
    align(horizon, line(length: 100%, stroke: 0.5pt + blue)) + 
    place(center + horizon, bond.single)
  ),
  text(size: 12pt)[#box(stroke: 0.5pt + green)[C]#bond.single#box(stroke: 0.5pt + green)[H]],
  [#ch("C-H")],
  
  [Double],
  box(
    width: 3em,
    height: 1.5em,
    stroke: 0.5pt + red,
    align(horizon, line(length: 100%, stroke: 0.5pt + blue)) + 
    place(center + horizon, bond.double)
  ),
  text(size: 12pt)[#box(stroke: 0.5pt + green)[C]#bond.double#box(stroke: 0.5pt + green)[O]],
  [#ch("C=O")],
  
  [Triple],
  box(
    width: 3em,
    height: 1.5em,
    stroke: 0.5pt + red,
    align(horizon, line(length: 100%, stroke: 0.5pt + blue)) + 
    place(center + horizon, bond.triple)
  ),
  text(size: 12pt)[#box(stroke: 0.5pt + green)[C]#bond.triple#box(stroke: 0.5pt + green)[C]],
  [#ch("C~C")],
)

#text(size: 8pt, fill: gray)[
  Red box = container, Blue line = center reference, Green boxes = text bounding boxes
]

= Charges (should NOT be bonds)

Na+: #ch("Na+")

Cl-: #ch("Cl-")

SO4^2-: #ch("SO4^2-")

Fe^3+: #ch("Fe^3+")

= Single Bonds

C-H: #ch("C-H")

= Double Bonds

C=O: #ch("C=O")

= Triple Bonds

C~C: #ch("C~C")

= Multiple bonds in chain

H-O-H: #ch("H-O-H")

CH3-CH2-CH3: #ch("CH3-CH2-CH3")

H2C=CH2: #ch("H2C=CH2")

HC~CH: #ch("HC~CH")
