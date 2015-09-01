Pkg.init()

# This repo contains fixes related to Jupyter 4.
Pkg.clone("git://github.com/ivant/IJulia.jl.git", "IJulia")
Pkg.pin("IJulia")

# This repo contains fixes to Bokeh.
Pkg.clone("git://github.com/ivant/Bokeh.jl.git", "Bokeh")
Pkg.pin("Bokeh")

pkgs = [
  "BayesNets",
  "Cairo",
  "Clp",
  "Clustering",
  "Colors",
  "DataArrays",
  "DataFrames",
  "DataStructures",
  "DimensionalityReduction",
  "Distributions",
  "FixedSizeArrays",
  "Formatting",
  "FunctionalCollections",
  "GLM",
  "GLPKMathProgInterface",
  "Gadfly",
  "GeneticAlgorithms",
  "GeometricalPredicates",
  "GeometryTypes",
  "GraphLayout",
  "Graphs",
  "HDF5",
  "HypothesisTests",
  "ImageView",
  "Images",
  "Interact",
  "Ipopt",
  "Iterators",
  "JuMP",
  "KernelDensity",
  "LinearLeastSquares",
  "MCMC",
  "MCMC",
  "MultivariateStats",
  "NLopt",
  "NumericExtensions",
  "ODE",
  "Optim",
  "PGFPlots",
  "PyPlot",
  "RDatasets",
  "Roots",
  "SIUnits",
  "SVM",
  "StatsBase",
  "Sundials",
  "SymPy",
  "WAV",
]

for pkg in pkgs
  Pkg.add(pkg)
end

Pkg.build()
