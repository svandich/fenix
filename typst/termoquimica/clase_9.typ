#set page(width: auto, height: auto, margin: (x: 0.5em, y: 0.3em), fill: none)
#set text(fill: rgb("#e6edf3"), size: 13pt)

$ "Kelvin-Planck:" quad eta = W/q_c < 1 quad quad "Clausius:" quad q colon T_"frío" arrow.r T_"caliente" quad "imposible sin " W $

#pagebreak()

$ eta = W_"ciclo"/q_c = (q_c + q_f)/q_c = 1 + q_f/q_c < 1 quad quad W_"ciclo" = q_c + q_f $

#pagebreak()

$ mat(delim: #none, align: #left,
  "1) A" arrow.r "B:", quad "expansión isotérmica a " T_c, quad q_c > 0;
  "2) B" arrow.r "C:", quad "expansión adiabática", quad q = 0;
  "3) C" arrow.r "D:", quad "compresión isotérmica a " T_f, quad q_f < 0;
  "4) D" arrow.r "A:", quad "compresión adiabática", quad q = 0
) $

#pagebreak()

$ eta_"Carnot" = 1 - T_f/T_c < 1 quad quad => quad q_c/T_c = - q_f/T_f $

#pagebreak()

$ Q_H = Delta U = n C_V (T_c - T_b) > 0 quad quad Q_C = Delta U = n C_V (T_a - T_d) < 0 $

#pagebreak()

$ eta_"Otto" = 1 - 1/r^(gamma - 1) quad quad r = V_"máx"/V_"mín" quad quad gamma = C_P/C_V $

#pagebreak()

$ d S = (delta q_"rev")/T quad quad => quad Delta S = integral_i^f (delta q_"rev")/T $

#pagebreak()

$ "Gas ideal, isotérmico reversible:" quad Delta S = n R ln (V_f/V_i) = - n R ln (P_f/P_i) $

#pagebreak()

$ d S_"alr" = (delta q_"alr,rev")/T_"alr" = (delta q_"alr")/T_"alr" quad quad => quad Delta S_"alr" = q_"alr"/T_"alr" $

#pagebreak()

$ N_i = (N e^(-E_i \/ k_B T))/(sum_j e^(-E_j \/ k_B T)) quad quad k_B = 1.381 times 10^(-23) " J/K" $

#pagebreak()

$ S = k_B ln W quad quad W = "número de microestados compatibles con el macroestado" $

#pagebreak()

$ Delta S_"total" = integral.cont d S = q_c/T_c + q_f/T_f = 0 quad quad => quad S "es función de estado" $

#pagebreak()

$ sum_"Total" q_"rev"/T = sum_"Perímetro" q_"rev"/T = integral.cont d S = 0 $
