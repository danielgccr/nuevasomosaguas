# Nueva Somosaguas

## Grado en ciencias sociales analíticas y cuantitativas

> *«If you didn't grow it, you didn't explain it.»* — Joshua Epstein
>
> *«Every social fact is the aggregate outcome of individual actions, beliefs, and opportunities.»* — Peter Hedström

[![Quarto](https://img.shields.io/badge/Compilado%20con-Quarto-blue.svg)](https://quarto.org/)
[![Stack](https://img.shields.io/badge/Stack-Julia%20%7C%20R%20%7C%20SQL-purple.svg)]()
[![Consiliencia](https://img.shields.io/badge/Epistemolog%C3%ADa-Consiliencia%20de%20E.%20O.%20Wilson-success.svg)]()

**Portal:** [danielgccr.github.io/nuevasomosaguas](https://danielgccr.github.io/nuevasomosaguas/)

---

## Qué es esto

La **Nueva Somosaguas** es una facultad libre de ciencias sociales analíticas y cuantitativas: un plan de estudios completo, abierto y publicado en código, construido sobre el principio de **consiliencia** de E. O. Wilson —la compatibilidad vertical entre las matemáticas, la biología evolutiva, los micro-mecanismos de decisión y la historia cuantitativa de gran escala.

No es un borrador pedagógico. Son **cuatro cursos y 19 asignaturas**, con un texto matriz y un cuaderno reproducible por asignatura, más un bootcamp propedéutico de doce semanas y un itinerario autodidacta con presupuesto de horas declarado.

El criterio de admisión de cualquier contenido es el mismo en todo el sitio: si un modelo no se deriva en la pizarra y no compila en la terminal, no entra.

---

## Los cuatro pilares

1. **Cimientos formales e inferencia rigurosa**
   * Probabilidad axiomática y conjugadas bayesianas (*Harvard Stat 110*, Blitzstein y Hwang).
   * Álgebra lineal matricial y sus descomposiciones: QR, SVD, matrices de Markov (Strang).
   * Cálculo multivariante y optimización con restricciones (Simon y Blume).
   * Inferencia no paramétrica e intervalos BCa por *bootstrap* (Efron y Hastie).

2. **Sustrato biológico y genómica cuantitativa**
   * Genética de la conducta y puntuaciones poligénicas (Plomin; Falconer y Mackay).
   * Paleogenómica y migraciones históricas (Reich).
   * Antropología evolutiva y etología comparada (Boehm, Buss, Tomasello).

3. **Mecanismos micro e interacción estratégica**
   * Sociología analítica DBO: deseos, creencias y oportunidades (Hedström, Elster, Boudon).
   * Identificación causal por grafos acíclicos dirigidos y resultados potenciales (Pearl; Angrist y Pischke; Imbens y Rubin).
   * Teoría de juegos y acción colectiva (Gibbons, Binmore, Olson).

4. **Síntesis generativa y macrohistoria biofísica**
   * Modelos basados en agentes (Joshua Epstein, Schelling, Smaldino, Railsback y Grimm).
   * Cliodinámica y sobreproducción de élites (Turchin y Nefedov).
   * Historia económica cuantitativa y contabilidad biofísica (Smil, Wrigley, Galor, Clark).

---

## Estructura del repositorio

El sitio se compila con **Quarto** y una hoja de estilos propia de inspiración tufteana.

```text
nuevasomosaguas/
├── index.qmd               Portada: los cuatro pilares y el mapa del dominio
├── curriculo.qmd           Plan de estudios: 4 cursos, 19 asignaturas
├── bootcamp.qmd            Bootcamp propedéutico: 3 fases, 12 semanas
├── guia_autodidacta.qmd    Itinerario en solitario: 4 hitos con gates de validación
├── laboratorios.qmd        Cinco laboratorios ejecutables en Julia y SQL
├── politica_ia.qmd         Política de inteligencia artificial: los cuatro principios
├── manual_bolsillo.qmd     Diez reglas para el debate cotidiano
├── biblioteca.qmd          141 obras en 4 estratos causales y una frontera de artículos
├── faq.qmd                 Preguntas frecuentes
├── about.qmd               Declaración institucional
├── refs.R                  Recuento único de la biblioteca, leído por las páginas
├── _quarto.yml             Configuración del sitio, menú e idioma
├── styles.css              Estilos: tipografía, medida de 80ch y ajustes de Mermaid
└── .github/workflows/      Compilación y publicación en GitHub Pages
```

El recuento de obras no se escribe a mano en ningún sitio: `refs.R` lo deriva de `biblioteca.qmd` y las páginas que lo citan lo leen de ahí.

---

## Entorno computacional

Un solo entorno nuclear, para no pagar el coste de aprender dos ecosistemas a la vez:

* **Julia** — cálculo matricial, simulación basada en agentes, ecuaciones diferenciales y optimización. Es el lenguaje vehicular desde el primer curso.
* **R** — econometría aplicada tabular, bioestadística y psicometría. Herramienta de biblioteca, no entorno general.
* **SQL** — extracción relacional pura, funciones de ventana y agregación censal en PostgreSQL o SQLite.
* **Bash, Git y Quarto o Typst** — consola de Unix, canalizaciones reproducibles y publicación determinista.

Python se conserva como herramienta auxiliar de ingesta y manipulación de datos tabulares.

---

## Política de inteligencia artificial

La IA no se prohíbe ni se padece: se gobierna. Cuatro principios, desarrollados en `politica_ia.qmd`:

* **Principio socrático.** El modelo actúa como interlocutor dialéctico, no resuelve ejercicios ni redacta memorandos evaluables.
* **Asimetría epistemológica.** Los modelos de lenguaje manejan asociaciones, no estructuras generativas: tienen prohibido decidir la identificación causal.
* **Trazabilidad.** Toda función de origen algorítmico entra con la traza del *prompt*, la semilla declarada y una prueba de regresión escrita por el estudiante.
* **Prueba de la pizarra.** Los exámenes son a terminal abierta, con la IA asumida; ninguna calificación es firme hasta defenderla a mano alzada.

---

## Compilación local

```bash
git clone https://github.com/danielgccr/nuevasomosaguas.git
cd nuevasomosaguas
quarto render     # compila el sitio en _site/
quarto preview    # servidor local con recarga automática
```

Hace falta [Quarto](https://quarto.org/) y una instalación de R con `knitr` y `rmarkdown`: tres páginas evalúan fragmentos de R para leer el recuento de la biblioteca.

Cada empuje a `master` compila y publica en GitHub Pages mediante el flujo de trabajo de `.github/workflows/`.

---

## Autoría

Diseño y dirección pedagógica de un científico de datos e investigador independiente. Las correcciones, refutaciones y erratas metodológicas se agradecen en el propio repositorio.
