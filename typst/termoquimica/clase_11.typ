#set page(width: auto, height: auto, margin: (x: 0.5em, y: 0.3em), fill: none)
#set text(fill: rgb("#e6edf3"), size: 13pt)

$ S_T^circle.stroked.small = integral_0^T C_P/T thin d T quad quad ("tercera ley:" S_0 = 0 "para un cristal perfecto") $

#pagebreak()

$ S_T^circle.stroked.small ("gas") = integral_0^(T_f) (C_P^circle.stroked.small (s))/T thin d T + (Delta H_"fus"^circle.stroked.small)/T_f + integral_(T_f)^(T_e) (C_P^circle.stroked.small (l))/T thin d T + (Delta H_"vap"^circle.stroked.small)/T_e + integral_(T_e)^T (C_P^circle.stroked.small (g))/T thin d T $

#pagebreak()

$ Delta S^circle.stroked.small = sum_"prod" nu_i S_i^circle.stroked.small - sum_"reac" nu_j S_j^circle.stroked.small quad quad Delta S_T^circle.stroked.small = Delta S_(T_0)^circle.stroked.small + integral_(T_0)^T (Delta C_P^circle.stroked.small)/T thin d T $

#pagebreak()

$ d S = C_V/T thin d T + lr(( (partial p)/(partial T) ))_V d V = C_V/T thin d T + alpha/kappa thin d V $

#pagebreak()

$ d S = C_P/T thin d T - lr(( (partial V)/(partial T) ))_p d p = C_P/T thin d T - V alpha thin d p $

#pagebreak()

$ "Gas ideal:" quad Delta S = C_V ln(T_2/T_1) + n R ln(V_2/V_1) = C_P ln(T_2/T_1) - n R ln(p_2/p_1) $

#pagebreak()

$ T thin d S >= delta q quad => quad d S_(U,V) >= 0 quad d U_(S,V) <= 0 quad d S_(H,p) >= 0 quad d H_(S,p) <= 0 $

#pagebreak()

$ A = U - T S quad quad G = H - T S quad quad d A_(T,V) <= 0 quad quad d G_(T,p) <= 0 $

#pagebreak()

$ mat(delim: #none, align: #left,
  d U = T d S - p d V;
  d H = T d S + V d p;
  d A = -S d T - p d V;
  d G = -S d T + V d p
) $

#pagebreak()

$ lr(( (partial T)/(partial V) ))_S = -lr(( (partial p)/(partial S) ))_V quad quad lr(( (partial T)/(partial p) ))_S = lr(( (partial V)/(partial S) ))_p \
lr(( (partial S)/(partial V) ))_T = lr(( (partial p)/(partial T) ))_V quad quad -lr(( (partial S)/(partial p) ))_T = lr(( (partial V)/(partial T) ))_p $

#pagebreak()

$ delta w_"rev" = -d A_T quad => quad |w_"máx"| = |Delta A_T| quad quad |w_(e,"máx")| = |Delta G_(T,p)| $

#pagebreak()

$ p = T lr(( (partial p)/(partial T) ))_V - lr(( (partial U)/(partial V) ))_T quad quad V = T lr(( (partial V)/(partial T) ))_p + lr(( (partial H)/(partial p) ))_T $

#pagebreak()

$ lr(( (partial U)/(partial V) ))_T = (alpha T - kappa p)/kappa quad quad lr(( (partial H)/(partial p) ))_T = V(1 - alpha T) $

#pagebreak()

$ lr(( (partial A)/(partial T) ))_V = -S quad lr(( (partial A)/(partial V) ))_T = -p quad quad lr(( (partial G)/(partial T) ))_p = -S quad lr(( (partial G)/(partial p) ))_T = V $

#pagebreak()

$ G(T,p) = G^circle.stroked.small (T) + integral_(p^circle.stroked.small)^p V thin d p quad => quad mu = mu^circle.stroked.small (T) + R T ln p quad ("gas ideal, " p " en atm") $

#pagebreak()

$ mu = mu^circle.stroked.small (T) + R T ln f quad quad ln f = ln p + integral_0^p (Z - 1)/p thin d p $

#pagebreak()

$ lr(( (partial (G\/T))/(partial T) ))_p = -H/T^2 quad quad lr(( (partial G)/(partial T) ))_p = (G - H)/T quad ("Gibbs-Helmholtz") $
