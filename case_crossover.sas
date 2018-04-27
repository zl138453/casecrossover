******************Create case crossover data***********************;
*in the macro, ds is requirement;
*if your date, month and year in your dateset call date, m, year, then please just specify dataset name;
*example: %case_crossover(inpatient);
*otherwise, please specify the date name, month name or year name from your dateset;
*example: %case_crossover(inpatient,ADMITDTE=the date name from your set, month= the month name from your set, year=the year name from your set);


%macro case_crossover(ds,ADMITDTE=date,month=m,year=year);

data &ds._1;
set &ds.;
id =_n_;

if &month in (1 3 5 7 8 10 12) then do; *for months with 31 days;
begin =  mdy(&month,1,&year);
end = mdy(&month,31,&year);
end;

else if &month in (4 6 9 11) then do; * for months with 30 days;
begin =  mdy(&month,1,&year);
end = mdy(&month,30,&year);
end;

else if &month eq 2 then do; *for February;
if mod(&year.,4)=0 then do; *leap years;
begin =  mdy(&month,1,&year);
end = mdy(&month,29,&year);
end;

else if mod(&year.,4) ^=0 then do;  *non-leap years;
begin =  mdy(&month,1,&year);
end = mdy(&month,28,&year);
end;
end;

format begin end date9.;
run;

data &ds._2;
set &ds._1;
format control_date date7.;
do i = -28 to 28 by 7;
   control_date = &ADMITDTE + i;
  if (begin <= control_date <= end) then keep="yes"; else keep="no";
  if (begin <= &ADMITDTE + i) then control=i/7; 
  if (&ADMITDTE + i <= end) then control=i/7; 
  if keep="yes" then output;
end;
rename i=days;
run;

data &ds._3;
set &ds._2;
if control eq 0 then case = 1;
if control in (-4,-3,-2,-1,1,2,3,4) then case = 6 + control;	*case value must be positive for PROC PHREG, transform by adding 5;
if control = 0 then censor=1;
if control < 0 or control > 0 then censor=0;
run;
%mend;
