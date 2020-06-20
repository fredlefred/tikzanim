I apologie for my poor english.

# 1 Introduction
tikzanim create animations in L A TEX with tikz and animate. Steps are drawn with standard tikz code.
A tikzanim’s animation is made of steps. Each step draws transparencies which are uses with others to
create frames of the part’s step.

# 2 tikzanim’s macros
## 2.1 `\tikzanim`

This macro uses a animateinline’s environment, \multiframe and a tikzpicture’s environment to
prepare animationntes images).
Syntax :
`\tikzanim <overlay> [animateinline’s options] {frame rate} [tikz’s options] {initialisation} {steps}`
* `<overlay>` : overlay number on which animation will be shown. Before this number, first frame of animation will be dran. After this number, last frame of animation will be drawn.
Prefer a single number for the overlay, or animation will be render multiple times.}
*  `[animateinline’s options]` : options which are pass to animateinline’s environment.
Défault value : poster=last,controls
* `{frame rate}` : the starting frame rate. Each step can change it.
* `[options tikz]` : options which are pass to tikzpicture’s environment.
Défault value : no option
* `{initialisation}` : tikz’s code. This code will initialize all frames. Minimaly, it should call `\useasboundingbox` to set same size to all transparencies.
* `{étapes}` : list of steps.

## 2.2 `\step`

This macro define a new animation’s step. animate uses a transparencies’ stack. Each animation’s frame
is draw by showing all the stack. `\step` manage the stack and frame frame creation.
At start, the stack is empty. A \step call will :
(1) create first image of the step, put it on the stack for a frame.
(2) remove last image of the stack.
(3) create next image, put it on the stack for a frame.
(4) If it’s not step’s end, go to (2).
(5) If it’s step’s end, last image will stay on stack for some define time.

Syntaxe :
`\step[*] [frame rate] {images} [duration] {tikz’ code}`
* `*` : star version will clear transparencies stack at animation’s start.
* `[frame rate]` : define the new frame rate.
Défault value : last frame rate defined either by `\tikzanim` or `\step`.
* `{images}` : define how many frames `\step` will define. If 0, a transparencies is created but no frame.
The transparencies will last for `[duration]` on the stack.
* `[duration]` : set duration of last step’s transparency (in frames).
Défault value : 0, to animation’s end.
* `{tikz’s code}` : here goes tikz’s code which will draw each transparency. This code should use all
previous initialised code, and, to make things depends on which frame is to be drawn, the macros
`\framepos` and `\iframe`.
  * The macro `\framepos` is set to 0 at step’s start, and will go to 1 at step’s end. `\step` will set
this macro.
  * The macro `\iframe` is set to transparency number. `\multiframe` from animate’s package will
set this macro.

# 2.3 `\allframes`

This macro draw on all transparencies.
Syntax :
`\allframes {tikz’s code}`
* {tikz’s code} : set tikz’s code to be drawn on each transparency chargé de dessiner sur tous les
transparents. This code should use all previous initialised code, \framepos and \iframe.

#3 timeline
`animate` ues a timeline file to manage transparencies’ stack. tikzanim will create a timeline file by
animation. They are named : `\jobname.tzc#.tln`. You can use them for debug purpose.

# 4. Complete sample :

```
\gdef\aLen{5}
\gdef\bLen{2}
\pgfmathsetmacro{\cLen}{sqrt(\aLen^2+\bLen^2)}
\tikzset{bleu/.style={fill=blue!30,fill opacity=0.5},rouge/.style={fill=red!30,fill opacity=0.5}} 

\tikzanim[poster=0,controls]{5}{
	\useasboundingbox(0,-\bLen)rectangle(\aLen+\bLen,\aLen) ;
}{
	\step[1]{0}[1]{
		
		\coordinate(A)at(0,0) ;
		\coordinate(B)at(\aLen,0) ;
		\coordinate(C)at(\aLen,\aLen) ;
		\coordinate(D)at(0,\aLen) ;
		
		\coordinate(E)at(\aLen+\bLen,0) ;
		\coordinate(F)at(\aLen+\bLen,\bLen) ;
		\coordinate(G)at(\aLen,\bLen) ;

		\path[name path=EC](E)--(C) ;
		\path[name path=FG](F)--(G) ;
		\path[name intersections={of=EC and FG,by=H}] ;

		\coordinate(I)at(0,\aLen-\bLen) ;
		\coordinate(J)at($(A)+(H)-(G)$);
		\fill[bleu] (C) -- (D) -- (I) -- cycle ;
	}
	\step{0}[4.0]{
		\fill[bleu] (I) -- (A) -- (J) -- cycle ;
	}
	\step{0}[5.0]{
		\fill[rouge] (E) -- (F) -- (H) -- cycle ;
	}
	\step{1}{
		\draw (A) -- (B) -- (C) -- (D) --cycle ;
		\draw (B) -- (E) -- (F) -- (G) --cycle ;
		
		\fill[bleu] (I) -- (J) -- (B) -- (C) -- cycle ;
		\draw (J) -- (B) -- (C) ; \draw[densely dotted] (C) -- (I) -- (J) ;
			
		\fill[rouge] (B) -- (E) -- (H) -- (G) -- cycle ;
		\draw (H) -- (G) -- (B) -- (E) ; \draw[densely dotted] (E) -- (H) ;
	}

	\step[5]{10}[1]{
		\coordinate(M)at($(C)!\framepos!(E)$);% Point à \framepos sur [CE]
		\coordinate(CM)at($(M)-(C)$) ;
		\coordinate(ICM)at($(I)+(CM)$);
		\coordinate(CCM)at($(C)+(CM)$);
		\coordinate(DCM)at($(D)+(CM)$);
		\coordinate(S)at(barycentric cs:I=1,C=1,D=1);
		\coordinate(S')at(barycentric cs:ICM=1,CCM=1,DCM=1);
		\fill[bleu] (ICM) -- (CCM) -- (DCM) -- cycle ;
		\draw[densely dotted] (ICM) -- (CCM) ;
		\draw (CCM) -- (DCM) -- (ICM) ;
		\draw[-latex](S)--(S') ;
	}
	
	\step{1}{
		\fill[bleu] (ICM) -- (CCM) -- (DCM) -- cycle ;
		\draw[densely dotted] (ICM) -- (CCM) ;
		\draw (CCM) -- (DCM) -- (ICM) ;
	}
	
	\step{10}[1]{
		\coordinate(N)at($(I)!\framepos!(C)$);% Point à \framepos sur [IC]
		\coordinate(IN)at($(N)-(I)$) ;
		\coordinate(IIN)at($(I)+(IN)$);
		\coordinate(JIN)at($(J)+(IN)$);
		\coordinate(AIN)at($(A)+(IN)$);
		\coordinate(T)at(barycentric cs:I=1,J=1,A=1);
		\coordinate(T')at(barycentric cs:IIN=1,JIN=1,AIN=1);
		\fill[bleu] (IIN) -- (JIN) -- (AIN) -- cycle ;
		\draw[densely dotted] (IIN) -- (JIN) ;
		\draw (JIN) -- (AIN) -- (IIN) ;
		\draw[-latex](T)--(T') ;
	}
	
	\step{1}{
		\fill[bleu] (IIN) -- (JIN) -- (AIN) -- cycle ;
		\draw[densely dotted] (IIN) -- (JIN) ;
		\draw (JIN) -- (AIN) -- (IIN) ;
	}
	
	\step{10}[1]{
		\coordinate(P)at($(H)!\framepos!(J)$);% Point à \framepos sur [HJ]
		\coordinate(HP)at($(P)-(H)$) ;
		\coordinate(EHP)at($(E)+(HP)$);
		\coordinate(FHP)at($(F)+(HP)$);
		\coordinate(HHP)at($(H)+(HP)$);
		\coordinate(U)at(barycentric cs:E=1,F=1,H=1);
		\coordinate(U')at(barycentric cs:EHP=1,FHP=1,HHP=1);
		\fill[rouge] (EHP) -- (FHP) -- (HHP) -- cycle ;
		\draw[densely dotted] (EHP) -- (HHP) ;
		\draw (EHP) -- (FHP) -- (HHP) ;
		\draw[-latex](U)--(U') ;
	}
	
	\step{1}{
		\fill[rouge] (EHP) -- (FHP) -- (HHP) -- cycle ;
		\draw[densely dotted] (EHP) -- (HHP) ;
		\draw (EHP) -- (FHP) -- (HHP) ;
	}
}
```
