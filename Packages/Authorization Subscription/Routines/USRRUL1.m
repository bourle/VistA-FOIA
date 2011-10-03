USRRUL1 ; SLC/JER - Rule Browser subroutines & functions ; 05/13/1998
 ;;1.0;AUTHORIZATION/SUBSCRIPTION;**7**;Jun 20, 1997
UPDATE(ITEM) ; Updates list following edit
 N USRDA,USRULE,USRPAD
 S $P(USRPAD," ",6-$L(+ITEM))=""
 S USRDA=$P(ITEM,U,2)
 D XLATE^USRAEDT(.USRULE,USRDA)
 D SET^VALM10(+ITEM,+ITEM_USRPAD_$P(USRULE,"|"),USRDA)
 D RESTORE^VALM10(+ITEM),CNTRL^VALM10(+ITEM,1,VALM("RM"),IOINHI,IOINORM)
 Q
RESIZE(LONG,SHORT,SHRINK) ; Resizes list area
 N USRBM S USRBM=$S(VALMMENU:SHORT,+$G(SHRINK):SHORT,1:LONG)
 I VALM("BM")'=USRBM S VALMBCK="R" D
 . S VALM("BM")=USRBM,VALM("LINES")=(USRBM-VALM("TM"))+1
 . I +$G(VALMCC) D RESET^VALM4
 Q
PICK(USRITEM) ; Highlight selected list elements, add to VALMY(ITEM) array
 N I,ITEM,LINE,MRSI
 F I=1:1:$L(USRITEM,",") S ITEM=$P(USRITEM,",",I) Q:+ITEM'>0  D
 . S LINE=+$O(@VALMAR@("IDX",+ITEM,0))
 . I '+LINE S LINE=ITEM
 .;Keep track of the most recently selected item.
 . S MRSI=ITEM
 . I '$D(VALMY(ITEM)) D  I 1
 . . D RESTORE^VALM10(LINE),CNTRL^VALM10(LINE,6,VALM("RM"),IORVON,IORVOFF)
 . . D WRITE^VALM10(LINE)
 . . S VALMY(ITEM)=""
 . E  D
 . . D RESTORE(LINE),WRITE^VALM10(LINE)
 . . K VALMY(ITEM)
 ;Move the display to 5 lines before the MRSI
 S VALMBG=$$MAX^XLFMTH(1,(MRSI-5))
 D RE^VALM4
 Q
FIXLST ; Restore video attributes to entire list
 N USRI S USRI=0
 Q:'$D(VALMAR)
 F  S USRI=$O(@VALMAR@(USRI)) Q:+USRI'>0  D
 . D RESTORE^VALM10(USRI)
 Q
RESTORE(ITEM) ; Restore video attributes for a single list element
 D RESTORE^VALM10(ITEM)
 Q
REMOVE(ITEM) ; Remove an element from the list
 N USRULE,USRPAD
 S $P(USRPAD," ",6-$L(USRCNT))=""
 S USRULE="<Business Rule DELETED>"
 D SET^VALM10(+ITEM,+ITEM_USRPAD_USRULE,+$P(ITEM,U,2))
 D RESTORE^VALM10(+ITEM),CNTRL^VALM10(+ITEM,6,VALM("RM"),IOINHI,IOINORM)
 Q