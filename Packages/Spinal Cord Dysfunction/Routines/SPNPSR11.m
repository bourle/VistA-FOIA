SPNPSR11 ;HIRMFO/DAD,WAA-HUNT: IMPAIRMENTS ;8/7/95  15:42
 ;;2.0;Spinal Cord Dysfunction;**10**;01/02/1997
 ;
EN1(D0,INJURY) ; *** Search entry point
 ; Input:
 ;  ACTION,SEQUENCE = Search ACTION,SEQUENCE number
 ;  D0       = SCD (SPINAL CORD) REGISTRY file (#154) IEN
 ;  ^TMP($J,"SPNPRT",ACTION,SEQUENCE,"COMPLETENESS OF INJURY") = Internal ^ External
 ;       INJURY= Internal
 ; Output: 
 ;  $S( D0_Meets_Search_Criteria : 1 , 1 : 0 )
 ;
 ;N I,INJURNUM,INJURTXT,MEETSRCH,INJURY2 ;**MOD,AB, Added INJURY2 to New List here**
 ;**MOD,AB, Per NOIS BIR-1098-30014, Change "INJURY=" to "INJURY2=", 10/9/98
 S INJURY2=INJURY
 ;**MOD,AB, Per NOIS BIR-1098-30014, Change next line "INJURY=" to "INJURY2=", 10/9/98
 F I=0:1 S INJURY2=$P($T(EN1DATA+I+1^SPNLUTL0),";",3) Q:INJURY2=""  D
 . S INJURY(INJURY2)=I
 . Q
 S MEETSRCH=0
 S INJURY=","_INJURY_","
 S INJURTXT=$$EN1^SPNLUTL0(D0)
 S INJURNUM=$S(INJURTXT]"":$G(INJURY(INJURTXT)),1:"")
 ;**MOD,AB,Per NOIS BIR-1098-30014, LINE AFTER NEXT LINE, 10/9/98
 I INJURY[(","_INJURNUM_",") S MEETSRCH=1
 Q MEETSRCH
 ;
EN2(ACTION,SEQUENCE) ; *** Prompt entry point
 ; Input:
 ;  ACTION,SEQUENCE = Search ACTION,SEQUENCE number
 ; Output:
 ;  SPNLEXIT = $S( User_Abort/Timeout : 1 , 1 : 0 )
 ;  ^TMP($J,"SPNPRT",ACTION,SEQUENCE,"COMPLETENESS OF INJURY") = Internal ^ External
 ;  ^TMP($J,"SPNPRT",ACTION,SEQUENCE,0) = $$EN1^SPNPSR11(DO,INJURY)
 ;
 ;N DIR,DIRUT,DTOUT,DUOUT,I,INJURNUM,INJURTXT,INJURY
 K ^TMP($J,"SPNPRT",ACTION,SEQUENCE),DIR
 F INJURNUM=0:1 S INJURTXT=$P($T(EN1DATA+INJURNUM+1^SPNLUTL0),";",3) Q:INJURTXT=""  D
 . S DIR("?",INJURNUM+1)="  "_INJURNUM_" - "_INJURTXT
 . S INJURY(INJURNUM)=INJURTXT
 . Q
 S DIR("?",INJURNUM)=""
 S DIR("?",INJURNUM+1)="You may enter a range of impairments '1-3',"
 S DIR("?",INJURNUM+2)="discrete impairments '1,3,5', or any"
 S DIR("?",INJURNUM+3)="combination of these '1-3,5,7'."
 S DIR("?")="Choose any combination of impairments by number"
 S DIR(0)="LOA^0:"_(INJURNUM-1)
 S DIR("A")="Impairments: "
 D ^DIR S INJURY=Y
 S SPNLEXIT=$S($D(DTOUT):1,$D(DUOUT):1,1:0)
 I 'SPNLEXIT,Y'="" D
 . I $E(INJURY,$L(INJURY))="," S INJURY=$E(INJURY,1,$L(INJURY)-1)
 . S INJURY=INJURY_U
 . F I=1:1:$L(INJURY,",") D
 .. S INJURY=INJURY_$G(INJURY(+$P(INJURY,",",I)))_";"
 .. Q
 . I $E(INJURY,$L(INJURY))=";" S INJURY=$E(INJURY,1,$L(INJURY)-1)
 . S ^TMP($J,"SPNPRT",ACTION,SEQUENCE,"COMPLETENESS OF INJURY")=INJURY
 .;**MOD,AB-Per NOIS BIR-1098-30014, see line below next line, 10/9/98
 .; S ^TMP($J,"SPNPRT",ACTION,SEQUENCE,0)="$$EN1^SPNPSR11(D0,"_$P(INJURY,U)_")"
 . S ^TMP($J,"SPNPRT",ACTION,SEQUENCE,0)="$$EN1^SPNPSR11(D0,"_""""_$P(INJURY,U)_""""_")"
 . Q
 Q