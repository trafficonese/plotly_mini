#' Initiate a plotly visualization
#'
#' This function maps R objects to [plotly.js](https://plot.ly/javascript/),
#' an (MIT licensed) web-based interactive charting library. It provides 
#' abstractions for doing common things (e.g. mapping data values to 
#' fill colors (via `color`) or creating [animation]s (via `frame`)) and sets
#' some different defaults to make the interface feel more 'R-like' 
#' (i.e., closer to [plot()] and [ggplot2::qplot()]). 
#'
#' @details Unless `type` is specified, this function just initiates a plotly 
#' object with 'global' attributes that are passed onto downstream uses of
#' [add_trace()] (or similar). A [formula] must always be used when 
#' referencing column name(s) in `data` (e.g. `plot_ly(mtcars, x = ~wt)`).
#' Formulas are optional when supplying values directly, but they do
#' help inform default axis/scale titles
#' (e.g., `plot_ly(x = mtcars$wt)` vs `plot_ly(x = ~mtcars$wt)`)
#'
#' @param data A data frame (optional) or [crosstalk::SharedData] object.
#' @param ... Arguments (i.e., attributes) passed along to the trace `type`.
#' See [schema()] for a list of acceptable attributes for a given trace `type`
#' (by going to `traces` -> `type` -> `attributes`). Note that attributes
#' provided at this level may override other arguments 
#' (e.g. `plot_ly(x = 1:10, y = 1:10, color = I("red"), marker = list(color = "blue"))`).
#' @param type A character string specifying the trace type (e.g. `"scatter"`, `"bar"`, `"box"`, etc).
#' If specified, it *always* creates a trace, otherwise 
#' @param name Values mapped to the trace's name attribute. Since a trace can 
#' only have one name, this argument acts very much like `split` in that it 
#' creates one trace for every unique value.
#' @param color Values mapped to relevant 'fill-color' attribute(s) 
#' (e.g. [fillcolor](https://plot.ly/r/reference#scatter-fillcolor), 
#' [marker.color](https://plot.ly/r/reference#scatter-marker-color), 
#' [textfont.color](https://plot.ly/r/reference/#scatter-textfont-color), etc.).
#' The mapping from data values to color codes may be controlled using
#' `colors` and `alpha`, or avoided altogether via [I()] (e.g., `color = I("red")`). 
#' Any color understood by [grDevices::col2rgb()] may be used in this way. 
#' @param colors Either a colorbrewer2.org palette name (e.g. "YlOrRd" or "Blues"), 
#' or a vector of colors to interpolate in hexadecimal "#RRGGBB" format, 
#' or a color interpolation function like `colorRamp()`.
#' @param stroke Similar to `color`, but values are mapped to relevant 'stroke-color' attribute(s)
#' (e.g., [marker.line.color](https://plot.ly/r/reference#scatter-marker-line-color)
#'  and [line.color](https://plot.ly/r/reference#scatter-line-color)
#' for filled polygons). If not specified, `stroke` inherits from `color`.
#' @param strokes Similar to `colors`, but controls the `stroke` mapping.
#' @param alpha A number between 0 and 1 specifying the alpha channel applied to `color`.
#' Defaults to 0.5 when mapping to [fillcolor](https://plot.ly/r/reference#scatter-fillcolor) and 1 otherwise.
#' @param alpha_stroke Similar to `alpha`, but applied to `stroke`.
#' @param symbol (Discrete) values mapped to [marker.symbol](https://plot.ly/r/reference#scatter-marker-symbol).
#' The mapping from data values to symbols may be controlled using
#' `symbols`, or avoided altogether via [I()] (e.g., `symbol = I("pentagon")`). 
#' Any [pch] value or [symbol name](https://plot.ly/r/reference#scatter-marker-symbol) may be used in this way.
#' @param symbols A character vector of [pch] values or [symbol names](https://plot.ly/r/reference#scatter-marker-symbol).
#' @param linetype (Discrete) values mapped to [line.dash](https://plot.ly/r/reference#scatter-line-dash).
#' The mapping from data values to symbols may be controlled using
#' `linetypes`, or avoided altogether via [I()] (e.g., `linetype = I("dash")`). 
#' Any `lty` (see [par]) value or [dash name](https://plot.ly/r/reference#scatter-line-dash) may be used in this way.
#' @param linetypes A character vector of `lty` values or [dash names](https://plot.ly/r/reference#scatter-line-dash)
#' @param size (Numeric) values mapped to relevant 'fill-size' attribute(s) 
#' (e.g., [marker.size](https://plot.ly/r/reference#scatter-marker-size), 
#' [textfont.size](https://plot.ly/r/reference#scatter-textfont-size),
#' and [error_x.width](https://plot.ly/r/reference#scatter-error_x-width)).
#' The mapping from data values to symbols may be controlled using
#' `sizes`, or avoided altogether via [I()] (e.g., `size = I(30)`). 
#' @param sizes A numeric vector of length 2 used to scale `size` to pixels.
#' @param span (Numeric) values mapped to relevant 'stroke-size' attribute(s) 
#' (e.g., 
#' [marker.line.width](https://plot.ly/r/reference#scatter-marker-line-width),
#' [line.width](https://plot.ly/r/reference#scatter-line-width) for filled polygons,
#' and [error_x.thickness](https://plot.ly/r/reference#scatter-error_x-thickness))
#' The mapping from data values to symbols may be controlled using
#' `spans`, or avoided altogether via [I()] (e.g., `span = I(30)`). 
#' @param spans A numeric vector of length 2 used to scale `span` to pixels.
#' @param split (Discrete) values used to create multiple traces (one trace per value).
#' @param frame (Discrete) values used to create animation frames.
#' @param width	Width in pixels (optional, defaults to automatic sizing).
#' @param height Height in pixels (optional, defaults to automatic sizing).
#' @param source a character string of length 1. Match the value of this string 
#' with the source argument in [event_data()] to retrieve the 
#' event data corresponding to a specific plot (shiny apps can have multiple plots).
#' @author Carson Sievert
#' @references <https://plotly-book.cpsievert.me/the-plotly-cookbook.html>
#' @seealso \itemize{
#'  \item For initializing a plotly-geo object: [plot_geo()]
#'  \item For initializing a plotly-mapbox object: [plot_mapbox()]
#'  \item For translating a ggplot2 object to a plotly object: [ggplotly()]
#'  \item For modifying any plotly object: [layout()], [add_trace()], [style()]
#'  \item For linked brushing: [highlight()]
#'  \item For arranging multiple plots: [subplot()], [crosstalk::bscols()]
#'  \item For inspecting plotly objects: [plotly_json()]
#'  \item For quick, accurate, and searchable plotly.js reference: [schema()]
#' }
#' @export
plot_ly <- function(data = data.frame(), ..., type = NULL, name,
                    color, colors = NULL, alpha = NULL, 
                    stroke, strokes = NULL, alpha_stroke = 1,
                    size, sizes = c(10, 100), 
                    span, spans = c(1, 20),
                    symbol, symbols = NULL, 
                    linetype, linetypes = NULL,
                    split, frame, 
                    # selectedpoints = NULL,
                    width = NULL, height = NULL, source = "A") {
  
  if (!is.data.frame(data) && !crosstalk::is.SharedData(data)) {
    stop("First argument, `data`, must be a data frame or shared data.", call. = FALSE)
  }
  
  # "native" plotly arguments
  attrs <- list(...)
  
  # warn about old arguments that are no longer supported
  for (i in c("filename", "fileopt", "world_readable")) {
    if (is.null(attrs[[i]])) next
    warning("Ignoring ", i, ". Use `plotly_POST()` if you want to post figures to plotly.")
    attrs[[i]] <- NULL
  }
  if (!is.null(attrs[["group"]])) {
    warning(
      "The group argument has been deprecated. Use `group_by()` or split instead.\n",
      "See `help('plotly_data')` for examples"
    )
    attrs[["group"]] <- NULL
  }
  if (!is.null(attrs[["inherit"]])) {
    warning("The inherit argument has been deprecated.")
    attrs[["inherit"]] <- NULL
  }
  
  # tack on variable mappings
  attrs$name <- if (!missing(name)) name
  attrs$color <- if (!missing(color)) color
  attrs$stroke <- if (!missing(stroke)) stroke
  attrs$size <- if (!missing(size)) size
  attrs$span <- if (!missing(span)) span
  attrs$symbol <- if (!missing(symbol)) symbol
  attrs$linetype <- if (!missing(linetype)) linetype
  attrs$split <- if (!missing(split)) split
  attrs$frame <- if (!missing(frame)) frame
  # attrs$selectedpoints <- if (!missing(selectedpoints)) selectedpoints
  
  # tack on scale ranges
  attrs$colors <- colors
  attrs$strokes <- strokes
  attrs$alpha <- alpha
  attrs$alpha_stroke <- alpha_stroke
  attrs$sizes <- sizes
  attrs$spans <- spans
  attrs$symbols <- symbols
  attrs$linetypes <- linetypes

  
  # and, of course, the trace type
  attrs$type <- type
  
  # id for tracking attribute mappings and finding the most current data
  id <- new_id()
  # avoid weird naming clashes
  plotlyVisDat <- data
  p <- list(
    visdat = setNames(list(function() plotlyVisDat), id),
    cur_data = id,
    attrs = setNames(list(attrs), id),
    # we always deal with a _list_ of traces and _list_ of layouts 
    # since they can each have different data
    layout = list(
      width = width, 
      height = height,
      # sane margin defaults (mainly for RStudio)
      margin = list(b = 40, l = 60, t = 25, r = 10)
    ),
    source = source
  )
  # ensure the collab button is shown (and the save/edit button is hidden) by default
  config(as_widget(p))
}



#' Convert a list to a plotly htmlwidget object
#' 
#' @param x a plotly object.
#' @param ... other options passed onto `htmlwidgets::createWidget`
#' @export
#' @examples 
#' 
#' trace <- list(x = 1, y = 1)
#' obj <- list(data = list(trace), layout = list(title = "my plot"))
#' as_widget(obj)
#' 

as_widget <- function(x, ...) {
  if (inherits(x, "htmlwidget")) return(x)
  # add plotly class mainly for printing method
  # customize the JSON serializer (for htmlwidgets)
  attr(x, 'TOJSON_FUNC') <- to_JSON
  htmlwidgets::createWidget(
    name = "plotly",
    x = x,
    width = x$layout$width,
    height = x$layout$height,
    sizingPolicy = htmlwidgets::sizingPolicy(
      browser.fill = TRUE,
      defaultWidth = '100%',
      defaultHeight = 400
    ),
    preRenderHook = plotly_build,
    dependencies = c(
      list(typedArrayPolyfill()),
      crosstalk::crosstalkLibs(),
      list(plotlyHtmlwidgetsCSS()),
      list(plotlyMainBundle())
    )
  )
}

typedArrayPolyfill <- function() {
  htmltools::htmlDependency(
    "typedarray", "0.1",
    src = depPath("typedarray"),
    script = "typedarray.min.js",
    all_files = FALSE
  )
}

# TODO: suggest a plotlyBundles package that has trace-level bundles 
# and bundle size at print time.
plotlyMainBundle <- function() {
  htmltools::htmlDependency(
    "plotly-main", 
    version = "1.42.5",
    src = depPath("plotlyjs"),
    script = "plotly-latest.min.js",
    all_files = FALSE
  )
}

plotlyHtmlwidgetsCSS <- function() {
  htmltools::htmlDependency(
    "plotly-htmlwidgets-css", 
    version = plotlyMainBundle()$version,
    src = depPath("plotlyjs"),
    stylesheet = "plotly-htmlwidgets.css",
    all_files = FALSE
  )
}

locale_dependency <- function(locale) {
  if (!is.character(locale) || length(locale) != 1) {
    stop("locale must be a character string (vector of length 1)", call. = FALSE)
  }
  
  locale_dir <- depPath("plotlyjs", "locales")
  locales_all <- sub("\\.js$", "", list.files(locale_dir))
  if (!tolower(locale) %in% locales_all) {
    stop(
      "Invalid locale: '", locale, "'.\n\n",
      sprintf("Supported locales include: '%s'", paste(locales_all, collapse = "', '")),
      call. = FALSE
    )
  }
  
  # some locales rely on a base/main locale (e.g. de-CH relies on de)
  # https://codepen.io/etpinard/pen/pKvLVX?editors=1010
  scripts <- paste0(locale, ".js")
  if (grepl("-", locale)) {
    locale_main <- strsplit(locale, "-")[[1]][1]
    if (locale_main %in% locales_all) {
      scripts <- c(scripts, paste0(locale_main, ".js"))
    }
  }
  
  htmltools::htmlDependency(
    name = paste0("plotly-locale-", locale),
    version = plotlyMainBundle()$version,
    src = list(file = locale_dir),
    script = tolower(scripts),
    all_files = FALSE
  )
}

