#' Adapt Results 2
#' @param date date
#' @return Dataframe of descriptives and frequencies for each variable and value
#' @description Test ADAPT 2
#' @export

adapt_report_new <- function(date = "")
{
  purrr::walk(1:5, function(x) {
    cat("Processing...\n")
    Sys.sleep(1)
  })
  cat(crayon::red$bold("Victoria!!!!!!!!!!!!!!!!!!!!!!!!!!\n"))
  Sys.sleep(4)
  cat("I know this is going to sound crazy, but it's me, Victoria, but from the ", crayon::red$bold("future"), "!!!\n", sep = "")
  Sys.sleep(3)
  cat("You can call me", crayon::blue$bold("Future Victoria"), "\n")
  Sys.sleep(3)
  cat("In the future, everyone uses R for texting for some reason and I just invented a time machine. I'm contacting you to warn you.\n")
  Sys.sleep(3)
  cat("But first, we have to make sure Ryan, Sydney, and Yael are gone. It's not safe if they're around!")
  Sys.sleep(3)
  alone <- readline(prompt = "Are they gone? (Y/N)  ")
  while (!(alone %in% c("y", "Yes", "yes", "Y"))) {
    cat("Wait until the rest of the team is gone and let me know\n")
    alone <- readline(prompt = "Are they gone? (Y/N)  ")
  }
  Sys.sleep(3)
  cat("Okay good!\n")
  Sys.sleep(3)
  cat("A spy has infiltrated JetBlue through the Gateway Select program!\n")
  Sys.sleep(3)
  cat("The team, relying on their carefully crafted assessment processes, painstakingly accepted the very best candidates\n")
  Sys.sleep(3)
  cat("for the class of 2018 and graduates from that class have now become first officers.\n")
  Sys.sleep(3)
  cat("There was one candidate who passed each step with flying colors and was unanimously regarded as a first-rate applicant.\n")
  Sys.sleep(3)
  cat("However, once the 2018 program kicked off, rumors started flying and secrets starting leaking.\n")
  Sys.sleep(3)
  cat("This betrayal continued even after the four years of the program were completed and the trainees",
      "transitioned into first officers.\n")
  Sys.sleep(3)
  cat("You quickly realized that the spy must have been from the Gateway Select 2018 class.\n")
  Sys.sleep(3)
  cat("As a first officer, it now seems that the spy has broadened their focus from the Gateway Select program\n")
  Sys.sleep(3)
  cat("to the entirety of JetBlue and is currently working to bring down the whole company from within.\n")
  Sys.sleep(3)
  cat("I am contacting you now because you have the power to root out this candidate", crayon::bold$red("before"), "they begin the program.\n")
  Sys.sleep(3)
  cat("Only you have the knowledge and connections to figure out who this candidate is and prevent this fiasco from occurring!!\n")
  Sys.sleep(3)
  cat("I've hidden clues around the building that will lead you to this devious candidate.\n")
  Sys.sleep(3)
  cat("I've protected the clues with challenges in case the spy is on to you.\n")
  Sys.sleep(3)
  cat("But first, I need to know if you will help\n")
  decision <- readline(prompt = "Will you help Future Victoria? (Y/N)  ")
  while (!(decision %in% c("y", "Yes", "yes", "Y"))) {
    cat("Come on, please...\n")
    decision <- readline(prompt = "Will you help Future Victoria? (Y/N)  ")
  }
  # cat("Thank you! But first, you need a codename, so that the spy doesn't catch on to us\n")
  # name <- readline(prompt = "Enter codename: ")
  # Sys.sleep(1)
  # cat("Welcome to the mission", name,"\n")
  Sys.sleep(3)
  cat("I must also warn you. Do NOT talk to", crayon::blue$bold("present"),"Sam, Sydney, Ryan or Yael - it could mess up the time continuum and destroy the universe!\n")
  Sys.sleep(3)
  cat("If you need help, you can contact me on the", crayon::red$bold("#help"), "channel on the People Assessment Slack.\n")
  Sys.sleep(3)
  cat("Also, please", crayon::red$bold("DO NOT"), "hit the escape button. If you do, we will get disconnected and the spy will never be stopped!")
  # Task 1
  cat("To start you off, I'm going to send you a list of the potential suspsects and their performance\n")
  
  # file <- readxl::read_excel("/Users/Samuel/Google Drive/Work/JetBlue/Scavenger Hunt/Interviews.xlsx")
  # devtools::use_data(file, overwrite = TRUE)
  file <- SKTools::file
  
  if(.Platform$OS.type == "windows") {
    writexl::write_xlsx(
      file,
      paste0(Sys.getenv("USERPROFILE"), "\\Desktop\\Interviews.xlsx"))
  }
  if(.Platform$OS.type == "unix") {
    invisible(writexl::write_xlsx(
      file,
      paste0(Sys.getenv("HOME"),"/Desktop/Interviews.xlsx")))
  }
  Sys.sleep(1)
  cat('Their interview performance should now be on your desktop in a file called "Interviews.xlsx"\n')
  Sys.sleep(2)
  cat("We know that the spy applied in either 2016 or 2017, before applying again in 2018.\n")
  Sys.sleep(2)
  cat("I can tell you that the spy did well in the interview, but I remember that Debra had a bad feeling about a few people in the process.\n")
  Sys.sleep(2)
  cat("I'm pretty sure that she gave them low Impact scores.\n")
  Sys.sleep(2)
  cat("We didn't listen to her then, but it might be a good idea to take a look at the interview ratings to narrow down the suspects.\n")
  Sys.sleep(2)
  cat("Once you've narrowed down the list of suspects, add up their id numbers and enter it here")
  sum.id <- readline(prompt = "What is the sum of the id numbers?  ")
  while (sum.id != 386946) {
    cat("There is an error in at least one of your answers\n")
    sum.id <- readline(prompt = "What is the sum of the id numbers?   ")
  }
  cat("That is correct, nice job!")
  Sys.sleep(2)
  cat("To narrow down the list further, let's investigate their onsite performance.")
  Sys.sleep(2)
  cat('The next step would be to "fly" to where we did the assessments. Without leaving the building, go to those locations\n.')
  Sys.sleep(2)
  cat("Remember, you can't trust anyone. If you get there and you see anyone else, then try another location.") 
}