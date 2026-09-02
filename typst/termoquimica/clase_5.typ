#set page(width: auto, height: auto, margin: (x: 0.5em, y: 0.3em), fill: none)
#set text(fill: rgb("#e6edf3"), size: 13pt)

$ integral.cont macron(delta) W = integral.cont macron(delta) Q quad => quad integral.cont (macron(delta) Q - macron(delta) W) = 0 $

#pagebreak()

$ d U = macron(delta) Q - macron(delta) W quad => quad Delta U = Q - W $

#pagebreak()

$ d U = lr((partial U)/(partial T))_V thin d T + lr((partial U)/(partial V))_T thin d V $

#pagebreak()

$ C_V equiv (macron(delta) Q_V)/(d T) = lr((partial U)/(partial T))_V quad => quad Delta U = integral_(T_1)^(T_2) C_V thin d T = C_V Delta T $

#pagebreak()

$ "Expansión libre:" quad macron(delta) W = 0", " macron(delta) Q = 0 => d U = 0 quad => quad lr((partial U)/(partial V))_T = 0 $

#pagebreak()

$ underbrace(U = U(T), "Ley de Joule") quad quad d U = C_V thin d T + lr((partial U)/(partial V))_T thin d V $

#pagebreak()

$ H equiv U + P V quad => quad Delta H = Delta U + P Delta V = Q_P $

#pagebreak()

$ d H = lr((partial H)/(partial T))_P thin d T + lr((partial H)/(partial P))_T thin d P $

#pagebreak()

$ C_P equiv (macron(delta) Q_P)/(d T) = lr((partial H)/(partial T))_P quad => quad Delta H = integral_(T_1)^(T_2) C_P thin d T = C_P Delta T $
