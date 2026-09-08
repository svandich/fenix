# Migrar el math inline de LaTeX a MathML, vía Typst

**Estado: hecha.** Las 5784 expresiones inline de las 80 páginas ya no son `$...$` interpretado por
MathJax en el navegador: son `<math>` horneado en el HTML. No queda ninguna dependencia de red.

Este documento era, hasta ahora, el argumento de por qué *no* hacerla por este camino. El análisis de
riesgo sigue vigente y sigue abajo, porque es lo que dictó cómo se construyó el traductor: cada modo
de falla silenciosa que estaba identificado tiene ahora una decisión de diseño que lo hace imposible,
o un chequeo que lo habría detectado. Dos de esos chequeos encontraron errores reales (§7).

---

## 1. Qué se hizo

| | |
|---|---|
| Expresiones inline convertidas | **5784** instancias, **2261** distintas |
| Páginas tocadas | **80** (79 tenían MathJax; `electro/index.html` no tiene math) |
| Macros LaTeX soportados | **84**, exactamente los que usa el repo |
| MathJax | eliminado del `<head>` de las 79 páginas y de `styles/quiz.js` |
| Peso del HTML | 1310 KB → 1875 KB (+564 KB, repartido en 80 archivos) |
| Peso que deja de bajarse | 1134 KB de MathJax por CDN, más sus fuentes |
| `styles/main.css` | 18,9 KB → 21,3 KB (normalización de MathML + fuente math) |

El pipeline quedó en dos scripts:

```
scripts/latex2typst.py     traduce el subconjunto de LaTeX del repo a math de Typst
scripts/inline-mathml.py   extrae, traduce, compila con Typst y hornea el MathML en las páginas
```

`./build.sh` corre los dos pasos (Typst → SVG para las fórmulas de display, y el horneado del
inline). Es idempotente: correrlo sin tocar nada no genera diff.

### El LaTeX no se perdió

Cada `<math>` guarda su fuente en `data-tex`:

```html
<math data-tex="\left(\frac{\partial S}{\partial V}\right)_T"><msub><mrow><mo>(</mo>…</math>
```

De ahí salen tres cosas: el script es **idempotente** (en la corrida siguiente lee de `data-tex` y
regenera), la migración es **reversible**, y escribir una página nueva sigue siendo escribir `$...$`
en el HTML — el horneado lo hace `./build.sh`. `./scripts/inline-mathml.py --check` sale con código 1
si quedó algo sin hornear (sirve para pre-commit, igual que `sync-nav.py --check`).

---

## 2. Por qué se planteó

`MathJax` era la única dependencia de red que quedaba. El repo se auto-hospeda todo lo demás — Inter
y JetBrains Mono viven en `styles/fonts/` (548 KB) justamente para no depender de nadie — pero
`CLAUDE.md`, en *Abrir localmente*, tenía que admitir que "MathJax necesita conexión a internet para
cargar desde CDN". Abrir un `index.html` sin red dejaba todas las fórmulas inline en crudo.

Además había **tres configuraciones distintas** de MathJax repartidas por las páginas, lo que no
rompía nada pero indicaba que ese `<head>` nunca se normalizó. Ahora no hay ninguna.

---

## 3. Las alternativas, con números

| Opción | Peso | Sin red | Sin JS | Texto real | Traducción |
|---|---|---|---|---|---|
| MathJax por CDN (antes) | 1134 KB + fuentes | ✗ | ✗ | ✓ | — |
| KaTeX auto-hospedado | 549 KB | ✓ | ✗ | ✓ | ninguna |
| LaTeX → MathML en build (Temml/KaTeX) | ~0 KB | ✓ | ✓ | ✓ | ninguna |
| **Typst → MathML (elegida)** | **~0 KB** | ✓ | ✓ | ✓ | **2261 expresiones** |
| Typst → SVG inline | 8,4 MB | ✓ | ✓ | ✗ | 2261 expresiones |

**Typst → SVG estaba descartado de entrada.** Cada SVG incrusta sus propios contornos de glifo (3,8 KB
promedio medido), el color va fijo en el archivo (`fill="#e6edf3"`, así que el math dentro de
`.formula-desc` saldría del color equivocado), no escala con el `font-size` del contexto, y la línea
base no se puede recuperar de un solo `transform`. Además rompe seleccionar, copiar y Ctrl+F.

**Typst → MathML es lo que se usó.** El MathML que emite es de verdad: texto seleccionable, buscable,
que hereda `color` y `font-size` del CSS. Soporte de navegador suficiente (Firefox siempre,
Chrome 109+, Safari 14.1+).

**LaTeX → MathML directo (Temml, o `output: "mathml"` de KaTeX) llegaba al mismo destino sin traducir
nada**, y sigue siendo la opción con menos superficie de error. Se descartó porque en esta máquina no
hay `npm` — sólo `node` — así que instalar Temml no era posible sin agregar una dependencia de red
nueva, que es exactamente lo que la migración venía a sacar. Typst ya estaba instalado y ya era parte
del build. El precio de esa decisión es el paso de traducción, y la §5 es cómo se pagó.

Typst sigue avisando en cada corrida:

```
warning: html export is under active development and incomplete
 = hint: do not rely on this feature for production use cases
```

Es una advertencia real. La mitigación es que el MathML está **horneado**: si una versión futura de
Typst cambia lo que emite, las páginas publicadas no se mueven. Se regeneran cuando alguien corre
`./build.sh`, y ahí el arnés de §5 se puede volver a correr para ver qué cambió.

---

## 4. Los riesgos, y qué se hizo con cada uno

Lo que decide el riesgo no es cuántos errores puede haber, sino **si el error grita o se calla**.

### 4.1 Riesgos que gritan (aceptables)

**Letras adyacentes.** En LaTeX `$PV$` es P·V. En Typst `PV` es un identificador de dos letras y hay
que escribir `P V`. Afectaba a **942 instancias / 615 expresiones distintas** (`BT` 209, `Nk` 133,
`dV` 86, `PV` 76, `RT` 69, `nRT` 38…). Typst **falla con error** en vez de renderizar mal:

```
error: unknown variable: PV
  = hint: if you meant to display multiple letters as is, try adding spaces
          between each letter: `P V`
```

El traductor separa siempre las letras, así que el caso no se da. Y se había verificado que ninguna
de esas 615 secuencias colisiona con un operador predefinido de Typst (`Pr`, `det`, `ker`, `deg`,
`hom`, `arg`, `max`, `mod`…), que sí se renderizaría en silencio: **0 casos** en este corpus.

### 4.2 Riesgos que se callan

Estos renderizan algo, no levantan error, y sólo se detectan comparando. Uno por uno:

| Riesgo | Instancias | Cómo quedó neutralizado |
|---|---|---|
| `\varepsilon` vs `\epsilon` → **se invierten** respecto de LaTeX | 153 | Los símbolos se emiten como **codepoint Unicode literal**, no como nombre Typst |
| Sub/superíndices de varios caracteres | 519 | El argumento se envuelve siempre en `(...)`; el arnés compara la estructura |
| `\text` / `\mathrm` → comillas o `upright()` | 380 | `\text` → string, `\mathrm` → math recto; el arnés compara el `<mtext>` resultante |
| Acentos (`\bar`, `\hat`, `\dot`) | 283 | Tabla explícita; el arnés compara el glifo del acento |
| `\vec` → `arrow()` | 272 | Ídem |
| Paréntesis alrededor de una fracción → trampa `lr(()/())` | 16 | Se emite `frac(a, b)`, no `(a)/(b)`: la trampa deja de existir |

**El caso de `epsilon` merece el subrayado que ya tenía**: en LaTeX `\epsilon` es la lunada (ϵ) y
`\varepsilon` la abierta (ε); en Typst `epsilon` es la abierta y `epsilon.alt` la lunada. La
correspondencia está dada vuelta, y un traductor que mapee `\epsilon → epsilon` produce el glifo
equivocado en 153 lugares sin avisar. Por eso `scripts/latex2typst.py` no escribe nombres de símbolo:
escribe el carácter. `\epsilon` → `ϵ` (U+03F5), `\varepsilon` → `ε` (U+03B5), y Typst se limita a
llevarlos al plano matemático correcto. Lo mismo con `\phi`/`\varphi`. El arnés lo confirma
expresión por expresión (§5).

**Un riesgo que no estaba en la lista**: en LaTeX `a/b` es una barra; en Typst `a/b` es una
**fracción**. Son 679 barras en el corpus. El traductor las escapa a `\/`. No estaba identificado
antes de escribir el traductor, y habría cambiado silenciosamente la forma de 679 expresiones.

---

## 5. Cómo se verificó

La traducción no se puede dar por buena leyéndola. El plan original era diff por imagen; lo que se
hizo es mejor y más barato: **comparar el MathML contra un oráculo independiente**.

Se bajó `mathjax-full@3.2.2` del registro de npm y se corrió bajo `node` (`MathJax.tex2mml`) para
producir, desde el **LaTeX original**, el MathML de referencia de las 2261 expresiones. Es el mismo
motor que renderizaba estas páginas hasta ahora, así que compararlo es comparar contra lo que el
lector veía.

Sobre eso, tres pasadas:

1. **Compilación.** Las 2261 expresiones traducidas compilan con `typst compile --format html` sin un
   solo error ni warning propio.
2. **Glifos.** Se compara el flujo de texto visible de ambos MathML, normalizando lo que no cambia el
   render (plano alfanumérico matemático, acentos combinantes vs. espaciadores, `⁡` invisible).
   **2257 de 2261 idénticas.** Las 4 que difieren son `\boldsymbol`, y difieren porque la referencia
   offline de MathJax no tenía cargada esa extensión y escupió el macro como texto: la salida buena
   es la nuestra.
3. **Estructura.** Se comparan los árboles MathML. Quedan 226 diferencias, todas en cinco clases
   revisadas una por una y ninguna visible:
   - subíndice colgado del grupo `(…)` entero en vez de sólo del `)` (Typst agrupa mejor);
   - MathJax junta letras rectas contiguas en un `<mi>` (`\mathrm{CO_2}` → `<mi>CO</mi>`), Typst las
     separa — mismo render;
   - `\mathcal{E}` → `ℰ` (U+2130) contra `<mi mathvariant="script">E</mi>`;
   - `0{,}082` como un `<mn>` contra tres tokens;
   - `\mathbf` (ver §6).

   Con el espaciado incluido en la comparación aparecen 14 diferencias más, todas de redondeo
   (`0.1667em` vs `0.167em`) o del `\ ` explícito. Ninguna es un hueco de más o de menos.

Y una revisión a ojo, que es donde se cierra: 39 expresiones representativas (todas las clases de
riesgo de §4.2) renderizadas al lado de su fuente LaTeX.

### 5.1 Reproducir el arnés

Los scripts de verificación no están en el repo — dependen de bajar MathJax de npm, que es
precisamente la dependencia que la migración elimina. El procedimiento, si hace falta repetirlo:

1. `curl -L https://registry.npmjs.org/mathjax-full/-/mathjax-full-3.2.2.tgz | tar xz`
2. Con `node`, `MathJax.tex2mml(tex)` sobre cada valor de `data-tex` → MathML de referencia.
3. Contra eso, el `<math>` que ya está en las páginas.
4. Normalizar antes de comparar: plano matemático → letra base **sin fundir** `ϵ`/`ε` ni `ϕ`/`φ`
   (NFKC los funde, y son justo los que hay que vigilar), acentos combinantes ≡ espaciadores,
   `⁡`/`⁢` fuera, `munder` ≡ `msub`.

---

## 6. Las dos cosas que cambian a propósito

**`\mathbf` ahora es negrita cursiva.** MathJax renderizaba `\mathbf{E}` como **E** recta; el
traductor emite `bold(E)`, que es negrita cursiva ***E***. Se eligió así porque es lo que ya hacen las
fórmulas de display del repo: `CLAUDE.md` mapea `\mathbf{E}` → `bold(E)` y los 348 SVG están
compilados con esa convención. Antes de la migración, un mismo vector se veía distinto en el párrafo
y en la fórmula de abajo. Ahora no. Son 174 instancias.

**Los alfanuméricos matemáticos bajan a letra base.** Typst emite `𝑃` (U+1D447, MATHEMATICAL ITALIC
CAPITAL P) donde MathJax emite `<mi>P</mi>` y deja que el navegador lo incline. `inline-mathml.py`
normaliza a la forma de MathJax, porque esos codepoints sólo existen en fuentes matemáticas y este
repo auto-hospeda Inter, que no los trae: sin la normalización, un sistema sin fuente matemática
instalada mostraría cajitas. Con la letra base, el math hereda la tipografía de la página, y además
`Ctrl+F` de "PV" encuentra `$PV$`. La negrita, que sí necesitaba el codepoint, va por CSS
(`math .mv-bi { font-weight: 700 }`).

`styles/main.css` fija además una pila de fuentes matemáticas para `math` (`Latin Modern Math`,
`STIX Two Math`, `Cambria Math`, `math`, `serif`). Si se quiere que el inline calce exactamente con
la New Computer Modern de los SVG de display, el paso siguiente sería auto-hospedar un `.woff2`
matemático (~500 KB); no se hizo porque duplicaría el peso de `styles/fonts/`.

---

## 7. Los dos errores que el arnés encontró

Valen como prueba de que el riesgo silencioso era real, porque los dos renderizaban algo, ninguno dio
error, y ninguno se veía leyendo el traductor.

**`\tfrac72R` salía como 7/2·R con el 72 arriba.** El traductor juntaba las cifras contiguas en un
número, así que `\frac32` se leía como `frac(32, …)`. En LaTeX un argumento sin llaves es **un solo
token**: `\frac32` es 3/2. Afectaba a 16 instancias, todas fracciones de capacidades caloríficas
(`\bar C_P = \tfrac72R`) y coeficientes estequiométricos (`\tfrac32\mathrm{O_2}`) — es decir, números
que un lector no tiene cómo saber que están mal.

**Las primas dejaban de ser primas.** `q'` se traducía a `q '`, y Typst sólo eleva la prima si está
pegada a su base: con el espacio quedaba una comilla a la altura de la línea. Peor, `Q_y'` no se
arregla pegándola al final (`Q_(y)'` hace que Typst dibuje los paréntesis del subíndice); hay que
insertarla antes de los índices, `Q'_(y)`. Por eso `_Atom` guarda la base y los índices por separado.

Y un tercero, de espaciado, que el arnés también marcó: Typst convierte un espacio de fuente
adyacente a un string en 0.2222em reales, cosa que LaTeX no hace. `0{,}082` salía como `0 , 082` y
`\mathrm{Fe}(s)` como `Fe (s)`.

### El precedente

Ya antes de esta migración el repo había caído en un error de esta familia, en el pipeline de
display, y estuvo publicado un buen tiempo sin que nadie lo notara:

```typst
lr((partial V)/(partial t))_P     ← lo que estuvo escrito
lr(( (partial V)/(partial t) ))_P ← lo correcto
```

La primera forma renderiza **sin los paréntesis**: Typst se los come como agrupación de la fracción.
Eran **52 ocurrencias en 12 archivos `.typ`**, y se reproducía sola, porque `CLAUDE.md` documentaba el
patrón roto como la receta recomendada. Ya está corregido, y `scripts/check-lr-parens.py` lo detecta
(no se puede con grep: la forma correcta contiene a la incorrecta como subcadena).

El math inline no puede volver a caer en eso: `latex2typst.py` emite `frac(a, b)`, que es una llamada
a función y no se come nada.

---

## 8. Lo que queda anotado

- `typst compile --format html` sigue marcado como incompleto. El MathML horneado aísla a las páginas
  de eso, pero conviene volver a correr el arnés de §5 cada vez que se suba la versión de Typst.
- Si alguna vez hay `npm` en la máquina, **Temml es mejor traductor que el nuestro**: consume el
  `data-tex` que ya está guardado en cada `<math>` y no traduce nada. La migración dejó el LaTeX
  justamente para que ese cambio sea barato.
- El único JS propio que queda es `styles/quiz.js`, y ya no tipografía nada: inyecta la explicación
  con `innerHTML` y el navegador renderiza el MathML solo.
