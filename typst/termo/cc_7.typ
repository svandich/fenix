#set page(width: auto, height: auto, margin: (x: 0.5em, y: 0.3em), fill: none)
#set text(fill: rgb("#e6edf3"), size: 13pt)

$ lr((partial x)/(partial y))_z lr((partial y)/(partial z))_x lr((partial z)/(partial x))_y = -1 quad quad lr((partial x)/(partial y))_z = (lr((partial x \/ partial w))_z) / (lr((partial y \/ partial w))_z) $

#pagebreak()

$ d f = M thin d x + N thin d y quad "exacto" arrow.l.r.double lr((partial M)/(partial y))_x = lr((partial N)/(partial x))_y $

#pagebreak()

$ g(p) = f(x) - p dot.op x quad quad "con" p = d f \/ d x quad quad x = -d g \/ d p $

#pagebreak()

$ ln N! approx N ln N - N $
