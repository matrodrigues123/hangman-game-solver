# Hangman Solver Code

This is a Julia module for solving the hangman game. The code includes a `GameState` struct that stores the current state of the game and several functions for manipulating the game state and making guesses.

The `guess` function is the main function that plays the game. It repeatedly calls either `calculateBestGuessEnt` or `calculateBestGuessProb` to determine the best letter to guess based on the current game state. The function then updates the game state with the guessed letter and checks if the game has ended.

`calculateBestGuessEnt` calculates the best letter to guess using an algorithm that maximizes the entropy equation. It does this by calculating the information gain for each letter in the alphabet and selecting the letter with the highest information gain. Entropy is a measure of the uncertainty or randomness of a system. It is commonly denoted as H and can be calculated using the entropy equation:

$H(x) = -∑ p(x) log(p(x))$

where:
- $H(x)$ is the entropy of the system
- $p(x)$ is the probability of a particular outcome x occurring

This equation tells us that the entropy of a system is proportional to the sum of the probabilities of each possible outcome of the system multiplied by the logarithm of the probability of that outcome. The negative sign is included to ensure that the entropy is always non-negative.

The entropy equation is often used in information theory to measure the amount of information contained in a message or signal. It is also used in statistical mechanics to describe the distribution of energy in a system.

`calculateBestGuessProb` calculates the best letter to guess based on the frequency of letters in the remaining possible words.

The other functions, `updateResult`, `removeWithCharacter`, and `filterOnCurrentResult`, are used to update the game state based on the guessed letter.

The code uses the `Combinatorics` package to generate combinations of letters and the `HelperFunctions.jl` file for some additional helper functions.

