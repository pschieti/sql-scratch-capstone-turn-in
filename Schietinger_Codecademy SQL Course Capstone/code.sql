--- Question 1a- campaigns

SELECT COUNT(DISTINCT(utm_campaign)) AS 'num_campaigns'
FROM page_visits;

--- Question 1b- sources

SELECT COUNT(DISTINCT(utm_source)) AS 'num_sources'
FROM page_visits;

---Question 1c- how do campagins and sources related

SELECT utm_campaign, utm_source
FROM page_visits
GROUP BY utm_campaign;

--- Question 2a- pages on website

SELECT DISTINCT(page_name)
FROM page_visits;

---Question 3a- How many first touches per campaign?

WITH first_touch AS (
    SELECT user_id,
        MIN(timestamp) AS first_touch_at
    FROM page_visits
    GROUP BY user_id),
ft_attr AS (
		SELECT ft.user_id,
    	ft.first_touch_at,
    	pv.utm_source,
			pv.utm_campaign
  	FROM first_touch AS ft
	 	JOIN page_visits AS pv
    	ON ft.user_id = pv.user_id
   	  AND ft.first_touch_at = pv.timestamp
  )
  SELECT ft_attr.utm_source as source, ft_attr.utm_campaign AS campagain, count(*) AS first_touches
  FROM ft_attr
  GROUP BY 1, 2
  ORDER BY 3 desc;

--- Question 4a- How many last touches per campaign?

WITH last_touch AS (
    SELECT user_id,
        MAX(timestamp) AS last_touch_at
    FROM page_visits
    GROUP BY user_id),
lt_attr AS (
		SELECT lt.user_id,
    	lt.last_touch_at,
    	pv.utm_source,
			pv.utm_campaign
  	FROM last_touch AS lt
	 	JOIN page_visits AS pv
    	ON lt.user_id = pv.user_id
   	  AND lt.last_touch_at = pv.timestamp
  )
  SELECT lt_attr.utm_source AS source, lt_attr.utm_campaign AS campagain, count(*) AS last_touches
  FROM lt_attr
  GROUP BY 1, 2
  ORDER BY 3 desc;

--- Question 5a- How many visitors make a purchase?

SELECT COUNT(DISTINCT(user_id)) AS num_purchases, page_name
FROM page_visits
WHERE page_name = '4 - purchase';

--- Question 6a- How many last touches on the purchase page is each campaign responsible for?


WITH last_touch AS (
    SELECT user_id, 
        MAX(timestamp) AS last_touch_at
    FROM page_visits
  	WHERE page_name = '4 - purchase'
    GROUP BY user_id),
lt_attr AS (
		SELECT lt.user_id,
    	lt.last_touch_at,
    	pv.utm_source,
			pv.utm_campaign,
  		pv.page_name
  	FROM last_touch AS lt
	 	JOIN page_visits AS pv
    	ON lt.user_id = pv.user_id
   	  AND lt.last_touch_at = pv.timestamp
  )
  SELECT lt_attr.utm_source AS source, lt_attr.utm_campaign AS campagain, count(*) AS purchases
  FROM lt_attr
  GROUP BY 1, 2
  ORDER BY 3 desc;