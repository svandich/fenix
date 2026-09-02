# Mantención de sidebars y navegación

La sidebar y el bloque prev/next están **copiados literalmente en cada una de las 79 páginas** del
repo. No se editan a mano: los genera `scripts/sync-nav.py` desde el manifiesto `scripts/courses.py`.

| Curso | index | páginas | total |
|-------|-------|---------|-------|
| `electro/` | 1 | 25 | 26 |
| `termo/` | 1 | 39 | 40 |
| `termoquimica/` | 1 | 12 | 13 |

---

## 1. Uso

| Comando | Efecto |
|---------|--------|
| `./scripts/sync-nav.py` | Sincroniza los tres cursos |
| `./scripts/sync-nav.py termoquimica` | Sincroniza sólo ese curso |
| `./scripts/sync-nav.py --check` | No escribe; sale con código 1 si algo está desincronizado |
| `./scripts/sync-nav.py --diff` | Muestra el diff que aplicaría, sin escribir |

`--check` es el que sirve para un hook de pre-commit o para CI.

Para agregar una página: crear su carpeta, agregar una línea a `pages` en `scripts/courses.py` (y a
`nav_order` si el curso lo define), y correr `./scripts/sync-nav.py <curso>`. El script escribe la
sidebar y el prev/next en las 13, 26 o 40 páginas del curso, incluido su `index.html`.

El script **no toca nada fuera de esos dos bloques**. La tabla del temario en `<curso>/index.html` es
contenido de la página y se sigue editando a mano.

---

## 2. El manifiesto

`scripts/courses.py` es la única fuente de verdad. Un curso se ve así:

```python
'termoquimica': {
    'icon': '🧪',
    'name': 'Termodinámica Química',
    'subtitle': 'IQ2212 · Clases 1–8 · Aux 1–4',
    'blocks': ['Gases ideales', 'Gases reales', 'Primera ley', 'Termoquímica'],
    # slug, num, etiqueta sidebar, unidad, bloque, título para el prev/next
    'pages': [
        ('clase_1', '01', 'Gas Ideal y Dalton', 'u1', 'Gases ideales', 'Gas Ideal, Leyes Empíricas y Ley de Dalton'),
        ('aux_1'  , 'A1', 'Gases Ideales'     , 'u1', 'Gases ideales', 'Gases Ideales'),
        # …
    ],
},
```

- El orden de `blocks` es el orden de las secciones; el orden de `pages` es el orden dentro de cada
  sección. Juntos definen la sidebar y, por defecto, también la cadena prev/next.
- `subtitle` es explícito a propósito: es exactamente el campo que se quedó atrás en `electro/`
  (decía "Auxiliares 1 – 18" en 16 páginas), y tenerlo en el manifiesto es lo que permite que
  `--check` detecte que se desactualizó.

### Los dos títulos de cada página son distintos

Cada página lleva **dos** textos y no son intercambiables:

| Campo | Dónde sale | Ejemplo (`electro/aux_25`) |
|-------|------------|----------------------------|
| etiqueta sidebar | link de la sidebar, ancho ~200 px | `Vector H` |
| título prev/next | `<div class="nav-title">` del pie | `Vector Intensidad Magnética` |

Y ninguno de los dos es el `<h1>` (`Auxiliar 25: Vector Intensidad Magnética`). En `termo/` la
diferencia es sistemática — la sidebar abrevia (`Transform. Legendre`, `Cap. Calórica`) y el pie no —
y en `termo/cc_*` el título del pie conserva el prefijo `CC1:` mientras el de la sidebar no. Por eso
son dos columnas del manifiesto y no una derivada de la otra.

### `nav_order`: cuando la sidebar y el prev/next difieren

`termo/` es el único curso donde el orden de la sidebar y la cadena prev/next no coinciden, y es
deliberado: la sidebar intercala cátedras y clases complementarias por tema (`cat_20` → `cc_1`),
mientras que el prev/next recorre `cat_1…cat_28` y después `cc_1…cc_11` como dos secuencias
numéricas. El manifiesto conserva ese comportamiento con un campo `nav_order` explícito.

Para que `termo/` pase a usar el hilo temático de la sidebar también en el prev/next, **basta con
borrar `nav_order`** del manifiesto y volver a correr el script. Los otros dos cursos no lo definen.

---

## 3. Contrato del marcado

### Delimitadores

```python
SIDEBAR = re.compile(r'<nav class="sidebar">.*?</nav>', re.S)
PAGENAV = re.compile(r'<div class="page-nav">.*?</div>(?=\s*</div>\s*</main>)', re.S)
```

`page-nav` contiene `<div>` anidados, así que un `.*?</div>` a secas corta demasiado pronto. Se ancla
en el `</main>` que le sigue, pero con un *lookahead*: así la cola (`</div>\n</main>`) queda fuera del
reemplazo y no se reescribe. El script aborta si alguno de los dos bloques no aparece exactamente una
vez en un archivo.

### Sidebar — forma canónica

```html
<nav class="sidebar">
  <div class="sidebar-header">
    <a class="sidebar-logo" href="{HOME}">
      <span class="icon">{ICON}</span>
      <div><div class="name">{NAME}</div><div class="subtitle">{SUBTITLE}</div></div>
    </a>
  </div>
  <div class="sidebar-nav">
    <div class="nav-section-title">Índice</div>
    <a class="nav-link{ACTIVE}" href="{HOME}"><span class="dot" style="background:var(--text-muted)"></span><span>Temario general</span></a>
    <div class="nav-section-title">{BLOQUE}</div>
    <a class="nav-link{ACTIVE}" href="{PREFIX}{SLUG}/"><span class="dot dot-{UNIT}"></span><span class="num">{NUM}</span> {LABEL}</a>
    <!-- … una línea por página, agrupadas por bloque … -->
  </div>
</nav>
```

| Token | En `<curso>/index.html` | En `<curso>/<página>/index.html` |
|-------|-------------------------|----------------------------------|
| `{HOME}` | `./` | `../` |
| `{PREFIX}` | *(vacío)* | `../` |
| `{ACTIVE}` | ` active` en el link "Temario general" | ` active` en el link de esa página |

Nada más cambia entre el index y las páginas: una sola plantilla sirve para los dos.

### Bloque prev/next

```html
  <div class="page-nav">
    <a href="../"><div class="nav-dir">← Volver</div><div class="nav-title">Temario general</div></a>
    <a href="../aux_1/" class="next"><div class="nav-dir">Siguiente →</div><div class="nav-title">Gases Ideales</div></a>
  </div>
```

- Primera página de la cadena: el link izquierdo es `← Volver` → `../` (Temario general).
- Última: el link derecho es `Volver →` → `../`.
- Intermedias: `← Anterior` → página previa, `Siguiente →` → página siguiente.
- El link derecho siempre lleva `class="next"`.
- El texto es el **título prev/next** de la otra página (§2), no su `<h1>`.

---

## 4. Verificación

```bash
# 1) Idempotencia y sincronía
./scripts/sync-nav.py && ./scripts/sync-nav.py --check   # debe salir 0 y no reportar nada

# 2) Una sola variante de sidebar por curso
python3 - <<'EOF'
import re, glob, hashlib, collections
sb   = lambda p: re.search(r'<nav class="sidebar">.*?</nav>', open(p, encoding='utf-8').read(), re.S)
norm = lambda s: re.sub(r'\s+', ' ', re.sub(r'href="(\.\./|\./)', 'href="', s.replace(' active', ''))).strip()
for course in ['electro', 'termo', 'termoquimica']:
    files = glob.glob(f'{course}/index.html') + sorted(glob.glob(f'{course}/*/index.html'))
    v = collections.defaultdict(list)
    for f in files:
        m = sb(f)
        v[hashlib.md5(norm(m.group(0)).encode()).hexdigest()[:8] if m else 'SIN-SIDEBAR'].append(f)
    print(course, len(files), 'archivos,', len(v), 'variante(s)')
EOF

# 3) Ningún link roto en el repo
python3 - <<'EOF'
import os, re
roto = []
for dp, _, fs in os.walk('.'):
    if '/.git' in dp: continue
    for f in fs:
        if not f.endswith('.html'): continue
        p = os.path.join(dp, f)
        for href in re.findall(r'(?:href|src)="([^"#]+)"', open(p, encoding='utf-8').read()):
            if href.startswith(('http', 'data:', 'mailto:')): continue
            t = os.path.normpath(os.path.join(dp, href))
            if os.path.isdir(t): t = os.path.join(t, 'index.html')
            if not os.path.exists(t): roto.append((p, href))
print(roto or 'ningún link roto')
EOF

# 4) Exactamente una página activa por archivo
grep -c 'nav-link active' {electro,termo,termoquimica}/index.html */*/index.html | grep -v ':1$' \
  || echo "todas con exactamente 1 activa"
```

Y una revisión visual de una página por curso, que es lo único que detecta un desastre de layout:

```bash
mkdir -p /tmp/ffprof
MOZ_HEADLESS=1 firefox --profile /tmp/ffprof --no-remote \
  --screenshot /tmp/check.png --window-size=1400,2000 \
  "file://$PWD/electro/aux_1/index.html"
```

---

## 5. Trampas conocidas

- **Codificación**: los archivos son UTF-8 con acentos, `–` (en dash) y emoji. Abrir siempre con
  `encoding='utf-8'` explícito, en lectura y en escritura.
- **No usar un parser HTML** que reserialice el documento (BeautifulSoup, lxml): reordena atributos y
  reescribe entidades, produciendo un diff gigante en las 79 páginas. Sustitución textual del bloque
  delimitado, y nada más.
- **El reemplazo va como función**, no como string: `pattern.sub(lambda _m: nuevo, texto)`. Si se pasa
  el bloque generado como string, `re` interpreta `\1` y `\g<...>` dentro de él.
- **`</nav>` es único** en estos archivos, pero `</div>` no: por eso el `page-nav` se ancla en
  `</main>` (§3).
- **`termo/problemas/`** contiene `.typ` y `.pdf` sueltos y **no está trackeado en git**. No es una
  página del curso: no tiene `index.html`. El script ignora en silencio cualquier subcarpeta sin
  `index.html`, pero avisa si encuentra una **con** `index.html` que no esté en el manifiesto.
- **`basicos/`** es una página única sin sidebar, y no está en el manifiesto.
- El emoji del logo difiere por curso (⚡ electro, ⚛️ termo, 🧪 termoquimica) y el ⚛️ lleva un
  selector de variación (U+FE0F). Sale del manifiesto; no retipearlo.

---

## 6. Qué arregló la primera corrida

El script se escribió cuando la sidebar ya se había desincronizado. Estado previo:

| Curso | Variantes de sidebar conviviendo |
|-------|----------------------------------|
| `electro/` | **3** — `aux_1…aux_16` decían "Auxiliares 1 – 18" y **no linkeaban a los auxiliares 19–25**; `aux_17…aux_25` y el index estaban al día |
| `termo/` | 2 — sólo diferencias cosméticas entre el index y las páginas |
| `termoquimica/` | 2 — idem |

Es decir, **el 64 % de las páginas de electro no podía navegar a los auxiliares 19–25**. Además
`electro/aux_16` tenía el link "siguiente" apuntando al temario en vez de a `aux_17`, cortando la
cadena prev/next a la mitad del curso. Las dos cosas se arreglaron solas al correr el script.

Los cambios cosméticos que absorbió la misma corrida, todos invisibles en pantalla:

1. `termo/index.html` y `electro/index.html` tenían el logo y el link de temario expandidos en varias
   líneas; las páginas los tenían en una sola. Se usa siempre la forma de una línea.
2. En los index el texto del temario iba envuelto en `<span>`; en las páginas de `termo/` y `electro/`
   iba suelto. Se usa siempre el `<span>`, que es lo que ya hacía `termoquimica/`.
3. Los index llevaban `<div class="nav-section-title" style="margin-top:12px">` en la primera sección.
   Ese `margin-top` ya lo aplica la regla `.nav-section-title` de `main.css`: el `style` inline era
   redundante y se eliminó.
4. El texto del link derecho en la última página de cada curso era distinto en los tres
   (`Volver →`, `↑ Volver`, `Siguiente →`). Quedó `Volver →` en los tres.

El mejor test de que el generador es fiel fue `termoquimica/`, que estaba consistente: de sus 13
archivos, 12 salieron byte a byte idénticos y el único cambio fue el punto 4.
