#' Add data to a plotly visualization
#' 
#' @param p a plotly visualization
#' @param data a data frame.
#' @export
#' @examples 
#' 
#' plot_ly() %>% add_data(economics) %>% add_trace(x = ~date, y = ~pce)
add_data <- function(p, data = NULL) {
  if (is.null(data)) return(p)
  if (!is.plotly(p)) {
    stop("Don't know how to add traces to an object of class: ", 
         class(p), call. = FALSE)
  }
  id <- new_id()
  p$x$visdat[[id]] <- function() data
  p$x$cur_data <- id
  # TODO: should this also override the data used for the most recent trace?
  p
}

#' Add trace(s) to a plotly visualization
#' 
#' @inheritParams plot_ly
#' @param p a plotly object
#' @param inherit inherit attributes from [plot_ly()]?
#' @param z a numeric matrix
#' @param x the x variable.
#' @param y the y variable.
#' @param text textual labels.
#' @param ymin a variable used to define the lower boundary of a polygon.
#' @param ymax a variable used to define the upper boundary of a polygon.
#' @param xend "final" x position (in this context, x represents "start")
#' @param yend "final" y position (in this context, y represents "start")
#' @seealso [plot_ly()]
#' @references \url{http://plotly-book.cpsievert.me/the-plotly-cookbook.html}
#' 
#' \url{https://plot.ly/r}
#' 
#' \url{https://plot.ly/r/reference/} 
#' @author Carson Sievert
#' @export
#' @rdname add_trace
#' @examples 
#' 
#' # the `plot_ly()` function initiates an object, and if no trace type
#' # is specified, it sets a sensible default
#' p <- plot_ly(economics, x = ~date, y = ~uempmed)
#' p
#' 
#' # some `add_*()` functions are a specific case of a trace type
#' # for example, `add_markers()` is a scatter trace with mode of markers
#' add_markers(p)
#' 
#' # scatter trace with mode of text
#' add_text(p, text = "%")
#' 
#' # scatter trace with mode of lines 
#' add_paths(p)
#' 
#' # like `add_paths()`, but ensures points are connected according to `x`
#' add_lines(p)
#' 
#' # if you prefer to work with plotly.js more directly, can always
#' # use `add_trace()` and specify the type yourself
#' add_trace(p, type = "scatter", mode = "markers+lines")
#' 
#' # mappings provided to `plot_ly()` are "global", but can be overwritten
#' plot_ly(economics, x = ~date, y = ~uempmed, color = I("red"), showlegend = FALSE) %>% 
#'   add_lines() %>%
#'   add_markers(color = ~pop)
#' 
#' # a number of `add_*()` functions are special cases of the scatter trace
#' plot_ly(economics, x = ~date) %>% 
#'   add_ribbons(ymin = ~pce - 1e3, ymax = ~pce + 1e3)
#'
#' # use `group_by()` (or `group2NA()`) to apply visual mapping
#' # once per group (e.g. one line per group)
#' txhousing %>% 
#'   group_by(city) %>% 
#'   plot_ly(x = ~date, y = ~median) %>%
#'   add_lines(color = I("black"))

add_trace <- function(p, ...,
                      data = NULL, inherit = TRUE) {
  
  # "native" plotly arguments
  attrs <- list(...)
  attrs$inherit <- inherit
  
  if (!is.null(attrs[["group"]])) {
    warning("The group argument has been deprecated. Use group_by() or split instead.")
  }
  
  p <- add_data(p, data)
  
  # inherit attributes from the "first layer" (except the plotly_eval class)
  if (inherit) {
    attrs <- modify_list(unclass(p$x$attrs[[1]]), attrs)
  }
  
  p$x$attrs <- c(
    p$x$attrs %||% list(), 
    setNames(list(attrs), p$x$cur_data)
  )
  
  p
}


#' @inheritParams add_trace
#' @rdname add_trace
#' @export
add_markers <- function(p, x = NULL, y = NULL, z = NULL, ..., 
                        data = NULL, inherit = TRUE) {
  if (inherit) {
    x <- x %||% p$x$attrs[[1]][["x"]]
    y <- y %||% p$x$attrs[[1]][["y"]]
    z <- z %||% p$x$attrs[[1]][["z"]]
  }
  if (is.null(x) || is.null(y)) {
    stop("Must supply `x` and `y` attributes", call. = FALSE)
  }
  type <- if (!is.null(z)) "scatter3d" else "scatter"
  add_trace(
    p, x = x, y = y, z = z, type = type, mode = "markers", ...,
    data = data, inherit = inherit
  )
}


#' @inheritParams add_trace
#' @rdname add_trace
#' @export
add_text <- function(p, x = NULL, y = NULL, z = NULL, text = NULL, ...,
                     data = NULL, inherit = TRUE) {
  if (inherit) {
    x <- x %||% p$x$attrs[[1]][["x"]]
    y <- y %||% p$x$attrs[[1]][["y"]]
    z <- z %||% p$x$attrs[[1]][["z"]]
    text <- text %||% p$x$attrs[[1]][["text"]]
  }
  if (is.null(x) || is.null(y) || is.null(text)) {
    stop("Must supply `x`, `y` and `text` attributes", call. = FALSE)
  }
  type <- if (!is.null(z)) "scatter3d" else "scatter"
  add_trace(p, x = x, y = y, z = z, text = text, type = type, mode = "text", 
            ..., data = data, inherit = inherit)
}



#' @inheritParams add_trace
#' @rdname add_trace
#' @export
add_bars <- function(p, x = NULL, y = NULL, ...,
                     data = NULL, inherit = TRUE) {
  if (inherit) {
    x <- x %||% p$x$attrs[[1]][["x"]]
    y <- y %||% p$x$attrs[[1]][["y"]]
  }
  if (is.null(x) || is.null(y)) {
    stop("Must supply `x`/`y` attributes", call. = FALSE)
  }
  # TODO: provide type checking in plotly_build for this trace type
  add_trace_classed(
    p, class = "plotly_bar", x = x, y = y, type = "bar", 
    ..., data = data, inherit = inherit
  )
}



# attach a class to a trace which informs data processing in plotly_build
add_trace_classed <- function(p, class = "plotly_polygon", ...) {
  p <- add_trace(p, ...)
  nAttrs <- length(p$x$attrs)
  p$x$attrs[[nAttrs]] <- prefix_class(p$x$attrs[[nAttrs]], class)
  p
}

# retrieve the non-plotly.js attributes for a given trace
special_attrs <- function(trace) {
  attrs <- switch(
    class(trace)[[1]],
    plotly_segment = c("xend", "yend"),
    plotly_ribbon = c("ymin", "ymax")
  )
  # for data training, we temporarily rename lat/lon as x/y
  if (isTRUE(trace[["type"]] %in% c("scattermapbox", "scattergeo"))) {
    attrs <- c(attrs, c("x", "y"))
  }
  attrs
}





#' Apply function to plot, without modifying data
#' 
#' Useful when you need two or more layers that apply a summary statistic
#' to the original data.
#' 
#' @param p a plotly object.
#' @param fun a function. Should take a plotly object as input and return a 
#' modified plotly object.
#' @param ... arguments passed to `fun`.
#' @export
add_fun <- function(p, fun, ...) {
  oldDat <- p$x$cur_data
  p <- fun(p, ...)
  p$x$cur_data <- oldDat
  p$x$attrs[length(p$x$attrs)] <- setNames(
    list(p$x$attrs[[length(p$x$attrs)]]), oldDat
  )
  p
}


#' Add an annotation(s) to a plot
#' 
#' @param p a plotly object
#' @param text annotation text (required).
#' @param ... these arguments are documented at 
#' \url{https://github.com/plotly/plotly.js/blob/master/src/components/annotations/attributes.js}
#' @param data a data frame.
#' @param inherit inherit attributes from [plot_ly()]?
#' @author Carson Sievert
#' @export
add_annotations <- function(p, text = NULL, ..., data = NULL, inherit = TRUE) {
  p <- add_data(p, data)
  attrs <- list(text = text, ...)
  # x/y/text inherit from plot_ly()
  for (i in c("x", "y", "text")) {
    attrs[[i]] <- attrs[[i]] %||% p$x$attrs[[1]][[i]]
  }
  if (is.null(attrs[["text"]])) {
    stop("Must supply text to annotation", call. = FALSE)
  }
  attrs <- list(annotations = attrs)
  # similar to layout()
  p$x$layoutAttrs <- c(
    p$x$layoutAttrs %||% list(), 
    setNames(list(attrs), p$x$cur_data)
  )
  p
}
