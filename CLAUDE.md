# Apuntes de Cursos — CLAUDE.md

Repositorio de apuntes interactivos para cursos de ingeniería. Cada curso es una carpeta HTML+CSS estática, compartiendo estilos y tipografía desde `styles/`.

## Cursos disponibles

| Carpeta | Curso | Estado |
|---------|-------|--------|
| `basicos/` | Prerrequisitos de Cálculo (1 página) | Completo |
| `electro/` | Electromagnetismo (Aux 1–25) | Incompleto |
| `termo/` | Termodinámica — DFI, física (Cat 1–28 + CC 1–11) | Completo |
| `termoquimica/` | Termodinámica Química — IQ2212, DIQBM (Clases 1–8 + Aux 1–4) | En curso |

## Estructura

```
repo-root/
├── styles/main.css           ← CSS compartido por todos los cursos
├── styles/fonts/             ← Inter + JetBrains Mono (locales)
├── basicos/                  ← index.html (página única, sin sidebar, usa MathJax display)
├── electro/                  ← index.html + aux_N/index.html × 25
├── termo/                    ← index.html + cat_N/index.html × 28 + cc_N/index.html × 11
├── termoquimica/             ← index.html + clase_N/index.html × 8 + aux_N/index.html × 4
├── typst/
│   ├── electro/aux_N.typ     ← Fuentes Typst de fórmulas (electro, N=1–25)
│   ├── termo/cat_N.typ       ← Fuentes Typst de cátedras (N=1–28)
│   ├── termo/cc_N.typ        ← Fuentes Typst de clases complementarias (N=1–11)
│   ├── termoquimica/clase_N.typ ← Fuentes Typst de cátedras IQ2212 (N=1–8)
│   └── termoquimica/aux_N.typ   ← Fuentes Typst de auxiliares IQ2212 (N=1–4)
│   (los SVGs compilados viven en <curso>/<página>/ junto con el index.html)
├── scripts/
│   ├── compile-typst.sh      ← Compila todos los .typ → SVG
│   ├── courses.py            ← Manifiesto: fuente de verdad de sidebar y prev/next
│   ├── sync-nav.py           ← Regenera sidebar y prev/next en las 79 páginas
│   ├── verify-typst-migration.py ← Chequea que recompilar no cambió nada visible
│   └── update-html.py        ← (ya ejecutado) migró $$...$$ → <img> en los HTML
├── docs/
│   ├── structure.md          ← Árbol de carpetas y convenciones
│   ├── style-guide.md        ← Variables CSS, componentes, clases
│   ├── design-logic.md       ← Por qué se tomaron las decisiones de diseño
│   ├── sidebar-maintenance.md   ← Cómo funciona sync-nav.py y el manifiesto de cursos
│   └── typst-0.15-migration.md  ← Registro de la migración a 0.15 y receta para subir de versión
├── build.sh                  ← ./build.sh [curso] — compila Typst → SVG
├── .gitignore                ← Excluye node_modules/
└── CLAUDE.md                 ← Este archivo
```

Ver [docs/structure.md](docs/structure.md) para el árbol completo y las reglas de rutas.

## Sistema de fórmulas: Typst + SVG

Las fórmulas de display (`$$...$$`) se renderizan con **Typst**, no con MathJax.

**Flujo de trabajo:**
1. Editar la fórmula en `typst/<curso>/<página>.typ` (ej. `cat_3.typ`, `cc_1.typ`, `aux_5.typ`, `clase_2.typ`)
2. Compilar: `./build.sh <curso>` (o `./build.sh` para todos)
3. Refrescar el navegador — los SVGs en `<curso>/<página>/` se actualizan

Todo el repo está compilado con la misma versión de Typst, así que `./build.sh` sin argumentos es
idempotente: recompilar sin tocar ningún `.typ` deja los SVGs byte a byte iguales y no genera diff.

**Convenciones de los archivos `.typ`:**
- Una fórmula por "página" Typst, separadas por `#pagebreak()`
- Header fijo en todos los archivos:
  ```typst
  #set page(width: auto, height: auto, margin: (x: 0.5em, y: 0.3em), fill: none)
  #set text(fill: rgb("#e6edf3"), size: 13pt)
  ```
- El SVG N° P de `<página>.typ` se compila a `<curso>/<página>/<página>_P.svg` (junto al HTML)
  - Ejemplos: `cat_3.typ` → `termo/cat_3/cat_3_1.svg`; `cc_1.typ` → `termo/cc_1/cc_1_1.svg`; `aux_5.typ` → `electro/aux_5/aux_5_1.svg`; `clase_2.typ` → `termoquimica/clase_2/clase_2_1.svg`
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
| `\left(\frac{\partial U}{\partial V}\right)_T` | `lr((partial U)/(partial V))_T` |
| `\underbrace{x}_{\text{foo}}` | `underbrace(x, "foo")` |
| `H^\circ` (estado estándar) | `H^circle.stroked.small` |
| `\begin{array}{l}` sin delimitadores | `mat(delim: #none, align: #left, ...)` |

## Cómo agregar una página nueva a un curso existente

> ⚠️ La sidebar y el bloque prev/next están **copiados en cada página** del curso (79 archivos en
> total), pero **no se editan a mano**: los genera `./scripts/sync-nav.py` desde el manifiesto
> `scripts/courses.py`. Agregar una página es agregar una línea al manifiesto y correr el script.
> Ver [docs/sidebar-maintenance.md](docs/sidebar-maintenance.md).

> **Nota:** El prefijo de carpeta varía por curso y tipo:
> - `electro/`: auxiliares → `aux_N/`
> - `termo/`: cátedras → `cat_N/`; clases complementarias → `cc_N/`
> - `termoquimica/`: cátedras → `clase_N/`; auxiliares → `aux_N/`
>
> Cada página vive en su propia subcarpeta con un `index.html`.

1. Crear la carpeta `<curso>/<página>/` (ej. `termo/cat_21/`) y copiar una página existente del mismo curso como plantilla.
2. Cambiar el número, título y unidad (`u1`–`u7`) en `.page-header`.
3. Actualizar el `<h1>` para usar "Auxiliar N:" (electro), "Cátedra N:" o "CC N:" (termo), "Clase N:" o "Auxiliar N:" (termoquimica).
4. Agregar la página a `scripts/courses.py`, en la posición que le toca dentro de `pages`
   (y en `nav_order` si el curso lo define). No tocar la sidebar ni el `page-nav` a mano.
5. Rellenar las secciones: temas, conceptos, fórmulas, tips y quiz.
   - En `termoquimica/`, las páginas `aux_N/` reemplazan "conceptos clave" por "herramientas" y añaden una sección de problemas (`.problem-block`) con enunciado + estrategia, sin resultados numéricos.
   - Las fórmulas de display van como `<img class="typst-formula" src="<página>_P.svg" alt="">` (SVGs en la misma carpeta).
   - CSS: `href="../../styles/main.css"` (dos niveles arriba).
6. Crear el archivo `typst/<curso>/<página>.typ` con las fórmulas correspondientes.
7. Compilar: `./build.sh <curso>`.
8. Sincronizar la navegación: `./scripts/sync-nav.py <curso>`. Esto escribe la sidebar y el
   prev/next en las 13, 26 o 40 páginas del curso, incluido su `index.html`.
9. Actualizar `index.html` del curso con una fila nueva en la tabla del temario (link: `<página>/`).
   Esta tabla es contenido de la página y el script no la toca.

## Cómo agregar un curso nuevo

1. `mkdir nombre-curso/` en el root.
2. Copiar `electro/index.html` como base del temario.
3. Actualizar CSS link en las páginas: `href="../../styles/main.css"` (dos niveles).
4. Reasignar los colores `--unit-1` a `--unit-7` a las unidades del nuevo curso.
5. Crear las carpetas `<página>/` con `index.html` dentro de cada una (usando el prefijo que corresponda: `aux_N/`, `cat_N/`, etc.).
6. Crear `typst/nombre-curso/<página>.typ` por cada página.
7. Agregar el curso al array `COURSES` en `scripts/compile-typst.sh`.
8. Agregar el curso al dict `COURSES` de `scripts/courses.py` y correr `./scripts/sync-nav.py <curso>`
   para que genere las sidebars.

Ver [docs/structure.md](docs/structure.md) para más detalle.

## Convenciones de CSS

- Variables de color: `--unit-1` a `--unit-7` (ver [docs/style-guide.md](docs/style-guide.md)).
- Clases de color por unidad: `.u1`–`.u7`, `.bg-u1`–`.bg-u7`, `.dot-u1`–`.dot-u7`.
- Componentes: `.formula-block`, `.concept-card`, `.card-grid`, `.tip-box`, `.page-nav`, `.problem-block`.
- `.typst-formula` — clase en los `<img>` de fórmulas Typst (display: block, centrado).

## Tecnologías

- HTML/CSS vanilla — sin frameworks, sin build step para el HTML.
- Fuentes locales en `styles/fonts/` (Inter, JetBrains Mono).
- **Typst 0.15.1** — CLI local para compilar fórmulas de display a SVG (`pacman -S typst` en Arch).
  Los 333 SVG del repo están compilados con esta versión exacta. Subir de versión cambia los hashes
  de los ids de glifo y reescribe todos los archivos, sin cambio visual: ver
  [docs/typst-0.15-migration.md](docs/typst-0.15-migration.md) antes de hacerlo.
- MathJax 3 CDN para math inline (`$...$`) en texto de descripciones.
- `styles/quiz.js` — único JS propio: corrige los quizzes de repaso al vuelo.
- `scripts/sync-nav.py` — genera la sidebar y el prev/next de las 79 páginas desde `scripts/courses.py`.
  `./scripts/sync-nav.py --check` sale con código 1 si algo quedó desincronizado (sirve para pre-commit).

## Abrir localmente

Abrir cualquier `index.html` directamente en el navegador (no requiere servidor).
MathJax necesita conexión a internet para cargar desde CDN.
Los SVGs están trackeados en git junto al HTML de cada página — regenerar con `./build.sh` si se editan los `.typ`.

## Convenios que difieren entre cursos

`termo/` (física, DFI) y `termoquimica/` (química, DIQBM) cubren temas que se solapan pero **usan
convenios de signo opuestos** para la primera ley:

| | `termo/` | `termoquimica/` |
|---|---|---|
| Primera ley | `dU = δQ + δW` | `dU = δQ − δW` |
| `W > 0` significa | trabajo **sobre** el sistema (compresión) | trabajo **producido por** el sistema (expansión) |

Al escribir o revisar fórmulas hay que respetar el convenio del curso correspondiente. No unificarlos:
cada uno refleja el que usa su cátedra.
