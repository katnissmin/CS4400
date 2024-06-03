-- CS4400: Introduction to Database Systems (Spring 2024)
-- Phase II: Create Table & Insert Statements [v0] Monday, February 19, 2024 @ 12:00am EST

-- Team 62
-- Asiya Khan (akhan461)
-- Jayanee Venkat (jvenkat8)
-- Jeff Kramer (jkramer36)
-- Katniss Min (smin70)
-- Paula Punmaneeluk (ppunmaneeluk3)

-- Directions:
-- Please follow all instructions for Phase II as listed on Canvas.
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

-- Define the database structures
/* You must enter your tables definitions, along with your primary, unique and foreign key
declarations, and data insertion statements here.  You may sequence them in any order that
works for you.  When executed, your statements must create a functional database that contains
all of the data, and supports as many of the constraints as reasonably possible. */

CREATE TABLE user (
uname varchar(40) NOT NULL, 
fname varchar(100) NOT NULL, 
lname varchar(100) NOT NULL, 
birthdate date DEFAULT NULL,
address varchar(500) NOT NULL,
PRIMARY KEY (uname)
);

CREATE TABLE customer (
userID varchar(40) NOT NULL,
rating decimal(1,0) unsigned NOT NULL,
credit decimal(10,2) unsigned NOT NULL,
PRIMARY KEY (userID),
FOREIGN KEY (userID) REFERENCES user(uname)
);

CREATE TABLE employee (
userID varchar(40) NOT NULL,
taxID varchar(40) NOT NULL,
service int unsigned NOT NULL,
salary decimal(10,2) unsigned NOT NULL,
PRIMARY KEY (userID),
UNIQUE (taxID),
FOREIGN KEY (userID) REFERENCES user(uname)
);

CREATE TABLE drone_pilot (
userID varchar(40) NOT NULL,
licenseID varchar(40) NOT NULL,
experience int unsigned NOT NULL,
UNIQUE (licenseID),
PRIMARY KEY (userID),
FOREIGN KEY (userID) REFERENCES employee(userID)
);

CREATE TABLE store_worker (
userID varchar(40) NOT NULL,
PRIMARY KEY (userID),
FOREIGN KEY (userID) REFERENCES employee(userID)
);

CREATE TABLE store (
storeID varchar(40) NOT NULL,
sname varchar(100) NOT NULL,
revenue decimal(10,2) unsigned NOT NULL,
userID varchar(40) NOT NULL,
PRIMARY KEY (storeID),
FOREIGN KEY (userID) REFERENCES store_worker(userID)
);

CREATE TABLE drone (
droneTag varchar(40) NOT NULL,
storeID varchar(40) NOT NULL,
userID varchar(40) NOT NULL,
rem_trips int unsigned NOT NULL,
capacity decimal unsigned NOT NULL,
PRIMARY KEY (droneTag, storeID),
FOREIGN KEY (storeID) REFERENCES store(storeID),
FOREIGN KEY (userID) REFERENCES drone_pilot(userID)
);

CREATE TABLE employ (
storeID varchar(40) NOT NULL,
userID varchar(40) NOT NULL,
PRIMARY KEY (storeID, userID),
FOREIGN KEY (storeID) REFERENCES store(storeID),
FOREIGN KEY (userID) REFERENCES store_worker(userID)
);

CREATE TABLE orders (
orderID varchar(40) NOT NULL,
sold_on date NOT NULL,
userID varchar(40) NOT NULL,
droneTag varchar(40) NOT NULL,
storeID varchar(40) NOT NULL,
PRIMARY KEY (orderID),
FOREIGN KEY (userID) REFERENCES customer(userID),
FOREIGN KEY (droneTag, storeID) REFERENCES drone(droneTag, storeID)
);

CREATE TABLE product (
barcode varchar(40) NOT NULL,
pname varchar(100) NOT NULL,
weight int unsigned NOT NULL,
PRIMARY KEY (barcode)
);

CREATE TABLE contain (
orderID varchar(40) NOT NULL,
barcode varchar(40) NOT NULL,
price decimal(10,2) unsigned NOT NULL,
quantity int unsigned NOT NULL,
PRIMARY KEY (orderID, barcode),
FOREIGN KEY (orderID) REFERENCES orders(orderID),
FOREIGN KEY (barcode) REFERENCES product(barcode)
);

INSERT INTO USER VALUES
('awilson5', 'Aaron','Wilson','1963-11-11','220 Peachtree Street'),
('csoares8', 'Claire','Soares','1965-09-03','706 Living Stone Way'),
('echarles19', 'Ella','Charles','1974-05-06','22 Peachtree Street'),
('eross10', 'Erica','Ross','1975-04-02','22 Peachtree Street'),
('hstark16', 'Harmon','Stark','1971-10-27','53 Tanker Top Lane'),
('jstone5', 'Jared','Stone','1961-01-06','101 Five Finger Way'),
('lrodriguez5', 'Lina','Rodriguez','1975-04-02','360 Corkscrew Circle'),
('sprince6', 'Sarah','Prince','1968-06-15','22 Peachtree Street'),
('tmccall5', 'Trey','McCall','1973-03-19','360 Corkscrew Circle');

INSERT INTO CUSTOMER VALUES 
('awilson5', 2, 100),
('jstone5', 4, 40),
('lrodriguez5', 4, 60),
('sprince6', 5, 30);

INSERT INTO EMPLOYEE VALUES
('awilson5', '111-11-1111', 9, 46000),
('csoares8', '888-88-8888', 26, 57000),
('echarles19', '777-77-7777', 3, 27000),
('eross10', '444-44-4444', 10, 61000),
('hstark16', '555-55-5555', 20, 59000),
('lrodriguez5', '222-22-2222', 20, 58000),
('tmccall5', '333-33-3333', 29, 33000);

INSERT INTO DRONE_PILOT VALUES 
('awilson5', '314159', 41), 
('lrodriguez5', '287182', 67), 
('tmccall5', '181633', 10);

INSERT INTO STORE_WORKER VALUES
('echarles19'),
('eross10'),
('hstark16');

INSERT INTO STORE VALUES
('pub', 'Publix', 200, 'hstark16'),
('krg', 'Kroger', 300, 'echarles19');

INSERT INTO DRONE VALUES
('Publix’s drone #1', 'pub', 'awilson5', 3, 10),
('Publix’s drone #2', 'pub', 'tmccall5', 2, 20),
('Kroger’s drone #1', 'krg', 'lrodriguez5', 4, 15);

INSERT INTO EMPLOY VALUES
('pub', 'eross10'),
('pub', 'hstark16'),
('krg', 'echarles19'),
('krg', 'eross10');

INSERT INTO ORDERS VALUES
('pub_303', '2021-05-23', 'sprince6', 'Publix’s drone #1', 'pub'),
('pub_305', '2021-05-22', 'sprince6', 'Publix’s drone #2', 'pub'),
('pub_306', '2021-05-22', 'awilson5', 'Publix’s drone #2', 'pub'),
('krg_217', '2021-05-23', 'jstone5',  'Kroger’s drone #1', 'krg');

INSERT INTO PRODUCT VALUES
('ap_9T25E36L', 'antipasto platter', 4),
('pr_3C6A9R', 'pot roast', 6),
('hs_5E7L23M', 'hoagie sandwich', 3),
('clc_4T9U25X', 'chocolate lava cake', 5),
('ss_2D4E6L', 'shrimp salad', 3);

INSERT INTO CONTAIN VALUES 
('pub_303', 'ap_9T25E36L', 4, 1),
('pub_303', 'pr_3C6A9R', 20, 1), 
('krg_217', 'pr_3C6A9R', 15, 2), 
('pub_306', 'hs_5E7L23M', 3, 2), 
('pub_306', 'ap_9T25E36L', 10, 1), 
('pub_305', 'clc_4T9U25X', 3, 2);









