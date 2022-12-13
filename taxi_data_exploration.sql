--previewing data prior to beginning analysis
select
	*
from public.yellow_taxi_data
limit 100;

--calculating the average taxi ride cost (using total_amount) per day, ordered by recency
select
	tpep_pickup_datetime::date as date,
	avg(total_amount) as avg_cost
from public.yellow_taxi_data
group by 1
order by 1 desc;

--which date has the highest average taxi ride cost?
select
	date,
	max(avg_cost) as highest_avg_cost
from (
	select
		tpep_pickup_datetime::date as date,
		avg(total_amount) as avg_cost
	from public.yellow_taxi_data
	group by 1
	order by 1 desc
	) as cost
group by 1
order by 2 desc
limit 1;

--calculating the average length on a taxi ride per day for records where pickup and dropoff occurs on the same day
select
	tpep_pickup_datetime::date as date,
	avg(tpep_dropoff_datetime::time - tpep_pickup_datetime::time) as avg_duration
from public.yellow_taxi_data
where tpep_pickup_datetime::date = tpep_dropoff_datetime::date
group by 1
order by 2 desc;

--what is the average number of passengers in a taxi for rides that are longer than 20 minutes?
select
	avg(passenger_count)
from public.yellow_taxi_data
where (tpep_dropoff_datetime::time - tpep_pickup_datetime::time) > '00:20:00';