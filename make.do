// the 'make.do' file is automatically created by 'github' package.
// execute the code below to generate the package installation files.
// DO NOT FORGET to update the version of the package, if changed!
// for more information visit http://github.com/haghish/github


*run test
//cd "test"

//do "00_masterfile.do"


*generate make file 
//cd ".."

make stataMisc, replace toc pkg version(1.0.0)                           ///
     license("Academic Free License v3.0")                                   ///
     author("Lukas Bütikofer")                                              ///
     affiliation("CTU Bern")                                                 ///
     email("lukas.buetikofer@ctu.unibe.ch")                                  ///
     url("https://github.com/CTU-Bern/stataMI")                               ///
     title("stataMI")                                                         ///
     description("Miscellaneous stata programs")                                           ///
     install("mh_rd2.ado;mh_rd2.sthlp") ///
     ancillary("")                                                         
