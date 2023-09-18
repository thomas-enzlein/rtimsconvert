.composeDockerBinding <- function(hostPath, containerPath) {
  stopifnot(is.character(hostPath) & length(hostPath) == 1)
  stopifnot(is.character(containerPath) & length(containerPath) == 1)
  return(paste0(hostPath, ":", containerPath))
}
