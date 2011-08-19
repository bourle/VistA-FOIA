ESPOFP ;DALISC/CKA - PRINT OFFENSE REPORT FOLLOW-UP NOTES ONLY;3/99
 ;;1.0;POLICE & SECURITY;**14,27,42**;Mar 31, 1994
EN ;Entry point to print follow-up notes of only completed and nonsensitive reports.
 D DT^DICRW
OR S DIC(0)="QAEMZ",DIC("A")="UOR#: ",DIC("S")="I $D(^(5)),$P(^(5),U,2),'$P(^(5),U,4),$P(^(5),U,5)",DIC="^ESP(912,"
 D ^DIC
 G:$D(DTOUT)!($D(DUOUT))!(X="") EXIT
 I Y<0 W !,$C(7),"UOR# not found.  Please try again." G OR
 S ESPDTR=$P(^ESP(912,+Y,0),U,2),ESPID=+Y
Q S %ZIS="Q" D ^%ZIS G:POP EXIT I '$D(IO("Q")) U IO D START G EXIT
 S ZTRTN="START^ESPOFP",ZTSAVE("ESP*")="",ZTDESC="FOLLOW-UP NOTES" D ^%ZTLOAD,HOME^%ZIS G EXIT
START ; BEGINS THE PRINT OF THESE FOLLOW-UP NOTES
 N ESPFACI
 K ^UTILITY("DIQ1",$J) S (END,PAGE)=0 D HDR G:END EXIT
FOL ;PRINT FOLLOW-UP NOTES
 G:'$D(^ESP(912,ESPID,130)) EXIT
 F ESPN=0:0 S ESPN=$O(^ESP(912,ESPID,130,ESPN))  Q:ESPN'>0  D
 .  D HDR:$Y+5>IOSL&(ESPN'=1) Q:END
 .  W !,"FOLLOW-UP NOTES:",!!
 .  K ^UTILITY($J,"W") S DIWL=3,DIWR=78,DIWF="W",IEN=0
 .  F ESPN1=1:1 S IEN=$O(^ESP(912,ESPID,130,ESPN,10,IEN)) Q:IEN'>0  S X=^(IEN,0) D  Q:END
 .  .  D HDR:$Y+5>IOSL Q:END
 .  .  D ^DIWP
 .  Q:END
 .  D ^DIWW
 .  S DIC="^ESP(912,"_ESPID_",130,",DA=ESPN,DR=".01",DIQ(0)="I" D EN^DIQ1
 .  S ESPOFF=$G(^UTILITY("DIQ1",$J,912.17,DA,.01,"I"))
 .  S DIC="^VA(200,",DA=ESPOFF,DR="20.2;910.1",DIQ(0)="E" D EN^DIQ1
 .  W !!!!
 .  D HDR:$Y+10>IOSL Q:END
 .  W !,$G(^UTILITY("DIQ1",$J,200,DA,20.2,"E")),"   # ",$G(^UTILITY("DIQ1",$J,200,DA,910.1,"E")),!,"FOLLOW-UP INVESTIGATOR",!!!!!
EXIT D ^%ZISC
 K %ZIS,CL,DA,DIC,DIQ,DIR,DIRUT,DIWF,DIWL,DIWR,DR,END,ESPDTR,ESPID,ESPN,ESPN1,IEN,PAGE,X,Y,ZTDESC,ZTRTN,ZTSAVE
 K ^UTILITY("DIQ1",$J)
 QUIT
HDR ;PRINT HEADING
 I PAGE>0,$E(IOST,1,2)="C-" S END=$$EOP^ESPUTIL() Q:END
 S PAGE=PAGE+1 W @IOF,!?25,"DEPARTMENT OF VETERANS AFFAIRS",?(IOM-10),"PAGE:  ",$J(PAGE,3)
 W !?35,"VA POLICE",!?28,"UNIFORM OFFENSE REPORT"
 W !?30,"UOR# ",$E(ESPDTR,2,3),"-",$E(ESPDTR,4,5),"-",$E(ESPDTR,6,7),"-",$TR($E($P(ESPDTR,".",2)_"ZZZZ",1,4),"Z",0)
 W !,"VA Facility" W ?61,"Date/Time Printed"
 S ESPFACI=$P(^ESP(912,ESPID,0),U,7) S ESPFACI=$S(ESPFACI="":"",$D(^DG(40.8,ESPFACI,0)):$P(^(0),U),1:"")
 I ESPFACI="",$D(^ESP(912,ESPID,5)),$P(^(5),U)'="" S ESPFACI=$S($D(^DIC(4,$P(^(5),U),0)):$P(^(0),U),1:"")
 W !,ESPFACI
 ;I $D(^ESP(912,ESPID,5)),$P(^(5),U)'="" W !,$S($D(^DIC(4,$P(^(5),U),0)):$P(^(0),U),1:"")
 W ?61,$$NOW^ESPUTIL()
 W !,"Automated VA Form 10-1393"
 W !!
 QUIT
 ;
 ;ENTRY POINT OR1 IS TO ALLOWS PRINT OF AN INCOMPLETE REPORT
 ;THIS OPTION IS ONLY FOR PERSONS HOLDING THE CHIEF KEY
OR1 S DIC(0)="QAEMZ",DIC("A")="UOR#: ",DIC("S")="I $D(^(5)),$P(^(5),U,5)",DIC="^ESP(912,"
 D ^DIC G:$D(DTOUT)!($D(DUOUT))!(X="") EXIT G:Y<0 OR1 S ESPDTR=$P(^ESP(912,+Y,0),U,2),ESPID=+Y
 D Q
 QUIT