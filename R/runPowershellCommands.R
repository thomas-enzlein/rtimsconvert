.runPowershellCommads <- function(commands) {
  # concat commands
  cmds <- "powershell"
  for(i in 1:length(commands)) {
    cmds <- paste(cmds, commands[i])
  }
  # run
  cat("running command:", cmds)
  return(system(paste(cmds)))
}
