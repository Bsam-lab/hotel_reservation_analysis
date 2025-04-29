-- rename the title
rename table `hotel reservation dataset` to hotel_reservation_dataset;

-- make the date in right format
-- change the - in date
update hotel_reservation_dataset set arrival_date= replace(arrival_date,'-','/');
SET SQL_SAFE_UPDATES = 0;
update hotel_reservation_dataset set arrival_date = str_to_date(arrival_date,'%d/%m/%YYYY');
alter table hotel_reservation_dataset modify column arrival_date date;
select * from hotel_reservation_dataset;

-- 1. What is the total number of reservations in the dataset?
select count(booking_id) as total_number_of_reservation from hotel_reservation_dataset;

-- 2. Which meal plan is the most popular among guests?  
 select type_of_meal_plan,count(type_of_meal_plan) as count from hotel_reservation_dataset group by type_of_meal_plan order by count desc limit 1;
 
-- 3. What is the average price per room for reservations involving children?
 select avg_price_per_room,no_of_children from hotel_reservation_dataset where no_of_children > 0;
 
-- 4. How many reservations were made for the year 2018
select year(arrival_date) as year, count(booking_id) as number_of_reservation from hotel_reservation_dataset where year(arrival_date)='2018' group by year;
select * from hotel_reservation_dataset;

-- 5. What is the most commonly booked room type?
select room_type_reserved,count(booking_id) as count from hotel_reservation_dataset group by room_type_reserved order by count desc limit 1;

-- 6. How many reservations fall on a weekend nights (no_of_weekend_nights > 0)? 
select count(no_of_weekend_nights) as count from hotel_reservation_dataset where no_of_weekend_nights >0;

-- 7. What is the highest and lowest lead time for reservations?
select max(lead_time) as highest,min(lead_time) as lowest from hotel_reservation_dataset;

select * from hotel_reservation_dataset;

-- 8. What is the most common market segment type for reservations?
select market_segment_type, count(market_segment_type) as count from hotel_reservation_dataset group by market_segment_type order by count desc limit 1;

-- 9. How many reservations have a booking status of "Confirmed"?
select booking_status, count(booking_status) as count from hotel_reservation_dataset where booking_status='not_canceled' group by booking_status;

select * from hotel_reservation_dataset;

-- 10. What is the total number of adults and children across all reservations?
select sum(no_of_adults) as adult_number, sum(no_of_children) as children_number from hotel_reservation_dataset;

-- 11. What is the average number of weekend nights for reservations involving children? 
select round(avg(no_of_weekend_nights),2) as avg from hotel_reservation_dataset where no_of_children > 0;

-- 12. How many reservations were made in each month of the year?

select year(arrival_date), month(arrival_date) as month_number,monthname(arrival_date) as month, count(*) as reservation_made from hotel_reservation_dataset group by 1,2,3 order by 1,2 asc;

-- 13. What is the average number of nights (both weekend and weekday) spent by guests for each room type?
select room_type_reserved,avg(no_of_weekend_nights) as avg_weekend,avg(no_of_week_nights) as avg_week from hotel_reservation_dataset group by room_type_reserved;
  
  select * from hotel_reservation_dataset;
  
-- 14. For reservations involving children, what is the most common room type, and what is the average price for that room type?
select room_type_reserved as most_common, count(room_type_reserved)as number,round(avg(avg_price_per_room)) as avg_price from hotel_reservation_dataset where 
no_of_children >0 group by 1 order by 2 desc limit 1;

-- 15. Find the market segment type that generates the highest average price per room.
select market_segment_type,avg_price_per_room from hotel_reservation_dataset order by avg_price_per_room desc limit 1;