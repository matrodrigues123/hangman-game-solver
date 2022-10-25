module HelperFunctions

    export constructAlphabet
    export matches

    function constructAlphabet(dictionary::Vector{String})::Dict{Char, Int}
        alphabet = Dict()
        for word in dictionary
            for c in word
                alphabet[c] = get!(alphabet, c, 0) + 1
            end
        end

        return alphabet
    end

    function matches(currResult::String, wordToMatch::String)::Bool
        for i in 1:lastindex(currResult)
            if currResult[i] != '.' && currResult[i] != wordToMatch[i]
                return false
            end
        end
        return true
    end

end