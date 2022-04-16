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
length _UFormat200 $200;
drop   _UFORMAT200;
_UFORMAT200 = " ";

* ;
* Defining: REP_breast_quad;
* ;
Length REP_breast_quad$9;
Label REP_breast_quad='Replacement: breast-quad';
REP_breast_quad=breast_quad;
* ;
* Variable: breast_quad;
* ;
_UFORMAT200 = strip(breast_quad);
if _UFORMAT200 =  '?' then
REP_breast_quad='';

* ;
* Defining: REP_node_caps;
* ;
Length REP_node_caps$3;
Label REP_node_caps='Replacement: node-caps';
REP_node_caps=node_caps;
* ;
* Variable: node_caps;
* ;
_UFORMAT200 = strip(node_caps);
if _UFORMAT200 =  '?' then
REP_node_caps='';
*------------------------------------------------------------*;
* TOOL: Imputation;
* TYPE: MODIFY;
* NODE: Impt;
*------------------------------------------------------------*;
label M_REP_breast_quad = "Imputation Indicator for REP_breast_quad";
if REP_breast_quad = '' then M_REP_breast_quad = 1;
else M_REP_breast_quad= 0;
label M_REP_node_caps = "Imputation Indicator for REP_node_caps";
if REP_node_caps = '' then M_REP_node_caps = 1;
else M_REP_node_caps= 0;
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
