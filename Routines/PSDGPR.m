PSDGPR ;BIR/CML,JPW-Print NAOU Inventory Group List ; 2 Aug 94
 ;;3.0; CONTROLLED SUBSTANCES ;;13 Feb 97
 I '$D(PSDSITE) D ^PSDSET Q:'$D(PSDSITE)
 D NOW^%DTC S PSDT=$P(%,".")
 W !!!,"This report shows data stored for NAOU Inventory Groups.",!!,"Right margin for this report is 80 columns.",!,"You may queue the report to print at a later time.",!!
 I '$O(^PSI(58.2,0)) W !,"You MUST create Inventory Groups before running this report!" K %,%I,%H Q
DEV K %ZIS,IOP S %ZIS="QM",%ZIS("B")="" D ^%ZIS I POP W !,"NO DEVICE SELECTED OR REPORT PRINTED!" G QUIT
 I $D(IO("Q")) K IO("Q") S PSDIO=ION,ZTIO="" K ZTSAVE,ZTDTH,ZTSK S ZTRTN="ENQ^PSDGPR",ZTDESC="Compile Data for NAOU Inventory Groups",ZTSAVE("PSDIO")="",ZTSAVE("PSDT")="",ZTSAVE("PSDSITE")=""
 I  D ^%ZTLOAD K ZTSK G QUIT
 U IO
 ;
ENQ ;ENTRY POINT WHEN QUEUED
INVG K ^TMP("PSDGPR",$J) F INVG=0:0 S INVG=$O(^PSI(58.2,INVG)) G:('INVG)&($D(ZTQUEUED)) PRTQUE G:'INVG PRINT D BUILD
 ;
BUILD ;BUILD DATA ELEMENTS
 I $S('$D(^PSI(58.2,INVG,0)):1,^(0)="":1,'$O(^(0)):1,1:0) S DIK="^PSI(58.2,",DA=INVG D ^DIK K DIK Q
 F NAOU=0:0 S NAOU=$O(^PSI(58.2,INVG,3,NAOU)) Q:'NAOU  I $D(^(NAOU,0)) F TYPE=0:0 S TYPE=$O(^PSI(58.2,INVG,3,NAOU,1,TYPE)) Q:'TYPE  I $D(^(TYPE,0)) D SETGL
 Q
SETGL ;
 Q:$P($G(^PSD(58.8,NAOU,0)),"^",3)'=+PSDSITE
 S ANM=$S($D(^PSD(58.8,NAOU,0)):$P(^(0),"^"),1:"NAOU NAME MISSING"),TYPENM=$S($D(^PSI(58.16,TYPE,0)):$P(^(0),"^"),1:"TYPE NAME MISSING"),GNM=^PSI(58.2,INVG,0),INACT=""
 I $D(^PSD(58.8,NAOU,"I")),^("I")]"",^("I")'>DT S INACT="I"
 S ^TMP("PSDGPR",$J,GNM,ANM_"^"_INACT,TYPENM)=""
 Q
 ;
PRTQUE ;AFTER DATA IS COMPILED, QUEUE THE PRINT
 K ZTSAVE,ZTIO S ZTIO=PSDIO,ZTRTN="PRINT^PSDGPR",ZTDESC="Print Data for Inventory Group List",ZTDTH=$H,ZTSAVE("^TMP(""PSDGPR"",$J,")=""
 D ^%ZTLOAD K ^TMP("PSDGPR",$J) G QUIT
PRINT ;
 K LN S $P(LN,"-",80)="",(PG,PSDOUT)=0,%DT="",(GNM,ANM,TYPENM)="",X="T" D ^%DT X ^DD("DD") S HDT=Y D HDR
 I '$D(^TMP("PSDGPR",$J)) W !?17,"***** NO DATA AVAILABLE FOR THIS REPORT *****" G QUIT
 F LL=0:0 S GNM=$O(^TMP("PSDGPR",$J,GNM)) Q:GNM=""!(PSDOUT)  D:$Y+4>IOSL PAGE Q:PSDOUT  W !!,"=> ",GNM F LL=0:0 S ANM=$O(^TMP("PSDGPR",$J,GNM,ANM)) Q:ANM=""!(PSDOUT)  D:$Y+4>IOSL PAGE Q:PSDOUT  W !?13,$P(ANM,"^") D WRTDATA Q:PSDOUT
DONE I $E(IOST)'="C" W @IOF
 I $E(IOST,1,2)="C-",'PSDOUT W ! K DIR,DIRUT S DIR(0)="EA",DIR("A")="END OF REPORT!  Press <RET> to return to the menu" D ^DIR K DIR
QUIT ;
 K %DT,DTOUT,NAOU,ANM,HDT,INACT,INVG,GNM,LL,LN,PG,PSDT,TYPE,TYPENM,X,Y,PSDIO,ZTSK,ZTDESC,ZTRTN,ZTIO,DA,IO("Q"),%,%I,%H,ANS,PSDOUT,POP
 K ^TMP("PSDGPR",$J) D ^%ZISC
 S:$D(ZTQUEUED) ZTREQ="@" Q
WRTDATA ;DATA LINES
 I $P(ANM,"^",2)="I" W "          *** INACTIVE ***"
 F LL=0:0 S TYPENM=$O(^TMP("PSDGPR",$J,GNM,ANM,TYPENM)) Q:TYPENM=""!(PSDOUT)  D:$Y+4>IOSL PAGE Q:PSDOUT  W !?18,TYPENM
 Q
HDR ;HEADER
 W:$Y @IOF S PG=PG+1 W !?28,"NAOU INVENTORY GROUP LIST",?71,"PAGE: ",PG,!?31,"PRINTED: ",HDT,!!,"=> INVENTORY GROUP",!?13,"NARCOTIC AREA OF USE",!?18,"TYPE",!,LN
 Q
PAGE ;end of page check
 I $E(IOST,1,2)="C-" W ! K DA,DIR S DIR(0)="E" D ^DIR K DIR I 'Y S PSDOUT=1 Q
 D HDR
 Q