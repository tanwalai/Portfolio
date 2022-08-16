# Create variable
ties <- 0
win <- 0
lose <- 0
firsttime <- 0
quit <- "exit"

# ------------------------------------------------------------------------------------------------------------------------
# Create games()

games <- function() {while (TRUE) {
  while(firsttime<1){print("Welcome to Rock-Paper-Scissors Games! You can quit this game by type exit")
    firsttime<-firsttime+1
  }
  user_ans <- tolower(readline("Choose your action: "))
  action <- c("rock", "paper", "scissors")
  result <- c(win, lose, ties)
  names(result) <- c("win", "lose", "ties") 
  if(user_ans == quit){
    print("Thank you for playing! This is your score ")
    print(result)
    result*0 #restartเกม
    firsttime*0 #restartเกม
    break
  } else if(user_ans == sample(action, 1)){
    print("ties") 
    ties <- ties + 1
  } else if(user_ans == "rock" & sample(action, 1) == "scissors" ){
    print("win")
    win <- win+1
  } else if(user_ans == "scissors" & sample(action, 1) == "paper"){
    print("win")
    win <- win+1
  } else if(user_ans == "paper" & sample(action, 1) == "rock"){
    print("win")
    win <- win+1
  } else {
    print("lose")
    lose <- lose+1
  }
}}


# ------------------------------------------------------------------------------------------------------------------------
# Play the games()
games()
