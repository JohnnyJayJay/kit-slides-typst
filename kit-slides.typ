//==========================================================
// Karlsruhe Institute of Technology theme for Typst slides.
// Based on the official Powerpoint Theme and Latex Template
//
// You don't need to edit this file. Only presentation.typ
// =========================================================
#import "@preview/polylux:0.4.0" as polylux: *

#let _kit-outer-margin = 3mm
#let _kit-inner-margin = 11mm
#let _kit-top-margin = 10mm
#let _kit-bottom-margin = 11mm

#let kit-green = rgb(0, 150, 130)
#let kit-blue = rgb(70, 100, 170)
#let green = kit-green
#let blue = kit-blue
#let black70 = rgb(64, 64, 64)
#let brown = rgb(167, 130, 46)
#let purple = rgb(163, 16, 124)
#let cyan = rgb(35, 161, 224)
#let lime = rgb(140, 182, 60)
#let yellow = rgb(252, 229, 0)
#let orange = rgb(223, 155, 27)
#let red = rgb(162, 34, 35)

#let kit-title = state("kit-title", [])
#let kit-subtitle = state("kit-subtitle", [])
#let kit-short-title = state("kit-short-title", none)
#let kit-author = state("kit-author", [])
#let kit-short-author = state("kit-short-author", none)
#let kit-group-logo = state("kit-group-logo", none)
#let kit-institute = state("kit-institute", [])
#let kit-date = state("kit-date", none)
#let kit-show-page-count = state("kit-show-page-count", false)

//=================
// Helper functions
//=================

#let kit-logo(..rest) = context {
  if text.lang == "de" {
    image("/assets/kit/logo-de.svg", ..rest)
  } else {
    image("/assets/kit/logo-en.svg", ..rest)
  }
}

#let kit-rounded-block(radius: 3mm, body) = {
  block(
    radius: (
      top-right: radius,
      bottom-left: radius,
    ),
    clip: true,
    body,
  )
}

#let kit-list-marker = move(
  dy: 0.125em,
  kit-rounded-block(
    radius: 0.15em,
    rect(
      // The latex documentclass uses a size of 1ex, but type only supports em.
      width: 0.5em,
      height: 0.5em,
      fill: kit-green,
    ),
  ),
)

#let kit-theme(
  title: none,
  subtitle: none,
  short-title: none,
  author: none,
  short-author: none,
  language: "de",
  group-logo: none,
  institute: none,
  date: none,
  aspect-ratio: "16-9",
  show-page-count: false,
  body,
) = {

  if language not in ("en", "de") {
    panic("Only English (en) and German (de) are currently supported")
  }
  set page(margin: 0pt, header-ascent: 0pt, footer-descent: 0pt)
  // Use power point page sizes, as they differ from default typst page sizes.
  set page(width: 25.4cm, height: 14.29cm) if aspect-ratio == "16-9"
  set page(width: 25.4cm, height: 15.88cm) if aspect-ratio == "16-10"
  set page(width: 25.4cm, height: 19.05cm) if aspect-ratio == "4-3"
  if aspect-ratio not in ("16-9", "16-10", "4-3") {
    panic("Unsupported aspect ratio")
  }

  set text(lang: language, font: ("Arial", "Helvetica", "Roboto"))

  set list(marker: kit-list-marker)

  kit-title.update(title)
  kit-subtitle.update(subtitle)
  if short-title == none {
    kit-short-title.update(title)
  } else {
    kit-short-title.update(short-title)
  }
  kit-author.update(author)
  if short-author == none {
    kit-short-author.update(author)
  } else {
    kit-short-author.update(short-author)
  }
  kit-institute.update(institute)
  kit-group-logo.update(group-logo)
  kit-date.update(date)
  kit-show-page-count.update(show-page-count)

  body
}

//=================
// slides
//=================

#let title-slide(banner: none) = {
  show: slide
  if banner == none {
    banner = image("/assets/kit/banner.jpg")
  }

  // Top half
  pad(left: _kit-inner-margin, right: 6mm, top: _kit-top-margin)[
    // KIT logo
    #place[
      #kit-logo(width: 45mm)
    ]
    // Group logo
    #place(right)[
      #block(width: 30mm, height: 30mm)[
        #set image(width: 100%)
        #context kit-group-logo.get()
      ]
    ]
    // Title
    #place(dy: 32mm, text(weight: "bold", size: 26pt, context { kit-title.get() }))
    // Subtitle
    #place(dy: 44mm)[
      #set text(weight: "bold", size: 18pt)
      #set par(leading: 0.3em)
      #context { kit-subtitle.get() }
    ]
  ]

  // Bottom half
  align(
    bottom,
    pad(x: _kit-outer-margin)[
      // Banner
      #block(height: 60mm, below: 0pt)[
        #kit-rounded-block(radius: 3mm)[
          #set image(width: 100%, height: 100%)
          #banner
        ]
      ]
      // Footer
      #block(height: _kit-bottom-margin, width: 100%)[
        #grid(
          columns: (auto, 1fr),
          [
            #align(left + horizon)[
              #block(height: 100%)[
                #set text(size: 8pt)
                #context {
                  if text.lang == "en" [
                    KIT - The Research University in the Helmholtz Association
                  ] else if text.lang == "de" [
                    KIT - Die Forschungsuniversität in der Helmholtz-Gemeinschaft
                  ]
                }
              ]
            ]
          ],
          [
            #align(
              right + horizon,
              block(height: 100%)[
                #link(
                  "https://www.kit.edu",
                  text("www.kit.edu", weight: "bold", size: 16.5pt),
                )
              ],
            )
          ],
        )
      ]
    ],
  )
}

#let slide(title: [], body) = {
  // Title bar
  let header = block(width: 100%, height: 100%, inset: (x: _kit-inner-margin))[
    #grid(
      columns: (auto, 1fr),
      [
        #set text(24pt, weight: "bold")
        // We need a block here to force the grid to take the full height of the surrounding block
        #block(height: 100%)[
          #align(left + bottom, title)
        ]
      ],
      [
        #align(right + bottom)[
          #kit-logo(width: 30mm)
        ]
      ],
    )
  ]

  // Content block
  let wrapped-body = block(
    width: 100%,
    height: 100%,
    inset: (x: _kit-inner-margin, top: 15.5mm),
  )[
    #set text(18pt)
    // Default value, but had to be changed for layout
    #set block(above: 1.2em)
    #body
  ]

  // Footer
  let footer = block(width: 100%, inset: (x: _kit-outer-margin))[
    #set block(above: 0pt)
    #set text(size: 9pt)
    #line(stroke: rgb("#d8d8d8"), length: 100%)
    #block(width: 100%, height: 100%)[
      #align(horizon)[
        #grid(
          columns: (20mm, 30mm, 1fr, auto),
          pad(
            left: 6mm,
            context if kit-show-page-count.get() [
              #toolbox.slide-number/#strong(utils.last-slide-number)
            ] else [
              #toolbox.slide-number
            ],
          ),
          context { kit-date.get() },
          context { [#kit-short-author.get() - #kit-short-title.get()] },
          align(right, context { kit-institute.get() }),
        )
      ]
    ]
  ]

  set page(
    header: header,
    footer: footer,
    margin: (top: 22.5mm, bottom: _kit-bottom-margin),
  )
  polylux.slide(wrapped-body)
}

// This function is left here for backwards compatibility only. Please use #slide(side-by-side[][]) instead.
#let split-slide(title: [], body-left, body-right) = {
  let body = grid(
    columns: (1fr, 1fr),
    gutter: 2em,
    body-left, body-right,
  )

  slide(title: title, body)
}

#let kit-color-block(title: [], color: [], body) = {
  // 80% is a rough heuristic, that produces the correct result for all predefined colors.
  // Might be adjusted in the future
  let title-color = if luma(color).components().at(0) >= 80% {
    black
  } else {
    white
  }
  kit-rounded-block()[
    #block(
      width: 100%,
      inset: (x: 0.5em, top: 0.3em, bottom: 0.4em),
      fill: gradient.linear(
        (color, 0%),
        (color, 87%),
        (color.lighten(85%), 100%),
        dir: ttb,
      ),
      text(fill: title-color, title),
    )
    #set text(size: 15pt)
    #block(
      inset: 0.5em,
      above: 0pt,
      fill: color.lighten(85%),
      width: 100%,
      body,
    )
  ]
}

#let kit-info-block(title: [], body) = {
  kit-color-block(title: title, color: kit-green, body)
}

#let kit-example-block(title: [], body) = {
  kit-color-block(title: title, color: kit-blue, body)
}

#let kit-alert-block(title: [], body) = {
  kit-color-block(title: title, color: red.lighten(10%), body)
}
