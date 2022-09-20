def game():
    first_time = 0
    win = 0
    lose = 0
    ties = 0
    score = {
        "win" : win,
        "lose" : lose,
        "ties" : ties
    }
    bot_list = ['rock', 'paper', 'scissors']
    while True :
        while first_time == 0:
            print("Welcome to Rock-Paper-Scissors game!\n You can quit this game by type exit")
            first_time += 1
        user_ans = input("Choose your action: ").lower()
        bot_action = random.choice(bot_list)
        if user_ans == "exit":
            print("Thanks for playing my game! This is your score")
            print(score)
            break
        elif user_ans == bot_action :
            print("ties")
            score["ties"] +=1
        elif (user_ans == "rock" and bot_action == "scissors") or \
        (user_ans == "scissors" and bot_action == "paper") or \
        (user_ans == "paper" and bot_action == "rock") :
            print("win")
            score["win"] +=1
        elif (user_ans == "rock" and bot_action == "paper") or \
        (user_ans == "scissors" and bot_action == "rock") or \
        (user_ans == "paper" and bot_action == "scissors") :
            print("lose")
            score["lose"] +=1
        else:
            print("please choose 'paper' or 'scissors' or 'rock'")
