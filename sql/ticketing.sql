CREATE database ticketing;

create table line(id integer not null PRIMARY key AUTO_INCREMENT, 
departure varchar(255), arrival varchar(255), unitprice double);

CREATE table sale(numberofticket integer, totalprice double, 
saletime datetime, id integer, FOREIGN KEY (id) REFERENCES line(id));

insert into line values (1, "Adjamé", "Abobo", 200), 
(2, "Adjamé", "Yopougon", 300), (3, "Adjamé", "Treichville", 300)

insert into sale values (3, 600, now(), 1),
 (4, 1200, now(), 2), (2, 600, now(), 3)