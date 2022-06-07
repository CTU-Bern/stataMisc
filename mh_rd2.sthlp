{smcl}
{* *! version 1.0.0  07jun2022}{...}
{hline}
{cmd:help mh_rd2} 
{hline}

{title:Title}

{phang}
{bf:mh_rd2} {hline 2} Mantel-Haenszel risk difference.


{marker syntax}{...}
{title:Syntax}

{p 4 6 2}
{cmdab:mh_rd2} {it:{help varlist:varlist}} [, {it:options}]

{synoptset 25 tabbed}{...}
{synopthdr}
{synoptline}
{syntab:Main}
{synopt:{opt method}}method for confidence interval calculation, Sato0 (default), Sato or GR {p_end}
{synopt:{opt l:evel(#)}}set confidence level; default is {cmd:level(95)}{p_end}
{synoptline}

{marker description}{...}
{title:Description}

{pstd}
{cmd:mh_rd2} calculates the statified Mantel-Haenszel risk difference 
	with different confidence intervals. 
	Needs three variables as input, a binary dependent variable, a binary indpendent (group) variable 
		and a categorical strata variable.
	Confidence intervals are based on code given in {help mh_rd2##Klingenberg2014:Klingenberg, 2014}.
	

{marker options}{...}
{title:Options}

{dlgtab:Main}

{phang}
{opt l:evel(#)} set confidence level; default is {cmd:level(95)}

{phang}
{opt method} method for confidence interval calculation, either
	Sato0 (default, {help mh_rd2##Klingenberg2014:Klingenberg, 2014}), 
	Sato ({help mh_rd2##Sato1989:Sato, 1989})
	or GR ({help mh_rd2##Greenland1985:Greenland and Robbins, 1985}).

{marker results}{...}
{title:Stored results}

{synoptset 22 tabbed}{...}
{p2col 5 22 19 2: Scalars}{p_end}
{synopt:{cmd:r(rd)}}stratified risk difference{p_end}
{synopt:{cmd:r(rd_mid)}}mid-point risk difference (if method==Sato0){p_end}
{synopt:{cmd:r(se)}}standard error (if method!=Sato0){p_end}
{synopt:{cmd:r(pseudo_se)}}pseudo standard error (if method==Sato0){p_end}
{synopt:{cmd:r(t)}}t-statistic{p_end}
{synopt:{cmd:r(p)}}p-value{p_end}
{synopt:{cmd:r(p_hom)}}p-value for homogeneity{p_end}
{synopt:{cmd:r(chi2_hom)}}chi squared statistic for homogeneity{p_end}
{synopt:{cmd:r(df_hom)}}degrees of freedom for homogeneity{p_end}

{marker examples}{...}
{title:Examples}

{phang2}{cmd:. webuse lbw}{p_end}
{phang2}{cmd:. mh_rd2 low smoke race}{p_end}
{phang2}{cmd:. return list}{p_end}
{phang2}{cmd:. mh_rd2 low smoke race, method(Sato)}{p_end}
{phang2}{cmd:. return list}{p_end}

{marker references}{...}
{title:References}

{marker Greenland1985}{...}
{phang}
Greenland S, Robins JM. 1985.
Estimation of a common effect parameter from sparse follow-up data. 
{it:Biometrics} 41:55–68.

{marker Sato1989}{...}
{phang}
Sato T. 1989 
On the variance estimator for the Mantel–Haenszel risk difference (letter). 
{it: Biometrics} 45:1323–1324.

{marker Klingenberg2014}{...}
{phang}
Klingenberg, B. 2014.
A new and improved confidence interval for the Mantel–Haenszel risk difference
{it: Statistics in medicine} 33:2968–2983


