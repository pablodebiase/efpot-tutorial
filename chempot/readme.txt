How to compute excess chemical potentials

* Introduction
-The strategy for computing excess chemical potential for a given concentration range is to search by trying several mu for each concentration until the desired concentration matches the obtained concentration. We will create folders corresponding to the desired concentrations and inside subfolders for the trial mu. 

* Preparation (go to folder chempot)
-Efpot and bromoc are needed
-tools (calcf.f90,calc-mu.f90,conc-bromoc.f90,fit-it.f90,stat.f90) in bromoc/tools/src 
-scripts (calcconc.bash,calcmu.bash,domore.bash,getall.bash,getres.bash,maketable.bash,mudatcalc.bash,calcconc-rf.bash,calcmu-rf.bash,rf4all.bash) in bromoc/tools/scripts needed
-echempot range depends on size of the box
-For 0.1 to 3 M range a box of 60x60x60 A can be used (edit calcmu.bash and efpot.inp for a different box specially at lower or higher concentrations)
-compile all .f90 files and make executables available through PATH or edit scripts and use full path for programs
-check/change paths of all program in bash scripts or do "export PATH=$PATH:$HOME/bromoc/tools/scripts"

*First Step
(Try a concentration and variate mu, determine real concentration, extrapolate mu, fit function and get mu for any concentration)

-Decide range of concentration for example 0.1 to 3 M in a 60x60x60 box do
   calcconc.bash 1 9 1 1 20 1 60 60 60 100 100
                     ^- Concentration Step
                   ^- Concentration end
                 ^- Concentration start
   calcconc.bash 10 100 10 1 60 1 60 60 60 100 100
                                ^ Mu step
                              ^ mu end
                           ^ mu start
   calcconc.bash 110 200 10 20 60 1 60 60 60 100 100
                                    ^  ^  ^ box dimension
   calcconc.bash 225 300 25 36 65 1 60 60 60 100 100
                                              ^   ^- mu is calculated by dividing by this number
                                              |_ Concentration is calculated by dividing by this number
                                                 (example: if you need mu of 1e-3 use 10 10 1 1 1 1 60 60 60 100 1000)
(check "domore.bash" script for more examples)
 This will generate several folders 1 2 ... 9 + 10 20 ... 300 with several subfolders inside
 from 1 to 20 for (1-9) etc
 This example may take a lot of time so better is to choose the $4 and $5 parameter low and then do more according to the obtained results.
 The first folders represent the molar concentration x 100 to be used.
Each subfolder inside each folder represent  mu x 100 to be tried.
in each subfolder a bromoc simulation will be run using the concentration of the folder and the mu in each subfolder.
This script will do almost everything but you need to do some manual adjustments (see next)

-The script calcmu.bash will do the job of generating bromoc inputs and generating trajectories.
If you need to run more mu the command will be for example inside folder 1 (0.01 Molar)
You want to make more simulations of mu from 0.1 to 0.15 so 
enter into concentration directory and do for a 60x60x60 box 
$ calcmu.bash 10 15 1 60 60 60 100
This will make 10 11 12 13 14 15 (1 is the step)
Then you need to count the real number of ions generated for each mu at the 0.01 M and calculate concentration for each mu
For that you use this script:
$ mudatcalc.bash
This script will make a table with all mu vs concentration measured for each ion (mu-conc.dat).
Here is when you need to do manual adjustments.
Check the table. You need to see that the concentration, let say 0.01 M, is more or less in the middle of the table. 
So you will need to do more ./calcmu.bash until you get this.
NOTE: the larger is mu and concentration the longer are bromoc simulations
NOTE2: if the number of particles in the sub-subfolders in conc-*-efpot.dat files is lower than 10 you should recompute with a bigger box in that cases
NOTE3: if you need mu in the order of 1e-3 use
$ calcconc.bash 1 10 1 1 200 5 200 200 200 100 1000


-Once you got the expected result in previous step run
$ getres.bash
This script will fit this table result and extrapolate mu for each ion for the working concentration (0.01)

-Repeat this two steps for all concentrations

- getall.bash script can be used to calculate mu for each concentration automatically once all mu subfolders are generated
(this script cannot generate more mu subfolders).
 This script will also generate a table with concentration vs mu for each ion (conc-mu.dat)

-With conc-mu.dat we are able now to extrapolate any mu data from given concentration for each ion
 (check mix folder to see an example)
 It is usefull to include in conc-mu.dat the point 0 conc and 0 mu that is where the function  must start to get better fitting
 Now once conc-mu.dat data is coherent use this command and program to obtain mu at given concentration (2 M):
$ fit-it conc-mu.dat 5 2
5 is the number of parameters for the trial function that will use to fit the data.

- In case you need to generate a table with several values you can use the script "maketable.bash" (see also mix folder for an example)
just running the program will work and the table will be in table-conc-mu.dat

* Example of how to compute Excess chemical potential with reaction field

-Create a working directory and go
$ mkdir rfpar; cd rfpar

-Create static and rfpar maps for all concentrations and choose box
 0.1 M is computed as 10 / 100
 0.2 M is computed as 20 / 100 
 and so on
$ rf4all.bash 60x60x60 100 10,20,40,60,80,100,125,150
 wait until all pb-pnp process finish

- If you are not already there go to
$ cd 60x60x60

- Place or link potential files
$ ln -s path/cla-cla.pot
$ ln -s path/cla-pot.pot
$ ln -s path/pot-pot.pot

-Now run calcconc-rf.bash is equivalent to calcconc.bash but designed to use static and rfpar
$ nohup calcconc-rf.bash  10  10  1   1   9  1 60 60 60 100 1000 &
$ nohup calcconc-rf.bash  10  10  1  10 100 10 60 60 60 100 1000 &
$ nohup calcconc-rf.bash  10  10  1 110 300 10 60 60 60 100 1000 &
$ nohup calcconc-rf.bash  20 100 20   1   9  1 60 60 60 100 1000 &
$ nohup calcconc-rf.bash  20 100 20  10 100 10 60 60 60 100 1000 &
$ nohup calcconc-rf.bash  20 100 20 110 300 10 60 60 60 100 1000 &
$ nohup calcconc-rf.bash  60 100 20 310 400 10 60 60 60 100 1000 &
$ nohup calcconc-rf.bash  60 100 20 410 500 10 60 60 60 100 1000 &
$ nohup calcconc-rf.bash 125 150 25  10 200 10 60 60 60 100 1000 &
$ nohup calcconc-rf.bash 125 150 25 210 300 10 60 60 60 100 1000 &
$ nohup calcconc-rf.bash 125 150 25 310 400 10 60 60 60 100 1000 &
$ nohup calcconc-rf.bash 125 150 25 410 500 10 60 60 60 100 1000 &
$ nohup calcconc-rf.bash 125 150 25 510 600 10 60 60 60 100 1000 &
$ getall.bash 100 1000 force
$ maketable.bash 1 1500 1 1000
