RCRCRT1 ;ALB/CMS - RC AND DOJ TRANSACTION ROU 1 ;8/14/97
V ;;4.5;Accounts Receivable;**63,198**;Mar 20, 1995
 ;;Per VHA Directive 10-93-142, this routine should not be modified.
 Q
EN(PRCATYPE) ;Enter here from Options
 ;Refer Accounts receivable to RC/DOJ option enter PRCATYPE=34
 ;               (3 - RC, 4 - DOJ)
 ;Re-Refer to RC/DOJ option enter PRCATYPE=5
 ;Return by RC/DOJ option enter PRCATYPE=6
 I 'PRCATYPE G ENQ
 ;
 N C,D,DA,DIC,D0,I,RCOUT,RCCAT,X,Y,%
 N PRCA,PRCAAB,PRCABN,PRCABN0,PRCABN6,PRCABN7,PRCACAT,PRCACC,PRCACODE,PRCACURB,PRCADT,PRCAEN
 N PRCAD,PRCAIB,PRCAMF,PRCAPB,PRCAPROC,PRCARAMT,PRCAS,PRCATEMP,PRCATY
 ;
GET D BILL I $G(PRCABN)<1 G ENQ
 S DA=PRCABN,DIC="^PRCA(430," D LCK^PRCAUPD I '$D(DA) G GET
 S PRCACAT=$P(PRCABN0,U,2)
 S PRCABN6=$G(^PRCA(430,PRCABN,6)),PRCADT=+$P(PRCABN6,U,4)
 I 'PRCADT,PRCATYPE'=34 W !!,"This Bill was not referred to RC/DOJ !",! G GET
 S PRCARAMT=$P(PRCABN6,U,6),PRCACODE=$P(PRCABN6,U,5),PRCAPROC=""
 I PRCACODE="DC" S PRCACODE="RC"
 S PRCABN7=$G(^PRCA(430,PRCABN,7))
 S PRCAPB=$P(PRCABN7,U,1),PRCAIB=$P(PRCABN7,U,2),PRCAAB=$P(PRCABN7,U,3)
 S PRCAMF=$P(PRCABN7,U,4),PRCACC=$P(PRCABN7,U,5)
 S PRCACURB=0 F I=1:1:5 S PRCACURB=PRCACURB+$P(PRCABN7,U,I)
 ;
 D WRREF^RCRCRT2 I $G(RCOUT)=1 G ENQ
 I PRCADT,PRCATYPE=34 D CAN^RCRCRT2 G ENQ
 I PRCATYPE=34 D REF
 I PRCATYPE=0 W !,"The Principal Balance is less than the Minimum set for Referral" G ENQ
 I (PRCATYPE=3)!(PRCATYPE=4) S PRCATEMP="[PRCAC DCDOJ REFER]"
 I PRCATYPE=5 S PRCATEMP="[PRCAC DCDOJ REREFER]"
 I PRCATYPE=6 S PRCATEMP="[PRCAC DCDOJ RETN]"
 D PROC
 ;
ENQ I $G(PRCABN)>0 L -^PRCA(430,+PRCABN)
 K PRCATYPE
 Q
 ;
PROC ;Create Transaction and Update Bill
 N DA,DIE,DR,PRCAOK,PRCATOT
 D SETTR^PRCAUTL,PATTR^PRCAUTL
 I '$D(PRCAEN) W !!,"*Could not create Transaction at this time. Try again." G PROCQ
 D SETEN
 I 'PRCATOT W !!,"No Referral Action taken.",! G PROCQ
 I PRCATYPE=6 S (PRCACODE,PRCATOT)="@"
 S DR="64///"_$S(PRCATYPE=6:"@",1:PRCADT)_";65///"_PRCACODE_";66///"_PRCATOT
 I PRCATYPE=6 S DR=DR_";68.3///"_PRCADT
 I PRCATYPE=5 S DR=DR_";68.2///"_PRCADT
 S DA=PRCABN,DIE="^PRCA(430," D ^DIE
 W !!,"Referral Action taken.",!
PROCQ Q
 ;
REF ;Check Group File for RC or DOJ based on amount
 N MAX,MIN,PRCAGRP,PRCAMAX,PRCAMIN
 I $P($G(^PRCA(430.2,+PRCACAT,0)),U,6)="T" S PRCACODE="RC",PRCATYPE=3 G REFQ
 S PRCAMAX=5000,PRCAMIN=1,PRCATYPE=3
 S PRCAGRP=$O(^RC(342.2,"B","REGIONAL COUNSEL",0)) I PRCAGRP="" G REFQ
 S PRCAGRP=$O(^RC(342.1,"AC",PRCAGRP,0))
 S MIN=$P($G(^RC(342.1,+PRCAGRP,2)),"^"),MAX=$P($G(^(2)),U,2)
 S PRCAMIN=$S(+MIN>0:MIN,1:PRCAMIN),PRCAMAX=$S(+MAX>0:MAX,1:PRCAMAX)
 S PRCATYPE=$S(PRCAPB<PRCAMIN:0,PRCAPB<PRCAMAX:3,1:4)
 S PRCACODE=$S(PRCATYPE=3:"RC",1:"DOJ")
REFQ Q
 ;
SETEN ;record the Referral action transaction in the #433.
 N DR,DIE,DIC,DA,D0,PRCAOK,X,Y
 N PRCAEDIT,PRCAEN1,PRCAEN8,PRCAKDT,PRCAKTY
EDT S DIE="^PRCA(433,",DR=PRCATEMP,DA=PRCAEN D ^DIE
 S DR="41" D ^DIE
 S PRCAEN8=$G(^PRCA(433,PRCAEN,8))
 S PRCAPB=+$P(PRCAEN8,U,1),PRCAIB=+$P(PRCAEN8,U,2),PRCAAB=+$P(PRCAEN8,U,3)
 S PRCAMF=+$P(PRCAEN8,U,4),PRCACC=+$P(PRCAEN8,U,5)
 S PRCATOT=PRCAPB+PRCAIB+PRCAAB+PRCAMF+PRCACC
 S $P(^PRCA(433,PRCAEN,1),U,5)=PRCATOT
 S PRCAEN1=$G(^PRCA(433,PRCAEN,1)),PRCADT=$P(PRCAEN1,U,1)
 S PRCAKTY=$S($P(PRCAEN1,U,2)'="":$P(^PRCA(430.3,$P(PRCAEN1,U,2),0),U,1),1:"")
 S PRCAKDT=""
 I PRCADT S Y=PRCADT D D^DIQ S PRCAKDT=Y
 I PRCATOT>0 D WRDATA^RCRCRT2
 I 'PRCATOT W !!,"**TRANSACTION TOTAL IS ZERO",! D ASKED I $D(PRCAEDIT) G EDT
 I 'PRCATOT,'$D(PRCAEDIT) D DEL G SETENQ
 I $G(RCCAT(PRCACAT)),PRCACURB'=PRCATOT W !!,"**TRANSACTION TOTAL MUST EQUAL THE CURRENT BILL BALANCE  $"_PRCACURB D ASKED I $D(PRCAEDIT) G EDT
 I $G(RCCAT(PRCACAT)),PRCACURB'=PRCATOT,'$D(PRCAEDIT) D DEL G SETENQ
 D ASKOK I $D(PRCAOK) G SETENQ
 I $D(PRCAEDIT) G EDT
 D DEL
SETENQ Q
 ;
ASKOK K PRCAOK S %=2 W !,"IS THIS CORRECT " D YN^DICN I %=1 S PRCAOK="" Q
 I %=0 D M1^PRCAMESG G ASKOK
 Q:%<0
ASKED K PRCAEDIT S %=2 W !!,"DO YOU WANT TO EDIT " D YN^DICN Q:%<0
 I %=0 D M2^PRCAMESG G ASKED
 S:%=1 PRCAEDIT=""
 Q
DEL ;delete the entry.
 N PRCACOMM
 W !!,"* Deleting Transaction ......",!
 S PRCACOMM="USER CANCELED REFERRAL ACTION"
 D DELETE^PRCAWO1 S PRCATOT=0
 Q
BILL ;Get Active Bill that is not a TP Electronic Refer Type
 ;Return PRCABN=Y,PRCABN(0)=Y(0)
 N DA,DIC,X,Y,%Y W !
 N DPTNOFZY,DPTNOFZK S (DPTNOFZY,DPTNOFZK)=1
 D RCCAT^RCRCUTL(.RCCAT)
 S DIC="^PRCA(430,",DIC(0)="AEQMZ"
 S DIC("S")="I $P(^(0),U,8)=16,+$G(RCCAT(+$P(^(0),U,2)))'=1"
 D ^DIC S PRCABN=+Y,PRCABN0=$G(Y(0))
 Q
 ;RCRCRT1