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

### Data Exploration and Insight
1. What is the total number of reservations in the dataset?
```sql
select count(booking_id) as total_number_of_reservation from hotel_reservation_dataset;
```

Insight: There are 700 reservations in the dataset.

2. Which meal plan is the most popular among guests?
```sql
select type_of_meal_plan,count(type_of_meal_plan) as count from hotel_reservation_dataset
 group by type_of_meal_plan order by count desc limit 1;
```

Insight: Meal plan 1 is the most popular meal with 527 count.

3. What is the average price per room for reservations involving children?
```sql
select round(avg(avg_price_per_room)) from hotel_reservation_dataset
where no_of_children > 0 order by 1 desc limit 1;
```

Insight: The  average price per room for reservations involving children is $145.

4. How many reservations were made for the year 2018?
```sql
select year(arrival_date) as year, count(booking_id) as number_of_reservation
from hotel_reservation_dataset where year(arrival_date)='2018' group by year;
```

Insight: In the year 2018, the reservations made is 577 reservations.

5. What is the most commonly booked room type?
```sql
select room_type_reserved,count(booking_id) as count from hotel_reservation_dataset
group by room_type_reserved order by count desc limit 1;
```

Insight: The most common room type is room type one with 534 booking.

6. How many reservations fall on a weekend (no_of_weekend_nights > 0)?
```sql
select count(no_of_weekend_nights) as count from hotel_reservation_dataset
where no_of_weekend_nights >0;
```

Insight: The number of reservation that fall under this category is 383.

7. What is the highest and lowest lead time for reservations?
```sql
select max(lead_time) as highest,min(lead_time) as lowest from hotel_reservation_dataset;
```

Insight: The highest lead time for reservation is 443 and the lowest is 0.

8. What is the most common market segment type for reservations?
```sql
select market_segment_type, count(market_segment_type) as count from
hotel_reservation_dataset group by market_segment_type order by count desc limit 1;
```

Insight: The most common market segment type for reservation is onlime segment with count of 518.

9. How many reservations have a booking status of "Confirmed"?
```sql
select booking_status, count(booking_status) as count from hotel_reservation_dataset
where booking_status='not_canceled' group by booking_status;
```

Insight: Out of 700 reservtion made, 493 reservation are confirmed giving 70.4% success.

10. What is the total number of adults and children across all reservations?
```
select sum(no_of_adults) as adult_number, sum(no_of_children) as children_number
from hotel_reservation_dataset;
```

Insight: The total number of adult and children are 1316 and 69 respectively.

11. What is the average number of weekend nights for reservations involving children?
```sql
select round(avg(no_of_weekend_nights),2) as avg from
hotel_reservation_dataset where no_of_children > 0;
```

Insight: Reservations with children suggest a preference for an average of one weekend night stay.

12. How many reservations were made in each month of the year?
```sql
select year(arrival_date), month(arrival_date) as month_number,monthname(arrival_date) as month, count(*) as reservation_made from hotel_reservation_dataset
group by 1,2,3 order by 4 desc;
```

Insight: June 2018 have the highest record of reservation with 84 reservations while July 2017 have the lowest record of reservation with 8 reservations.

13. What is the average number of nights (both weekend and weekday) spent by guests for each room type?
```sql
select room_type_reserved,avg(no_of_weekend_nights) as avg_weekend,avg(no_of_week_nights) as avg_week 
from hotel_reservation_dataset group by room_type_reserved order by 3 desc;
```

Insight: Room type 4 have the highest average number while room 5 have the lowest number of night (both weekend and weekday)

14. For reservations involving children, what is the most common room type, and what is the average price for that room type?
```sql
select room_type_reserved as most_common, count(room_type_reserved)as number,
round(avg(avg_price_per_room)) as avg_price from hotel_reservation_dataset where 
no_of_children >0 group by 1 order by 2 desc limit 1;
```

Insight: The most common room type is room type 1 with average price of $123

15. Find the market segment type that generates the highest average price per room.
```sql
select market_segment_type,round(avg(avg_price_per_room),2) from 
hotel_reservation_dataset group by 1 order by 2 desc limit 1;
```

Insight: The Online segment generate the highest average price with $112.46

### Recommendation
#### Recommendation based on popularity of meal plan 1
1. Feature Meal Plan 1 prominently:
   - Highlight it on the booking page as a "Top Choice" or "Most Popular."
   - Use trust-building language: "Chosen by 500+ guests" or "Guest favorite!"
2. Bundle Meal Plan 1 with hotel promotions:
   - Offer it as the default option in packages.
   - Create discounts like: "Book 3 nights, get Meal Plan 1 at 10% off."
3. Use customer reviews to reinforce the choice:
   - Showcase testimonials from satisfied guests who picked Meal Plan 1.
4. Analyze what makes it popular:
   - Is it the menu variety, price, convenience, or availability?
   - Replicate these successful elements in other meal plans to boost their appeal.
5. Guide new guests with behavioral nudges:
   - Use phrases like: "Most guests who book this room choose Meal Plan 1."
6. Monitor and A/B test:
   - Continue tracking if these strategies increase conversion.
   - Test variations like emphasizing popularity vs. value.

#### Recommendations Based on Most Booked Room Type(Room type 1 with 534 bookings)
1. Promote as “Guest Favorite” or “Most Booked”
   - Add badges or highlights in the booking UI: “Most Popular Choice – Booked 534 times!”
2. Make it a default selection
   - Pre-select it in search results or booking flows to reduce friction and guide choices.
3. Create special packages
   - Offer bundle deals.
4. Investigate why it’s popular
   - Is it price, size, view, or amenities?
   - Apply winning features to underbooked room types (e.g., improve photos, pricing, or descriptions).
5. Highlight in marketing emails & ads

#### Recommendations Based on Most Common Market Segment(Online Segment)
1. Leisure Travelers (e.g., families, couples)
   - Promote weekend deals, vacation packages, and experiences (e.g., spa, tours, local dining).
   - Highlight family-friendly features: free breakfast, kids stay free, late checkout.
   - Use emotion-driven marketing: “Escape. Relax. Recharge.”
2.  OTA (Online Travel Agent) Guests
   - Optimize listings on booking platforms with high-quality images, reviews, and room descriptions.
   - Consider offering direct booking perks to convert OTA customers (e.g., free upgrade or early check-in when booking direct).

#### Recommendations to Increase Child/Family Bookings
1. Make Your Property Family-Friendly.
   - Offer family rooms or connecting rooms.
   - Include amenities like cribs, high chairs, baby tubs, or kids' toiletries.
   - Provide kid-friendly entertainment: play area, pool with shallow section, cartoon channels, or a game room.
2. Add Child-Friendly Meal Plans.
   - Offer kids’ menus or free meals for children under a certain age.
   - Promote “Kids Eat Free” offers with adult meal plans.
3. Market to Families Explicitly
   - Use website and OTA listings to show that the hotel is family-friendly.
   - Include images of families enjoying the property.
   - Create family-focused landing pages or ads: “Perfect for Your Family Getaway!”
4. Add Family-Oriented Packages
   - Example: “Family Fun Package – Includes breakfast for 4 + free tickets to local attractions.”
5. Partner with Local Attractions
   - Collaborate with zoos, amusement parks, aquariums, or museums for bundle deals.
6. Use Pricing Incentives
   - Offer discounts or free stays for children under a certain age.
   - “Stay 3 nights, kids stay free!” type promotions.

#### Recommendations When Reservations Are Low
1. Audit Your Online Presence
   - Make sure the hotel is listed on all major platforms (Booking.com, Expedia, Google Hotels, Airbnb, etc.).
   - Use high-quality photos, updated descriptions, and recent guest reviews.
   - Ensure pricing is competitive for your area and category.
2. Run Targeted Promotions
   - Offer limited-time discounts or packages to create urgency, Example: “Book Now & Save 20% on Weekend Stays”
   - Promote off-season deals or last-minute offers.
3. Improve Direct Booking Incentives
   - Give guests a reason to book directly: free early check-in, room upgrade, or discount.
   - Promote this on your website and in ads.
4. Improve Direct Booking Incentives
   - Give guests a reason to book directly: free early check-in, room upgrade, or discount.
   - Promote this on your website and in ads.
5. Boost Marketing Efforts
   - Run geo-targeted ads (Google, Facebook, Instagram) aimed at your ideal customer type.
   - Partner with influencers or travel bloggers for visibility.
   - Use email marketing to reach past guests with rebooking incentives.
6. Re-evaluate Pricing Strategy
   - Use dynamic pricing tools to stay competitive.
   - Offer more value rather than just lowering prices: free breakfast, parking, or spa credit.
7. Enhance Guest Experience & Reviews
   - Encourage satisfied guests to leave reviews on TripAdvisor, Google, and OTAs.
   - More good reviews = better ranking = more bookings.
  
### Conclusion
This project successfully developed a hotel reservation recommendation system that simplifies the hotel selection process for users. By using key criteria such as location, price range, amenities, and user preferences, the system provides relevant and personalized hotel suggestions. This helps users make faster and more informed decisions when planning their stays.

The approach demonstrated that even without complex algorithms, well-structured filtering and ranking methods can significantly improve the hotel booking experience. Future enhancements may include adding more user input options, real-time availability checks, and integration with maps or review platforms to further enrich the recommendations. Overall, the system offers a reliable and user-friendly solution for hotel selection.
