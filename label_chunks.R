args <- commandArgs(trailingOnly = TRUE)
if (length(args) < 2) {
  stop('Usage: Rscript label_chunks.R <path> <prefix> [start_index]')
}
path <- args[[1]]
prefix <- args[[2]]
start_idx <- if (length(args) >= 3) as.integer(args[[3]]) else 1L
lines <- readLines(path)
new_lines <- character()
chunk_idx <- start_idx
n <- length(lines)
tick <- intToUtf8(96L)
chunk_start_pattern <- paste0('^', strrep(tick, 3), '\\{')
for (i in seq_len(n)) {
  line <- lines[[i]]
  new_lines <- c(new_lines, line)
  if (grepl(chunk_start_pattern, line)) {
    label_already <- i < n && grepl('^#\\| label:', trimws(lines[[i + 1]]))
    if (!label_already) {
      new_lines <- c(new_lines, sprintf('#| label: %s-%02d', prefix, chunk_idx))
    }
    chunk_idx <- chunk_idx + 1L
  }
}
writeLines(new_lines, path)
