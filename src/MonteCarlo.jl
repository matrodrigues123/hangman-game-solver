include("HangmanSolver.jl")
using .HangmanSolver
using ProgressBars
using Printf

function main()
    inputFile = open("item2.txt", "r")
    outputFile = open("item2_output.txt", "w")
    for dictionary in ProgressBar(split.(readlines(inputFile)))
        player1Wins::Int = 0
        player2Wins::Int = 0
        for i in 1:20000
            gameST = GameState(string.(dictionary))
            while true
                # Player 1 plays
                guess(gameST)
                if gameST.gameEnded
                    player1Wins += 1
                    break
                end
                
                # Player 2 plays
                guess(gameST)
                if gameST.gameEnded
                    player2Wins += 1
                    break
                end
            end
        end

        p1WinProb::Float64 = player1Wins / (player1Wins + player2Wins) 
        Printf.@printf(outputFile, "%0.6f\n", p1WinProb)
    end
    close(inputFile)
    close(outputFile)
end