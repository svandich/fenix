# Migrar el math inline de LaTeX a Typst

**Estado: no hecha, y la recomendación es no hacerla así.** Este documento existe para que la decisión
quede tomada con números y no se vuelva a discutir de memoria.

La idea evaluada: sacar MathJax del `<head>` de las 80 páginas y renderizar también el math inline
(`$...$`) con Typst, aprovechando que el repo ya tiene el pipeline Typst → SVG andando para las
fórmulas de display.

La conclusión corta: **el destino es correcto, el camino no**. Typst puede emitir MathML y eso resuelve
el problema de verdad, pero llegar por Typst obliga a traducir 2261 expresiones de LaTeX a otra
sintaxis, y ese paso tiene un modo de falla que este repo ya sufrió sin darse cuenta (§5).

---

## 1. Por qué se plantea

`MathJax` es la única dependencia de red que queda. El repo se auto-hospeda todo lo demás — Inter y
JetBrains Mono viven en `styles/fonts/` (548 KB) justamente para no depender de nadie — pero
`CLAUDE.md`, en *Abrir localmente*, tiene que admitir que "MathJax necesita conexión a internet para
cargar desde CDN". Abrir un `index.html` sin red deja todas las fórmulas inline en crudo.

Además hoy hay **tres configuraciones distintas** de MathJax repartidas por las páginas, lo que no
rompe nada pero indica que ese `<head>` nunca se normalizó.

---

## 2. Alcance real

Medido sobre las 80 páginas (`electro/`, `termo/`, `termoquimica/`, `basicos/`):

| | |
|---|---|
| Expresiones inline `$...$` | **5784** instancias |
| Expresiones distintas (deduplicadas) | **2261** |
| Macros LaTeX distintos en uso | **84** |
| Páginas a tocar | **80** |

Los más usados: `\partial` (470), `\Delta` (457), `\vec` (394), `\text` (289), `\mu` (269),
`\bar` (249), `\mathrm` (198), `\ln` (175), `\mathbf` (174).

Esto no es convertible a mano ni a entidades HTML: hay que renderizarlo con algo.

---

## 3. Qué habría que hacer, paso a paso

1. **Extraer** las 5784 ocurrencias de los 80 HTML y deduplicarlas a 2261 expresiones.
2. **Traducir** cada una de LaTeX a sintaxis Typst. No hay traductor confiable: la tabla de
   equivalencias de `CLAUDE.md` cubre 15 casos de los 84 macros en uso, y varias equivalencias no son
   1:1 (§4).
3. **Compilar** cada expresión con `typst compile --format html` para obtener MathML.
4. **Empalmar** el MathML de vuelta en los 80 HTML, en el lugar exacto de cada `$...$`.
5. **Meter** el CSS de normalización de MathML (~1,5 KB, lo emite Typst) en `styles/main.css`.
6. **Reescribir** `styles/quiz.js:45-47`, que hoy llama `MathJax.typesetPromise()` para re-tipografiar
   la explicación del quiz después de inyectarla.
7. **Revisar a ojo** las 2261 expresiones, porque los errores de traducción no se detectan solos (§4).

Los pasos 1, 3, 4, 5 y 6 son mecánicos. El 2 y el 7 son el problema.

---

## 4. Riesgos

Lo que decide el riesgo no es cuántos errores puede haber, sino **si el error grita o se calla**.

### 4.1 Riesgos que gritan (aceptables)

**Letras adyacentes.** En LaTeX `$PV$` es P·V. En Typst `PV` es un identificador de dos letras y hay
que escribir `P V`. Afecta a **942 instancias / 615 expresiones distintas** (`BT` 209, `Nk` 133,
`dV` 86, `PV` 76, `RT` 69, `nRT` 38…).

La buena noticia: Typst **falla con error** en vez de renderizar mal.

```
error: unknown variable: PV
  = hint: if you meant to display multiple letters as is, try adding spaces
          between each letter: `P V`
```

Verifiqué además si alguna de esas 615 secuencias colisiona con un operador predefinido de Typst
(`Pr`, `det`, `ker`, `deg`, `hom`, `arg`, `max`, `mod`…), que sí se renderizaría en silencio —
`$Pr$` sale como la "Pr" recta de probabilidad y `$P r$` como P·r en cursiva. **En este corpus la
colisión no ocurre: 0 casos.** Es el mejor resultado posible para este riesgo.

### 4.2 Riesgos que se callan (el problema)

Estos renderizan algo, no levantan error, y sólo se detectan mirando la imagen:

| Riesgo | Instancias | Distintas |
|---|---|---|
| Sub/superíndices de varios caracteres (`P_{\text{op}}` → `P_"op"`) | 519 | 371 |
| `\text` / `\mathrm` → comillas o `upright()` | 380 | 246 |
| Acentos (`\bar`, `\hat`, `\dot`) → `macron` / `overline` / `hat` / `dot` | 283 | 154 |
| `\vec` → `arrow()` | 272 | 114 |
| `\varepsilon` vs `\epsilon` → **se invierten** respecto de LaTeX | 153 | 102 |
| Paréntesis alrededor de una fracción → trampa `lr(()/())` | 16 | 14 |

`\varepsilon` merece subrayado: en LaTeX `\epsilon` es la lunada (ϵ) y `\varepsilon` la abierta (ε);
en Typst `epsilon` es la abierta y `epsilon.alt` la lunada. La correspondencia está **dada vuelta**, y
un traductor mecánico que mapee `\epsilon → epsilon` produce el glifo equivocado en 153 lugares sin
avisar.

---

## 5. La prueba de que el riesgo silencioso es real

**Ya corregido**, pero vale como evidencia: este repo cayó en uno de estos errores, en el pipeline de
display, y estuvo publicado un buen tiempo sin que nadie lo notara.

```typst
lr((partial V)/(partial t))_P     ← lo que estuvo escrito hasta ahora
```

Renderiza **sin los paréntesis**. Typst se los come como agrupación de la fracción. La forma correcta
necesita un par interno:

```typst
lr(( (partial V)/(partial t) ))_P
```

- **52 ocurrencias, en 12 archivos `.typ`**: `clase_6` (14), `clase_5` (8), `aux_4` (7), `cc_7` (6),
  `cat_18` (4), `cat_15` (3), `clase_3` (3), `cat_14` (2), `aux_2` (2), `cat_17` (1), `cc_2` (1),
  `clase_1` (1).
- No es cosmético: en termodinámica, `∂U/∂V` con un `_T` colgando y sin paréntesis es ambiguo sobre a
  qué aplica el subíndice. Es exactamente la notación que el curso enseña a leer bien.
- Y se reproducía solo: **`CLAUDE.md` documentaba el patrón roto como la receta recomendada**, así que
  volvía a aparecer cada vez que alguien agregaba una derivada parcial. La receta ya está corregida.

Esto es un solo macro, escrito a mano, por gente que conocía el material, y aun así pasó y sobrevivió.
El paso 2 de §3 propone hacer esa misma clase de traducción **2261 veces**.

Detectarlo tampoco es trivial: **no se puede con grep**, porque la forma correcta
(`lr(( (A)/(B) ))`) contiene a la incorrecta (`lr((A)/(B))`) como subcadena. Hace falta emparejar
paréntesis. Por eso el chequeo quedó como `scripts/check-lr-parens.py`, que sale con código 1 si
encuentra alguno.

> Las 52 están corregidas y `CLAUDE.md` ya documenta la forma buena. Que hiciera falta un script
> dedicado para *detectar* un error de traducción de un solo macro es, en sí, el argumento de este
> documento.

---

## 6. Alternativas, con números

Las cuatro opciones y lo que cuesta cada una. Tamaños medidos, no estimados.

| Opción | Peso | Sin red | Sin JS | Texto real | Traducción |
|---|---|---|---|---|---|
| MathJax por CDN (hoy) | 1134 KB + fuentes | ✗ | ✗ | ✓ | — |
| KaTeX auto-hospedado | **549 KB** | ✓ | ✗ | ✓ | ninguna |
| LaTeX → MathML en build | **~0 KB** | ✓ | ✓ | ✓ | ninguna |
| Typst → MathML | ~0 KB | ✓ | ✓ | ✓ | **2261 expresiones** |
| Typst → SVG inline | **8,4 MB** | ✓ | ✓ | ✗ | 2261 expresiones |

**Typst → SVG queda descartado de entrada.** Cada SVG incrusta sus propios contornos de glifo (3,8 KB
promedio medido), el color va fijo en el archivo (`fill="#e6edf3"`, así que el math dentro de
`.formula-desc` saldría del color equivocado), no escala con el `font-size` del contexto, y la línea
base no se puede recuperar de un solo `transform`. Además rompe seleccionar, copiar y Ctrl+F.

**Typst → MathML sí funciona.** Verificado con el `typst 0.15.1` de esta máquina:

```html
Sea <math><mi>𝑇</mi></math> la temperatura y
<math><msub><mfrac><mrow><mi>𝜕</mi><mi>𝑈</mi></mrow>
<mrow><mi>𝜕</mi><mi>𝑉</mi></mrow></mfrac><mi>𝑇</mi></msub></math>
```

Es MathML de verdad: texto seleccionable, buscable, que hereda `color` y `font-size` del CSS. Soporte
de navegador suficiente (Firefox siempre, Chrome 109+, Safari 14.1+).

Pero Typst avisa en cada corrida:

```
warning: html export is under active development and incomplete
 = hint: do not rely on this feature for production use cases
```

**LaTeX → MathML en build llega al mismo destino sin el paso peligroso.** Herramientas como Temml
(hecha para esto) o el modo `output: "mathml"` de KaTeX consumen el LaTeX que ya está escrito y
escupen MathML. Se corre una vez en build, el MathML queda horneado en el HTML, y no se envía JS.
Mismo resultado final, **sin traducir nada**, sin depender de una feature marcada como incompleta.
`node v26.8.1` ya está instalado en esta máquina.

---

## 7. Recomendación

1. **Arreglar los 53 `lr()`** y corregir la receta de `CLAUDE.md` línea 88. Es un bug real, está
   publicado, y no depende de ninguna de estas decisiones.
2. **Si el objetivo es sacar el CDN:** LaTeX → MathML en build. Es el mismo destino que Typst, con
   cero traducción y cero riesgo silencioso.
3. **Si sólo se quiere algo rápido y reversible:** KaTeX auto-hospedado (549 KB). Los 84 macros en uso
   están todos soportados; lo verifiqué contra el inventario completo. No cierra la puerta a MathML
   después, porque ambos consumen el mismo LaTeX.
4. **Typst para inline:** dejarlo anotado para cuando `--format html` salga de "incomplete". No aporta
   nada sobre la opción 2 y carga con la traducción de 2261 expresiones.

---

## 8. Si igual se hace, cómo verificarlo

La traducción no se puede dar por buena leyéndola. Hace falta comparar renders:

1. Antes de tocar nada, renderizar las 2261 expresiones con el MathJax actual y guardarlas como PNG.
2. Renderizar las 2261 traducidas.
3. Diff por imagen, y **revisar a ojo todo lo que no calce pixel a pixel**.

Sin ese arnés no hay forma de saber si alguna de las 519 con subíndices multicarácter, las 153 con
`\varepsilon` o las 14 con paréntesis sobre fracción salió mal: todas renderizan *algo*.

Nota: la comprobación barata de que no hay `$` sueltos ya está hecha — **cero** en las 80 páginas (el
único candidato era una expresión de más de 200 caracteres, límite del script, no un delimitador
impar). Ese riesgo no existe.
