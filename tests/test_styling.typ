// Test file for electron configuration styling options
#import "../src/electronconfig.typ": *

#set page(width: auto, height: auto, margin: 1em)
#set text(size: 10pt)

= Electron Configuration Styling Tests

== Default Styling
#ec("1s2.2s2.2p3")

#line(length: 100%)

== Custom Box Size (40pt)
#ec("1s2.2s2.2p3", box-size: 40pt)

#line(length: 100%)

== Custom Box Size (60pt) - arrows scale automatically
#ec("1s2.2s2.2p3", box-size: 60pt)

#line(length: 100%)

== Small boxes (15pt)
#ec("1s2.2s2.2p3", box-size: 15pt)

#line(length: 100%)

== Custom Arrow Spacing (wider)
#ec("1s2.2s2.2p6", box-size: 40pt, arrow-spacing: 0.8em)

#line(length: 100%)

== Custom Arrow Spacing (tighter)
#ec("1s2.2s2.2p6", box-size: 40pt, arrow-spacing: 0.1em)

#line(length: 100%)

== Custom Label Size (larger)
#ec("1s2.2s2.2p[1,1,1]", label-size: 1.2em)

#line(length: 100%)

== Custom Label Size (smaller)
#ec("1s2.2s2.2p[1,1,1]", label-size: 0.6em)

#line(length: 100%)

== Custom Box Inset (more padding)
#ec("1s2.2s2.2p3", box-size: 40pt, box-inset: 0.8em)

#line(length: 100%)

== Custom Box Spacing (gaps between boxes)
#ec("1s2.2s2.2p6", box-spacing: 5pt)

#line(length: 100%)

== Combined: Large presentation style
#ec("1s2.2s2.2p[1,1,1]", 
  box-size: 50pt, 
  label-size: 1em,
  arrow-spacing: 0.4em,
  spacing: 3em,
)

#line(length: 100%)

== Combined: Compact style
#ec("1s2.2s2.2p6.3s2.3p6", 
  box-size: 18pt, 
  label-size: 0.6em,
  spacing: 1em,
)
