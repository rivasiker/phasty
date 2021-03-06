% Generated by roxygen2: do not edit by hand
% Please edit documentation in R/reward_phase_type.R
\name{reward_phase_type}
\alias{reward_phase_type}
\title{Transformation of Phase-Type Distributions via Rewards}
\usage{
reward_phase_type(phase_type, reward, round_zero = NULL)
}
\arguments{
\item{phase_type}{an object of class \code{cont_phase_type} or
\code{disc_phase_type}.}

\item{reward}{a vector of the same length as the number of
states. The vector should contains non negative values and only integer for
discrete phase-type class.
For \code{disc_phase_type} object, it could also be a matrix with as many
rows as states and as many columns as the maximum values of reward plus one.
Also in this case, each cell of the matrix should be probabilities and the
sum of the rows should sum up to one.}

\item{round_zero}{is a positive integer or \code{NULL}, if it is a positive
integer, all the values in the subintensity matrix and initial probabilities
will be truncate at the corresponding decimal. It can be useful if
the computational approximation of some values leads the row
sums of the subintensity  matrix to be higher than 1 or smaller than 0 for
discrete cases, or higher than 0 for continuous cases.}
}
\value{
An object of class \code{disc_phase_type} or \code{cont_phase_type}.
Be aware that if the input is a multivariate phase_type the output will be
univariate.
}
\description{
Transform a variable following a phase-type distribution according to a
non-negative reward vector.
}
\details{
For the reward transformation for continuous phase-type distribution, the
transformation will be performed as presented in the book of Bladt and
Nielsen (2017).

For the discrete phase_type distribution is based on the PhD of Navarro and
the *in prep.* manuscript of Andersen *et al.*

Every state of the subintensity matrix should have a reward, in the case of
continuous phase-type, this reward should be a vector with non negative
values of a size equal to the number of states.

For the discrete phase-type, the reward could be also a vector but containing
only non-negatives integer.
Also it can be me a matrix, in that case the matrix should have as many rows
as the number of states, and the column 1 to j+1 corresponds to reward of
0 to j. Each cell corresponding that entering in the state i, the probability
that we attribute to this state a reward j corresponds to the value of the
matrix in row i and column j+1.
}
\examples{
##===========================##
## For continuous phase-type ##
##===========================##

subint_mat <- matrix(c(-3, 1, 1,
                      2, -3, 0,
                      1, 1, -3), ncol = 3)
init_probs <- c(0.9, 0.1, 0)
ph <- phase_type(subint_mat, init_probs)
reward <- c(0.5, 0, 4)

reward_phase_type(ph, reward)

##=========================##
## For discrete phase-type ##
##=========================##

subint_mat <- matrix(c(0.4, 0, 0,
                      0.24, 0.4, 0,
                      0.12, 0.2, 0.5), ncol = 3)
init_probs <- c(0.9, 0.1, 0)
ph <- phase_type(subint_mat, init_probs)

reward <- c(1, 0, 4)

reward_phase_type(ph, reward)

#---

subint_mat <- matrix(c(0.4, 0, 0.5,
                      0.2, 0.24, 0,
                      0.4, 0.6, 0.2), ncol = 3)
init_probs <- c(0.9, 0.1, 0)

ph <- phase_type(subint_mat, init_probs)

reward <- matrix(c(0, 0.2, 1,
                   0.5, 0, 0,
                   0.5, 0.6, 0,
                   0, 0, 0,
                   0, 0.2, 0), ncol = 5)

reward_phase_type(ph, reward)


}
\references{
Bladt, M., & Nielsen, B. F. (2017). *Matrix-exponential distributions in applied probability* (Vol. 81). New York: Springer.
Campillo Navarro, A. (2019). *Order statistics and multivariate discrete phase-type distributions*. DTU Compute. DTU Compute PHD-2018, Vol.. 492
Andersen, L. *et al.* (*in prep.*)
}
\seealso{
\code{\link{phase_type}}
}
\author{
C. Guetemme, A. Hobolth
}
