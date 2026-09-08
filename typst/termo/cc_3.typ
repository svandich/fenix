#set page(width: auto, height: auto, margin: (x: 0.5em, y: 0.3em), fill: none)
#set text(fill: rgb("#e6edf3"), size: 13pt)

#table(
  columns: 4,
  stroke: rgb("#e6edf3") + 0.4pt,
  inset: 5pt,
  align: center,
  [*Proceso*], [*W*], [*Q*], [*ΔU*],
  [Isotérmico], $-N k_B T ln(V_f\/V_i)$, $N k_B T ln(V_f\/V_i)$, $0$,
  [Isocórico], $0$, $N C_V Delta T$, $N C_V Delta T$,
  [Isobárico], $-p Delta V$, $N C_p Delta T$, $N C_V Delta T$,
  [Adiabático], $N C_V Delta T$, $0$, $N C_V Delta T$,
)

#pagebreak()

$ p V^gamma = "cte" quad quad T V^(gamma-1) = "cte" quad quad T^gamma p^(1-gamma) = "cte" $
