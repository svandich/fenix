# Estructura del Proyecto

## Árbol de carpetas

```
repo-root/
├── index.html               ← Landing: tarjetas de todos los cursos
│
├── styles/                  ← Compartido por todos los cursos
│   ├── main.css
│   ├── quiz.js
│   └── fonts/
│       ├── Inter-Regular.woff2
│       ├── Inter-Medium.woff2
│       ├── Inter-SemiBold.woff2
│       ├── Inter-Bold.woff2
│       └── JetBrainsMono-Regular.woff2
│
├── basicos/                 ← Prerrequisitos de Cálculo (página única, sin sidebar)
│   ├── index.html
│   └── basicos_N.svg
│
├── electro/                 ← Electromagnetismo (DFI)
│   ├── index.html           ← Temario del curso
│   └── aux_N/
│       ├── index.html
│       └── aux_N_P.svg
│
├── termo/                   ← Termodinámica (DFI, física)
│   ├── index.html
│   ├── cat_N/               ← Cátedras 1–28
│   └── cc_N/                ← Clases complementarias 1–11
│
├── termoquimica/            ← Termodinámica Química (IQ2212, DIQBM)
│   ├── index.html
│   ├── clase_N/             ← Cátedras 1–8
│   └── aux_N/               ← Auxiliares 1–4
│
├── typst/                   ← Fuentes de las fórmulas
│   ├── electro/aux_N.typ
│   ├── termo/{cat,cc}_N.typ
│   ├── termoquimica/{clase,aux}_N.typ
│   └── basicos/basicos.typ
│
├── scripts/
│   ├── compile-typst.sh     ← Compila todos los .typ → SVG
│   └── update-html.py       ← (ya ejecutado) migró $$...$$ → <img>
│
├── build.sh                 ← ./build.sh [curso]
│
├── docs/                    ← Documentación del proyecto
│   ├── structure.md         ← Este archivo
│   ├── style-guide.md       ← Tokens de diseño y componentes CSS
│   ├── design-logic.md      ← Decisiones de diseño y razonamiento
│   ├── sidebar-maintenance.md   ← Spec del script sync-nav.py
│   └── typst-0.15-migration.md  ← Migración de los SVG a Typst 0.15
│
└── CLAUDE.md                ← Punto de entrada para Claude
```

## Regla de rutas

Cada página vive en su propia subcarpeta con un `index.html`, dos niveles bajo el root:

```html
<!-- desde <curso>/<página>/index.html -->
<link rel="stylesheet" href="../../styles/main.css">
<script src="../../styles/quiz.js" defer></script>
```

El temario de cada curso está un solo nivel abajo:

```html
<!-- desde <curso>/index.html -->
<link rel="stylesheet" href="../styles/main.css">
```

Los links de navegación son relativos dentro de la misma carpeta del curso:

```html
<a href="../">Temario</a>
<a href="../clase_2/">Siguiente</a>
```

Los SVGs de fórmulas viven **junto** al `index.html` que los usa, así que se referencian sin ruta:

```html
<img class="typst-formula" src="clase_2_1.svg" alt="">
```

## Convención de nombres

| Curso | Prefijo de carpeta | Rango |
|-------|--------------------|-------|
| `electro/` | `aux_N/` | 1–25 |
| `termo/` | `cat_N/` · `cc_N/` | 1–28 · 1–11 |
| `termoquimica/` | `clase_N/` · `aux_N/` | 1–8 · 1–4 |
| `basicos/` | — (página única) | — |

`N` va sin cero a la izquierda. El SVG número `P` del archivo `<página>.typ` se llama `<página>_P.svg`.

Clases CSS de unidad: `.u1` a `.u7` (ver [style-guide.md](style-guide.md)).

## Cómo agregar un curso nuevo

1. Crear `nombre-curso/` en el root.
2. Crear `nombre-curso/index.html` basado en la plantilla de `termoquimica/index.html` (temario con `unit-group` + `temario-table`).
3. Referenciar el CSS compartido: `href="../styles/main.css"` desde el temario, `../../styles/main.css` desde las páginas.
4. Crear las carpetas de página con su `index.html` dentro, usando un prefijo consistente.
5. Crear `typst/nombre-curso/<página>.typ` por cada página.
6. Registrar el curso en el array `COURSES` y en `prefixes_for()` de `scripts/compile-typst.sh`.
7. Agregar la tarjeta del curso al `index.html` del root.
8. Reutilizar las variables CSS de unidad, reasignando su significado temático al nuevo curso.

## Cómo cambiar el estilo globalmente

Editar `styles/main.css`. Los cambios aplican automáticamente a todos los cursos. Las variables CSS en `:root` controlan colores, espaciado y tipografía.
