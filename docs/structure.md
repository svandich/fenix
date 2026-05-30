# Estructura del Proyecto

## Árbol de carpetas

```
repo-root/
├── styles/                  ← Compartido por todos los cursos
│   ├── main.css
│   └── fonts/
│       ├── Inter-Regular.woff2
│       ├── Inter-Medium.woff2
│       ├── Inter-SemiBold.woff2
│       ├── Inter-Bold.woff2
│       └── JetBrainsMono-Regular.woff2
│
├── electro/                 ← Curso de Electromagnetismo
│   ├── index.html           ← Temario del curso
│   ├── aux_1.html
│   ├── aux_2.html
│   └── ...
│
├── termo/                   ← Curso de Termodinámica (futuro)
│   ├── index.html
│   └── ...
│
├── docs/                    ← Documentación del proyecto
│   ├── structure.md         ← Este archivo
│   ├── style-guide.md       ← Tokens de diseño y componentes CSS
│   └── design-logic.md      ← Decisiones de diseño y razonamiento
│
└── CLAUDE.md                ← Punto de entrada para Claude
```

## Regla de rutas

Los HTML están una carpeta adentro del root, por eso referencian el CSS así:

```html
<link rel="stylesheet" href="../styles/main.css">
```

Los links internos de navegación son relativos dentro de la misma carpeta del curso:

```html
<a href="index.html">Temario</a>
<a href="aux_2.html">Siguiente</a>
```

## Cómo agregar un curso nuevo

1. Crear `nombre-curso/` en el root.
2. Crear `nombre-curso/index.html` basado en la plantilla de `electro/index.html`.
3. Referenciar el CSS compartido: `href="../styles/main.css"`.
4. Crear `nombre-curso/aux_N.html` para cada sesión de auxiliar.
5. Reutilizar las variables CSS de unidad (o agregar nuevas en `styles/main.css`).

## Cómo cambiar el estilo globalmente

Editar `styles/main.css`. Los cambios aplican automáticamente a todos los cursos. Las variables CSS en `:root` controlan colores, espaciado y tipografía.

## Convención de nombres

- Un `index.html` por curso (temario general con la tabla de auxiliares).
- Páginas de auxiliar: `aux_N.html` donde `N` es el número sin cero a la izquierda.
- Clases CSS de unidad: `.u1` a `.u5` (ver style-guide.md para ampliar).
