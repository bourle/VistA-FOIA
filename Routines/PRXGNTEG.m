PRXGNTEG ;ISC/XTSUMBLD KERNEL - Package checksum checker ;2960212.162124
 ;;5.0;IFCAP;**41**;4/21/95
 ;;7.3;2960212.162124
 S XT4="I 1",X=$T(+3) W !!,"Checksum routine created on ",$P(X,";",4)," by KERNEL V",$P(X,";",3),!
CONT F XT1=1:1 S XT2=$T(ROU+XT1) Q:XT2=""  S X=$P(XT2," ",1),XT3=$P(XT2,";",3) X XT4 I $T W !,X X ^%ZOSF("TEST") S:'$T XT3=0 X:XT3 ^%ZOSF("RSUM") W ?10,$S('XT3:"Routine not in UCI",XT3'=Y:"Calculated "_$C(7)_Y_", off by "_(Y-XT3),1:"ok")
 ;
 K %1,%2,%3,X,Y,XT1,XT2,XT3,XT4 Q
ONE S XT4="I $D(^UTILITY($J,X))",X=$T(+3) W !!,"Checksum routine created on ",$P(X,";",4)," by KERNEL V",$P(X,";",3),!
 W !,"Check a subset of routines:" K ^UTILITY($J) X ^%ZOSF("RSEL")
 W ! G CONT
ROU ;;
PRC0F ;;1247664
PRCFARR ;;11626100
PRCHDAM1 ;;6408863
PRCHDAM3 ;;8068677
PRCHDP1 ;;14237702
PRCHDP5 ;;6253199
PRCHDP7 ;;8216762
PRCHDSP ;;8856429
PRCHDSP2 ;;8941110
PRCHDSP4 ;;6574502
PRCHDSP6 ;;7919614
PRCHFPNT ;;7114681
PRCHP18 ;;12388574
PRCHPAM ;;17483245
PRCHPAM2 ;;6728575
PRCHPAM4 ;;8070892
PRCHPAM8 ;;18184792
PRCHRPT7 ;;6634242
PRCOE1 ;;11646112
PRCOEC1 ;;20277043
PRCOEDC ;;1966903
PRCOEDI ;;3791471
PRCOPHA1 ;;2965485
PRXGI001 ;;10161764
PRXGI002 ;;9624616
PRXGI003 ;;4361531
PRXGINI1 ;;4855580
PRXGINI2 ;;5232623
PRXGINI3 ;;16808126
PRXGINI4 ;;3357795
PRXGINI5 ;;556150
PRXGINIS ;;2216347
PRXGINIT ;;10222160