# Jupyter docker image with Julia kernel

This image contains [Jupyter][1] and [Julia language][2] kernel based on a fork
of [IJulia][3]. It uses [phusion/baseimage][4] as a base image.

Currently two Julia packages are customized:
- [ivant/IJulia.jl][5], which fixes package build to make it put the kernel
  spec to `.local/share/jupyter/kernels`.
- [ivant/Bokeh.jl][6], which fixes some compilation issue (probably due to
  changes in type inference engine).

## Usage

Run the container:

    docker run -d -p 8888:8888 b.gcr.io/ivant-docker-images/juputer-ijulia

and open [localhost:8888](http://localhost:8888) in your browser.

**Note**: Jupyter in this image is not password protected, nor does it use https, and anyone can access the notebook UI.

## Known issues

1. Due to ongoing changes in package precompilation, many packages fail to
   load, see [issue 12508 of JuliaLang/julia repo][7]. A workaround is to add

   ```
   VERSION >= v"0.4.0-dev+6641" && __precompile__(true)
   ```

   statement at the beginning of a `Foo.jl` file for each package `Foo` that
   does not already forbid precompilation using `__precompile__(false)`.

   This workaround is automatically applied during Docker build as a short-term
   solution for the preinstalled packages.

   Should you need to fix the packages you have installed, run the following in
   your IJulia session:

   ```
   run(`/root/fix_package_precompilation.sh`)
   ```

[1]: http://jupyter.org
[2]: http://julialang.org
[3]: https://github.com/JuliaLang/IJulia.jl
[4]: http://phusion.github.io/baseimage-docker
[5]: https://github.com/ivant/IJulia.jl
[6]: https://github.com/ivant/Bokeh.jl
[7]: https://github.com/JuliaLang/julia/issues/12508
