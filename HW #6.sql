with CTE_combined_data as (
		select 
		fabd.ad_date 
		, fc.campaign_name
		, fa.adset_name
		, COALESCE (fabd.spend, 0) spend
		, COALESCE (fabd.impressions, 0) impressions
		, COALESCE (fabd.reach, 0) reach
		, COALESCE (fabd.clicks,0) clicks
		, COALESCE (fabd.leads,0) leads
		, COALESCE (fabd.value,0) value
		, fabd.url_parameters
		, 'facebook' media_source
	from facebook_ads_basic_daily fabd 
left join facebook_campaign fc on fc.campaign_id = fabd.campaign_id 
left join facebook_adset fa on fa.adset_id = fabd.adset_id 
union all 
	select
	      gabd.ad_date
		, gabd.campaign_name
		, gabd.adset_name
		, COALESCE (gabd.spend, 0) spend
		, COALESCE (gabd.impressions, 0) impressions
		, COALESCE (gabd.reach, 0) reach
		, COALESCE (gabd.clicks, 0) clicks
		, COALESCE (gabd.leads, 0) leads
		, COALESCE (gabd.value, 0) value
		, gabd.url_parameters
		, 'google' media_source
	from google_ads_basic_daily gabd
	)
	select
	ad_date
	, campaign_name
	, case 
		when lower (substring (url_parameters, 'utm_campaign=([^&#$]+)')) = 'nan' then null
		else lower (substring (url_parameters, 'utm_campaign=([^&#$]+)'))
	end utm_campaign
	, sum(spend) total_spend
	, sum (impressions) total_impressions
	, sum (clicks) total_clicks
	, sum (value) total_value
	, case 
		when sum (impressions) > 0
		then round ((sum (clicks) * 1.00 / sum(impressions)) * 100, 2)
		end CTR
	, case 
		when sum (clicks) > 0
		then round (1.00 * sum (spend) / sum (clicks), 2)
		end CPC
	, case 
		when sum(impressions) > 0
		then round ((1.00 * sum (spend) / sum (impressions)) * 1000, 2)
		end CPM
	, case 
		when sum (spend) > 0
		then round (((1.00 * SUM(value) - SUM(spend)) / SUM(spend))*100, 2)
		end ROMI
	from CTE_combined_data
	group by ad_date
, campaign_name
, utm_campaign
order by utm_campaign