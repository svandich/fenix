#set page(width: auto, height: auto, margin: (x: 0.5em, y: 0.3em), fill: none)
#set text(fill: rgb("#e6edf3"), size: 13pt)

$
d U &= T thin d S - p thin d V + mu thin d N \
d F &= -S thin d T - p thin d V + mu thin d N \
d H &= T thin d S + V thin d p + mu thin d N \
d G &= -S thin d T + V thin d p + mu thin d N
$

#pagebreak()

$ F = U - T S quad quad H = U + p V quad quad G = U - T S + p V $

#pagebreak()

$ U = F - T lr((diff F)/(diff T))_V = -T^2 lr([(diff (F slash T))/(diff T)]_V) $

#pagebreak()

$ lr((diff S)/(diff p))_T = -lr((diff V)/(diff T))_p $
