How to compute RDF, EFPOT, EXCHEMPOT
1) Run MD simulations using NAMD-2.8 DCDE modified (md dir)
  - NAMD-2.8 DCDE modified is a variant of NAMD that generated dcde 
    instead of dcd. DCDE is a DCD format, not compatible with regular DCD analysis programs
    that contains complete information about lattices vectors additionally to DCD information.
    The source for this variant is in the tarball NAMD28dcde.tar.bz2 (modified routines) for NAMD_2.8_Source.tar.gz (Original NAMD 2.8 Sources)
    Replace files in original by my modified routines and compile normally.
2) Compute RDF using DNADF_CHARMM (rdf dir)
   dnadf_charmm source code is in rdf fir
3) Compute EFPOT using IMC-MACRO (imc dir)
  - use rdf2imc to convert rdf files into imc format input file (check max/min limit and number of each particle)
  - move or link kcl.rdf to setup folder 
  - IMC-MACRO is needed located in BROMOC folder (bromoc/imc-macro)
  - check for box vectors in boxvolume.dat in rdf and put them in genpot.in (setup) and iterate.sh (run)
  - generate first guess of potential (kcl-in.pot) using kcl.rdf, genpot.in and imc-macro (in setup) 
  - move of link kcl-in.pot generated to run
  - calc and calcf in same folder needed by the main iteration script
  - check all parameters and needed files and run iterate.sh
  - In bromoc/imc-macro/bin folder can be found 2 scripts to convert rdf and pot in imc format into a 
    xmgraceable file so to visualize with xmgrace to check if everything is Ok
4) Compute ExCHEMPOT using BROMOC and other scripts and programs (chempot dir)
  -Inside chempot dir follow instructions in note.txt file
