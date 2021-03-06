PRCHREC7 ;WISC/RWS-CODE SHEET GENERATOR - DEPOT TRANSACTIONS ;10-24-91/10:10
V ;;5.1;IFCAP;;Oct 20, 2000
 ;Per VHA Directive 10-93-142, this routine should not be modified.
 ;
LOG ;CREATE LOG CODE SHEETS
 N D0,I D:'$D(PRCHDEP) VOUCHER Q:'PRCHDEP
 S PRCFA("DEL")=$P(^PRC(442,PRCHPO,0),U,10),PRCFA("LBN")=$P(^(0),U,1),PRCFA("ISSUE")=$P(^(2,+PRCHRIT,0),U,3),PRCFA("MULT")=$P(^(0),U,12),Y=$P(^(0),U,13),PRCFA("NSN")=$E(Y,6,7)_$E(Y,9,11)_$E(Y,13,17),PRCFA("FSC")=Y
 S Y=$P(PRCHDEP,U,2),PRCFA("LDATE")=$E(Y,4,7)_$E(Y,2,3),PRCFA("SITE")=$S($E(PRCHDEP)=2:"79A",$E(PRCHDEP)=3:"794",1:"793"),PRCFA("TTLEN")=80
 S PRCHLOG="",PRCFA("SYS")="LOG",PRCFA("TT")=$S($D(PRCHNRQ):"431",1:"434"),PRCFA("REF")=$E($P($P(^PRC(442,PRCHPO,0),U,1),"-",2),2,6),PRCF("X")="P",PRCFA("EDIT")="[PRCHL"_PRCFA("TT")_"]"
 D:PRCHRTP PRINT D ^PRCFSITE G:'% OUT D NEWCS^PRCFAC G:'$D(DA) OUT S $P(^PRC(442,PRCHPO,2,+PRCHRIT,3,PRCHRDY,0),U,6)=DA,^PRC(442,PRCHPO,2,+PRCHRIT,3,"AB",DA,PRCHRDY)=""
 S X1=+PRCHRIT_"^^"_PRCHRQ_U_"^^^"_PRCFA("DEL")_"^^"_PRCFA("NSN"),PRCFA("LBN")=PRCFA("LBN")_"."_$P(PRCHRIT,U,1)
 S Z=$P(PRCHDEP,U,2)_U_"^^^^^^^^"_PRCFA("MULT")_"^^"_PRCHRAM_"^^^"_PRCFA("SITE")
 S ^PRCF(423,DA,300)=X1,^(304)=Z,$P(^(301),U,15)=PRCFA("REF"),$P(^(301),U,38)=+PRCHDEP
 ;
VOU S DIE="^PRCF(423,",DR="[PRCH-REC7 LOG 431/434]" D ^DIE,^PRCFACX1
 ;
OUT K %,B,D,D0,DA,DG,DIC,DIE,DIG,DIH,DIU,DIV,DIW,DLAYGO,DQ,DR,J,K,M,N,PRCFA,PRCFASYS,Q,Q1,S,X,XL1,Y,Z
 Q
 ;
VOUCHER ;SELECT VOUCHER NUMBER
 ;
Q1 R !!,"LOG DATE: TODAY//",X:DTIME G:X="^"!'$T OUT S %DT="EX",%DT(0)="-NOW" S:X="" X="TODAY" D ^%DT K %DT G:Y<0 Q1 S PRCFA("LDATE")=Y
 ;
Q2 R !!,"DEPOT: HINES//",X:DTIME G:X="^"!'$T OUT S PRCHDEP=$S("793HINES"[X:"4","794SOMMERVILLE"[X:"2","79ABELL"[X:"3",1:""),X=PRCHDEP G:'PRCHDEP Q2 W " ("_$S(X=4:"HINES)",X=3:"BELL)",1:"SOMMERVILLE)")
 S X=PRC("SITE")_"-"_PRC("FY")_"-"_"DVCODE"_+PRCHDEP,DIC="^PRCS(410.1,",DIC(0)="Z" I '$D(^PRCS("410.1","B",X)) S DIC("DR")="1////1" D FILE^DICN
 D ^DIC S Y(1)=$P(Y(0),U,2),PRCHDEP=PRCHDEP_$E("000",$L(Y(1)),3)_Y(1)_U_PRCFA("LDATE"),DIE=DIC,DA=+Y,DR="1////"_(Y(1)+1)_";2///T" D ^DIE K DIC,X,Y
 W !!,"This session has been assigned Depot Voucher Number ",+PRCHDEP
 Q
 ;
PRINT W !,"UNIT OF PRCH: ",$P($G(^PRCD(420.5,PRCFA("ISSUE"),0)),U,1),"        QTY ORDERED: ",PRCHRQ1,"        PREVIOUSLY RECEIVED: ",PRCHRQ2,!?3,"QTY BEING RECEIVED: ",PRCHRQ,!
 Q
 ;
EXP I PRCFA("FSC")?1"89".E,X>$P(PRCHDEP,U,2) K X Q
 I PRCFA("FSC")?1"6505".E,Y<$P(PRCHDEP,U,2) K X
 Q
