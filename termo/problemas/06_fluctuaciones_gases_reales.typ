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
  #text(size: 16pt, weight: "bold")[Fluctuaciones y Gases Reales]
  #v(4pt)
  #text(size: 10pt)[Termodinámica FI2004 — FCFM, Universidad de Chile]
  #v(2pt)
  #text(size: 9pt, fill: luma(100))[Cátedras 12, 17–18 · Virial, punto crítico, fluctuaciones térmicas]
]
#v(0.5em)
#line(length: 100%, stroke: 1pt)
#v(0.3em)

= Problemas de Exámenes y Controles

== Problema 1 — Flotación Térmica
#text(size: 9pt, style: "italic")[(FI2004-2009-02, Ej. 6; FI2004-2015, Ej. 8 · dif. 4.0)]

Considere una columna de gas semi-infinita a temperatura $T$, bajo la influencia
de un campo gravitatorio constante $g$, a la cual se le agrega un cuerpo extraño
de masa $m$.

*(a)* Encuentre la distribución de probabilidad de la altura $z$ del cuerpo externo,
usando que el gas actúa como un baño que provee fluctuaciones térmicas. La densidad
del gas es $rho(z)$ (distribución barométrica del Gas 2 del Set 1).

*(b)* Encuentre la altura media $overline(z)$ a la cual el objeto se encuentra
debido a las fluctuaciones térmicas.

*(c)* Analice físicamente la dependencia de $overline(z)$ con la temperatura $T$,
la masa $m$ y la gravedad $g$.
#text(size: 9pt, fill: luma(80))[_Ind.: justifique explícita y claramente sus argumentos._]

== Problema 2 — Corcho en un Fluido
#text(size: 9pt, style: "italic")[(FI22A-2007-02, Ej. 7 · dif. 3.0)]

Un recipiente contiene un líquido de densidad $rho$. Sobre el líquido se coloca un
corcho cilíndrico de altura $h$, radio $R$ y densidad $rho_1 < rho$ (el corcho flota
por el principio de Arquímedes). El fluido está a temperatura $T$.

Encuentre la distancia típica a la cual el corcho está fluctuando con respecto al
nivel del líquido, debido a las fluctuaciones térmicas.
#text(size: 9pt, fill: luma(80))[_Ind.: el corcho sufre una fuerza restauradora proporcional al volumen del fluido desplazado._]

== Problema 3 — Punto Crítico del Gas de Van der Waals
#text(size: 9pt, style: "italic")[(FI22A-2007-02, Examen · dif. 3.5)]

Considere la ecuación de estado de van der Waals:
$ lr((P + frac(a N, V)))lr((frac(V, N) - b)) = k T $

Un sistema es mecánicamente estable si la presión como función de la densidad es
monótona creciente; es inestable cuando tiene compresibilidad negativa.

*(a)* Expanda en potencias de la densidad $rho = N slash V$ hasta el tercer término
del virial (ecuación de van der Waals cúbica).

*(b)* Encuentre la relación que deben satisfacer $a$, $b$ y $T$ para que la curva
presión-densidad deje de ser monótona (punto crítico). Calcule la densidad $rho_c$,
temperatura $T_c$ y presión $P_c$ críticas en función de $a$, $b$ y $k$.

*(c)* Interprete físicamente la densidad crítica como función de $a$, $b$ y $T$.

== Problema 4 — Punto Crítico del Gas de Dieterici
#text(size: 9pt, style: "italic")[(FI2004-2015, Ej. 3 · dif. 3.0)]

Un gas real sigue la ecuación de Dieterici:
$ P = frac(n R T, V - n b) exp(-frac(n a, R T V)) $

donde $n$ es el número de moles. El punto crítico se define como el punto de
inflexión de la curva $P(V)$: primera y segunda derivada con respecto al volumen
iguales a cero.

Calcule la presión $P_c$, temperatura $T_c$ y volumen $V_c$ en el punto crítico.
Compare con los valores del gas de van der Waals.

== Problema 5 — Segundo Coeficiente del Virial desde Van der Waals
#text(size: 9pt, style: "italic")[(FI2004-2009-02, Ej. 13 · dif. 2.5)]

A partir de la ecuación de estado de van der Waals, encuentre el segundo término
del virial $B_2(T)$, donde la ecuación de estado expandida es:
$ frac(P V, N k T) = 1 + frac(N B_2(T), V) + dots.h $

Interprete físicamente los roles de los parámetros $a$ (atracción) y $b$ (volumen
excluido) en el signo de $B_2(T)$ a diferentes temperaturas.

#v(1.5em)
#line(length: 100%, stroke: 1pt)
#v(0.3em)

= Problemas de Práctica

== Práctica 1 — Fluctuación de Volumen en el Ensemble Canónico

En el ensemble canónico, el volumen fluctúa alrededor de su valor de equilibrio.
Para un gas ideal de $N$ partículas a temperatura $T$ y presión $P$:

*(a)* Muestre que la varianza del volumen es:
$ sigma_V^2 = overline((Delta V)^2) = k_B T V kappa_T $
donde $kappa_T = -(1/V)(diff V slash diff P)_T$ es la compresibilidad isotérmica.

*(b)* Calcule $sigma_V / V$ para el gas ideal y muestre que $sigma_V / V tilde 1 / sqrt(N)$,
confirmando que las fluctuaciones relativas son despreciables para $N$ grande.

*(c)* Para el gas de van der Waals, ¿qué ocurre con las fluctuaciones de volumen
cerca del punto crítico? ¿Divergen? Interprete físicamente (fluctuaciones críticas).

== Práctica 2 — Temperatura de Boyle y Segundo Virial

El segundo coeficiente del virial $B_2(T)$ para un gas con potencial intermolecular
$U(r)$ es:
$ B_2(T) = -2 pi integral_0^infinity (e^(-U(r) slash (k T)) - 1) r^2 d r $

*(a)* Para el modelo de esferas duras más cola atractiva:
$ U(r) = cases(+infinity & r < sigma, -epsilon_0 & sigma < r < lambda sigma, 0 & r > lambda sigma) $
calcule $B_2(T)$ analíticamente.

*(b)* La temperatura de Boyle $T_B$ se define como la temperatura a la que
$B_2(T_B) = 0$ (el gas se comporta idealmente a primer orden). Encuentre $T_B$ para
el modelo de (a).

*(c)* Para un gas de van der Waals, muestre que $T_B = a / (k b)$ y que para
$T > T_B$ el gas es más difícil de comprimir que el ideal, mientras que para
$T < T_B$ es más fácil. Interprete en términos del balance atracción/repulsión.

== Práctica 3 — Gas Real con Potencial Gaussiano

Considere un gas de $N$ partículas con interacción de pares débil y simétrica
(potencial de apares):
$ U(r) = zeta e^(-alpha r^2) $
donde $zeta << k T$ (interacción débil) y $alpha$ es una longitud característica.

*(a)* En el límite de interacción débil ($zeta << k T$), encuentre la ecuación de
estado a primer orden en $zeta$:
$ P = frac(N k T, V) + "corrección"(T, V, N, zeta, alpha) $

*(b)* Determine el segundo coeficiente del virial $B_2(T)$ para este potencial.
¿Es siempre negativo (atractivo) o puede cambiar de signo?

*(c)* Compare con el gas de van der Waals en términos del signo de la corrección
y la dependencia con $T$. ¿Cuál sería la "temperatura de Boyle" para este gas?
