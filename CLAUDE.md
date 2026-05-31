# Apuntes de Cursos — CLAUDE.md

Repositorio de apuntes interactivos para cursos de ingeniería. Cada curso es una carpeta HTML+CSS estática, compartiendo estilos y tipografía desde `styles/`.

## Cursos disponibles

| Carpeta | Curso | Estado |
|---------|-------|--------|
| `electro/` | Electromagnetismo (Aux 1–18) | Completo |
| `termo/` | Termodinámica (cátedras, no auxiliares) | En construcción |

## Estructura

```
repo-root/
├── styles/main.css           ← CSS compartido por todos los cursos
├── styles/fonts/             ← Inter + JetBrains Mono (locales)
├── electro/                  ← index.html + aux_N.html × 16
├── termo/                    ← index.html + aux_N.html × 12
├── typst/
│   ├── electro/aux_N.typ     ← Fuentes Typst de fórmulas (electro, N=1–16)
│   └── termo/aux_N.typ       ← Fuentes Typst de fórmulas (termo, N=1–12, cátedras)
├── typst-out/                ← SVGs compilados (regenerar con ./build.sh)
│   ├── electro/aux_N_P.svg
│   └── termo/aux_N_P.svg
├── scripts/
│   ├── compile-typst.sh      ← Compila todos los .typ → SVG
│   └── update-html.py        ← (ya ejecutado) migró $$...$$ → <img> en los HTML
├── docs/
│   ├── structure.md          ← Árbol de carpetas y convenciones
│   ├── style-guide.md        ← Variables CSS, componentes, clases
│   └── design-logic.md       ← Por qué se tomaron las decisiones de diseño
├── build.sh                  ← ./build.sh [curso] — compila Typst → SVG
├── .gitignore                ← Excluye node_modules/
└── CLAUDE.md                 ← Este archivo
```

Ver [docs/structure.md](docs/structure.md) para el árbol completo y las reglas de rutas.

## Sistema de fórmulas: Typst + SVG

Las fórmulas de display (`$$...$$`) se renderizan con **Typst**, no con MathJax.

**Flujo de trabajo:**
1. Editar la fórmula en `typst/<curso>/aux_N.typ`
2. Compilar: `./build.sh` (o solo un curso: `./build.sh electro`)
3. Refrescar el navegador — los SVGs en `typst-out/` se actualizan

**Convenciones de los archivos `.typ`:**
- Una fórmula por "página" Typst, separadas por `#pagebreak()`
- Header fijo en todos los archivos:
  ```typst
  #set page(width: auto, height: auto, margin: (x: 0.5em, y: 0.3em), fill: none)
  #set text(fill: rgb("#e6edf3"), size: 13pt)
  ```
- El SVG N° P de `aux_N.typ` se llama `typst-out/<curso>/aux_N_P.svg`
- En el HTML, cada fórmula es `<div class="formula-math"><img class="typst-formula" src="../typst-out/<curso>/aux_N_P.svg" alt=""></div>`

**MathJax** se mantiene en `<head>` para el math inline (`$...$`) en texto de descripciones. Las fórmulas de display ya no usan MathJax.

**Sintaxis Typst relevante** (diferencias con LaTeX):
| LaTeX | Typst |
|-------|-------|
| `\mathbf{E}` | `bold(E)` |
| `\epsilon_0` | `epsilon.alt_0` |
| `\nabla` | `nabla` |
| `\langle X \rangle` | `chevron.l X chevron.r` |
| `\bar{\delta}Q` | `macron(delta) Q` |
| `\xrightarrow{\text{foo}}` | `limits(arrow.r.long)^"foo"` |
| `\begin{cases}...\end{cases}` | `cases(...)` |
| `\oint` | `integral.cont` |
| `\cdot` | `dot.op` |

## Cómo agregar una página nueva a un curso existente

> **Nota:** En `electro/` las páginas se llaman "auxiliares"; en `termo/` se llaman "cátedras". Los nombres de archivo (`aux_N.html`) son internos y no cambian.

1. Copiar `electro/aux_1.html` como plantilla.
2. Cambiar el número, título y unidad (`u1`–`u5`) en `.page-header`.
3. Actualizar el `<h1>` para usar "Auxiliar N:" (electro) o "Cátedra N:" (termo).
4. Marcar el link correcto como `active` en la sidebar.
5. Rellenar las 4 secciones: temas, conceptos, fórmulas, tips.
   - Las fórmulas de display van como `<img class="typst-formula" src="../typst-out/<curso>/aux_N_P.svg" alt="">`.
6. Crear el archivo `typst/<curso>/aux_N.typ` con las fórmulas correspondientes.
7. Compilar: `./build.sh <curso>`.
8. Actualizar `index.html` del curso con una fila nueva en la tabla.

## Cómo agregar un curso nuevo

1. `mkdir nombre-curso/` en el root.
2. Copiar `electro/index.html` como base del temario.
3. Actualizar CSS link: `href="../styles/main.css"`.
4. Reasignar los colores `--unit-1` a `--unit-5` a las unidades del nuevo curso.
5. Crear las páginas `aux_N.html`.
6. Crear `typst/nombre-curso/aux_N.typ` por cada auxiliar.
7. Agregar el curso al array `COURSES` en `scripts/compile-typst.sh`.

Ver [docs/structure.md](docs/structure.md) para más detalle.

## Convenciones de CSS

- Variables de color: `--unit-1` a `--unit-5` (ver [docs/style-guide.md](docs/style-guide.md)).
- Clases de color por unidad: `.u1`–`.u5`, `.bg-u1`–`.bg-u5`, `.dot-u1`–`.dot-u5`.
- Componentes: `.formula-block`, `.concept-card`, `.card-grid`, `.tip-box`, `.page-nav`.
- `.typst-formula` — clase en los `<img>` de fórmulas Typst (display: block, centrado).

## Tecnologías

- HTML/CSS vanilla — sin frameworks, sin build step para el HTML.
- Fuentes locales en `styles/fonts/` (Inter, JetBrains Mono).
- **Typst 0.14** — CLI local para compilar fórmulas de display a SVG.
- MathJax 3 CDN para math inline (`$...$`) en texto de descripciones.
- Sin JavaScript propio.

## Abrir localmente

Abrir cualquier `index.html` directamente en el navegador (no requiere servidor).
MathJax necesita conexión a internet para cargar desde CDN.
Los SVGs en `typst-out/` están trackeados en git — regenerar con `./build.sh` si se editan los `.typ`.
