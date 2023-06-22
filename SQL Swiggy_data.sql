CREATE DATABASE swiggy;

USE swiggy;

SELECT * FROM swiggydata;

/*SET 1- EASY LEVEL QUESTIONS*/

/*Q.1 How many restaurants are there*/

SELECT COUNT(`restaurant name`) AS No_of_restaurants
FROM swiggydata;

/*Q.2 How many cities are there?*/
SELECT COUNT(Distinct(city)) AS No_of_cities
FROM swiggydata;

/*Q.3 Name all the cuisines available in the restaurant*/
SELECT Distinct(type) AS Cuisines
FROM swiggydata;

/*Q.4 Name the different cities where swiggy restaurants are there*/
SELECT DISTINCT(city)  AS cities
FROM swiggydata;

/*Q.5 How many veg restaurants are there in city Delhi*/

SELECT  city,category,count(*) as total
FROM swiggydata
WHERE city = 'Delhi' AND category = 'Veg';

/*Q.6 Help Yash to find out the veg restaurants in city Mumbai with ratings greater than 4*/
SELECT `restaurant name`, ratings, category
FROM swiggydata
WHERE city = 'Mumbai' AND category = 'Veg' AND ratings>4;

/*Q.7 Find the Ghaziabad restaurants having cost of 2 greater than 400 in each city*/

SELECT  `restaurant name`,`Cost for 2`
FROM swiggydata
WHERE `Cost for 2`>400 AND city ='Ghaziabad';

/*Q.8 Mr.Mehta is looking for a restaurant in Lucknow which provides nonveg cuisines. Help him choose the best restaurant*/
SELECT `restaurant name`, ratings, category
FROM swiggydata
WHERE city = 'Lucknow' AND category = 'Non-Veg' AND ratings>4;

/*SET 2---- MODERATE LEVEL QUESTIONS*/

/*Q.9 Find max rating restaurant in each city*/

SELECT city,`restaurant name`, MAX(ratings) as max
FROM swiggydata
GROUP BY city;

/*Can we use aggregate functions as window functions--Definitely Yes
--Using Aggregate function as Window Function by using over() clause
-- Without window function, SQL will reduce the no of records.-- By using MAX as an window function, 
SQL will not reduce records but the result will be shown corresponding to each record*/

SELECT s.*, MAX(ratings) OVER(PARTITION BY city) AS Maxratings
FROM swiggydata s;

/*Q-10) Help Swiggy in identifying the cities with poor Restaurant ratings*/
SELECT `restaurant name`, city,ratings
FROM swiggydata
WHERE ratings<3.3
GROUP BY city;

/*Q.11 Find highest rating restaurant in each city by highest cost of 2 */

SELECT city, max(ratings) as highest_rating, max(`Cost for 2`) as highcost
FROM swiggydata
GROUP BY city;

/*Q.12 Mr. Singh who lives in Ghaziabad is going to have a family dinner so help him to find the restaurant with rating not less than 4 in each city 
by low cost rating */

SELECT `Restaurant Name`, city, ratings, `Cost Rating`
FROM swiggydata
WHERE `Cost Rating` = 'Low' AND Ratings >=4 AND city = 'Ghaziabad';

/*Q.13 Find the restaurants having Chinese,Italian cuisines in each city ordered alphabetically*/

SELECT city, `restaurant name`,Type
FROM swiggydata 
WHERE Type IN ('Chinese','Italian')
ORDER BY city;

/*Q.14 Find the restaurants starts with 'R'*/

SELECT `restaurant name`
FROM swiggydata
WHERE  `restaurant name` LIKE 'R%';

/*Q.15 Find the restaurants NOT starts with 'H'*/

SELECT `restaurant name`
FROM swiggydata
WHERE  `restaurant name` NOT LIKE 'H%';


/*SET 3- HIGH LEVEL QUESTIONS*/
       
/*Q-16 Help Swiggy in identifying those cities which have atleast 3 restaurants with ratings >= 4
  In case there are two cities with the same result, sort them in alphabetical order.*/
  
  SELECT city,COUNT( `restaurant name`) as cnt,ratings
  FROM swiggydata
  WHERE Ratings >=4
  GROUP BY city
  HAVING cnt<=3
  ORDER BY city ;

/*Q.17 Find 2nd highest rating given to the restaurant-----Can be solve by 2 methods*/

/*Method-1*/
SELECT MAX(ratings)
FROM swiggydata
WHERE ratings < (SELECT MAX(ratings)
                 FROM swiggydata
                );
                
 /*Method-2*/               
SELECT MAX(ratings)
FROM swiggydata
WHERE ratings NOT IN (SELECT MAX(ratings)
                      FROM swiggydata);
                      

/*Q.18 Fetch the top 3 restaurants in each city with the corresponding max ratings.*/

SELECT * FROM 
              (SELECT s.* ,rank() over(partition by city order by ratings desc) as rk
               FROM swiggydata s) as tp
			   WHERE tp.rk <4;

/*Q.19 Group the restaurants based on ratings into: 
Excellent, Good,Average and Poor 
Then, find the number of restaurants in each category.----Using CTE*/

WITH cte AS 
    (SELECT `restaurant name`, ratings,
     CASE
        WHEN ratings >=4.5 THEN 'Excellent'
        WHEN ratings >=4 THEN 'Good'
        WHEN ratings >=3 THEN 'Average'
        ELSE 'Poor'
        END AS Status
 FROM swiggydata 
 ORDER BY ratings DESC)
 SELECT  COUNT(`restaurant name`), status
 FROM cte
 GROUP BY Status;
 
 
    



