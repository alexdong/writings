#import "@preview/cetz:0.3.4": canvas, draw

// Chart styling is centralized here so the figures can be brought into the
// Tacit visual system later without touching the article prose.
#let chart-theme = (
  font: "Avenir Next",
  ink: rgb("#161616"),
  muted: rgb("#667085"),
  faint: rgb("#eaedf0"),
  grid: rgb("#d9dee5"),
  slm: rgb("#005c53"),
  slm-light: rgb("#d9eee9"),
  frontier: rgb("#5867dd"),
  frontier-light: rgb("#e3e6fb"),
  haiku: rgb("#c77a00"),
  sonnet: rgb("#7a5ce6"),
  gpt: rgb("#19a977"),
  base: rgb("#a36b00"),
  base-light: rgb("#f5ead5"),
  warning: rgb("#a43f34"),
)

#let score-data = (
  (label: "Qwen3-8B base", value: 2.88, value_label: "2.88%", kind: "base"),
  (label: "GPT-4.1", value: 16.09, value_label: "16.09%", kind: "frontier"),
  (label: "Opus 4.6", value: 18.08, value_label: "18.08%", kind: "frontier"),
  (label: "Sonnet 4.6", value: 26.32, value_label: "26.32%", kind: "frontier"),
  (label: "Haiku 4.5", value: 31.25, value_label: "31.25%", kind: "frontier"),
  (label: "Tacit SLM", value: 96.55, value_label: "96.55%", kind: "slm"),
)

#let cost-data = (
  (label: "Qwen3-8B base", score: 2.88, cost: 300, kind: "base", dx: 0.25, dy: 0.15),
  (label: "GPT-4.1", score: 16.09, cost: 6800, kind: "frontier", dx: 0.25, dy: 0.15),
  (label: "Opus 4.6", score: 18.08, cost: 20900, kind: "frontier", dx: 0.25, dy: -0.12),
  (label: "Sonnet 4.6", score: 26.32, cost: 12500, kind: "frontier", dx: 0.25, dy: 0.28),
  (label: "Haiku 4.5", score: 31.25, cost: 4200, kind: "frontier", dx: 0.25, dy: 0.15),
  (label: "Tacit SLM", score: 96.55, cost: 300, kind: "slm", dx: 0.25, dy: -0.05),
)

#let reliability-series = (
  // Intermediate points are reconstructed from the embedded report figure so
  // the curve shape remains editable in Typst rather than embedded as a PNG.
  (label: "Tacit SLM", kind: "slm", values: (96.55, 93.7, 91.1, 88.9, 86.9, 84.9, 83.3, 81.7, 80.2, 78.9, 77.7, 76.4, 75.3, 74.2, 73.2, 72.4), end_label: "72.4%", end_dy: 0.25),
  (label: "Haiku 4.5", kind: "haiku", values: (31.25, 17.2, 11.5, 8.4, 6.5, 5.2, 4.4, 3.8, 3.3, 3.0, 2.8, 2.7, 2.6, 2.6, 2.6, 2.6), end_label: "2.6%", end_dy: 0.35),
  (label: "Sonnet 4.6", kind: "sonnet", values: (26.32, 16.4, 12.2, 9.7, 8.5, 7.6, 7.0, 6.5, 6.2, 6.0, 5.8, 5.6, 5.5, 5.4, 5.3, 5.3), end_label: "5.3%", end_dy: 1.15),
  (label: "GPT-4.1", kind: "gpt", values: (16.09, 8.0, 5.5, 4.0, 2.8, 2.0, 1.5, 1.1, 0.8, 0.6, 0.4, 0.3, 0.2, 0.1, 0.0, 0.0), end_label: "near 0", end_dy: -0.25),
  (label: "Qwen3-8B base", kind: "base", values: (2.88, 0.5, 0.2, 0.1, 0.05, 0.0, 0.0, 0.0, 0.0, 0.0, 0.0, 0.0, 0.0, 0.0, 0.0, 0.0), end_label: "0 by k=6", end_dy: -0.85),
)

#let chart-color(kind, theme: chart-theme) = {
  if kind == "slm" {
    theme.slm
  } else if kind == "base" {
    theme.base
  } else if kind == "haiku" {
    theme.haiku
  } else if kind == "sonnet" {
    theme.sonnet
  } else if kind == "gpt" {
    theme.gpt
  } else {
    theme.frontier
  }
}

#let chart-fill(kind, theme: chart-theme) = {
  if kind == "slm" {
    theme.slm-light
  } else if kind == "base" {
    theme.base-light
  } else {
    theme.frontier-light
  }
}

#let chart-label(body, size: 7pt, fill: chart-theme.muted, weight: "regular") = {
  text(font: chart-theme.font, size: size, fill: fill, weight: weight, body)
}

#let fig(body, caption) = figure(
  align(center, body),
  caption: caption,
  supplement: [FIG.],
)

#let subset-diagram(theme: chart-theme) = fig(
  canvas(length: 1cm, {
    import draw: *

    circle((3.2, 2.5), radius: 1.45, fill: theme.frontier.transparentize(78%), stroke: 0.7pt + theme.frontier)
    circle((5.0, 2.5), radius: 1.45, fill: theme.warning.transparentize(82%), stroke: 0.7pt + theme.warning)
    circle((4.1, 3.85), radius: 1.45, fill: theme.slm.transparentize(78%), stroke: 0.7pt + theme.slm)
    circle((4.1, 2.95), radius: .52, fill: theme.slm, stroke: none)

    content((2.0, 1.2), chart-label([Consensus], size: 8pt, fill: theme.frontier, weight: 600), anchor: "center")
    content((6.2, 1.2), chart-label([Hard], size: 8pt, fill: theme.warning, weight: 600), anchor: "center")
    content((4.1, 5.55), chart-label([Context-seeking], size: 8pt, fill: theme.slm, weight: 600), anchor: "center")

    content((4.1, 2.96), chart-label([1,216], size: 11pt, fill: white, weight: 700), anchor: "center")
    content((4.1, .55), chart-label([Hardest physician-validated HealthBench subset], size: 8pt, fill: theme.ink, weight: 600), anchor: "center")
  }),
  [Evaluation subset: the intersection of physician-consensus examples, hard examples, and context-seeking conversations, giving 1,216 examples.]
)

#let accuracy-bars(theme: chart-theme) = fig(
  canvas(length: 1cm, {
    import draw: *

    let x0 = 3.2
    let barw = 7.3
    let ytop = 5.15
    let rowh = .72

    for tick in (0, 25, 50, 75, 100) {
      let x = x0 + barw * tick / 100
      line((x, .75), (x, 5.65), stroke: 0.35pt + theme.grid)
      content((x, .35), chart-label([#(str(tick) + "%")], size: 6.2pt), anchor: "center")
    }

    for (i, model) in score-data.enumerate() {
      let y = ytop - i * rowh
      let c = chart-color(model.kind, theme: theme)
      let f = chart-fill(model.kind, theme: theme)
      content((.25, y), chart-label([#model.label], size: 7.2pt, fill: theme.ink), anchor: "west")
      rect((x0, y - .18), (x0 + barw, y + .18), radius: .04, fill: theme.faint, stroke: none)
      rect((x0, y - .18), (x0 + barw * model.value / 100, y + .18), radius: .04, fill: f, stroke: 0.5pt + c)
      content((x0 + barw * model.value / 100 + .2, y), chart-label([#model.value_label], size: 7pt, fill: c, weight: 700), anchor: "west")
    }

    line((x0, .75), (x0 + barw, .75), stroke: .7pt + theme.ink)
    content((.25, 5.9), chart-label([HealthBench score], size: 7pt, fill: theme.muted, weight: 600), anchor: "west")
  }),
  [HealthBench score on the Consensus / Hard / Context-seeking subset. The Tacit SLM is the only model above 90%.]
)

#let cost-scatter-graphic(theme: chart-theme, length: 1cm, compact: false) = canvas(length: length, {
    import draw: *

    let x0 = 1.1
    let y0 = .85
    let w = 8.8
    let h = 5.15
    let log-min = calc.log(100, base: 10)
    let log-max = calc.log(30000, base: 10)
    let x(cost) = x0 + (calc.log(cost, base: 10) - log-min) / (log-max - log-min) * w
    let y(score) = y0 + score / 100 * h

    for tick in ((value: 0, label: "0"), (value: 20, label: "0.2"), (value: 40, label: "0.4"), (value: 60, label: "0.6"), (value: 80, label: "0.8"), (value: 100, label: "1")) {
      let yy = y(tick.value)
      line((x0, yy), (x0 + w, yy), stroke: .35pt + theme.grid)
      content((.75, yy), chart-label([#tick.label], size: 6.2pt), anchor: "east")
    }
    for t in ((value: 100, label: "$100"), (value: 1000, label: "$1k"), (value: 10000, label: "$10k")) {
      let xx = x(t.value)
      line((xx, y0), (xx, y0 + h), stroke: .35pt + theme.grid)
      content((xx, .35), chart-label([#t.label], size: 6.2pt), anchor: "center")
    }

    line((x0, y0), (x0 + w, y0), stroke: .75pt + theme.ink)
    line((x0, y0), (x0, y0 + h), stroke: .75pt + theme.ink)
    content((x0 + w / 2, -.08), chart-label(if compact { [1M-query cost (\$)] } else { [Monthly inference cost at 1M queries (\$)] }, size: if compact { 6.2pt } else { 7pt }, weight: 600), anchor: "center")
    content((if compact { .08 } else { .18 }, y0 + h / 2), chart-label(if compact { [Score] } else { [HealthBench Score] }, size: if compact { 6.2pt } else { 7pt }, weight: 600), angle: 90deg, anchor: "center")

    for point in cost-data {
      let c = chart-color(point.kind, theme: theme)
      let px = x(point.cost)
      let py = y(point.score)
      circle((px, py), radius: .09, fill: c, stroke: none)
      content((px + point.dx, py + point.dy), chart-label([#point.label], size: 6.5pt, fill: c, weight: if point.kind == "slm" { 700 } else { 500 }), anchor: if point.dx < 0 { "east" } else { "west" })
    }
  })

#let cost-scatter(theme: chart-theme) = fig(
  cost-scatter-graphic(theme: theme),
  [Quality against inference cost. The Tacit SLM sits in the high-score, low-cost corner of the plot.]
)

#let reliability-curve-graphic(theme: chart-theme, length: 1cm, compact: false) = canvas(length: length, {
    import draw: *

    let x0 = 1.15
    let y0 = .85
    let w = 9.25
    let h = 5.55
    let x(k) = x0 + (k - 1) / 15 * w
    let y(v) = y0 + v / 100 * h

    for k in range(1, 17) {
      let xx = x(k)
      line((xx, y0), (xx, y0 + h), stroke: .25pt + theme.grid)
      if not compact or k in (1, 4, 8, 12, 16) {
        content((xx, .42), chart-label([#str(k)], size: 5.8pt), anchor: "center")
      }
    }
    for tick in (0, 20, 40, 60, 80, 100) {
      let yy = y(tick)
      line((x0, yy), (x0 + w, yy), stroke: .35pt + theme.grid)
      content((x0 - .25, yy), chart-label([#(str(tick) + "%")], size: 6.2pt), anchor: "east")
    }

    line((x0, y0), (x0 + w, y0), stroke: .75pt + theme.ink)
    line((x0, y0), (x0, y0 + h), stroke: .75pt + theme.ink)
    content((x0 + w / 2, -.05), chart-label([Number of samples (k)], size: 7pt, fill: theme.ink, weight: 600), anchor: "center")
    content((.18, y0 + h / 2), chart-label([Worst-of-k score], size: 7pt, fill: theme.ink, weight: 600), angle: 90deg, anchor: "center")

    for item in reliability-series {
      let c = chart-color(item.kind, theme: theme)
      let stroke-width = if item.kind == "slm" { 1.15pt } else { .65pt }
      for i in range(0, item.values.len() - 1) {
        line((x(i + 1), y(item.values.at(i))), (x(i + 2), y(item.values.at(i + 1))), stroke: stroke-width + c)
      }
      for (i, value) in item.values.enumerate() {
        circle((x(i + 1), y(value)), radius: if item.kind == "slm" { .075 } else { .06 }, fill: c, stroke: none)
      }
      if compact and item.kind == "slm" {
        content((x(1) + .18, y(item.values.first()) + .18), chart-label([#item.label], size: 6pt, fill: c, weight: 700), anchor: "west")
      }
      if item.kind == "slm" or not compact {
        content((x(16) + .18, y(item.values.last()) + item.end_dy), chart-label([#item.end_label], size: 6.3pt, fill: c, weight: if item.kind == "slm" { 700 } else { 500 }), anchor: "west")
      }
    }
    if not compact {
      let legend-x = x(10.3)
      let legend-y = y(56)
      let legend-row = .32
      rect(
        (legend-x - .16, legend-y - legend-row * (reliability-series.len() - 1) - .2),
        (legend-x + 2.55, legend-y + .18),
        radius: .04,
        fill: white.transparentize(7%),
        stroke: .35pt + theme.grid,
      )
      for (i, item) in reliability-series.enumerate() {
        let yy = legend-y - i * legend-row
        let c = chart-color(item.kind, theme: theme)
        let stroke-width = if item.kind == "slm" { 1.15pt } else { .65pt }
        line((legend-x, yy), (legend-x + .34, yy), stroke: stroke-width + c)
        circle((legend-x + .17, yy), radius: if item.kind == "slm" { .07 } else { .055 }, fill: c, stroke: none)
        content((legend-x + .46, yy), chart-label([#item.label], size: 5.9pt, fill: c, weight: if item.kind == "slm" { 700 } else { 500 }), anchor: "west")
      }
    }
    if compact {
      content((x(9.5), y(9)), chart-label([frontier/base collapse], size: 5.8pt, fill: theme.muted, weight: 600), anchor: "center")
    }
  })

#let reliability-slope(theme: chart-theme) = fig(
  reliability-curve-graphic(theme: theme),
  [Worst-of-k reliability curves across 16 samples. The Tacit SLM degrades slowly while frontier and base models collapse quickly.]
)

#let executive-summary-charts(theme: chart-theme) = figure(
  grid(
    columns: (1fr, 1fr),
    gutter: 10pt,
    [
      #align(center)[
        #text(font: theme.font, size: 7pt, weight: 700, fill: theme.ink)[Quality vs. inference cost]
        #v(2pt)
        #cost-scatter-graphic(theme: theme, length: .62cm, compact: true)
      ]
    ],
    [
      #align(center)[
        #text(font: theme.font, size: 7pt, weight: 700, fill: theme.ink)[Worst-of-k reliability]
        #v(2pt)
        #reliability-curve-graphic(theme: theme, length: .56cm, compact: true)
      ]
    ],
  ),
  caption: [Executive summary figures: quality against inference cost and worst-of-k reliability.]
)

#let behavior-panel(theme: chart-theme) = fig(
  grid(
    columns: (1fr, 1fr),
    gutter: 12pt,
    [
      #block(fill: theme.slm-light, stroke: .7pt + theme.slm, radius: 4pt, inset: 10pt)[
        #text(font: theme.font, size: 8pt, weight: 700, fill: theme.slm)[Tacit SLM]

        #v(5pt)
        #text(font: theme.font, size: 9pt, fill: theme.ink)[Stops and asks for missing clinical context before giving advice.]
      ]
    ],
    [
      #block(fill: theme.frontier-light, stroke: .7pt + theme.frontier, radius: 4pt, inset: 10pt)[
        #text(font: theme.font, size: 8pt, weight: 700, fill: theme.frontier)[Frontier and base models]

        #v(5pt)
        #text(font: theme.font, size: 9pt, fill: theme.ink)[Answer immediately, recommend next steps, or defer to care without first gathering the needed facts.]
      ]
    ],
  ),
  [Behavior on the sample rollout. The scoring difference is not bedside manner; it is whether the model recognizes the missing information boundary.]
)
