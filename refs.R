# Single source of truth for the size and shape of the library.
biblio <- readLines("biblioteca.qmd", warn = FALSE)

# A catalogued work is a bullet whose bolded author is followed by a year in
# parentheses. The year is what separates a reference from any other bold
# bullet on the page.
n_obras <- length(grep("^\\* \\*\\*.*\\([0-9]{4}", biblio))

# The corpus is ordered by causal function, in ascending strata.
n_estratos <- length(grep("^## Estrato ", biblio))

# Prose spells out small counts; fall back to the numeral beyond ten.
estratos_txt <- if (n_estratos <= 10) {
  c("uno", "dos", "tres", "cuatro", "cinco", "seis",
    "siete", "ocho", "nueve", "diez")[n_estratos]
} else as.character(n_estratos)

stopifnot(n_obras > 0, n_estratos > 0)
