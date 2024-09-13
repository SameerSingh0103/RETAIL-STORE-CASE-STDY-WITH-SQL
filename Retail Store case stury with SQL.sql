select top 5* from customer
select top 20* from Transactions
select  * from prod_cat_info

--Total rows in all three columns--
--1)
select   count( customer_Id)cnt from customer
union
select   count( cust_Id) from Transactions
union
select   count( prod_cat_code) from prod_cat_info

--2)
select count(distinct transaction_id) as Return_cnt from Transactions
where Qty<0

--3) 
alter table transactions
alter column tran_date date
--4)
 select DATEDIFF(year,min(tran_date),max(tran_date)) as year_range ,
 DATEDIFF(month,min(tran_date),max(tran_date)) as month_range,
 DATEDIFF(day,min(tran_date),max(tran_date)) as day_range 
 from transactions

 --5)
  select prod_cat, prod_subcat from prod_cat_info
  where prod_subcat ='DIY'

                     --- Data Analysis--
 --1) 
 
 select top 1 store_type,count(store_type) Freq_cnt from transactions
 group by store_type
 order by 1 

 --2) 
   select top 2 gender, count(customer_id) as gender_cnt  from Customer
   group by gender
   order by 1 desc
--3) 
  
  select  top 2 city_code, count(customer_id) from customer
  group by city_code
  order by 2 desc 

  --4)

  select prod_cat, count(prod_subcat) Books_cnt from prod_cat_info
  where prod_cat ='books'
  group by prod_cat

  --5) 

    select sum(convert(float,total_amt)) as Total_amt from Transactions T1
	join prod_cat_info T2 on T1.Prod_subcat_code = T2.prod_sub_cat_code  and T1.prod_cat_code = T2.prod_cat_code
    where prod_cat in ('Electronics','Books')



--6)

select cust_id, count(transaction_id) from Transactions
where total_amt >0
group by cust_id
having count(transaction_id)>10

--7) 
    select sum(convert(float,total_amt)) as Total_amt from Transactions T1
	join prod_cat_info T2 on T1.Prod_subcat_code = T2.prod_sub_cat_code  and T1.prod_cat_code = T2.prod_cat_code
    where prod_cat in ('Electronics','Clothing') and store_type= 'flagship store'
	
--8)
   select prod_sub_cat_code,sum(convert(int,total_amt)) as Total_amt from Transactions T1
	join prod_cat_info T2 on T1.Prod_subcat_code = T2.prod_sub_cat_code  and T1.prod_cat_code = T2.prod_cat_code
	join customer t3 on t3.customer_Id = t1.cust_id
	where gender='M' and prod_cat='electronics'
	group by prod_sub_cat_code
	order by 1 desc

--9) 
 -- percent of sales
 select top 5 b.prod_subcat, per_sales,percentage_returuns from (
 select prod_subcat,(sum(cast(total_amt as float)/(select sum(cast(total_amt as float))as total_sales from transactions where Qty>0)) as per_sales 
 from Transactions T1
 join prod_cat_info T2 on T1.Prod_subcat_code = T2.prod_sub_cat_code  and T1.prod_cat_code = T2.prod_cat_code
 where Qty>0
 group by prod_subcat) as a
 join 
(select prod_subcat,(sum(cast(total_amt as float))/(select sum(cast(total_amt as float)) toal_returns from transactions where Qty<0)) as percentage_returuns
 from Transactions T1
 join prod_cat_info T2 on T1.Prod_subcat_code = T2.prod_sub_cat_code  and T1.prod_cat_code = T2.prod_cat_code
  where Qty<0
 group by prod_subcat
 ) as b
 on a.prod_subcat = b.prod_subcat
--10)
select * from(
select * from(
select cust_id,DATEDIFF(year,DOB,max_dte) as age,revenue  from
(select cust_id,dob,max(convert(date,tran_date))max_dte, sum(convert(int, total_amt))revenue from Customer t1
join Transactions t2 on t1.customer_Id =t2.cust_id
where Qty>0
group by cust_id,dob)a
    )b
	where age between 25 and 35
	)c
	join 
	(select cust_id,(convert(date,tran_date)) as trans_dte from Transactions
	group by cust_id,(convert(date,tran_date))
	having convert(date,tran_date) >= (select DATEADD(day,-30,max(convert(date,tran_date)))cutoff_dte from Transactions))d
	on c.cust_id=d.cust_id

--11)
select top 2 prod_cat_code, convert(date,tran_date) dte, sum(qty) as returns from Transactions
where qty<0
group by prod_cat_code, convert(date,tran_date)
having convert(date,tran_date) >= (select dateadd(month,-3,max(convert(date,tran_date))) as cut_off from Transactions)
order by returns 

--12)

select   top 1 Store_type, (sum(convert(float,total_amt)))Total_amt,sum(qty) from Transactions
where qty>0
group by  Store_type
order by (sum(convert(float,total_amt))) desc


--13)

select prod_cat_code, AVG(convert(float,total_amt)) from Transactions
where qty>0
group by prod_cat_code 
having AVG(convert(float,total_amt))>(select avg(convert(float,total_amt)) from Transactions)


--14) 

select prod_subcat_code, sum(convert(float,total_amt))as total_sales, avg(convert(float,total_amt)) as avg_sales 
from Transactions a
where qty>0 and prod_cat_code in (select top 5 prod_subcat_code from Transactions
                                  group by prod_subcat_code
								  order by sum(qty))
group by prod_subcat_code



