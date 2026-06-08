# Apuntes de Cursos — CLAUDE.md

Repositorio de apuntes interactivos para cursos de ingeniería. Cada curso es una carpeta HTML+CSS estática, compartiendo estilos y tipografía desde `styles/`.

## Cursos disponibles

| Carpeta | Curso | Estado |
|---------|-------|--------|
| `electro/` | Electromagnetismo (Aux 1–18) | Completo |
| `termo/` | Termodinámica (Cat 1–20 + CC 1–7) | En construcción |

## Estructura

```
repo-root/
├── styles/main.css           ← CSS compartido por todos los cursos
├── styles/fonts/             ← Inter + JetBrains Mono (locales)
├── electro/                  ← index.html + aux_N/index.html × 18
├── termo/                    ← index.html + cat_N/index.html × 20 + cc_N/index.html × 7
├── typst/
│   ├── electro/aux_N.typ     ← Fuentes Typst de fórmulas (electro, N=1–16)
│   ├── termo/cat_N.typ       ← Fuentes Typst de cátedras (N=1–20)
│   └── termo/cc_N.typ        ← Fuentes Typst de clases complementarias (N=1–7)
│   (los SVGs compilados viven en <curso>/<página>/ junto con el index.html)
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
1. Editar la fórmula en `typst/<curso>/<página>.typ` (ej. `cat_3.typ`, `cc_1.typ`, `aux_5.typ`)
2. Compilar: `./build.sh` (o solo un curso: `./build.sh electro`)
3. Refrescar el navegador — los SVGs en `typst-out/` se actualizan

**Convenciones de los archivos `.typ`:**
- Una fórmula por "página" Typst, separadas por `#pagebreak()`
- Header fijo en todos los archivos:
  ```typst
  #set page(width: auto, height: auto, margin: (x: 0.5em, y: 0.3em), fill: none)
  #set text(fill: rgb("#e6edf3"), size: 13pt)
  ```
- El SVG N° P de `<página>.typ` se compila a `<curso>/<página>/<página>_P.svg` (junto al HTML)
  - Ejemplos: `cat_3.typ` → `termo/cat_3/cat_3_1.svg`; `cc_1.typ` → `termo/cc_1/cc_1_1.svg`; `aux_5.typ` → `electro/aux_5/aux_5_1.svg`
- En el HTML, cada fórmula es `<div class="formula-math"><img class="typst-formula" src="<página>_P.svg" alt=""></div>`

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

> **Nota:** El prefijo de carpeta varía por curso y tipo:
> - `electro/`: auxiliares → `aux_N/`
> - `termo/`: cátedras → `cat_N/`; clases complementarias → `cc_N/`
>
> Cada página vive en su propia subcarpeta con un `index.html`.

1. Crear la carpeta `<curso>/<página>/` (ej. `termo/cat_21/`) y copiar una página existente del mismo curso como plantilla.
2. Cambiar el número, título y unidad (`u1`–`u5`) en `.page-header`.
3. Actualizar el `<h1>` para usar "Auxiliar N:" (electro), "Cátedra N:" o "CC N:" (termo).
4. Marcar el link correcto como `active` en la sidebar.
5. Rellenar las 4 secciones: temas, conceptos, fórmulas, tips.
   - Las fórmulas de display van como `<img class="typst-formula" src="<página>_P.svg" alt="">` (SVGs en la misma carpeta).
   - CSS: `href="../../styles/main.css"` (dos niveles arriba).
6. Crear el archivo `typst/<curso>/<página>.typ` con las fórmulas correspondientes.
7. Compilar: `./build.sh <curso>`.
8. Actualizar `index.html` del curso con una fila nueva en la tabla (link: `<página>/`).

## Cómo agregar un curso nuevo

1. `mkdir nombre-curso/` en el root.
2. Copiar `electro/index.html` como base del temario.
3. Actualizar CSS link en las páginas: `href="../../styles/main.css"` (dos niveles).
4. Reasignar los colores `--unit-1` a `--unit-5` a las unidades del nuevo curso.
5. Crear las carpetas `<página>/` con `index.html` dentro de cada una (usando el prefijo que corresponda: `aux_N/`, `cat_N/`, etc.).
6. Crear `typst/nombre-curso/<página>.typ` por cada página.
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
