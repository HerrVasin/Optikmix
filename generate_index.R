# generate_index.R
# Usage: source("generate_index.R") in R / RStudio, or run `Rscript generate_index.R`
#
# This will create (or overwrite) "index.qmd" in the project root.
# After running this, render with:
#   quarto render index.qmd --output-dir docs
# or from R:
#   quarto::quarto_render("index.qmd", output_dir = "docs")

# --- config ---------------------------------------------------------------
docs_dir <- "docs"           # where your html files live
out_qmd  <- "index.qmd"      # file created (project root)

# --- find html files -----------------------------------------------------
if (!dir.exists(docs_dir)) {
  stop("docs/ directory not found. Create it or adjust docs_dir at top of script.")
}

html_files <- list.files(docs_dir, pattern = "\\.html$", full.names = FALSE)
html_files <- setdiff(html_files, "index.html")   # exclude index itself

# sort for predictable order (optional)
html_files <- sort(html_files)

# --- build qmd content ---------------------------------------------------
front_matter <- c(
  "---",
  "title: \"My Reports\"",
  "format: html",
  "execute:",
  "  echo: false",
  "---",
  ""
)

body <- c("# My Reports", "")

if (length(html_files) == 0) {
  body <- c(body, "No reports found in `docs/`.")
} else {
  # Create Markdown links; when index.qmd is rendered with --output-dir docs,
  # the generated docs/index.html will be in docs/, so links should be to filename only.
  links <- paste0("- [", tools::file_path_sans_ext(html_files), "](", html_files, ")")
  body <- c(body, links)
}

contents <- c(front_matter, body)

# --- write file ----------------------------------------------------------
writeLines(contents, con = out_qmd)
message("Wrote ", out_qmd, " (", length(html_files), " files found in ", docs_dir, ")")
message("Render with: quarto render index.qmd --output-dir docs")

