# Haskell-Reverse-Shell

This is a novel implementation of a reverse shell in Haskell. I wasn't been able to find a Haskell reverse shell, so I cobbled one together by tweaking some existing code.

You can compile it with GHC, as: ghc --make reverse-shell.hs

If run on Linux it will compile to an elf, and on Windows it will compile to an exe.

A full breakdown of the code is available here: https://passthehashbrowns.github.io/Writing-A-Reverse-Shell-In-Haskell/

References:

Reverse TCP Client by kreed131: https://gist.github.com/kreed131/1100407/77f43a49bb68bd7817f6fcae6b661275ac19c0d7
Spawning processes in Haskell from lotz84: https://lotz84.github.io/haskellbyexample/ex/spawning-processes
Handling errors from createProcess: https://stackoverflow.com/questions/21620131/how-to-handle-an-error-with-createprocess-in-haskell
