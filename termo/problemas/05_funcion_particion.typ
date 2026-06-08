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
  #text(size: 16pt, weight: "bold")[Función de Partición y Ensemble Canónico]
  #v(4pt)
  #text(size: 10pt)[Termodinámica FI2004 — FCFM, Universidad de Chile]
  #v(2pt)
  #text(size: 9pt, fill: luma(100))[Cátedras 13–14 · Distribución de Boltzmann, $F = -k_B T ln Z$, modelos moleculares]
]
#v(0.5em)
#line(length: 100%, stroke: 1pt)
#v(0.3em)

= Problemas de Exámenes y Controles

== Problema 1 — Gas Diatómico con Resorte
#text(size: 9pt, style: "italic")[(FI2004-2009-02, Control II · dif. 3.5)]

Considere un gas formado por $N$ moléculas diatómicas en un volumen $V$. Cada
molécula se modela como dos partículas puntuales conectadas por un resorte ideal
de largo natural $L_0$ y constante elástica $k$, que solo puede deformarse en su
dirección longitudinal.

*(a)* Encuentre la función de partición $Z(V, T, N)$ que caracteriza este sistema
a temperatura $T$.

*(b)* Encuentre la ecuación de estado del gas.

*(c)* Calcule la relación entre la energía interna $U$ y la temperatura $T$.
Analice su resultado e interprete usando el teorema de equipartición.

== Problema 2 — Molécula de CO₂: Capacidad Calórica
#text(size: 9pt, style: "italic")[(FI2004-2009-02, Ej. 10; FI22A-2007-02, Ej. 9 · dif. 3.5)]

Una molécula de CO₂ se modela como tres partículas de masas $M_O$, $M_C$, $M_O$
(dos átomos de oxígeno y uno de carbono), conectadas por dos resortes ideales de
constante $k$ y largo natural $l_0$. Los resortes solo pueden deformarse en la
dirección radial (a lo largo de la molécula).

Si el gas está en 3 dimensiones (o en 2 dimensiones), determine la capacidad
calórica a volumen constante $C_V$ de un gas de $N$ moléculas de CO₂ en contacto
con un termostato a temperatura $T$.

#text(size: 9pt, fill: luma(80))[_Ind.: identifique los grados de libertad traslacionales, rotacionales y vibracionales._]

== Problema 3 — Gas de Fotones Unidimensional
#text(size: 9pt, style: "italic")[(FI22A-2006-02, Control II · dif. 3.5)]

Considere un gas monoatómico _relativista_ de $3N$ partículas (fotones) con
relación de energía-momentum $epsilon = p c$, donde $c$ es la velocidad de la luz.
Para el caso unidimensional, muestre que su función de partición es:

$ Z(V, T, N) = frac(1, N!) lr([2L frac(k T, planck.reduce c)])^(3N) $

donde $L$ es la longitud del sistema y $h = 2 pi planck.reduce$ la constante de Planck.

Luego calcule:
*(a)* La energía libre de Helmholtz $F$.
*(b)* La presión y la ecuación de estado.
*(c)* La entropía $S$ del sistema.

== Problema 4 — Gas Relativista Tridimensional
#text(size: 9pt, style: "italic")[(FI2004-2015, Ej. 9 · dif. 5.0)]

Considere un gas formado por $N$ partículas idénticas relativistas en un volumen $V$,
con relación de dispersión $epsilon_i = m c v_i$, donde $c$ es la velocidad de la luz
y $v_i = sqrt(v_(x,i)^2 + v_(y,i)^2 + v_(z,i)^2)$ la rapidez de la $i$-ésima partícula.

Usando el formalismo de la función de partición, encuentre:
*(a)* La función de partición $Z(V, T, N)$.
*(b)* La ecuación de estado del gas.
*(c)* La entropía $S(T, V, N)$.

Compare la ecuación de estado con la del gas ideal clásico y con la del gas de fotones.

== Problema 5 — Pistón Fluctuante
#text(size: 9pt, style: "italic")[(FI22A-2007-02, Control I; FI2004-2015, Control I · dif. 3.5)]

Un émbolo cilíndrico de radio $R$, con paredes adiabáticas, contiene un gas ideal
de $N$ partículas. La pared móvil del émbolo (masa $m$) tiene un resorte de largo
natural $l_0$ y constante elástica $K$. El extremo fijo del resorte está a distancia
$L$ de la pared fija del émbolo.

Si el gas tiene temperatura $T$:

*(a)* Encuentre la posición de equilibrio $x_0$ del émbolo balanceando la fuerza del
resorte y la presión del gas.

*(b)* Calcule la distancia típica de fluctuación del émbolo alrededor de $x_0$.
#text(size: 9pt, fill: luma(80))[_Ind.: expanda la energía potencial efectiva (gas + resorte) alrededor del equilibrio hasta segundo orden._]

#v(1.5em)
#line(length: 100%, stroke: 1pt)
#v(0.3em)

= Problemas de Práctica

== Práctica 1 — Sólido de Einstein

El modelo de Einstein describe un sólido cristalino como $N$ osciladores armónicos
independientes (en 3D: $3N$ osciladores), cada uno con frecuencia $omega_0$.

*(a)* Para el caso clásico, calcule la función de partición de un oscilador a
temperatura $T$ usando:
$ z_"osc" = integral_(-infinity)^(+infinity) frac(d p d q, h) e^(-beta (p^2/(2m) + m omega_0^2 q^2/2)) $
Muestre que $z_"osc" = k T slash (planck.reduce omega_0)$.

*(b)* Derive la energía media del sólido y su calor específico $C_V$. Compare con
la ley de Dulong-Petit ($C_V = 3 N k_B$).

*(c)* Para el caso cuántico, cada oscilador tiene energía $E_n = planck.reduce omega_0 (n + 1/2)$
con $n = 0, 1, 2, dots.h$ Calcule $z_"osc"^"cuántico"$ y el calor específico resultante.
Muestre que $C_V arrow.r 0$ cuando $T arrow.r 0$ (Tercera Ley).

== Práctica 2 — Gas con Dos Estados Internos

Considere un gas ideal de $N$ partículas en 3D a temperatura $T$, donde cada
partícula tiene dos estados internos de energía: $0$ y $epsilon > 0$.

*(a)* Calcule la función de partición de una partícula $z_1 = z_"trasl" dot.op z_"int"$,
separando los grados de libertad traslacionales e internos.

*(b)* Encuentre la energía interna $U(T)$ y el calor específico $C_V(T)$.

*(c)* Muestre que $C_V$ tiene un máximo (pico de Schottky) en
$k T^* approx epsilon slash 2.4$. ¿Qué comportamiento tiene $C_V$ para $T >> epsilon / k$
y para $T << epsilon / k$?

*(d)* Calcule la ecuación de estado y muestre que el volumen específico solo
depende de los grados traslacionales.

== Práctica 3 — Gas de Fotones Bidimensional

Considere una cavidad bidimensional de área $A$ con fotones, con relación de
dispersión $epsilon = planck.reduce c |bold(k)|$ donde $bold(k)$ es el vector de onda 2D.

*(a)* Calcule la función de partición $Z(A, T)$ para $N$ fotones.

*(b)* Muestre que la ecuación de estado satisface $tau A = U$ donde $tau$ es la
"presión" bidimensional (tensión superficial). Compare con el caso 3D: $P V = U slash 3$.

*(c)* Derive la relación general: en $d$ dimensiones, $P_d V_d = U slash d$. Interprete.
