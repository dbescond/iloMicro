% Generated by roxygen2: do not edit by hand
% Please edit documentation in R/Micro_prepare_ori.r
\name{Micro_prepare_ori}
\alias{Micro_prepare_ori}
\title{helper to load and prepare original file}
\usage{
Micro_prepare_ori(ref_area, source, time, wd = "default")
}
\arguments{
\item{ref_area}{country.}

\item{source}{.}

\item{time}{reference original dataset time}

\item{wd}{work directory, path folder of the original dataset, 'default'}
}
\description{
dataset could be manipulate during the load file base on the workflow arguments
}
\examples{
## Not run:

# test that
Micro_prepare_ori(ref_area = 'CAN', source = 'LFS', time = '2017M01')

## End(**Not run**)
}
\author{
ILO / bescond
}
\keyword{ILO,}
\keyword{microdataset,}
\keyword{processing}
