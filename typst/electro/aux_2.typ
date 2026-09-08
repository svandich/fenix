#set page(width: auto, height: auto, margin: (x: 0.5em, y: 0.3em), fill: none)
#set text(fill: rgb("#e6edf3"), size: 13pt)

$ integral.cont_S bold(E) dot.op d bold(S) = Q_"enc" / epsilon.alt_0 $

#pagebreak()

$ nabla dot.op bold(E) = rho / epsilon.alt_0 $

#pagebreak()

$ E(r) = cases(
  Q / (4 pi epsilon.alt_0 r^2) & r > R,
  (Q r) / (4 pi epsilon.alt_0 R^3) & r < R quad "(carga uniforme)"
) $
