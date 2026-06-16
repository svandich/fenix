#set page(width: auto, height: auto, margin: (x: 0.5em, y: 0.3em), fill: none)
#set text(fill: rgb("#e6edf3"), size: 13pt)

$ Z_N (T,V) = Z_"trasl"^N (T,V) dot.op Z_"interno"^N (T) / N! quad quad F = -k_B T ln Z_N $

#pagebreak()

$ P = -(diff F)/(diff V)_(T,N) = (N k_B T)/V quad quad arrow.r.double quad P V = N k_B T $

#pagebreak()

$ U_"LJ" (r) = 4 epsilon [ (sigma/r)^12 - (sigma/r)^6 ] quad quad F(r) = -(dif U_"LJ")/(dif r) $

#pagebreak()

$ U_"LJ" prop cases(
  +1/r^12 & "(repulsión, origen cuántico, Pauli)",
  -1/r^6 & "(atracción, dipolo-dipolo inducido)"
) $
