module PkgSearch
const DEBUG = false

using Requests
using Sparklines
using MetadataTools
using Memoize
DEBUG && using Lumberjack

type SearchState
  page::Int
  terms::AbstractString
  packages::Dict{AbstractString,Any}
  results::Dict{AbstractString,Any}
end

const search_api_uri = "http://genieframework.com/api/v1"
const search_endpoint = "/packages/search"
const details_endpoint = "/packages"

const items_per_page = 10
const search = SearchState(1, "", Dict{AbstractString, Any}(), Dict{AbstractString, Any}())

"""
  lookup(keyword1, keyword2, ...)

Searches for Julia packages matching the provided keywords. Search results limited to $items_per_page per lookup.
Returns the results and displays the info in the REPL.

#Examples
```julia
julia> PkgSearch.lookup("Redis")

4-element Array{Any,1}:
 Dict{AbstractString,Any}("search"=>Dict{AbstractString,Any} ... )
```
"""
function lookup(keywords...)
  search.terms = join(map(x -> strip(string(x)), collect(keywords)), "+")
  search.page = 1
  _lookup(search.terms);
end
@memoize function _lookup(keywords::AbstractString; autorender::Bool = true, page::Int = 1)
  if isempty(strip(keywords))
    Base.error("Search term can not be empty")
  end
  if search.page <= 0
    Base.error("Invalid page number")
    search.page = 1
  end

  try
    page_uri = search_api_uri * search_endpoint * "?q=" * replace(keywords, " ", "+") * "&page[number]=$(search.page)&page[size]=$items_per_page"
    DEBUG && Lumberjack.info(page_uri)
    search.results = Requests.get(page_uri) |> Requests.json
  catch ex
    rethrow(ex) # do something better with the exception
  end

  if ! isempty(search.results["data"])
    return process_results(search.results, autorender = autorender)
  else
    return []
  end
end

"""
  next([page_jump])

Performs a new lookup to bring the next batch of $items_per_page results, if available. If page_jump is provided, it will go directly to that page.
"""
function next(page_jump::Int = 1)
  search.page += page_jump
  _lookup(search.terms, page = search.page)
end

"""
  prev([page_jump])

Performs a new lookup to bring the previous batch of $items_per_page results, if available. If page_jump is provided, it will go directly to that page.
"""
function prev(page_jump::Int = 1)
  next(page_jump * -1)
end

"""
Returns and optionally displays in the REPL more details about the requested package
"""
function details(package_name::AbstractString; autorender::Bool = true)
  _details(package_name, autorender = autorender)
end
@memoize function _details(package_name::AbstractString; autorender::Bool = true)
  if ! haskey(search.packages, package_name)
    _lookup(package_name, autorender = false)
  end

  package_details = Requests.get(search_api_uri * details_endpoint * "/" * string(search.packages[package_name]["id"])) |> Requests.json

  if isempty(package_details) error("Package not found") end
  autorender && render_package(package_details["data"]["attributes"])

  package_details["data"]["attributes"]
end

"""
Installs the requested package using the appropriate technique: Pkg.add if it's an official METADATA package, or Pkg.clone if not.
"""
function install(package_name::AbstractString)
  if is_official_package(package_name)
    Pkg.add(package_name)
  else
    pkg_details = details(package_name, autorender = false)
    Pkg.clone(pkg_details["url"])
  end
end

"""
Returns true if the requested package is official, that is part of METADATA. False otherwise.
"""
function is_official_package(package_name::AbstractString)
  haskey(metadata_packages(), package_name)
end

"""
Returns the current page number
"""
function current_page()
  search.page
end

"""
Sets the current page number
"""
function current_page(page_number::Int)
  page_number > 0 ? search.page = page_number : error("Invalid page number")
end

"""
Returns the official packages from METADATA
"""
function metadata_packages()
  _metadata_packages()
end
@memoize function _metadata_packages()
  MetadataTools.get_all_pkg()
end

function process_results(search_results::Dict; autorender::Bool = false)
  for p in search_results["data"]
    p["search"]["headline"] = replace(p["search"]["headline"], r"(<b>|</b>)", "**")
    search.packages[p["attributes"]["name"]] = p
    autorender && render(p)
  end

  search_results["data"]
end

function render{T<:AbstractString, U<:Any}(p::Dict{T,U})
  println("=====================================================")
  println(mark_official_package(p["attributes"]["name"]) * " " * p["attributes"]["name"] * " " * p["attributes"]["url"])
  println("-----------------------------------------------------")
  display(p["search"]["headline"] |> Markdown.parse)
  println("_____________________________________________________\n\n")
end

function render_package{T<:AbstractString, U<:Any}(p::Dict{T,U})
  println("=====================================================")
  println(mark_official_package(p["name"]) * " " * p["name"] * " " * p["url"])
  println("-----------------------------------------------------")
  println("Weekly activity: ")
  spark(p["participation"])
  println("")
  println("-----------------------------------------------------")
  display(replace(p["readme"], r"(<b>|</b>)", "**") |> Markdown.parse)
  println("_____________________________________________________\n\n")
end

function mark_official_package(package_name::AbstractString)
  is_official_package(package_name) ? "✅ " : "⚠️ "
end

function help()
  println("""\n
    PkgSearch quick options: \n
    * PkgSearch.lookup("words...")
      Returns the first page of results matching the search terms \n
    * PkgSearch.next()
      Returns the next page of search results \n
    * PkgSearch.prev()
      Returns the previous page of search results \n
    * PkgSearch.details("package name")
      Shows the details for "package name" \n
    * Legend:
      ✅   official package (metadata)
      ⚠️   unofficial package
  """)
end

println("Preloading METADATA packages... please wait...")
metadata_packages()
println("Ready - use `PkgSearch.help()` for help.")

end
