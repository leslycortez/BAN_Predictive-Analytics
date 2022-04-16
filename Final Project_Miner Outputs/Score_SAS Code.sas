*------------------------------------------------------------*;
* EM SCORE CODE;
*------------------------------------------------------------*;
*------------------------------------------------------------*;
* TOOL: Extension Class;
* TYPE: SAMPLE;
* NODE: FIMPORT;
*------------------------------------------------------------*;
*------------------------------------------------------------*;
* TOOL: Partition Class;
* TYPE: SAMPLE;
* NODE: Part;
*------------------------------------------------------------*;
*------------------------------------------------------------*;
* TOOL: Extension Class;
* TYPE: MODIFY;
* NODE: Repl;
*------------------------------------------------------------*;
* ;
* Variable: deg_malig ;
* ;
Label REP_deg_malig='Replacement: deg-malig';
Length REP_deg_malig 8;
REP_deg_malig =deg_malig ;
if deg_malig  eq . then REP_deg_malig = . ;
else
if deg_malig <-0.232071427  then REP_deg_malig  = -0.232071427 ;
else
if deg_malig >4.2320714274  then REP_deg_malig  = 4.2320714274 ;

* ;
* Defining New Variables;
* ;
Length REP_breast_quad $9;
Label REP_breast_quad='Replacement: breast-quad';
REP_breast_quad= breast_quad;
Length REP_inv_nodes $9;
Label REP_inv_nodes='Replacement: inv-nodes';
REP_inv_nodes= inv_nodes;
Length REP_node_caps $3;
Label REP_node_caps='Replacement: node-caps';
REP_node_caps= node_caps;
Length REP_tumor_size $9;
Label REP_tumor_size='Replacement: tumor-size';
REP_tumor_size= tumor_size;

* ;
* Replace Specific Class Levels ;
* ;
length _UFormat200 $200;
drop   _UFORMAT200;
_UFORMAT200 = " ";
* ;
* Variable: breast_quad;
* ;
_UFORMAT200 = strip(breast_quad);
if _UFORMAT200 =  '?' then
REP_breast_quad='';
* ;
* Variable: inv_nodes;
* ;
_UFORMAT200 = strip(inv_nodes);
if _UFORMAT200 =  '05-Mar' then
REP_inv_nodes='_UNKNOWN_';
else
if _UFORMAT200 =  '11-Sep' then
REP_inv_nodes='_UNKNOWN_';
else
if _UFORMAT200 =  '15-17' then
REP_inv_nodes='_UNKNOWN_';
else
if _UFORMAT200 =  '08-Jun' then
REP_inv_nodes='_UNKNOWN_';
else
if _UFORMAT200 =  '24-26' then
REP_inv_nodes='_UNKNOWN_';
* ;
* Variable: node_caps;
* ;
_UFORMAT200 = strip(node_caps);
if _UFORMAT200 =  '?' then
REP_node_caps='';
* ;
* Variable: tumor_size;
* ;
_UFORMAT200 = strip(tumor_size);
if _UFORMAT200 =  '14-Oct' then
REP_tumor_size='_UNKNOWN_';
else
if _UFORMAT200 =  '09-May' then
REP_tumor_size='_UNKNOWN_';
*------------------------------------------------------------*;
* TOOL: Imputation;
* TYPE: MODIFY;
* NODE: Impt;
*------------------------------------------------------------*;
*;
* TREE IMPUTATION;
*;
*;
* IMPUTE VARIABLE: REP_breast_quad;
*;
length IMP_REP_breast_quad $9;
label IMP_REP_breast_quad = 'Imputed: Replacement: breast-quad';
IMP_REP_breast_quad = REP_breast_quad;
if IMP_REP_breast_quad eq '' then do;
****************************************************************;
****** DECISION TREE SCORING CODE ******;
****************************************************************;
****** LENGTHS OF NEW CHARACTER VARIABLES ******;
LENGTH I_REP_breast_quad $ 9;
LENGTH U_REP_breast_quad $ 9;
LENGTH _WARN_ $ 4;
****** LABELS FOR NEW VARIABLES ******;
label P_REP_breast_quadleft_low = 'Predicted: REP_breast_quad=left_low';
label P_REP_breast_quadleft_up = 'Predicted: REP_breast_quad=left_up';
label P_REP_breast_quadright_low = 'Predicted: REP_breast_quad=right_low';
label P_REP_breast_quadright_up = 'Predicted: REP_breast_quad=right_up';
label P_REP_breast_quadcentral = 'Predicted: REP_breast_quad=central';
label Q_REP_breast_quadleft_low = 'Unadjusted P: REP_breast_quad=left_low';
label Q_REP_breast_quadleft_up = 'Unadjusted P: REP_breast_quad=left_up';
label Q_REP_breast_quadright_low = 'Unadjusted P: REP_breast_quad=right_low';
label Q_REP_breast_quadright_up = 'Unadjusted P: REP_breast_quad=right_up';
label Q_REP_breast_quadcentral = 'Unadjusted P: REP_breast_quad=central';
label I_REP_breast_quad = 'Into: REP_breast_quad';
label U_REP_breast_quad = 'Unnormalized Into: REP_breast_quad';
label _WARN_ = 'Warnings';
****** TEMPORARY VARIABLES FOR FORMATTED VALUES ******;
LENGTH _ARBFMT_9 $ 9;
DROP _ARBFMT_9;
_ARBFMT_9 = ' ';
/* Initialize to avoid warning. */
LENGTH _ARBFMT_5 $ 5;
DROP _ARBFMT_5;
_ARBFMT_5 = ' ';
/* Initialize to avoid warning. */
LENGTH _ARBFMT_3 $ 3;
DROP _ARBFMT_3;
_ARBFMT_3 = ' ';
/* Initialize to avoid warning. */
****** ASSIGN OBSERVATION TO NODE ******;
DROP _BRANCH_;
_BRANCH_ = -1;
_ARBFMT_5 = PUT( breast , $5.);
%DMNORMIP( _ARBFMT_5);
IF _ARBFMT_5 IN ('LEFT' ) THEN DO;
_BRANCH_ = 1;
END;
ELSE IF _ARBFMT_5 IN ('RIGHT' ) THEN DO;
_BRANCH_ = 2;
END;
IF _BRANCH_ LT 0 AND NOT MISSING(irradiat ) THEN DO;
_ARBFMT_3 = PUT( irradiat , $3.);
%DMNORMIP( _ARBFMT_3);
IF _ARBFMT_3 IN ('YES' ) THEN DO;
_BRANCH_ = 1;
END;
ELSE IF _ARBFMT_3 IN ('NO' ) THEN DO;
_BRANCH_ = 2;
END;
END;
IF _BRANCH_ LT 0 AND NOT MISSING(REP_tumor_size ) THEN DO;
_ARBFMT_9 = PUT( REP_tumor_size , $9.);
%DMNORMIP( _ARBFMT_9);
IF _ARBFMT_9 IN ('30-34' ,'15-19' ,'25-29' ,'_UNKNOWN_' ) THEN DO;
_BRANCH_ = 1;
END;
ELSE IF _ARBFMT_9 IN ('40-44' ,'20-24' ,'35-39' ) THEN DO;
_BRANCH_ = 2;
END;
END;
IF _BRANCH_ LT 0 THEN _BRANCH_ = 1;
IF _BRANCH_ EQ 2 THEN DO;
P_REP_breast_quadleft_low = 0.18181818181818;
P_REP_breast_quadleft_up = 0.45454545454545;
P_REP_breast_quadright_low = 0.01818181818181;
P_REP_breast_quadright_up = 0.25454545454545;
P_REP_breast_quadcentral = 0.09090909090909;
Q_REP_breast_quadleft_low = 0.18181818181818;
Q_REP_breast_quadleft_up = 0.45454545454545;
Q_REP_breast_quadright_low = 0.01818181818181;
Q_REP_breast_quadright_up = 0.25454545454545;
Q_REP_breast_quadcentral = 0.09090909090909;
I_REP_breast_quad = 'LEFT_UP';
U_REP_breast_quad = 'left_up';
END;
ELSE DO;
P_REP_breast_quadleft_low = 0.59649122807017;
P_REP_breast_quadleft_up = 0.19298245614035;
P_REP_breast_quadright_low = 0.08771929824561;
P_REP_breast_quadright_up = 0.07017543859649;
P_REP_breast_quadcentral = 0.05263157894736;
Q_REP_breast_quadleft_low = 0.59649122807017;
Q_REP_breast_quadleft_up = 0.19298245614035;
Q_REP_breast_quadright_low = 0.08771929824561;
Q_REP_breast_quadright_up = 0.07017543859649;
Q_REP_breast_quadcentral = 0.05263157894736;
I_REP_breast_quad = 'LEFT_LOW';
U_REP_breast_quad = 'left_low';
END;
****************************************************************;
****** END OF DECISION TREE SCORING CODE ******;
****************************************************************;
*;
* ASSIGN VALUE TO: REP_breast_quad;
*;
length _format200 $200;
drop _format200;
_format200 = strip(I_REP_breast_quad);
if _format200="RIGHT_UP" then IMP_REP_breast_quad = "right_up ";
else
if _format200="RIGHT_LOW" then IMP_REP_breast_quad = "right_low";
else
if _format200="LEFT_UP" then IMP_REP_breast_quad = "left_up  ";
else
if _format200="LEFT_LOW" then IMP_REP_breast_quad = "left_low ";
else
if _format200="CENTRAL" then IMP_REP_breast_quad = "central  ";
END;
*;
* IMPUTE VARIABLE: REP_node_caps;
*;
length IMP_REP_node_caps $3;
label IMP_REP_node_caps = 'Imputed: Replacement: node-caps';
IMP_REP_node_caps = REP_node_caps;
if IMP_REP_node_caps eq '' then do;
****************************************************************;
****** DECISION TREE SCORING CODE ******;
****************************************************************;
****** LENGTHS OF NEW CHARACTER VARIABLES ******;
LENGTH I_REP_node_caps $ 3;
LENGTH U_REP_node_caps $ 3;
LENGTH _WARN_ $ 4;
****** LABELS FOR NEW VARIABLES ******;
label P_REP_node_capsno = 'Predicted: REP_node_caps=no';
label P_REP_node_capsyes = 'Predicted: REP_node_caps=yes';
label Q_REP_node_capsno = 'Unadjusted P: REP_node_caps=no';
label Q_REP_node_capsyes = 'Unadjusted P: REP_node_caps=yes';
label I_REP_node_caps = 'Into: REP_node_caps';
label U_REP_node_caps = 'Unnormalized Into: REP_node_caps';
label _WARN_ = 'Warnings';
****** TEMPORARY VARIABLES FOR FORMATTED VALUES ******;
LENGTH _ARBFMT_3 $ 3;
DROP _ARBFMT_3;
_ARBFMT_3 = ' ';
/* Initialize to avoid warning. */
LENGTH _ARBFMT_9 $ 9;
DROP _ARBFMT_9;
_ARBFMT_9 = ' ';
/* Initialize to avoid warning. */
****** ASSIGN OBSERVATION TO NODE ******;
_ARBFMT_9 = PUT( REP_inv_nodes , $9.);
%DMNORMIP( _ARBFMT_9);
IF _ARBFMT_9 IN ('_UNKNOWN_' ) THEN DO;
P_REP_node_capsno = 0.38461538461538;
P_REP_node_capsyes = 0.61538461538461;
Q_REP_node_capsno = 0.38461538461538;
Q_REP_node_capsyes = 0.61538461538461;
I_REP_node_caps = 'YES';
U_REP_node_caps = 'yes';
END;
ELSE DO;
P_REP_node_capsno = 0.94117647058823;
P_REP_node_capsyes = 0.05882352941176;
Q_REP_node_capsno = 0.94117647058823;
Q_REP_node_capsyes = 0.05882352941176;
I_REP_node_caps = 'NO';
U_REP_node_caps = 'no';
END;
****************************************************************;
****** END OF DECISION TREE SCORING CODE ******;
****************************************************************;
*;
* ASSIGN VALUE TO: REP_node_caps;
*;
length _format200 $200;
drop _format200;
_format200 = strip(I_REP_node_caps);
if _format200="YES" then IMP_REP_node_caps = "yes";
else
if _format200="NO" then IMP_REP_node_caps = "no ";
END;
*;
* Drop prediction variables since they are for INPUTS not TARGETS;
* Replace _NODE_ by _XODE_ so it can be safely dropped;
*;
drop
P_REP_breast_quadcentral
P_REP_breast_quadright_up
P_REP_breast_quadright_low
P_REP_breast_quadleft_up
P_REP_breast_quadleft_low
I_REP_breast_quad
U_REP_breast_quad
Q_REP_breast_quadcentral
Q_REP_breast_quadright_up
Q_REP_breast_quadright_low
Q_REP_breast_quadleft_up
Q_REP_breast_quadleft_low
P_REP_node_capsyes
P_REP_node_capsno
I_REP_node_caps
U_REP_node_caps
Q_REP_node_capsyes
Q_REP_node_capsno
;
*;
*INDICATOR VARIABLES;
*;
label M_REP_breast_quad = "Imputation Indicator for REP_breast_quad";
if REP_breast_quad = '' then M_REP_breast_quad = 1;
else M_REP_breast_quad= 0;
label M_REP_node_caps = "Imputation Indicator for REP_node_caps";
if REP_node_caps = '' then M_REP_node_caps = 1;
else M_REP_node_caps= 0;
*------------------------------------------------------------*;
* TOOL: Transform;
* TYPE: MODIFY;
* NODE: Trans;
*------------------------------------------------------------*;
*------------------------------------------------------------*;
* TOOL: Extension Class;
* TYPE: UTILITY;
* NODE: Grp;
*------------------------------------------------------------*;
*------------------------------------------------------------*;
* TOOL: Extension Class;
* TYPE: MODEL;
* NODE: EndGrp;
*------------------------------------------------------------*;
*------------------------------------------------------------* ;
* Grp: StartGroup;
* User: u59400043;
* Date: 15APR22: 07:30;
* Group: ^(M_REP_breast_quad =0 and M_REP_node_caps =0);
*------------------------------------------------------------*;
if (M_REP_breast_quad =0 and M_REP_node_caps =0)  then do;
_XVAL_=1;
*------------------------------------------------------------* ;
* Tree: DecisionTree;
* User: u59400043;
* Date: 15APR22: 07:30;
* Group: ^(M_REP_breast_quad =0 and M_REP_node_caps =0);
*------------------------------------------------------------*;
****************************************************************;
******             DECISION TREE SCORING CODE             ******;
****************************************************************;

******         LENGTHS OF NEW CHARACTER VARIABLES         ******;
LENGTH I_Class  $   20;
LENGTH U_Class  $   20;
LENGTH _WARN_  $    4;

******              LABELS FOR NEW VARIABLES              ******;
label _NODE_ = 'Node' ;
label _LEAF_ = 'Leaf' ;
label P_Classno_recurrence_events = 'Predicted: Class=no-recurrence-events' ;
label P_Classrecurrence_events = 'Predicted: Class=recurrence-events' ;
label Q_Classno_recurrence_events =
'Unadjusted P: Class=no-recurrence-events' ;
label Q_Classrecurrence_events = 'Unadjusted P: Class=recurrence-events' ;
label I_Class = 'Into: Class' ;
label U_Class = 'Unnormalized Into: Class' ;
label _WARN_ = 'Warnings' ;


******      TEMPORARY VARIABLES FOR FORMATTED VALUES      ******;
LENGTH _ARBFMT_20 $     20; DROP _ARBFMT_20;
_ARBFMT_20 = ' '; /* Initialize to avoid warning. */


******             ASSIGN OBSERVATION TO NODE             ******;
_NODE_  =                    1;
_LEAF_  =                    1;
P_Classno_recurrence_events  =     0.66666666666666;
P_Classrecurrence_events  =     0.33333333333333;
Q_Classno_recurrence_events  =     0.66666666666666;
Q_Classrecurrence_events  =     0.33333333333333;
I_Class  = 'NO-RECURRENCE-EVENTS' ;
U_Class  = 'no-recurrence-events' ;

****************************************************************;
******          END OF DECISION TREE SCORING CODE         ******;
****************************************************************;

drop _LEAF_;
*------------------------------------------------------------* ;
* MdlComp: ModelCompare;
* User: u59400043;
* Date: 15APR22: 07:30;
* Group: ^(M_REP_breast_quad =0 and M_REP_node_caps =0);
*------------------------------------------------------------*;
drop _temp_;
if (P_Classrecurrence_events ge 0.33333333333333) then do;
b_Class = 1;
end;
else
if (P_Classrecurrence_events ge 0.33333333333333) then do;
_temp_ = dmran(1234);
b_Class = floor(6 + 2*_temp_);
end;
else
if (P_Classrecurrence_events ge 0.33333333333333) then do;
_temp_ = dmran(1234);
b_Class = floor(13 + 2*_temp_);
end;
else
do;
b_Class = 20;
end;
*------------------------------------------------------------* ;
* EndGrp: EndGroup;
* User: u59400043;
* Date: 15APR22: 07:30;
* Group: ^(M_REP_breast_quad =0 and M_REP_node_caps =0);
*------------------------------------------------------------*;
end;
*------------------------------------------------------------*;
* TOOL: Score Node;
* TYPE: ASSESS;
* NODE: Score;
*------------------------------------------------------------*;
*------------------------------------------------------------*;
* Score: Creating Fixed Names;
*------------------------------------------------------------*;
LABEL EM_SEGMENT = 'Node';
EM_SEGMENT = _NODE_;
LENGTH EM_EVENTPROBABILITY 8;
LABEL EM_EVENTPROBABILITY = 'Probability for level RECURRENCE-EVENTS of Class';
EM_EVENTPROBABILITY = P_Classrecurrence_events;
LENGTH EM_PROBABILITY 8;
LABEL EM_PROBABILITY = 'Probability of Classification';
EM_PROBABILITY =
max(
P_Classrecurrence_events
,
P_Classno_recurrence_events
);
LENGTH EM_CLASSIFICATION $%dmnorlen;
LABEL EM_CLASSIFICATION = "Prediction for Class";
EM_CLASSIFICATION = I_Class;
