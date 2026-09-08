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

Hay 7 colores de unidad definidos. Cada curso les reasigna su propio significado temático; el CSS no cambia. Los colores se aplican a dots de sidebar, pills, líneas de encabezado y bordes izquierdos de fórmulas y bloques de problema.

| Variable | Valor | `electro/` | `termo/` | `termoquimica/` |
|----------|-------|------------|----------|-----------------|
| `--unit-1` | `#00d4ff` | Campo eléctrico (Aux 1–3) | Introducción (Cát. 1–2) | Gases ideales |
| `--unit-2` | `#3fb950` | Potencial y conductores (Aux 4–9) | Gas ideal y cinética (Cát. 3–5) | Gases reales |
| `--unit-3` | `#d29922` | Pre-control y dipolos (Aux 10–11) | Primera ley (Cát. 6–8) | Primera ley |
| `--unit-4` | `#f0883e` | Dieléctricos (Aux 12–14) | Segunda ley (Cát. 9–10) | Termoquímica |
| `--unit-5` | `#bc8cff` | Corrientes y circuitos (Aux 15–16) | Estadística y fases (Cát. 11–20) | — (libre) |
| `--unit-6` | `#f472b6` | Magnetismo (Aux 17–18) | Ciclos y máquinas (Cát. 21–23) | — (libre) |
| `--unit-7` | `#ef4444` | — | Gases reales y transporte (Cát. 24–28) | — (libre) |

Si se necesita un 8.º color, agregar `--unit-8` en `:root` y las clases `.u8`, `.dot-u8`, `.bg-u8` junto a las existentes.

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

Reemplazar el número 1–7 según la unidad.

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
  <div class="formula-math"><img class="typst-formula" src="clase_1_1.svg" alt=""></div>
  <div class="formula-desc">Descripción con <code>variables</code></div>
</div>
```
El SVG se compila desde `typst/<curso>/<página>.typ` con `./build.sh <curso>` y queda en la misma
carpeta que el `index.html`. Ver CLAUDE.md para las convenciones de Typst.

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

### `.problem-block`
Bloque de problema para las páginas de auxiliar. Mismo borde izquierdo de color de unidad que
`.formula-block`. Estructura:
```html
<div class="problem-block u1">
  <div class="problem-head">
    <span class="problem-num">P1</span>
    <span class="problem-title">Título corto del problema</span>
    <span class="problem-badge">Resuelto en aula</span>
  </div>
  <div class="problem-statement">
    Enunciado resumido. Si tiene incisos, van en un <ol> que se numera (a), (b), (c)…
  </div>
  <div class="problem-strategy">
    <div class="strategy-title">Estrategia</div>
    <ol><li>Paso 1</li><li>Paso 2</li></ol>
  </div>
</div>
```
- `.problem-badge` va alineado a la derecha; se usa para el origen del problema
  ("Resuelto en aula", "Propuesto", "C1 Primavera 2023").
- El `<ol>` de `.problem-statement` se numera con letras minúsculas entre paréntesis;
  el de `.problem-strategy`, con números en cuadrito.
- Admite `.formula-math` con un `<img class="typst-formula">` entre el enunciado y la estrategia.

### `.quiz`
Quiz de repaso al pie de la página, corregido por `styles/quiz.js`. Cada pregunta:
```html
<div class="quiz-q" id="qX_N" data-correct="2">
  <div class="quiz-question">Texto de la pregunta</div>
  <div class="quiz-options">
    <label class="quiz-option"><input type="radio" name="qX_N" value="0"><span class="opt-letter">A</span><span class="opt-text">…</span></label>
    <!-- value va de 0 en adelante, en orden -->
  </div>
  <script type="text/explanation" id="qX_N-exp">Explicación que se muestra al responder.</script>
  <div class="quiz-feedback" id="qX_N-fb"></div>
</div>
```
Reglas que `quiz.js` da por sentadas: el `name` de los radios debe ser igual al `id` del `.quiz-q`;
los `value` van `0,1,2,…` en el orden del DOM; y los ids de `-exp` y `-fb` derivan del mismo prefijo.
La página debe cargar `<script src="../../styles/quiz.js" defer></script>`.

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

Se carga por CDN en cada página, **sólo para math inline**:
```html
<script>
  MathJax = { tex: { inlineMath: [['$','$']] }, options: { skipHtmlTags: ['script','noscript','style','textarea'] } };
</script>
<script src="https://cdn.jsdelivr.net/npm/mathjax@3/es5/tex-chtml.js" async></script>
```

Las fórmulas inline usan `$...$` dentro de la prosa. Las de bloque **no** usan MathJax: se compilan
con Typst a SVG (`.typst-formula`). El `skipHtmlTags` con `script` es lo que evita que MathJax
procese los `<script type="text/explanation">` de los quizzes antes de tiempo.

### `.typst-formula`
Clase de los `<img>` de fórmulas compiladas: `display: block`, centrado, `max-width: 100%`.
