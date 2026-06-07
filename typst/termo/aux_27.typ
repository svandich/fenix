#set page(width: auto, height: auto, margin: (x: 0.5em, y: 0.3em), fill: none)
#set text(fill: rgb("#e6edf3"), size: 13pt)

$ lr((diff x)/(diff y))_z lr((diff y)/(diff z))_x lr((diff z)/(diff x))_y = -1 quad quad lr((diff x)/(diff y))_z = (lr((diff x \/ diff w))_z) / (lr((diff y \/ diff w))_z) $

#pagebreak()

$ d f = M thin d x + N thin d y quad "exacto" arrow.l.r.double lr((diff M)/(diff y))_x = lr((diff N)/(diff x))_y $

#pagebreak()

$ g(p) = f(x) - p dot.op x quad quad "con" p = d f \/ d x quad quad x = -d g \/ d p $

#pagebreak()

$ ln N! approx N ln N - N $
