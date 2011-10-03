RACDR ;HISC/FPT AISC/SAW-Cost Distribution (CDR) Report ;4/16/96  08:44
 ;;5.0;Radiology/Nuclear Medicine;;Mar 16, 1998
 I $O(RACCESS(DUZ,""))="" D SETVARS^RAPSET1(0) S RAPSTX=""
 K ^TMP($J,"RACDR"),^TMP($J,"RA DIVTOT")
 S X=$$DIVLOC^RAUTL7() I X D Q Q
 S A=""
 F  S A=$O(RACCESS(DUZ,"DIV-IMG",A)) Q:A']""  D
 . Q:'$D(^TMP($J,"RA D-TYPE",A))  S A1=$O(^TMP($J,"RA D-TYPE",A,0))
 . Q:A1'>0  S B=""
 . F  S B=$O(RACCESS(DUZ,"DIV-IMG",A,B)) Q:B']""  D
 .. I $D(^TMP($J,"RA I-TYPE",B)) D IT^RALWKL2 I B1?3AP1"-".N S ^TMP($J,"RACDR",A1,B1)=0
 .. Q
 . Q
 K A,A1,B,B1,RACCESS(DUZ,"DIV-IMG")
DATE D DATE^RAUTL I RAPOP D Q QUIT
 S RABEG=BEGDATE,RAEND=ENDDATE+.9,RABDT=$E(BEGDATE,4,5)_"/"_$E(BEGDATE,6,7)_"/"_$E(BEGDATE,2,3),RAEDT=$E(ENDDATE,4,5)_"/"_$E(ENDDATE,6,7)_"/"_$E(ENDDATE,2,3)
 S ZTDESC="Rad/Nuc Med Cost Distribution Report",ZTRTN="START^RACDR"
 F RASV="RABDT","RAEDT","RABEG","RAEND","^TMP($J,""RACDR""," S ZTSAVE(RASV)=""
 W ! D ZIS^RAUTL G:RAPOP Q
START ; start processing
 U IO S (RAEOS,RAPG)=0,(RAQ,X)="",$P(RAQ,"-",80)="-" D NOW^%DTC S Y=% D DD^%DT S RARDT=Y K %,%H,%I
 S:$D(ZTQUEUED) ZTREQ="@"
 S RAITCNT=0,RALP=""
 F  S RALP=$O(^TMP($J,"RACDR",RALP)) Q:RALP=""  S RAITCNT(RALP)=0,^TMP($J,"RACDR",RALP)="0^0^0^0",RALP1="" F  S RALP1=$O(^TMP($J,"RACDR",RALP,RALP1)) Q:RALP1=""  S RAITCNT(RALP)=RAITCNT(RALP)+1,^TMP($J,"RACDR",RALP,RALP1)="0^0^0^0"
 K RALP,RALP1
 F RAI=RABEG-.0001:0 S RAI=$O(^RADPT("AR",RAI)) Q:'RAI!(RAI>RAEND)!(RAEOS)  F RADFN=0:0 S RADFN=$O(^RADPT("AR",RAI,RADFN)) Q:RADFN'>0!(RAEOS)  S RADTI=9999999.9999-RAI,RAY=$G(^RADPT(RADFN,"DT",RADTI,0)) D:RAY]""
 .S RADIV=$P(RAY,U,3),RADIV=$P($G(^RA(79,+RADIV,0)),U,1) Q:RADIV'>0
 .S RAIMAGE=+$P(RAY,U,2)
 .S RAIMAGE("X")=$P($G(^RA(79.2,RAIMAGE,0)),U),RAITYPE=$E(RAIMAGE("X"),1,3)_"-"_RAIMAGE
 .Q:'$D(^TMP($J,"RACDR",RADIV,RAITYPE))  ;No access to this division & imaging type
 .F RACNI=0:0 S RACNI=$O(^RADPT(RADFN,"DT",RADTI,"P",RACNI)) Q:'RACNI!(RAEOS)  S RAX=$G(^(RACNI,0)) I RAX]"",'$D(^RA(72,"AA",RAIMAGE,0,+$P(RAX,"^",3))) D  Q:RAEOS
 ..S RAPROC=+$P(RAX,"^",2) Q:RAPROC=""  S RACAT=$P(RAX,"^",4) Q:RACAT']""
 ..S RACATN=$S(RACAT="I":1,RACAT="O":2,RACAT="R":3,1:4),RAPROCN=$P($G(^RAMIS(71,RAPROC,0)),"^") S:RAPROCN="" RAPROCN="Unknown"
 ..S RACDR="" I RACAT="I",$D(^DIC(42,+$P(RAX,"^",6),0)) S RACDR=+$P(^(0),"^",12) I RACDR S RACDR=$G(^DIC(42.4,RACDR,0)) I RACDR]"" S RACDRN=$P(RACDR,"^"),RACDR=$P(RACDR,"^",6)
 ..I "OE"[RACAT S RACDR=$P($G(^SC(+$P(RAX,"^",8),0)),"^",7) I RACDR S RACDR=$G(^DIC(40.7,RACDR,0)) I RACDR]"" S RACDRN=$P(RACDR,"^"),RACDR=$P(RACDR,"^",5)
 ..I "RCS"[RACAT D
 ...S RACDR=$P($G(^DIC(42,+$P(RAX,"^",6),0)),"^",12) I RACDR S RACDR=$G(^DIC(42.4,RACDR,0)) I RACDR]"" S RACDRN=$P(RACDR,"^"),RACDR=$P(RACDR,"^",6)
 ...E  S RAT=$G(^SC(+$P(RAX,"^",22),0)) Q:"CW"'[$P(RAT,"^",3)  D
 ....I $P(RAT,"^",3)="W",$D(^SC(+$P(RAX,"^",22),42)) S RACDR=$P($G(^DIC(42,+^(42),0)),"^",12) I RACDR S RACDR=$G(^DIC(42.4,RACDR,0)) I RACDR]"" S RACDRN=$P(RACDR,"^"),RACDR=$P(RACDR,"^",6)
 ....E  S RACDR=$G(^DIC(40.7,+$P(RAT,"^",7),0)) I RACDR]"" S RACDRN=$P(RACDR,"^"),RACDR=$P(RACDR,"^",5)
 ..Q:'RACDR  S:RACDR'["." RACDR=RACDR_".00" I '$D(^TMP($J,"RACDR",RADIV,RAITYPE,RACDR,RAPROCN,RAPROC)) S ^(RAPROC)="0^0^0^0"
 ..S RACDRNME=$S($E(RACDR,1,4)=1110:"GENERAL MEDICINE",$E(RACDR,1,4)=1111:"NEUROLOGY",$E(RACDR,1,4)=1210:"GENERAL SURGERY",$E(RACDR,1,4)=1310:"ACUTE AND LONG TERM PSYCHIATRY",1:RACDRN)
 .. I $D(ZTQUEUED) D STOPCHK^RAUTL9 S:$G(ZTSTOP)=1 RAEOS=1 Q:RAEOS
 ..I '($D(^TMP($J,"RACDR",RADIV,RAITYPE,RACDR))#2) S ^(RACDR)="0^0^0^0^"_RACDRNME
 ..S (RAK,RAMUL)=0 F  S RAK=$O(^RAMIS(71,RAPROC,2,RAK)) Q:RAK'>0!(RAMUL)  I $D(^(RAK,0)),$P(^(0),"^",3)="Y" S RAMUL=1
 ..S $P(^TMP($J,"RACDR",RADIV,RAITYPE,RACDR,RAPROCN,RAPROC),"^",RACATN)=$P(^TMP($J,"RACDR",RADIV,RAITYPE,RACDR,RAPROCN,RAPROC),"^",RACATN)+1+RAMUL
 ..S $P(^TMP($J,"RACDR",RADIV,RAITYPE,RACDR),"^",RACATN)=$P(^TMP($J,"RACDR",RADIV,RAITYPE,RACDR),"^",RACATN)+1+RAMUL
 ..S $P(^TMP($J,"RACDR",RADIV,RAITYPE),U,RACATN)=$P(^TMP($J,"RACDR",RADIV,RAITYPE),U,RACATN)+1+RAMUL
 ..S $P(^TMP($J,"RACDR",RADIV),U,RACATN)=$P(^TMP($J,"RACDR",RADIV),U,RACATN)+1+RAMUL
 ..I '$D(^TMP($J,"RA DIVTOT",RADIV,RACDR)) S ^TMP($J,"RA DIVTOT",RADIV,RACDR)="0^0^0^0^"_RACDRNME
 ..S $P(^TMP($J,"RA DIVTOT",RADIV,RACDR),U,RACATN)=$P(^TMP($J,"RA DIVTOT",RADIV,RACDR),U,RACATN)+1+RAMUL
 D:'RAEOS ^RACDR1
Q ; kill variables & close device
 K %,%DT,%H,%I,%W,%X,%Y,BEGDATE,DIC,ENDDATE,RA,RA1,RABDT,RABEG,RACAT,RACATN,RACDR,RACDRNME,RACDRN,RACNI,RADFN,RADIC,RADIV,RADIVNDE,RADIVNME,RADIVTOT,RADTI
 K RAEDT,RAEND,RAEOS,RAFLG,RAI,RAIMAGE,RAIMGNDE,RAIMGTOT,RAITHLD,RAITCNT,RAITYPE,RAJ,RAK,RAMUL,RAPG,RAPOP,RAPROC,RAPROCN,RAQ,RAQUIT,RARDT,RASUM,RASV,RAT,RATA,RATOT,RATP,RAUTIL
 K RAX,RAY,X,Y,ZTDESC,ZTRTN,ZTSAVE,^TMP($J,"RACDR"),^TMP($J,"RA D-TYPE"),^TMP($J,"RA I-TYPE"),^TMP($J,"RA DIVTOT")
 K:$D(RAPSTX) RACCESS,RAPSTX
 W ! D CLOSE^RAUTL
 K I,POP,RAMES
 Q