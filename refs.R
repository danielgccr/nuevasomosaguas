# Single source of truth for the size and shape of the library.
biblio <- readLines("biblioteca.qmd", warn = FALSE)

# Every reference is a bullet whose first field is the bolded author.
n_obras <- length(grep("^\\* \\*\\*", biblio))

# Every domain is a numbered level-2 heading.
n_dominios <- length(grep("^## [0-9]+\\.", biblio))

# Prose spells out small counts; fall back to the numeral beyond ten.
dominios_txt <- if (n_dominios <= 10) {
  c("uno", "dos", "tres", "cuatro", "cinco", "seis",
    "siete", "ocho", "nueve", "diez")[n_dominios]
} else as.character(n_dominios)

stopifnot(n_obras > 0, n_dominios > 0)
