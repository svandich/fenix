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
  #text(size: 16pt, weight: "bold")[Segunda Ley de la Termodinámica y Entropía]
  #v(4pt)
  #text(size: 10pt)[Termodinámica FI2004 — FCFM, Universidad de Chile]
  #v(2pt)
  #text(size: 9pt, fill: luma(100))[Cátedras 9–10 · Entropía, mezcla de gases, consecuencias macroscópicas]
]
#v(0.5em)
#line(length: 100%, stroke: 1pt)
#v(0.3em)

= Problemas de Exámenes y Controles

== Problema 1 — Entropía del Gas Ideal
#text(size: 9pt, style: "italic")[(FI2004-2009-02, Examen · dif. 4.0)]

Considere un gas ideal formado por $N$ partículas de masa $m$ al interior de un
volumen $V$ a temperatura $T$.

*(a)* Encuentre la entropía que caracteriza este gas: determine el número de
microestados $Omega(N, V, E)$ y use $S = k_B ln Omega$.
#text(size: 9pt, fill: luma(80))[_Ind.: debe justificar claramente todos sus argumentos. Use la fórmula de Stirling $ln(n!) approx n ln n - n$._]

*(b)* Comente cómo cambian los microestados al aumentar el volumen $V$, la
energía $E$ y el número de partículas $N$ por separado.

*(c)* Muestre que la expresión obtenida en (a) es consistente con la relación
termodinámica $1/T = (diff S slash diff U)_(V,N)$ y que recupera $U = 3/2 N k T$.

== Problema 2 — Mezclar o Amalgamar Dos Gases
#text(size: 9pt, style: "italic")[(FI22A-2006-02, Examen; FI2004-2015, Examen · dif. 3.5)]

Un contenedor tiene dos cámaras separadas por una pared adiabática sin poros.
La cámara 1 tiene un gas ideal con energía $E_1$, volumen $V_1$ y $N_1$ partículas;
la cámara 2 tiene energía $E_2$, volumen $V_2$ y $N_2$ partículas del _mismo_ tipo
de gas. La energía total es $E = E_1 + E_2$ y el volumen total es $V = V_1 + V_2$.

*(a)* Encuentre la entropía del sistema _antes_ de retirar la pared:
$S(N_1, N_2, V_1, V_2, E_1, E_2)$.

*(b)* Si se elimina la pared adiabática, encuentre la entropía del sistema amalgamado
$S(N_1 + N_2, V, E)$ y calcule la temperatura y presión de la mezcla a partir de
esta expresión.

*(c)* Demuestre que la entropía no disminuye al mezclar ($Delta S >= 0$).

== Problema 3 — Consecuencias de la Segunda Ley: $U$ y el Volumen
#text(size: 9pt, style: "italic")[(FI2004-2009-02, Ej. 9 · dif. 4.0)]

Muestre que la energía interna de un material cuya ecuación de estado tiene la
forma $p = f(V) T$ es _independiente del volumen_, es decir,
$(diff U slash diff V)_T = 0$.

Para ello, use la relación termodinámica:
$ lr((frac(diff U, diff V)))_T = T lr((frac(diff P, diff T)))_V - P $

¿Para qué gas(es) conocidos se satisface $P = f(V) T$? Verifique explícitamente.

== Problema 4 — Interacción de Sistemas: Equilibrio Térmico
#text(size: 9pt, style: "italic")[(FI2004-2009-02, Control I · dif. 3.5)]

Considere dos sistemas que inicialmente _no_ están en contacto, cada uno
caracterizado por energía $U_i$ y volumen $V_i$ (donde $i = {1, 2}$). Luego se
colocan en contacto por medio de una pared móvil y permeable: la pared permite
intercambiar tanto energía como momentum (volumen).

*(a)* Encuentre las condiciones de equilibrio térmico y mecánico maximizando la
entropía total $S = S_1 + S_2$.

*(b)* Interprete las relaciones obtenidas: ¿cuáles magnitudes se igualan en
equilibrio? Relacione con las definiciones termodinámicas de $T$ y $P$.

#v(1.5em)
#line(length: 100%, stroke: 1pt)
#v(0.3em)

= Problemas de Práctica

== Práctica 1 — Paradoja de Gibbs y Entropía de Mezcla

*(a)* Repita el Problema 2, pero ahora con dos gases _distintos_ (distintas masas
$m_1 \neq m_2$) en las dos cámaras. Calcule el aumento de entropía al mezclarlos
(entropía de mezcla):
$ Delta S_"mezcla" = -N k sum_i x_i ln x_i $
donde $x_i = N_i slash N$ son las fracciones molares. Muestre que $Delta S_"mezcla" > 0$.

*(b)* La "paradoja de Gibbs" consiste en que si $m_1 = m_2$ (gases idénticos) uno
esperaría $Delta S = 0$, pero la fórmula del punto (a) da $Delta S > 0$. Explique
por qué esto _no_ es una paradoja desde el punto de vista cuántico y qué corrección
(factor de $N!$) resuelve el problema clásico.

*(c)* Calcule $Delta S_"mezcla"$ para una mezcla equimolar ($N_1 = N_2 = N slash 2$)
de dos gases distintos y expréselo en unidades de $N k$.

== Práctica 2 — Ciclo de Carnot y Eficiencia Máxima

*(a)* Describa el ciclo de Carnot para un gas ideal monoatómico operando entre
temperaturas $T_c$ (fuente fría) y $T_h$ (fuente caliente). Exprese el calor absorbido
$Q_h$ y cedido $Q_c$ en términos de los volúmenes y temperaturas.

*(b)* Demuestre que la eficiencia del ciclo es $eta = 1 - T_c slash T_h$ usando solo
la primera ley y la condición $P V^gamma = "cte"$ en las etapas adiabáticas.

*(c)* Un motor de vapor opera entre $T_h = 500 "K"$ y $T_c = 300 "K"$. Si su potencia
es de 10 kW, ¿cuánto calor absorbe por segundo de la fuente caliente en el caso ideal
(Carnot)? ¿Y cuánto debe absorber si su eficiencia real es del 60% de la de Carnot?

== Práctica 3 — Entropía en Procesos Irreversibles

*(a)* Dos bloques metálicos de masas $m_1, m_2$ y calores específicos $c_1, c_2$
están inicialmente a temperaturas $T_1 > T_2$. Se ponen en contacto térmico
(sin trabajo) hasta alcanzar el equilibrio. Encuentre la temperatura de equilibrio
$T_f$ y el cambio de entropía total $Delta S_"tot"$.

*(b)* Muestre que $Delta S_"tot" >= 0$, con igualdad solo si $T_1 = T_2$. #text(size: 9pt, fill: luma(80))[_Ind.: use $ln(x) <= x - 1$._]

*(c)* Un gas ideal se expande irreversiblemente al vacío (expansión de Joule),
duplicando su volumen. Calcule el cambio de entropía del gas y del universo.
Compare con la expansión isotérmica reversible al mismo volumen final.

== Práctica 4 — Relaciones de Maxwell

A partir de los cuatro potenciales termodinámicos
$U(S, V)$, $F(T, V)$, $H(S, P)$ y $G(T, P)$, derive las cuatro relaciones de Maxwell:

$ lr((frac(diff T, diff V)))_S = -lr((frac(diff P, diff S)))_V, quad
  lr((frac(diff S, diff V)))_T = lr((frac(diff P, diff T)))_V $
$ lr((frac(diff T, diff P)))_S = lr((frac(diff V, diff S)))_P, quad
  lr((frac(diff S, diff P)))_T = -lr((frac(diff V, diff T)))_P $

Use la relación de Maxwell $(diff S slash diff V)_T = (diff P slash diff T)_V$ para
demostrar el Problema 3 (que $U$ es independiente de $V$ cuando $P = f(V) T$).
