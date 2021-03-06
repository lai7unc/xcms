% Generated by roxygen2: do not edit by hand
% Please edit documentation in R/functions-imputation.R
\name{imputeRowMinRand}
\alias{imputeRowMinRand}
\title{Impute missing values with random numbers based on the row minimum}
\usage{
imputeRowMinRand(x, min_fraction = 1/2, sd_fraction = 1, abs = TRUE)
}
\arguments{
\item{x}{\code{matrix} with abundances, rows being features/metabolites and
columns samples.}

\item{min_fraction}{\code{numeric(1)} with the fraction of the row minimum that
should be used to replace \code{NA} values in that row.}

\item{sd_fraction}{\code{numeric(1)} factor to reduce the estimated standard
deviation.}

\item{abs}{\code{logical(1)} to force imputed values to be strictly positive.}
}
\description{
Replace missing values with random numbers from a normal distribution based
on (a fraction of) the row min and a standard deviation estimated from the
linear relationship between row standard deviation and mean of the full data
set. Parameter \code{sd_fraction} allows to further reduce the estimated
standard deviation.
}
\details{
Imputed values are taken from a normal distribution with mean being a
user defined fraction of the row minimum and the standard deviation
estimated for that mean based on the linear relationship between row
standard deviations and row means in the full matrix \code{x}.

To largely avoid imputed values being negative or larger than the \emph{real}
values, the standard deviation for the random number generation is estimated
ignoring the intercept of the linear model estimating the relationship
between standard deviation and mean. If \code{abs = TRUE} \code{NA} values are
replaced with the absolute value of the random values.
}
\examples{

library(faahKO)
data("faahko")

xset <- group(faahko)
mat <- groupval(xset, value = "into")

## Estimate the relationship between row sd and mean. The standard deviation
## of the random distribution is estimated on this relationship.
mns <- rowMeans(mat, na.rm = TRUE)
sds <- apply(mat, MARGIN = 1, sd, na.rm = TRUE)
plot(mns, sds)
abline(lm(sds ~ mns))

mat_imp <- imputeRowMinRand(mat)

head(mat)
head(mat_imp)
}
\seealso{
\code{imputeLCMD} package for more left censored imputation functions.

Other imputation functions: \code{\link{imputeRowMin}}
}
\author{
Johannes Rainer
}
\concept{imputation functions}
