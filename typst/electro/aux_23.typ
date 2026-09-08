#set page(width: auto, height: auto, margin: (x: 0.5em, y: 0.3em), fill: none)
#set text(fill: rgb("#e6edf3"), size: 13pt)

$ d arrow(m) = arrow(M) dif V quad arrow.r.double quad arrow(M) = (dif arrow(m))/(dif V) $

#pagebreak()

$ arrow(J)_m = nabla times arrow(M) quad quad arrow(K)_m = arrow(M) times hat(n) $

#pagebreak()

$ nabla times arrow(M) = hat(s) (1/s (partial M_z)/(partial phi) - (partial M_phi)/(partial z))
  + hat(phi) ((partial M_s)/(partial z) - (partial M_z)/(partial s))
  + hat(z) 1/s (partial (s M_phi))/(partial s) - 1/s (partial M_s)/(partial phi) $

#pagebreak()

$ integral.cont arrow(B) dot.op dif arrow(l) = mu_0 I_("enc,mag") quad arrow.r.double quad
  B dot.op 2 pi s = mu_0 integral_0^s J_m dot.op 2 pi s' dif s' $

#pagebreak()

$ arrow(K)_m = arrow(M) times hat(rho) = M_0 hat(x) times hat(rho) = M_0 (cos phi hat(rho) - sin phi hat(phi)) times hat(rho) = M_0 cos phi hat(z) $
