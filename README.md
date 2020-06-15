# tikzanim
TikzAnim is a latex package that make it easy to build embed tikz drawn animation in pdf file

# usage

```
\documentclass{article}
\usepackage{tikzanim}
...other package...
\begin{document}
\tikzanim{10}{
  \step{10}{
    ...tikz code...
  }
  ...many steps...
}
\end{document}
```

Read : tikzanim-howto.pdf
