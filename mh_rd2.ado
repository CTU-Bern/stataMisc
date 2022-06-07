*! version 1.0.0 07jun2022
cap program drop mh_rd2
program mh_rd2, rclass
version 13.0
 
syntax varlist [, method(string) Level(cilevel)]

*method
if "`method'"=="" {
	local method="Sato0"
	dis "Default method used: Sato0"
}

*level
if "`level'"=="" {
	local level 95
}
local alpha = (100 - `level')/100
local conflev = `level'/100


*varlist
//local varlist fi group strata
tokenize `varlist'

qui levelsof `3', local(lev)
local wc: word count `lev'

local wsum 0
local numsum 0
local Qsum 0
local Psum 0
local var_MH_sum 0
foreach sg of local lev {

	qui count if `2'==0 & `3'==`sg' & !missing(`1')
	local n1=r(N)
	qui count if `1'==1 & `2'==0 & `3'==`sg'
	local x1=r(N)
	local p1=`x1'/`n1'
	
	qui count if `2'==1 & `3'==`sg' & !missing(`1')
	local n0=r(N)
	qui count if `1'==1 & `2'==1 & `3'==`sg'
	local x0=r(N)
	local p0=`x0'/`n0'
	
	local w=`n1'*`n0'/(`n1'+`n0')
	local wsum=`wsum'+`w'
	
	local num = (`x0'*`n1'-`x1'*`n0')/(`n0'+`n1')
	local numsum = `numsum' + `num'
	
	local P= (`n0'^2*`x1'-`n1'^2*`x0'+0.5*`n1'*`n0'*(`n1'-`n0'))/(`n1'+`n0')^2
	local Psum=`Psum'+`P'
	local Q=  (`x1'*(`n0'-`x0')+`x0'*(`n1'-`x1'))/(2*(`n1'+`n0'))
	local Qsum=`Qsum'+`Q'
	
	local var_MH = (`w')^2 * (`p1'*(1-`p1')/`n1' + `p0'*(1-`p0')/`n0')
	local var_MH_sum = `var_MH_sum' + `var_MH'
	//not defined in all Strata!
	
}

local delta_MH = `numsum'/`wsum'

if "`method'"=="Sato" | "`method'"=="GR" {

	if "`method'"=="Sato" {
		local var_delta_MH = (`delta_MH'*`Psum'+`Qsum')/`wsum'^2
	}
	else {
		local var_delta_MH=`var_MH_sum'/ (`wsum')^2
	}

	local se=sqrt(`var_delta_MH')
	local lci=`delta_MH' - invnormal(1-(1-`conflev')/2)*sqrt(`var_delta_MH')
	local uci=`delta_MH' + invnormal(1-(1-`conflev')/2)*sqrt(`var_delta_MH')
	local t = `delta_MH'/`se'
	local p = 2*(1-normal(abs(`t')))
	
	return scalar p =`p'
	return scalar t = `t'
	return scalar se =`se'
	return scalar uci=`uci'
	return scalar lci=`lci'
	return scalar rd=`delta_MH'
	return local method="`method'"
}	

if "`method'"=="Sato0" {

	local delta_mid = `delta_MH' + 0.5*invchi2(1,`conflev')*(`Psum'/`wsum'^2)
	local ME = sqrt((`delta_mid')^2 - (`delta_MH')^2 + invchi2(1,`conflev')*`Qsum'/`wsum'^2)
	local lci = `delta_mid' -`ME'
	local uci = `delta_mid' +`ME'
	//local pseudo_se = `ME'/invchi2(1,`conflev')
	local pseudo_se = `ME'/invnormal(1-(1-`conflev')/2)
	local t0 = `delta_MH'/sqrt(`Qsum'/`wsum'^2)
	local p = 2*(1-normal(abs(`t0')))
	
	return scalar p =`p'
	return scalar t = `t0'
	return scalar pseudo_se =`pseudo_se'
	return scalar uci=`uci'
	return scalar lci=`lci'
	return scalar rd_mid=`delta_mid'
	return scalar rd=`delta_MH'
	return local method="`method'"

}


*pvalue for homogeneity
local chi2hom=0
local counter=0

foreach sg of local lev {
	
	local lb: label (`3') `sg'
	
	qui count if `2'==0 & `3'==`sg' & !missing(`1')
	local n1=r(N)
	qui count if `1'==1 & `2'==0 & `3'==`sg'
	local x1=r(N)
	local p1=`x1'/`n1'
	
	qui count if `2'==1 & `3'==`sg' &  !missing(`1')
	local n0=r(N)
	qui count if `1'==1 & `2'==1 & `3'==`sg'
	local x0=r(N)
	local p0=`x0'/`n0'
	
	local w=`n1'*`n0'/(`n1'+`n0')
	local wsum=`wsum'+`w'
	
	local num = (`x0'*`n1'-`x1'*`n0')/(`n0'+`n1')
	local numsum = `numsum' + `num'
	
	local P= (`n0'^2*`x1'-`n1'^2*`x0'+0.5*`n1'*`n0'*(`n1'-`n0'))/(`n1'+`n0')^2
	local Psum=`Psum'+`P'
	local Q=  (`x1'*(`n0'-`x0')+`x0'*(`n1'-`x1'))/(2*(`n1'+`n0'))
	local Qsum=`Qsum'+`Q'
	
	local var_MH = (`w')^2 * (`p1'*(1-`p1')/`n1' + `p0'*(1-`p0')/`n0')
	local var_MH_sum = `var_MH_sum' + `var_MH'
	//not defined in all Strata!
	
	local rdi=`p0'-`p1'
	local var_rdi=`p0'*(1-`p0')/`n0' + `p1'*(1-`p1')/`n1' 
	
	//chi2 for homogeneity
	if `var_rdi'!=0 & `rdi'!=. {
		local chi2hom= `chi2hom' + (`rdi'-`delta_MH')^2/`var_rdi'
		//local chi2hom= `chi2hom' + (`rdi'-`delta_MH')^2/`var_MH'
		local counter=`counter' + 1
	}
	else {
		dis "Empty strata for level `sg': `lb'"
	}
}

local df=`counter'-1
local pv=1-chi2(`df',`chi2hom')

return scalar df_hom=`df'
return scalar chi2_hom=`chi2hom'
return scalar p_hom=`pv'



end


