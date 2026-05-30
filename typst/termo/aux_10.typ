#set page(width: auto, height: auto, margin: (x: 0.5em, y: 0.3em), fill: none)
#set text(fill: rgb("#e6edf3"), size: 13pt)

$ eta_C = 1 - T_f/T_c = (T_c - T_f)/T_c $

#pagebreak()

$ d S = (macron(delta) Q_"rev")/T quad => quad Delta S = integral_i^f (macron(delta) Q_"rev")/T $

#pagebreak()

$ integral.cont (macron(delta) Q)/T <= 0 quad cases(
  = 0 & "ciclo reversible",
  < 0 & "ciclo irreversible"
) $

#pagebreak()

$ Delta S_"universo" = Delta S_"sistema" + Delta S_"entorno" >= 0 $
