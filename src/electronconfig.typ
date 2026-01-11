// Orbital Library - Electron Configuration Renderer
//
// Usage examples:
//   ec("1s2.2s2.2p6")           - Standard notation (Hund's rule filling)
//   ec("2p[1,1,1]")             - Explicit distribution with axis labels (2px, 2py, 2pz)
//   ec("2pz1")                  - Specific axis orbital (just one box with 2pz label)
//   ec("2s1|2px1|2py1|2pz1")    - Hybrid orbitals (sp3) - all boxes in one group
//   ec("1s2.2s1|2px1|2py1.2pz1") - Mixed: 1s, hybrid 2s+2px+2py, then separate 2pz
//
// Styling options:
//   box-size: 25pt              - Size of orbital boxes (width & height)
//   arrow-length: auto          - Arrow length (auto = 60% of box-size)
//   arrow-spacing: 0.3em        - Spacing between paired arrows
//   box-inset: 0.4em            - Padding inside boxes
//   box-spacing: 0pt            - Gap between boxes in same group
//   label-size: 0.8em           - Text size for orbital labels
//   spacing: 2em                - Spacing between shell groups
//
// Axis labels: p(x,y,z), d(xy,xz,yz,x²-y²,z²), f(z³,xz²,yz²,xyz,z(x²-y²),x(x²-3y²),y(3x²-y²))

#import "@preview/tiptoe:0.3.1"
#import "@preview/atostate:1.0.0": atostate

// ============================================================================
// Constants - Orbital information
// ============================================================================

// Number of orbitals per subshell type
#let orbital-count = (
  s: 1,
  p: 3,
  d: 5,
  f: 7,
)

// Maximum electrons per subshell
#let max-electrons = (
  s: 2,
  p: 6,
  d: 10,
  f: 14,
)

// Axis labels for each subshell type
#let axis-labels = (
  s: ("",),
  p: ("x", "y", "z"),
  d: ("xy", "xz", "yz", "x²-y²", "z²"),
  f: ("z³", "xz²", "yz²", "xyz", "z(x²-y²)", "x(x²-3y²)", "y(3x²-y²)"),
)

// ============================================================================
// Electron Arrow Mark (for tiptoe)
// ============================================================================

#let electron-arrow(
  align-dir,
  line: stroke(),
  width: 2.4pt + 360%,
  length: 5pt,
  curvature: 70%,
  stroke: auto,
) = {
  import tiptoe.utility
  stroke = utility.process-stroke(line, stroke)
  let (width,) = utility.process-dims(line, width: width)

  let scalar = if (align-dir == left) { 1 } else { -1 }

  (
    mark: place(std.curve(
      curve.move((0pt, 0pt)),
      curve.cubic(none, (-length * curvature, 0pt), (-length, scalar * width / 2)),
      stroke: stroke,
    )),
    end: 0pt,
  )
}

// ============================================================================
// Basic Rendering Primitives
// ============================================================================

/// Render a spin-up electron (arrow pointing up)
#let spin-up(length: 20pt) = tiptoe.line(
  toe: electron-arrow.with(right),
  length: length,
  angle: 90deg,
  stroke: 0.8pt,
)

/// Render a spin-down electron (arrow pointing down)
#let spin-down(length: 20pt) = tiptoe.line(
  tip: electron-arrow.with(left),
  length: length,
  angle: 90deg,
  stroke: 0.8pt,
)

/// Render an orbital box with electrons
/// count: 0 (empty), 1 (one up), 2 (up and down)
/// style: dictionary with box-size, arrow-length, arrow-spacing, box-inset
#let orbital-box(count, style: (:)) = {
  // Default style values
  let box-size = style.at("box-size", default: 25pt)
  let arrow-length = style.at("arrow-length", default: auto)
  let arrow-spacing = style.at("arrow-spacing", default: 0.3em)
  let box-inset = style.at("box-inset", default: 0.4em)

  // Auto-calculate arrow length based on box size if not specified
  let arrow-len = if arrow-length == auto {
    box-size * 0.6
  } else {
    arrow-length
  }

  box(
    width: box-size,
    height: box-size,
    stroke: 0.5pt + black,
    inset: box-inset,
    {
      set align(center + horizon)
      if count == 0 {
        // Empty box
        none
      } else if count == 1 {
        spin-up(length: arrow-len)
      } else if count == 2 {
        stack(
          dir: ltr,
          spacing: arrow-spacing,
          spin-down(length: arrow-len),
          spin-up(length: arrow-len),
        )
      }
    },
  )
}

/// Render a shell (subshell) with multiple orbitals
/// shell-type: "s", "p", "d", or "f"
/// electrons: total number of electrons OR array of per-orbital counts
/// show-axis: whether to show individual axis labels (x, y, z for p orbitals)
/// label: the label to display (e.g., "2p")
/// specific-axis: if set, render only this specific axis orbital
/// style: styling dictionary (box-size, arrow-length, arrow-spacing, box-inset, label-size)
#let shell(
  shell-type,
  electrons,
  label: none,
  show-axis: false,
  specific-axis: none,
  style: (:),
) = {
  let box-size = style.at("box-size", default: 25pt)
  let box-spacing = style.at("box-spacing", default: 0pt)
  let label-size = style.at("label-size", default: 0.8em)

  // Handle specific axis orbital (e.g., just "2pz")
  if specific-axis != none {
    let count = if electrons > 2 { 2 } else { int(electrons) }
    return block(
      stack(
        dir: ttb,
        spacing: 0.3em,
        align(center, box(width: box-size, text(size: label-size, label + sub(specific-axis)))),
        orbital-box(count, style: style),
      ),
    )
  }

  let num-orbitals = orbital-count.at(shell-type, default: 1)

  // Determine electron distribution per orbital
  let distribution = if type(electrons) == array {
    // Explicit distribution provided
    electrons
  } else {
    // Calculate distribution using Hund's rule (fill singly first, then pair)
    let e = int(electrons)
    let dist = ()
    // First pass: one electron per orbital
    for i in range(num-orbitals) {
      if e > 0 {
        dist.push(1)
        e -= 1
      } else {
        dist.push(0)
      }
    }
    // Second pass: pair up electrons
    for i in range(num-orbitals) {
      if e > 0 and dist.at(i) == 1 {
        dist.at(i) = 2
        e -= 1
      }
    }
    dist
  }

  // Pad distribution if needed
  while distribution.len() < num-orbitals {
    distribution.push(0)
  }

  // Build orbital boxes
  let boxes = for (i, count) in distribution.enumerate() {
    (orbital-box(count, style: style),)
  }

  // Build axis labels if needed
  let labels = if show-axis and shell-type != "s" {
    let axes = axis-labels.at(shell-type, default: ())
    for (i, ax) in axes.enumerate() {
      if i < distribution.len() {
        (align(center, text(size: label-size, label + sub(ax))),)
      }
    }
  } else {
    ()
  }

  // Calculate total width for centering the label
  let total-width = box-size * distribution.len() + box-spacing * (distribution.len() - 1)

  block(
    stack(
      dir: ttb,
      spacing: 0.3em,
      // Labels on top (either single label or axis labels)
      if show-axis and labels.len() > 0 {
        stack(
          dir: ltr,
          spacing: box-spacing,
          ..for lbl in labels {
            (box(width: box-size, align(center, lbl)),)
          },
        )
      } else if label != none {
        box(width: total-width, align(center, text(size: label-size, atostate(label))))
      },
      // Orbital boxes
      stack(
        dir: ltr,
        spacing: box-spacing,
        ..boxes,
      ),
    ),
  )
}

// ============================================================================
// Parser Functions
// ============================================================================

/// Parse shell type from notation like "1s", "2p", etc.
#let parse-shell-info(notation) = {
  let n = notation.at(0) // Principal quantum number
  let l = notation.slice(1, 2) // Subshell type (s, p, d, f)
  (n: n, type: l)
}

/// Parse electron count or distribution
/// Examples: "2", "6", "[1,1,1]", "[2,1,0]"
#let parse-electrons(value) = {
  if value.starts-with("[") and value.ends-with("]") {
    // Array notation: [1,1,1]
    let inner = value.slice(1, -1)
    let parts = inner.split(",")
    parts.map(p => int(p.trim()))
  } else {
    // Simple count
    int(value)
  }
}

/// Parse a single orbital group
/// Formats supported:
/// - "2p6" - standard notation (fills according to Hund's rule)
/// - "2p[1,1,1]" - explicit distribution for all orbitals
/// - "2px1" or "2pz2" - specific axis orbital (single box with axis label)
#let parse-orbital-group(group) = {
  // First try to match specific axis notation: number + letter + axis + number
  // e.g., "2px1", "2py2", "3dxy1", "3dz²2"
  let axis-match = group.match(regex("^(\d)([spdf])([a-zxy²³\-\(\)]+)(\d+)$"))
  if axis-match != none {
    let captures = axis-match.captures
    let n = captures.at(0)
    let l = captures.at(1)
    let axis-str = captures.at(2)
    let electron-count = int(captures.at(3))

    // Find the axis index
    let axes = axis-labels.at(l, default: ())
    let axis-idx = axes.position(a => a == axis-str)

    if axis-idx != none {
      return (
        label: n + l,
        shell-type: l,
        electrons: electron-count,
        show-axis: true,
        specific-axis: axis-str,
        axis-index: axis-idx,
      )
    }
  }

  // Standard pattern: number + letter + (number or [array])
  let shell-match = group.match(regex("^(\d)([spdf])(.+)$"))
  if shell-match == none {
    return none
  }

  let captures = shell-match.captures
  let n = captures.at(0)
  let l = captures.at(1)
  let electrons-str = captures.at(2)

  let electrons = parse-electrons(electrons-str)
  let show-axis = type(electrons) == array

  (
    label: n + l,
    shell-type: l,
    electrons: electrons,
    show-axis: show-axis,
    specific-axis: none,
    axis-index: none,
  )
}

/// Parse a hybrid group (orbitals separated by |)
#let parse-hybrid-group(group) = {
  let parts = group.split("|")
  parts.map(p => parse-orbital-group(p.trim()))
}

/// Parse full electron configuration string
/// Format: "1s2.2s2.2p6" or "1s2.2s2.2p[1,1,1]" or "1s2.2s1|2p[1,1].2p[1]"
#let parse-config(config) = {
  let groups = config.split(".")
  groups.map(g => {
    if g.contains("|") {
      // Hybrid group
      (type: "hybrid", orbitals: parse-hybrid-group(g))
    } else {
      // Single orbital
      (type: "single", orbital: parse-orbital-group(g))
    }
  })
}

// ============================================================================
// Main Rendering Function
// ============================================================================

/// Render a hybrid orbital group (multiple orbitals in same box)
#let render-hybrid(orbitals, style: (:)) = {
  let box-size = style.at("box-size", default: 25pt)
  let box-spacing = style.at("box-spacing", default: 0pt)
  let label-size = style.at("label-size", default: 0.8em)

  let all-boxes = ()
  let all-labels = ()

  for orb in orbitals {
    if orb == none { continue }

    // Check if this is a specific axis orbital (e.g., 2pz1)
    if orb.specific-axis != none {
      // Single box with specific axis label
      let count = if orb.electrons > 2 { 2 } else { orb.electrons }
      all-boxes.push(orbital-box(count, style: style))
      all-labels.push(box(width: box-size, align(center, text(
        size: label-size,
        orb.label + sub(orb.specific-axis),
      ))))
    } else {
      // Standard orbital handling
      let num-orbitals = orbital-count.at(orb.shell-type, default: 1)
      let distribution = if type(orb.electrons) == array {
        orb.electrons
      } else {
        let e = int(orb.electrons)
        let dist = ()
        for i in range(num-orbitals) {
          if e > 0 {
            dist.push(1)
            e -= 1
          } else { dist.push(0) }
        }
        for i in range(num-orbitals) {
          if e > 0 and dist.at(i) == 1 {
            dist.at(i) = 2
            e -= 1
          }
        }
        dist
      }

      for (i, count) in distribution.enumerate() {
        all-boxes.push(orbital-box(count, style: style))
        // Always add a label for each box in hybrid mode
        if orb.show-axis {
          let axes = axis-labels.at(orb.shell-type, default: ())
          if i < axes.len() {
            all-labels.push(box(width: box-size, align(center, text(
              size: label-size,
              orb.label + sub(axes.at(i)),
            ))))
          } else {
            all-labels.push(box(width: box-size, align(center, text(size: label-size, orb.label))))
          }
        } else {
          // Non-axis mode: just show the orbital label (e.g., "2s")
          all-labels.push(box(width: box-size, align(center, text(size: label-size, orb.label))))
        }
      }
    }
  }

  block(
    stack(
      dir: ttb,
      spacing: 0.3em,
      // Labels on top
      stack(
        dir: ltr,
        spacing: box-spacing,
        ..all-labels,
      ),
      // Orbital boxes
      stack(
        dir: ltr,
        spacing: box-spacing,
        ..all-boxes,
      ),
    ),
  )
}

/// Main electron configuration rendering function
/// config: electron configuration string
/// spacing: spacing between shell groups
/// box-size: size of each orbital box (width and height)
/// arrow-length: length of electron arrows (auto = 60% of box-size)
/// arrow-spacing: spacing between paired arrows
/// box-inset: padding inside the box
/// box-spacing: spacing between boxes in same group
/// label-size: text size for labels
#let ec(
  config,
  spacing: 1em,
  box-size: 18pt,
  arrow-length: auto,
  arrow-spacing: 0.3em,
  box-inset: 0.4em,
  box-spacing: 0pt,
  label-size: 0.6em,
) = {
  let parsed = parse-config(config)

  // Build style dictionary
  let style = (
    box-size: box-size,
    arrow-length: arrow-length,
    arrow-spacing: arrow-spacing,
    box-inset: box-inset,
    box-spacing: box-spacing,
    label-size: label-size,
  )

  stack(
    dir: ltr,
    spacing: spacing,
    ..for group in parsed {
      if group.type == "hybrid" {
        (render-hybrid(group.orbitals, style: style),)
      } else if group.type == "single" and group.orbital != none {
        let orb = group.orbital
        (
          shell(
            orb.shell-type,
            orb.electrons,
            label: orb.label,
            show-axis: orb.show-axis,
            specific-axis: orb.specific-axis,
            style: style,
          ),
        )
      }
    },
  )
}
