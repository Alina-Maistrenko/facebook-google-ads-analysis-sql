# Facebook and Google Ads Campaign Analysis (SQL)

This SQL code helps to analyze ad campaigns from Facebook and Google, and create reports to see how well they're doing.

## What it does

The code combines data from Facebook and Google ad tables, looks at UTM parameters, and calculates important numbers to understand how the ads are performing.

## Tables

* `facebook_ads_basic_daily`: Basic info about Facebook ad campaigns.
* `facebook_campaign`: Info about Facebook campaigns.
* `facebook_adset`: Info about Facebook ad sets.
* `google_ads_basic_daily`: Basic info about Google ad campaigns.

## Metrics

* `ad_date`: The date the ad was shown.
* `campaign_name`: The name of the campaign.
* `utm_campaign`: The campaign name from the ad's URL.
* `total_spend`: How much money was spent.
* `total_impressions`: How many times the ad was shown.
* `total_clicks`: How many times people clicked on the ad.
* `total_value`: The total value of conversions (e.g., sales).
* `CTR (Click-Through Rate)`: How often people clicked on the ad after seeing it.
* `CPC (Cost Per Click)`: How much each click cost.
* `CPM (Cost Per Mille)`: How much it cost to show the ad 1000 times.
* `ROMI (Return on Marketing Investment)`: How much money was made compared to how much was spent.

## How to use

1. Connect to the database (PostgreSQL).
2. Run the SQL query shown above.
3. Use the results to make reports or dashboards to analyze the ad campaigns.

## How the code works

1. **CTE `CTE_combined_data`:**
    * Takes data from `facebook_ads_basic_daily` and `google_ads_basic_daily` tables and puts them together.
    * Changes `NULL` values to 0 using `COALESCE`.
    * Adds a `media_source` column to show if the data is from Facebook or Google.
2. **Main query:**
    * Selects the ad date, campaign name, and UTM campaign.
    * Cleans up the `utm_campaign` values, changing 'nan' to `NULL` and making them lowercase.
    * Adds up the total spend, impressions, clicks, and value.
    * Calculates CTR, CPC, CPM, and ROMI, using `CASE` to avoid dividing by zero.
    * Groups the results by ad date, campaign name, and UTM campaign.
    * Sorts the results by UTM campaign.
