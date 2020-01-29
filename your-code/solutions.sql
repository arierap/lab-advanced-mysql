-- MYSQL ADVANCED QUERIES --

-- Challenge 1 -- Most Profiting Authors TOP3

# Step 0 . Defining the database that we will be using:

USE publications;

# 1. Calculate the royalty of each sale for each author and 
# the advance for each author and publication.
SELECT 
titles.title_id AS Title_ID,
titleauthor.au_id AS Author_ID,
(titles.advance * titleauthor.royaltyper / 100) AS Advance,
(titles.price * sales.qty * titles.royalty / 100 * titleauthor.royaltyper / 100) AS Sales_Royalty
## 1.A. We would need to JOIN info including all the relevant into coming from 
# the tables titles, titlesauthor and sales
FROM titles
JOIN titleauthor ON titles.title_id = titleauthor.title_id
JOIN sales ON titles.title_id = sales.title_id;



# 2. Using the output from Step 1 as a subquery, 
# aggregate the total royalties for each title and author.

SELECT Title_ID, Author_ID, SUM(Sales_Royalty) AS Aggregate_royalties 
FROM 
(
	SELECT 
	titles.title_id AS Title_ID,
	titleauthor.au_id AS Author_ID,
	(titles.advance * titleauthor.royaltyper / 100) AS Advance,
	(titles.price * sales.qty * titles.royalty / 100 * titleauthor.royaltyper / 100) AS Sales_Royalty
	FROM titles
	JOIN titleauthor ON titles.title_id = titleauthor.title_id
	JOIN sales ON titles.title_id = sales.title_id
) AS Query_1
GROUP BY Title_ID, Author_ID
ORDER BY Aggregate_royalties DESC
;

# 3. Using the output from Step 2 as a subquery, calculate the total 
# profits of each author by aggregating the advances and total royalties of each title.

	# QUERY 2 and QUERY 2.2
SELECT Author_ID, (Aggregate_royalties + Aggregate_advances) AS Profit
FROM
	(SELECT Title_ID, Author_ID, SUM(Sales_Royalty) AS Aggregate_royalties, SUM(Advance) AS Aggregate_advances
	FROM 
	(
		SELECT 
		titles.title_id AS Title_ID,
		titleauthor.au_id AS Author_ID,
		(titles.advance * titleauthor.royaltyper / 100) AS Advance,
		(titles.price * sales.qty * titles.royalty / 100 * titleauthor.royaltyper / 100) AS Sales_Royalty
		FROM titles
		JOIN titleauthor ON titles.title_id = titleauthor.title_id
		JOIN sales ON titles.title_id = sales.title_id
	) AS Query_1
	GROUP BY Title_ID, Author_ID
	ORDER BY Aggregate_royalties DESC) AS Query_2
GROUP BY Profit, Author_ID
ORDER BY Profit DESC
;

# Challenge 2

CREATE TEMPORARY TABLE temp_table
	SELECT Title_ID, Author_ID, SUM(Sales_Royalty) AS Aggregate_royalties 
	FROM 
	(
		SELECT 
		titles.title_id AS Title_ID,
		titleauthor.au_id AS Author_ID,
		(titles.advance * titleauthor.royaltyper / 100) AS Advance,
		(titles.price * sales.qty * titles.royalty / 100 * titleauthor.royaltyper / 100) AS Sales_Royalty
		FROM titles
		JOIN titleauthor ON titles.title_id = titleauthor.title_id
		JOIN sales ON titles.title_id = sales.title_id
	) AS Query_1
	GROUP BY Title_ID, Author_ID
	ORDER BY Aggregate_royalties DESC
	;

# Challenge 3

CREATE TABLE most_profiting_authors
SELECT Author_ID, (Aggregate_royalties + Aggregate_advances) AS Profit
FROM
	(SELECT Title_ID, Author_ID, SUM(Sales_Royalty) AS Aggregate_royalties, SUM(Advance) AS Aggregate_advances
	FROM 
	(
		SELECT 
		titles.title_id AS Title_ID,
		titleauthor.au_id AS Author_ID,
		(titles.advance * titleauthor.royaltyper / 100) AS Advance,
		(titles.price * sales.qty * titles.royalty / 100 * titleauthor.royaltyper / 100) AS Sales_Royalty
		FROM titles
		JOIN titleauthor ON titles.title_id = titleauthor.title_id
		JOIN sales ON titles.title_id = sales.title_id
	) AS Query_1
	GROUP BY Title_ID, Author_ID
	ORDER BY Aggregate_royalties DESC) AS Query_2
GROUP BY Profit, Author_ID
ORDER BY Profit DESC
;

