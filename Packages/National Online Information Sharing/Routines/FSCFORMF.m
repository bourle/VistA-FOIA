FSCFORMF ;SLC/STAFF-NOIS Format Formats ;4/22/94  10:49
 ;;1.1;NOIS;;Sep 06, 1998
 ;
FORMAT ; from FSCFORM
 N FTYPE,EXECUTE
 I $D(FORMAT("E")) D EXTRACT^FSCRX Q
 I $D(FSCSTYLE("E")) M FORMAT=FSCSTYLE D EXTRACT^FSCRX Q
 S FTYPE=+$G(FORMAT("F")) I 'FTYPE S FTYPE=+$G(FSCSTYLE("F")) I 'FTYPE Q  ;***use one array
 S EXECUTE=$G(^FSC("FORMAT",FTYPE,1)) Q:'$L(EXECUTE)
 X EXECUTE
 Q