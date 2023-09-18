#' Install timsconvert docker image
#'
#' @param imageURL character, the URL of the image.
#'
#' @export
installDockerImage <- function(imageURL = "ghcr.io/thomas-enzlein/timsconvert:main") {
  res <- .runPowershellCommads(c("docker pull", imageURL))

  if(res == 0) {
    cat("Docker image sucessfully installed\n")
  }
  if(res == 1) {
    stop("Could not install docker image.\n")
  }
}
