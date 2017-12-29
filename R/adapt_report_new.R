#' Adapt Results 2
#' @param date date
#' @return Dataframe of descriptives and frequencies for each variable and value
#' @description Test ADAPT 2
#' @export

adapt_report_new <- function(date = "")
{
  cat(crayon::red$bold("Victoria!!!!!!!!!!!!!!!!!!!!!!!!!!\n"))
  Sys.sleep(4)
  cat("I know this is going to sound crazy, but it's me, Victoria, but from the ",
      crayon::red$bold("future"),
      "!!!\n", sep = "")
  Sys.sleep(2)
  cat("You can call me", crayon::blue$bold("Future Victoria"), "\n")
  Sys.sleep(2)
  cat("I'm contacting you through a texting time machine to warn you\n")
  Sys.sleep(2)
  cat("A spy has infiltrated JetBlue through the Gateway Select program!\n")
  Sys.sleep(2)
  cat("The team, relying on their carefully crafted assessment processes, painstakingly accepted the very best candidates\n")
  Sys.sleep(2)
  cat("for the class of 2018 and graduates from that class have now become first officers.\n")
  Sys.sleep(2)
  cat("There was one candidate who passed each step with flying colors and was unanimously regarded as a first-rate applicant.\n")
  Sys.sleep(2)
  cat("However, once the 2018 program kicked off, rumors started flying and secrets starting leaking.\n")
  Sys.sleep(2)
  cat("This betrayal continued even after the four years of the program were completed and the trainees",
      "transitioned into first officers.\n")
  Sys.sleep(2)
  cat("You quickly realized that the spy must have been from the Gateway Select 2018 class.\n")
  Sys.sleep(2)
  cat("As a first officer, it now seems that the spy has broadened their focus from the Gateway Select program\n")
  Sys.sleep(2)
  cat("to the entirety of JetBlue and is currently working to bring down the whole company.\n")
  Sys.sleep(2)
  cat("I am contacting you now because you have the power to root out this candidate", crayon::bold("before"), "they begin the program.\n")
  Sys.sleep(2)
  cat("Only you have the knowledge and connections to figure out who this candidate is and prevent this fiasco from occurring!!\n")
  Sys.sleep(2)
  cat("I've hidden clues around the building that will lead you to this devious candidate.\n")
  Sys.sleep(2)
  cat("I've protected the clues with challenges in case the spy is on to you.\n")
  Sys.sleep(2)
  cat("I've left you a series of clues that will help you find the cure\n")
  Sys.sleep(2)
  cat("But first, I need to know you will help\n")
  decision <- readline(prompt = "Will you help Future Victoria? (Y/N)  ")
  while (!(decision %in% c("y", "Yes", "yes", "Y"))) {
    cat("Come on, please...\n")
    decision <- readline(prompt = "Will you help Future Victoria?")
  }
  cat("Thank you! You will save so many people. But first, you need a codename, so that Ryan doesn't catch on to you\n")
  name <- readline(prompt = "Enter codename: ")
  cat("Welcome to the mission", name,"\n")
  cat("I must also warn you. Do not talk to", crayon::blue$bold("present"),"Sam, Sydney, Ryan or Yael - it could mess up the time continuum and destroy the universe!\n")
  cat("If you need help, you can contact me on the", crayon::red$bold("#help"), "channel on the People Assessment Slack.\n")
  cat("Also, please do not hit the escape button. If you do, we will get disconnected and the spy will never be stopped!")
}