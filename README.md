# Haskell-Reverse-Shell

This is a novel implementation of a reverse shell in Haskell. I haven't been able to find a Haskell reverse shell yet, so I cobbled one together by tweaking some existing code.

It currently does not handle errors in the commands passed in so.... Don't make typos. That'll be added in the next commit.

You can compile it with GHC, as: ghc --make reverse-shell.hs

If run on Linux it will compile to an elf, and if compiled on Windows it will compile to an exe. Hasn't been tested on Windows but should work the same.

References:

Reverse TCP Client by kreed131: https://gist.github.com/kreed131/1100407/77f43a49bb68bd7817f6fcae6b661275ac19c0d7
Spawning processes in Haskell from lotz84: https://lotz84.github.io/haskellbyexample/ex/spawning-processes
