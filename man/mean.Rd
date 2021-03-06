% Generated by roxygen2: do not edit by hand
% Please edit documentation in R/mean.R
\name{mean}
\alias{mean}
\alias{mean.cont_phase_type}
\alias{mean.disc_phase_type}
\alias{mean.mult_cont_phase_type}
\alias{mean.mult_disc_phase_type}
\title{mean method for \code{cont_phase_type}}
\usage{
mean(x, ...)

\method{mean}{cont_phase_type}(x, ...)

\method{mean}{disc_phase_type}(x, ...)

\method{mean}{mult_cont_phase_type}(x, v = NULL, ...)

\method{mean}{mult_disc_phase_type}(x, v = NULL, ...)
}
\arguments{
\item{x}{a \code{cont_phase_type}, \code{disc_phase_type},
\code{mult_cont_phase_type} or \code{mult_disc_phase_type} object}

\item{...}{other arguments passed to methods}

\item{v}{NULL, integer or vector.}
}
\description{
mean method for \code{cont_phase_type}

mean method for \code{disc_phase_type}

mean method for \code{mult_cont_phase_type}

mean method for \code{mult_disc_phase_type}
}
\examples{
# For univariate continuous phase-type distributions
ph1 <- phase_type(matrix(c(-3, 0, 0, 1, -2, 0, 0, 1, -1), ncol = 3), c(0.25,0.25,0.5))
mean(ph1)

# For multivariate continuous phase-type distributions
subintensity_matrix <- matrix(c(-3, 0, 0,
                               2, -2, 0,
                               0, 1, -1), nrow = 3, ncol = 3)
reward_matrix = matrix(sample(seq(0, 10), 6), nrow = 3, ncol = 2)
ph2 <- phase_type(subintensity_matrix, reward_mat = reward_matrix)
## Mean for both states in the reward matrix
mean(ph2)
## Mean for the first state in the reward matrix
mean(ph2, 1)
## Mean for the second state in the reward matrix
mean(ph2, 2)


}
