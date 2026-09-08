#!/usr/bin/env python3
"""Genera los diagramas SVG del curso de Termodinámica Química.

Las curvas se calculan desde las ecuaciones reales (gas ideal, Van der Waals
reducida, construcción de Maxwell), no se dibujan a mano. Salida: un .svg por
figura dentro de la carpeta de cada clase.

Uso:  python3 scripts/make-diagrams.py
"""
import math
import os
import re

BASE = os.path.join(os.path.dirname(os.path.abspath(__file__)), "..", "termoquimica")

# Paleta del tema (styles/main.css)
TEXT   = "#e6edf3"
MUTED  = "#8b949e"
DIM    = "#6e7681"
GRID   = "#30363d"
U1, U2, U3, U4 = "#00d4ff", "#3fb950", "#d29922", "#f0883e"
PURPLE, PINK, RED, BLUE = "#bc8cff", "#f472b6", "#ef4444", "#58a6ff"
FONT = "'Inter', system-ui, sans-serif"

_MARK = re.compile(r"([_^])(?:\{([^}]*)\}|([A-Za-z0-9αβγ]))")


def markup(s, size):
    """Traduce  P_c ,  V_{op} ,  V^{gamma}  a <tspan> con sub/superíndice.

    Las cadenas ya vienen escapadas para XML (se usa &lt; y &gt; a mano), así
    que aquí sólo se reposicionan los índices.
    """
    out, i = [], 0
    for m in _MARK.finditer(s):
        out.append(s[i:m.start()])
        txt = m.group(2) if m.group(2) is not None else m.group(3)
        dy = size * 0.30 if m.group(1) == "_" else -size * 0.42
        out.append(f'<tspan font-size="{size*0.72:.1f}" dy="{dy:.2f}">{txt}'
                   f'</tspan><tspan font-size="{size}" dy="{-dy:.2f}">'
                   f'&#8203;</tspan>')
        i = m.end()
    out.append(s[i:])
    return "".join(out)


# ─────────────────────────────────────────── lienzo

class Canvas:
    def __init__(self, w, h):
        self.w, self.h, self.parts = w, h, []
        self.defs = []

    def clip_rect(self, x, y, w, h):
        """Registra un clipPath rectangular y devuelve su id."""
        cid = f"clip{len(self.defs)}"
        self.defs.append(f'<clipPath id="{cid}"><rect x="{x:.1f}" y="{y:.1f}" '
                         f'width="{w:.1f}" height="{h:.1f}"/></clipPath>')
        return cid

    def add(self, s):
        self.parts.append(s)

    def text(self, x, y, s, size=11, fill=MUTED, anchor="middle", weight="400",
             style=""):
        st = f' font-style="{style}"' if style else ""
        self.add(f'<text x="{x:.1f}" y="{y:.1f}" font-family="{FONT}" '
                 f'font-size="{size}" fill="{fill}" text-anchor="{anchor}" '
                 f'font-weight="{weight}"{st}>{markup(s, size)}</text>')

    def legend(self, x, y, entries, size=10.5, dash_for=()):
        """Caja de leyenda: entries = [(color, etiqueta), ...]."""
        w = 108
        h = 12 + 17 * len(entries)
        self.rect(x, y, w, h, "#1c2128", GRID, 1, rx=5, opacity=0.92)
        for i, (col, lab) in enumerate(entries):
            yy = y + 20 + 17 * i
            da = "4 3" if lab in dash_for else None
            self.line(x + 10, yy - 4, x + 30, yy - 4, col, 2.1, dash=da)
            self.text(x + 37, yy, lab, size, TEXT, "start")

    def path(self, d, stroke, width=1.8, fill="none", dash=None, opacity=None):
        da = f' stroke-dasharray="{dash}"' if dash else ""
        op = f' opacity="{opacity}"' if opacity is not None else ""
        self.add(f'<path d="{d}" fill="{fill}" stroke="{stroke}" '
                 f'stroke-width="{width}" stroke-linecap="round" '
                 f'stroke-linejoin="round"{da}{op}/>')

    def line(self, x1, y1, x2, y2, stroke, width=1.4, dash=None, opacity=None):
        self.path(f"M {x1:.1f} {y1:.1f} L {x2:.1f} {y2:.1f}", stroke, width,
                  dash=dash, opacity=opacity)

    def circle(self, x, y, r, fill, stroke=None, width=1.5):
        s = f' stroke="{stroke}" stroke-width="{width}"' if stroke else ""
        self.add(f'<circle cx="{x:.1f}" cy="{y:.1f}" r="{r}" fill="{fill}"{s}/>')

    def rect(self, x, y, w, h, fill="none", stroke=None, width=1.4, rx=0,
             dash=None, opacity=None):
        s = f' stroke="{stroke}" stroke-width="{width}"' if stroke else ""
        da = f' stroke-dasharray="{dash}"' if dash else ""
        op = f' opacity="{opacity}"' if opacity is not None else ""
        self.add(f'<rect x="{x:.1f}" y="{y:.1f}" width="{w:.1f}" '
                 f'height="{h:.1f}" fill="{fill}" rx="{rx}"{s}{da}{op}/>')

    def save(self, path):
        head = (f'<svg xmlns="http://www.w3.org/2000/svg" viewBox="0 0 {self.w} '
                f'{self.h}" width="{self.w}" height="{self.h}" '
                f'font-family="{FONT}">\n'
                f'<defs><marker id="ah" viewBox="0 0 10 10" refX="9" refY="5" '
                f'markerWidth="6" markerHeight="6" orient="auto-start-reverse">'
                f'<path d="M 0 0 L 10 5 L 0 10 z" fill="{DIM}"/></marker>'
                f'<marker id="ahl" viewBox="0 0 10 10" refX="9" refY="5" '
                f'markerWidth="7" markerHeight="7" orient="auto-start-reverse">'
                f'<path d="M 0 0 L 10 5 L 0 10 z" fill="{MUTED}"/></marker>'
                f'</defs>\n')
        os.makedirs(os.path.dirname(path), exist_ok=True)
        with open(path, "w") as f:
            f.write(head + "\n".join(self.parts) + "\n</svg>\n")
        print("  ", os.path.relpath(path, BASE))


class Axes:
    """Mapea coordenadas de datos a píxeles y dibuja los ejes."""

    def __init__(self, cv, x0, y0, w, h, xlim, ylim):
        self.cv, self.x0, self.y0, self.w, self.h = cv, x0, y0, w, h
        self.xlim, self.ylim = xlim, ylim

    def px(self, x):
        a, b = self.xlim
        return self.x0 + (x - a) / (b - a) * self.w

    def py(self, y):
        a, b = self.ylim
        return self.y0 + self.h - (y - a) / (b - a) * self.h

    def frame(self, xlabel, ylabel, title=None, xlab_dx=0, ylab_dy=0):
        cv = self.cv
        cv.add(f'<path d="M {self.x0} {self.y0+self.h} L {self.x0+self.w+12} '
               f'{self.y0+self.h}" stroke="{DIM}" stroke-width="1.3" '
               f'marker-end="url(#ah)" fill="none"/>')
        cv.add(f'<path d="M {self.x0} {self.y0+self.h} L {self.x0} '
               f'{self.y0-12}" stroke="{DIM}" stroke-width="1.3" '
               f'marker-end="url(#ah)" fill="none"/>')
        cv.text(self.x0 + self.w + 20 + xlab_dx, self.y0 + self.h + 5, xlabel,
                12, TEXT, "start", style="italic")
        cv.text(self.x0 - 8, self.y0 - 16 + ylab_dy, ylabel, 12, TEXT, "middle",
                style="italic")
        if title:
            cv.text(self.x0 + self.w / 2, self.y0 - 20, title, 11.5, MUTED,
                    "middle", "600")

    def curve(self, pts, stroke, width=1.9, dash=None, opacity=None):
        d = "M " + " L ".join(f"{self.px(x):.2f} {self.py(y):.2f}"
                              for x, y in pts)
        self.cv.path(d, stroke, width, dash=dash, opacity=opacity)

    def area(self, pts, fill, opacity=0.16, clip=False):
        d = ("M " + " L ".join(f"{self.px(x):.2f} {self.py(y):.2f}"
                               for x, y in pts) + " Z")
        cp = ""
        if clip:
            cid = self.cv.clip_rect(self.x0, self.y0 - 8, self.w + 8,
                                    self.h + 8)
            cp = f' clip-path="url(#{cid})"'
        self.cv.add(f'<path d="{d}" fill="{fill}" opacity="{opacity}" '
                    f'stroke="none"{cp}/>')

    def clip(self, pts):
        """Recorta una curva al rectángulo de los ejes."""
        (xa, xb), (ya, yb) = self.xlim, self.ylim
        return [(x, y) for x, y in pts if xa <= x <= xb and ya <= y <= yb]


# ─────────────────────────────────────────── física

R_ATM = 0.082057  # L·atm·mol⁻¹·K⁻¹


def vdw_volume(P, T, a, b):
    """Volumen molar de Van der Waals (raíz de gas) por bisección."""
    lo, hi = b * 1.0001, 1e6
    f = lambda V: (P + a / V**2) * (V - b) - R_ATM * T
    if f(hi) < 0:
        return None
    for _ in range(200):
        mid = math.sqrt(lo * hi)
        if f(mid) > 0:
            hi = mid
        else:
            lo = mid
    return math.sqrt(lo * hi)


def z_curve(a, b, T, pmax, n=180):
    pts = []
    for i in range(1, n + 1):
        P = pmax * i / n
        V = vdw_volume(P, T, a, b)
        if V:
            pts.append((P, P * V / (R_ATM * T)))
    return [(0.0, 1.0)] + pts


def vdw_reduced_P(Vr, Tr):
    """Ecuación de Van der Waals en variables reducidas."""
    return 8 * Tr / (3 * Vr - 1) - 3 / Vr**2


def vdw_reduced_Vr(Pr, Tr):
    """Raíz de gas de la vdW reducida.

    Por encima de T_c la isoterma es monótona decreciente en Vr, así que basta
    bisectar entre la asíntota (Vr = 1/3) y un volumen muy grande. El bracket
    debe partir en 1/3 y no en 1: a P_r altos el volumen reducido baja de 1.
    """
    lo, hi = 1.0 / 3.0 + 1e-6, 1e5
    f = lambda V: vdw_reduced_P(V, Tr) - Pr
    if f(lo) < 0 or f(hi) > 0:
        return None
    for _ in range(200):
        mid = math.sqrt(lo * hi)
        if f(mid) > 0:
            lo = mid
        else:
            hi = mid
    return math.sqrt(lo * hi)


def maxwell(Tr):
    """Construcción de Maxwell: presión de coexistencia y volúmenes reducidos.

    Busca Pr tal que las dos áreas encerradas entre la isoterma y la recta
    horizontal se cancelen, es decir ∫(P_vdW − Pr) dVr = 0 entre ambas raíces.
    """
    if Tr >= 1:
        return None
    # Muestreo fino de la isoterma. Al crecer Vr desde b, P baja, pasa por un
    # mínimo local, sube hasta un máximo local y luego decae: ese es el tramo
    # con las tres raíces.
    n = 40000
    xs = [1 / 3 + 1e-3 + i * (40.0 - 1 / 3) / n for i in range(n)]
    ps = [(v, vdw_reduced_P(v, Tr)) for v in xs]
    loc_min = loc_max = None
    for i in range(1, len(ps) - 1):
        if loc_min is None and ps[i][1] < ps[i - 1][1] and ps[i][1] < ps[i + 1][1]:
            loc_min = ps[i]
        elif loc_min is not None and loc_max is None and \
                ps[i][1] > ps[i - 1][1] and ps[i][1] > ps[i + 1][1]:
            loc_max = ps[i]
    if not (loc_min and loc_max):
        return None
    plo, phi = max(1e-9, loc_min[1]), loc_max[1]
    if phi <= plo:
        return None

    def roots(Pr):
        """Raíces Vr de la cúbica a esa Pr (líquido, inestable, gas)."""
        out, prev = [], None
        for v, p in ps:
            if prev is not None and (prev[1] - Pr) * (p - Pr) <= 0:
                lo, hi = prev[0], v
                for _ in range(60):
                    mid = 0.5 * (lo + hi)
                    if (vdw_reduced_P(lo, Tr) - Pr) * \
                       (vdw_reduced_P(mid, Tr) - Pr) <= 0:
                        hi = mid
                    else:
                        lo = mid
                out.append(0.5 * (lo + hi))
            prev = (v, p)
        return out

    def imbalance(Pr):
        r = roots(Pr)
        if len(r) < 3:
            return None
        vl, vg, m = r[0], r[-1], 2000
        return sum((vdw_reduced_P(vl + (vg - vl) * (i + 0.5) / m, Tr) - Pr)
                   for i in range(m)) * (vg - vl) / m

    lo, hi = plo, phi
    for _ in range(80):
        mid = 0.5 * (lo + hi)
        s = imbalance(mid)
        if s is None:
            break
        if s > 0:
            lo = mid
        else:
            hi = mid
    Pr = 0.5 * (lo + hi)
    r = roots(Pr)
    if len(r) < 3:
        return None
    return Pr, r[0], r[-1]


# ─────────────────────────────────────────── figuras

def _label_at(cv, ax, pts, xtarget, lab, col, dx=8, dy=-8, anchor="start",
              size=10.5, weight="600"):
    """Coloca una etiqueta sobre el punto de la curva más cercano a xtarget."""
    p = min(pts, key=lambda q: abs(q[0] - xtarget))
    cv.text(ax.px(p[0]) + dx, ax.py(p[1]) + dy, lab, size, col, anchor, weight)


def fig_gas_ideal():
    """Clase 1 — los tres cortes del diagrama de estado del gas ideal."""
    cv = Canvas(906, 300)
    pw, gap, x0 = 232, 62, 48

    # (a) isotermas en P–V̄
    ax = Axes(cv, x0, 50, pw, 186, (0, 4.4), (0, 3.2))
    ax.frame("V̄", "P", "(a) Isotermas — corte a T constante")
    # cada rótulo se ancla a una altura distinta para que no se pisen
    for T, col, lab, plab in ((0.8, U1, "T_1", 2.70), (1.3, BLUE, "T_2", 2.10),
                              (1.9, PURPLE, "T_3", 1.55)):
        pts = ax.clip([(0.2 + i * 0.012, T / (0.2 + i * 0.012))
                       for i in range(400)])
        ax.curve(pts, col)
        _label_at(cv, ax, pts, T / plab, lab, col, 9, -7)
    cv.text(x0 + pw / 2, 268, "Hipérbolas rectangulares: PV̄ = RT", 10.5, DIM)
    cv.text(ax.px(3.2), ax.py(2.5), "T_3 &gt; T_2 &gt; T_1", 10, DIM)

    # (b) isóbaras en V̄–T
    x0b = x0 + pw + gap
    ax = Axes(cv, x0b, 50, pw, 186, (0, 3.4), (0, 3.2))
    ax.frame("T", "V̄", "(b) Isóbaras — corte a P constante")
    for P, col, lab in ((0.42, U1, "P_1"), (0.75, BLUE, "P_2"),
                        (1.35, PURPLE, "P_3")):
        pts = ax.clip([(i * 0.02, i * 0.02 / P) for i in range(200)])
        ax.curve(pts, col)
        cv.text(ax.px(pts[-1][0]) + 6, ax.py(pts[-1][1]) + 4, lab, 10.5, col,
                "start", "600")
    cv.text(x0b + pw / 2, 268, "Rectas por el origen: V̄ = (R/P) T", 10.5, DIM)
    cv.text(ax.px(2.35), ax.py(0.42), "P_3 &gt; P_2 &gt; P_1", 10, DIM)

    # (c) isócoras en P–T
    x0c = x0b + pw + gap
    ax = Axes(cv, x0c, 50, pw, 186, (0, 3.4), (0, 3.2))
    ax.frame("T", "P", "(c) Isócoras — corte a V̄ constante")
    for V, col, lab in ((0.42, U1, "V̄_1"), (0.75, BLUE, "V̄_2"),
                        (1.35, PURPLE, "V̄_3")):
        pts = ax.clip([(i * 0.02, i * 0.02 / V) for i in range(200)])
        ax.curve(pts, col)
        cv.text(ax.px(pts[-1][0]) + 6, ax.py(pts[-1][1]) + 4, lab, 10.5, col,
                "start", "600")
    cv.text(x0c + pw / 2, 268, "Rectas por el origen: P = (R/V̄) T", 10.5, DIM)
    cv.text(ax.px(2.35), ax.py(0.42), "V̄_3 &gt; V̄_2 &gt; V̄_1", 10, DIM)

    cv.save(os.path.join(BASE, "clase_1", "fig_clase_1_diagramas.svg"))


def fig_compresibilidad():
    """Clase 2 — Z frente a P a 0 °C para varios gases."""
    cv = Canvas(720, 375)
    ax = Axes(cv, 62, 36, 570, 280, (0, 1000), (0, 2.0))
    ax.frame("P / atm", "Z")

    for y in (0.5, 1.0, 1.5, 2.0):
        cv.line(ax.px(0), ax.py(y), ax.px(1000), ax.py(y), GRID, 1,
                dash=None if y == 1.0 else "3 4")
        cv.text(ax.px(0) - 10, ax.py(y) + 4, f"{y:.1f}", 10, DIM, "end")
    for x in (200, 400, 600, 800, 1000):
        cv.line(ax.px(x), ax.py(0), ax.px(x), ax.py(0) + 5, DIM, 1)
        cv.text(ax.px(x), ax.py(0) + 19, str(x), 10, DIM)
    cv.text(ax.px(1000) - 6, ax.py(1.0) - 8, "gas ideal", 10, DIM, "end")

    # Los cuatro son supercríticos a 273,15 K, así que la raíz de gas de la
    # cúbica es única y la curva no tiene saltos.
    gases = [("H_2",  0.2444, 0.02661, U1),
             ("N_2",  1.390,  0.03913, BLUE),
             ("O_2",  1.360,  0.03183, U2),
             ("CH_4", 2.253,  0.04278, U3)]
    for name, a, b, col in gases:
        pts = ax.clip(z_curve(a, b, 273.15, 1000))
        ax.curve(pts, col, 2.0)
    cv.legend(ax.px(1000) - 118, ax.py(0.86),
              [(c, n) for n, _, _, c in gases])

    cv.text(ax.px(140), ax.py(0.40),
            "Z &lt; 1: dominan las fuerzas atractivas", 10.5, MUTED, "start")
    cv.text(ax.px(140), ax.py(0.22),
            "Z &gt; 1: domina el volumen propio de las moléculas", 10.5,
            MUTED, "start")
    cv.text(347, 358, "Van der Waals a 273,15 K.  Z = PV̄/RT mide de un vistazo "
            "cuánto se aparta un gas del comportamiento ideal.", 10.5, DIM)
    cv.save(os.path.join(BASE, "clase_2", "fig_clase_2_z.svg"))


def fig_isotermas_reales():
    """Clase 3 — isotermas de Van der Waals, condensación y punto crítico."""
    cv = Canvas(720, 428)
    ax = Axes(cv, 62, 40, 570, 300, (0.32, 4.6), (0, 2.0))
    ax.frame("V̄ / V̄_c", "P / P_c")

    for y in (0.5, 1.0, 1.5, 2.0):
        cv.line(ax.px(0.32), ax.py(y), ax.px(4.6), ax.py(y), GRID, 1, dash="3 4")
        cv.text(ax.px(0.32) - 10, ax.py(y) + 4, f"{y:.1f}", 10, DIM, "end")
    for x in (1, 2, 3, 4):
        cv.line(ax.px(x), ax.py(0), ax.px(x), ax.py(0) + 5, DIM, 1)
        cv.text(ax.px(x), ax.py(0) + 19, str(x), 10, DIM)

    # campana de coexistencia por construcción de Maxwell
    dome_l, dome_g = [], []
    tr = 0.62
    while tr < 0.999:
        mw = maxwell(tr)
        if mw:
            Pr, vl, vg = mw
            dome_l.append((vl, Pr))
            dome_g.append((vg, Pr))
        tr += 0.01
    dome = dome_l + [(1.0, 1.0)] + list(reversed(dome_g))
    ax.area(dome, MUTED, 0.10, clip=True)
    ax.curve(ax.clip(dome), MUTED, 1.3, dash="5 4")

    isos = ((0.85, U1), (0.90, BLUE), (0.95, PURPLE), (1.00, RED), (1.15, U2))
    for Tr, col in isos:
        pts = ax.clip([(0.34 + i * 0.0026, vdw_reduced_P(0.34 + i * 0.0026, Tr))
                       for i in range(1800)])
        ax.curve(pts, col, 1.7, dash="4 3" if Tr < 1 else None)
        mw = maxwell(Tr)
        if mw:  # el tramo real: meseta horizontal en lugar de la ondulación
            Pr, vl, vg = mw
            ax.curve([(vl, Pr), (vg, Pr)], col, 2.6)

    cx, cy = ax.px(1.0), ax.py(1.0)
    cv.circle(cx, cy, 4.5, RED)
    cv.text(cx + 10, cy - 9, "punto crítico  (V̄_c , P_c , T_c)", 10.5, RED,
            "start", "600")

    cv.legend(ax.px(4.6) - 112, ax.py(2.0) + 4,
              [(c, f"T_r = {t:.2f}") for t, c in isos])

    # anotaciones sobre la isoterma subcrítica más baja
    Pr, vl, vg = maxwell(0.85)
    cv.text(ax.px((vl + vg) / 2), ax.py(Pr) + 20, "L + V", 10.5, MUTED)
    cv.text(ax.px(1.52), ax.py(1.72), "líquido", 10, MUTED, "middle")
    cv.add(f'<path d="M {ax.px(1.35)} {ax.py(1.70)} L {ax.px(0.60)} '
           f'{ax.py(1.34)}" stroke="{DIM}" stroke-width="1" fill="none" '
           f'stroke-dasharray="3 3" marker-end="url(#ah)"/>')
    cv.text(ax.px(3.2), ax.py(1.62), "gas", 10, MUTED, "middle")
    lx, ly = ax.px(3.55), ax.py(0.24)
    cv.text(lx, ly, "meseta de condensación:", 10, TEXT, "start", "600")
    cv.text(lx, ly + 14, "las dos áreas que corta", 10, MUTED, "start")
    cv.text(lx, ly + 27, "la recta son iguales", 10, MUTED, "start")
    cv.add(f'<path d="M {lx - 6} {ly - 4} L {ax.px(2.62)} {ax.py(Pr) + 7}" '
           f'stroke="{DIM}" stroke-width="1" fill="none" '
           f'stroke-dasharray="3 3" marker-end="url(#ah)"/>')

    cv.text(360, 396, "Isotermas de Van der Waals en variables reducidas. "
            "Bajo la campana el tramo punteado tiene (∂P/∂V̄)_T &gt; 0 y es "
            "mecánicamente", 10.5, DIM)
    cv.text(360, 412, "imposible: la naturaleza lo reemplaza por la meseta "
            "horizontal a la que el líquido y el vapor coexisten.", 10.5, DIM)
    cv.save(os.path.join(BASE, "clase_3", "fig_clase_3_isotermas.svg"))


def fig_generalizado():
    """Clase 3 — diagrama generalizado de compresibilidad."""
    cv = Canvas(720, 392)
    ax = Axes(cv, 62, 36, 570, 282, (0, 7), (0, 1.3))
    ax.frame("P_r = P/P_c", "Z", xlab_dx=-6)

    for y in (0.2, 0.4, 0.6, 0.8, 1.0, 1.2):
        cv.line(ax.px(0), ax.py(y), ax.px(7), ax.py(y), GRID, 1,
                dash=None if y == 1.0 else "3 4")
        cv.text(ax.px(0) - 10, ax.py(y) + 4, f"{y:.1f}", 10, DIM, "end")
    for x in range(1, 8):
        cv.line(ax.px(x), ax.py(0), ax.px(x), ax.py(0) + 5, DIM, 1)
        cv.text(ax.px(x), ax.py(0) + 19, str(x), 10, DIM)

    trs = ((1.0, U1), (1.2, BLUE), (1.5, PURPLE), (2.0, U2), (3.0, U3))
    for Tr, col in trs:
        pts = [(0.0, 1.0)]
        for i in range(1, 351):
            Pr = i * 0.02
            Vr = vdw_reduced_Vr(Pr, Tr)
            if Vr:
                pts.append((Pr, 0.375 * Pr * Vr / Tr))
        ax.curve(ax.clip(pts), col, 1.9)

    cv.legend(ax.px(4.55), ax.py(0.62), [(c, f"T_r = {t:g}") for t, c in trs])

    cv.circle(ax.px(1.0), ax.py(0.375), 4, RED)
    cv.text(ax.px(1.0) - 12, ax.py(0.375) + 16, "Z_c = 3/8", 10.5, RED, "end",
            "600")

    cv.text(360, 358, "Con coordenadas reducidas todos los gases caen sobre "
            "las mismas curvas: eso es la ley de los estados correspondientes.",
            10.5, DIM)
    cv.text(360, 374, "Van der Waals predice Z_c = 0,375 y los gases reales "
            "están entre 0,27 y 0,29, así que las cartas de uso práctico son "
            "empíricas.", 10.5, DIM)
    cv.save(os.path.join(BASE, "clase_3", "fig_clase_3_generalizado.svg"))


def fig_termometria():
    """Clase 4 — termómetro de gas a volumen constante y el cero absoluto."""
    cv = Canvas(720, 372)
    ax = Axes(cv, 76, 40, 545, 258, (-300, 130), (0, 1.3))
    ax.frame("t / °C", "P")

    for x in (-273.15, -200, -100, 0, 100):
        cv.line(ax.px(x), ax.py(0), ax.px(x), ax.py(0) + 5, DIM, 1)
        cv.text(ax.px(x), ax.py(0) + 19,
                "−273,15" if x < -273 else f"{int(x)}", 10, DIM)

    for P0, col, lab in ((0.95, U1, "gas A"), (0.68, BLUE, "gas B"),
                         (0.42, PURPLE, "gas C")):
        f = lambda t: P0 * (1 + t / 273.15)
        ax.curve([(t, f(t)) for t in (-273.15, -40)], col, 1.7, dash="4 4")
        ax.curve([(t, f(t)) for t in (-40, 130)], col, 2.2)
        cv.text(ax.px(130) + 7, ax.py(f(130)) + 4, lab, 10.5, col, "start",
                "600")

    cv.line(ax.px(-273.15), ax.py(0), ax.px(-273.15), ax.py(1.22), RED, 1.2,
            dash="4 4")
    cv.circle(ax.px(-273.15), ax.py(0), 4.5, RED)
    cv.text(ax.px(-273.15) + 12, ax.py(1.22), "cero absoluto", 10.5, RED,
            "start", "600")
    cv.text(ax.px(-273.15) + 12, ax.py(1.22) + 15,
            "las tres rectas concurren aquí,", 10, MUTED, "start")
    cv.text(ax.px(-273.15) + 12, ax.py(1.22) + 28,
            "sea cual sea el gas y cuánto se cargue", 10, MUTED, "start")

    cv.text(ax.px(55), ax.py(0.14), "zona realmente medida", 10, MUTED)
    cv.text(ax.px(-175), ax.py(0.06), "extrapolación", 10, MUTED)

    cv.text(360, 344, "Termómetro de gas a volumen constante: la propiedad "
            "termométrica es P. Que el intercepto sea universal es lo que "
            "permite", 10.5, DIM)
    cv.text(360, 360, "definir una escala absoluta de temperatura sin "
            "referirse a ninguna sustancia en particular.", 10.5, DIM)
    cv.save(os.path.join(BASE, "clase_4", "fig_clase_4_termometria.svg"))


def fig_trabajo():
    """Clase 4 — trabajo de expansión en 1, 3 y muchas etapas."""
    cv = Canvas(900, 322)
    V1, V2, K = 1.0, 4.0, 3.0
    pw, gap, x0 = 236, 48, 48
    iso = lambda v: K / v

    def panel(xoff, n, title):
        ax = Axes(cv, xoff, 50, pw, 192, (0, 4.9), (0, 3.6))
        ax.frame("V", "P", title)
        edges = [V1 + (V2 - V1) * i / n for i in range(n + 1)]
        for i in range(n):
            va, vb = edges[i], edges[i + 1]
            Pop = iso(vb)   # se expande contra la presión final de cada etapa
            ax.area([(va, 0), (va, Pop), (vb, Pop), (vb, 0)], U3, 0.3)
            cv.rect(ax.px(va), ax.py(Pop), ax.px(vb) - ax.px(va),
                    ax.py(0) - ax.py(Pop), "none", U3, 1.1)
        ax.curve(ax.clip([(0.55 + i * 0.011, iso(0.55 + i * 0.011))
                          for i in range(400)]), U1, 2.0)
        for v in (V1, V2):
            cv.line(ax.px(v), ax.py(0), ax.px(v), ax.py(iso(v)), DIM, 1,
                    dash="3 3")
        cv.text(ax.px(V1), ax.py(0) + 18, "V_1", 10.5, MUTED)
        cv.text(ax.px(V2), ax.py(0) + 18, "V_2", 10.5, MUTED)
        return ax

    ax = panel(x0, 1, "(a) Una sola etapa")
    cv.text(ax.px(2.5), ax.py(0.40), "W = P_{op} ΔV", 10.5, U3, "middle", "600")
    ax = panel(x0 + pw + gap, 3, "(b) Tres etapas")
    cv.text(ax.px(3.1), ax.py(1.9), "más área", 10.5, U3, "middle", "600")
    ax = panel(x0 + 2 * (pw + gap), 26, "(c) Cuasiestático (n → ∞)")
    cv.text(ax.px(3.0), ax.py(2.5), "W_{máx} = ∫P dV", 10.5, U3, "middle", "600")

    cv.text(450, 296, "El área sombreada es el trabajo producido. Cuantas más "
            "etapas, más se pega la escalera a la isoterma: el trabajo máximo "
            "es el del límite reversible.", 10.5, DIM)
    cv.save(os.path.join(BASE, "clase_4", "fig_clase_4_trabajo.svg"))


def fig_adiabatica():
    """Clase 6 — adiabática reversible frente a isoterma."""
    cv = Canvas(720, 398)
    gamma, P1, Va, Vb = 1.4, 3.0, 1.0, 3.6
    ax = Axes(cv, 66, 42, 560, 275, (0, 4.6), (0, 3.9))
    ax.frame("V̄", "P")

    iso = lambda v: P1 * Va / v
    adi = lambda v: P1 * Va**gamma / v**gamma
    span = [Va + (Vb - Va) * i / 80 for i in range(81)]

    ax.area([(Va, 0)] + [(v, iso(v)) for v in span] + [(Vb, 0)], U1, 0.13)
    ax.area([(Va, 0)] + [(v, adi(v)) for v in span] + [(Vb, 0)], U3, 0.22)
    ax.curve(ax.clip([(0.75 + i * 0.008, iso(0.75 + i * 0.008))
                      for i in range(500)]), U1, 2.1)
    ax.curve(ax.clip([(0.75 + i * 0.008, adi(0.75 + i * 0.008))
                      for i in range(500)]), U3, 2.1)

    cv.circle(ax.px(Va), ax.py(P1), 4.5, TEXT)
    cv.text(ax.px(Va) - 9, ax.py(P1) - 9, "1", 11.5, TEXT, "end", "600")
    cv.circle(ax.px(Vb), ax.py(iso(Vb)), 4, U1)
    cv.text(ax.px(Vb) + 9, ax.py(iso(Vb)) - 8, "2 (isot.)", 10, U1, "start")
    cv.circle(ax.px(Vb), ax.py(adi(Vb)), 4, U3)
    cv.text(ax.px(Vb) + 9, ax.py(adi(Vb)) + 15, "2 (adiab.)", 10, U3, "start")

    cv.text(ax.px(3.35), ax.py(iso(3.35)) - 13, "isoterma   PV̄ = cte.", 11, U1,
            "middle", "600")
    cv.text(ax.px(2.15), ax.py(adi(2.15)) + 22, "adiabática   PV̄^{γ} = cte.",
            11, U3, "middle", "600")

    cv.line(ax.px(Vb), ax.py(0), ax.px(Vb), ax.py(iso(Vb)), DIM, 1, dash="3 3")
    cv.text(ax.px(Va), ax.py(0) + 18, "V̄_1", 10.5, MUTED)
    cv.text(ax.px(Vb), ax.py(0) + 18, "V̄_2", 10.5, MUTED)
    cv.text(ax.px(2.2), ax.py(0.28), "W_{adiab} &lt; W_{isot}", 10.5, MUTED)

    cv.text(360, 364, "Como γ = C̄_P/C̄_V &gt; 1, la adiabática cae más rápido "
            "que la isoterma. Al expandirse sin recibir calor el gas paga el "
            "trabajo con su", 10.5, DIM)
    cv.text(360, 380, "propia energía interna y se enfría (T_2 &lt; T_1); por "
            "eso el área bajo la adiabática — el trabajo — es menor.", 10.5, DIM)
    cv.save(os.path.join(BASE, "clase_6", "fig_clase_6_adiabatica.svg"))


def fig_kirchhoff():
    """Clase 8 — el ciclo termodinámico detrás de la ecuación de Kirchhoff."""
    cv = Canvas(720, 366)
    bw, bh = 176, 52
    xl, xr, yt, yb = 92, 452, 58, 226

    def box(x, y, title, sub):
        cv.rect(x, y, bw, bh, "#1c2128", U4, 1.6, rx=6)
        cv.text(x + bw / 2, y + 22, title, 12, TEXT, "middle", "600")
        cv.text(x + bw / 2, y + 39, sub, 10.5, MUTED)

    box(xl, yt, "Reactivos", "a T_1")
    box(xr, yt, "Productos", "a T_1")
    box(xl, yb, "Reactivos", "a T_2")
    box(xr, yb, "Productos", "a T_2")

    def arrow(x1, y1, x2, y2):
        cv.add(f'<path d="M {x1} {y1} L {x2} {y2}" stroke="{MUTED}" '
               f'stroke-width="1.7" fill="none" marker-end="url(#ahl)"/>')

    arrow(xl + bw + 10, yt + bh / 2, xr - 10, yt + bh / 2)
    cv.text((xl + bw + xr) / 2, yt + bh / 2 - 11, "ΔH_1", 12.5, U1, "middle",
            "600")
    cv.text((xl + bw + xr) / 2, yt + bh / 2 + 21, "conocida (tablas a 298 K)",
            10, DIM)

    arrow(xl + bw + 10, yb + bh / 2, xr - 10, yb + bh / 2)
    cv.text((xl + bw + xr) / 2, yb + bh / 2 - 11, "ΔH_2", 12.5, U2, "middle",
            "600")
    cv.text((xl + bw + xr) / 2, yb + bh / 2 + 21, "la que se busca", 10, DIM)

    arrow(xl + bw / 2, yb - 10, xl + bw / 2, yt + bh + 10)
    cv.text(xl + bw / 2 - 12, (yt + bh + yb) / 2 - 2, "calentar reactivos", 10,
            MUTED, "end")
    cv.text(xl + bw / 2 - 12, (yt + bh + yb) / 2 + 12, "∫C_P(reac) dT", 10,
            MUTED, "end")
    arrow(xr + bw / 2, yt + bh + 10, xr + bw / 2, yb - 10)
    cv.text(xr + bw / 2 + 12, (yt + bh + yb) / 2 - 2, "calentar productos", 10,
            MUTED, "start")
    cv.text(xr + bw / 2 + 12, (yt + bh + yb) / 2 + 12, "∫C_P(prod) dT", 10,
            MUTED, "start")

    cv.rect(76, 292, 568, 52, "#22272e", GRID, 1, rx=6)
    cv.text(360, 313, "H es función de estado: ir por arriba o por abajo debe "
            "dar lo mismo. Igualando ambos caminos,", 10.5, MUTED)
    cv.text(360, 333, "ΔH_2 = ΔH_1 + ∫ ΔC_P° dT ,   con   ΔC_P° = "
            "ΣC_P(productos) − ΣC_P(reactivos)", 12, TEXT, "middle", "600")
    cv.save(os.path.join(BASE, "clase_8", "fig_clase_8_kirchhoff.svg"))


if __name__ == "__main__":
    print("Generando diagramas…")
    fig_gas_ideal()
    fig_compresibilidad()
    fig_isotermas_reales()
    fig_generalizado()
    fig_termometria()
    fig_trabajo()
    fig_adiabatica()
    fig_kirchhoff()
    print("Listo.")
