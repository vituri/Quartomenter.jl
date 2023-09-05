"""
    quarto_block(x)

Interpolate the string `x` with the Quarto callout block. Return a MD.
"""
function quarto_block(x)
    s = """

    :::{.callout-note appearance="simple"}

    $x

    :::

    """

    s = replace(string(s), "\n#" => "\n###")

    return Markdown.parse(s)
end

"""
    @qdoc

Create a MD block with a macro.
"""
macro qdoc(f)
    quote
        quarto_block(@doc $f)
    end
end

"""
    create_qmds_doc(m::Module, filepath = "quarto-docs/quarto_docs.qmd")

Create the .qmd with all documentation from the module.
"""
function create_qmds_doc(m::Module, filepath = "quarto-docs/quarto_docs.qmd")

    module_name = m |> repr

    mds = filter(Docs.modules) do m
        s = repr(m)
        if (s == module_name) | occursin("($module_name).", s)
            return true
        end

        return false
    end

    metadicts = Docs.meta.(mds)

    open(filepath, "w") do io
        counter = 1
        println(io, "# Reference \n \n")

        for metadict in metadicts
            
            module_name = mds[counter] |> repr
            println(io, "## Module $module_name \n")

            for (bd, md) in metadict
                ds = map(x->md.docs[x], md.order)

                for d in ds
                    s = d |> Docs.parsedoc |> quarto_block #|> string
                    println(io, s)
                end            
            end

            counter += 1
        end
    end
end