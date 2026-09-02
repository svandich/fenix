# Lógica de Diseño

## Propósito

Este sitio es un apunte de estudio estructurado, no un textbook ni una app. El diseño prioriza la legibilidad larga y la orientación espacial: el lector siempre sabe dónde está en el curso y puede saltar a cualquier auxiliar sin perder contexto.

---

## Decisiones de diseño

### Dark mode
Se eligió dark mode por tres razones prácticas:
1. Los apuntes se leen de noche antes de controles.
2. Reduce la fatiga visual al leer texto con fórmulas densas.
3. El contraste de colores de acento (cian, verde) es más legible sobre fondos oscuros que sobre blancos.

La paleta sigue GitHub dark (`#0d1117`, `#161b22`, etc.) porque es un estándar conocido, probado en pantallas de distintas calidades.

### Sidebar fija
La sidebar resuelve el problema de orientación: en un curso con 16 auxiliares, el lector necesita saber siempre qué auxiliar está leyendo y cuánto falta. La sidebar fija (sin scroll propio de página) cumple esa función sin interrumpir la lectura del contenido.

La jerarquía en la sidebar es: sección (unidad) → auxiliar numerado. El dot de color conecta visualmente el auxiliar con su unidad temática.

### Una página por auxiliar
Se eligió una página por auxiliar (vs. todo en una sola página) porque:
- Los auxiliares son unidades de estudio independientes (se pueden estudiar en sesiones separadas).
- Permite compartir links directos a una explicación específica.
- El tiempo de carga es más rápido por página (importante en celular con MathJax).

### Color por unidad temática
Los colores codifican la estructura conceptual del curso. En `electro/`:
- Los colores "fríos" (cian, verde) para las unidades fundacionales (campo, potencial).
- Los colores "cálidos" (amarillo, naranja) para los temas intermedios (dipolos, dieléctricos).
- El violeta para los temas finales (corrientes, circuitos).

Esta progresión no es arbitraria: refleja el arco pedagógico del curso, de la electrostática estática a la corriente.

Los cursos posteriores reutilizan las mismas variables CSS reasignando su significado, en vez de
agregar colores nuevos por curso. Así la paleta del sitio se mantiene acotada y el CSS compartido no
crece con cada curso que se suma.

### Estructura interna de cada página
Cada página sigue el mismo esquema:
1. **Temas que cubre** — para decidir si esta es la página que necesita el lector.
2. **Conceptos clave** — explicación intuitiva en prosa, sin fórmulas todavía.
3. **Fórmulas fundamentales** — notación formal, con descripción de variables.
4. **Qué hay que entender** — estrategia práctica, lo que pide el control.
5. **Quiz de repaso** — autoevaluación con explicación al responder.

Esta secuencia va de lo abstracto a lo concreto, reproduciendo el flujo natural de estudio: primero entender qué hay que saber, luego la intuición, luego el formalismo, luego cómo aplicarlo, y por último verificar que quedó.

### Páginas de auxiliar con problemas
En `termoquimica/` los auxiliares son pautas de ejercicios, no clases expositivas, así que su página
altera el esquema: "conceptos clave" pasa a ser **herramientas** (qué hay que tener a mano para
resolver) y se agrega una sección de **problemas**, cada uno con su enunciado resumido y una
**estrategia** paso a paso.

La estrategia llega hasta el planteamiento y el método, sin ejecutar la aritmética ni entregar el
resultado numérico. La razón es doble: el valor de estudio está en reconocer qué herramienta aplica,
no en copiar un número; y un resultado numérico equivocado en un apunte hace más daño que no tenerlo,
porque el lector no tiene cómo detectarlo.

### Convenios de signo distintos entre cursos
`termo/` (física) usa `dU = δQ + δW` y `termoquimica/` (química) usa `dU = δQ − δW`. Se decidió
**no** unificarlos: cada página respeta el convenio de su cátedra, porque el lector va a rendir el
control de esa cátedra. Donde el solapamiento puede confundir, la página lo señala explícitamente
en la sección de tips.

### Tipografía local
Las fuentes (Inter y JetBrains Mono) se sirven localmente para:
- Funcionar offline (útil para estudiar sin internet).
- Evitar dependencias de terceros que puedan fallar o cambiar.
- El único CDN externo que se mantiene es MathJax, porque compilar LaTeX localmente sería impracticable.

### Fórmulas: Typst para display, MathJax para inline
Las fórmulas de bloque se compilan con Typst a SVG y se sirven como imágenes estáticas: se ven
idénticas siempre, no dependen de que cargue un CDN, y no producen el salto de layout que causa
MathJax al reemplazar el texto crudo.

MathJax se mantiene sólo para el math inline (`$...$`) dentro de la prosa, donde el costo de generar
un SVG por cada símbolo suelto no se justifica. Requiere internet, pero si falla sólo se degrada a
notación LaTeX legible en medio de una frase, no rompe la página.

---

## Qué no se hizo y por qué

- **Casi no hay JavaScript propio**: la sidebar activa se marca con la clase `active` directamente en el HTML. Requiere copiar el bloque de sidebar en cada página, pero evita cargar JS innecesario y simplifica el debug. La única excepción es `styles/quiz.js`, que corrige los quizzes; sin él la página sigue siendo legible.
- **No hay framework CSS**: usar vanilla CSS con variables permite entender y modificar cualquier parte sin documentación externa.
- **No hay build step para el HTML**: los HTML son estáticos y se abren directamente con el navegador. No hay npm ni webpack. El único paso de compilación es `./build.sh`, que convierte los `.typ` en SVG; su salida está trackeada en git, así que el sitio funciona sin ejecutarlo.
