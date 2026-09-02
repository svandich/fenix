#set page(width: auto, height: auto, margin: (x: 0.5em, y: 0.3em), fill: none)
#set text(fill: rgb("#e6edf3"), size: 13pt)

$ C_P - C_V = [P + lr((partial U)/(partial V))_T] lr((partial V)/(partial T))_P > 0 $

#pagebreak()

$ C_P - C_V = underbrace(P lr((partial V)/(partial T))_P, "trabajo de expansión") + underbrace(lr((partial U)/(partial V))_T lr((partial V)/(partial T))_P, "separar las moléculas") $

#pagebreak()

$ "Gas ideal:" quad lr((partial U)/(partial V))_T = 0", " lr((partial V)/(partial T))_P = R/P quad => quad C_P - C_V = R $

#pagebreak()

$ "Líquidos y sólidos:" quad lr((partial V)/(partial T))_P approx 0 quad => quad C_P approx C_V $

#pagebreak()

$ W = integral_(V_1)^0 P_1 thin d V + integral_0^(V_2) P_2 thin d V = P_2 V_2 - P_1 V_1 $

#pagebreak()

$ Q = 0 quad => quad U_2 - U_1 = -(P_2 V_2 - P_1 V_1) quad => quad H_2 = H_1 $

#pagebreak()

$ mu_"JT" equiv lr((partial T)/(partial P))_H = lim_(Delta P -> 0) lr((Delta T)/(Delta P))_H $

#pagebreak()

$ lr((partial H)/(partial P))_T lr((partial P)/(partial T))_H lr((partial T)/(partial H))_P = -1 quad => quad lr((partial H)/(partial P))_T = -mu_"JT" C_P $

#pagebreak()

$ d H = C_P thin d T - mu_"JT" C_P thin d P $
