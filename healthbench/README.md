# HealthBench SLM Field Note

This folder contains a Typst draft adapted from the HealthBench report into a Tacit field-note style blog article.

## Files

- `slm-healthbench-field-note.typ` - main article source.
- `charts.typ` - reusable chart/data/style module. Change palette, fonts, line weights, and chart data here.
- `dist/` - generated output after compilation.

## Compile

```sh
mkdir -p dist
typst compile slm-healthbench-field-note.typ dist/slm-healthbench-field-note.pdf
```

## Restyling The Charts

All chart visuals use data-driven Typst/CeTZ functions in `charts.typ`.

The main restyling surface is `chart-theme`:

- `slm`, `slm-light` - Tacit SLM color and light fill.
- `frontier`, `frontier-light` - frontier model comparator color.
- `base`, `base-light` - base open model color.
- `ink`, `muted`, `grid`, `faint` - text, axis, and grid treatment.
- `font` - chart label font.

The charts are not screenshots. They can be adjusted, exported, or copied into a later Tacit visual system without changing the prose.
