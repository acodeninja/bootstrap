using Test

# A glob, not a list: Pkg.test only ever runs this file, and naming the others
# here would break the moment one is deleted.
for name in sort(readdir(@__DIR__))
    if endswith(name, ".jl") && name != basename(@__FILE__)
        include(name)
    end
end
