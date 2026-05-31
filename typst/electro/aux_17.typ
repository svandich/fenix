#set page(width: auto, height: auto, margin: (x: 0.5em, y: 0.3em), fill: none)
#set text(fill: rgb("#e6edf3"), size: 13pt)

$ bold(F)_"mag" = q(bold(v) times bold(B)) quad quad bold(F)_"Lorentz" = q(bold(E) + bold(v) times bold(B)) $

#pagebreak()

$ bold(F) = integral I dif bold(l) times bold(B) quad quad bold(F) = integral.double bold(K) times bold(B) dif S quad quad bold(F) = integral.triple bold(J) times bold(B) dif V $

#pagebreak()

$ bold(B)(bold(r)) = mu_0 / (4 pi) integral (bold(I) times (bold(r) - bold(r)')) / (|bold(r) - bold(r)'|^3) dif bold(l)' $

#pagebreak()

$ bold(B)(bold(r)) = mu_0 / (4 pi) integral.double_S (bold(K)(bold(r)') times (bold(r) - bold(r)')) / (|bold(r) - bold(r)'|^3) dif S' quad quad bold(B)(bold(r)) = mu_0 / (4 pi) integral.triple_V (bold(J)(bold(r)') times (bold(r) - bold(r)')) / (|bold(r) - bold(r)'|^3) dif V' $
