-- Exported from QuickDBD: https://www.quickdatabasediagrams.com/
-- Link to schema: https://app.quickdatabasediagrams.com/#/d/dlKkBe
-- NOTE! If you have used non-SQL datatypes in your design, you will have to change these here.


CREATE TABLE "campaign" (
    "cf_id" int   NOT NULL,
    "contact_id" int   NOT NULL,
    "company_name" varchar(100)   NOT NULL,
    "description" text   NOT NULL,
    "goal" numeric(10,2)   NOT NULL,
    "pledged" numeric(10,2)   NOT NULL,
    "outcome" varchar(50)   NOT NULL,
    "backers_count" int   NOT NULL,
    "country" varchar(10)   NOT NULL,
    "currency" varchar(10)   NOT NULL,
    "launch_date" date   NOT NULL,
    "end_date" date   NOT NULL,
    "category_id" varchar(10)   NOT NULL,
    "subcategory_id" varchar(10)   NOT NULL,
    CONSTRAINT "pk_campaign" PRIMARY KEY (
        "cf_id"
     )
);

CREATE TABLE "category" (
    "category_id" varchar(10)   NOT NULL,
    "category_name" varchar(50)   NOT NULL,
    CONSTRAINT "pk_category" PRIMARY KEY (
        "category_id"
     )
);

CREATE TABLE "subcategory" (
    "subcategory_id" varchar(10)   NOT NULL,
    "subcategory_name" varchar(50)   NOT NULL,
    CONSTRAINT "pk_subcategory" PRIMARY KEY (
        "subcategory_id"
     )
);

CREATE TABLE "contacts" (
    "contact_id" int   NOT NULL,
    "first_name" varchar(50)   NOT NULL,
    "last_name" varchar(50)   NOT NULL,
    "email" varchar(100)   NOT NULL,
    CONSTRAINT "pk_contacts" PRIMARY KEY (
        "contact_id"
     )
);

CREATE TABLE "backers" (
    "backer_id" varchar(10)   NOT NULL,
    "cf_id" int     NOT NULL,
	"first_name" varchar(50)   NOT NULL,
    "last_name" varchar(50)   NOT NULL,
    "email" varchar(100)   NOT NULL,
    CONSTRAINT "pk_backers" PRIMARY KEY (
        "backer_id"
     )
);

SELECT * FROM backers

ALTER TABLE "backers" ADD CONSTRAINT "fk_cf_id" FOREIGN KEY("cf_id")
REFERENCES "campaign" ("cf_id");

SELECT * FROM campaign
SELECT * FROM category
SELECT * FROM subcategory
SELECT * FROM contacts


ALTER TABLE "campaign" ADD CONSTRAINT "fk_campaign_contact_id" FOREIGN KEY("contact_id")
REFERENCES "contacts" ("contact_id");

ALTER TABLE "campaign" ADD CONSTRAINT "fk_campaign_category_id" FOREIGN KEY("category_id")
REFERENCES "category" ("category_id");

ALTER TABLE "campaign" ADD CONSTRAINT "fk_campaign_subcategory_id" FOREIGN KEY("subcategory_id")
REFERENCES "subcategory" ("subcategory_id");

SELECT * FROM campaign
SELECT * FROM category
SELECT * FROM subcategory
SELECT * FROM contacts

-- Challenge Bonus queries.
-- 1. (2.5 pts)
-- Retrieve all the number of backer_counts in descending order for each `cf_id` for the "live" campaigns. 
-- **** live is in "outcome" column of the campaign table
SELECT
	c.cf_id,
	c.backers_count
--INTO live_backers_count (nah don't need table - never ran it to create it)
FROM campaign AS c
WHERE c.outcome = ('live')
ORDER BY backers_count DESC;

-- 2. (2.5 pts)
-- Using the "backers" table confirm the results in the first query.
SELECT b.cf_id,
		COUNT(b.backer_id) AS "backers_count"
FROM backers AS b
INNER JOIN campaign AS c
ON b.cf_id = c.cf_id
WHERE c.outcome = 'live'
GROUP BY b.cf_id
ORDER BY "backers_count" DESC;

-- 3. (5 pts)
-- Create a table that has the first and last name, and email address of each contact.
-- and the amount left to reach the goal for all "live" projects in descending order. 
-- table called "email_contacts_remaining_goal_amount" - CONTACTS
--would we be subtracting pledged from goal for all live projects?
--left join on cf_id from backers and campaign and 'live_backers_count' created above?
SELECT con.first_name,
	con.last_name,
	con.email,
	c.goal - c.pledged AS "Remaining Goal Amount"
INTO email_contacts_remaining_goal_amount
FROM contacts AS con
LEFT JOIN campaign AS c
ON con.contact_id = c.contact_id
WHERE c.outcome = 'live'
ORDER BY "Remaining Goal Amount" DESC;

-- Check the table
SELECT * FROM email_contacts_remaining_goal_amount

-- 4. (5 pts)
-- Create a table, "email_backers_remaining_goal_amount" - BACKERS - that contains the email address (backers) of each backer in descending order, 
-- and has the first and last name of each backer (backers), the cf_id (backers or campaign - pk), (c)company name, (c)description, 
-- (campaign)end date of the campaign, and the remaining amount of the campaign goal as "Left of Goal". 
-- inner join on cf_id pk 
-- again subtract pledged from goal just name it different (from campaign table) 
-- based on example table in challenge looks like sorting by last name in descending, not email?

SELECT b.email,
	b.first_name,
	b.last_name,
	b.cf_id,
	c.company_name,
	c.description,
	c.end_date,
	c.goal - c.pledged AS "Left of Goal"
INTO email_backers_remaining_goal_amount
FROM backers AS b
INNER JOIN  campaign AS c
ON b.cf_id = c.cf_id
ORDER BY last_name;

-- Check the table
SELECT * FROM email_backers_remaining_goal_amount
