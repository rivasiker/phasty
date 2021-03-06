% Generated by roxygen2: do not edit by hand
% Please edit documentation in R/BlockCountingProcess.R
\name{RateMAndStateSpace}
\alias{RateMAndStateSpace}
\title{Rate matrix and state space of the block counting process}
\usage{
RateMAndStateSpace(n)
}
\arguments{
\item{n}{Number of samples}
}
\value{
List consisting of
RateM: Rate matrix
StSpM: Matrix with rows corresponding to the states
       A state is a n-dimensional row vector (a1,...,an).
       For example the beginning state is (n,0,...,0),
       the next state is (n-2,1,0,...,0),
       and the ending state is (0,...,0,1)
}
\description{
\code{RateMatAndStateSpace} finds the state space and corresponding rate matrix
for the block counting process for a number of samples n in the
standard coalescent.
}
\examples{
RateMAndStateSpace(8)



}
