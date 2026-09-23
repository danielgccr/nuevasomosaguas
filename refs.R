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

# The same bullets, exported as BibTeX. Everything is read off the line, so the
# download cannot drift from the page. Works under "Frontera empírica" are
# articles, whose trailing "Journal 78(6)" splits into journal, volume, number.
escribe_bib <- function(path = "biblioteca.bib") {
  ficha <- paste0("^\\* \\*\\*(.+?)\\*\\* (?:\\((Eds?)\\.\\) )?\\(([0-9/]+)\\)\\. ",
                  "\\*(.+?)\\*\\.? ?(?:\\(([^)]+)\\)\\. )?(.*?)\\.? `\\[")
  seccion <- cumsum(grepl("^## ", biblio))
  frontera <- seccion == seccion[grep("^## Frontera", biblio)]
  obras <- grepl(ficha, biblio, perl = TRUE)
  stopifnot(sum(obras) == n_obras)

  m <- regmatches(biblio[obras], regexec(ficha, biblio[obras], perl = TRUE))
  esc <- function(s) gsub("([&%$#_])", "\\\\\\1", s)
  entradas <- mapply(function(m, articulo) {
    autores <- sub(" et al\\.$", "", m[2])
    nombres <- paste(strsplit(autores, "\\s*[;&]\\s*")[[1]], collapse = " and ")
    if (autores != m[2]) nombres <- paste(nombres, "and others")
    anios <- strsplit(m[4], "/")[[1]]
    parentesis <- m[6]
    campos <- c(
      if (m[3] == "") c(author = nombres) else c(editor = nombres),
      title = m[5],
      if (articulo) {
        j <- regmatches(m[7], regexec("^(.*?) ([0-9]+)(?:\\(([0-9]+)\\))?$", m[7]))[[1]]
        if (length(j)) c(journal = j[2], volume = j[3], number = if (j[4] != "") j[4])
        else c(journal = m[7])
      } else c(publisher = m[7]),
      if (grepl(" Edition$", parentesis)) c(edition = sub(" Edition$", "", parentesis))
      else if (parentesis != "") c(note = parentesis),
      year = anios[length(anios)],
      if (length(anios) > 1) c(origdate = anios[1])
    )
    apellido <- sub(",.*", "", strsplit(autores, "\\s*[;&]\\s*")[[1]][1])
    palabra <- setdiff(strsplit(tolower(m[5]), "[^[:alnum:]_]+")[[1]],
                       c("", "the", "a", "an", "on", "in"))[1]
    clave <- tolower(gsub("[^[:alnum:]]", "",
                          iconv(paste0(apellido, campos[["year"]], palabra), "UTF-8", "ASCII//TRANSLIT")))
    c(tipo = if (articulo) "article" else "book", clave = clave,
      cuerpo = paste(sprintf("  %-9s = {%s}", names(campos), esc(campos)), collapse = ",\n"))
  }, m, frontera[obras])

  claves <- make.unique(entradas["clave", ], sep = "")
  writeLines(sprintf("@%s{%s,\n%s\n}\n", entradas["tipo", ], claves, entradas["cuerpo", ]),
             path, useBytes = TRUE)
}
