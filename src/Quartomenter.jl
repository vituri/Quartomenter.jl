module Quartomenter

using Markdown

include("docstrings.jl")
export @qdoc, 
    quarto_block;

end
