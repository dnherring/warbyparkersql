 /*Step 1*/
SELECT *
FROM survey
LIMIT 10;

/*Step 2*/
SELECT question, COUNT(DISTINCT user_id)
FROM survey
GROUP BY 1; 

/*Step 4*/
SELECT *
FROM quiz
LIMIT 5;

SELECT *
FROM home_try_on
LIMIT 5;

SELECT *
FROM purchase
LIMIT 5;
 
/*Step 5*/
WITH funnel AS(
SELECT DISTINCT q.user_id,
   h.user_id IS NOT NULL AS 'is_home_try_on',
   h.number_of_pairs,
   p.user_id IS NOT NULL AS 'is_purchase'
FROM quiz AS 'q'
LEFT JOIN home_try_on AS 'h'
   ON q.user_id = h.user_id
LEFT JOIN purchase AS 'p'
   ON p.user_id = q.user_id)
SELECT *
FROM funnel
LIMIT 10;

/*Step 6*/
WITH funnel AS(
SELECT DISTINCT q.user_id,
   h.user_id IS NOT NULL AS 'is_home_try_on',
   h.number_of_pairs,
   p.user_id IS NOT NULL AS 'is_purchase'
FROM quiz AS 'q'
LEFT JOIN home_try_on AS 'h'
   ON q.user_id = h.user_id
LEFT JOIN purchase AS 'p'
   ON p.user_id = q.user_id)
   SELECT COUNT(*) AS 'Number of Users',
   SUM(is_home_try_on) AS 'Try On',
   SUM(is_purchase) AS 'Number of Purchase',
   100.0 * SUM(is_home_try_on)/COUNT(user_id) AS '% of Home Try On',
   100.0 * SUM(is_purchase)/SUM(is_home_try_on) AS '% Checkout to Purchase'
   From funnel;

 /*Step 7*/
/*Determining the Most Common Style*/
SELECT style, COUNT(style) AS 'Number of Style'
FROM quiz
GROUP BY style
ORDER BY 2 DESC;

/*Determining the Most Common Model*/
SELECT product_id, style, model_name, color, price, COUNT(product_id) AS 'Total Purchased'
FROM purchase
GROUP BY 3
ORDER BY 6 DESC
LIMIT 3;

/*Determining the Most Common Color*/
SELECT product_id, style, model_name, color, price, COUNT(color) AS 'Total of Color'
FROM purchase
GROUP BY 4
ORDER BY 6 DESC
LIMIT 3;

/*A/B Split*/
/*Purchased*/
WITH funnel AS (
  SELECT DISTINCT q.user_id,
 CASE
  WHEN h.user_id IS NOT NULL 
      THEN 'True'
      ELSE 'False'
  END AS 'is_home_try_on',
 h.number_of_pairs,
 CASE
  WHEN p.user_id IS NOT NULL 
      THEN 'True'
      ELSE 'False'
  END AS 'is_purchase'
FROM quiz AS 'q'
LEFT JOIN home_try_on AS 'h'
   ON q.user_id = h.user_id
LEFT JOIN purchase AS 'p'
   ON p.user_id = q.user_id)
   
SELECT number_of_pairs AS 'Number of Pairs', COUNT(is_purchase) AS ' Total Number of Purchased Pairs'
FROM funnel
WHERE is_purchase = 'True'
GROUP BY number_of_pairs;

/*Not Purchased*/
WITH funnel AS (
  SELECT DISTINCT q.user_id,
 CASE
  WHEN h.user_id IS NOT NULL 
      THEN 'True'
      ELSE 'False'
  END AS 'is_home_try_on',
 h.number_of_pairs,
 CASE
  WHEN p.user_id IS NOT NULL 
      THEN 'True'
      ELSE 'False'
  END AS 'is_purchase'
FROM quiz AS 'q'
LEFT JOIN home_try_on AS 'h'
   ON q.user_id = h.user_id
LEFT JOIN purchase AS 'p'
   ON p.user_id = q.user_id)
   
SELECT number_of_pairs AS 'Number of Pairs', COUNT(is_purchase) AS ' Total Number of Not Purchased Pairs'
FROM funnel
WHERE is_purchase = 'False'
GROUP BY number_of_pairs;