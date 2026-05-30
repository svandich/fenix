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
Los 5 colores codifican la estructura conceptual del curso:
- Los colores "fríos" (cian, verde) para las unidades fundacionales (campo, potencial).
- Los colores "cálidos" (amarillo, naranja) para los temas intermedios (dipolos, dieléctricos).
- El violeta para los temas finales (corrientes, circuitos).

Esta progresión no es arbitraria: refleja el arco pedagógico del curso, de la electrostática estática a la corriente.

### Estructura interna de cada auxiliar
Cada página sigue el mismo esquema en 4 secciones:
1. **Temas que cubre** — para decidir si esta es la página que necesita el lector.
2. **Conceptos clave** — explicación intuitiva en prosa, sin fórmulas todavía.
3. **Fórmulas fundamentales** — notación formal, con descripción de variables.
4. **Qué hay que entender** — estrategia práctica, lo que pide el control.

Esta secuencia va de lo abstracto a lo concreto, reproduciendo el flujo natural de estudio: primero entender qué hay que saber, luego la intuición, luego el formalismo, luego cómo aplicarlo.

### Tipografía local
Las fuentes (Inter y JetBrains Mono) se sirven localmente para:
- Funcionar offline (útil para estudiar sin internet).
- Evitar dependencias de terceros que puedan fallar o cambiar.
- El único CDN externo que se mantiene es MathJax, porque compilar LaTeX localmente sería impracticable.

### Fórmulas con MathJax
MathJax permite usar la misma notación LaTeX que los auxiliares originales. Esto reduce el error de transcripción y hace el contenido verificable contra los PDFs fuente.

---

## Qué no se hizo y por qué

- **No hay JavaScript propio**: la sidebar activa se marca con la clase `active` directamente en el HTML. Requiere copiar el bloque de sidebar en cada página, pero evita cargar JS innecesario y simplifica el debug.
- **No hay framework CSS**: usar vanilla CSS con variables permite entender y modificar cualquier parte sin documentación externa.
- **No hay build step**: los HTML son estáticos y se abren directamente con el navegador. No hay npm, webpack ni proceso de compilación.
