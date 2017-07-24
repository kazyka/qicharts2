#' Paretochart
#' 
#' Creates a pareto chart from a categorical variable
#'
#' @param x Categorical variable to plot.
#' @param title Chart title.
#' @param subtitle Chart subtitle.
#' @param caption Chart caption.
#' @param ylab Y axis label.
#' @param xlab X axis label.
#'
#' @return An object of class ggplot.
#' 
#' @examples
#' # Generate categorical vector
#' x <- rep(LETTERS[1:9], c(256, 128, 64, 32, 16, 8, 4, 2, 1))
#' 
#' # Make paretochart
#' paretochart(x)
#' 
#' # Save paretochart object to variable
#' p <- paretochart(x)
#' 
#' # Print data frame
#' p$data
#' 
#' @import ggplot2
#' @export

paretochart <- function(x,
                        title = NULL,
                        subtitle = NULL,
                        caption = NULL,
                        ylab       = NULL,
                        xlab       = NULL) {
  varname  <- deparse(substitute(x))
  x        <- factor(x)
  x        <- table(x)
  x        <- sort(x, decreasing = TRUE, na.last = TRUE)
  x <- as.data.frame(x)
  names(x) <- c('x', 'y')
  x$y.cum <- cumsum(x$y)
  x$p <- x$y / sum(x$y)
  x$p.cum <- cumsum(x$p)
  
  if (is.null(title)) {
    title <- paste('Pareto Chart of', varname)
  }
  
  p <- ggplot(x, aes_(x = ~ x, y = ~ p.cum)) +
    geom_col(aes_(y = ~ p), fill = '#88BDE6') +
    geom_line(aes_(group = 1), colour = 'grey33') +
    geom_point(colour = 'grey33') +
    geom_text(aes_(y = ~ p, label = ~ y), vjust = -1) +
    scale_y_continuous(breaks = seq(0, 1, 0.2),
                       labels = scales::percent) +
    theme_minimal() +
    theme(panel.grid.minor = element_blank(),
          panel.grid.major.x = element_blank()) +
    labs(title = title,
         subtitle = subtitle,
         caption = caption,
         y = ylab,
         x = xlab)
  
  return(p)
}