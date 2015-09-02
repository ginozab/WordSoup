# WordSoup

WordSoup is a game that I created for a undergraduate project at Allegheny College. The entire program is written in MIPS Assembly language. Play the game by running the main program WordSoup.asm in MARS MIPS Simulator. 

# Gameplay

WordSoup is a very simple game that is similar to hang man. When you play the game each word you need to guess is a new round.
Each round score is equal to the number of letters that are in the word that you are trying to guess. 

For each turn you can guess an individual letter, you can guess the entire word <enter "!">, you can ask for a hint <enter "?"> (you only get one hint), or you can forfeit the entire round <enter ".">. 

For each wrong guess a point gets taken off, and for each right guess the score stays the same.

If you choose a hint it will input one of the letters of the word for you without you having to guess. 

If you guess the entire word right you get twice the remaining points in the round added to your total score, and if you guess the entire word wrong you get twice the remaining points deducted from your entire score.

If you forfeit then it will give you zero points to your total score and it will show you the final state of your guesses and show you the correct word you needed to guess. 

At the end of each round you will be asked if you want to another round or not. Answer yes by entering "y", answer no by entering "n".

# Example
Here is an example of one round of gameplay for WordSoup
```shell
Welcome to WordSoup!

I am thinking of a word. The word is _ * _ _ _ _ _ * _ . Round score is 9.

Guess a letter?
e
Correct! The word is _ * _ e _ _ _ * e . Round score is 9
Guess a letter?
i
Correct! The word is i * _ e _ i _ * e . Round score is 9
Guess a letter?
l
No! The word is i * _ e _ i _ * e . Round score is 8
Guess a letter?
!
What is your guess?
immediate

You guessed the word correctly!

Your round score is 8, doubled to 16. Game tally is 21.
Do you want to play again? (y/n) y
```
