CSVDataFileName = 'CMH_1945_2021.csv'; %change to match your data file
RawData = readtable(CSVDataFileName); %read the csv data into a data talbe called RawData. I assume it is the original CSV file that came from NOAA, and was untouched

figure(1) %plot prcp vs date of the raw data
plot(RawData.DATE, RawData.PRCP)
xlabel('Date')
ylabel('Daily Precip [inches]') %change this label if using other units or durations
title('John Glenn Airport, Columbus, OH') %change this label if using other stations

Years = unique(year(RawData.DATE)); %find all unique years in the dataset
NY = length(Years); %determine the number of years

WeekDays = floor(daysdif(datetime([Years(1),1,1]),RawData.DATE)/7);  %determine the week each row belongs to (calculate number of days from 1/1 of the first year, and take the integer after dividing by 7) 
Weeks = unique(WeekDays); %find all unique weeks in the dataset
NW = length(Weeks); %determine the number of weeks

WeeklyPRCP = nan(NW,1);
WeekW = nan(NW,1);
YearW = nan(NW,1);
WeekDate = NaT(NW,1);

for wi = 1:NW
        WeeklyPRCP(wi)= nansum(RawData.PRCP(WeekDays==(Weeks(wi)))); %sum all events in days that belong to week(wi)
        WeekW(wi)= Weeks(wi);
        WeekDate(wi) = min(RawData.DATE(WeekDays==(Weeks(wi)))); %the date of the first day of the week in that year
        YearW(wi) = year(WeeklyDate(wi));
end

WeeklyPrecipData = table(YearW, WeekW, WeekDate, WeeklyPRCP); %WeeklyPrecipData is a data table, similar to RawData, but aggrerated to Weekly PRCP 

    
AnnualMaxDaily = nan(length(Years),3); %Table of daily PRCP AMR [Year, AnnualMaxDailyPrecipAccumulation (inches), AMR daily PRCP intensity (in/h)]
for y=1:NY
    AnnualMaxDaily(y,1) = Years(y);
    YearData = RawData.PRCP(year(RawData.DATE)==Years(y));
    if sum(~isnan(YearData))>0.9*365 %QA, checking if the number of days with data is larger than 90% of the expected days. If more than 10% is missing, it'll get a NaN
        AnnualMaxDaily(y,2) = max(YearData);
    end
end
AnnualMaxDaily(:,3) = AnnualMaxDaily(:,2)./24; %converting accumulation in secod column to intensity in third column


figure(2)
plot(AnnualMaxDaily(:,1), AnnualMaxDaily(:,2),'x')
xlabel('Year')
ylabel('Annual Max Daily Precip [inches]')
title('John Glenn Airport, Columbus, OH, 1948-2021')
xlim([1945,2022]);

AMRdt=AnnualMaxDaily(:,2);
Params = gevfit(AMRdt); %fitting extreme value distribution to the observed Annual max accumulation and getting the parameters of the fitted curve
T = 1:100; %return times
T(1)=1.1; %change first return time from 1 to 1.1
PT = gevinv((1-1./T),Params(1),Params(2),Params(3)); %Getting the value of extreme precip in different return times

figure(3)
plot(T,PT,'k') %plotting the fitted distribution of preipitation
xlabel('Return Time [years]')
ylabel('Daily Precip Accumulation [inches]')
title('John Glenn Airport, Columbus, OH')

NY = length(AMRdt);
H = histogram(AMRdt,25); %hystogram (empirical distribution) of AMR 
figure(4)
bar(0.5*(H.BinEdges(2:end)+H.BinEdges(1:end-1)),H.Values/NY) %plottng the observed distribution of precipitation (AMR, acumulation)
xlabel('Annual Max Daily Precipitation')
ylabel('Probability of Observed Precipitation')
title('Distribution of CMH Annual Max Daily Precip')
