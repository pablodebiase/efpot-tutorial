#!/bin/bash
# 153 ions / 216174.946793306 A^3 * 1660.5388631270122099 = 1.17526313677 Molar KCl
list='1 2 3 4 5 6 7 8 9 10 11 12 13 14 15 16 17 18 19 20 21 22 23 24 25 26 27 28 29 30 31 32 33 34 35 36 37 38 39 40 41 42 43 44 45 46 47 48 49 50'
inpfile=kcl.in
outfile=kcl.out
filpot=kcl-in.pot
fout=kcl-out.pot
nmks=10100000
nmksa=1000000
regp=0.30
regpa=-0.006
for i in $list; do
cat << EOF > $inpfile
 NMKS=20100000,
 &INPUT
 IPRINT=5,
 NMKS=$nmks,
 NMKS0=100000,
 LPOT=.t.,
 LDMP=.f.,
 LRST=.f.,
 FILRDF='kcl.rdf',
 FILPOT='kcl-in.pot',
 FOUT='kcl-out.pot',
 FDMP='kcl.dmp',
 RSTFQ=100000,
 WXYZ=.f.,
 WXYZNM='kcl-out.xyz',
 WXYZFQ=100000,
 AF=3.,
 FQ=19.,
 EPS=78.3,
 TEMP=300.0,
 B1X= 63.0131,
 B1Y=-12.6027,
 B1Z=-12.6027,
 B2X=-12.6027,
 B2Y= 63.0131,
 B2Z=-12.6027,
 B3X=-12.6027,
 B3Y=-12.6027,
 B3Z= 63.0131,
 DR=5.,
 IOUT=1000,
 IAV=0,
 REGP=$regp,  
 DPOTM=0.25,
 RTM=10.0,
 ISEED=0,
 RXYZ=.f.,
 RXYZNM='kcl-in.xyz',
 ZEROMOVE=0.10,
 LZM=.t.,
 LDMPPOT=.f.,
 LELEC=.f.,
 LRESPOT=.f.,
 RESPOTNM='kcl-fix.pot',
 LSEPPOT=.t.,
 LSEPRDF=.t.
 &END
EOF
date
echo $i $nmks $regp
./imc-macro < $inpfile > $outfile
mkdir $i
cp * $i &> /dev/null
cp $fout $filpot &> /dev/null
nmks=$(./calc $nmks + $nmksa)
regp=$(./calcf $regp + $regpa)
done
