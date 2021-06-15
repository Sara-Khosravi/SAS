*___________________________________________________________________________________________________;

/*..............................********   Sara Khosrvi    *********...............................*/
/*........................Part One: Small Project for the Telecom company..........................*/
*___________________________________________________________________________________________________;


*Customer Distribution and Deactivation Analyses;
*---------------------------------------------------------------------------------------------------;
/*
Objective:
----------

The attached data is the CRM data of a wireless company for 2 years. The wireless
company would like to investigate the customer distribution and business behaviors, and
then gain insightful understanding about the customers, and to forecast the deactivation
trends for the next 6 months.

Data:
-----
Acctno: 		account number.
Actdt: 	       account activation date
Deactdt: 		account deactivation date
DeactReason: 	       reason for deactivation.
GoodCredit: 	       customer’s credit is good or not.
RatePlan: 		rate plan for the customer.
DealerType: 	       dealer type.
Age: 			customer age.
Province: 		province.
Sales: 	       the amount of sales to a customer.
-----------------------------------------------------------------------------------------------------
*/
/*
RFM analysis for following data:
--------------------------------
RECENCY: Their most recent purchase date.()or sometimes difference days or months  from the most recent
purchase date and today or specific date
FREQUENCY: Number of purchases within a set time period (i.e. one year).
MONETARY:Total sales from that customer (you could also use average sales or average margin)
*/

/*Preparing Input file:
-----------------------
Method1:
--------
Since the "New_Wireless_Fixed.txt" file is a raw data without any Delemiter I had to manipulate it
to be ready to be able to load to SAS to work on that.

To make the file, I did the following tasks:

1) Make a copy from "New_Wireless_Fixed.txt" file to another one as "Dataset0.txt"
2) Opened "Dataset0.txt" file in notepad
3) Select all data and made Copy
4) Opened a new Excel file
5) Paste the memory in the Excel worksheet 
6) Since all data is pasted in only one column, it should be maipulated to create original columns
7) Select the column, and In Data menu, using Text to Column option, splited the column by speces 
   between them
8) set format of each column based on original data file
9) It's ready to load it in SAS and work on that; It saved as "Dataset2.xlsx"

proc import datafile = '/folders/myfolders/cars.csv'
 out = work.cars
 dbms = CSV
;
run;
*/
/* Method2:
 ----------
   For Input file in this project is used Method2.
*/

/**********************************************************************************************/
*......................................IMPORT DATA.............................................;
/**********************************************************************************************/

LIBNAME Sara "C:\Sara\Data SCIENCE\Advance SAS\My Project";


TITLE " TABLE: New_Wireless_Fixed ";
DATA Sara.NWF;
INFILE 'C:\Sara\Data SCIENCE\Advance SAS\My Project\New_Wireless_Fixed.txt' TRUNCOVER;
INPUT Acctno $ 1-13
      Actdt @26 
      Deactdt  
      DeactReason $ 41-48 
      GoodCredit 53-54  
      RatePlan 62-63
      DealerType $ 65-66 
      Age 74-75 
      Province $ 80-81 
      Sales DOLLAR11.2 ;
informat Actdt Deactdt MMDDYY10.;
format   Actdt Deactdt MMDDYY10.;
FORMAT   Sales DOLLAR11.2;
RUN;

*
1) Flowover: It’s the default option in SAS. It causes the INPUT statement to jump to the next
   record if it doesn’t find values for all variables.
2) Missover: This option sets all empty vars to missing when reading a short line.However, it 
   can skip values
3) Truncover: It forces the INPUT statement to stop reading when it gets to the end of a short
   line. This option will not skip information and will take partial values to fill the first
   unfilled variable.;

/**********************************************************************************************/
*..........................................IMPORT MACRO........................................;
/**********************************************************************************************/

*TO TURN ON MACRO PROCESSOR
---------------------------;
PROC OPTIONS OPTION = MACRO;
RUN;
%include "C:\Sara\Data SCIENCE\Advance SAS\My Project\SARA_MACRO_ DATA ANALYSIS.sas";

/**********************************************************************************************/
*........................................EDA Dataset...........................................;
/**********************************************************************************************/

*
What Is Exploratory Data Analysis?
Exploratory Data Analysis is an approach in analyzing data sets to summarize their main characteristics, 
often using statistical graphics and other data visualization methods.
EDA assists Data science professionals in various ways:-

1 Getting a better understanding of data
2 Identifying various data patterns
3 Getting a better understanding of the problem statement;

*EDA-1)DATA CLEANING;
*-------------------;

Title 'Summary of New_Wireless_Fixed';
proc means data = Sara.NWF  n NMISS  mean max min range median clm alpha=0.05 std fw=8;
*n for number of non-missing and nmiss for number of missing;
run;

*EDA-1-1) Handling Duplicate Data;
*--------------------------------;
PROC SORT DATA = Sara.NWF OUT = SaraNWF NODUPKEY;
BY Acctno;
RUN;

PROC PRINT DATA = SaraNWF noobs; RUN;
*The NOOBS option suppresses observation numbers in the output.;

Proc sql;
select * from SaraNWF;
quit;
TITLE;

PROC CONTENTS DATA = Sara.NWF;
RUN;

*EDA-1-2) Handling Missing value;
*-------------------------------;
*
This is the most important step in EDA involving removing duplicate rows/columns, 
filling the void entries with values like mean/median of the data, dropping various values,
removing null entries
;
*Misssing Value and Filling values in place of Null Entries(If Numerical feature);

PROC SQL;
CREATE TABLE SARA_NWF AS
SELECT * ,
	COALESCE(Age,mean(Age)) as N_Age, 
	COALESCE(Sales,median(Sales)) AS N_Sales
FROM SaraNWF
;
ALTER TABLE SARA_NWF 
DROP Age,Sales
;
QUIT;
PROC PRINT DATA = SARA_NWF;RUN;


*EDA-1-3) DESCRIPTIVE Data;
*-------------------------;
*
Checking Introductory Details About Data
The first and foremost step of any data analysis, after loading the data file, should be about checking
few introductory details like, no. Of columns, no. of rows, types of features( categorical or Numerical),
data types of column entries.
;

*TWO TYPES OF DATA: CONTINOUS AND CATEGORICAL;
*EDA-1-3-a) CONTINOUS: FIVE NUMBER SUMMARY: MIN MAX IQR MEDIAN OUTLIERS;
*----------------------------------------------------------------------;

PROC MEANS DATA = SARA_NWF;RUN;
PROC UNIVARIATE DATA = SARA_NWF;RUN;

*
Statistical Insight
This step should be performed for getting details about various statistical data like Mean, Standard
Deviation, Median, Max Value, Min Value
;

*FIVE NUMBER SUMMARY and so on;
*-----------------------------;
proc means data = SARA_NWF n mean max min range median clm alpha=0.05 std fw=8;
   var N_Sales N_Age;
   title 'Summary of Sales';
run;

*EDA-1-3-b) CATEGORICAL: FREQ;
*----------------------------;
PROC FREQ DATA = SARA_NWF;
TABLE GoodCredit Province DealerType DeactReason RatePlan;
RUN;

/*RatePlan: It's categorical, specifically ordinal. (If for you categorical doesn't include ordinal,
  rewrite that as you prefer.) Whether it's numeric in the sense of a measured variable pivots
  on what you mean by measurement. As for whether you can validly work with sums, there is an entire
  spectrum of opinion from that being out of order to it being what people do, and the heck with it.
  Opinion variables on a 1 to 5 or 1 to 10 scale are usually considered as ordinal categorical variables.*/
*

EDA-2)Data Visualization
------------------------

Data visualization is the method of converting raw data into a visual form, such as a map or graph,
to make data easier for us to understand and extract useful insights.
;

*EDA-2-1)Univariate Analysis;
*---------------------------;

*EDA-2-1-1)CONTINOUSE DATA : 
---------------------------;

*System options for debugging macros
------------------------------------;
*1. MLOGIC/NOMLOGIC: MACRO LOGIC: DESCRIBE THE ACTION OF MACRO PROCESSOR: When this option is on , 
    SAS prints in your log details about the execution of macros;
*2. MPRINT/NOMPRINT : MACRO PRINT :WHEN THIS OPTION IS ON,SAS PRINITS IN YOUR LOG STANDARD SAS
    STATEMENTS GENERATED BY MACRO PROGRAM;
*3. SYMBOLGEN/NOSYMBOLGEN : WHEN THIS OPTION IS ON, SAS PRINTS IN YOUR LOG THE VALUES OF MACRO VARAIBLES;

OPTIONS MLOGIC MPRINT SYMBOLGEN;
%SARA_UNI_ANALYSIS_NUM(SARA_NWF,N_Age)
%SARA_UNI_ANALYSIS_NUM(SARA_NWF,N_Sales)

*TURN OFF ALL OPTIONS;
OPTIONS MLOGIC MPRINT SYMBOLGEN;
%SARA_UNI_ANALYSIS_NUM(SARA_NWF,N_Age)
%SARA_UNI_ANALYSIS_NUM(SARA_NWF,N_Sales)

*EDA-2-1-2)CATEGORICAL VARIABLES:
--------------------------------;
OPTIONS MLOGIC MPRINT SYMBOLGEN;
%SARA_UNI_ANALYSIS_CAT(SARA_NWF,Province)
%SARA_UNI_ANALYSIS_CAT(SARA_NWF,GoodCredit)
%SARA_UNI_ANALYSIS_CAT(SARA_NWF,RatePlan)
%SARA_UNI_ANALYSIS_CAT(SARA_NWF,DealerType)
OPTIONS MLOGIC MPRINT SYMBOLGEN;


*EDA-2-1) Bivariate Analysis;
*---------------------------;

*EDA-2-1-1)Continouse Vs. Categorical:
--------------------------------------
    For summaraization: Grouped by categorical column an aggragte for numerical column
    For visualization : Grouped box plot,...
    For test of independence :1) if categorical column has only two levels :t-test
                              2) if categorical column has more than two levels: ANOVA
;

*Macro for RELATION BETWEEN Sales Vs. Province;
*.............................................;
OPTIONS MLOGIC MPRINT SYMBOLGEN;
%SARA_BI_ANALYSIS_NUMs_CAT (DSN = SARA_NWF ,CLASS=Province , VAR=N_Age N_Sales );
%SARA_BI_ANALYSIS_NUMs_CAT (DSN = SARA_NWF ,CLASS=Province , VAR=N_Sales);
OPTIONS MLOGIC MPRINT SYMBOLGEN;


*Macro for RELATION BETWEEN Age Vs. Province;
*.....................................................;
OPTIONS MLOGIC MPRINT SYMBOLGEN;
%SARA_AGG_CAT_NUM (DSN =SARA_NWF ,CLASS=Province , VAR=N_Age );
OPTIONS MLOGIC MPRINT SYMBOLGEN;

*Test independency 
-----------------;
*Macro ANOVA TEST FOR Continouse Vs. Categorical;
*...............................................;
%SARA_ANOVA_CAT_NUM (DSN = SARA_NWF ,CLASS=Province , VAR=N_Age  N_Sales);

*EDA-2-1-2)Categorical Vs. Categorical:
---------------------------------------
For summaraization: contingency table (two-way table)
For visualization : stacked bar chart,Grouped bar chart,...
For test of independence:chi-square test ;

*MACRO FOR RELATION BETWEEN Province Vs. GoodCredit WITH VISUALIZATION AND TEST OF INDEPENDENCE;
*..............................................................................................;
%SARA_CHSQUARE_CAT_CAT(DSN = SARA_NWF  , VAR1= Province , VAR2 = Actdt);
%SARA_CHSQUARE_CAT_CAT(DSN = SARA_NWF  , VAR1= Province , VAR2 = Deactdt);
%SARA_CHSQUARE_CAT_CAT(DSN = SARA_NWF  , VAR1= Province , VAR2 = GoodCredit);
%SARA_CHSQUARE_CAT_CAT(DSN = SARA_NWF  , VAR1= Province , VAR2 = DeactReason);

*
Any analysis will not result in association to dates
                          Statistic   DF    Value      Prob 
Province vs. Actdt        Chi-Square  2912  2958.6509  0.2687 
Province vs. Deactdt	     Chi-Square  2736  2699.6012  0.6862 
Province vs. GoodCredit   Chi-Square  4     3.2508     0.5168 
Province vs. DeactReason  Chi-Square  16    24.9359    0.0710 
Probability for all of variable more than 0.05 significant level, therefore we can not reject the
null Hypothesis
;

/**********************************************************************************************/
*.....................................DATA SEGMENTATION........................................;
/**********************************************************************************************/

* WE HAVE TWO style FOR SEGMENTATION ONE OF THEM BY USING "IF-ELSE" AND "PROCFORMAT"
  IN THIS PROJECT ARE USED BOTH OF THEM. BUT USING "IF-ELSE" AS WELL AS PROC FORMAT. 
  BY USING "IF-ELSE" FOR SEGMENTATION, WE CAN GET NAME FOR DATA, THEREFORE IT IS EASY FOR USING 
  DURING TO WORK ON PROJECT;

DATA SARA.SEGMENT;
SET  SARA_NWF;

*1) ACCOUNT_STATUS (ACTIVE OR DEACTIVE)
---------------------------------------;
IF DEACTDT NE '' THEN ACCOUNT_STATUS = 'DEACTIVE';
ELSE 			 ACCOUNT_STATUS = 'ACTIVE';
	
*2)CREDIT_STATUS (GOOD OR BAD)
------------------------------;
IF GOODCREDIT NE 0 THEN CREDIT_STATUS ='1 = GOOD';
ELSE 			   CREDIT_STATUS ='0 = BAD';
				
*3) TENURE & MONTH
------------------;
CURRENTDATE = TODAY();
DEACT_YEARMONTH = put(DEACTDT,yymmn6.);
DEACT_MONTH = put(DEACTDT,MONNAME.);
IF DEACTDT = ' ' THEN TENURE=INTCK('DAY', ACTDT, CURRENTDATE);
ELSE 			 TENURE=INTCK('DAY', ACTDT, DEACTDT);

*4) SALES SEGMENTATION
----------------------;
IF 	 N_SALES LE 101 THEN SALES_GROUP = "<100";
ELSE IF N_SALES LE 501 THEN SALES_GROUP = "100 - 500";
ELSE IF N_SALES LE 801 THEN SALES_GROUP = "500 - 800";
ELSE 			       SALES_GROUP = "800>";

*5) TENURE SEGMENTATION
-----------------------;
IF 	 TENURE LE 31  THEN 	TENURE_GROUP = "<30 DAYS";
ELSE IF TENURE LE 61  THEN 	TENURE_GROUP = "31 - 60 DAYS";
ELSE IF TENURE LE 366 THEN 	TENURE_GROUP = "61 DAYS - 1 YR";
ELSE 				TENURE_GROUP = "1 YR & ABOVE";
		
*6) AGE SEGMENTATION
--------------------;
IF 	 N_AGE LE 21 THEN AGE_GROUP = " <20";
ELSE IF N_AGE LE 41 THEN AGE_GROUP = "20 - 40";
ELSE IF N_AGE LE 61 THEN AGE_GROUP = "40 - 60";
ELSE 			    AGE_GROUP = "60 & ABOVE";
				
RUN;

*7) PRINT THE DATASET 
---------------------;
*For TO GET FAST RESULTS TOTAL OBSERVATIONS ARE CONSIDERINGSET TO 50 ; 
TITLE	"DATASET AFTER SEGMENTMENTATION - TABLENAME: SEGMENT";
PROC PRINT DATA = SARA.SEGMENT (OBS = 50); RUN;
TITLE;

*8) GETTING FORMATS TO BE USED DURING THE PROJECT
-------------------------------------------------;
PROC FORMAT;
VALUE SALES_CATEGORY
      LOW - < 101 = " < 100"
      101 - < 501 = "100 - 500"
      501 - < 801 = "500 - 800"
      801 - HIGH  = "800 & ABOVE"
;
VALUE AGE_CATEGORY
      LOW - < 21 = " < 20"
      21 - < 41  = "20 - 40"
      41 - < 61  = "40 - 60"
      61 - HIGH  = "60 & ABOVE"
;
VALUE TENURE_CATEGORY
      LOW - < 31 = " < 30 DAYS"
      31 - < 61  = "31 - 60 DAYS"
      61 - < 366 = "61 DAYS - 1 YEARS"
      366 - HIGH = "1 YEAR & ABOVE"
;
VALUE GC_FMT
      1 = "  1 = GOOD"
      0 = " 0  = BAD"
;
RUN;

*________________________________________________________________________________________________________;

*------------------------------------...... ANSWER THE QUESTION.....-------------------------------------;
*________________________________________________________________________________________________________;

/*********************************************************************************************************
Analysis requests:
1.1  Explore and describe the dataset briefly. For example, is the acctno unique? What
is the number of accounts activated and deactivated? When is the earliest and
latest activation/deactivation dates available? And so on….
*********************************************************************************************************/
*........................................................................................................;
*Q1(a). Explore and describe the dataset briefly or(PROPERITIES OF A DATA SET(Browsing decriptor portion));
         *To obtain a list of all of the columns in a table and their attributes, you can use the DESCRIBE 
          TABLE statement.;
proc contents data = SARA_NWF;
   title  'The Contents of the New_Wireless_Fixed Data Set';
run;
PROC SQL;
   DESCRIBE TABLE SARA_NWF;
QUIT;

proc contents data = SARA.SEGMENT;
   title  'The Contents of the New_Wireless_Fixed Data Set';
run;
PROC SQL;
   DESCRIBE TABLE SARA.SEGMENT;
QUIT;
*........................................................................................................;

*Q1(b): Is the acctno unique? 
        find all unique values for Acctno in New_Wireless_Fixed data set from sashelp libraray
	 * REMOVE DUPLICATE RECORDS;
	 *If you want to remove duplicate records in your data set you should use by _all_;

*Q1 (b):METHOD1: NUMBER OF UNIQUE ACCOUNTS VERIFICATION
-----------------------------------------------;
PROC SQL OUTOBS = 10;
SELECT COUNT(*) AS TOTAL_RECORDS, 
       COUNT(DISTINCT ACCTNO) AS UNIQUE_ACCOUNTS
FROM SARA.SEGMENT
;				
QUIT;

*Q1 (b):METHOD2: NUMBER OF UNIQUE ACCOUNTS VERIFICATION
-----------------------------------------------;
PROC SQL;
SELECT COUNT(*) AS TOTAL_COUNT, 
	COUNT(DISTINCT Acctno) AS UNIQUE_COUNT
FROM SARA_NWF
;
QUIT;

*Q1 (b): Method1: UNIQUE ACCOUNTS
---------------------------------;
PROC SORT DATA = SARA_NWF;
BY Acctno;
RUN;
PROC PRINT DATA = SARA_NWF (OBS=10);
VAR Acctno;
RUN;

*Q1 (b): Method2: UNIQUE ACCOUNTS
---------------------------------;
PROC SQL OUTOBS = 10;
CREATE TABLE SARA_NWF_Acctno AS
SELECT DISTINCT Acctno
FROM SARA_NWF
;
QUIT;
proc print data = SARA_NWF_Acctno;run;

*........................................................................................................;

*Q1 (c): What is the number of accounts activated and deactivated? 
         find total number of obs and number of unique values for Acctno in New_Wireless_Fixed dataset 
         from sara libraray;
         *COUNT();
	  *If instesd of * use any column name in count, it will count for you
          number of non missing values;

*Q1 (c): Method1:  The number of accounts activated and deactivated
-------------------------------------------------------------------;
TITLE "TOTAL ACTIVATED AND DEACTIVATED ACCOUNTS";
FOOTNOTE "CREATED BY SARA";
PROC SQL;
SELECT COUNT(Actdt)            AS TOTAL_COUNT_Actdt, 
	COUNT(DISTINCT Actdt)   AS UNIQUE_COUNT_Actdt,
	COUNT(Deactdt)          AS TOTAL_COUNT_Deactdt, 
	COUNT(DISTINCT Deactdt) AS UNIQUE_COUNT_Deactdt
FROM SARA_NWF
;
QUIT;
TITLE;
FOOTNOTE;

*Q1 (c): Method2: The number of accounts activated and deactivated
------------------------------------------------------------------;
TITLE "TOTAL ACTIVATED ACCOUNTS";
FOOTNOTE "CREATED BY SARA";
PROC SQL OUTOBS = 50;
SELECT COUNT(*) AS TOTAL_ACTIVATED_COUNT
FROM  SARA.SEGMENT
WHERE DEACTDT IS NULL
;
QUIT;
TITLE;
FOOTNOTE;

TITLE "TOTAL DEACTIVATED ACCOUNTS";
FOOTNOTE "CREATED BY SARA";
PROC SQL OUTOBS = 50;
SELECT COUNT(*) AS TOTAL_DEACTIVATED_COUNT
FROM  SARA.SEGMENT
WHERE DEACTDT IS NOT NULL 
;
QUIT;
TITLE;
FOOTNOTE;

*........................................................................................;

/*Q1. (d): When is the earliest and latest activation and deactivation dates available? */
* Q1. (d): Method1 ;
Title "The First activation";
Footnote "created by SARA";
proc sql outobs=1;
         select*from SARA_NWF
	  where Actdt is not null
	  order by Actdt;
Quit;
Title;
Footnote;

Title "The last activation";
Footnote "created by SARA";
proc sql outobs=1;
         select*from SARA_NWF
	  where Actdt is not null
	  order by Actdt DESc;
Quit;
Title;

Title2 "The First deactivated";
Footnote "created by SARA";
proc sql outobs=1;
         select*from SARA_NWF
	  where deactdt is not null
	  order by deactdt;
Quit;
title;

Title "The last deactivated";
Footnote "created by SARA";
proc sql outobs=1;
         select*from SARA_NWF
	  where deactdt is not null
	  order by deactdt DESc;
Quit;
title;
Footnote;

*Q1.(E): TOTAL SALES BY PROVINCE 
---------------------------------;

TITLE "TOTAL SALES BY PROVINCE";
PROC SQL OUTOBS = 10;
SELECT DISTINCT PROVINCE AS PROVINCE, SUM(N_SALES) AS TOTAL_SALES FROM SARA_NWF
GROUP BY PROVINCE;
QUIT;	
TITLE;

*GRAPHICAL REPRESENTATION - VERTICAL BAR CHART
----------------------------------------------;

TITLE4 "TOTAL SALES BY PROVINCE FOR ALL CUSTOMER: GRAPHICAL REPRESENTATION";
PROC SGPLOT DATA = SARA.SEGMENT;
VBAR PROVINCE / RESPONSE = N_SALES STAT = SUM;
XAXISTABLE N_SALES / STATS = SUM POSITION = TOP;
STYLEATTRS 
BACKCOLOR = LIGHTBLUE 
WALLCOLOR = WHITE;
RUN;
TITLE4;


/*********************************************************************************************
1.2  What is the N_Age and province distributions of active and deactivated customers?
**********************************************************************************************/

*USING PROC SQL 
---------------;

*1-2-1)ACTIVE CUSTOMERS
------------------------; 
*METHOD 1: USING AGE
--------------------;
*ACTIVE CUSTOMERS (DEACTDT IS NULL);
TITLE " AGE AND PROVINCE DISTRIBUTION OF ACTIVE CUSTOMERS - TABLENAME";
PROC SQL OUTOBS = 10;
SELECT N_AGE,
	PROVINCE,
	COUNT(*) AS TOTAL_ACTIVE_CUSTOMERS,
	SUM(N_SALES) AS TOTAL_SALES
FROM 	SARA.SEGMENT
WHERE 	DEACTDT IS NULL
GROUP BY N_AGE, PROVINCE
ORDER BY N_AGE, PROVINCE;
QUIT; 
TITLE;

*METHOD 2: USING AGEGROUP
-------------------------;
TITLE " AGE AND PROVINCE DISTRIBUTION OF ACTIVE CUSTOMERS USING AGEGROUPS";
PROC SQL OUTOBS = 10;
SELECT AGE_GROUP,
	PROVINCE,
	COUNT(*) AS TOTAL_ACTIVE_CUSTOMERS,
	SUM(N_SALES) AS TOTAL_SALES
FROM 	SARA.SEGMENT
WHERE 	DEACTDT IS NULL
GROUP BY AGE_GROUP, PROVINCE
ORDER BY AGE_GROUP, PROVINCE;
QUIT; 
TITLE;

*1-2-2)DEACTIVE CUSTOMERS
-------------------------; 
*METHOD 1: USING AGE
--------------------;
* DEACTIVE CUSTOMERS (DEACTDT IS NOT NULL); 
TITLE " AGE AND PROVINCE DISTRIBUTION OF DEACTIVE CUSTOMERS";
PROC SQL OUTOBS = 10;
SELECT N_AGE,
	PROVINCE,
	COUNT(*) AS TOTAL_INACTIVE_CUSTOMERS,
	SUM(N_SALES) AS TOTAL_SALES
FROM 	SARA.SEGMENT
WHERE 	DEACTDT IS NOT NULL
GROUP BY N_AGE, PROVINCE
ORDER BY N_AGE, PROVINCE;
QUIT; 
TITLE;

*METHOD 2: USING AGEGROUP
-------------------------;
TITLE " AGE AND PROVINCE DISTRIBUTION OF DEACTIVE CUSTOMERS USING AGEGROUPS";
PROC SQL OUTOBS = 10;
SELECT AGE_GROUP,
	PROVINCE,
	COUNT(*) AS TOTAL_INACTIVE_CUSTOMERS,
	SUM(N_SALES) AS TOTAL_SALES
FROM 	SARA.SEGMENT
WHERE 	DEACTDT IS NOT NULL
GROUP BY AGE_GROUP, PROVINCE
ORDER BY AGE_GROUP, PROVINCE;
QUIT; 
TITLE;

/*********************************************************************************************
1.3 Segment the customers based on age, province and sales :
Sales segment: < $100, $100---500, $500-$800, $800 and above.
Age segments: < 20, 21-40, 41-60, 60 and above.
Create analysis report 
**********************************************************************************************/

DATA SARA_NWF_dataGroup;
SET  SARA_NWF;
length   agegruop $15;
length   salesgroup $15;
if       N_age   le 20  then  agegruop = 'less than 20';
else if  N_age   le 41  then  agegruop = 'between 21-40 ';
else if  N_age   le 61  then  agegruop = 'between 41-60 ';
else if  N_age   gt 61  then  agegruop = 'more than 60';
		
if       N_Sales le 100 then  salesgroup = 'less than 100';
else if  N_Sales le 500 then  salesgroup = 'between 100-500';	 
else if  N_Sales le 800 then  salesgroup = 'between 500-800';	 
else if  N_Sales gt 80  then  salesgroup = 'more than 800';	
run;

proc print data = SARA_NWF_dataGroup(OBS = 10);
run;

title "Segment the customers based on age, province and sales";
footnote "created by SARA";
proc freq data = SARA_NWF_dataGroup;
table agegruop salesgroup province/missing list;
run;
title;
footnote;

*MISSING: treats missing values as a valid nonmissing level for all TABLES variables. The MISSING 
          option displays the missing levels in frequency and crosstabulation tables and includes 
          them in all calculations of percentages, tests, and measures.
          By default, if you do not specify the MISSING or MISSPRINT option, an observation is 
          excluded from a table if it has a missing value for any of the variables in the TABLES 
          request. When PROC FREQ excludes observations with missing values, it displays the total
          frequency of missing observations below the table. See the section Missing Values for more
          information.
 LIST: The forward slash followed by LIST keyword produces the list styled table.
 NOCOL: suppresses the display of column percentages in crosstabulation table cells.
 NOROW: suppresses the display of row percentages in crosstabulation table cells.
 ;

proc freq data=SARA_NWF(OBS=50);
table N_Age*N_Sales / norow nocol missing;
run;

proc freq data=SARA_NWF(OBS=50);
table N_Age*Province / norow nocol missing;
run;

proc freq data=SARA_NWF(OBS=50);
table N_Sales*Province / norow nocol missing;
run;

/*********************************************************************************************
1.4.Statistical Analysis:
1) Calculate the tenure in days for each account and give its simple statistics.
2) Calculate the number of accounts deactivated for each month.
3) Segment the account, first by account status “Active” and “Deactivated”, then by
Tenure: < 30 days, 31---60 days, 61 days--- one year, over one year. Report the
number of accounts of percent of all for each segment.
4) Test the general association between the tenure segments and “Good Credit”
“RatePlan ” and “DealerType.”
5) Is there any association between the account status and the tenure segments?
Could you find out a better tenure segmentation strategy that is more associated
with the account status?
6) Does Sales Sales differ among different account status, GoodCredit, and
customer age segments?
*******************************************************************************************************/

*1-4-1) Calculate the tenure in days for each account and give its simple statistics.
------------------------------------------------------------------------------------;

*DATE CONSTANT :"1JAN2020"D , MDY( month,day ,year ) ;

*You can use a date as a constant in a SAS expression. Put the date in DATEw. format (such as 01FEB2001).
 INTCK: The INTCK in SAS is a function that returns the number of time units between two dates. For the
 time unit, you can choose years, months, weeks, days, and more. INTNX The INTNX function returns a SAS 
 date that is a specified number of time units away from a specified date ;

*METHOD1:
--------;
TITLE	" The tenure in days for each account ";
FOOTNOTE "CREATED BY SARA";
DATA SARA_TENURE_ACCOUNT ;
SET SARA_NWF;
TENURE = INTCK('DAY',Actdt,'01FEB2002'D);
    /* Calculate the difference in days */
    dif_days = intck('day', Actdt, Deactdt);
    /* Calculate the difference in weeks */
    dif_weeks = intck('week', Actdt, Deactdt);
    /* Calculate the difference in months */
    diff_months = intck('month', Actdt, Deactdt);
RUN;

PROC PRINT DATA = SARA_TENURE_ACCOUNT (OBS=10);
FORMAT Actdt Deactdt  DATE9.;
RUN;

%SARA_UNI_ANALYSIS_NUM (SARA_TENURE_ACCOUNT, TENURE);
TITLE;

*METHOD2:
--------;
DATA SARA_NWF_SEGMENT;
SET  SARA_NWF;
CURRENTDATE = TODAY();
DEACT_YEARMONTH = put(DEACTDT,yymmn6.);
DEACT_MONTH = put(DEACTDT,MONNAME.);
IF DEACTDT = ' ' THEN TENURE = INTCK('DAY', ACTDT, CURRENTDATE);
ELSE                  TENURE = INTCK('DAY', ACTDT, DEACTDT);
RUN;

TITLE	"DATASET AFTER SEGMENTMENTATION";
PROC PRINT DATA = SARA_NWF_SEGMENT (OBS=10); RUN;
TITLE;

*AVERAGE, MIN AND MAX
----------------------;
TITLE	"DATASET AFTER SEGMENTMENTATION";
PROC MEANS DATA = SARA_NWF_SEGMENT ;
VAR TENURE;
RUN;

*TENURE SEGMENTATION AND FREQUENCIES
-------------------------------------;
PROC FREQ DATA = SARA_NWF_SEGMENT;
FORMAT TENURE TENURE_CATEGORY.;
TABLE TENURE/NOROW NOCOL MISSING;
RUN;
TITLE;

*1-4-2) Calculate the number of accounts deactivated for each month.
-------------------------------------------------------------------;
TITLE	" The number of accounts deactivated for each month ";
FOOTNOTE "CREATED BY SARA";
DATA SARA_NWF_SEGMENT;
SET  SARA_NWF;
CURRENTDATE = TODAY();
DEACT_YEARMONTH = put(DEACTDT,yymmn6.);
DEACT_MONTH     = put(DEACTDT,MONNAME.);
IF   DEACTDT = ' ' THEN TENURE = INTCK('DAY', ACTDT, CURRENTDATE);
ELSE TENURE  = INTCK('DAY', ACTDT, DEACTDT);
RUN;

PROC SQL OUTOBS = 10;
SELECT   DEACT_YEARMONTH,
	  DEACT_MONTH,
	  COUNT(*) AS TOTAL_DEACTIVATED_CUSTOMERS
FROM     SARA_NWF_SEGMENT
WHERE    DEACTDT IS NOT NULL 
GROUP BY DEACT_YEARMONTH,DEACT_MONTH
ORDER BY DEACT_YEARMONTH,DEACT_MONTH ;
QUIT; 
TITLE;
FOOTNOTE;

*
Using PUT and INPUT Functions
In this example, the PUT function returns a numeric value as a character string. 
The value 122591 is assigned to the CHARDATE variable. The INPUT function returns 
the value of the character string as a SAS date value using a SAS date informat. 
The value 11681 is stored in the SASDATE variable.
The PUT statement writes the following lines to the SAS log:
SAS date=15639
formated date=26OCT2002
Note: Whenever possible, specify a year using all four digits. Most SAS date and time
language elements support four digit year values.[cautionend] ;


*1-4-3) Segment the account, first by account status “Active” and “Deactivated”, then by
Tenure: < 30 days, 31---60 days, 61 days--- one year, over one year. Report the
number of accounts of percent of all for each segment.
----------------------------------------------------------------------------------------;

*STEP1: SEGMENTING THE ACCOUNTS TO ACTIVE AND DEACTIVE
------------------------------------------------------;
DATA SARA_NWF_SEGMENT;
SET  SARA_NWF;
IF DEACTDT NE '' THEN STATUS='DEACTIVE';
ELSE                  STATUS='ACTIVE';
RUN;

*STEP2: FORMATTING THE TENURE SEGMENTS
--------------------------------------;
PROC FORMAT;
VALUE TENURE_CATEGORY
LOW - < 31 = " LESS THAN 30 DAYS"
31 - < 61  = "31 - 60 DAYS"
61 - < 366 = "61 DAYS - 1 YEARS"
366 - HIGH = "MORE THAN 1 YEAR"
;
RUN;

TITLE "DATASET AFTER SEGMENTMENTATION";
PROC PRINT DATA = SARA_NWF_SEGMENT (OBS=10); RUN;
TITLE;

*STEP-3: QUERYING THE DATASET FOR STATUS AND TENURE
---------------------------------------------------;
TITLE " CUSTOMER STATUS WISE TENURE REPORT ";
PROC SQL OUTOBS = 10;
SELECT PUT(N_AGE, AGE_CATEGORY. ) AS AGE_CATEGORY,
	PROVINCE,
	PUT(N_SALES, SALES_CATEGORY. ) AS SALES_CATEGORY,
	COUNT(*) AS TOTAL_CUSTOMERS,
	SUM(N_SALES) AS TOTAL_SALES
FROM 	  SARA_NWF_SEGMENT
GROUP BY AGE_CATEGORY, PROVINCE, SALES_CATEGORY
ORDER BY AGE_CATEGORY, PROVINCE, SALES_CATEGORY;
QUIT; 
TITLE;	

*STEP-4:GIVE FERQUENCY FOR STATUS AND TENURE IN A TABLE
-------------------------------------------------------;
PROC FREQ DATA = SARA.SEGMENT;
FORMAT TENURE TENURE_CATEGORY.;
TABLE ACCOUNT_STATUS*TENURE/NOROW NOCOL MISSING;
RUN;

*1-4-4) Test the general association between the tenure segments and “Good Credit”
“RatePlan ” and “DealerType.”
---------------------------------------------------------------------------------;
OPTIONS MLOGIC MPRINT SYMBOLGEN;
%SARA_UNI_ANALYSIS_CAT(SARA.SEGMENT,TENURE_GROUP)
%SARA_UNI_ANALYSIS_CAT(SARA.SEGMENT,CREDIT_STATUS)
%SARA_UNI_ANALYSIS_CAT(SARA.SEGMENT,RATEPLAN)
%SARA_UNI_ANALYSIS_CAT(SARA.SEGMENT,DEALERTYPE)

%SARA_CHSQUARE_CAT_CAT(DSN = SARA.SEGMENT  , VAR1= TENURE_GROUP , VAR2 =CREDIT_STATUS);
%SARA_CHSQUARE_CAT_CAT(DSN = SARA.SEGMENT  , VAR1= TENURE_GROUP , VAR2 =DEALER_TYPE);
%SARA_CHSQUARE_CAT_CAT(DSN = SARA.SEGMENT  , VAR1= TENURE_GROUP , VAR2 =RATEPLAN);
%SARA_CHSQUARE_CAT_CAT(DSN = SARA.SEGMENT  , VAR1= TENURE_GROUP , VAR2 =ACCOUNT_STATUS);
OPTIONS MLOGIC MPRINT SYMBOLGEN;

*1-4-5) Is there any association between the account status and the tenure segments?
Could you find out a better tenure segmentation strategy that is more associated
with the account status?
-----------------------------------------------------------------------------------;
OPTIONS MLOGIC MPRINT SYMBOLGEN;
%SARA_UNI_ANALYSIS_CAT(SARA.SEGMENT,TENURE_GROUP)
%SARA_UNI_ANALYSIS_CAT(SARA.SEGMENT,ACCOUNT_STATUS)

%SARA_CHSQUARE_CAT_CAT(DSN = SARA.SEGMENT  , VAR1= TENURE_GROUP , VAR2 =ACCOUNT_STATUS);
OPTIONS MLOGIC MPRINT SYMBOLGEN;

*BETTER TENURE SEGMENTATION
---------------------------;
DATA SARA_NEWSEGMENT;
SET  SARA.SEGMENT;
IF      TENURE LE 183  THEN NEW_TENURE_GROUP= "< 6 MTHS";
ELSE IF TENURE LE 366  THEN NEW_TENURE_GROUP= "6 MTHS - 1 YEAR";
ELSE IF TENURE LE 3660 THEN NEW_TENURE_GROUP= "1 YEAR - 10 YR";
ELSE 			       NEW_TENURE_GROUP= "10 YR & ABOVE";
		
RUN;

TITLE "DATASET AFTER SEGMENTMENTATION - TABLENAME : NEWSEGMENT";
PROC PRINT DATA=SARA.SEGMENT (OBS=10); RUN;
TITLE;

PROC FREQ DATA=SARA_NEWSEGMENT;
TABLE ACCOUNT_STATUS*NEW_TENURE_GROUP/NOROW NOCOL MISSING;
RUN;

%SARA_UNI_ANALYSIS_CAT(SARA_NEWSEGMENT,NEW_TENURE_GROUP)

%SARA_CHSQUARE_CAT_CAT(DSN = SARA_NEWSEGMENT, VAR1= TENURE_GROUP, VAR2 =ACCOUNT_STATUS);


*USE EXPECTED option TO IMPROVE CHI_SQUARE
------------------------------------------;
*
The EXPECTED option displays expected cell frequencies in the crosstabulation table, and 
the CELLCHI2 option displays the cell contribution to the overall chi-square. The NOROW 
and NOCOL options suppress the display of row and column percents in the crosstabulation
table. The CHISQ option produces chi-square tests.

The OUTPUT statement creates the ChiSqData output data set and specifies the statistics to 
include. The N option requests the number of nonmissing observations, the NMISS option
stores the number of missing observations, and the PCHI and LRCHI options request Pearson 
and likelihood-ratio chi-square statistics, respectively, together with their degrees of 
freedom and -values.
;

PROC SQL  OUTOBS =10;
CREATE TABLE SARA_COUNT_EX AS
SELECT TENURE_GROUP,
	ACCOUNT_STATUS,
	COUNT(*) AS COUNT
FROM  SARA.SEGMENT
GROUP BY TENURE_GROUP 
ORDER BY TENURE_GROUP;
QUIT; 
TITLE;
FOOTNOTE;
PROC PRINT DATA = SARA_COUNT_EX; RUN;

proc freq data = SARA_COUNT_EX;
   tables TENURE_GROUP ACCOUNT_STATUS TENURE_GROUP*ACCOUNT_STATUS / expected cellchi2 norow nocol chisq;
   output out=ChiSqData n nmiss pchi lrchi;
   weight COUNT;
   title 'The account status and the tenure segments';
run;
proc print data=ChiSqData noobs;
   title1 'Chi-Square Statistics for tenure and ACCOUNT_STATUS';
   title2 'Output Data Set from the FREQ Procedure';
run;

PROC FREQ DATA=SARA_COUNT_EX;
   WEIGHT count / ZEROS; 
   TABLES TENURE_GROUP*ACCOUNT_STATUS / CHISQ;
RUN;


*1-4-6) Does Sales differ among different account status, GoodCredit, and
customer age segments?
-------------------------------------------------------------------------;

*ANALYZING FOR ACCOUNT_STATUS, CREDIT_STATUS,AND AGE_GROUP BY SALES
-------------------------------------------------------------------;
OPTIONS MLOGIC MPRINT SYMBOLGEN;
%SARA_BI_ANALYSIS_NUMs_CAT (DSN = SARA.SEGMENT ,CLASS=ACCOUNT_STATUS , VAR=N_Sales );
%SARA_BI_ANALYSIS_NUMs_CAT (DSN = SARA.SEGMENT ,CLASS=CREDIT_STATUS , VAR=N_Sales );
%SARA_BI_ANALYSIS_NUMs_CAT (DSN = SARA.SEGMENT ,CLASS=AGE_GROUP , VAR=N_Sales );
OPTIONS MLOGIC MPRINT SYMBOLGEN;

*USING ANOVA TEST FOR CATEGORICAL VARIABLE ACCOUNT_STATUS, AND AGE_GROUP FOR NUMERICAL VARIABLE SALES
-----------------------------------------------------------------------------------------------------;
OPTIONS MLOGIC MPRINT SYMBOLGEN;
%SARA_ANOVA_CAT_NUM (DSN = SARA.SEGMENT ,CLASS=CREDIT_STATUS, VAR=N_Sales);
%SARA_ANOVA_CAT_NUM (DSN = SARA.SEGMENT ,CLASS=AGE_GROUP, VAR=N_Sales );
OPTIONS MLOGIC MPRINT SYMBOLGEN;

*_______________________________________________________________________________________________________;
*______________________________________..... RFM ANALYSIS.....__________________________________________;
*_______________________________________________________________________________________________________;

*Q1 (a). Explore and describe the dataset briefly or(PROPERITIES OF A DATA SET(Browsing decriptor portion));
         *To obtain a list of all of the columns in a table and their attributes, you can use the DESCRIBE 
          TABLE statement.;
*Q1_Extra_q: What is the TOTAL TRANSACTIONS AND TOTAL Sales in the dataset?;

PROC SORT DATA = SARA_NWF OUT= CUX_S;
 BY Acctno;
RUN;
PROC PRINT DATA = CUX_S;RUN;

*sas executes observations one by one and for each observation excutes lines one by one;
*A sum statement also retains a value from the previous iteration;
*The variable's value is retained from one iteration to the next, as if it had appeared in a RETAIN 
 statement.
 To initialize a sum variable to a value other than 0, include it in a RETAIN statement with an initial 
 value.;
DATA Sara.CUX_01;
SET CUX_S;
TOTAL_TRAN+1;
TOTAL_SAL+N_Sales;
RUN;
PROC PRINT DATA = Sara.CUX_01;RUN;
*.....................................................................................................;

*Q_Extra_q: How can getting the TOTAL N_Sales in the dataset?;
PROC MEANS DATA = Sara.CUX_01 SUM mean max min ;
 VAR N_Sales;
RUN;

*Q_Extra_q: How can getting the TOTAL TRANSACTIONS AND TOTAL Sales by using proc sql?;
PROC SQL;
SELECT COUNT(*)AS TOTAL_TRAN , 
	SUM(N_Sales) AS TOTAL_SALE
FROM Sara.CUX_01
;
QUIT;	
*....................................................................................................;

*Q_Extra_q: COUNT HOW MANY UNIQUE CUSTOMERS AND HOW MANY TRANSACTIONS IN TOTAL?;
            *CALCULATE TOTAL Sales FOR EACH CUSTOMER;
            *Is the Acctno unique?;
DATA Sara.CUX_02;
 SET CUX_S;
 BY Acctno;
 IF FIRST.Acctno THEN TOTAL_TRAN=1;
 ELSE TOTAL_TRAN+1;
 IF FIRST.Acctno THEN TOTAL_SAL = N_Sales;
 ELSE TOTAL_SAL+N_Sales;
 IF LAST.Acctno;/*or IF LAST.Acctno THEN OUTPUT;*/
 DROP Actdt Deactdt  DeactReason  GoodCredit  RatePlan DealerType N_Age  Province N_Sales
;
 RUN;
PROC PRINT DATA = Sara.CUX_02;RUN;


*Q_Extra_q: Get the RECENCY FREQUENCY MONETARY in the dataset ?;

DATA RFM;
SET CUX_S;
BY Acctno;
*FOR MONETARY;
IF  FIRST.Acctno THEN TOTAL_SAL=0;
TOTAL_SAL+N_Sales;*THIS IS SUM STATEMENT;
*FOR FREQUENCY ;
IF FIRST.Acctno THEN TOTAL_TRANS=0;
TOTAL_TRANS+1;
*FOR RECENCY;
IF LAST.Acctno THEN OUTPUT;
DROP N_Sales;
RUN;
PROC PRINT DATA = RFM LABEL;
LABEL Actdt=Most_Recent TOTAL_TRANS=FREQUENCY TOTAL_SAL=MONETARY;
RUN;

*Q_Extra_q: Get the RECENCY FREQUENCY MONETARY in the dataset by using SQL?;

*Q-a: HOW MANY UNIQUE Acctno are in  the dataset? ;
PROC SQL;
SELECT COUNT(DISTINCT Acctno) AS UNI_Acctno_COUNT
FROM CUX_S
;
QUIT;

*Q-b: HOW MANY TRANS FOR EACH Acctno are in the dataset?;
PROC SQL;
SELECT Acctno, 
       COUNT(*) AS TOTAL_TRAN_BY_Acctno , 
       SUM(N_Sales) AS TOTAL_SAL_BY_Acctno
FROM CUX_S
GROUP BY Acctno
;
QUIT;

*Q_Extra_q: How has attain RECENCY FREQUENCY MONETARY BY USING SQL?;
PROC SQL;
SELECT Acctno, 
       COUNT(*) AS TOTAL_TRAN_BY_Acctno , 
	SUM(N_Sales) AS TOTAL_SAL_BY_Acctno,
       Max(Actdt) as most_recent_date format=date9.
FROM CUX_S
GROUP BY Acctno
;
QUIT;

*Craete a data set;
PROC SQL;
CREATE TABLE RFM2 AS
SELECT Acctno, 
       COUNT(*) AS TOTAL_TRAN_BY_Acctno , 
	SUM(N_Sales) AS TOTAL_SAL_BY_Acctno,
       Max(Actdt) as most_recent_date format=date9.
FROM CUX_S
GROUP BY Acctno
;
QUIT;
PROC PRINT DATA=RFM2;RUN;
*ORDER BY;

*DEFAULT IS ASCENDING;
PROC SORT DATA =  RFM2  OUT= CUX_S1 ;
BY TOTAL_TRAN_BY_Acctno TOTAL_SAL_BY_Acctno;
RUN;
PROC PRINT DATA = CUX_S1;
RUN;

PROC SQL;
CREATE TABLE RFM2 AS
SELECT Acctno, 
	COUNT(*) AS TOTAL_TRAN_BY_Acctno , 
	SUM(N_Sales) AS TOTAL_SAL_BY_Acctno,
       Max(Actdt) as most_recent_date format=date9.
FROM CUX_S
GROUP BY Acctno
ORDER BY TOTAL_TRAN_BY_Acctno ,TOTAL_SAL_BY_Acctno
;
QUIT;


*DESCENDING;
PROC SORT DATA = rfm OUT=CUX_S2 ;
   BY Acctno DESCENDING TOTAL_SAL;
RUN;
PROC PRINT DATA = CUX_S2;
RUN;

PROC SQL;
SELECT *
FROM SARA_NWF
ORDER BY Acctno DESC , N_Sales DESC
;
QUIT;

*What is the number of accounts activated and deactivated?;
*HOW MANY TRANS FOR EACH Acctno;
PROC SQL;
SELECT COUNT(DISTINCT Actdt) AS UNI_Actdt_COUNT
FROM CUX_S
;
QUIT;

PROC SQL;
SELECT COUNT(DISTINCT Deactdt) AS UNI_Deactdt_COUNT
FROM CUX_S
;
QUIT;


*CHECK IF YOUR SAS MACRO FACILITY IS ENABLE OR NOT?;
PROC OPTIONS OPTION = MACRO;
RUN;

*DAILY REPORT: Monday to Friday : getting top 3 customers;
PROC SORT DATA = SARA_NWF OUT= SaraNWF;
 BY DESCENDING N_Sales;
RUN;

PROC PRINT DATA = SaraNWF(OBS=3);
TITLE "DAILY  N_Sales : &SYSDATE. ,&SYSDAY. ";
TITLE "TOP 3 CUSTOMERS FOR &SYSDATE. ,&SYSDAY. ";
RUN;

*SATURDAY : SUMMARY REPORT;
PROC MEANS DATA = SARA_NWF MAXDEC=2 SUM MEAN MIN MAX;
CLASS DealerType;
VAR N_Sales;
TITLE "SUMMARY OF N_Sales BY DealerType : &SYSDATE. ,&SYSDAY.";
RUN;

%macro New_Wireless_Fixed;

*DAILY REPORT: Monday to Friday;
%IF &SYSDAY. NE SATURDAY %THEN 
%DO;
	PROC SORT DATA = SARA_NWF OUT = SaraNWF;
       BY DESCENDING N_Sales;
       RUN;

       PROC PRINT DATA = SaraNWF(OBS = 3);
       TITLE "DAILY  N_Sales : &SYSDATE. ,&SYSDAY. ";
       TITLE "TOP 3 CUSTOMERS FOR &SYSDATE. ,&SYSDAY. ";
       RUN;
%END;

%ELSE %IF &SYSDAY. EQ SATURDAY %THEN 
%DO;
*SATURDAY : SUMMARY REPORT;
           PROC MEANS DATA = SARA_NWF MAXDEC = 2 SUM MEAN MIN MAX;
           CLASS DealerType;
           VAR N_Sales;
      TITLE "SUMMARY of SALES BY DealerType : &SYSDATE. ,&SYSDAY.";
      RUN;
%END;
%mend New_Wireless_Fixed;
*The macro-name in the MEND statement is optional, but your macros will be easier to debug and maintain
 if you include it. ;

%New_Wireless_Fixed
*A semicolon is not required when invoking a macro, though adding one 
generally does no harm.;

DATA _NULL_;
 SET SARA_NWF;
 IF _n_ EQ 1 THEN  CALL SYMPUTX( "CUX_Acctno",Acctno);
 ELSE STOP;
RUN;
%put &CUX_Acctno;
PROC SQL;
TITLE "TOP CUSTOMER";
SELECT *
FROM SARA_NWF
WHERE Acctno EQ "&CUX_Acctno";
QUIT;

*_________________________________________________________________________________________________;

*......................................END PROJECT BY SARA........................................;
*_________________________________________________________________________________________________;
