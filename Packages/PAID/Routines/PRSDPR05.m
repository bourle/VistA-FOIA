PRSDPR05 ;HISC/MGD-PAID PAYRUN DOWNLOAD RECORD 5 LAYOUT ;05/13/04
 ;;4.0;PAID;**34,73**;Sep 21, 1995
 F CC=1:1 S GRP=$T(@CC) Q:GRP=""  S GRPVAL=$P(RCD,":",CC) I GRPVAL'="" S GNUM=$P(GRP,";",4),LTH=$P(GRP,";",5),PIC=$P(GRP,";",6) D:PIC=9 PIC9^PRSDUTIL F EE=1:1:GNUM S FLD=$T(@CC+EE) D EPTSET^PRSDSET
 Q
RECORD ;;Record 5;32
 ;;
1 ;;Group 1;1;7;9
 ;;TPVA-1PER;TSP 1-PCT GOV CONTRIB YTD;1;7;TSP1;1;D SIGN^PRSDUTIL,DD^PRSDUTIL;;;395
 ;;
2 ;;Group 2;1;7;9
 ;;TPBASYTD;TSP BASE PAY AMT YTD;1;7;TSP1;3;D SIGN^PRSDUTIL,DD^PRSDUTIL;;;397
 ;;
3 ;;Group 3;1;7;9
 ;;ASCITTAX;CITY TAX-2 AMT WITHHELD CPPD;1;7;CITY;15;D SIGN^PRSDUTIL,DD^PRSDUTIL;1;5;201;A
 ;;
4 ;;Group 4;1;5;9
 ;;AUGFDED;CFC DEDUCTION CPPD;1;5;CFC;3;D SIGN^PRSDUTIL,DD^PRSDUTIL;2;7;211;A
 ;;
5 ;;Group 5;1;5;9
 ;;ACOMP;COMPTIME/CREDIT HRS BALANCE;1;5;COMP;9;D SIGN^PRSDUTIL,DD^PRSDUTIL;4;4;496;O
 ;;
6 ;;Group 6;1;4;9
 ;;AUNIONDUE1;UNION DUES-1 DEDUCTION CPPD;1;4;UNION;4;D SIGN^PRSDUTIL,DD^PRSDUTIL;2;5;431;A
 ;;
7 ;;Group 7;1;4;9
 ;;AUNIONDUE2;UNION DUES-2 DEDUCTION CPPD;1;4;UNION;6;D SIGN^PRSDUTIL,DD^PRSDUTIL;2;6;433;A
 ;;
8 ;;Group 8;1;9;9
 ;;AB1BAL;SAVINGS BOND-1 BALANCE;1;9;BOND1;5;D SIGN^PRSDUTIL,DD^PRSDUTIL;2;19;347;O
 ;;
9 ;;Group 9;1;9;9
 ;;AB2BAL;SAVINGS BOND-2 BALANCE;1;9;BOND2;4;D SIGN^PRSDUTIL,DD^PRSDUTIL;2;20;361;O
 ;;
10 ;;Group 10;1;7;9
 ;;ABASE;BASE PAY CPPD;1;7;PAY;4;D SIGN^PRSDUTIL,DD^PRSDUTIL;5;5;537;A
 ;;
11 ;;Group 11;1;9;9
 ;;AGROSS;GROSS PAY CPPD;1;9;PAY;7;D SIGN^PRSDUTIL,DD^PRSDUTIL;5;1;540;A
 ;;
12 ;;Group 12;1;7;9
 ;;ARETEMP;CSRS REEMP ANNUITANT DED CPPD;1;7;RETIRE;8;D SIGN^PRSDUTIL,DD^PRSDUTIL;1;19;336;A
 ;;
13 ;;Group 13;1;7;9
 ;;ANET;NET PAY CPPD;1;7;PAY;8;D SIGN^PRSDUTIL,DD^PRSDUTIL;5;2;541;A
 ;;
14 ;;Group 14;1;7;9
 ;;AWHTAX;FEDERAL TAX AMT WITHHELD CPPD;1;7;FED;5;D SIGN^PRSDUTIL,DD^PRSDUTIL;1;1;216;A
 ;;
15 ;;Group 15;1;7;9
 ;;ARETIREVA;RETIREMENT VA SHARE CPPD;1;7;RETIRE;10;D SIGN^PRSDUTIL,DD^PRSDUTIL;1;21;338;A
 ;;
16 ;;Group 16;1;9;9
 ;;AFICAVA;OASDI TAX VA SHARE CPPD;1;9;OASDI;7;D SIGN^PRSDUTIL,DD^PRSDUTIL;1;10;296;A
 ;;
17 ;;Group 17;1;9;9
 ;;AB1DED;SAVINGS BOND DED SUM CPPD;1;9;BOND1;1;D SIGN^PRSDUTIL,DD^PRSDUTIL,BONDS^PRSDCOMP;2;21;343;A
 ;;
18 ;;Group 18;1;4;9
 ;;ACOMPUSED;COMPTIME/CREDIT HRS USED CPPD;1;4;COMP;18;D SIGN^PRSDUTIL,AHRS^PRSDUTIL;4;3;505;A
 ;;
19 ;;Group 19;1;6;9
 ;;ASTAX;STATE TAX-1 AMT WITHHELD CPPD;1;6;STATE;5;D SIGN^PRSDUTIL,DD^PRSDUTIL;1;2;376;A
 ;;
20 ;;Group 20;1;5;9
 ;;ALIDEDEMP;FEGLI BASIC DEDUCTION CPPD;1;5;FEGLI;3;D SIGN^PRSDUTIL,DD^PRSDUTIL;1;14;225;A
 ;;
21 ;;Group 21;1;5;9
 ;;ALIDEDVA;FEGLI VA SHARE CPPD;1;5;FEGLI;7;D SIGN^PRSDUTIL,DD^PRSDUTIL;1;15;229;A
 ;;
22 ;;Group 22;1;5;9
 ;;AFAMLI;FEGLI FAMILY DEDUCTION CPPD;1;5;FEGLI;5;D SIGN^PRSDUTIL,DD^PRSDUTIL;1;12;227;A
 ;;
23 ;;Group 23;1;7;9
 ;;AMEDTAX;MEDICARE AMT WITHHELD CPPD;1;7;MEDICARE;1;D SIGN^PRSDUTIL,DD^PRSDUTIL;1;6;250;A
 ;;
24 ;;Group 24;1;7;9
 ;;AMEDWAGE;MEDICARE GROSS PAY CPPD;1;7;MEDICARE;4;D SIGN^PRSDUTIL,DD^PRSDUTIL;1;7;253;A
 ;;
25 ;;Group 25;1;7;9
 ;;AHIDEDEMP;HEALTH BENEFITS DEDUCTION CPPD;1;7;FEHB;1;D SIGN^PRSDUTIL,DD^PRSDUTIL;1;17;230;A
 ;;
26 ;;Group 26;1;7;9
 ;;AHIDEDVA;HEALTH BENEFITS VA SHARE CPPD;1;7;FEHB;6;D SIGN^PRSDUTIL,DD^PRSDUTIL;1;18;235;A
 ;;
27 ;;Group 27;1;7;9
 ;;ASEVPAY;SEVERANCE PAY AMT CPPD;1;7;MISC4;18;D SIGN^PRSDUTIL,DD^PRSDUTIL;3;2;457;A
 ;;
28 ;;Group 28;1;5;9
 ;;ANITEPAY;NIGHT DIFF AMT CPPD;1;5;PREMIUM;7;D SIGN^PRSDUTIL,DD^PRSDUTIL;5;10;549;A
 ;;
29 ;;Group 29;1;5;9
 ;;AHOLPAY;HOLIDAY AMT;1;5;PREMIUM;4;D SIGN^PRSDUTIL,DD^PRSDUTIL;5;8;546;A
 ;;
30 ;;Group 30;1;5;9
 ;;ASTDBY;STANDBY AMT CPPD;1;5;PREMIUM;17;D SIGN^PRSDUTIL,DD^PRSDUTIL;5;18;559;A
 ;;
31 ;;Group 31;1;7;9
 ;;AGARNISH-COM3;COMMERCIAL GARNISHMENT-3;1;7;ACSB;21;D SIGN^PRSDUTIL,DD^PRSDUTIL;3;13;764;
 ;;
32 ;;Group 32;1;7;9
 ;;AGARNISH-COM4;COMMERCIAL GARNISHMENT-4;1;7;ACSB;22;D SIGN^PRSDUTIL,DD^PRSDUTIL;3;14;765;
