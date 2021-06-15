*_________________________________________________________________________________________________;

*....................*****... SARA UNIVARIATE and BIVARIATE ANALYSIS...*****......................;
*_________________________________________________________________________________________________;

*EDA-1)Univariate Analysis;
*---------------------------;

*EDA-1-1)CONTINOUSE DATA : 
---------------------------;
%MACRO SARA_UNI_ANALYSIS_NUM(DATA,VAR);
 TITLE "THIS IS HISTOGRAM FOR &VAR";
 PROC SGPLOT DATA=&DATA;
  HISTOGRAM &VAR;
  DENSITY &VAR;
  DENSITY &VAR/type=kernel ;
    STYLEATTRS 
    BACKCOLOR=DARKGREY 
    WALLCOLOR=LIGHTGREY
     ;
  keylegend / location=inside position=topright;
 RUN;
 QUIT;
 TITLE "THIS IS HORIZONTAL BOXPLOT FOR &VAR";
 PROC SGPLOT DATA=&DATA;
  HBOX &VAR;
    STYLEATTRS 
    BACKCOLOR=DARKGREY 
    WALLCOLOR=LIGHTPINK
     ;
 RUN;
TITLE "THIS IS UNIVARIATE ANALYSIS FOR &VAR IN &DATA";
proc means data=&DATA  N NMISS MIN Q1 MEDIAN MEAN Q3 MAX qrange cv clm maxdec=2 ;
var &var;
run;
%MEND;


*EDA-1-2)CATEGORICAL VARIABLES:
--------------------------------;
%MACRO SARA_UNI_ANALYSIS_CAT(DATA,VAR);
 TITLE "THIS IS FREQUENCY OF &VAR FOR &DATA";
  PROC FREQ DATA=&DATA;
  TABLE &VAR;
 RUN;

TITLE "THIS IS VERTICAL BARCHART OF &VAR FOR &DATA";
PROC SGPLOT DATA = &DATA;
 VBAR &VAR;
    STYLEATTRS 
    BACKCOLOR=DARKGREY 
    WALLCOLOR=TAN
     ;
 RUN;

TITLE "THIS IS PIECHART OF &VAR FOR &DATA";
PROC GCHART DATA=&DATA;
  PIE3D &VAR/discrete 
             value=inside
             percent=outside
             EXPLODE=ALL
			 SLICE=OUTSIDE
			 RADIUS=20
		
;
RUN;
%MEND;


%MACRO SARA_UNI_ANALYSIS_CAT_FORMAT(DATA,VAR,FORMAT);
 TITLE "THIS IS FREQUENCY OF &VAR FOR &DATA";
  PROC FREQ DATA=&DATA;
  TABLE &VAR;
  FORMAT &VAR &FORMAT;
 RUN;

TITLE "THIS IS VERTICAL BARCHART OF &VAR FOR &DATA";
PROC SGPLOT DATA = &DATA;
 VBAR &VAR;
 FORMAT &VAR &FORMAT;
    STYLEATTRS 
    BACKCOLOR=DARKGREY 
    WALLCOLOR=TAN
     ;
 RUN;

TITLE "THIS IS PIECHART OF &VAR FOR &DATA";
PROC GCHART DATA=&DATA;
  PIE3D &VAR/discrete 
             value=inside
             percent=outside
             EXPLODE=ALL
			 SLICE=OUTSIDE
			 RADIUS=20
		
;
  FORMAT &VAR &FORMAT;

RUN;
%MEND;

*EDA-2) Bivariate Analysis;
*---------------------------;

*EDA-2-1)Continouse Vs. Categorical:
--------------------------------------
    For summaraization: Grouped by categorical column an aggragte for numerical column
    For visualization : Grouped box plot,...
    For test of independence :1) if categorical column has only two levels :t-test
                              2) if categorical column has more than two levels: ANOVA
;


*Macro for RELATION BETWEEN Continouse Vs. Categorical;
*.....................................................;
%MACRO SARA_AGG_CAT_NUM (DSN = ,CLASS = , VAR = );* equal sign after argument is optional;
PROC MEANS DATA = &DSN. MAXDEC= 2 ;
TITLE " RELATION BETWEEN &VAR. AND &CLASS.";
CLASS &CLASS. ;
VAR &VAR.;
OUTPUT OUT = OUT_&CLASS._&VAR. MIN = MEAN = STD = MAX = /AUTONAME ;
RUN;
%MEND SARA_AGG_CAT_NUM;

*Macro ANOVA TEST FOR Continouse Vs. Categorical;
*.....................................................;
%MACRO SARA_ANOVA_CAT_NUM (DSN = ,CLASS = , VAR = );
PROC ANOVA DATA = &DSN. plots(maxpoints=none);
 CLASS &CLASS.;
 MODEL &VAR. = &CLASS.;
 MEANS &CLASS./Scheffe;/*we can consider that at least two group means are statistically signicant from each other if p-value is less than 0.05. So far, the ANOVA only tells you all group means are not statistically significant equal. It does not tell you where the difference lies. For further multiple comparison, we still need Scheffe’s or Tukey test.*/
 TITLE "ANOVA TEST FOR &VAR. VS. &CLASS.";
RUN;
QUIT;
%MEND SARA_ANOVA_CAT_NUM;

*EDA-2-2)Categorical Vs. Categorical:
---------------------------------------
For summaraization: contingency table (two-way table)
For visualization :stacked bar chart,Grouped bar chart,...
For test of independence:chi-square test ;

*Macro for RELATION BETWEEN Categorical Vs. Categorical;
*..................................................;
%MACRO SARA_CHSQUARE_CAT_CAT (DSN = ,VAR1= , VAR2= );
ods graphics on;
proc freq data=&DSN;
TITLE "RELATIONSHIP BETWEEN &VAR1 AND &VAR2";
tables (&VAR1.)*(&VAR2) / chisq
plots=(freqplot(twoway=grouphorizontal
scale=percent));
run;
ods graphics off
%MEND SARA_CHSQUARE_CAT_CAT;

*
COUNTW Function:
................
Counts the number of words in a character string.
;
%MACRO SARA_BI_ANALYSIS_NUMs_CAT (DSN = ,CLASS= , VAR= );
%LET N = %SYSFUNC(COUNTW(&VAR));
%DO I = 1 %TO &N;
	%LET X = %SCAN(&VAR,&I);
	PROC MEANS DATA = &DSN. N NMISS MIN Q1 MEDIAN MEAN Q3 MAX qrange cv clm maxdec=2 ;
	TITLE " RELATION BETWEEN &X. AND &CLASS.";
	CLASS &CLASS. ;
	VAR &X.;
	OUTPUT OUT= OUT_&CLASS._&X. MIN =   MEAN=  STD = MAX = /AUTONAME ;

	RUN;
%END;
%MEND SARA_BI_ANALYSIS_NUMs_CAT;




