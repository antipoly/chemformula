#import "src/electronconfig.typ": *

#set page(width: auto, height: auto, margin: 1em)

// Test vertical alignment - the | syntax vs regular
// Draw a baseline to see alignment

#box(stroke: red)[
  #ec("1s2.2s2.2p6")
]

#v(1em)

// With hybrid
#box(stroke: blue)[
  #ec("1s2.2s1|2px1")
]

#v(1em)

// Side by side comparison
#stack(dir: ltr, spacing: 2em,
  box(stroke: red)[#ec("1s2")],
  box(stroke: blue)[#ec("2s1|2px1")],
  box(stroke: green)[#ec("2p6")],
)
