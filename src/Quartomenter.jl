module Quartomenter

using Markdown
using Base.Docs

include("docstrings.jl")
export @qdoc, 
    quarto_block, 
    create_qmds_doc;

end
