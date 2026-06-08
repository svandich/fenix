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
  #text(size: 16pt, weight: "bold")[Gas Ideal y Teoría Cinética]
  #v(4pt)
  #text(size: 10pt)[Termodinámica FI2004 — FCFM, Universidad de Chile]
  #v(2pt)
  #text(size: 9pt, fill: luma(100))[Cátedras 3–5 · Ecuación de estado, distribución de Maxwell, efusión]
]
#v(0.5em)
#line(length: 100%, stroke: 1pt)
#v(0.3em)

= Problemas de Exámenes y Controles

== Problema 1 — Gas Bidimensional
#text(size: 9pt, style: "italic")[(FI22A-2006-02 · dif. 3.0)]

Un gas bidimensional tiene $N$ partículas de masa $m$ que solo se mueven
sobre un plano. Su energía interna es $E = N k T$.

*(a)* Encuentre la ecuación de estado (relación entre $P$, $A$, $N$, $T$, donde $A$ es el área) si las colisiones con las paredes son especulares.

*(b)* Muestre que una expansión adiabática de este gas satisface $P A^gamma = "cte"$ y determine $gamma$.

== Problema 2 — Gas Ideal en Campo Gravitatorio
#text(size: 9pt, style: "italic")[(FI22A-2006-02 · dif. 3.0)]

Un gas ideal de partículas de masa $m$ está en equilibrio a temperatura fija $T$
dentro de un contenedor muy alto, bajo la influencia del campo gravitatorio $g$.

*(a)* Encuentre la distribución de densidad $n(z)$ y la presión $P(z)$ como función
de la altura $z$. #text(size: 9pt, fill: luma(80))[_Ind.: establezca el balance de fuerzas sobre un disco de volumen infinitesimal._]

*(b)* Si la atmósfera estuviera en equilibrio isotérmico, estime a qué distancia
la densidad sería despreciable. La densidad del aire a nivel del piso es
$rho_0 = 1.3 "kg/m"^3$.

== Problema 3 — Gas Unidimensional (Partículas Puntuales)
#text(size: 9pt, style: "italic")[(FI2004-2009-02, Ej. 2 · dif. 5.0)]

Un gas de $N$ partículas de masa $m$ se mueve en un canal horizontal unidimensional
de largo $l$ y sección transversal $A$. Las partículas chocan elásticamente entre
ellas y con las paredes de los extremos.

Definiendo apropiadamente la temperatura y considerando movimiento
unidimensional, encuentre la ecuación de estado del sistema.

== Problema 4 — Gas Unidimensional (Esferas Duras)
#text(size: 9pt, style: "italic")[(FI2004-2009-02, Ej. 3 · dif. 4.0)]

Repita el problema anterior, pero ahora cada partícula es una esfera de radio $R$
que se mueve en un canal de sección transversal $pi R^2$. Las esferas no se
superponen y chocan elásticamente entre sí y con las paredes.

Encuentre la ecuación de estado y compare con el caso de partículas puntuales.

== Problema 5 — Efusión: Rayo de Partículas
#text(size: 9pt, style: "italic")[(FI2004-2009-02, Ej. 8 · dif. 4.5)]

Un gas ideal de densidad $n = N slash V$ en equilibrio a temperatura $T$ está
encerrado en un volumen $V$ con paredes adiabáticas. En un instante se abre un
orificio de área $A$ por el cual escapan partículas.

La distribución de Maxwell es:
$ f(arrow(v)) = n lr((frac(m, 2 pi k T)))^(3 slash 2) e^(-m v^2 slash (2k T)) $

*(a)* Calcule el número de partículas $dot(N)$ que sale por unidad de tiempo.

*(b)* Calcule la energía $dot(E)$ que sale por el orificio por unidad de tiempo.

*(c)* Determine si el gas se enfría o se calienta como consecuencia de la efusión.
Justifique comparando la energía media de una partícula que escapa con la energía
media por partícula dentro del recipiente.

#v(1.5em)
#line(length: 100%, stroke: 1pt)
#v(0.3em)

= Problemas de Práctica

== Práctica 1 — Gas en Cilindro Rotante (Neumático)

Un gas de $N$ partículas de masa $m$ está confinado entre dos cilindros coaxiales
de radios $R_1 < R_2$ y altura $h$, que giran con velocidad angular $Omega$
constante. En el sistema rotante, las partículas experimentan una fuerza
centrífuga efectiva $m Omega^2 r$ hacia afuera.

*(a)* Encuentre la distribución de densidad $n(r)$ en equilibrio a temperatura $T$.

*(b)* Calcule la presión $P(r)$ como función del radio y encuentre el cociente
$P(R_2) slash P(R_1)$.

*(c)* Muestre que en el límite $Omega arrow.r 0$ se recupera la distribución uniforme.

*(d)* Para $Omega >> 0$: ¿hacia qué radio tiende a concentrarse el gas? Interprete físicamente.

== Práctica 2 — Efusión Diferencial y Separación de Isótopos

Una mezcla de dos gases ideales con masas $m_A$ y $m_B$ y concentraciones $n_A$
y $n_B$ está en equilibrio a temperatura $T$.

*(a)* Muestre que el flujo de partículas de la especie $i$ a través de un orificio
pequeño es $Phi_i = (n_i / 4) overline(v)_i$, donde
$overline(v)_i = sqrt(8 k T slash (pi m_i))$ es la velocidad media.

*(b)* Derive la Ley de Graham: $Phi_A slash Phi_B = (n_A slash n_B) sqrt(m_B slash m_A)$.

*(c)* Se desea separar $""^235 "UF"_6$ ($m = 349$ u) de $""^238 "UF"_6$ ($m = 352$ u)
por efusión sucesiva. ¿Cuál es el factor de enriquecimiento por etapa? Estime
cuántas etapas se necesitan para llevar el $""^235"U"$ de 0.7% a 4%.
#text(size: 9pt, fill: luma(80))[_Ind.: el factor de separación por etapa es $alpha = sqrt(352/349)$._]

== Práctica 3 — Gas en Campo Eléctrico

Un gas de $N$ iones de masa $m$ y carga $q$ se encuentra en equilibrio a temperatura
$T$ dentro de un condensador de placas paralelas separadas por $d$, con campo
eléctrico uniforme $E_0$ (la fuerza sobre cada ión es $q E_0$, constante).

*(a)* Encuentre la distribución de densidad de iones entre las placas.

*(b)* Calcule la diferencia de presiones entre ambas placas.

*(c)* Compare el resultado con el caso gravitatorio y discuta las condiciones bajo
las cuales el efecto eléctrico es comparable a la agitación térmica ($k T ~ q E_0 d$).

== Práctica 4 — Distribución de Velocidades en 1D y 2D

*(a)* Para un gas ideal en 1D a temperatura $T$, calcule la velocidad media
$overline(|v_x|)$ y la dispersión $sigma_(v_x) = sqrt(overline(v_x^2) - overline(v_x)^2)$.

*(b)* Para el gas bidimensional del Problema 1, deduzca la distribución de
rapideces $f(v) d v$ en 2D (donde $v = sqrt(v_x^2 + v_y^2)$). Encuentre la
rapidez más probable y la rapidez media.

*(c)* Compare la velocidad media en 1D, 2D y 3D. ¿Cuál es la tendencia general
con la dimensión $d$?
