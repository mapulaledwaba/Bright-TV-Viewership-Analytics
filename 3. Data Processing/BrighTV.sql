select * from `brighttv2`.`default`.`viewership` limit 100;


select * from `brighttv2`.`default`.`user_profile` limit 100;



---There are 21 Channels
SELECT DISTINCT Channel2
FROM  `brighttv2`.`default`.`viewership`;


---The data was collected over a period of three months
SELECT MIN(RecordDate2) AS start_date,
       MAX(RecordDate2) AS end_date
FROM  `brighttv2`.`default`.`viewership`;
    


--We have 1000 users
SELECT COUNT(UserID) AS number_of_users
FROM  `brighttv2`.`default`.`viewership`;


---Converting from UTC to SA Time
SELECT RecordDate2,
       from_utc_timestamp(TO_TIMESTAMP(RecordDate2, 'yyyy/MM/dd HH:mm'), 'Africa/Johannesburg') AS SAst_timestamp
FROM `brighttv2`.`default`.`viewership`;



---Grouping by month name and day name
SELECT 
      from_utc_timestamp(TO_TIMESTAMP(RecordDate2, 'yyyy/MM/dd HH:mm'), 'Africa/Johannesburg') AS SAst_timestamp,
      Dayname(from_utc_timestamp(TO_TIMESTAMP(RecordDate2, 'yyyy/MM/dd HH:mm'), 'Africa/Johannesburg')) AS Day_name,
      Monthname(from_utc_timestamp(TO_TIMESTAMP(RecordDate2, 'yyyy/MM/dd HH:mm'), 'Africa/Johannesburg')) AS Month_name
FROM  `brighttv2`.`default`.`viewership`;



---Grouping into weekdays and weekends 
SELECT 
      from_utc_timestamp(TO_TIMESTAMP(RecordDate2, 'yyyy/MM/dd HH:mm'), 'Africa/Johannesburg') AS SAst_timestamp,
      CASE 
      WHEN  Dayname(from_utc_timestamp(TO_TIMESTAMP(RecordDate2, 'yyyy/MM/dd HH:mm'), 'Africa/Johannesburg')) IN ('Sat', 'Sun') THEN 'Weekend'
      ELSE 'Weekday' 
      END AS Day_classification
FROM   `brighttv2`.`default`.`viewership`;



---Grouping into viewing times
SELECT 
      from_utc_timestamp(TO_TIMESTAMP(RecordDate2, 'yyyy/MM/dd HH:mm'), 'Africa/Johannesburg') AS SAst_timestamp,
      CASE 
         WHEN date_format(from_utc_timestamp(TO_TIMESTAMP(RecordDate2, 'yyyy/MM/dd HH:mm'), 'Africa/Johannesburg'), 'HH:mm:ss') BETWEEN '05:00:00' AND '11:59:59' THEN 'morning viewers'
           WHEN date_format( from_utc_timestamp(TO_TIMESTAMP(RecordDate2, 'yyyy/MM/dd HH:mm'), 'Africa/Johannesburg'), 'HH:mm:ss') BETWEEN '12:00:00' AND '17:59:59' THEN 'Afternoon viewers'
           WHEN date_format( from_utc_timestamp(TO_TIMESTAMP(RecordDate2, 'yyyy/MM/dd HH:mm'), 'Africa/Johannesburg'), 'HH:mm:ss') BETWEEN '18:00:00' AND '23:59:59' THEN 'Evening viewers'
           WHEN date_format( from_utc_timestamp(TO_TIMESTAMP(RecordDate2, 'yyyy/MM/dd HH:mm'), 'Africa/Johannesburg'), 'HH:mm:ss') BETWEEN '00:00:00' AND '04:59:59' THEN 'Midnight viewers' 
           ELSE 'Other time'
           END AS Viewing_times
 FROM   `brighttv2`.`default`.`viewership`;
         


---I want to see the different races and provinces we have
SELECT DISTINCT Race
FROM   `brighttv2`.`default`.`user_profile`;
   

SELECT DISTINCT Province
FROM `brighttv2`.`default`.`user_profile`;


---JOINING THE TWO TABLES
SELECT *
FROM `brighttv2`.`default`.`viewership` AS V
LEFT JOIN  `brighttv2`.`default`.`user_profile` AS UP
ON V.UserID=UP.UserID;

---FULL OUTER JOIN
SELECT *
FROM `brighttv2`.`default`.`viewership` AS V
FULL OUTER JOIN  `brighttv2`.`default`.`user_profile` AS UP
ON V.UserID=UP.UserID;

---CHECKING FOR NULLS
SELECT Gender,
       Race,
       Age,
       Province
FROM    `brighttv2`.`default`.`user_profile`
WHERE Gender IS NULL
       OR Race IS NULL
       OR Age IS NULL
       OR Province IS NULL;


SELECT 
      IFNULL(Channel2, 'No_Channel') AS Channel2,
      IFNULL(Name, 'No_Name') AS Name,
      IFNULL(Surname, 'No_Surname') AS Surname,
      IFNULL(Gender, 'No_Gender') AS Gender,
      IFNULL(Race, 'No_Race') AS Race,
      IFNULL(Age, 0) AS Age,
      IFNULL(Province, 'No_Province') AS Province
FROM `brighttv2`.`default`.`viewership` AS V
FULL OUTER JOIN  `brighttv2`.`default`.`user_profile` AS UP
ON V.UserID=UP.UserID ;


SELECT 
     COALESCE(NULLIF(Race, 'None'), 'No race') AS Race,
     COALESCE(NULLIF(Gender, 'None'), 'No gender') AS Gender,
     COALESCE(NULLIF(Province, 'None'), 'No province') AS Province
FROM `brighttv2`.`default`.`user_profile` ;
 

 ---Age classification
 SELECT Age,
  CASE 
          WHEN Age< 13 THEN 'Child'
          WHEN Age BETWEEN 13 AND 19 THEN 'Teen'
          WHEN Age BETWEEN 20 AND 34 THEN 'Young Adult'
          WHEN Age BETWEEN 35 AND 54 THEN 'Middle aged'
          ELSE 'Senior'
          END AS Age_classification  
FROM `brighttv2`.`default`.`user_profile` ;
 

----FINAL CODE

SELECT 
      V.UserID,
      V.Channel2,
       date_format(V.Duration2, 'HH:mm:ss') AS Duration2,
      UP.Age,
---Removing none's
     COALESCE(NULLIF(UP.Race, 'None'), 'No race') AS Race,
     COALESCE(NULLIF(UP.Gender, 'None'), 'No gender') AS Gender,
     COALESCE(NULLIF(UP.Province, 'None'), 'No province') AS Province,
---Converting to SA Time
     from_utc_timestamp(TO_TIMESTAMP(RecordDate2, 'yyyy/MM/dd HH:mm'), 'Africa/Johannesburg') AS SAst_timestamp,
---Extracting day and month names     
      Dayname(from_utc_timestamp(TO_TIMESTAMP(RecordDate2, 'yyyy/MM/dd HH:mm'), 'Africa/Johannesburg')) AS Day_name,
      Monthname(from_utc_timestamp(TO_TIMESTAMP(RecordDate2, 'yyyy/MM/dd HH:mm'), 'Africa/Johannesburg')) AS Month_name,
---Grouping days into weekdays and weekends
      CASE 
      WHEN  Dayname(from_utc_timestamp(TO_TIMESTAMP(RecordDate2, 'yyyy/MM/dd HH:mm'), 'Africa/Johannesburg')) IN ('Sat', 'Sun') THEN 'Weekend'
      WHEN Dayname(from_utc_timestamp(TO_TIMESTAMP(RecordDate2, 'yyyy/MM/dd HH:mm'), 'Africa/Johannesburg')) IN ('Mon', 'Tue','Wed', 'Thu', 'Fri') THEN'Weekday' 
      END AS Day_classification,
---Grouping viewers into time buckets
        CASE 
         WHEN date_format(from_utc_timestamp(TO_TIMESTAMP(RecordDate2, 'yyyy/MM/dd HH:mm'), 'Africa/Johannesburg'), 'HH:mm:ss') BETWEEN '05:00:00' AND '11:59:59' THEN 'morning viewers'
           WHEN date_format( from_utc_timestamp(TO_TIMESTAMP(RecordDate2, 'yyyy/MM/dd HH:mm'), 'Africa/Johannesburg'), 'HH:mm:ss') BETWEEN '12:00:00' AND '17:59:59' THEN 'Afternoon viewers'
           WHEN date_format( from_utc_timestamp(TO_TIMESTAMP(RecordDate2, 'yyyy/MM/dd HH:mm'), 'Africa/Johannesburg'), 'HH:mm:ss') BETWEEN '18:00:00' AND '23:59:59' THEN 'Evening viewers'
           WHEN date_format( from_utc_timestamp(TO_TIMESTAMP(RecordDate2, 'yyyy/MM/dd HH:mm'), 'Africa/Johannesburg'), 'HH:mm:ss') BETWEEN '00:00:00' AND '04:59:59' THEN 'Midnight viewers' 
           END AS Viewing_times,
---Age classification
      CASE 
          WHEN Age=0 THEN 'No age'      
          WHEN Age BETWEEN 1 AND 13 THEN 'Child'
          WHEN Age BETWEEN 13 AND 19 THEN 'Teen'
          WHEN Age BETWEEN 20 AND 34 THEN 'Young Adult'
          WHEN Age BETWEEN 35 AND 54 THEN 'Middle aged'
          ELSE 'Senior'
          END AS Age_classification,
 ----Removing empty cells
 CASE 
    WHEN UP.Race IS NULL OR TRIM(UP.Race) = '' THEN 'Unknown'
    ELSE Race
END AS Race
                    
FROM `brighttv2`.`default`.`viewership` AS V
LEFT JOIN  `brighttv2`.`default`.`user_profile` AS UP
ON V.UserID=UP.UserID
WHERE V.UserID IS NOT NULL
     AND V.Channel2 IS NOT NULL
     AND V.Duration2 IS NOT NULL
     AND UP.Age IS NOT NULL
     AND UP.Race IS NOT NULL
     AND UP.Gender IS NOT NULL
     AND UP.Province IS NOT NULL;
