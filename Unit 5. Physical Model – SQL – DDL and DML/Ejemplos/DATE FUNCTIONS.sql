/********************************************WORKING WITH DAYS****************************************************************************/

/*EXTRACT() function: extracts specific parts of a date or time.*/
SELECT EXTRACT(DAY FROM '2025-11-25') AS ExtractDay;
SELECT EXTRACT(WEEK FROM '2025-11-25') AS ExtractWeek;

/*LAST_DAY() function: returns the last day of the month for a given date.*/
SELECT LAST_DAY('2025-11-25') AS LastDay;

/*DATEDIFF() function: returns the difference in days between two dates.*/
SELECT DATEDIFF('2025-12-25', '2025-11-25') AS DateDiff;

/*TO_DAYS() function: returns the number of days from year 0 to a given date.*/
SELECT TO_DAYS('2025-11-25') AS ToDays;

/*FROM_DAYS() function: converts a number of days to a date.*/
SELECT FROM_DAYS(750000) AS FromDays;

/*****************************************WORKING WITH MONTHS AND YEARS*********************************************************************/

/*MONTHNAME() function: returns the name of the month.*/
SELECT MONTHNAME('2025-11-25') AS MonthName;

/*YEAR() function: returns the year from a date.*/
SELECT YEAR('2025-11-25') AS Year;

/*DAY() function: returns the day from a date.*/
SELECT DAY ('2025-11-25') AS Day;

/*WEEK() function: returns the week from a date.*/
SELECT WEEK ('2025-11-25') AS Week;

/*QUARTER() function: returns the quarter of the year (1 to 4).*/
SELECT QUARTER('2025-11-25') AS Quarter;

/*PERIOD_ADD() function: adds months to a period in YYYYMM format.*/
SELECT PERIOD_ADD(202511, 3) AS PeriodAdd;  -- Returns: 202602

/*PERIOD_DIFF() function: returns the difference in months between two YYYYMM periods.*/
SELECT PERIOD_DIFF(202511, 202401) AS PeriodDiff;

/*****************************************WORKING WITH WEEKS*****************************************************************************/

/*WEEKOFYEAR() function: returns the ISO week number (1–53).*/
SELECT WEEKOFYEAR('2025-11-25') AS WeekOfYear;

/*Adding WEEKDAY() example using NOW(): This query shows the weekday number of the current day, where Monday = 0 and Sunday = 6.*/
SELECT WEEKDAY(NOW()) AS WeekDayToday;

/*****************************************WORKING WITH HOURS, MINUTES AND SECONDS************************************************************/

/*CURTIME() function: returns the current time.*/
SELECT CURTIME() AS CurrentTime;

/*CURRENT_TIME() function: synonym of CURTIME().*/
SELECT CURRENT_TIME() AS CurrentTime2;

/*TIME() function: extracts the time part from a datetime.*/
SELECT TIME('2025-11-25 10:15:21') AS OnlyTime;

/*MICROSECOND() function: returns microseconds (0 to 999999).*/
SELECT MICROSECOND('10:15:21.123456') AS MicroSec;

/*TIME_TO_SEC() function: converts a time value to total seconds.*/
SELECT TIME_TO_SEC('01:02:03') AS TimeToSeconds;

/*SEC_TO_TIME() function: converts seconds into hh:mm:ss format.*/
SELECT SEC_TO_TIME(3723) AS SecondsToTime; -- 01:02:03

/*****************************************DATE & TIME MANIPULATION FUNCTIONS*************************************************************/

/*ADDDATE() and SUBDATE(): add or subtract days from a date.*/
SELECT ADDDATE('2025-11-25', INTERVAL 10 DAY) AS AddDate;
SELECT SUBDATE('2025-11-25', INTERVAL 10 DAY) AS SubDate;

/*ADDTIME() and SUBTIME(): add or subtract time intervals.*/
SELECT ADDTIME('10:00:00', '02:30:00') AS AddTime;
SELECT SUBTIME('10:00:00', '02:30:00') AS SubTime;

/*DATE_ADD() function: adds an interval to a date.*/
SELECT DATE_ADD('2025-11-25', INTERVAL 1 MONTH) AS DateAdd;

/*DATE_SUB() function: subtracts an interval from a date.*/
SELECT DATE_SUB('2025-11-25', INTERVAL 1 MONTH) AS DateSub;

/*TIMESTAMPADD() function: adds an interval to a timestamp.*/
SELECT TIMESTAMPADD(HOUR, 5, '2025-11-25 10:15:21') AS TimestampAdd;

/*TIMESTAMPDIFF() function: returns the difference between timestamps in any unit.*/
SELECT TIMESTAMPDIFF(DAY, '2025-11-01', '2025-11-25') AS DaysDiff;
SELECT TIMESTAMPDIFF(HOUR, '2025-11-25 10:00:00', '2025-11-25 15:00:00') AS HoursDiff;

/********************************************CURRENT DATE & TIME****************************************************************************/

/*CURDATE() function: returns the current date.*/
SELECT CURDATE() AS CurrentDate;

/*NOW() function: returns the current date and time.*/
SELECT NOW() AS Now;

/*SYSDATE(): similar to NOW() but evaluated at execution time.*/
SELECT SYSDATE() AS SysDate;

/*Difference between NOW() and SYSDATE()
NOW() returns the date and time at the moment the query starts.
SYSDATE() returns the actual system date and time at the moment it is executed inside the query.*/
SELECT SLEEP(3), NOW(), SYSDATE();

/*UTC_DATE() and UTC_TIME(): date and time in UTC.*/
SELECT UTC_DATE() AS UtcDate;
SELECT UTC_TIME() AS UtcTime;

/*UTC_TIMESTAMP(): datetime in UTC.*/
SELECT UTC_TIMESTAMP() AS UtcTimestamp;

/********************************************CONVERSION FUNCTIONS****************************************************************************/

/*STR_TO_DATE(): converts a string to a date using a format mask.*/
SELECT STR_TO_DATE('25/11/2025', '%d/%m/%Y') AS StrToDate;

/*DATE_FORMAT(): formats a date into a custom string.*/
SELECT DATE_FORMAT('2025-11-25', '%W %d %M %Y') AS DateFormat;

/*TIME_FORMAT(): formats a time value.*/
SELECT TIME_FORMAT('15:13:46', '%h:%i %p') AS TimeFormat;
