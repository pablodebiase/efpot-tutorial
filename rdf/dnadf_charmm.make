#gfortran -ffpe-trap=invalid,zero,overflow -fbacktrace -g -fcheck=all -ffree-line-length-none -static -o dnacdf_charmm dnacdf_charmm.f90
#gfortran -ffree-line-length-none -static -o dnacdf_charmm dnacdf_charmm.f90
ifort -ip -O3 -static -xHost -o dnadf_charmm dnadf_charmm.f90
rm comun.mod
