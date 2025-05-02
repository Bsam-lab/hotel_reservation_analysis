# Hotel Analysis
![dug-out-pool-hotel-poolside-1134176](https://github.com/user-attachments/assets/84ad952c-040c-4359-ba59-309e5f6ca430)

## Table of Contents
- [Introduction](#Introduction)
- [Dataset Overview](#Dataset-Overview)
- [Data Cleaning and Transformation](#Data-Cleaning-and-Transformation)
- [Data Exploration and Insight](#Data-Exploration-and-Insight)
- [Recommendation](#Recommendation)
- [Conclusion](#Conclusion)

### Introduction
The hospitality industry plays a vital role in global tourism and economic development, with hotels serving as a cornerstone of guest experience and service delivery. Conducting a hotel analysis is essential for understanding operational efficiency, market positioning, customer satisfaction, and financial performance. This analysis aims to provide a comprehensive evaluation of key factors influencing hotel success, including service quality, pricing strategy, and guest reviews. By identifying strengths, weaknesses, opportunities, and threats, the analysis offers actionable insights that can guide strategic planning and enhance overall performance.

### Dataset Overview
The dataset used in this analysis consists of 700 rows and 12 columns, capturing various aspects of hotel reservations, including:
- Booking_ID: Unique identifier for each reservation.
- no_of_adults: Number of adults in the reservation.
- no_of_children: Number of children in the reservation.
- no_of_weekend_nights: Number of weekend nights in the reservation.
- no_of_week_nights: Number of weekday nights in the reservation.
- type_of_meal_plan: Meal plan chosen by guests.
- room_type_reserved: Type of room reserved.
- lead_time: Days between booking and arrival.
- arrival_date: Date of arrival.
- market_segment_type: Market segment to which the reservation belongs.
- avg_price_per_room: Average price per room in the reservation.
- booking_status: Status of the booking (e.g., confirmed, cancelled).

  ![image](https://github.com/user-attachments/assets/117e5df6-2b50-4cdf-b541-30db797c5892)

### Data Cleaning and Transformation
- Handling missing value
```sql
SELECT * 
FROM hotel_reservation_dataset
WHERE no_of_adults IS NULL OR no_of_children IS NULL OR no_of_weekend_nights IS NULL OR no_of_week_nights IS NULL OR type_of_meal_plan IS NULL OR room_type_reserved IS NULL OR lead_time IS NULL
OR arrival_date IS NULL OR market_segment_type IS NULL OR avg_price_per_room IS NULL OR booking_status IS NULL;
```

- Checking for Duplicates record
```sql
select Booking_ID, count(*) from hotel_reservation_dataset group by Booking_ID having count(*) >1;
```

- Standardizing date format
```sql
update hotel_reservation_dataset set arrival_date= replace(arrival_date,'-','/');
SET SQL_SAFE_UPDATES = 0;
update hotel_reservation_dataset set arrival_date = str_to_date(arrival_date,'%d/%m/%YYYY');
alter table hotel_reservation_dataset modify column arrival_date date;
```
- Adding column real_day
```sql
alter table hotel_reservation_dataset add column real_Day date;
update hotel_reservation_dataset set real_day = date_sub(arrival_date,interval lead_time Day);
```

- Renaming the title from hotel reservation dataset to hotel_reservation_dataset for easy access to the table
```sql
rename table `hotel reservation dataset` to hotel_reservation_dataset;
```
