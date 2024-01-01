use ig_clone;
/*1.Create an ER diagram or draw a schema for the given database.*/


/*2. We want to reward the user who has been around the longest, Find the 5 oldest users.*/

SELECT * FROM users 
ORDER BY created_at  
LIMIT 5;

/*3. To target inactive users in an email ad campaign, find the users who have never posted a photo.*/

SELECT u.id,u.username FROM users u
WHERE u.id NOT IN (SELECT p.user_id FROM photos p  )
ORDER BY u.id;

/*4.Suppose you are running a contest to find out who got the most likes on a photo. Find out who won?*/
SELECT u.id,u.username,COUNT(*) AS like_counts FROM users u 
INNER JOIN likes l ON u.id=l.user_id
GROUP BY user_id
ORDER BY like_counts DESC
LIMIT 1;

/*5.The investors want to know how many times does the average user post.*/

SELECT COUNT(p.id) / COUNT(DISTINCT user_id) AS avg_posts_per_user FROM photos p;


/*6.A brand wants to know which hashtag to use on a post, and find the top 5 most used hashtags.*/
WITH most_popular_hashtags AS
(
SELECT  COUNT(tag_id) as top_used_hashtags FROM photo_tags GROUP BY tag_id 
ORDER BY top_used_hashtags DESC
)

SELECT * FROM most_popular_hashtags LIMIT 5;

/* 7.To find out if there are bots, find users who have liked every single photo on the site.*/

SELECT count(distinct photo_id ) from  likes;
WITH BOT AS(
SELECT l.user_id,COUNT(*) FROM  likes l 
GROUP BY l.user_id HAVING COUNT(*)=(SELECT count(distinct photo_id ) from  likes l)
ORDER BY COUNT(*) DESC
)
SELECT * FROM BOT;

/*8.Find the users who have created instagramid in may and select top 5 newest joinees from it?*/

DELIMITER //
CREATE PROCEDURE sp_top_joinees_monthwise(IN month_name varchar(20))
BEGIN
SELECT id as userid,username,created_at FROM users u
WHERE MONTHNAME(created_at)=month_name
ORDER BY created_at desc
LIMIT 5;
END//
DELIMITER ;

/*9.Can you help me find the users whose name starts with c and ends with any number and have posted the photos as well as liked the photos?*/
SELECT DISTINCT u.id,u.username FROM users u 
WHERE u.id in  (
				SELECT DISTINCT p.user_id FROM photos p INNER JOIN likes l on p.id=l.photo_id
                )
AND username regexp '^C.*[0-9]$';

/*10.Demonstrate the top 30 usernames to the company who have posted photos in the range of 3 to 5.*/
SELECT DISTINCT u.username from users u 
JOIN photos p on  u.id=p.user_id 
GROUP BY u.username
HAVING Count(p.id) between 3 and 5 
ORDER BY COUNT(p.id) DESC
LIMIT 30; 


