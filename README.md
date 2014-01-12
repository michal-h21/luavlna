# luavlna

This is small package for plain luatex. In some languages, like Czech or Polish, there should be no single letter words at the line end, according to the typographical norms. There exists some external commands (like `vlna`) or packages (`encxvlna` for `enctex`, `xevlna` for `XeTeX`, `impnattypo` for `luaLaTeX`). This package is for plain luatex. 

The code is modified version of Patrick Gundlach's answer on TeX.sx^[http://tex.stackexchange.com/a/28128/2891]. 
Difference is that it is possible to specify which single letters should be taken into account and the code works also for single letters at the beginning of the brackets. 

The usage is simple:

    \input ucode
    \uselanguage{czech}
    \input luavlna 
    \preventsingledebugon
    \input luaotfload.sty
    \font\hello={name:Linux Libertine O:+rlig;+clig;+liga;+tlig} at 12pt %;+liga;+clig;hlig;+dlig;+trep} at 12pt
    \hsize=3in
    \hello
    Příliš žluťoučký kůň úpěl ďábelské ódy. 
    Text s krátkými souhláskami a samohláskami i dalšími jevy z nabídky možností (v textu možnými). 
    
    Grafika, ffinance -- pomlčka a tak.
    
    I začátek odstavce je třeba řešit, i když výskyt zalomení není pravděpodobný.
    
    Co třeba í znaky š diakritikou?
    
    \preventsingledebugoff
    Různé možnosti [v závorkách <a jiných znacích
    \bye

## commands

    \singlechars{#1} 
 
Enable this feature only for certain letters. By default, all single letters are processed, this command can be used to pass a string of characters, which should be processed only.

    \preventsingledebugon
    \preventsingledebugoff

Insert debugging marks on/off. Default off.
