This package has been reviewed by Gregor Seyer <gregor.seyer@wu.ac.at>.
All of his concerns have been resolved:

(1) Please always write package names, software names and API (application
programming interface) names in single quotes in title and description.
e.g: --> 'Rcpp'

Reply: The title has been renamed as 'Trend Estimating Tools'.

(2) Please add \value to .Rd files regarding exported methods and explain
the functions results in the documentation. Please write about the
structure of the output (class) and also what the output means. (If a
function does not return a value, please document that too, e.g.
\value{No return value, called for side effects} or similar)
Missing Rd-tags:
      acf.fft.Rd: \value
      slope.Rd: \value
      stat_mk.Rd: \value

Reply: all of those functions have added `value` descriptions.
