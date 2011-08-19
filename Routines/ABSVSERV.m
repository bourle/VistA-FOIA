ABSVSERV ;VAMC ALTOONA/CTB - SERVER TO FILE DATA FROM AUSTIN  ;1/11/01  10:21 AM
V ;;4.0;VOLUNTARY TIMEKEEPING;**3,9,10,19,21,23**;JULY 6, 1994
 D NOW^ABSVQ S DATE=%
 ;CHECK MESSAGE FILE FOR ENTRY, IF NONE ADD, IF SERVED, QUIT
 S RECCOUNT=0,ERRCOUNT=0
 S X=XMZ,DIC=503339.1,DIC(0)="ML",DLAYGO=DIC D ^DIC
 I Y<0 QUIT
 S MSGNUM=XMZ,MFILEDA=+Y
 I $P(^ABS(503339.1,MFILEDA,0),"^",3)="S" S MSG="Message previously filed.  No action taken." D ERR QUIT
 S $P(^ABS(503339.1,MFILEDA,0),"^",3,4)="R^"_DATE
 S DONE=0
 F  X XMREC Q:XMER'=0  D  Q:DONE
 . I $E(XMRG,1,2)="01"!($E(XMRG,1,5)="SERV2") D START Q:DONE
 . I $E(XMRG,1,5)="SERV3" D ^ABSVSER3 Q:DONE
 .  QUIT
 QUIT
START ;
 S MSG="PROCESSING MONTHLY MASTER RECORD DOWNLOAD." D MSG
 S MSG="  " D MSG
 D TYPE01
 F  X XMREC Q:XMER'=0  D
 . I $E(XMRG,1,2)="01" D TYPE01 QUIT
 . I $E(XMRG,1,5)="SERV2" D TYPE02 QUIT
 . QUIT
 S $P(^ABS(503339.1,MFILEDA,0),"^",3)="S"
 I '$D(MSGLINE) S XQSTXT(1)=" ",XQSTXT(2)="No errors found during processing for station "_$G(SITE) S MSGLINE=3
 S XQSTXT(MSGLINE)=RECCOUNT_" records processed into master file." S MSGLINE=MSGLINE+1
 S XQSTXT(MSGLINE)=ERRCOUNT_" records bypassed."
 S DONE=1 QUIT
TYPE01 K X,TRANSNUM,SITE,DATE,SSN,TERMMO,TERMYR,SERVYRS,HRSPRYR,HRSCURYR,AWDCODE,AWDHRS,AWDMO,AWDYR,HRSTOT,ZIP
 S X=XMRG
 S TRANSNUM=$E(X,1,2),SITE=$$STRIP($E(X,3,6))
 S DATE=$E(X,7,12),PSSN=$$STRIP($E(X,13))
 S SSN=$$STRIP($E(X,14,22))
 S TERMMO=$E(X,23,24),TERMYR=$E(X,25,26)
 S TERMDATE=""
 I TERMYR]"",+TERMMO'=0 S TERMDATE=$$YEAR(TERMYR)_TERMMO_"00"
 S SERVYRS=+$E(X,27,28),HRSPRYR=+$E(X,29,33),HRSCURYR=+$E(X,34,37),HRSTOT=HRSPRYR+HRSCURYR
 S AWDCODE=$$STRIP($E(X,38,39)) I AWDCODE]"" S AWDCODE=$O(^ABS(503337,"C",AWDCODE,0))
 S AWDHRS=+$E(X,40,44)
 S AWDMO=$E(X,45,46),AWDYR=$E(X,47,48)
 S AWDDATE=""
 I AWDYR]"",+AWDMO'=0 S AWDDATE=$$YEAR(AWDYR)_AWDMO_"00"
 S ZIP=$$STRIP($E(X,49,57)) I $L(ZIP)>5 S ZIP=$E(ZIP,1,5)_"-"_$E(ZIP,6,9)
 D FILE QUIT
TYPE02 K X,TRANSNUM,SITE,DATE,SSN,TERMMO,TERMYR,SERVYRS,HRSPRYR,HRSCURYR,AWDCODE,AWDHRS,AWDMO,AWDYR,HRSTOT,ZIP
 S X=XMRG
 S TRANSNUM=$P(X,"^",1),SITE=$$STRIP($P(X,"^",2))
 S DATE=$$FMDATE($P(X,"^",3)),PSSN=$$STRIP($P(X,"^",3))
 S SSN=$$STRIP($P(X,"^",4))
 S TERMDATE=$$FMDATE($P(X,"^",5))
 S SERVYRS=+$P(X,"^",6),HRSPRYR=+$P(X,"^",7),HRSCURYR=+$P(X,"^",8),HRSTOT=HRSPRYR+HRSCURYR
 S AWDCODE=$$STRIP($P(X,"^",9)) I AWDCODE]"" S AWDCODE=$O(^ABS(503337,"C",AWDCODE,0))
 S AWDHRS=+$P(X,"^",10)
 S AWDDATE=$$FMDATE($P(X,"^",11))
 S ZIP=$$STRIP($P(X,"^",12)) I $L(ZIP)>5 S ZIP=$E(ZIP,1,5)_"-"_$E(ZIP,6,9)
 D FILE QUIT
FILE ;LOOKUP STATION NUMBER FOR INTERNAL NUMBER ON 4 NODE
 S SITEDA=$O(^ABS(503338,"AD",SITE,0)) I SITEDA="" S MSG="Station number "_SITE_" on record "_$$EXTSSN^ABSVU2(SSN)_" not found in file 503338." D ERR QUIT
 ;LOOKUP VOLUNTEER
 S VOLDA=$O(^ABS(503330,"D",SSN,0)) I $S(VOLDA="":1,'$D(^ABS(503330,VOLDA)):1,1:0) S MSG="No volunteer record found with SSN "_$$EXTSSN^ABSVU2(SSN)_"." D ERR QUIT
 ;CHECK FOR STATION ENTRY
 I '$D(^ABS(503330,VOLDA,4,SITEDA,0)) S MSG="Volunteer "_$$EXTSSN^ABSVU2(SSN)_" has no record for station "_SITE_".~" D ERR QUIT
 L +^ABS(503330,VOLDA,4,SITEDA,0):20 ELSE  S MSG="Unable to post record for SSN "_$$EXTSSN^ABSVU2(SSN)_" due to record lock.~" D ERR QUIT
 S $P(^ABS(503330,VOLDA,4,SITEDA,0),"^",3,8)=$$BLANK(SERVYRS)_"^"_$$BLANK(HRSTOT)_"^"_$$BLANK(AWDHRS)_"^"_AWDDATE_"^"_AWDCODE_"^"_TERMDATE,$P(^(0),"^",20,21)=$$BLANK(HRSPRYR)_"^"_$$BLANK(HRSCURYR)
 S RECCOUNT=RECCOUNT+1
 L -^ABS(503330,VOLDA,4,SITEDA,0)
 L +^ABS(503330,VOLDA,0):20 ELSE  S MSG="Unable to post record for SSN "_$$EXTSSN^ABSVU2(SSN)_" due to record lock.~" D ERR QUIT
 I $E(ZIP,1,5)?5N S $P(^ABS(503330,VOLDA,0),"^",6)=ZIP
 L -^ABS(503330,VOLDA,0)
 QUIT
 ;
FMDATE(X) ;CONVERT MMDDYYYY OR MMYYYY TO FILEMAN INTERNAL DATE
 I $L(X)=4 Q (X-1700)_"0000"
 I $L(X)=6 Q ($E(X,3,6)-1700)_$E(X,1,2)_"00"
 Q ($E(X,5,8)-1700)_$E(X,1,2)_$E(X,3,4)
YEAR(X) ;CONVERT COBOL YEAR TO FM YEAR EG 89 TO 289
 Q $S($E(X)>3:2_X,1:3_X)
STRIP(X) ;STRIP TRAILING BLANKS
 F  Q:$E(X,$L(X))'=" "  S X=$E(X,1,($L(X)-1))
 Q X
BLANK(X) ;SET 0 TO BLANKS
 I +X=0 S X=""
 Q X
ERR ;POST ERROR MESSGE
 S ERRCOUNT=$G(ERRCOUNT)+1
MSG S MSGLINE=$G(MSGLINE)+1
 S XQSTXT(MSGLINE)=$P(MSG,"~",1)
 Q:MSG'["~"
 S XQSTXT(MSGLINE)="  YRS="_+SERVYRS_"  TOT HRS="_+(HRSPRYR+HRSCURYR)_"  AWD HRS/DATE/CODE="_$$AWD(AWDHRS,AWDDATE,AWDCODE)_"  TERM DATE="_$$FULLDAT^ABSVU2(TERMDATE) S MSGLINE=MSGLINE+1
 QUIT
AWD(X,Y,Z) ;
 S X=$$BLANK(X)
 I +X=0,Y="",Z="" Q ""
 I Y="",Z="" Q +X
 I Y="" S Y=" "
 Q (+X_"/"_$$FULLDAT^ABSVU2(Y)_"/"_Z)