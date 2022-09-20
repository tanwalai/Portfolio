games <- function() {
  ties <- 0
  win <- 0
  lose <- 0
  firsttime <- 0
  while (TRUE) {
    while(firsttime<1){print("Welcome to Rock-Paper-Scissors Games! You can quit this game by type exit")
      firsttime<-firsttime+1
    }
    user_ans <- tolower(readline("Choose your action: "))
    action <- c("rock", "paper", "scissors")
    result <- c(win, lose, ties)
    names(result) <- c("win", "lose", "ties") 
    bot_action <- sample(action, 1)
    if(user_ans == "exit"){
      print("Thank you for playing! This is your score ")
      print(result)
      break
    } else if(user_ans == bot_action){
      print("ties") 
      ties <- ties + 1
    } else if(user_ans == "rock" & bot_action == "scissors" ){
      print("win")
      win <- win+1
    } else if(user_ans == "scissors" & bot_action == "paper"){
      print("win")
      win <- win+1
    } else if(user_ans == "paper" & bot_action == "rock"){
      print("win")
      win <- win+1
    } else if(user_ans == "paper" & bot_action == "scissors"){
      print("lose")
      lose <- lose+1
    }else if(user_ans == "scissors" & bot_action == "rock"){
      print("lose")
      lose <- lose+1
    }else if(user_ans == "rock" & bot_action == "paper"){
      print("lose")
      lose <- lose+1
    }else {
      print("please choose 'paper' or 'scissors' or 'rock'")
    }
  }}
