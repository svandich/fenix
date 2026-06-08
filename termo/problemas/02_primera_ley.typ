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
  #text(size: 16pt, weight: "bold")[Primera Ley de la Termodinámica]
  #v(4pt)
  #text(size: 10pt)[Termodinámica FI2004 — FCFM, Universidad de Chile]
  #v(2pt)
  #text(size: 9pt, fill: luma(100))[Cátedras 6–8 · Trabajo, calor, procesos cuasi-estáticos, capacidad calórica]
]
#v(0.5em)
#line(length: 100%, stroke: 1pt)
#v(0.3em)

= Problemas de Exámenes y Controles

== Problema 1 — Proceso Adiabático: Relación de Poisson
#text(size: 9pt, style: "italic")[(FI2004-2015, Ej. 4 · dif. 5.0)]

Considere un gas ideal que se expande cuasi-estáticamente y adiabáticamente.

*(a)* Muestre que se satisface la relación de Poisson $P V^gamma = "cte"$, donde
$gamma equiv C_p slash C_v$. Para ello, use que el calor específico es constante y
que el proceso es adiabático ($delta Q = 0$).

*(b)* Derive también las relaciones $T V^(gamma-1) = "cte"$ y $T^gamma P^(1-gamma) = "cte"$.

*(c)* Muestre que la relación $kappa_"ad" = C_v slash C_p dot.op kappa_T$ se satisface, donde
$kappa_"ad" = -(1/V)(diff V slash diff P)_"ad"$ y $kappa_T = -(1/V)(diff V slash diff P)_T$
son los coeficientes de compresibilidad adiabático e isotérmico.
#text(size: 9pt, fill: luma(80))[_Dif. adicional 5.0 para la parte (c)._]

== Problema 2 — Gas Monoatómico de Van der Waals: Expansión Adiabática
#text(size: 9pt, style: "italic")[(FI2004-2009-02, Ej. 4 · dif. 4.0)]

Un gas monoatómico real está descrito por la ecuación de van der Waals
$ P = frac(N k T, V - N b) - frac(a N^2, V^2) $
con energía interna $U = 3/2 N k T - a N^2 slash V$.

Inicialmente el gas está a temperatura $T_1$ y volumen $V_1$. Luego se expande
adiabáticamente (sin intercambio de calor con el exterior) hasta ocupar un
volumen $V_2$.

Encuentre la temperatura final $T_2$ del gas.

== Problema 3 — Gas Real con $C_v$ Constante: Proceso Adiabático
#text(size: 9pt, style: "italic")[(FI2004-2009-02, Ej. 12 · dif. 3.5)]

Encuentre la ecuación que caracteriza un proceso adiabático cuasi-estático para
un gas real descrito por la ecuación de estado de van der Waals con capacidad
calórica a volumen constante $C_v$ constante (independiente de la temperatura).

Exprese el resultado como una relación entre $T$ y $V$ a lo largo del proceso
adiabático, y compárela con la relación de Poisson del gas ideal.

== Problema 4 — Gas Unidimensional con Pistón
#text(size: 9pt, style: "italic")[(FI2004-2015, Control I · dif. 3.5)]

Considere un émbolo cilíndrico de radio $R$, formado por paredes adiabáticas,
que contiene un gas ideal de $N$ partículas. La pared móvil del émbolo (masa $m$)
tiene un resorte de largo natural $l_0$ y constante elástica $K$; el extremo fijo
del resorte está a distancia $L$ de la pared fija del émbolo.

Si el gas tiene temperatura $T$, calcule la posición de equilibrio del émbolo y
la distancia típica de fluctuación alrededor de ese equilibrio.
#text(size: 9pt, fill: luma(80))[_Ind.: encuentre la posición de equilibrio entre el resorte y la presión del gas._]

#v(1.5em)
#line(length: 100%, stroke: 1pt)
#v(0.3em)

= Problemas de Práctica

== Práctica 1 — Expansión Libre de Joule

Un gas de van der Waals con $N$ partículas ocupa un volumen $V_1$ a temperatura
$T_1$. Se abre una válvula hacia un recipiente vacío de volumen $V_2 - V_1$, y el
gas se expande libremente (sin trabajo, sin calor: expansión de Joule).

*(a)* Usando la primera ley ($Delta U = 0$ en expansión libre), encuentre la
temperatura final $T_2$ del gas. La energía interna es $U = C_v T - a N^2 slash V$.

*(b)* Muestre que para un gas ideal ($a = 0$) la temperatura no cambia.

*(c)* Para el gas real con $a > 0$: ¿el gas se enfría o se calienta? ¿Qué papel
juega el parámetro $a$? Interprete físicamente.

*(d)* Calcule el coeficiente de Joule $mu_J = (diff T slash diff V)_U$ para este gas.

== Práctica 2 — Coeficiente de Joule-Thomson

El proceso de Joule-Thomson consiste en hacer pasar un gas a través de un
tapón poroso. La entalpía se conserva ($H = "cte"$).

*(a)* Para un gas de van der Waals, calcule el coeficiente de Joule-Thomson:
$ mu_"JT" = lr((frac(diff T, diff P)))_H $
a primer orden en las constantes $a$ y $b$ (gas levemente no ideal).

*(b)* Muestre que $mu_"JT" = 0$ para el gas ideal.

*(c)* Defina la temperatura de inversión $T^* $ como la temperatura a la que
$mu_"JT" = 0$ para el gas real. Calcule $T^*$ para el gas de van der Waals y
discuta cuándo el gas se enfría al pasar por el tapón.

== Práctica 3 — Ciclo de Aire: Motor Otto

El ciclo Otto (motor de gasolina) consta de cuatro procesos cuasi-estáticos
para un gas ideal diatómico ($gamma = 7/5$):
1→2: compresión adiabática de $V_1$ a $V_2$
2→3: combustión isocórica (calor $Q_"in"$ absorbido)
3→4: expansión adiabática de $V_2$ a $V_1$
4→1: escape isocórico (calor $Q_"out"$ cedido)

*(a)* Dibuje el ciclo en el diagrama $P$-$V$.

*(b)* Muestre que la eficiencia del ciclo es
$ eta = 1 - lr((frac(V_2, V_1)))^(gamma - 1) $

*(c)* Para una relación de compresión $r = V_1 slash V_2 = 8$, calcule $eta$ y compárela
con la eficiencia de Carnot operando entre las mismas temperaturas extremas del ciclo.

== Práctica 4 — Calores Específicos y Equipartición

*(a)* Usando el teorema de equipartición, deduzca $C_v$ para: gas monoatómico
3D, gas diatómico 3D (traslación + rotación clásica), gas diatómico con
vibración (traslación + rotación + vibración).

*(b)* A temperatura $T$, el gas diatómico tiene $C_v = 5/2 N k$ (sin vibración).
Muestre que $C_p = 7/2 N k$ y $gamma = 7/5$.

*(c)* Explique por qué el valor de $C_v$ medido para el $"H"_2$ a bajas temperaturas
es $3/2 N k$ (como monoatómico), $5/2 N k$ a temperatura ambiente, y tendería a
$7/2 N k$ a muy altas temperaturas. Relacione esto con el principio de incertidumbre.
