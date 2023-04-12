--report to generate top 5 artist
WITH ranked_artists AS (
    SELECT u.userid AS artist_id, u.username AS artist_name, COUNT(DISTINCT a.artworkid) AS total_artworks_sold,
           DENSE_RANK() OVER (ORDER BY COUNT(DISTINCT a.artworkid) DESC) AS artist_rank
    FROM users u
    JOIN user_role ur ON u.roleid = ur.roleid
    JOIN artwork a ON u.userid = a.userid
    WHERE a.Status = 'Sold' AND ur.roleid = 2
    GROUP BY u.username, ur.rolename, u.userid
)
SELECT total_artworks_sold, artist_name, artist_id
FROM ranked_artists;
 
--reports to generate trending artcategories
WITH trending_artcategory AS (
    SELECT ac.artcategory as artcategory_name, COUNT(a.artcategoryid) AS num_sold,
        DENSE_RANK() OVER (ORDER BY COUNT(DISTINCT a.artworkid) DESC) AS artcategory_rank
    FROM artwork a
    LEFT JOIN art_category ac ON a.artcategoryid = ac.artcategoryid 
    where a.status = 'Sold'
    GROUP BY a.artcategoryid,ac.artcategory
)
select artcategory_name, artcategory_rank, num_sold
from trending_artcategory
where artcategory_rank <= 3;

--Report for revenue generated by artist
SELECT TRUNC(o.OrderDateTime, 'MONTH') AS Month, SUM(o.TotalAmount) AS Revenue
FROM ORDERS o
JOIN ORDER_ITEMS oi ON o.OrderID = oi.OrderID
JOIN ARTWORK a ON oi.OrderItemsID = a.OrderItemsID
WHERE a.UserID = 16
AND EXTRACT(YEAR FROM o.OrderDateTime) = 2022
GROUP BY TRUNC(o.OrderDateTime, 'MONTH')
ORDER BY Month ASC;

