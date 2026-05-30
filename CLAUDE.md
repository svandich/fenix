# Apuntes de Cursos — CLAUDE.md

Repositorio de apuntes interactivos para cursos de ingeniería. Cada curso es una carpeta HTML+CSS estática, compartiendo estilos y tipografía desde `styles/`.

## Cursos disponibles

| Carpeta | Curso | Estado |
|---------|-------|--------|
| `electro/` | Electromagnetismo (Aux 1–16) | Completo |
| `termo/` | Termodinámica | En construcción |

## Estructura

```
repo-root/
├── styles/main.css       ← CSS compartido por todos los cursos
├── styles/fonts/         ← Inter + JetBrains Mono (locales)
├── electro/              ← index.html + aux_N.html × 16
├── termo/                ← index.html + aux_N.html (futuro)
├── docs/
│   ├── structure.md      ← Árbol de carpetas y convenciones
│   ├── style-guide.md    ← Variables CSS, componentes, clases
│   └── design-logic.md   ← Por qué se tomaron las decisiones de diseño
└── CLAUDE.md             ← Este archivo
```

Ver [docs/structure.md](docs/structure.md) para el árbol completo y las reglas de rutas.

## Cómo agregar un auxiliar nuevo a un curso existente

1. Copiar `electro/aux_1.html` como plantilla.
2. Cambiar el número, título y unidad (`u1`–`u5`) en `.page-header`.
3. Marcar el link correcto como `active` en la sidebar.
4. Rellenar las 4 secciones: temas, conceptos, fórmulas, tips.
5. Actualizar `index.html` del curso con una fila nueva en la tabla.

## Cómo agregar un curso nuevo

1. `mkdir nome-curso/` en el root.
2. Copiar `electro/index.html` como base del temario.
3. Actualizar CSS link: `href="../styles/main.css"`.
4. Reasignar los colores `--unit-1` a `--unit-5` a las unidades del nuevo curso (los colores son globales, los significados son por curso).
5. Crear las páginas `aux_N.html`.

Ver [docs/structure.md](docs/structure.md) para más detalle.

## Convenciones de CSS

- Variables de color: `--unit-1` a `--unit-5` (ver [docs/style-guide.md](docs/style-guide.md)).
- Clases de color por unidad: `.u1`–`.u5`, `.bg-u1`–`.bg-u5`, `.dot-u1`–`.dot-u5`.
- Componentes: `.formula-block`, `.concept-card`, `.card-grid`, `.tip-box`, `.page-nav`.

## Tecnologías

- HTML/CSS vanilla — sin frameworks, sin build step.
- Fuentes locales en `styles/fonts/` (Inter, JetBrains Mono).
- MathJax 3 CDN para renderizado de fórmulas LaTeX.
- Sin JavaScript propio.

## Abrir localmente

Abrir cualquier `index.html` directamente en el navegador (no requiere servidor).
MathJax necesita conexión a internet para cargar desde CDN.
