# Single source of truth for the library: biblioteca.bib. The page lists, the
# counts quoted across the site and both downloads are all read from it.

# The file is kept to one field per line, so a line reader is enough; any line
# inside an entry that is not a field stops the render instead of being lost.
lee_bib <- function(path = "biblioteca.bib") {
  lineas <- readLines(path, encoding = "UTF-8", warn = FALSE)
  obras <- list()
  actual <- NULL
  for (l in lineas) {
    if (grepl("^@\\w+\\{", l)) {
      m <- regmatches(l, regexec("^@(\\w+)\\{([^,]+),$", l))[[1]]
      stopifnot(length(m) == 3)
      actual <- c(tipo = m[2], clave = m[3])
    } else if (!is.null(actual)) {
      if (l == "}") {
        obras[[actual[["clave"]]]] <- actual
        actual <- NULL
      } else {
        m <- regmatches(l, regexec("^  ([a-z]+) *= \\{(.*)\\},?$", l))[[1]]
        if (length(m) != 3) stop("biblioteca.bib: línea ilegible: ", l)
        actual[[m[2]]] <- m[3]
      }
    }
  }
  obras
}

obras <- lee_bib()
stopifnot(!anyDuplicated(names(obras)), all(vapply(obras, function(o) "estrato" %in% names(o), NA)))
n_obras <- length(obras)

# The corpus is ordered by causal function, in ascending strata.
n_estratos <- length(grep("^## Estrato ", readLines("biblioteca.qmd", warn = FALSE)))

# Prose spells out small counts; fall back to the numeral beyond ten.
estratos_txt <- if (n_estratos <= 10) {
  c("uno", "dos", "tres", "cuatro", "cinco", "seis",
    "siete", "ocho", "nueve", "diez")[n_estratos]
} else as.character(n_estratos)

stopifnot(n_obras > 0, n_estratos > 0)

# One work as the page shows it: authors, year, title, imprint, the level tag
# and, for the works that carry one, the three-field record.
ficha <- function(o) {
  campo <- function(k) if (k %in% names(o)) o[[k]] else ""
  llano <- function(s) gsub("\\\\([&%$#_])", "\\1", gsub("[{}]", "", s))
  personas <- strsplit(llano(if (campo("author") != "") o[["author"]] else o[["editor"]]), " and ")[[1]]
  et_al <- personas[length(personas)] == "others"
  personas <- personas[personas != "others"]
  n <- length(personas)
  nombres <- if (n == 1) personas else paste0(paste(personas[-n], collapse = "; "), " & ", personas[n])
  if (et_al) nombres <- paste(nombres, "et al.")
  nombres <- paste0("**", nombres, "**",
                    if (campo("editor") != "") if (n > 1 || et_al) " (Eds.)" else " (Ed.)")
  titulo <- llano(o[["title"]])
  parentesis <- if (campo("edition") != "") paste(o[["edition"]], "Edition") else llano(campo("note"))
  pie <- if (o[["tipo"]] == "article") {
    paste0(llano(o[["journal"]]),
           if (campo("volume") != "") paste0(" ", o[["volume"]]),
           if (campo("number") != "") paste0("(", o[["number"]], ")"))
  } else llano(o[["publisher"]])
  # The DOI resolves to the work itself; the ISBN, to the libraries that hold it.
  enlace <- if (campo("doi") != "") {
    sprintf(". [doi:%s](https://doi.org/%s)", o[["doi"]], o[["doi"]])
  } else if (campo("isbn") != "") {
    sprintf(". [ISBN %s](https://search.worldcat.org/isbn/%s)", o[["isbn"]], o[["isbn"]])
  } else ""
  linea <- sprintf("* %s (%s). *%s*%s%s%s%s. `[Nivel %s | %s]`",
                   nombres,
                   paste(c(if (campo("origdate") != "") o[["origdate"]], o[["year"]]), collapse = "/"),
                   titulo,
                   if (parentesis != "") paste0(" (", parentesis, ")") else "",
                   if (parentesis == "" && grepl("[?!]$", titulo)) " " else ". ",
                   pie, enlace, o[["nivel"]], o[["descriptor"]])
  rotulos <- c(mecanismo = "Mecanismo", aparato = "Aparato formal", funcion = "Función en el RAG")
  presentes <- intersect(names(rotulos), names(o))
  c(linea, sprintf("  * *%s:* %s", rotulos[presentes], unlist(o[presentes])))
}

# The list for one stratum, in file order, for a `results: asis` chunk.
lista <- function(estrato) {
  cat(unlist(lapply(Filter(function(o) o[["estrato"]] == estrato, obras), ficha)), sep = "\n")
}
