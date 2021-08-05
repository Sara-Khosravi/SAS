*___________________________________________________________________________________________________;

/*..............................********   Sara Khosrvi    *********...............................*/
/*..........................***** SUBMITTED BY : MR. ARKAR MIN ******..............................*/
/*...................................Black Friday Sales Data.......................................*/
*___________________________________________________________________________________________________;


*Customer Black Friday Sales Data Analyses;
*---------------------------------------------------------------------------------------------------;
/*
Objective:
----------

The attached data is the Black Friday Sales data. The Black Friday Sales would like to investigate the 
customer distribution and business behaviors, and then gain insightful understanding about the customers,
and to forecast the purchase for the next Black Friday Sales and keep good customer.

Data:
-----
User_ID:			User ID
Product_ID:			Product ID
Gender:			Sex of User
Age:   			Age in bins
Occupation:			Occupation (Masked)
City_Category:		Category of the City (A,B,C)
Stay_In_Current_City_Years:	Number of years stay in current city
Marital_Status:		Marital Status
Product_Category_1:		Product Category (Masked)
Product_Category_2:		Product may belongs to other category also (Masked)
Product_Category_3:		Product may belongs to other category also (Masked)
Purchase:			Purchase Amount (Target Variable)

-----------------------------------------------------------------------------------------------------
*/
/**********************************************************************************************/
*......................................IMPORT DATA.............................................;
/**********************************************************************************************/

LIBNAME Sara "C:\Sara\Data SCIENCE\SAS-SPB\Black Friday";

TITLE " TABLE: BLACK FRIDAY TRAIN ";
PROC IMPORT OUT= SARA.BlackFriday 
            DATAFILE= "C:\Sara\Data SCIENCE\SAS-SPB\Black Friday\train.csv" 
            DBMS=CSV REPLACE;
     GETNAMES=YES;
     DATAROW=2; 
     GUESSINGROWS=50000; 
RUN;
PROC PRINT DATA= SARA.BlackFriday (OBS= 10);RUN;
TITLE;


TITLE " TABLE: BLACK FRIDAY TEST";
PROC IMPORT OUT= SARA.TEST 
            DATAFILE= "C:\Sara\Data SCIENCE\SAS-SPB\Black Friday\test.csv" 
            DBMS=CSV REPLACE;
     GETNAMES=YES;
     DATAROW=2; 
     GUESSINGROWS=50000; 
RUN;
PROC PRINT DATA= SARA.TEST (OBS= 10); RUN;
TITLE;  

/**********************************************************************************************/
*..........................................IMPORT MACRO........................................;
/**********************************************************************************************/

*TO TURN ON MACRO PROCESSOR
---------------------------;
PROC OPTIONS OPTION = MACRO;
RUN;
%include "C:\Sara\Data SCIENCE\SAS-SPB\Black Friday\SARA_MACRO_ DATA ANALYSIS.sas";

/**********************************************************************************************/
*..........................CONVERT NUMERICAL TO CATEGORICAL VARIABLE...........................;
/**********************************************************************************************/

*JUST TO IDENTIFY THE CATEGRICAL VARIABELS AND THE NUMERICAL VARIABLES;
*---------------------------------------------------------------------;
DATA SARA.BlackFriday_C; 
SET SARA.BlackFriday;
	/* 1*/
	User_ID_CHAR = put(User_ID,2.);
	Occupation_CHAR = put(Occupation,2.);
	Marital_Status_CHAR = put(Marital_Status,2.);
	Product_Category_1_CHAR = put(Product_Category_1,2.);
	Product_Category_2_CHAR = put(Product_Category_2,2.);
	Product_Category_3_CHAR = put(Product_Category_3,2.);
 	/* 2*/
	DROP User_ID Occupation Marital_Status Product_Category_1 Product_Category_2 Product_Category_3;                                                                                                                               
	/* 3*/
	RENAME User_ID_CHAR = User_ID
		Occupation_CHAR = Occupation
		Marital_Status_CHAR = Marital_Status
	       Product_Category_1_CHAR = Product_Category_1
		Product_Category_2_CHAR = Product_Category_2
		Product_Category_3_CHAR = Product_Category_3
		;
	/* 4*/
RUN;
PROC CONTENTS DATA= SARA.BlackFriday_C;
RUN;

PROC CONTENTS DATA= SARA.BlackFriday;
RUN;

PROC CONTENTS DATA= SARA.CNBF;
RUN;

PROC PRINT DATA = SARA.BlackFriday_C (OBS=10);
RUN;

*................................. END OF CONVERT DATA TYPE ..................................*;

/**********************************************************************************************/
*......................................DATA PROFILING..........................................;
/**********************************************************************************************/

ODS PDF FILE = "C:\Sara\Data SCIENCE\SAS-SPB\Black Friday\DATA_PROFILING.PDF";
TITLE "DATA PROFILING : BLACK FRIDAY SALES ANALYSIS";
TITLE2 "CREATED BY SARA";
TITLE3 "REPORT DATE :&SYSDATE.";
FOOTNOTE " THE REPORT IS CONFIDENTIAL";
FOOTNOTE2 "INTERNAL USED ONLY";

*PROPERTIES OF DATA SET/DESCRIPTOR PORTION OF YOUR DATASET;
PROC CONTENTS DATA= SARA.BlackFriday_C;
RUN;

PROC CONTENTS DATA= SARA.BlackFriday_C VARNUM SHORT;
RUN;

* User_ID Product_ID Gender Age Occupation City_Category Stay_In_Current_City_Years
  Marital_Status Product_Category_1 Product_Category_2 Product_Category_3 Purchase;

* DATA PORTION OF YOUR DATA SET
-------------------------------;
PROC PRINT DATA = SARA.BlackFriday_C (OBS=20);
 VAR USER_ID Gender Age City_Category Product_Category_1 Product_Category_2 Product_Category_3 Purchase;
RUN;

* NUMERIC DATA= DESCRIPTIVE STATISTICS;
*--------------------------------------;
PROC MEANS DATA= SARA.BlackFriday_C N NMISS MIN MEAN MEDIAN STD MAX MAXDEC=2;
 VAR PURCHASE;
RUN;

TITLE"UNIVARIATE ANALYSIS : Purchase"
PROC UNIVARIATE DATA = SARA.BlackFriday;
 VAR Purchase;
RUN; 
TITLE;

* HISTOGRAM AND DENSITY 
-----------------------;
TITLE "UNIVARIATE ANALYSIS : Purchase";
PROC SGPLOT DATA =  SARA.BlackFriday_C;
 HISTOGRAM Purchase;
 DENSITY Purchase;
RUN;
QUIT;

* BOXPLOT
---------;
TITLE "UNIVARIATE ANALYSIS : Purchase";
PROC SGPLOT DATA =  SARA.BlackFriday_C;
 VBOX Purchase;
RUN;
QUIT;

* CATEGORICAL DATA : FREQUENCY COUNT : ABSOULTE FREQ, 
                     RELATIVE FREQ AND CUMULATIVE FREQ OR RATE/RATIO/PROPORTION;
*------------------------------------------------------------------------------;
PROC FREQ DATA = SARA.BlackFriday_C;
TABLE  Product_ID
	Gender
	Age
	Occupation
	City_Category
	Stay_In_Current_City_Years
	Marital_Status
	Occupation 
	Marital_Status 
	Product_Category_1 
	Product_Category_2 
	Product_Category_3 
; 
RUN;

PROC CONTENTS DATA = SARA.BlackFriday_C OUT= SARA.VAR_NAMES;
RUN;

PROC PRINT DATA = SARA.VAR_NAMES NOOBS;
VAR NAME;
WHERE TYPE = 1;
RUN;

PROC PRINT DATA = SARA.VAR_NAMES NOOBS;
VAR NAME;
WHERE TYPE = 2;
RUN;

*GRAPHICS METHODS FOR CATEGORICAL DATA : BAR CHART/GROUPED BARCHART , PIE CHART;
*------------------------------------------------------------------------------;
TITLE "PIE CHART: GENDER";
PROC GCHART DATA = SARA.BlackFriday_C ;
 PIE Gender;
RUN;
QUIT;
TITLE;

TITLE "PIE CHART: AGE";
PROC GCHART DATA = SARA.BlackFriday_C ;
 PIE AGE ;
 RUN;
QUIT;
TITLE;

TITLE "UNIVARIATE ANALYSIS: Occupation";
PROC SGPLOT DATA = SARA.BlackFriday_C ;
 VBAR Occupation;
RUN;
QUIT;
TITLE;

TITLE "PIE CHART: City_Category";
PROC GCHART DATA = SARA.BlackFriday_C ;
 PIE City_Category;
RUN;
QUIT;
TITLE;

TITLE "PIE CHART: Stay_In_Current_City_Years";
PROC GCHART DATA = SARA.BlackFriday_C ;
 PIE Stay_In_Current_City_Years;
RUN;
QUIT;
TITLE;

TITLE "PIE CHART : Marital Status";
PROC GCHART DATA = SARA.BlackFriday_C ;
 PIE Marital_Status;
RUN;
QUIT;
TITLE;

TITLE "UNIVARIATE ANALYSIS : Product_Category_1";
PROC SGPLOT DATA = SARA.BlackFriday_C ;
 VBAR Product_Category_1 ;
RUN;
QUIT;
TITLE;

TITLE "UNIVARIATE ANALYSIS : Product_Category_2";
PROC SGPLOT DATA = SARA.BlackFriday_C ;
 VBAR Product_Category_2;
RUN;
TITLE;
QUIT;

TITLE "UNIVARIATE ANALYSIS : Product_Category_3";
PROC SGPLOT DATA = SARA.BlackFriday_C ;
 VBAR Product_Category_3;
RUN;
QUIT;
TITLE;

*STACKED BAR CHART OR GROUPED BAR CHART
---------------------------------------;
TITLE "STACKED BAR CHART Stay_In_Current_City_Years VS. City_Category ";
PROC SGPLOT DATA = SARA.BlackFriday_C ;
 VBAR Stay_In_Current_City_Years/GROUP = City_Category ;
RUN;
QUIT;

*DATA PROFILING) Univariate Analysis - CONTINOUSE DATA;
*------------------------------------------------------;
OPTIONS MLOGIC MPRINT SYMBOLGEN;
%SARA_UNI_ANALYSIS_NUM(SARA.BlackFriday,Purchase)

*DATA PROFILING) Univariate Analysis - CATEGORICAL VARIABLES:
------------------------------------------------------------;
OPTIONS MLOGIC MPRINT SYMBOLGEN;
%SARA_UNI_ANALYSIS_CAT(SARA.BlackFriday,Age)
%SARA_UNI_ANALYSIS_CAT(SARA.BlackFriday,Occupation)
%SARA_UNI_ANALYSIS_CAT(SARA.BlackFriday,Gender)
%SARA_UNI_ANALYSIS_CAT(SARA.BlackFriday,City_Category)
%SARA_UNI_ANALYSIS_CAT(SARA.BlackFriday,Marital_Status)
%SARA_UNI_ANALYSIS_CAT(SARA.BlackFriday,Product_Category_1)
%SARA_UNI_ANALYSIS_CAT(SARA.BlackFriday,Product_Category_2)
%SARA_UNI_ANALYSIS_CAT(SARA.BlackFriday,Product_Category_3)
OPTIONS MLOGIC MPRINT SYMBOLGEN;   

ODS PDF CLOSE;

*...................................END OF DATA PROFILING......................................*
*______________________________________________________________________________________________;

/**********************************************************************************************/
*......................................   EDA DATA   ..........................................;
/**********************************************************************************************/

ODS PDF FILE = "C:\Sara\Data SCIENCE\SAS-SPB\Black Friday\DATA_EDA.PDF";
TITLE "DATA PROFILING : BLACK FRIDAY SALES ANALYSIS";
TITLE2 "CREATED BY SARA";
TITLE3 "REPORT DATE :&SYSDATE.";
FOOTNOTE " THE REPORT IS CONFIDENTIAL";
FOOTNOTE2 "INTERNAL USED ONLY";

*EDA-1) Handling Missing value- GET PERCENTAGE OF MISSING VALUES;
*---------------------------------------------------------------;
TITLE "Null Values in all variables";
/* CREATE A FORMAT TO GROUP MISSING AND NONMISSING */
PROC FORMAT;
 VALUE $MISSFMT ' '='MISSING' OTHER='NOT MISSING';
 VALUE  MISSFMT  . ='MISSING' OTHER='NOT MISSING';
RUN;

PROC FREQ DATA= SARA.BlackFriday; 
FORMAT _CHAR_ $MISSFMT.; /* APPLY FORMAT FOR THE DURATION OF THIS PROC */
TABLES _CHAR_ / MISSING MISSPRINT NOCUM ;
FORMAT _NUMERIC_ MISSFMT.;
TABLES _NUMERIC_ / MISSING MISSPRINT NOCUM;
RUN;

*EDA-2) Handling Missing value- USE 4 METHODS FOR HANDLING MISSING VALUES;
*------------------------------------------------------------------------;
*METHOD1(WRONG): REPLACE MISSING VALUES WITH ZERO, THAT MEANS WE DO NOT HAVE PRODUCT(THIS APPROACH IS WRONG) ;
*METHOD2(NO): REPLACE MISSING VALUES WITH MODE, THIS IS A WEAK WAY, BECAUSE WE HAVE 31.57% IN Product_Category_2 ;
*---------------------------------------------------------------------------------------------------------;
*METHOD2: 
--------;
DATA SARA.BF_C;
SET  SARA.BlackFriday;
IF MISSING(Product_Category_2) THEN  Product_Category_2 = "8"  ;
IF MISSING(Product_Category_3) THEN  Product_Category_3 = "16" ;
RUN;
PROC PRINT DATA = SARA.BF_C (OBS=10);
RUN;

*OR;
DATA SARA.BFC;
SET  SARA.BlackFriday;
If product_Category_2 = "." then product_category_2=8 ;
If product_Category_3 = "." then product_category_3=16 ;
RUN;
PROC PRINT DATA = SARA.BFC (OBS=10);
RUN; 

*METHOD3: ;
*---------;
*DROPPING PRODUCT_CATEGORY_3 IS LOGICAL, BECAUSE WE HAVE ABOUT 70% MISSING VALUE IN THIS VARIABLE;

*FILLING MISSING VALUES AND DROP PRODUCT_CATEGORY_3
*--------------------------------------------------;
DATA SARA.CLEAN;
SET SARA.BlackFriday;
DROP PRODUCT_CATEGORY_3;
RETAIN  _PRODUCT_CATEGORY_2;
IF NOT MISSING(PRODUCT_CATEGORY_2) THEN _PRODUCT_CATEGORY_2 = PRODUCT_CATEGORY_2;
ELSE PRODUCT_CATEGORY_2 = PRODUCT_CATEGORY_1;
DROP _PRODUCT_CATEGORY_2;
RUN;
PROC PRINT DATA= SARA.CLEAN (OBS= 10);
RUN;

PROC MEANS DATA = SARA.clean N NMISS;
VAR PRODUCT_CATEGORY_2;
RUN;

*concatenate  two product categories
 -----------------------------------;
DATA SARA.BlackFriday;
SET SARA.clean;
DIST_PRODUCT = CATX('-',PRODUCT_CATEGORY_1, PRODUCT_CATEGORY_2);
RUN;
PROC PRINT DATA= SARA.BlackFriday (OBS=10);
RUN;

*concatenate  two product categories
 -----------------------------------;
DATA CNBF;
SET SARA.clean;
DIST_PRODUCT = CATX('-',PRODUCT_CATEGORY_1, PRODUCT_CATEGORY_2);
RUN;

*METHOD4: ;
*---------;
DATA PRODUCT;
SET SARA.BlackFriday;
IF PRPRODUCT_CATEGORY_1 = '.' THEN PC_1 = 0;
ELSE PC_1 = PRODUCT_CATEGORY_1;
IF PRODUCT_CATEGORY_2 = '.' THEN PC_2 = 0;
ELSE PC_2 = PRODUCT_CATEGORY_2;
IF PRODUCT_CATEGORY_3 = '.' THEN PC_3 = 0;
ELSE PC_3 = PRODUCT_CATEGORY_3;
CATEGORY= PC_1*10000+PC_2*100+PC_2;
RUN;

PROC PRINT DATA = PRODUCT (OBS=10);
/* WHERE C3 = 0;*/
RUN;
PROC MEANS DATA = PRODUCT N NMISS;
VAR CATEGORY;
RUN;
PROC SQL;
SELECT COUNT(DISTINCT(CATEGORY))
FROM PRODUCT;
QUIT;


*EDA-3)REMOVE DUPLICATE STID
 ---------------------------;
PROC SORT DATA = SARA.BlackFriday OUT=SARA.BlackFriday_NODUP NODUPKEY;
BY USER_ID ;
RUN;
PROC CONTENTS DATA= SARA.BlackFriday_NODUP;
RUN;
PROC CONTENTS DATA= SARA.BlackFriday;
RUN;

*EDA-4)OUTLIERS
 --------------;

*KNOWN RANGE;
*UNKWON RANGE;

PROC MEANS DATA = SARA.BlackFriday N NMISS P25 P75 QRANGE;
 VAR PURCHASE;
 OUTPUT OUT=PURCHASE_O P25=Q1 P75=Q3 QRANGE=IQR;
RUN;

DATA PURCHASE_O;
 SET PURCHASE_O;
LOWER_LIMIT = Q1-(3*IQR);
UPPER_LIMIT = Q3+(3*IQR);
KEEP LOWER_LIMIT UPPER_LIMIT;
RUN;

DATA PURCHASE_O2;
 SET PURCHASE_O;
 IF PURCHASE LE LOWER_LIMIT THEN PURCHASE_RANGE ="BELOW LOWER LIMIT";
 ELSE IF PURCHASE GE UPPER_LIMIT THEN PURCHASE_RANGE ="ABOVE UPPER LIMIT";
 ELSE PURCHASE ="WITHIN RANGE";
RUN;

PROC SQL;
 CREATE TABLE PURCHASE_O3 AS
 SELECT *
 FROM PURCHASE_O2
 WHERE PURCHASE_RANGE ="WITHIN RANGE";
QUIT;
PROC PRINT DATA = PURCHASE_O3;
RUN;

*HOW TO VIUALIZE OUTLIERS;
PROC SGPLOT DATA = PURCHASE_O3 ;
 VBOX PURCHASE/DATALABEL = PURCHASE;
RUN;
QUIT;

*EDA-5)BIVARIATE ANALYSIS
 -----------------------;
* Y (Purchase) = x1-Product_ID+ x2-Gender+ X3-Age+ X4-Occupation+ X5-City_Category+
                 X6-Stay_In_Current_City_Years+ X7-Marital_Status+ X8-Product_Category_1+
                 X9-Product_Category_2+ X10-DIST_PROD;

* X VARIABLES: DEMOGRAPHIC: AGE, GENDER , OCCPUPATION,City_Category,EDUCATION, Marital_Status;
* X VARAIBLES: PRODUCT/SERVICE: Stay_In_Current_City_Years, Product_Category_1,Product_Category_1,DIST_PROD;

* Y (CONTINOUS) ~ X (CATEGORICAL);
* Y = X1 : Purchase ~ Product_ID 			: ANOVA;
* Y = X2 : Purchase ~ Gender			: T-TEST OR ANOVA;
* Y = X3 : Purchase ~ Age 			       : ANOVA;
* Y = X4 : Purchase ~ Occupation			: ANOVA;
* Y = X5 : Purchase ~ City_Category		: ANOVA;
* Y = X6 : Purchase ~ Stay_In_Current_City_Years : ANOVA;
* Y = X7 : Purchase ~ Marital_Status		: T-TEST OR ANOVA;
* Y = X8 : Purchase ~ Product_Category_1		: ANOVA;
* Y = X9 : Purchase ~ Product_Category_2		: ANOVA;
* Y = X10: Purchase ~ DIST_PRODUCT			: ANOVA;

* NOT RELATIONSHIP BETWEEN Xs;
* CROSS TABULATION ; 
* R AND c TABLE ;

* HYPOTHESIS TESTING;
* H0 : NULL HYPOTHEISIS- NO ASSOCIATION BETWEEN Purchase AND Age;
* HA : ALTERNATIVE HYPOTHESIS- THERE IS AN ASSOCIATION BETWEEN Purchase AND Age;
* ALPHA /SIGNIFICANT LEVEL = 5% (0.05)
* DECISION : REJECT H0 OR FAILED TO REJCT H0;
* P-VALUE : LE 0.05;


*EDA-5-1)Continouse Vs. Categorical:
 ----------------------------------;
PROC TTEST DATA = SARA.BlackFriday;
PAIRED  Purchase*Marital_Status;
RUN;

*ANOVA : ANALYSIS OF VARIANCE;
PROC ANOVA DATA = SARA.BlackFriday;
 CLASS Occupation;
 MODEL PURCHASE = Occupation;
 MEANS Occupation/SCHEFFE;
RUN;

*Macro for RELATION BETWEEN Purchase Vs. OTHER FEATURES;
*.............................................;
OPTIONS MLOGIC MPRINT SYMBOLGEN;
%SARA_BI_ANALYSIS_NUMs_CAT (DSN = SARA.BlackFriday_C ,CLASS=Age , VAR=Purchase );
%SARA_BI_ANALYSIS_NUMs_CAT (DSN = SARA.BlackFriday_C ,CLASS=Occupation , VAR=Purchase);
%SARA_BI_ANALYSIS_NUMs_CAT (DSN = SARA.BlackFriday_C ,CLASS=City_Category , VAR=Purchase );
%SARA_BI_ANALYSIS_NUMs_CAT (DSN = SARA.BlackFriday_C ,CLASS=Marital_Status , VAR=Purchase);
%SARA_BI_ANALYSIS_NUMs_CAT (DSN = SARA.BlackFriday_C ,CLASS=Product_Category_1 , VAR=Purchase );
%SARA_BI_ANALYSIS_NUMs_CAT (DSN = SARA.BlackFriday_C ,CLASS=Product_Category_2 , VAR=Purchase);
%SARA_BI_ANALYSIS_NUMs_CAT (DSN = SARA.BlackFriday_C ,CLASS=DIST_PRODuct , VAR=Purchase);
OPTIONS MLOGIC MPRINT SYMBOLGEN;

*Test independency 
-----------------;
*Macro ANOVA TEST FOR Continouse Vs. Categorical;
*...............................................;
%SARA_ANOVA_CAT_NUM (DSN = SARA.BlackFriday_C ,CLASS=Age , VAR=Purchase);
%SARA_ANOVA_CAT_NUM (DSN = SARA.BlackFriday_C ,CLASS=Occupation , VAR=Purchase);
%SARA_ANOVA_CAT_NUM (DSN = SARA.BlackFriday_C ,CLASS=City_Category , VAR=Purchase);
%SARA_ANOVA_CAT_NUM (DSN = SARA.BlackFriday_C ,CLASS=Marital_Status , VAR=Purchase);
%SARA_ANOVA_CAT_NUM (DSN = SARA.BlackFriday_C ,CLASS=Gender , VAR=Purchase);
%SARA_ANOVA_CAT_NUM (DSN = SARA.BlackFriday_C ,CLASS=Product_Category_1 , VAR=Purchase);
%SARA_ANOVA_CAT_NUM (DSN = SARA.BlackFriday_C ,CLASS=Product_Category_2 , VAR=Purchase);
%SARA_ANOVA_CAT_NUM (DSN = SARA.BlackFriday_C ,CLASS=DIST_PRODUCT , VAR=Purchase);


*EDA-6)DISCRETIZATION /BINNING/GROUPING 
 -------------------------------------;
*1. USING FORMAT  WIDTH : RANGE=(MAX - MIN )/5;
*2. NEW COLUMN IF THEN ELSE STATMENT : WIDTH : RANGE=(MAX - MIN )/5;
*3. PROC HPBIN :BUKET BINNING OR QUANTILE BINNING;
*4. PROC RANK RUN;


* DATA ANALYTICS
 ---------------;

*Distribution of Marital_Status
 ------------------------------;
PROC SGPLOT DATA= CNBF;
TITLE "Marital Status Distribution of Customers- Married:1 and Unmarried:0";
FOOTNOTE "Created by SARA";
HISTOGRAM Marital_Status /NBINS =20;
DENSITY Marital_Status / TYPE = KERNEL;
RUN;

*PRODUCT DISTRIBUTION
 --------------------;
/*CREATE A TABLE AGGREGATED BY DISTINCT PRODUCT COUNTS*/
PROC SQL;
CREATE TABLE PRODUCT_DIST AS
SELECT DIST_PRODUCT,
	USER_ID,
	COUNT(DISTINCT USER_ID)AS NUMBER_OF_CUSTOMER,  
	SUM(DISTINCT USER_ID) AS TOTAL_CUSTOMER,
	SUM(PURCHASE) AS TOTAL_PURCHASE,
	AVG(PURCHASE) AS AVG_PURCHASE,
	AGE,
	GENDER,
	OCCUPATION,
	Marital_Status,
	STAY_IN_CURRENT_CITY_YEARS,
	CITY_CATEGORY
FROM CNBF
GROUP BY DIST_PRODUCT, CITY_CATEGORY,Marital_Status
;
QUIT;

*PURCHASE DISTRIBUTION BOX PLOT
 -----------------------------;
PROC SGPLOT DATA = PRODUCT_DIST;
TITLE "Average Purchase per Age";
FOOTNOTE "SARA- Reporting";
VBOX AVG_PURCHASE / GROUP = AGE GROUPDISPLAY=CLUSTER ;
RUN;
QUIT;


PROC SGPLOT DATA = PRODUCT_DIST;
TITLE "Average Purchase per Marital Status";
FOOTNOTE "SARA- Reporting";
HBOX AVG_PURCHASE / GROUP = Marital_Status GROUPDISPLAY=CLUSTER ;
RUN;
QUIT;

PROC SGPLOT DATA = PRODUCT_DIST;
TITLE "Average Purchase per GENDER";
FOOTNOTE "SARA- Reporting";
HBOX AVG_PURCHASE / GROUP = GENDER GROUPDISPLAY=CLUSTER ;
RUN;
QUIT;

PROC SGPLOT DATA= PRODUCT_DIST;
TITLE "Average Purchase per product- City";
FOOTNOTE "SARA- Reporting";
VBOX AVG_PURCHASE / GROUP = CITY_CATEGORY GROUPDISPLAY=CLUSTER ;
RUN;
QUIT;

*Distribution of Customers
 ------------------------;
PROC TABULATE DATA= CNBF;
TITLE 'Customers Distribution Across Age, City Category, Gender and  Marital Status';
FOOTNOTE "SARA- Reporting";
CLASS AGE CITY_CATEGORY GENDER Marital_Status;
TABLE CITY_CATEGORY*(GENDER ALL), AGE='AGE GROUPS'*(PCTN='% ') ALL*(N PCTN) Marital_Status;
RUN;

PROC SGPLOT DATA= CNBF;
TITLE "Customers by Gender";
FOOTNOTE "SARA- Reporting";
VBAR CITY_CATEGORY / GROUP = GENDER GROUPDISPLAY=CLUSTER ;
RUN;

ODS LISTING STYLE=LISTING;
ODS GRAPHICS / WIDTH=5IN HEIGHT=2.81IN;

TITLE 'TOP PRODUCT Purchases BY NUMBER OF CUSTOMERS IN CITY CATEGORIES';
PROC SGPLOT DATA=PRODUCT_DIST(WHERE= (DIST_PRODUCT = '1-15' OR DIST_PRODUCT = '1-2' 
							           OR DIST_PRODUCT = '5-5' OR DIST_PRODUCT = '5-8'
							           OR DIST_PRODUCT = '8-8'OR DIST_PRODUCT = '6-8'));
  VBAR CITY_CATEGORY / RESPONSE= NUMBER_OF_CUSTOMER GROUP= DIST_PRODUCT GROUPDISPLAY= CLUSTER 
  STAT= MEAN DATASKIN= GLOSS;
  XAXIS DISPLAY= (NOLABEL NOTICKS);
  YAXIS GRID;
RUN;

TITLE 'TOP PRODUCT PURCHASES BY NUMBER OF CUSTOMERS IN AGE CATEGORIES';
PROC SGPLOT DATA=PRODUCT_DIST(WHERE= (DIST_PRODUCT = '1-15' OR DIST_PRODUCT = '1-2' 
							           OR DIST_PRODUCT = '5-5' OR DIST_PRODUCT = '5-8'
							           OR DIST_PRODUCT = '8-8'OR DIST_PRODUCT = '6-8'));
  VBAR AGE / RESPONSE= TOTAL_PURCHASE GROUP= DIST_PRODUCT GROUPDISPLAY= CLUSTER 
  STAT= MEAN DATASKIN= GLOSS;
  XAXIS DISPLAY= (NOLABEL NOTICKS);
  YAXIS GRID;
RUN;

TITLE 'TOP PRODUCT URCHASES BY NUMBER OF CUSTOMERS IN GENDER CATEGORIES';
FOOTNOTE "SARA- Reporting";
PROC SGPLOT DATA=PRODUCT_DIST(WHERE =(DIST_PRODUCT = '1-15' OR DIST_PRODUCT = '1-2' 
							           OR DIST_PRODUCT = '5-5' OR DIST_PRODUCT = '5-8'
							           OR DIST_PRODUCT = '8-8'OR DIST_PRODUCT = '6-8'));
  VBAR GENDER / RESPONSE=TOTAL_PURCHASE GROUP=DIST_PRODUCT GROUPDISPLAY=CLUSTER 
  STAT=SUM DATASKIN=GLOSS;
  XAXIS DISPLAY=(NOLABEL NOTICKS);
  YAXIS GRID;
RUN;

TITLE 'TOP PRODUCT URCHASES BY NUMBER OF CUSTOMERS IN GENDER CATEGORIES';
FOOTNOTE "SARA- Reporting";
PROC SGPLOT DATA=PRODUCT_DIST(WHERE =(DIST_PRODUCT = '1-15' OR DIST_PRODUCT = '1-2' 
							           OR DIST_PRODUCT = '5-5' OR DIST_PRODUCT = '5-8'
							           OR DIST_PRODUCT = '8-8'OR DIST_PRODUCT = '6-8'));
  VBAR OCCUPATION / RESPONSE=TOTAL_PURCHASE GROUP=DIST_PRODUCT GROUPDISPLAY=CLUSTER 
  STAT=SUM DATASKIN=GLOSS;
  XAXIS DISPLAY=(NOLABEL NOTICKS);
  YAXIS GRID;
RUN;

TITLE 'TOP PRODUCT URCHASES BY NUMBER OF CUSTOMERS IN GENDER CATEGORIES';
FOOTNOTE "SARA- Reporting";
PROC SGPLOT DATA=PRODUCT_DIST(WHERE =(DIST_PRODUCT = '1-15' OR DIST_PRODUCT = '1-2' 
							           OR DIST_PRODUCT = '5-5' OR DIST_PRODUCT = '5-8'
							           OR DIST_PRODUCT = '8-8'OR DIST_PRODUCT = '6-8'));
  VBAR STAY_IN_CURRENT_CITY_YEARS / RESPONSE=TOTAL_PURCHASE GROUP=DIST_PRODUCT GROUPDISPLAY=CLUSTER 
  STAT=SUM DATASKIN=GLOSS;
  XAXIS DISPLAY=(NOLABEL NOTICKS);
  YAXIS GRID;
RUN;

TITLE 'TOP PRODUCT URCHASES BY NUMBER OF CUSTOMERS IN GENDER CATEGORIES';
FOOTNOTE "SARA- Reporting";
PROC SGPLOT DATA=PRODUCT_DIST(WHERE =(DIST_PRODUCT = '1-15' OR DIST_PRODUCT = '1-2' 
							           OR DIST_PRODUCT = '5-5' OR DIST_PRODUCT = '5-8'
							           OR DIST_PRODUCT = '8-8'OR DIST_PRODUCT = '6-8'));
  VBAR MARITAL_STATUS / RESPONSE=TOTAL_PURCHASE GROUP=DIST_PRODUCT GROUPDISPLAY=CLUSTER 
  STAT=SUM DATASKIN=GLOSS;
  XAXIS DISPLAY=(NOLABEL NOTICKS);
  YAXIS GRID;
RUN;

*Descritive Statistics
 --------------------;
PROC UNIVARIATE DATA= CNBF;
  CLASS MARITAL_STATUS;
  VAR PURCHASE;/* COMPUTES DESCRIPTIVE STATISITCS */
  HISTOGRAM PURCHASE / NORMAL MIDPOINTS=(250 TO 25000 BY 2500) NROWS=2 ODSTITLE="PURCHASE DISTRIBUTION BY MARITAL STATUS";
  ODS SELECT HISTOGRAM;/* DISPLAY ON THE HISTOGRAMS */
RUN;
QUIT;

*Customer Segmentation
 --------------------;
PROC TABULATE DATA= PRODUCT_DIST;
TITLE 'CUSTOMER PROFILE BY FEATUE SIGNIFICANCE';
CLASS CITY_CATEGORY GENDER TOTAL_CUSTOMER;
VAR TOTAL_PURCHASE;
TABLE CITY_CATEGORY ALL ,GENDER *(TOTAL_CUSTOMER=' ');
RUN;

PROC SQL;
CREATE TABLE UNQ_CUSTOMER AS
SELECT DISTINCT USER_ID,
		  GENDER,
		  AGE,
		  OCCUPATION,
		  MARITAL_STATUS,
		  CITY_CATEGORY,
		  STAY_IN_CURRENT_CITY_YEARS
FROM CNBF;

PROC SQL;
CREATE TABLE CUSTOMER_PUR AS
SELECT USER_ID, 
	SUM(PURCHASE) AS TOTAL_PURCHASE,
	COUNT(PRODUCT_CATEGORY_1) AS TOTAL_PRODS
FROM CNBF
GROUP BY USER_ID;
QUIT;

PROC SQL;
CREATE TABLE AGGRE AS
SELECT *
FROM CUSTOMER_PUR C
JOIN UNQ_CUSTOMER U
ON C.USER_ID = U.USER_ID;
QUIT;

PROC TABULATE DATA=AGGRE;
TITLE 'Profiles of  Customers';
FOOTNOTE "SARA- Reporting";
CLASS AGE CITY_CATEGORY GENDER;
VAR TOTAL_PURCHASE;
TABLE (CITY_CATEGORY ALL)*(GENDER ALL), AGE='AGE GROUPS'*(PCTN='% ') ALL*(N PCTN);
RUN;

PROC UNIVARIATE DATA=AGGRE;
  CLASS CITY_CATEGORY;
  VAR TOTAL_PURCHASE;      
  HISTOGRAM TOTAL_PURCHASE / NROWS=3 ODSTITLE="Total Purchase Spent  by City Category";
  FOOTNOTE "SARA- Reporting";
  ODS SELECT HISTOGRAM; 
RUN;

*__________________________________________________________________________________;
PROC SQL;
CREATE TABLE SARA.MODEL_DATA (DROP=TOTAL_PRODS Age Occupation Marital_Status Stay_In_Current_City_Years PRODUCT_CATEGORY_1) AS
SELECT USER_ID, 
	SUM(PURCHASE) AS TOTAL_PURCHASE,
	City_Category
FROM SARA.BlackFriday
GROUP BY USER_ID;
QUIT;
PROC PRINT DATA= SARA.MODEL_DATA (OBS=10);
RUN;

ODS PDF CLOSE;

proc sql;
select count(distinct(User_ID)) as number_user_id, count(User_ID) as count_user_id
from SARA.BlackFriday;
run;

/* Find the top 20 customers by User_ID. */
proc sql outobs=20;
select user_id,
       age,
       sum(Purchase) as total_purchase,
       City_Category,
	Gender,
	Marital_Status,
	Occupation,
	STAY_IN_CURRENT_CITY_YEARS
from SARA.BlackFriday 
group by user_id ,age,City_Category,Gender,Occupation,STAY_IN_CURRENT_CITY_YEARS,Marital_Status
order by total_purchase desc
;
run;

proc sql ;
create table SARA.user_id as 
select user_id,
	age,
	sum(Purchase) as total_purchase,	
	avg(purchase) as avg_purchase,
	City_Category,
	Gender,
	Marital_Status,
	Occupation,
	STAY_IN_CURRENT_CITY_YEARS
from SARA.BlackFriday 
group by user_id ,age,City_Category,Gender,Occupation,STAY_IN_CURRENT_CITY_YEARS,Marital_Status
order by total_purchase desc
;
run;

*......................................   EDA DATA   ..........................................;

*______________________________________________________________________________________________;

/**********************************************************************************************/
*......................................   ENCODING   ..........................................;
/**********************************************************************************************/

*ENCODING USE MACRO;
*------------------;
 %macro label_encode(dataset,var);
   proc sql noprint;
     select distinct(&var)
     into:val1-
     from &dataset;
 select count(distinct(&var))  into:mx from &dataset;
 quit;
 data new;
     set &dataset;
   %do i=1 %to &mx;
     if &var="&&&val&i" then new=&i;
   %end;
   run;
 %mend;

%label_encode (SARA.BlackFriday ,AGE);
%label_encode (SARA.BlackFriday ,DIST_PRODUCT);
%label_encode (SARA.BlackFriday ,City_Category);
%label_encode (SARA.BlackFriday ,GENDER);

*ENCODING TRAIN DATA SET 
 -----------------------;
DATA  SARA.BlackFriday;
SET SARA.BlackFriday;
IF AGE="0-17"  THEN  AGE_ENC=1;
IF AGE="18-25" THEN  AGE_ENC=2;
IF AGE="26-35" THEN  AGE_ENC=3;
IF AGE="36-45" THEN  AGE_ENC=4;
IF AGE="46-50" THEN  AGE_ENC=5;
IF AGE="51-55" THEN  AGE_ENC=6;
IF AGE="55+"   THEN  AGE_ENC=7;
RUN;

DATA  SARA.BlackFriday;
SET SARA.BlackFriday;
ARRAY j{7} AGE_ENC1 AGE_ENC2 AGE_ENC3 AGE_ENC4 AGE_ENC5 AGE_ENC6 AGE_ENC7;
DO i= 1 TO 7;
j{i}= (AGE_ENC=i);
END;
DROP i;
RUN;

DATA  SARA.BlackFriday;
SET SARA.BlackFriday;
IF GENDER="F"  THEN  GENDER_ENC=1;
IF GENDER="M"  THEN  GENDER_ENC=2;
RUN;

DATA  SARA.BlackFriday;
SET SARA.BlackFriday;
ARRAY j{2} GENDER_ENC1 GENDER_ENC2;
DO i= 1 TO 2;
j{i}= (GENDER_ENC=i);
END;
DROP i;
RUN;

DATA  SARA.BlackFriday;
SET SARA.BlackFriday;
IF Marital_Status="0"  THEN  Marital_Status_ENC=1;
IF Marital_Status="1"  THEN  Marital_Status_ENC=2;
RUN;

DATA  SARA.BlackFriday;
SET SARA.BlackFriday;
ARRAY j{2} Marital_Status_ENC1 Marital_Status_ENC2;
DO i= 1 TO 2;
j{i}= (Marital_Status_ENC=i);
END;
DROP i;
RUN;

DATA  SARA.BlackFriday;
SET SARA.BlackFriday;
IF City_Category="A"  THEN  City_Category_ENC=1;
IF City_Category="B"  THEN  City_Category_ENC=2;
IF City_Category="C"  THEN  City_Category_ENC=3;
RUN;

DATA  SARA.BlackFriday;
SET SARA.BlackFriday;
ARRAY j{3} City_Category_ENC1 City_Category_ENC2 City_Category_ENC3;
DO i= 1 TO 3;
j{i}= (City_Category_ENC=i);
END;
DROP i;
RUN;

DATA  SARA.BlackFriday;
SET SARA.BlackFriday;
IF Occupation="0"   THEN  Occupation_ENC=1;
IF Occupation="1"   THEN  Occupation_ENC=2;
IF Occupation="2"   THEN  Occupation_ENC=3;
IF Occupation="3"   THEN  Occupation_ENC=4;
IF Occupation="4"   THEN  Occupation_ENC=5;
IF Occupation="5"   THEN  Occupation_ENC=6;
IF Occupation="6"   THEN  Occupation_ENC=7;
IF Occupation="7"   THEN  Occupation_ENC=8;
IF Occupation="8"   THEN  Occupation_ENC=9;
IF Occupation="9"   THEN  Occupation_ENC=10;
IF Occupation="10"  THEN  Occupation_ENC=11;
IF Occupation="11"  THEN  Occupation_ENC=12;
IF Occupation="12"  THEN  Occupation_ENC=13;
IF Occupation="13"  THEN  Occupation_ENC=14;
IF Occupation="14"  THEN  Occupation_ENC=15;
IF Occupation="15"  THEN  Occupation_ENC=16;
IF Occupation="16"  THEN  Occupation_ENC=17;
IF Occupation="17"  THEN  Occupation_ENC=18;
IF Occupation="18"  THEN  Occupation_ENC=19;
IF Occupation="19"  THEN  Occupation_ENC=20;
IF Occupation="20"  THEN  Occupation_ENC=21;
RUN;

DATA  SARA.BlackFriday;
SET SARA.BlackFriday;
ARRAY j{21} Occupation_ENC1 Occupation_ENC2 Occupation_ENC3 Occupation_ENC4 Occupation_ENC5 Occupation_ENC6
            Occupation_ENC7 Occupation_ENC8 Occupation_ENC9 Occupation_ENC10 Occupation_ENC11 Occupation_ENC12
            Occupation_ENC13 Occupation_ENC14 Occupation_ENC15 Occupation_ENC16 Occupation_ENC17 Occupation_ENC18
            Occupation_ENC19 Occupation_ENC20 Occupation_ENC21;
DO i= 1 TO 21;
j{i}= (Occupation_ENC=i);
END;
DROP i;
RUN;

PROC PRINT DATA= SARA.BlackFriday(OBS=10);
RUN;

DATA  SARA.BlackFridayCLEAN;
SET SARA.BlackFriday;
DROP AGE GENDER City_Category DIST_PRODUCT Product_ID Occupation Marital_Status ;
RUN;
PROC PRINT DATA= SARA.BlackFridayCLEAN (OBS=10);
RUN;

*ENCODING TEST DATA SET 
 -----------------------;
DATA  SARA.TEST;
SET SARA.TEST;
IF AGE="0-17"  THEN  AGE_ENC=1;
IF AGE="18-25" THEN  AGE_ENC=2;
IF AGE="26-35" THEN  AGE_ENC=3;
IF AGE="36-45" THEN  AGE_ENC=4;
IF AGE="46-50" THEN  AGE_ENC=5;
IF AGE="51-55" THEN  AGE_ENC=6;
IF AGE="55+"   THEN  AGE_ENC=7;
RUN;

DATA  SARA.TEST;
SET SARA.TEST;
ARRAY j{7} AGE_ENC1 AGE_ENC2 AGE_ENC3 AGE_ENC4 AGE_ENC5 AGE_ENC6 AGE_ENC7;
DO i= 1 TO 7;
j{i}= (AGE_ENC=i);
END;
DROP i;
RUN;

DATA  SARA.TEST;
SET SARA.TEST;
IF GENDER="F"  THEN  GENDER_ENC=1;
IF GENDER="M"  THEN  GENDER_ENC=2;
RUN;

DATA  SARA.TEST;
SET SARA.TEST;
ARRAY j{2} GENDER_ENC1 GENDER_ENC2;
DO i= 1 TO 2;
j{i}= (GENDER_ENC=i);
END;
DROP i;
RUN;

DATA  SARA.TEST;
SET SARA.TEST;
IF Marital_Status="0"  THEN  Marital_Status_ENC=1;
IF Marital_Status="1"  THEN  Marital_Status_ENC=2;
RUN;

DATA  SARA.TEST;
SET SARA.TEST;
ARRAY j{2} Marital_Status_ENC1 Marital_Status_ENC2;
DO i= 1 TO 2;
j{i}= (Marital_Status_ENC=i);
END;
DROP i;
RUN;

DATA  SARA.TEST;
SET SARA.TEST;
IF City_Category="A"  THEN  City_Category_ENC=1;
IF City_Category="B"  THEN  City_Category_ENC=2;
IF City_Category="C"  THEN  City_Category_ENC=3;
RUN;

DATA  SARA.TEST;
SET SARA.TEST;
ARRAY j{3} City_Category_ENC1 City_Category_ENC2 City_Category_ENC3;
DO i= 1 TO 3;
j{i}= (City_Category_ENC=i);
END;
DROP i;
RUN;

DATA  SARA.TEST;
SET SARA.TEST;
IF Occupation="0"   THEN  Occupation_ENC=1;
IF Occupation="1"   THEN  Occupation_ENC=2;
IF Occupation="2"   THEN  Occupation_ENC=3;
IF Occupation="3"   THEN  Occupation_ENC=4;
IF Occupation="4"   THEN  Occupation_ENC=5;
IF Occupation="5"   THEN  Occupation_ENC=6;
IF Occupation="6"   THEN  Occupation_ENC=7;
IF Occupation="7"   THEN  Occupation_ENC=8;
IF Occupation="8"   THEN  Occupation_ENC=9;
IF Occupation="9"   THEN  Occupation_ENC=10;
IF Occupation="10"  THEN  Occupation_ENC=11;
IF Occupation="11"  THEN  Occupation_ENC=12;
IF Occupation="12"  THEN  Occupation_ENC=13;
IF Occupation="13"  THEN  Occupation_ENC=14;
IF Occupation="14"  THEN  Occupation_ENC=15;
IF Occupation="15"  THEN  Occupation_ENC=16;
IF Occupation="16"  THEN  Occupation_ENC=17;
IF Occupation="17"  THEN  Occupation_ENC=18;
IF Occupation="18"  THEN  Occupation_ENC=19;
IF Occupation="19"  THEN  Occupation_ENC=20;
IF Occupation="20"  THEN  Occupation_ENC=21;
RUN;

DATA  SARA.TEST;
SET SARA.TEST;
ARRAY j{21} Occupation_ENC1 Occupation_ENC2 Occupation_ENC3 Occupation_ENC4 Occupation_ENC5 Occupation_ENC6
            Occupation_ENC7 Occupation_ENC8 Occupation_ENC9 Occupation_ENC10 Occupation_ENC11 Occupation_ENC12
            Occupation_ENC13 Occupation_ENC14 Occupation_ENC15 Occupation_ENC16 Occupation_ENC17 Occupation_ENC18
            Occupation_ENC19 Occupation_ENC20 Occupation_ENC21;
DO i= 1 TO 21;
j{i}= (Occupation_ENC=i);
END;
DROP i;
RUN;

PROC PRINT DATA= SARA.TEST(OBS=10);
RUN;

DATA  SARA.TESTCLEAN;
SET SARA.TEST;
DROP AGE GENDER City_Category DIST_PROD Product_ID;
RUN;
PROC PRINT DATA= SARA.TESTCLEAN (OBS=10);
RUN;
*-----------------;
DATA  SARA.MODEL_DATA;
SET SARA.MODEL_DATA;
IF City_Category="A"  THEN  City_Category_ENC=1;
IF City_Category="B"  THEN  City_Category_ENC=2;
IF City_Category="C"  THEN  City_Category_ENC=3;
RUN;
DATA  SARA.MODEL_DATA;
SET SARA.MODEL_DATA;
ARRAY j{3} City_Category_ENC1 City_Category_ENC2 City_Category_ENC3;
DO i= 1 TO 3;
j{i}= (City_Category_ENC=i);
END;
DROP i;
RUN;
DATA  SARA.MODEL_DATA;
SET SARA.MODEL_DATA;
DROP City_Category;
RUN;
PROC PRINT DATA= SARA.MODEL_DATA (OBS=10);
RUN;

data SARA.BlackFridayCLEAN;
   set SARA.BlackFridayCLEAN;
   logPURCHASE = log(PURCHASE);
run; quit;

PROC PRINT DATA= SARA.BlackFridayCLEAN (OBS=10);
RUN;


*......................................  END  ENCODING   ......................................;

*______________________________________________________________________________________________;

/**********************************************************************************************/
*................................   STANDARDIZE VARIABLES   ...................................;
/**********************************************************************************************/

PROC STANDARD DATA=SARA.BlackFridayCLEAN MEAN=0 STD=1 OUT=SARA.ZBlackFridayCLEAN;
VAR AGE_ENC Marital_Status_ENC City_Category_ENC Occupation_ENC GENDER_ENC Product_Category_1;
RUN;
 
PROC MEANS DATA=SARA.ZBlackFridayCLEAN;
RUN;
*................................  END STANDARDIZE VARIABLES   ................................;

*______________________________________________________________________________________________;

/**********************************************************************************************/
*.....................................   MODELLING DATA   .....................................;
*....................................   LINEAR REGRESSION   ...................................;
/**********************************************************************************************/

*SAMPLING METHODS : SYTSTEMIC RANDOM SAMPLING(SRS) , SIMPLE RANDOM SAMPLING,;

*SPLIT DATA INTO TRAINING (70%/80%) AND TESTING(30%/20%) DATA
 ------------------------------------------------------------;
PROC SURVEYSELECT DATA = SARA.ZBlackFridayCLEAN OUT=SARA.ZBlackFridayCLEAN_SPLIT RATE = 0.7 OUTALL;
RUN;
PROC FREQ DATA = SARA.ZBlackFridayCLEAN_SPLIT;
 TABLE Selected;
RUN;


PROC SURVEYSELECT DATA = SARA.MODEL_DATA OUT=SARA.MODEL_DATA_SPLIT RATE = 0.7 OUTALL;
RUN;
PROC FREQ DATA = SARA.MODEL_DATA_SPLIT;
 TABLE Selected;
RUN;

*SPLIT DATA INTO TRAINING (1) AND TESTING (0);

*SARA.BlackFriday_TRAINING
 SARA.BlackFriday_TESTING;

*MODEL1:
 -------;
DATA SARA.ZBlackFridayCLEAN_TRAINING 
     SARA.ZBlackFridayCLEAN_TESTING; 
SET  SARA.ZBlackFridayCLEAN_SPLIT;
IF  Selected=1 THEN OUTPUT SARA.ZBlackFridayCLEAN_TRAINING;
ELSE IF Selected=0 THEN OUTPUT SARA.ZBlackFridayCLEAN_TESTING;
RUN;

DATA SARA.MODEL_DATA_TRAINING 
     SARA.MODEL_DATA_TESTING; 
SET  SARA.MODEL_DATA_SPLIT;
IF  Selected=1 THEN OUTPUT SARA.MODEL_DATA_TRAINING;
ELSE IF Selected=0 THEN OUTPUT SARA.MODEL_DATA_TESTING;
RUN;

*running a simple linear regression model
 ----------------------------------------;

*How many Purchase a person can do based on his or her Gender, Age, Occupation, City_Category,
 Marital_Status, Product_Category_1, Product_Category_2, and DIST_PROD;

* Y = B0+B1*X1+...;
* Purchase = B0+B1*Age;
* SLOPE(COEFFICIENT/PARAMTER) H0 : B1 =0;
* ALPHA = 0.05;

TITLE "SIMPLE LINEAR REGRESSION:ONE PREDICTOR VARAIBLE";
PROC REG DATA = SARA.MODEL_DATA_TRAINING;
 MODEL TOTAL_PURCHASE = City_Category_ENC;
RUN;

TITLE "SIMPLE LINEAR REGRESSION:ONE PREDICTOR VARAIBLE";
PROC REG DATA = SARA.MODEL_DATA;
 MODEL TOTAL_PURCHASE = City_Category_ENC;
RUN;


ODS GRAPHICS ON;
ODS LISTING OFF;

TITLE "SIMPLE LINEAR REGRESSION:ONE PREDICTOR VARAIBLE";
PROC REG DATA = SARA.ZBlackFridayCLEAN_TRAINING;
 MODEL Purchase = GENDER_ENC;
RUN;

TITLE "SIMPLE LINEAR REGRESSION:ONE PREDICTOR VARAIBLE";
PROC REG DATA = SARA.ZBlackFridayCLEAN_TRAINING;
 MODEL Purchase = Occupation;
RUN;

TITLE "SIMPLE LINEAR REGRESSION:ONE PREDICTOR VARAIBLE";
PROC REG DATA = SARA.ZBlackFridayCLEAN_TRAINING;
 MODEL Purchase = AGE_ENC;
RUN;

TITLE "SIMPLE LINEAR REGRESSION:ONE PREDICTOR VARAIBLE";
PROC REG DATA = SARA.ZBlackFridayCLEAN_TRAINING;
 MODEL Purchase = Product_Category_1;
RUN;

TITLE "SIMPLE LINEAR REGRESSION:ONE PREDICTOR VARAIBLE";
PROC REG DATA = SARA.ZBlackFridayCLEAN_TRAINING;
 MODEL Purchase = Product_Category_2;
RUN;

TITLE "SIMPLE LINEAR REGRESSION:ONE PREDICTOR VARAIBLE";
PROC REG DATA = SARA.ZBlackFridayCLEAN_TRAINING;
 MODEL Purchase = City_Category_ENC;
RUN;

*MODEL:
 -----;
TITLE "SIMPLE LINEAR REGRESSION:ONE PREDICTOR VARAIBLE";
PROC REG DATA = SARA.ZBlackFridayCLEAN_TRAINING;
 MODEL logPURCHASE = AGE_ENC City_Category_ENC Occupation_ENC GENDER_ENC;
RUN;

TITLE "SIMPLE LINEAR REGRESSION:ONE PREDICTOR VARAIBLE";
PROC REG DATA = SARA.ZBlackFridayCLEAN;
 MODEL Purchase = AGE_ENC City_Category_ENC Occupation_ENC GENDER_ENC Product_Category_1; 
RUN;

TITLE "SIMPLE LINEAR REGRESSION:ONE PREDICTOR VARAIBLE";
PROC REG DATA = SARA.ZBlackFridayCLEAN;
 MODEL Purchase = Product_Category_1;
RUN;

ODS GRAPHICS OFF;
ODS LISTING ON;
*....................................  END MODELLING DATA   ...................................;

*______________________________________________________________________________________________;

*______________________________________________________________________________________________;

/**********************************************************************************************/
*.....................................   INTERPRETATIONS   ....................................;
/**********************************************************************************************/

*INTERPRETATIONS;
	*INTERCEPT : H0 ;
	* Bs;
*PURCHASE= 9261.92+ 31.036*User_ID+ 35.53*AGE_ENC+ 306.06*City_Category_ENC+ 60.236*Occupation+ 296.29*GENDER_ENC

*-----------------------------------------------------------------------------------------------;

ODS GRAPHICS ON;
ODS LISTING OFF;
TITLE "DISPLAYING INFLUENCIAL OBS";
PROC REG DATA = SARA.ZBlackFridayCLEAN_TRAINING PLOTS(ONLY) = (COOKSD(LABEL) RSTUDENTBYPREDICTED(LABEL));
 MODEL Purchase =AGE_ENC  /INFLUNCE R;
 ID USER_ID;
RUN;
QUIT;
ODS GRAPHICS OFF;
ODS LISTING ON;

*THE INFLUENCE OPTION GIVES YOU STATISTICS THAT SHOW YOU HOW MUCH EACH OBS CHANGEES ASPECT OF THE REGRESSION DEPENDING ON WHETHER 
THAT OBS IS INLCUDE;
*THE R/COOK'S D OPTION GIVE YOU MORE DETIALS ABOUT THE RESIDUALS;

*----------------------------------------------------------------------------------------------------------------;

*MULTIPLE REGRESSION;

*RUNNING ALL POSSIBLE REGRESSION WITH ALL PREDICTOR VARAIBLES;
*2*n -1;
* 4 PREDICOTRS - 2**4 -1 =15 MODELS;

*CP : MALLOW'S CP;
TITLE "DEMONSTRATING THE RSQUARE SELECTION METHOD";
PROC REG DATA = SARA.ZBlackFridayCLEAN_TRAINING;
 MODEL Purchase =AGE_ENC  City_Category_ENC Occupation_ENC GENDER_ENC/SELECTION = RSQUARE CP ADJRSQ ;
RUN;
QUIT;

*CHOOSING THE BEST MODELS;
*MALLOW METHODS (FOR PREDICTION) : TO CHOOSE THE FIST MODEL IN WHICH Cp IS LESS THAN OR EQUAL TO P WHERE P IS THE NUMBERS OF PARAMETER+INTERCEPT;
*HOCKING METHODS(FOR EXPLAINATION) : Cp IS LESS THAN OR EQUAL TO 2*P - Pfull+1 WHERE Pfull is thenumber of paramters in a full model
(all predictors variables);


TITLE "GENERATING PLOTS OF R-SQUARE,ADJUSTED R-SQUARE AND Cp";
PROC REG DATA = SARA.ZBlackFridayCLEAN_TRAINING PLOTS(ONLY) = (RSQUARE ADJRSQ CP);
 MODEL Purchase =AGE_ENC  City_Category_ENC Occupation_ENC GENDER_ENC Product_Category_1 /SELECTION = RSQUARE CP ADJRSQ ;
RUN;
QUIT;

* MALLOW'S Cp for each model;
		*MALLOW'S CRITERIA;
		*HOCKING'S CRITERIA;

*IF YOUR MODEL HAS A LARGE NUMBER OF VARIABLES, THERE MIGHT BE HIGH VALUES OF Cp, 
	MARKING IT HARD TO SEE THE PART OF THE GRAPH NEAR THE TWO LINES;
*USE BEST N= ;
TITLE "GENERATING PLOTS OF R-SQUARE,ADJUSTED R-SQUARE AND Cp";
PROC REG DATA = SARA.ZBlackFridayCLEAN_TRAINING PLOTS(ONLY) = (RSQUARE ADJRSQ CP);
 MODEL Purchase =AGE_ENC  City_Category_ENC Occupation GENDER_ENC Product_Category_1 Product_Category_2/SELECTION = RSQUARE CP ADJRSQ BEST=3;
RUN;
QUIT;

*********************************************************************************************************************
*AUOTMATIC SELECTION METHODS;

*DEFAULT VALUES FOR 
	FORWARD SLENTRY =.50
	BACKWARD SLSTAY = .10
	STEPWISE 	SLENTRY =.15 ,SLSTAY=.15;

TITLE "FORWARD,BACKWARD, AND STEPWISE SELECTION METHODS";
PROC REG DATA = SARA.ZBlackFridayCLEAN_TRAINING;
 MODEL Purchase =AGE_ENC  City_Category_ENC Occupation_ENC GENDER_ENC Product_Category_1 /SELECTION = FORWARD;
 MODEL Purchase =AGE_ENC  City_Category_ENC Occupation_ENC GENDER_ENC Product_Category_1 /SELECTION = BACKWARD;
 MODEL Purchase =AGE_ENC  City_Category_ENC Occupation_ENC GENDER_ENC Product_Category_1 /SELECTION = STEPWISE;
RUN;
QUIT;

*STEPWISE SELECTION
	1. STEP 1 , REST_PULSE IS ENTERED
	2. STEP 2, AGE IS ENTERED 
	NO OTHER VARABILES MEET THE ENTRY CRITER OF P <.15
	3. SUMMARY

SS : REST_PULSE AGE ;

TITLE "FORWARD,BACKWARD, AND STEPWISE SELECTION METHODS";
TITLE "SLENTRY AT 0.15";
PROC REG DATA = SARA.ZBlackFridayCLEAN_TRAINING ;
 MODEL Purchase =AGE_ENC  City_Category_ENC Occupation_ENC GENDER_ENC Product_Category_1 Product_Category_2/SELECTION = FORWARD SLENTRY=0.15;
RUN;
QUIT;
		  

*FORCING SELECTED VARAIBLES INTO A MODEL;
*MAX_PULSE IS FORCED TO BE ENTERED FRIST;
TITLE "FORCING SELECTED VARAIBLES INTO A MODEL";
PROC REG DATA = SARA.ZBlackFridayCLEAN_TRAINING ;
 MODEL Purchase =AGE_ENC  City_Category_ENC Occupation_ENC GENDER_ENC Product_Category_1 Product_Category_2/SELECTION = STEPWISE INLCLUDE=1;
RUN;
QUIT;
	

**************************************************************************************************************

*model scoring;
*least square regression equation to predict values of the dependent variables;

 *TO SCORE SMALL DATA SET;
 TITLE "MORE EFFICIENT WAYS TO COMPUTE PREDICTED VALUES";
 PROC REG DATA = SARA.ZBlackFridayCLEAN_TRAINING OUTEST= BETAS;
  MODEL Purchase =AGE_ENC City_Category_ENC Occupation_ENC Product_Category_1;
  RUN;
PROC PRINT DATA = BETAS;
RUN;
*The TYPE= option tells PROC SCORE what type of data the SCORE= data set contains. 
In this case, specifying TYPE=PARMS tells SAS to use the parameter estimates in the Estimates data set. ;
TITLE "USING PROC SCORE TO COMPUTE PREDICTED VALUES FROM A REG MODEL";
PROC SCORE DATA = SARA.TEST SCORE =BETAS OUT=PREDICTIONS_SCORE TYPE= PARMS;
VAR AGE_ENC City_Category_ENC Occupation_ENC Product_Category_1;
RUN;

PROC PRINT DATA = PREDICTIONS_SCORE;
RUN;


**************************************************************************************************************

*2. Errors(Residuals) should be normally distributed.;

PROC REG DATA = SARA.ZBlackFridayCLEAN_TRAINING;
 MODEL Purchase =AGE_ENC  City_Category_ENC Occupation_ENC GENDER_ENC Product_Category_1 /STB CLB;
 OUTPUT OUT=STD_RESIDUAL P =PREDICT R= RESIDUAL;
RUN;

PROC UNIVARIATE DATA = STD_RESIDUAL NORMAL;
 VAR RESIDUAL;
RUN;

*Shapiro-Wilk P > 0.05 h0 NOT REJECTED;


**********************************************************************************************************
________________________________________________  END  ___________________________________________________;

