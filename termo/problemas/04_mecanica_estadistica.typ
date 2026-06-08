#set page(paper: "a4", margin: (x: 2.5cm, y: 2.5cm))
#set text(size: 11pt, lang: "es")
#set par(justify: true, leading: 0.7em, spacing: 0.8em)
#set heading(numbering: none)

#show heading.where(level: 1): it => block(above: 1.4em, below: 0.4em)[
  #text(size: 13pt, weight: "bold")[#it.body]
  #line(length: 100%, stroke: 0.6pt)
]
#show heading.where(level: 2): it => block(above: 1.2em, below: 0.3em)[
  #text(size: 11pt, weight: "bold", fill: luma(80))[#it.body]
]

// ─── Encabezado ───────────────────────────────────────────────────────────────
#align(center)[
  #text(size: 16pt, weight: "bold")[Mecánica Estadística: Microestados y Entropía]
  #v(4pt)
  #text(size: 10pt)[Termodinámica FI2004 — FCFM, Universidad de Chile]
  #v(2pt)
  #text(size: 9pt, fill: luma(100))[Cátedra 11 · $S = k_B ln Omega$, conteo de microestados, temperatura estadística]
]
#v(0.5em)
#line(length: 100%, stroke: 1pt)
#v(0.3em)

= Problemas de Exámenes y Controles

== Problema 1 — Modelo de ADN
#text(size: 9pt, style: "italic")[(FI22A-2006-02, Control I; FI2004-2015, Control II · dif. 3.5)]

Un modelo simple de ADN (propuesto por Ch. Kittelen, 1969) consiste en dos
cuerdas unidas por $N$ enlaces uniformemente distribuidos. La energía necesaria
para romper un enlace es $E_0$.

*(a)* Si la energía debida a los enlaces rotos es $E = n E_0$ (donde $n < N$ es
el número de enlaces rotos), encuentre la entropía del sistema.
#text(size: 9pt, fill: luma(80))[_Ind.: use la aproximación de Stirling $ln(p!) approx p ln p - p$._]

*(b)* Si el sistema está en contacto con un baño térmico a temperatura $T$,
encuentre el número de equilibrio de enlaces rotos $n(T)$.

*(c)* ¿Qué ocurre con $n$ cuando $T arrow.r 0$ y cuando $T arrow.r infinity$?
Interprete físicamente.

== Problema 2 — Plasma: Extracción de Electrones
#text(size: 9pt, style: "italic")[(FI22A-2007-02, Control I; FI2004-2015, Ej. 7 · dif. 4.5)]

Un plasma aislado está formado por $N$ electrones. Extraer un electrón del
plasma tiene un costo de energía $epsilon$.

*(a)* Si se extraen $m$ electrones ($m <= N$), encuentre la entropía del sistema
asociada a este proceso de extracción.

*(b)* Grafique la entropía como función de $m$ e interprete cómo cambia.

*(c)* Encuentre la temperatura $T$ del sistema como función de $m$ e interprete
los valores que toma $T$. En particular: ¿puede $T$ ser negativa?

#text(size: 9pt, fill: luma(80))[_Recomendación: use la aproximación de Stirling $ln(n!) approx n ln n - n$, $n >> 1$._]

== Problema 3 — Polímero con Defectos
#text(size: 9pt, style: "italic")[(FI2004-2009-02, Ej. 5 · dif. 3.5)]

Considere una molécula de un polímero lineal al cual se pueden adherir átomos
de un material en un extremo (con energía $mu$) o en el centro (con energía $epsilon$).
Si hay un gas con $N$ moléculas poliméricas, con $n$ átomos adheridos en extremos
y $m$ átomos adheridos en centros, la energía asociada a los defectos es
$E = n mu + m epsilon$.

Encuentre la entropía de este gas de polímeros como función de $N$, $E$, $mu$ y $epsilon$.

== Problema 4 — Sistema de Tres Niveles
#text(size: 9pt, style: "italic")[(FI2004-2015, Ej. 5 · dif. 4.0)]

Un sistema está caracterizado por átomos con tres estados de energía posibles:
$+mu B$, $0$ y $-mu B$ (por ejemplo, un spin-1 en campo magnético $B$).

*(a)* Para un sistema de $N$ átomos, ¿cuál es el número de configuraciones con
energía $E = (2n - N - m) mu B$, donde $n$ es el número de átomos en el estado
$+mu B$ y $m$ el número en el estado $0$? Exprese el resultado en términos de $N$, $n$
y $m$.

*(b)* Encuentre la entropía del sistema usando $S = k_B ln Omega$ y la aproximación
de Stirling.

*(c)* Calcule la temperatura como $1/T = diff S / diff E$ y discuta los límites
$T arrow.r 0$ y $T arrow.r infinity$.

#v(1.5em)
#line(length: 100%, stroke: 1pt)
#v(0.3em)

= Problemas de Práctica

== Práctica 1 — Espines en Campo Magnético (Sistema de Dos Estados)

Considere un sólido paramagnético de $N$ átomos con spin 1/2, cada uno con
dos estados posibles: $+mu_B B$ (paralelo al campo, energía $-mu_B B$) y
$-mu_B B$ (antiparalelo, energía $+mu_B B$), donde $mu_B$ es el magnetón de Bohr.

*(a)* Si la energía total es $E = (N_- - N_+) mu_B B$ donde $N_+$ y $N_-$ son
el número de espines paralelos y antiparalelos, encuentre $Omega(N, E)$ y $S(N, E)$.

*(b)* Encuentre la temperatura como $1/T = diff S / diff E$ y despeje la energía
$E(T)$. Calcule la magnetización $M = mu_B (N_+ - N_-)$ en función de $T$ y $B$.

*(c)* Muestre que para $k_B T >> mu_B B$ (altas temperaturas) se obtiene la ley
de Curie: $M = C B / T$ con $C = N mu_B^2 / k_B$.

*(d)* ¿Existe temperatura negativa en este sistema? Si es así, interprete qué
significa físicamente y cuándo ocurre.

== Práctica 2 — Vacantes en un Cristal

Un cristal con $N$ átomos puede tener hasta $N$ vacantes (huecos) en su red
cristalina. Crear una vacante requiere una energía $epsilon_v$.

*(a)* Si hay $n$ vacantes, cuente el número de microestados $Omega(N, n)$
y calcule la entropía $S(n)$.

*(b)* En equilibrio a temperatura $T$, minimice la energía libre de Helmholtz
$F = E - T S = n epsilon_v - T S(n)$ respecto a $n$ para encontrar la concentración
de vacantes de equilibrio $n^*(T)$. Muestre que:
$ frac(n^*, N - n^*) = e^(-epsilon_v slash (k T)) $

*(c)* Para $n^* << N$, simplifique: $n^* approx N e^(-epsilon_v slash (k T))$.
Si $epsilon_v = 1 "eV"$ y $T = 1000 "K"$, estime la fracción de vacantes.

== Práctica 3 — Cadena de Polímero: Elasticidad Entrópica

Una cadena de polímero en 1D consiste en $N$ eslabones, cada uno de largo $a$,
que pueden apuntar hacia la derecha ($+a$) o hacia la izquierda ($-a$). Si $n_+$
eslabones apuntan a la derecha y $n_- = N - n_+$ a la izquierda, la longitud
total de la cadena es $L = (n_+ - n_-)a$.

*(a)* Cuente $Omega(N, n_+)$ y calcule la entropía $S(N, L)$.

*(b)* La fuerza entrópica que se opone a la elongación es $f = T (diff S / diff L)_N$.
Calcule $f(L)$ en el límite de pequeñas elongaciones ($|L| << N a$) y muestre que
se comporta como un resorte: $f = -kappa L$ con constante $kappa = k_B T / (N a^2)$.

*(c)* Interprete físicamente por qué la rigidez aumenta con la temperatura (a diferencia
de los resortes metálicos convencionales).
