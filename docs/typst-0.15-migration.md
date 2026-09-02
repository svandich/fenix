# Migración de las fórmulas a Typst 0.15

**Estado: hecha.** Los 333 SVG del repo están compilados con `typst 0.15.1 (9dfd3a08)`.

La recompilación de los 244 archivos quedó en el commit `925e6da`, sola y sin nada más. La limpieza de
la §5 está aplicada.

Este documento queda como registro de qué se hizo y como receta para la próxima vez que haya que subir
de versión, porque el problema se va a repetir igual.

---

## 1. Qué había

De los 333 SVG del repo, 244 venían de Typst 0.14 y 89 de 0.15:

| Curso | SVGs | Compilados con |
|-------|------|----------------|
| `termo/` | 144 | **0.14** |
| `electro/` | 93 | **0.14** |
| `basicos/` | 7 | **0.14** |
| `termoquimica/` | 89 | 0.15 |
| **Migrados** | **244** | |

Correr `./build.sh` sin argumentos recompilaba todo y reescribía esos 244 archivos, así que `CLAUDE.md`
advertía de usar siempre `./build.sh <curso>`. Esa advertencia era una curita; la migración la sacó de
encima.

---

## 2. Qué cambia realmente: nada visible

**Verificado sobre los 244 archivos, uno por uno**, por dos caminos independientes:

```
SVGs idénticos tras normalizar los ids de glifo:      244
SVGs con diferencia real:                               0
Diferencias en paths / transforms / viewBox:            0
```

Lo único que cambió es el **hash de los ids internos de glifo**. Ejemplo real,
`electro/aux_1/aux_1_1.svg`:

| | Typst 0.14 | Typst 0.15.1 |
|---|---|---|
| `viewBox` | `0 0 159.6296 39.6734` | igual ✅ |
| `width` / `height` | `159.6296pt` / `39.6734pt` | igual ✅ |
| Contornos `<path d="…">` | 19 | 19, **los 19 idénticos** ✅ |
| Transformaciones de posición | `6.5 21.359`, `17.589 21.359`, … | idénticas ✅ |
| Ids de glifo (`g219318…`) | 19 | 19, **0 en común** ⬅️ lo único que cambió |
| Tamaño | 16 876 bytes | 16 878 bytes |

Los ids son referencias internas (`<use xlink:href="#gXXXX">` apuntando a un `<path id="gXXXX">`) y
cada SVG se carga con `<img>`, o sea como documento aislado. No hay riesgo de colisión entre archivos
ni con el HTML que los contiene. Renombrarlos es inocuo.

**No hubo avisos de deprecación.** Compilando los 77 archivos `.typ` del repo con 0.15.1, la salida de
errores es de 0 bytes. Ninguna fuente usa sintaxis obsoleta, así que **no hubo que editar ningún
`.typ`**: la migración fue puramente recompilar.

### El resultado que importa

Ya migrado, `./build.sh` es **idempotente**: correrlo dos veces seguidas sin tocar ningún
`.typ` deja los 333 SVG byte a byte iguales y no genera diff. Comprobado durante el ensayo — el segundo
build no modificó un solo archivo. Eso es lo que se ganó — antes, correrlo sin argumento producía un
diff de 244 archivos sin cambio visual, y había que descubrir por cuenta propia que se descartaba.

Un diff de 244 archivos "que no significan nada" es exactamente donde se esconde el que sí significaba
algo.

---

## 3. Procedimiento

```bash
cd /home/nelson/Documents/termo/fenix

# 0) Punto de partida limpio: la migración no debe mezclarse con nada
git status --short          # idealmente vacío
typst --version             # anotar la versión exacta

# 1) Recompilar todo
./build.sh

# 2) Confirmar el tamaño del cambio
git diff --stat -- '*.svg' | tail -1

# 3) Verificar que el cambio es sólo de ids (§4). NO SALTARSE ESTE PASO.
python3 scripts/verify-typst-migration.py

# 4) Confirmar idempotencia: un segundo build no debe cambiar nada
./build.sh && git diff --name-only -- '*.svg' | wc -l   # mismo número que en (2)

# 5) Commitear SÓLO los SVGs, sin nada más
git add -u -- '*.svg'
git commit -m "chore: recompilar todos los SVG con Typst 0.15.1

Sin cambio visual: los 244 archivos son idénticos salvo los hashes
de los ids internos de glifo. Verificado archivo por archivo.
Deja ./build.sh sin argumentos seguro de usar de nuevo."
```

Cada SVG es una sola línea, así que git reporta cada archivo como 1 línea cambiada. Eso es esperable y
no indica que el contenido haya cambiado de verdad.

> Dos detalles del `git add`, los dos aprendidos a la mala:
>
> - **`-u` no es opcional.** `git add -- '*.svg'` también agrega los SVG *sin trackear* que calcen con
>   el patrón. Si hay un curso nuevo a medio integrar (fue el caso de `termoquimica/`), sus SVG entran
>   al commit sin su HTML. `-u` limita el `add` a archivos ya trackeados.
> - **Nunca `git add -A`.** Si el working tree tiene otro trabajo en curso, lo arrastra al commit de la
>   migración y lo entierra bajo 244 archivos de ruido.

---

## 4. Script de verificación

`scripts/verify-typst-migration.py` compara cada SVG del working tree contra su versión en git,
normalizando los ids de glifo por orden de aparición: si el único cambio son los hashes, ambos quedan
idénticos. Sale con código 1 si algún archivo cambió de verdad.

```bash
python3 scripts/verify-typst-migration.py
```

Si aparece algún archivo con diferencia real, **no commitear a ciegas**: renderizar esa fórmula antes y
después y mirarla.

```bash
git show HEAD:electro/aux_5/aux_5_1.svg > /tmp/antes.svg
typst compile typst/electro/aux_5.typ /tmp/despues_{p}.png --ppi 150
```

Como chequeo independiente del script (no depende de la lógica de normalización de ids), comparar
directamente la geometría — `d="…"`, `transform="…"` y `viewBox` — entre HEAD y el working tree. En
esta migración dio 0 diferencias en los 244 archivos.

---

## 5. Limpieza (ya aplicada)

### 5.1 Se quitó el filtro vestigial de `compile-typst.sh`

Había dos ocurrencias de:

```bash
typst compile "$f" "$course/$base/${base}_{p}.svg" 2>&1 \
  | grep -v 'is deprecated' || true
```

Ese `grep` se agregó para silenciar avisos de una versión anterior. Con 0.15 ningún `.typ` del repo
emite avisos, así que sólo servía para **esconder errores reales de compilación** — y el `|| true`
además le devolvía éxito al shell. Quedó:

```bash
typst compile "$f" "$course/$base/${base}_{p}.svg"
```

Con `set -e` arriba del script, un error de Typst ahora corta el build. Verificado con un `.typ`
deliberadamente roto: antes pasaba desapercibido, ahora el build sale con código 1 y muestra el error.

### 5.2 Se retiró la advertencia de `CLAUDE.md`

El bloque `> ⚠️ ./build.sh sin argumentos recompila todos los cursos…` dejó de aplicar. En su lugar
quedó anotado que `./build.sh` es idempotente.

### 5.3 Se fijó la versión

`CLAUDE.md` decía "Typst 0.15" a secas; ahora dice `0.15.1` y apunta acá, advirtiendo que subir de
versión implica repetir esta migración completa.

---

## 6. Trampas conocidas

- **Los SVG no llevan marca de versión.** No hay comentario ni atributo que diga con qué Typst se
  generó un archivo. La única forma de saberlo es recompilar y comparar. Por eso conviene que la
  migración sea un commit único y bien identificado: ese commit *es* el registro.
- **Migración parcial = peor que no migrar.** Si se recompila sólo un curso, quedan versiones
  conviviendo y el problema se vuelve más difícil de razonar. Hacerlo entero o no hacerlo.
- **No mezclar con cambios de contenido.** Si en el mismo commit se edita una fórmula, queda enterrada
  entre 244 archivos de ruido y nadie la va a revisar.
- **Este repo no tiene identidad de git configurada.** No hay `user.name` ni `user.email`, ni local ni
  global, así que `git commit` falla con *"Author identity unknown"*. Todos los commits existentes son
  de `svandich <137367720+svandich@users.noreply.github.com>`; para no dejar configuración persistente,
  el commit de la migración se hizo con `git -c user.name=... -c user.email=... commit`.
- **Coordinar la versión entre máquinas.** Si el repo se comparte con alguien que tiene otra versión de
  Typst instalada, su próximo `./build.sh` revierte todos los archivos. La versión exacta está anotada
  en `CLAUDE.md`.
- **`termo/problemas/`** tiene 6 `.typ` y 7 `.pdf` sueltos, y **sí está trackeado en git** (los 13
  archivos). `build.sh` no lo toca: `compile-typst.sh` sólo recorre `typst/<curso>/<prefijo>*.typ`, y
  estos `.typ` viven fuera de `typst/`. O sea que esos PDFs son salida de compilación commiteada que
  ningún script regenera — si se edita un `.typ` de ahí hay que correr `typst compile` a mano. Esta
  migración no los afecta.
- **Fuentes**: ningún `.typ` del repo fija una familia tipográfica (`grep -rn 'font:' typst/` no
  devuelve nada), así que todos usan la fuente que Typst trae embebida y el resultado es reproducible
  entre máquinas con la misma versión. Si alguna vez se agrega `#set text(font: "…")` apuntando a una
  fuente del sistema, la salida pasa a depender de la máquina y esta garantía se cae.
- **El header de los `.typ` no cambió** entre versiones:
  ```typst
  #set page(width: auto, height: auto, margin: (x: 0.5em, y: 0.3em), fill: none)
  #set text(fill: rgb("#e6edf3"), size: 13pt)
  ```
  `fill: none` es lo que deja el SVG transparente sobre el fondo oscuro, y `fill: rgb("#e6edf3")` fija
  el color del texto. Si en alguna versión futura cambiara el comportamiento de `fill: none`, se
  notaría como un rectángulo blanco detrás de cada fórmula — es lo primero que hay que mirar al subir
  de versión.

---

## 7. Verificación visual final

El script de la §4 compara bytes. Para cerrar, una mirada a una fórmula compleja de cada curso —
matrices, `underbrace`, derivadas parciales, integrales — que es donde un cambio de motor se notaría:

```bash
mkdir -p /tmp/ffprof
for p in electro/aux_17/index.html termo/cat_15/index.html \
         termoquimica/clase_6/index.html basicos/index.html; do
  MOZ_HEADLESS=1 firefox --profile /tmp/ffprof --no-remote \
    --screenshot "/tmp/$(echo $p | tr / _).png" --window-size=1400,2400 "file://$PWD/$p"
done
```

Hecho con Firefox 154. Las cuatro páginas renderizan bien: fórmulas nítidas, centradas, sin recuadro de
fondo y sin recortes. Se revisaron específicamente los casos difíciles — el `underbrace` doble de
`clase_6`, el determinante simbólico del rotor en `basicos`, las derivadas parciales con subíndice de
`cat_15` y las integrales de superficie y contorno (`∮`, `∯`).
