-- CS4400: Introduction to Database Systems (Spring 2024)
-- Phase III: Stored Procedures & Views [v1] Wednesday, March 27, 2024 @ 5:20pm EST

-- Team 62
-- Asiya Khan (akhan461)
-- Jayanee Venkat (jvenkat8)
-- Jeff Kramer (jkramer36)
-- Katniss Min (smin70)
-- Paula Punmaneeluk (ppunmaneeluk3)

-- Directions:
-- Please follow all instructions for Phase III as listed on Canvas.
-- Fill in the team number and names and GT usernames for all members above.
-- Create Table statements must be manually written, not taken from an SQL Dump file.
-- This file must run without error for credit.

/* This is a standard preamble for most of our scripts.  The intent is to establish
a consistent environment for the database behavior. */
set global transaction isolation level serializable;
set global SQL_MODE = 'ANSI,TRADITIONAL';
set names utf8mb4;
set SQL_SAFE_UPDATES = 0;

set @thisDatabase = 'drone_dispatch';
drop database if exists drone_dispatch;
create database if not exists drone_dispatch;
use drone_dispatch;

-- -----------------------------------------------
-- table structures
-- -----------------------------------------------

create table users (
uname varchar(40) not null,
first_name varchar(100) not null,
last_name varchar(100) not null,
address varchar(500) not null,
birthdate date default null,
primary key (uname)
) engine = innodb;

create table customers (
uname varchar(40) not null,
rating integer not null,
credit integer not null,
primary key (uname)
) engine = innodb;

create table employees (
uname varchar(40) not null,
taxID varchar(40) not null,
service integer not null,
salary integer not null,
primary key (uname),
unique key (taxID)
) engine = innodb;

create table drone_pilots (
uname varchar(40) not null,
licenseID varchar(40) not null,
experience integer not null,
primary key (uname),
unique key (licenseID)
) engine = innodb;

create table store_workers (
uname varchar(40) not null,
primary key (uname)
) engine = innodb;

create table products (
barcode varchar(40) not null,
pname varchar(100) not null,
weight integer not null,
primary key (barcode)
) engine = innodb;

create table orders (
orderID varchar(40) not null,
sold_on date not null,
purchased_by varchar(40) not null,
carrier_store varchar(40) not null,
carrier_tag integer not null,
primary key (orderID)
) engine = innodb;

create table stores (
storeID varchar(40) not null,
sname varchar(100) not null,
revenue integer not null,
manager varchar(40) not null,
primary key (storeID)
) engine = innodb;

create table drones (
storeID varchar(40) not null,
droneTag integer not null,
capacity integer not null,
remaining_trips integer not null,
pilot varchar(40) not null,
primary key (storeID, droneTag)
) engine = innodb;

create table order_lines (
orderID varchar(40) not null,
barcode varchar(40) not null,
price integer not null,
quantity integer not null,
primary key (orderID, barcode)
) engine = innodb;

create table employed_workers (
storeID varchar(40) not null,
uname varchar(40) not null,
primary key (storeID, uname)
) engine = innodb;

-- -----------------------------------------------
-- referential structures
-- -----------------------------------------------

alter table customers add constraint fk1 foreign key (uname) references users (uname)
	on update cascade on delete cascade;
alter table employees add constraint fk2 foreign key (uname) references users (uname)
	on update cascade on delete cascade;
alter table drone_pilots add constraint fk3 foreign key (uname) references employees (uname)
	on update cascade on delete cascade;
alter table store_workers add constraint fk4 foreign key (uname) references employees (uname)
	on update cascade on delete cascade;
alter table orders add constraint fk8 foreign key (purchased_by) references customers (uname)
	on update cascade on delete cascade;
alter table orders add constraint fk9 foreign key (carrier_store, carrier_tag) references drones (storeID, droneTag)
	on update cascade on delete cascade;
alter table stores add constraint fk11 foreign key (manager) references store_workers (uname)
	on update cascade on delete cascade;
alter table drones add constraint fk5 foreign key (storeID) references stores (storeID)
	on update cascade on delete cascade;
alter table drones add constraint fk10 foreign key (pilot) references drone_pilots (uname)
	on update cascade on delete cascade;
alter table order_lines add constraint fk6 foreign key (orderID) references orders (orderID)
	on update cascade on delete cascade;
alter table order_lines add constraint fk7 foreign key (barcode) references products (barcode)
	on update cascade on delete cascade;
alter table employed_workers add constraint fk12 foreign key (storeID) references stores (storeID)
	on update cascade on delete cascade;
alter table employed_workers add constraint fk13 foreign key (uname) references store_workers (uname)
	on update cascade on delete cascade;

-- -----------------------------------------------
-- table data
-- -----------------------------------------------

insert into users values
('jstone5', 'Jared', 'Stone', '101 Five Finger Way', '1961-01-06'),
('sprince6', 'Sarah', 'Prince', '22 Peachtree Street', '1968-06-15'),
('awilson5', 'Aaron', 'Wilson', '220 Peachtree Street', '1963-11-11'),
('lrodriguez5', 'Lina', 'Rodriguez', '360 Corkscrew Circle', '1975-04-02'),
('tmccall5', 'Trey', 'McCall', '360 Corkscrew Circle', '1973-03-19'),
('eross10', 'Erica', 'Ross', '22 Peachtree Street', '1975-04-02'),
('hstark16', 'Harmon', 'Stark', '53 Tanker Top Lane', '1971-10-27'),
('echarles19', 'Ella', 'Charles', '22 Peachtree Street', '1974-05-06'),
('csoares8', 'Claire', 'Soares', '706 Living Stone Way', '1965-09-03'),
('agarcia7', 'Alejandro', 'Garcia', '710 Living Water Drive', '1966-10-29'),
('bsummers4', 'Brie', 'Summers', '5105 Dragon Star Circle', '1976-02-09'),
('cjordan5', 'Clark', 'Jordan', '77 Infinite Stars Road', '1966-06-05'),
('fprefontaine6', 'Ford', 'Prefontaine', '10 Hitch Hikers Lane', '1961-01-28');

insert into customers values
('jstone5', 4, 40),
('sprince6', 5, 30),
('awilson5', 2, 100),
('lrodriguez5', 4, 60),
('bsummers4', 3, 110),
('cjordan5', 3, 50);

insert into employees values
('awilson5', '111-11-1111', 9, 46000),
('lrodriguez5', '222-22-2222', 20, 58000),
('tmccall5', '333-33-3333', 29, 33000),
('eross10', '444-44-4444', 10, 61000),
('hstark16', '555-55-5555', 20, 59000),
('echarles19', '777-77-7777', 3, 27000),
('csoares8', '888-88-8888', 26, 57000),
('agarcia7', '999-99-9999', 24, 41000),
('bsummers4', '000-00-0000', 17, 35000),
('fprefontaine6', '121-21-2121', 5, 20000);

insert into store_workers values
('eross10'),
('hstark16'),
('echarles19');

insert into stores values
('pub', 'Publix', 200, 'hstark16'),
('krg', 'Kroger', 300, 'echarles19');

insert into employed_workers values
('pub', 'eross10'),
('pub', 'hstark16'),
('krg', 'eross10'),
('krg', 'echarles19');

insert into drone_pilots values
('awilson5', '314159', 41),
('lrodriguez5', '287182', 67),
('tmccall5', '181633', 10),
('agarcia7', '610623', 38),
('bsummers4', '411911', 35),
('fprefontaine6', '657483', 2);

insert into drones values
('pub', 1, 10, 3, 'awilson5'),
('pub', 2, 20, 2, 'lrodriguez5'),
('krg', 1, 15, 4, 'tmccall5'),
('pub', 9, 45, 1, 'fprefontaine6');

insert into products values
('pr_3C6A9R', 'pot roast', 6),
('ss_2D4E6L', 'shrimp salad', 3),
('hs_5E7L23M', 'hoagie sandwich', 3),
('clc_4T9U25X', 'chocolate lava cake', 5),
('ap_9T25E36L', 'antipasto platter', 4);

insert into orders values
('pub_303', '2024-05-23', 'sprince6', 'pub', 1),
('pub_305', '2024-05-22', 'sprince6', 'pub', 2),
('krg_217', '2024-05-23', 'jstone5', 'krg', 1),
('pub_306', '2024-05-22', 'awilson5', 'pub', 2);

insert into order_lines values
('pub_303', 'pr_3C6A9R', 20, 1),
('pub_303', 'ap_9T25E36L', 4, 1),
('pub_305', 'clc_4T9U25X', 3, 2),
('pub_306', 'hs_5E7L23M', 3, 2),
('pub_306', 'ap_9T25E36L', 10, 1),
('krg_217', 'pr_3C6A9R', 15, 2);

-- -----------------------------------------------
-- stored procedures and views
-- -----------------------------------------------

-- add customer
delimiter // 
create procedure add_customer
	(in ip_uname varchar(40), in ip_first_name varchar(100),
	in ip_last_name varchar(100), in ip_address varchar(500),
    in ip_birthdate date, in ip_rating integer, in ip_credit integer)
sp_main: begin
	-- place your solution here
    if not exists (select 1 from customers where ip_uname = uname) and not -- checking that uname is unique
    -- birthday can be null
    (ip_uname is null or ip_first_name is null or ip_address is null or ip_rating is null or ip_credit is null) and
    ip_rating > 0 and ip_rating <= 5 
    then -- these values can't be null
		insert into users values(ip_uname, ip_first_name, ip_last_name, ip_address, ip_birthdate); -- must insert into superclass before inserting into subclass
        insert into customers values (ip_uname, ip_rating, ip_credit);
    
    end if;
end //
delimiter ;

-- add drone pilot
delimiter // 
create procedure add_drone_pilot
	(in ip_uname varchar(40), in ip_first_name varchar(100),
	in ip_last_name varchar(100), in ip_address varchar(500),
    in ip_birthdate date, in ip_taxID varchar(40), in ip_service integer, 
    in ip_salary integer, in ip_licenseID varchar(40),
    in ip_experience integer)
sp_main: begin
	-- place your solution here
    if not exists (select 1 from drone_pilots where uname = ip_uname) and
	not exists (select 1 from drone_pilots where licenseID = ip_licenseID) and
    not exists (select 1 from employees where taxID = ip_taxID) and 
    not exists (select 1 from store_workers where uname = ip_uname) and not  -- drone pilots cannot be store workers at the same time
    (ip_uname is null or ip_first_name is null or ip_address is null or ip_birthdate is null or 
    ip_taxID is null or ip_service is null or ip_salary is null or ip_licenseID is null or ip_experience is null) 
    then
		insert into users values(ip_uname, ip_first_name, ip_last_name, ip_address, ip_birthdate);
		insert into employees values (ip_uname, ip_taxID, ip_service, ip_salary);
		insert into drone_pilots values (ip_uname, ip_licenseID, ip_experience);
    
    end if;
end //
delimiter ;

-- add product
delimiter // 
create procedure add_product
	(in ip_barcode varchar(40), in ip_pname varchar(100),
    in ip_weight integer)
sp_main: begin
	-- place your solution here
    if not exists (select 1 from products where barcode = ip_barcode) and 
    not (ip_barcode is null or ip_pname is null or ip_weight is null) then
		insert into products values (ip_barcode, ip_pname, ip_weight);
    
    end if;
end //
delimiter ;

-- add drone
delimiter // 
create procedure add_drone
	(in ip_storeID varchar(40), in ip_droneTag integer,
    in ip_capacity integer, in ip_remaining_trips integer,
    in ip_pilot varchar(40))
sp_main: begin
	-- place your solution here
    if not exists (select 1 from drones where storeID = ip_storeID and droneTag = ip_droneTag) and -- drone unique (tag + store)
    exists (select 1 from stores where storeID = ip_storeID) and -- store must exist
    exists (select 1 from drone_pilots where uname = ip_pilot) and -- pilot must be in drone_pilots
    not exists (select 1 from drones where pilot = ip_pilot) and -- pilot must not already be controlling a drone
    not (ip_storeID is null or ip_droneTag is null or ip_capacity is null or ip_remaining_trips is null or ip_pilot is null)
    then
		insert into drones values (ip_storeID, ip_droneTag, ip_capacity, ip_remaining_trips, ip_pilot);
    end if;
end //
delimiter ;

-- increase customer credits
delimiter // 
create procedure increase_customer_credits
	(in ip_uname varchar(40), in ip_money integer)
sp_main: begin
	-- place your solution here
    if exists (select 1 from customers where uname = ip_uname) and -- uname must exist in customers
    not (ip_uname is null or ip_money is null) and ip_money >= 0 then 
		update customers set credit = credit + ip_money where uname = ip_uname;
    end if;
end //
delimiter ;

-- swap drone control
delimiter // 
create procedure swap_drone_control
	(in ip_incoming_pilot varchar(40), in ip_outgoing_pilot varchar(40))
sp_main: begin
	-- place your solution here
    if exists (select 1 from drone_pilots where ip_incoming_pilot = uname) -- incoming pilot is valid pilot in the system
    and exists (select 1 from drones where ip_outgoing_pilot = pilot)  -- outcoming pilot is currently controlling a drone
    and not exists (select 1 from drones where ip_incoming_pilot = pilot) -- incoming pilot is not currently controlling a drone
    and not (ip_incoming_pilot is null or ip_outgoing_pilot is null) 
    then
		update drones set pilot = ip_incoming_pilot where pilot = ip_outgoing_pilot;
    end if;
end //
delimiter ;

-- repair and refuel a drone
delimiter // 
create procedure repair_refuel_drone
	(in ip_drone_store varchar(40), in ip_drone_tag integer,
    in ip_refueled_trips integer)
sp_main: begin
	-- place your solution here
    if exists (select 1 from drones where ip_drone_store = storeID) 
    and exists (select 1 from drones where ip_drone_tag = droneTag) -- checks if drone is valid
    and not (ip_drone_store is null or ip_drone_tag is null or ip_refueled_trips is null)
    and ip_refueled_trips >= 0
    then
		update drones set remaining_trips = remaining_trips + ip_refueled_trips where storeID = ip_drone_store and droneTag = ip_drone_tag;
    end if;
end //
delimiter ;

-- begin order
delimiter // 
create procedure begin_order
	(in ip_orderID varchar(40), in ip_sold_on date,
    in ip_purchased_by varchar(40), in ip_carrier_store varchar(40),
    in ip_carrier_tag integer, in ip_barcode varchar(40),
    in ip_price integer, in ip_quantity integer)
sp_main: begin
	-- place your solution here
    -- do we need to check if the drone has capacity accounting for other orders that have been assigned to it?
    -- do we need to check if the user has enough credits for this in addition to other orders?
    if exists (select 1 from customers where ip_purchased_by = uname) and -- customer valid 
    not exists (select 1 from orders where ip_orderID = orderID) and -- order ID is valid
    exists (select 1 from drones where ip_carrier_tag = droneTag and ip_carrier_store = storeID) and -- drone is valid
    exists (select 1 from products where ip_barcode = barcode) and -- barcode is valid 
    ip_price >= 0 and ip_quantity > 0 and -- price is non negative and quantity is positive
    not (ip_orderID is null or ip_sold_on is null or ip_purchased_by is null or ip_carrier_store is null or 
    ip_carrier_tag is null or ip_barcode is null or ip_price is null or ip_quantity is null) and
    -- customer has enough credits to purchase initial products
    (select credit from customers where ip_purchased_by = uname) >= (ip_price * ip_quantity) 
    -- (select sum(price * quantity) from order_lines natural join orders where purchased_by = ip_purchased_by)))
    and 
    (select capacity from drones where ip_carrier_store = storeID and ip_carrier_tag = droneTag) >= ((select weight from products where ip_barcode = barcode) * ip_quantity)
    -- + (select sum(weight * quantity) from products natural join order_lines natural join orders where carrier_store = ip_carrier_store and carrier_tag = ip_carrier_tag))
    then -- drone has enoguh lifting capacity
		insert into orders values (ip_orderID, ip_sold_on, ip_purchased_by, ip_carrier_store, ip_carrier_tag);
		insert into order_lines values (ip_orderID, ip_barcode, ip_price, ip_quantity);
    end if;
end //
delimiter ;

-- add order line
delimiter // 
create procedure add_order_line
	(in ip_orderID varchar(40), in ip_barcode varchar(40),
    in ip_price integer, in ip_quantity integer)
sp_main: begin
	-- place your solution here
-- 	SELECT 'Initial ip_price:', ip_price;
	Declare purchaser varchar(40);
    select purchased_by into purchaser from orders where orderID = ip_orderID;
    
    if exists (select 1 from orders where ip_orderID = orderID) -- orderID valid
    and exists (select 1 from products where ip_barcode = barcode) -- barcode valid 
    and not exists (select 1 from order_lines where ip_barcode = barcode and ip_orderID = orderID) -- product being added is not already part of the order
    and ip_price >= 0 and ip_quantity > 0 -- price is non negative and quantity is positive 
    and not (ip_orderID is null or ip_barcode is null or ip_price is null or ip_quantity is null) 
    -- customer has enough credits to purchase the produdcts being added to the order + other orders
    and ((select credit from customers where uname = (select purchased_by from orders where orderID = ip_orderID)) >= ((ip_price * ip_quantity) +
    (select sum(price * quantity) from order_lines natural join orders natural join products where purchased_by = purchaser))) and 
    -- drone has enough capacity to carry products being added (new order + current orders)
    ((select capacity from drones where droneTag = (select carrier_tag from orders where orderID = ip_orderID) and 
    storeID = (select carrier_store from orders where orderID = ip_orderID)) >= 
    ((select weight from products where ip_barcode = barcode) * ip_quantity) + 
	(select sum(weight * quantity) from order_lines natural join orders natural join products where carrier_store = (select carrier_store from orders where orderID = ip_orderID) 
    and carrier_tag = (select carrier_tag from orders where orderID = ip_orderID)))
    then
-- 		SELECT 'After condition 1:', ip_price;
		insert into order_lines values (ip_orderID, ip_barcode, ip_price, ip_quantity);
    end if;
    
end //
delimiter ;

-- deliver order
delimiter // 
create procedure deliver_order
	(in ip_orderID varchar(40))
sp_main: begin
	-- place your solution here
    Declare total_cost int;
	Declare purchaser varchar(40);
    select sum(price * quantity) into total_cost from order_lines where orderID = ip_orderID; -- total price of order
    select purchased_by into purchaser from orders where orderID = ip_orderID; -- uname of purchaser of order
    
    if exists (select 1 from orders where ip_orderID = orderID) and -- valild orderID
    not (ip_orderID is null) and
    -- drone has at least 1 remaining trip left
    ((select remaining_trips from drones where storeID = (select carrier_store from orders where orderID = ip_orderID)
    and droneTag = (select carrier_tag from orders where orderID = ip_orderID)) > 0)
    then
    -- reduce customer's credit by cost of the order
		update customers set credit = credit - total_cost where uname = purchaser;
    -- if order was more than $25 then increase customer's rating 
	if total_cost > 25 and (select rating from customers where uname = purchaser) < 5 then
		update customers set rating = rating + 1 where uname = purchaser;
    end if;
    -- increase store's revenue by cost of order
		update stores set revenue = revenue + total_cost where storeID = (select carrier_store from orders where orderID = ip_orderID);
    -- reduce drone's remaining trips by 1
		update drones set remaining_trips = remaining_trips - 1 where storeID = (select carrier_store from orders where orderID = ip_orderID) 
    and droneTag = (select carrier_tag from orders where orderID = ip_orderID);
    -- update pilot's experience by 1
		update drone_pilots set experience = experience + 1 where uname = (select pilot from drones where storeID = (select carrier_store from orders where orderID = ip_orderID) 
    and droneTag = (select carrier_tag from orders where orderID = ip_orderID)); 
	-- delete order from system
		delete from orders where orderID = ip_orderID;
		delete from order_lines where orderID = ip_orderID;
    end if;
    
end //
delimiter ;

-- cancel an order
delimiter // 
create procedure cancel_order
	(in ip_orderID varchar(40))
sp_main: begin
	-- place your solution here
    Declare purchaser varchar(40);
    select purchased_by into purchaser from orders where orderID = ip_orderID; -- uname of purchaser of order
    
    if exists (select 1 from orders where ip_orderID = orderID) then -- orderID is valid
    -- delete records of the order
		delete from orders where orderID = ip_orderID;
		delete from order_lines where orderID = ip_orderID;
    -- decrease customer's rating by 1 if permitted
    if (select rating from customers where uname = purchaser) > 1 then
		update customers set rating = rating - 1 where uname = purchaser;
    end if;
    end if;
end //
delimiter ;

-- display persons distribution across roles
create or replace view role_distribution (category, total) as
-- replace this select query with your solution
select 'users' as categories,
count(uname) as total from users
union
select 'customers' as categories,
count(uname) from customers
union
select 'employees',
count(uname) from employees
union
select 'customer_employer_overlap',
count(uname) from employees
where employees.uname in (select uname from customers)
union
select 'drone_pilots',
count(uname) from drone_pilots
union
select 'store_workers',
count(uname) from store_workers
union
select 'other_employee_roles',
count(uname) from employees
where uname not in (select uname from drone_pilots) and uname not in (select uname from store_workers);

-- display customer status and current credit and spending activity
create or replace view customer_credit_check (customer_name, rating, current_credit,
	credit_already_allocated) as
-- replace this select query with your solution
select uname, rating, credit, coalesce(sum(price*quantity),0) as credit_already_allocated
from orders natural join order_lines right join customers on purchased_by = uname group by uname, rating, credit;

-- display drone status and current activity
create or replace view drone_traffic_control (drone_serves_store, drone_tag, pilot,
	total_weight_allowed, current_weight, deliveries_allowed, deliveries_in_progress) as
-- replace this select query with your solution
select storeID as drone_serves_store, droneTag as drone_tag, pilot, capacity as total_weight_allowed, coalesce(sum(weight*quantity),0) as current_weight, remaining_trips as deliveries_allowed, count(distinct orders.orderID) as deliveries_in_progress from drones
left join orders on carrier_store = storeID and carrier_tag = droneTag
left join order_lines on order_lines.orderID = orders.orderID 
left join products on products.barcode = order_lines.barcode
group by storeID, droneTag;

-- display product status and current activity including most popular products
create or replace view most_popular_products (barcode, product_name, weight, lowest_price,
	highest_price, lowest_quantity, highest_quantity, total_quantity) as
-- replace this select query with your solution
select products.barcode, pname, weight, min(price), max(price), coalesce(min(quantity),0), coalesce(max(quantity),0), coalesce(sum(quantity),0) 
from products left join order_lines on products.barcode = order_lines.barcode group by barcode;

-- display drone pilot status and current activity including experience
create or replace view drone_pilot_roster (pilot, licenseID, drone_serves_store,
	drone_tag, successful_deliveries, pending_deliveries) as
-- replace this select query with your solution
select uname as pilot, licenseID, storeID as drone_serves_store, droneTag as drone_tag, experience as successful_deliveries, count(carrier_tag) as pending_deliveries 
from drone_pilots left join drones on uname = pilot left join orders on droneTag = carrier_tag and storeID = carrier_store 
group by licenseID, drone_serves_store, drone_tag, successful_deliveries;

-- display store revenue and activity
create or replace view store_sales_overview (store_id, sname, manager, revenue,
	incoming_revenue, incoming_orders) as
-- replace this select query with your solution
select storeID, sname, manager, revenue, coalesce(sum(price*quantity),0), count(distinct orderID)
from stores left join orders on carrier_store = storeID natural join order_lines group by carrier_store;

-- display the current orders that are being placed/in progress
create or replace view orders_in_progress (orderID, cost, num_products, payload,
	contents) as
-- replace this select query with your solution
select orderID, sum(price * quantity) as cost, count(barcode) as num_products, 
sum(weight * quantity) as payload, group_concat(pname) as contents
from order_lines natural join orders natural join products group by orderID;

-- remove customer
delimiter // 
create procedure remove_customer
	(in ip_uname varchar(40))
sp_main: begin
	-- place your solution here
    if exists (select 1 from customers where ip_uname = uname) and not exists (select 1 from orders where ip_uname = purchased_by) 
    then 
		delete from customers where uname = ip_uname;
    if not exists (select 1 from employees where ip_uname = uname) then
		delete from users where uname = ip_uname;
        end if;
    end if;
end //
delimiter ;

-- remove drone pilot
delimiter // 
create procedure remove_drone_pilot
	(in ip_uname varchar(40))
sp_main: begin
    if exists (select 1 from drone_pilots where ip_uname = uname) 
    -- pilot is not controlling a drone
    and not exists (select 1 from drones where pilot = ip_uname) then
		delete from drone_pilots where uname = ip_uname;
         -- if pilot is not a customer, delete from users
        if not exists (select 1 from customers where uname = ip_uname) then
			delete from users where uname = ip_uname;
		end if;
	end if;
end //
delimiter ;

-- remove product
delimiter // 
create procedure remove_product
	(in ip_barcode varchar(40))
sp_main: begin
	-- place your solution here
    if exists (select 1 from products where ip_barcode = barcode) 
    and not exists (select 1 from order_lines where ip_barcode = barcode) then -- barcode not being used in pending orders
		delete from products where barcode = ip_barcode;
	end if;
end //
delimiter ;

-- remove drone
delimiter // 
create procedure remove_drone
	(in ip_storeID varchar(40), in ip_droneTag integer)
sp_main: begin
	-- place your solution here
    if exists (select 1 from drones where ip_storeID = storeID and ip_droneTag = droneTag) and 
    not exists (select 1 from orders where carrier_store = ip_storeID and carrier_tag = ip_droneTag) then
		delete from drones where ip_storeID = storeID and ip_droneTag = droneTag;
    end if;
end //
delimiter ;
