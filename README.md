# Introduction

This is a small package for plain luaTeX and luaLaTeX. In some languages,
like Czech or Polish, there should be no single letter words at the
line end, according to the typographical norms. There exists some
external commands (like `vlna`) or packages (`encxvlna` for encTeX,
`xevlna` for XeTeX, `impnattypo` for luaLaTeX).

The code is modified version of Patrick Gundlach’s answer on
TeX.sx[^1]. The difference is that it is possible to specify which
single letters should be taken into account for different
languages.

# Usage

The usage is simple:

    \input ucode
    \uselanguage{czech}
    %% in the case of luacsplain, use instead:
    %% \chyph
    %% but language code for Czech is different than in LaTeX or normal 
    %% luaTeX, so you will need to set single letters with somethinh like:
    %% \singlechars{5}{AIiVvOoUuSsZzKk}
    \input luavlna
    \preventsingledebugon
    \input luaotfload.sty
    \font\hello={name:Linux Libertine O:+rlig;+clig;+liga;+tlig} at 12pt 
    \hsize=3in
    \hello
    Příliš žluťoučký kůň úpěl ďábelské ódy. 
    Text s krátkými souhláskami a samohláskami i dalšími jevy 
    z nabídky možností (v textu možnými). 
    
    I začátek odstavce je třeba řešit, i když výskyt zalomení není pravděpodobný.
    
    Co třeba í znaky š diakritikou?
    
    Různé možnosti [v závorkách <i jiných znacích
    \preventsingledebugoff
    \bye


It is also possible to use the package with lua, just use

        \usepackage{luavlna}

in the preamble.

# Commands

    \singlechars{language name}{letters} 

Enable this feature for certain letters in given language. 

Default values:

    %% only Czech and Slovak are supported out of the box
    \singlechars{czech}{AIiVvOoUuSsZzKk}
    \singlechars{slovak}{AIiVvOoUuSsZzKk}

## Debugging commands 

    \preventsingledebugon
    \preventsingledebugoff

Insert debugging marks on/off. Default off.

[^1]:
    <http://tex.stackexchange.com/a/28128/2891>
