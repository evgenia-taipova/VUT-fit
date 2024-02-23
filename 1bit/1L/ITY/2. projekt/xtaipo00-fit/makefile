\documentclass[a4paper,11pt,twocolumn]{article}

\usepackage[utf8]{inputenc}
\usepackage[czech]{babel}
\usepackage[IL2]{fontenc}
\usepackage[utf8]{inputenc}
\usepackage{times}
\usepackage{bm}
\usepackage[left=1.5cm,text={18cm, 25cm},top=2.5cm]{geometry}
\usepackage{amsmath,amsfonts,amssymb,amsthm,mathtools}

\newtheorem{definition}{Definice}
\newtheorem{sentence}{Věta}


\begin{document}

	\begin{titlepage}
    \begin{center}

        \Huge \textsc{Fakulta informačních technologií\\
                      Vysoké učení technické v~Brně} \\
                      
            \vspace{\stretch{0.382}}
        \LARGE Typografie a~publikování\,--\,2. projekt \\
               Sazba dokumentů a~matematických výrazů \\
               
            \vspace{\stretch{0.618}}

     \end{center}

        {\Large 2021 \hfill
       Taipova Evgeniya(xtaipo00)}

    \end{titlepage}
	
\section*{Úvod}
V~této úloze si vyzkoušíme sazbu titulní strany, matematic\-kých vzorců, prostředí a~dalších textových struktur obvyklých pro technicky zaměřené texty (například rovnice (\ref{eq_1}) nebo Definice \ref{lem_1} na straně \pageref{lem_2}). Rovněž si vyzkoušíme používání odkazů \verb|\ref| a \verb|\pageref|.

Na titulní straně je využito sázení nadpisu podle optického středu s~využitím zlatého řezu. Tento postup byl probírán na přednášce. Dále je použito odřádkování se zadanou relativní velikostí 0.4\,em a~0.3\,em.

V~případě, že budete potřebovat vyjádřit matematickou konstrukci nebo symbol a~nebude se Vám dařit jej nalézt v~samotném \LaTeX u, doporučuji prostudovat možnosti balíku maker \AmS-\LaTeX.

\section{Matematický text}
Nejprve se podíváme na sázení matematických symbolů a~výrazů v~plynulém textu včetně sazby definic a~vět s~využitím balíku \texttt{amsthm}. Rovněž použijeme poznámku pod čarou s~použitím příkazu \verb|\footnote|. Někdy je vhodné použít konstrukci \verb|\mbox{}|, která říká, že text nemá být zalomen.



\begin{definition}
    \label{lem_1} 
	\emph{Rozšířený zásobníkový automat} (RZA) je definován jako sedmice tvaru $A = (Q, \Sigma, \Gamma, \delta, q_{0}, Z_{0}, F),$
	kde:

\begin{itemize}
\item [$\bullet$] $Q$ je konečná množina \emph{vnitřních (řídicích) stavů,}
\item  [$\bullet$]$\Sigma$ je konečná \emph{vstupní abeceda,}

\item [$\bullet$] $\Gamma$ je konečná \emph{zásobníková abeceda,}

\item  [$\bullet$]$\delta$ je \emph{přechodová funkce} $Q \times(\Sigma \cup\{\epsilon\}) \times \Gamma^{*} \rightarrow 2^{Q \times \Gamma^{*}}$,

\item [$\bullet$] $q_{0}$ $\in$ $Q$ je \emph{počáteční stav},$Z_{0}$ $\in$ $\Gamma$ je \emph{startovací symbol zásobníku} a~$F$ $\subseteq$ $Q$  je množina \emph{koncových stavů.}

\end{itemize}
	
\emph{Nechť $P = (Q,\Sigma, \Gamma, \delta, q_{0}, Z_{0}, F)$ je rozšířený zásobníkový automat.} Konfigurací \emph{nazveme trojici} $(q, w, \alpha) \in Q \times \Sigma^{*} \times \Gamma^{*}$, \emph{kde $q$ je aktuální stav vnitřního řízení,  $w$ je dosud nezpracovaná část vstupního řetězce a $\alpha$ = $Z_{i_{1}}Z_{i_{2}} \dots Z_{i_{k}}$
je obsah zásobníku\footnote{$Z_{i_{1}}$ je vrchol zásobníku}}.

\end{definition}

\subsection{Podsekce obsahující větu a~odkaz}

\begin{definition}
    
		\label{lem_2} 
		\emph{Řetězec $w$ nad abecedou $\Sigma$ je přijat RZA} $A$ jestliže $(q_{0},w, Z_{0}) \overset{*}{\underset{A}\vdash}    (q_{F} ,\epsilon , \gamma)$ pro nějaké $\gamma \in \Gamma^{*}$ a $q_{F} \in F$. Množinu $L(A) = \{w\,\mid\, w$ je přijat RZA $A$\} $\subseteq$ $\Sigma^{*}$ nazýváme \emph{jazyk přijímaný RZA} $A$.

\end{definition}
Nyní si vyzkoušíme sazbu vět a~důkazů opět s~použitím balíku \texttt{amsthm}.
\begin{sentence}
		\label{sentence_1}
	Třída jazyků, které jsou přijímány ZA, odpovídá \emph{bezkontextovým jazykům}.

	\end{sentence}
	
	\begin{proof}
	V~důkaze vyjdeme z~Definice \ref{lem_1} a \ref{lem_2}. 
	\end{proof}
	
\section{Rovnice a~odkazy}	
Složitější matematické formulace sázíme mimo plynulý
text. Lze umístit několik výrazů na jeden řádek, ale pak je
třeba tyto vhodně oddělit, například příkazem \verb|\quad|.

$$ \sqrt[i]{x_{i}^{3}} \textup{\quad kde $x_{i}$ je $i$-té sudé číslo splňující\quad} x_{i}^{x_{i}^{i^{2}}+2} \leq y_{i}^{x^{4}} $$

V rovnici (\ref{eq_1}) jsou využity tři typy závorek s~různou explicitně definovanou velikostí.
\bigskip
\begin{eqnarray}
\label{eq_1} x&=& \bigg[ \Big\{ \big[a+b\big] * c\Big\}^{d} \oplus 2\bigg]^{3 / 2}\\
\nonumber
y&=&\lim _{x \rightarrow \infty} \frac{\frac{1}{\log _{10} x}}{\sin ^{2} x+\cos ^{2} x}
\end{eqnarray}
\par
V~této větě vidíme, jak vypadá implicitní vysázení limity $\lim_{n\to\infty} f(n) $ v~normálním odstavci textu. Podobně je to i~s~dalšími symboly jako $\prod_{i=1}^{n} 2^{i}$ či $\bigcap_{A \in \mathcal{B}} A$. V~případě vzorců $\lim\limits_{n\to\infty} f(n)$ a $
\prod\limits_{i=1}^{n} 2^{i}$ jsme si vynutili méně
úspornou sazbu příkazem \verb|\limits|.
\bigskip

\begin{equation}
\int_{b}^{a} g(x) \mathrm{d} x=-\int_{a}^{b} f(x) \mathrm{d} x
\end{equation}

 
\section{Matice}
Pro sázení matic se velmi často používá prostředí \texttt{array} a~závorky (\verb|\left|, \verb|\right|).
\begin{center}

$\left(\begin{array}{ccc}
a-b & \widehat{\xi+\omega} & \pi \\
\vec{\mathbf{a}} & \overleftrightarrow{A C} & \hat{\beta}
\end{array}\right)=1 \Longleftrightarrow \mathcal{Q}=\mathbb{R}$\\
\bigskip
$\mathbf{A}=\left\|\begin{array}{cccc}
a_{11} & a_{12} & \ldots & a_{1 n} \\
a_{21} & a_{22} & \ldots & a_{2 n} \\
\vdots & \vdots & \ddots & \vdots \\
a_{m 1} & a_{m 2} & \ldots & a_{m n}
\end{array}\right\|=\left|\begin{array}{cc}
t & u \\
v & w
\end{array}\right|=t w\!-\!u v$
\end{center}
\par
Prostředí \texttt{array} lze úspěšně využít i~jinde.
\begin{center}
$\begin{pmatrix} 
n\\
k 
\end{pmatrix}=\left\{\begin{array}{cl}
0 & \text { pro } k<0 \text { nebo } k>n \\
\frac{n !}{k !(n-k) !} & \text { pro } 0 \leq k \leq n
\end{array}\right.$.
\end{center}
\end{document}
