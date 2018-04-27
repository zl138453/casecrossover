# casecrossover
SAS macro to create self control

##Create case crossover data##;
#in the macro, ds is requirement;
#if your date, month and year in your dateset call date, m, year, then please just specify dataset name;
#example: %case_crossover(inpatient);
#otherwise, please specify the date name, month name or year name from your dateset;
#example: %case_crossover(inpatient,ADMITDTE=the date name from your set, month= the month name from your set, year=the year name from your set);
