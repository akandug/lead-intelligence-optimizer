SELECT * FROM consulting.cloudflow_leads_data;

select * from lead_activity;
select * from lead_outcomes;
select * from lead_profiles;

#firmographic analysis
SELECT 
    industry,
    company_size,
    job_seniority,
    COUNT(lead_id) AS total_leads,
    SUM(is_converted) AS total_conversions,
    ROUND((SUM(is_converted) / COUNT(lead_id)) * 100, 2) AS conversion_rate_pct
FROM cloudflow_leads_data
GROUP BY industry, company_size,job_seniority
ORDER BY conversion_rate_pct DESC;


#intent Analysis
SELECT 
    lead_source,
    COUNT(lead_id) AS total_leads,
    ROUND(AVG(pricing_page_views), 2) AS avg_pricing_views,
    ROUND(AVG(content_downloads), 2) AS avg_downloads,
    ROUND(AVG(is_converted) * 100, 2) AS conversion_rate_pct
FROM cloudflow_leads_data
GROUP BY lead_source
ORDER BY conversion_rate_pct DESC;
#That is a perfect real-world insight. Webinars often have high conversion rates because they require a "time commitment," 
#which filters for serious buyers. The fact that they have the second-highest pricing page views suggests that after watching the webinar,
# they are moving straight to the "How much does this cost?" phase.



#Behavioral Patterns
  SELECT 
    CASE 
        WHEN velocity_score >= 2.5 THEN 'High (Hot)'
        WHEN velocity_score >= 1.5 THEN 'Medium (Warm)'
        ELSE 'Low (Cold)'
    END AS lead_temp,
    COUNT(lead_id) AS total_leads,
    SUM(is_converted) AS total_conversions,
    ROUND(AVG(is_converted) * 100, 2) AS conv_rate_pct,
    ROUND(AVG(days_since_last_action), 1) AS avg_days_since_active
FROM cloudflow_leads_data
GROUP BY 1
ORDER BY conv_rate_pct DESC;

#The data shows a clear, logical trend: "Hot" leads convert at more than double the rate of "Cold" leads (6.47% vs 2.97%). 
#This is the "Smoking Gun" for your project because it proves that behavior—not just company name or size—is a massive predictor of revenue.
#Interestingly, your avg_days_since_active is almost identical across all three groups (~21-22 days). This is a huge insight for an interviewer. 
#It means that "Recency" (how long ago they visited) isn't what makes them a hot lead; it's the Intensity (the velocity of their actions)
# while they are on the site.


# The interaction effect
WITH profile_numbered AS ( 
    -- We create the row_id here inside 'profile_numbered'
    SELECT *, ROW_NUMBER() OVER (ORDER BY (SELECT NULL)) as row_id 
    FROM cloudflow_leads_data 
), 
target_numbered AS ( 
    SELECT is_converted, ROW_NUMBER() OVER (ORDER BY (SELECT NULL)) as row_id 
    FROM lead_outcomes 
) 
SELECT 
    p.job_seniority, 
    CASE 
        WHEN p.velocity_score >= 2.5 THEN 'High (Hot)' 
        ELSE 'Low/Med (Not Hot)' 
    END AS behavioral_temp, 
    COUNT(p.row_id) AS total_leads, 
    ROUND(AVG(t.is_converted) * 100, 2) AS conv_rate_pct 
FROM profile_numbered p  -- Changed this to use the numbered table
JOIN target_numbered t ON p.row_id = t.row_id 
GROUP BY 1, 2 
ORDER BY job_seniority, behavioral_temp;


#These results are fascinating because they completely flip the script on our previous assumption!
#In our data, Job Seniority is the dominant predictor, not just behavior. Look at the numbers:
#"Cold" Directors (11.21%) actually convert at a much higher rate than "Hot" Managers (1.08%).
#In fact, a Director who isn't even showing "Hot" behavior is 10x more likely to buy than a "Hot" Entry-level lead.


#create table master_table as
create table master_table as
WITH p AS (
    SELECT *, ROW_NUMBER() OVER (ORDER BY (SELECT NULL)) AS id
    FROM cloudflow_leads_data
),
t AS (
    SELECT is_converted, ROW_NUMBER() OVER (ORDER BY (SELECT NULL)) AS id
    FROM lead_outcomes
)
SELECT 
    p.*
    FROM p 
JOIN t 
ON p.id = t.id;

select* from master_table;

create database project;

SELECT 
    industry, 
    company_size, 
    job_seniority, 
    COUNT(lead_id) AS total_leads, 
    SUM(is_converted) AS total_conversions, 
    ROUND((SUM(is_converted) / COUNT(lead_id)) * 100, 2) AS conversion_rate_pct,
    AVG(days_since_last_action) AS avg_days_since_action -- Added aggregate
FROM cloudflow_leads_data 
GROUP BY industry, company_size, job_seniority 
ORDER BY conversion_rate_pct DESC;


SELECT 
    *, -- Keeps all original columns like days_since_last_action
    ROUND(
        (SUM(is_converted) OVER(PARTITION BY industry, company_size, job_seniority) * 100.0) / 
        COUNT(lead_id) OVER(PARTITION BY industry, company_size, job_seniority), 
    2) AS segment_conversion_rate_pct
FROM cloudflow_leads_data
ORDER BY lead_id;


