# Guía de Estilo

## Variables CSS (`:root`)

Todas las variables están en `styles/main.css`. Modificar aquí afecta todos los cursos.

### Paleta de colores

| Variable | Valor | Uso |
|----------|-------|-----|
| `--bg` | `#0d1117` | Fondo de página principal |
| `--bg-sidebar` | `#161b22` | Fondo de la sidebar |
| `--bg-card` | `#1c2128` | Tarjetas y bloques de fórmulas |
| `--bg-card-2` | `#22272e` | Hover de filas y elementos interactivos |
| `--border` | `#30363d` | Bordes de todos los elementos |
| `--text` | `#e6edf3` | Texto principal |
| `--text-muted` | `#8b949e` | Texto secundario (descripciones, subtítulos) |
| `--text-dimmed` | `#6e7681` | Texto terciario (números de aux, labels) |

### Colores de unidad temática

Cada curso usa hasta 5 unidades temáticas. Los colores se aplican a dots de sidebar, pills, líneas de encabezado y bordes izquierdos de fórmulas.

| Variable | Valor | Curso electro |
|----------|-------|---------------|
| `--unit-1` | `#00d4ff` | Campo eléctrico (Aux 1–3) |
| `--unit-2` | `#3fb950` | Potencial y conductores (Aux 4–9) |
| `--unit-3` | `#d29922` | Pre-control y dipolos (Aux 10–11) |
| `--unit-4` | `#f0883e` | Dieléctricos (Aux 12–14) |
| `--unit-5` | `#bc8cff` | Corrientes y circuitos (Aux 15–16) |

Para un curso nuevo, reasignar los significados temáticos a estos mismos colores (el CSS ya los tiene definidos). Si se necesita un 6.º color, agregar `--unit-6` en `:root` y las clases `.u6`, `.dot-u6`, `.bg-u6`.

### Tipografía

| Variable | Fuente | Uso |
|----------|--------|-----|
| Body | `'Inter'` (local) | Todo el texto de la página |
| Monospace | `'JetBrains Mono'` (local) | Números de auxiliar, snippets en `.formula-desc` |
| MathJax | CDN jsdelivr | Fórmulas LaTeX renderizadas |

Las fuentes están en `styles/fonts/`. El `@font-face` en `main.css` las carga con `font-display: swap`.

---

## Clases de utilidad por unidad

```css
.u1   /* color + border-color = --unit-1 */
.bg-u1 /* background con 12% de opacidad de --unit-1 */
.dot-u1 /* background sólido --unit-1, usado en sidebar dots */
```

Reemplazar el número 1–5 según la unidad.

---

## Componentes

### `.page-header`
Encabezado de cada página auxiliar. Contiene:
- `.breadcrumb` — navegación textual con link al temario
- `.unit-pill` — etiqueta de unidad (`<div class="unit-pill u2 bg-u2">`)
- `h1` — título del auxiliar
- `.desc` — descripción corta

### `.formula-block`
Bloque de fórmula con borde izquierdo de color de unidad. Requiere clase de unidad:
```html
<div class="formula-block u1">
  <div class="formula-label">Nombre de la fórmula</div>
  <div class="formula-math">$$\text{LaTeX aquí}$$</div>
  <div class="formula-desc">Descripción con <code>variables</code></div>
</div>
```

### `.concept-card` + `.card-grid`
Grilla 2×N de tarjetas de concepto. Cada tarjeta tiene `h3` + `p`.
```html
<div class="card-grid">
  <div class="concept-card">
    <h3>Título</h3>
    <p>Explicación...</p>
  </div>
</div>
```

### `.tip-box`
Caja de consejos al final de la página. Contiene `.tip-title` + `ul > li`.

### `.topic-list`
Lista con flechas `→` para los temas que cubre cada auxiliar.

### `.page-nav`
Navegación prev/next al pie. Link con clase `.next` para el link derecho.

### Tabla de temario (index)
```html
<div class="unit-group">
  <div class="unit-group-header">
    <div class="unit-line" style="background:var(--unit-1)"></div>
    <h2 class="u1">Nombre de la unidad</h2>
    <span class="unit-range">Aux N – M</span>
  </div>
  <table class="temario-table">...</table>
</div>
```

---

## Sidebar

La sidebar es idéntica en todas las páginas. La única diferencia es cuál `nav-link` tiene la clase `active`. El link activo se marca así:

```html
<a class="nav-link active" href="aux_3.html">
  <span class="dot dot-u1"></span>
  <span class="num">03</span> Gauss — Parte 2
</a>
```

---

## MathJax

Se carga por CDN en cada página:
```html
<script>
  MathJax = { tex: { inlineMath: [['$','$']] } };
</script>
<script src="https://cdn.jsdelivr.net/npm/mathjax@3/es5/tex-chtml.js" async></script>
```

Las fórmulas inline usan `$...$` y las de bloque `$$...$$`.
