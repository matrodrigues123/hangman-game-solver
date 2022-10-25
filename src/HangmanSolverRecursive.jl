module HangmanSolver 

    include("HelperFunctions.jl")

    using Combinatorics
    using .HelperFunctions

    export GameState
    export guess
        
    mutable struct GameState
        gameEnded::Bool
        answer::String
        wordLen::Int
        currentResult::String
        possibleGuesses::Set{String}
        ungessedLetters::Dict{Char, Int}

        function GameState(dictionary::Vector{String})
            gameEnded = false
            answer = rand(dictionary, 1)[1]
            wordLen = length(answer)
            currentResult = "."^wordLen
            possibleGuesses = Set([word for word in dictionary])
            ungessedLetters = constructAlphabet(dictionary)

            new(gameEnded, answer, wordLen, currentResult, possibleGuesses, ungessedLetters)
        end
    end

    function probPlayerWins(gameState::GameState, player::Int = 1)
        # base cases are the win/lose conditions
        if length(gameState.possibleGuesses) == 1
            if player == 1 
                return 1
            else
                return 0
            end
        end




    end

    function guess(gameState::GameState)
        while true
            if length(gameState.possibleGuesses) <= 1
                gameState.gameEnded = true
                break
            end
            
            bestGuess::Char = ' '
            # use more precise but expensive algorithm if word is small
            if gameState.wordLen <= 3
                bestGuess = calculateBestGuessEnt(gameState)
            # larger words use the approximate solution
            else
                bestGuess = calculateBestGuessProb(gameState)
            end
            # println(bestGuess)

            if bestGuess ∉ gameState.answer
                removeWithCharacter(gameState,bestGuess)
                break
            else
                updateResult(gameState, bestGuess)
                if gameState.currentResult == gameState.answer
                    gameState.gameEnded = true
                    break
                end
            end
        end
    end

    function updateResult(gameState::GameState, bestGuess::Char)
        temp::String = ""
        for i in 1:gameState.wordLen
            if gameState.answer[i] == bestGuess
                temp *= bestGuess
            else
                temp *= gameState.currentResult[i]
            end
        end
        gameState.currentResult = temp
        filterOnCurrentResult(gameState)
    end

    function removeWithCharacter(gameState::GameState, character::Char)
        newPossibleGuesses = Set()
        for word in gameState.possibleGuesses
            if character ∉ word
                push!(newPossibleGuesses, word)
            end
        end
        gameState.possibleGuesses = newPossibleGuesses
    end

    function filterOnCurrentResult(gameState::GameState)
        newPossibleGuesses = Set()
        for word in gameState.possibleGuesses
            if matches(gameState.currentResult, word)
                push!(newPossibleGuesses, word)
            end
        end
        gameState.possibleGuesses = newPossibleGuesses
    end


    function calculateBestGuessEnt(gameState::GameState)
        emptyChars = []
        for i in range(1, length(gameState.currentResult))
            if gameState.currentResult[i] == '.'
                append!(emptyChars,i)
            end
        end    


        IG = zeros(length(gameState.ungessedLetters))
        maxIG = -Inf
        bestGuess = ' '
        for (i, (letter, letterCount)) in enumerate(gameState.ungessedLetters)
            failCount = 0
            for numReps in 1:lastindex(emptyChars)
                if numReps > letterCount
                    break #maybe wrong
                end
                
                for locs in combinations(emptyChars, numReps)
                    possibleResult = gameState.currentResult
                    for loc in locs
                        possibleResult = possibleResult[1:loc - 1]*letter*possibleResult[loc+1:end]
                        matchCount = 0
                        for word in gameState.possibleGuesses
                            if letter ∉ word
                                failCount += 1
                            elseif matches(possibleResult, word)
                                matchCount += 1
                            end
                            probMatch = matchCount / length(gameState.possibleGuesses)
                            if probMatch != 0
                                IG[i] -= probMatch*log2(probMatch)
                            end
                        end
                    end
                end
            end
            probFail = failCount/length(gameState.possibleGuesses)
            if probFail != 0
                IG[i] /= probFail
                if IG[i] > maxIG
                    bestGuess = letter
                    maxIG = IG[i]
                end
            else # prob of fail is zero, found best guess
                bestGuess = letter
                break
            end

        end

        # after all the loops, return the letter that maximizes entropy and remove it from ungessedLetters
        delete!(gameState.ungessedLetters, bestGuess)
        return bestGuess
    end

    function calculateBestGuessProb(gameState::GameState)
        # get letter that appears in the largest number of words
        freqTable::Dict{Char, Int} = Dict()
        for (letter,value) in gameState.ungessedLetters
            for word in gameState.possibleGuesses
                if letter in word
                    freqTable[letter] = get!(freqTable, letter, 0) + 1
                    continue
                end
            end
        end
        bestGuess = findmax(freqTable)[2]
        delete!(gameState.ungessedLetters, bestGuess)
        return bestGuess
    end

end
