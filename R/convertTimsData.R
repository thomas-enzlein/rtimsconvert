#' convert imaging data from Bruker timsTOF instruments to imzML
#'
#' @param input_path        Character, path to parentfolder of .d-folder.
#' @param mode              Character, export spectra in "raw" or "centroid" formats. Defaults to "centroid".
#' @param compression       Character,ZLIB compression ("zlib") or no compression ("none").
#'                          Defaults to "none". Note that zlib compression might lead to compatibility issues.
#' @param exclude_mobility  Logical, used to exclude trapped ion mobility spectrometry data from exported data.
#'                          Precursor ion mobility information is still exported.
#' @param enconding         Character, choose encoding for binary arrays: 32-bit ("32") or 64-bit ("64"). Defaults to 32-bit.
#'                          Note that 32-bit are usually enough to not limit the mass accuracy by bit depth and 64-bit is usually a waste of disk space.
#' @param profile_bins      Numeric, Number of bins used to bin data when converting in profile ("raw") mode.
#'                          A value of 0 indicates no binning is performed. Defaults to 0.
#' @param imzml_mode        Character, write .imzML files in "processed" or "continuous" mode. Defaults to "processed"
#' @param verbose           Logical, print logging output
#' @param dockerImageName   Character, the docker image name to be used.
#'
#' @details
#' This function is used to start a docker container containing timsconvert
#' (see https://github.com/gtluu/timsconvert) to convert imaging data from raw (Bruker format) to imzML.
#' Make sure that you have a working docker installation running and that a dockerimage of timsconvert is ready.
#' This package is rather barebones and will not check if docker is setup or the container present.
#' Still there is a helper function to install the correct docker image `installDockerImage()` that might help you.
#'
#' @return
#' Value of 0 if powershell command finished successfully and 1 if an error occured
#' @export

convertTimsData <- function(input_path,
                            mode = c("centroid", "raw"),
                            compression = c("none", "zlib"),
                            exclude_mobility = TRUE,
                            enconding = c("32", "64"),
                            profile_bins = 0,
                            imzml_mode = c("processed", "continuous"),
                            verbose = TRUE,
                            dockerImageName = "ghcr.io/thomas-enzlein/timsconvert:main") {
  # check arguments
  mode <- match.arg(mode)
  compression <- match.arg(compression)
  enconding <- match.arg(enconding)
  imzml_mode <- match.arg(imzml_mode)
  stopifnot(is.character(input_path))
  stopifnot(is.logical(exclude_mobility))
  stopifnot(is.numeric(profile_bins))
  stopifnot(is.logical(verbose))

  .runPowershellCommads(c("docker run --rm -v", .composeDockerBinding(input_path, "/data"),
                          dockerImageName,
                          "--input", "/data",
                          "--outdir", "/data",
                          "--mode", mode,
                          "--compression", compression,
                          ifelse(exclude_mobility,"--exclude_mobility", ""),
                          "--profile_bins", profile_bins,
                          "--imzml_mode", imzml_mode,
                          ifelse(verbose, "--verbose",  "")
                        ))
}

