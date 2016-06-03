# PkgSearch
## A Julia utility for package discovery

PkgSearch is a small REPL tool that helps Julia developers find and install packages. It knows about both the official and the unofficial packages available on GitHub. It searches for your keywords within both the package name and, most importantly, within the package's README file. 

The search results are provided by a RESTful API so the search will be fast and no data will be stored locally. The APIs data is refreshed daily. 

PkgSearch is not yet an official package, so install using: 

```julia
Pkg.clone("https://github.com/essenciary/PkgSearch")
```

It uses a few more packages, so you might need to install these too, first: 

```
Requests
Sparklines
MetadataTools
Memoize
```

## Searching for packages

In order to search for packages, the `lookup(keyword1::AbstractString, keyword2::AbstractString, ...)` function is available. As this is designed as a REPL tool, the search results will be displayed in a human readable format. However, the function will return an array of results, that can be used programatically. 

```julia
using PkgSearch

julia> PkgSearch.lookup("web")

=====================================================
Escher.jl
-----------------------------------------------------
Unofficial package
-----------------------------------------------------
git://github.com/shashi/Escher.jl.git
-----------------------------------------------------
  web server for 2016.** Escher's built-in web server allows you to create interactive
_____________________________________________________


=====================================================
docker-scrapy-crawler
-----------------------------------------------------
Unofficial package
-----------------------------------------------------
git://github.com/iammai/docker-scrapy-crawler.git
-----------------------------------------------------
  web browser for the web ui for monitoring * Go to http://192.168.59.103:6800/ * Go to http://192.168.59.103:6800/jobs
_____________________________________________________


=====================================================
GoogleCharts
-----------------------------------------------------
Official package
-----------------------------------------------------
git://github.com/jverzani/GoogleCharts.jl.git
-----------------------------------------------------
  web page describes this. We don't have a mechanism in place supporting Google's "Column
_____________________________________________________

[ ... output omitted ... ]

10-element Array{Any,1}:
 Dict{AbstractString,Any}("search"=>Dict{AbstractString,Any}("rank"=>0.0951392,"headline"=>"**web** server for 2016.** Escher's built-in **web** server allows you to create interactive"),"links"=>Dict{AbstractString,Any}("self"=>"/api/v1/packages/466"),"attributes"=>Dict{AbstractString,Any}("name"=>"Escher.jl","url"=>"git://github.com/shashi/Escher.jl.git"),"id"=>466,"type"=>"packages")
 Dict{AbstractString,Any}("search"=>Dict{AbstractString,Any}("rank"=>0.094717,"headline"=>"**web** browser for the **web** ui for monitoring\n   * Go to http://192.168.59.103:6800/\n   * Go to http://192.168.59.103:6800/jobs"),"links"=>Dict{AbstractString,Any}("self"=>"/api/v1/packages/1317"),"attributes"=>Dict{AbstractString,Any}("name"=>"docker-scrapy-crawler","url"=>"git://github.com/iammai/docker-scrapy-crawler.git"),"id"=>1317,"type"=>"packages")
 Dict{AbstractString,Any}("search"=>Dict{AbstractString,Any}("rank"=>0.0889769,"headline"=>"**web** page describes this. We don't have a mechanism in\nplace supporting Google's \"Column"),"links"=>Dict{AbstractString,Any}("self"=>"/api/v1/packages/289"),"attributes"=>Dict{AbstractString,Any}("name"=>"GoogleCharts","url"=>"git://github.com/jverzani/GoogleCharts.jl.git"),"id"=>289,"type"=>"packages")
 Dict{AbstractString,Any}("search"=>Dict{AbstractString,Any}("rank"=>0.0827456,"headline"=>"**web** pages from Julia. Pages may be served over the internet and controlled from the browser"),"links"=>Dict{AbstractString,Any}("self"=>"/api/v1/packages/240"),"attributes"=>Dict{AbstractString,Any}("name"=>"Blink.jl","url"=>"git://github.com/JunoLab/Blink.jl.git"),"id"=>240,"type"=>"packages")
 Dict{AbstractString,Any}("search"=>Dict{AbstractString,Any}("rank"=>0.0827456,"headline"=>"**web** browser.  Click\non the *New* button and choose the *Julia* option to start a new\n\"notebook"),"links"=>Dict{AbstractString,Any}("self"=>"/api/v1/packages/288"),"attributes"=>Dict{AbstractString,Any}("name"=>"IJulia.jl","url"=>"git://github.com/JuliaLang/IJulia.jl.git"),"id"=>288,"type"=>"packages")
 Dict{AbstractString,Any}("search"=>Dict{AbstractString,Any}("rank"=>0.0827456,"headline"=>"**web** content, GTK+ 3 Port\n11. libwebkitgtk3-devel (mingw32) - Library for rendering **web** content, GTK+ 3 Port"),"links"=>Dict{AbstractString,Any}("self"=>"/api/v1/packages/939"),"attributes"=>Dict{AbstractString,Any}("name"=>"WinRPM.jl","url"=>"git://github.com/JuliaLang/WinRPM.jl.git"),"id"=>939,"type"=>"packages")
 Dict{AbstractString,Any}("search"=>Dict{AbstractString,Any}("rank"=>0.0827456,"headline"=>"**Web**)\"\n\t  \"Idrisi\"     => \"Idrisi Vector (.vct)\"\n\t  \"WFS\"        => \"OGC WFS (**Web** Feature Service)\"\n\t  \"WMS\"        => \"OGC **Web** Map Service"),"links"=>Dict{AbstractString,Any}("self"=>"/api/v1/packages/1058"),"attributes"=>Dict{AbstractString,Any}("name"=>"RasterIO.jl","url"=>"git://github.com/wkearn/RasterIO.jl.git"),"id"=>1058,"type"=>"packages")
 Dict{AbstractString,Any}("search"=>Dict{AbstractString,Any}("rank"=>0.0759909,"headline"=>"**web** applications in Julia as easy as possible.\n\nIf you have looked at the examples"),"links"=>Dict{AbstractString,Any}("self"=>"/api/v1/packages/492"),"attributes"=>Dict{AbstractString,Any}("name"=>"Pages","url"=>"git://github.com/EricForgy/Pages.jl.git"),"id"=>492,"type"=>"packages")
 Dict{AbstractString,Any}("search"=>Dict{AbstractString,Any}("rank"=>0.0759909,"headline"=>"**web** services some closure. Mux allows you to\ndefine servers in terms of highly modular"),"links"=>Dict{AbstractString,Any}("self"=>"/api/v1/packages/588"),"attributes"=>Dict{AbstractString,Any}("name"=>"Mux.jl","url"=>"git://github.com/JuliaWeb/Mux.jl.git"),"id"=>588,"type"=>"packages")
 Dict{AbstractString,Any}("search"=>Dict{AbstractString,Any}("rank"=>0.0759909,"headline"=>"**Web** Services\n\nThis package provides a native Julia interface to the Amazon **Web** Services API\n\nThe following"),"links"=>Dict{AbstractString,Any}("self"=>"/api/v1/packages/644"),"attributes"=>Dict{AbstractString,Any}("name"=>"AWS","url"=>"git://github.com/JuliaParallel/AWS.jl.git"),"id"=>644,"type"=>"packages")

```

### Getting more results

The results are paginated, with 10 packages per page. To navigate between the results, use the `next()` and `prev()` functions. They both take an optional `::Int` argument indicating how many pages to jump (the default is 1). 

```julia
julia> PkgSearch.next()

=====================================================
TextMining.jl
-----------------------------------------------------
Unofficial package
-----------------------------------------------------
git://github.com/SLU-TMI/TextMining.jl.git
-----------------------------------------------------
  Julia**** with the goal of making them fast, generic, and easily usable in **Julia's REPL
_____________________________________________________

[ ... output omitted ... ]

```

### Checking packages details

Once you found a package that looks interesting, you can find out more about it using `details(package_name::AbstractString)`. Similar to `lookup()`, the results are displayed in human readable format and a `Dict` is returned for using in scripts. 

```julia
julia> PkgSearch.details("Mocking")

=====================================================
Mocking
-----------------------------------------------------
git://github.com/invenia/Mocking.jl.git
-----------------------------------------------------
Official package
-----------------------------------------------------
Weekly activity:
▁▁▁▁▁▁▁▁▁▁▁▁▁▁▁▄▇▁▃▁▁▁▁▄█▁▁▁▁▁▂▁▁▁▁▂▁▁▁▁▁▁▁▁▁▂▂▁▁▁▁▁
-----------------------------------------------------
     Mocking
    ≡≡≡≡≡≡≡≡≡

  (Image: Build Status) (Image: Build Status) (Image: codecov.io)

  Allows Julia functions to be temporarily modified for testing purposes.

     Usage
    =======

  Using the mend function provides a way to temporarily overwrite a specific method.
  
[ ... output omitted ... ]

Dict{AbstractString,Any} with 4 entries:
  "name"          => "Mocking"
  "participation" => Any[0,0,0,0,0,0,0,0,0,0  …  0,0,0,2,3,0,0,0,0,0]
  "readme"        => "# Mocking\n\n[![Build Status](https://travis-ci.org/invenia/Mocking.jl.svg?branch=master)](https://travis-ci.org/invenia/Mocking.jl)\n[![Build Status](https://ci.appveyor.com/api/projects/status/la041r86v6p5k24x?svg=true)](https://ci.appveyor.com/project/omus/mocking-jl)\n[![codecov.io](http://…
  "url"           => "git://github.com/invenia/Mocking.jl.git"
```

## Installing packages

PkgSearch informs you whether or not a package is official. Using this info you can either `Pkg.add()` or `Pkg.clone()`. Or you can just run `PkgSearch.install(package_name::AbstractString)` and PkgSearch will do it for you. 