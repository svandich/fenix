#set page(width: auto, height: auto, margin: (x: 0.5em, y: 0.3em), fill: none)
#set text(fill: rgb("#e6edf3"), size: 13pt)

$ nabla f = (partial f)/(partial x) hat(x) + (partial f)/(partial y) hat(y) + (partial f)/(partial z) hat(z) $

#pagebreak()

$ nabla dot.op bold(F) = (partial F_x)/(partial x) + (partial F_y)/(partial y) + (partial F_z)/(partial z) $

#pagebreak()

$ integral.surf_S bold(F) dot.op d bold(A) = integral.triple_V nabla dot.op bold(F) d V $

#pagebreak()

$ nabla times bold(F) = mat(delim: "|", hat(x), hat(y), hat(z); partial_x, partial_y, partial_z; F_x, F_y, F_z) $

#pagebreak()

$ integral.cont_C bold(F) dot.op d bold(ell) = integral.double_S (nabla times bold(F)) dot.op d bold(A) $

#pagebreak()

$ nabla^2 f = (partial^2 f)/(partial x^2) + (partial^2 f)/(partial y^2) + (partial^2 f)/(partial z^2) = nabla dot.op (nabla f) $

#pagebreak()

$ nabla^2 V = -rho / epsilon.alt_0 quad "(Poisson)" quad quad quad quad nabla^2 V = 0 quad "(Laplace)" $
