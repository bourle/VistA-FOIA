PRSEDEL1 ;HISC/MD-EDIT DELETE STUDENT RECORD ;07/14/94
 ;;4.0;PAID;;Sep 21, 1995
EN1 ; ENTRY FROM OPTION PRSEE-I-EMP
 S X=$G(^PRSE(452.7,1,"OFF")) I X=""!(X=1) D MSG6^PRSEMSG Q
 S (NOUT,NSW)=0 D EN2^PRSEUTL3($G(DUZ)) I PRSESER=""&'(DUZ(0)="@") D MSG3^PRSEMSG G Q1
 S DIR(0)="SO^M:Mandatory Training (MI);C:Continuing Education;O:Other/Miscellaneous;W:Ward/Unit-Location Training;A:All",DIR("A")="Select a Training Type" D ^DIR K DIR I $D(DTOUT)!$D(DUOUT) G Q1
 S PRSESEL=Y,(PRSENAM,PRSEDT)=""
CLS F  K POUT S Y=-1 R !!,"Select TRAINING CLASS: ",X:DTIME S:'$T X="^^" S:X="" Y="" Q:"^^"[X  D  Q:Y]""
 .   S DIC("S")="S DATA=$G(^PRSE(452,Y,0)),PRSEIEN=$G(^PRSE(452,""AK"",$P($G(DATA),U,2),Y)) I PRSESEL=""A""!($P(DATA,U,21)=PRSESEL),(PRSEIEN=$G(PRSESER)!(DUZ(0)[""@""!(+$$EN4^PRSEUTL3($G(DUZ)))))"
 .   S DIC("W")="W ?($X+4),$$DICW^PRSEDEL1(^(0))"
 .   S DLAYGO=452,DIC=452,DIC(0)=$E("SZE",1,(X'=" ")+2),D="AK" D IX^DIC K DIC I X?1"?".E!(Y>0) W:X=" " "   ",$P(Y(0),U,2) S Y=$S(Y>0:$P(Y(0),U,2),1:"") Q
 .   I X=" ",'(+Y>0)!($L(X)<2) S POUT=1 Q
 .   I '(+Y>0) W !!?3,$C(7),"'"_X_"' IS NOT CURRENTLY IN THE STUDENT TRACKING #452 FILE" S (X,Y)="",POUT=1 Q
 G Q1:Y=""!(Y<0)!($D(POUT))  S PRSENAM=Y K Y
 S PRSEDA(1)=$O(^PRSE(452,"AK",PRSENAM,0)),PRSEDATA=$G(^PRSE(452,+PRSEDA(1),0)),PRSEDATA(2)=$G(^PRSE(452,+PRSEDA(1),6)),PRSELEN=$P($G(PRSEDATA),U,16),PRSETYP=$P($G(PRSEDATA),U,21),PRSENTR=$P($G(PRSEDATA(2)),U,2)
 S PRSEDATA(1)=PRSENAM_"^"_PRSELEN_"^"_PRSETYP_"^"_PRSENTR
 S DIR(0)="FAO^3:53",DIR("A")="TRAINING CLASS: " S:'(PRSENAM="") DIR("B")=PRSENAM D ^DIR K DIR G:$D(DTOUT)!($D(DUOUT)) Q1 S PRSEX=Y
 I "@"[X W !!,$C(7),"ARE YOU SURE YOU WANT TO DELETE ALL RECORDS FOR THIS CLASS/DATE" S %=2,PRSEX=X D YN^DICN G:'(%=1) EN1 G:%=1 LOOP
 S DA=PRSEDA(1) D SUPPR^PRSEED12 Q:$G(POUT)=1
 S DIR(0)="SO^M:Mandatory Training (MI);C:Continuing Education;O:Other/Miscellaneous;W:Ward/Unit-Location Training",DIR("A")="Select a Training Type"
 S:'(PRSETYP="") DIR("B")=$S(PRSETYP="M":"Mandatory Training (MI)",PRSETYP="C":"Continuing Education",PRSETYP="O":"Other/Miscellaneous",PRSETYP="W":"Ward/Unit-Location Training",1:"")
 D ^DIR K DIR G:$D(DTOUT)!($D(DUOUT)) Q1
 S PRSETYP=Y
 S DIR(0)="NAO^0:9999.99:2",DIR("?")="Type a Number between 0 and 9999.99, 2 Decimal Digits",DIR("A")="PRSE PROGRAM/CLASS LENGTH HRS: " S:+PRSELEN DIR("B")=PRSELEN D ^DIR K DIR I $D(DUOUT)!($D(DTOUT)) G Q1
 S PRSELEN=Y,PRSEDATA(2)=PRSEX_"^"_PRSELEN_"^"_PRSETYP_"^"_PRSENTR G:PRSEDATA(1)=PRSEDATA(2) CLS
LOOP ;
 W ! F PRSEDA(1)=0:0 S PRSEDA(1)=$O(^PRSE(452,"CLS",PRSENAM,PRSEDA(1))) Q:PRSEDA(1)'>0  W "." D
 .  I PRSEX="@" S DIK="^PRSE(452,",DA=PRSEDA(1) D ^DIK Q
 .  S DIE="^PRSE(452,",DA=PRSEDA(1),DR="1////"_PRSEX_";5////"_PRSETYP_";2.1////"_PRSELEN_";2.4////"_PRSENTR_"" D ^DIE
 .  Q
 S (PRSECLS,DA)=+$O(^PRSE(452.1,"B",PRSENAM,0)) I DA>0 D
 . I PRSEX="@" S DIK="^PRSE(452.1," D ^DIK Q
 . S DIE="^PRSE(452.1,",DR=".01///"_PRSEX_";2///"_PRSELEN_";5///"_PRSETYP_"" D ^DIE K DIE
 . Q
 S DA=$O(^PRSE(452.8,"B",PRSECLS,0)) I DA>0 D
 . I PRSEX="@" S DIK="^PRSE(452.8," D ^DIK Q
 . S DIE="^PRSE(452.8,",DR="4////"_$P($G(PRSEDATA(2)),U,3)_";15////"_$P($G(PRSEDATA(2)),U,2)_";7.1///"_$J($P($G(PRSEDATA(2)),U,2),1,0)_"" D ^DIE K DIE,DR
 . S DA(1)=DA F DA=0:0 S DA=$O(^PRSE(452.8,DA(1),3,DA)) Q:DA'>0  I $G(^PRSE(452.8,DA(1),3,DA,0))'="" S DIE="^PRSE(452.8,DA(1),3,",DR="3///"_$P($G(PRSEDATA(2)),U,4)_"" D ^DIE
 . Q
 G CLS
Q1 D ^PRSEKILL
 Q
DICW(CLASS) ;
 N CLASSTXT,CLASSIEN,CLASSERV
 S CLASSTXT=$P($G(CLASS),U,2) S:CLASSTXT="" CLASSTXT=U
 S CLASSIEN=+$O(^PRSE(452.1,"B",CLASSTXT,0))
 S CLASSERV(0)=$$SERV(+$P($G(^PRSE(452.1,CLASSIEN,0)),U,8))
 I CLASSERV(0)="" D
 . S CLASSERV=+$O(^PRSE(452,"AK",CLASSTXT,0)),CLASSERV=+$G(^(CLASSERV))
 . S CLASSERV(0)=$$SERV(CLASSERV)
 . Q
 Q $S(CLASSERV(0)]"":CLASSERV(0),1:"UNKNOWN")
SERV(Y) Q $P($G(^PRSP(454.1,+$G(Y),0)),U)