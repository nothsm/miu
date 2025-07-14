# miu

miu implements the MIU formal system from "Gödel, Escher, Bach" (https://en.wikipedia.org/wiki/MU_puzzle)

## usage

the program is written in written in ocaml and is built with dune. 

first, install ocaml + dune on your computer 

then, the following command will run `miu` for a search depth of `3`:
``` shell
dune exec miu 2
```
then, type in a string consisting consisting of the letters `M`, `I` or `U`
and press enter to see what strings `miu` generates. for example,

``` shell
$ dune exec miu 2
$ MI
MI
MIU
MII
MIU
MII
MIUIU
MIIU
MIIII
```
have fun trying to generate the string `MU` :)

