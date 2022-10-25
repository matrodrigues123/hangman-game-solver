include("HangmanSolver.jl")
using .HangmanSolver

function main()
    sampleDict = ["top", "web", "cam", "buy", "now"]
    
    player1Wins = 0
    player2Wins = 0
    for i in 1:20000
        gameST = GameState(sampleDict)
        println("Answer: $(gameST.answer)")
        while true
            println("Possible guesses: $(gameST.possibleGuesses)")
            print("Player 1 guesses:")
    
            guess(gameST)
            println("Current result: $(gameST.currentResult)")
            println("Possible guesses: $(gameST.possibleGuesses)")
            if gameST.gameEnded
                player1Wins += 1
                println("Player 1 wins!")
                break
            end
    
            println()
    
            println("Possible guesses: $(gameST.possibleGuesses)")
            print("Player 2 guesses:")
    
            guess(gameST)
            println("Current result: $(gameST.currentResult)")
            if gameST.gameEnded
                player2Wins += 1
                println("Player 2 wins!")
                break
            end
        end
    end
    player1WinProb = player1Wins / (player1Wins + player2Wins)
    print(player1WinProb)
end

