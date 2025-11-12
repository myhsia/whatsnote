--[==========================================[--
           L3BUILD FILE FOR WHATSNOTE
      Once Pushed With This File Modified
        A New Release Will Be Published
--]==========================================]--

--[==========================================[--
               Basic Information
             Do Check Before Push
--]==========================================]--

module              = "whatsnote"
version             = "v5.0B"
date                = "2025-11-12"
maintainer          = "Mingyu Xia"
uploader            = "Mingyu Xia"
maintainid          = "myhsia"
email               = "myhsia@outlook.com"
repository          = "https://github.com/" .. maintainid .. "/" .. module
announcement        = [[Version 5.0B released.
- Complete the source explanations in the literature programming
]]
summary             = "LaTeX class for taking notes in science, engineering, etc."
description         = "The whatsnote LaTeX class provides an elegant layout and powerful tools for taking notes in science, engineering, etc."

--[==========================================[--
          Build, Pack, Tag, and Upload
         Do not Modify Unless Necessary
--]==========================================]--

ctanzip             = module
cleanfiles          = {"*.log", "*.pdf", "*.zip", "*.curlopt"}
excludefiles        = {"*~"}
installfiles        = {"*.sty", "*.code.tex"}
tagfiles            = {"*.dtx", "*.tex"}
textfiles           = {"*.md", "LICENSE", "*.lua"}
typesetdemofiles    = {module .. "-demo.tex"}
typesetexe          = "latexmk -pdf -synctex=1"
typesetfiles        = {"*.dtx"}
typesetruns         = 1
synctex             = false

uploadconfig  = {
  pkg          = module,
  version      = version .. " " .. date,
  author       = maintainer,
  uploader     = uploader,
  email        = email,
  summary      = summary,
  description  = description,
  license      = "lppl1.3c",  
  ctanPath     = "/macros/latex/contrib/" .. module,
  announcement = announcement,
  home         = "https://github.com/" .. maintainid,
  bugtracker   = repository .. "/issues",
  support      = repository .. "/issues",
  repository   = repository,
  development  = "https://github.com/" .. maintainid,
  update       = true
}
function update_tag(file, content, tagname, tagdate)
  tagname = version
  tagdate = date
  if string.match(file, "%.dtx$") or string.match(file, "%.tex$") then
    content = string.gsub(content,
      "\\date{Released %d+%-%d+%-%d+\\quad \\texttt{v([%d%.A-Z]+)}}",
      "\\date{Released " .. tagdate .. "\\quad \\texttt{" .. tagname .. "}}")
  end
  return content
end

--[== "Hacks" to `l3build` | Do not Modify ==]--

function docinit_hook()
  cp(ctanreadme, unpackdir, currentdir)
  table.insert(cleanfiles, "*.synctex.gz")
  for _,glob in pairs(cleanfiles) do
    rm(maindir, glob)
  end
  return 0
end
function tex(file,dir,cmd)
  if synctex == true then
    synctexcmd = "-synctex=1"
    cpsyncfile = "&& cp *.synctex.gz ../../"
  else
    synctexcmd = "-synctex=0"
    cpsyncfile = ""
  end
  dir = dir or "."
  cmd = cmd or typesetexe
  if os.getenv("WINDIR") ~= nil or os.getenv("COMSPEC") ~= nil then
    upretex_aux = "-usepretex=\"" .. typesetcmds .. "\""
    makeidx_aux = "-e \"$makeindex=q/makeindex -s " .. indexstyle .. " %O %S/\""
    sandbox_aux = "set \"TEXINPUTS=../unpacked;%TEXINPUTS%;\" &&"
  else
    upretex_aux = "-usepretex=\'" .. typesetcmds .. "\'"
    makeidx_aux = "-e \'$makeindex=q/makeindex -s " .. indexstyle .. " %O %S/\'"
    sandbox_aux = "TEXINPUTS=\"../unpacked:$(kpsewhich -var-value=TEXINPUTS):\""
  end
  return run(dir, sandbox_aux .. " " .. cmd ..  " " .. synctexcmd .. " " ..
                  upretex_aux .. " " .. makeidx_aux .. " " ..
                  file        .. " " .. cpsyncfile)
end
