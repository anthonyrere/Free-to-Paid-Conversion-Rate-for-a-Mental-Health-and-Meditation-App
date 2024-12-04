SELECT *
FROM student_info;

SELECT *
FROM student_engagement;

SELECT *
FROM student_purchases;

SELECT i.student_id, i.date_registered, MIN(e.date_watched) AS first_date_watched
, MIN(p.date_purchased) AS first_date_purchased, DATEDIFF(MIN(e.date_watched), i.date_registered) AS date_diff_reg_watch
, DATEDIFF(MIN(p.date_purchased), MIN(e.date_watched)) AS date_diff_watch_purch
FROM student_info i
JOIN student_engagement e
ON i.student_id = e.student_id
LEFT JOIN student_purchases p
ON i.student_id = p.student_id
GROUP BY i.student_id
HAVING first_date_purchased IS NULL
OR first_date_watched <= first_date_purchased;

WITH Duplicate_cte AS
(
SELECT i.student_id, i.date_registered, MIN(e.date_watched) AS first_date_watched
, MIN(p.date_purchased) AS first_date_purchased, DATEDIFF(MIN(e.date_watched), i.date_registered) AS date_diff_reg_watch
, DATEDIFF(MIN(p.date_purchased), MIN(e.date_watched)) AS date_diff_watch_purch
FROM student_info i
JOIN student_engagement e
ON i.student_id = e.student_id
LEFT JOIN student_purchases p
ON i.student_id = p.student_id
GROUP BY i.student_id
HAVING first_date_purchased IS NULL
OR first_date_watched <= first_date_purchased
) 
select 
round(count(first_date_purchased) / count(first_date_watched), 2)*100 AS conversion_rate 
, round(sum(date_diff_reg_watch) / count(date_diff_reg_watch)) AS av_reg_watch
, round(sum(date_diff_watch_purch) / count(date_diff_watch_purch)) AS av_watch_purch
FROM Duplicate_cte;













