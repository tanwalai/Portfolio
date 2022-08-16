/*In this project, I created a Korean restaurant database containing five tables. */

-- Table1 : Customer
CREATE TABLE Customer(
    customer_id INT UNIQUE,
    firstname TEXT,
    lastname TEXT,
    member BOOLEAN,
    PRIMARY KEY(customer_id)
);

INSERT INTO Customer VALUES
(1, 'Franklin', 'Ball', 0),
(2, 'Christine', 'Berry', 0 ),
(3, 'Fern', 'Brooks', 1),
(4, 'Nicholas', 'Harding', 0),
(5, 'Elaine', 'Kim', 1),
(6, 'Sybil', 'Shillingford', 1),
(7, 'Bobby', 'Bowman', 1),
(8, 'Ingram', 'Fowler', 0),
(9, 'Brooke', 'Beck', 0),
(10, 'Barnaby', 'Harrison', 1 );

-- Table2 : Location
CREATE TABLE Location(
    location_id INT UNIQUE,
    location_name TEXT,
    delivery_price REAL,
    PRIMARY KEY(location_id)
) ;

INSERT INTO Location VALUES
(1, 'Dine_in', 0),
(2, 'Dusit', 40),
(3, 'Jatujak', 40),
(4, 'Bangsue', 50),
(5, 'Phayathai', 55),
(6, 'Latphrao', 60) ;

-- Table3 : Type_Menu
CREATE TABLE Type_Menu(
    type_id INT UNIQUE,
    type_name TEXT,
    PRIMARY KEY(type_id)
) ;

INSERT INTO Type_Menu VALUES
(1, 'Snow Onion'),
(2, 'Tikkudak'),
(3, 'Original'),
(4, 'Side dish'),
(5, 'Dessert'),
(6, 'Beverage') ;

--Table4 : Menu
CREATE TABLE Menu (
    menu_id INT UNIQUE,
    menu_name TEXT,
    type_id INT,
    price INT,
    PRIMARY KEY(menu_id),
    FOREIGN KEY(type_id) REFERENCES Type_Menu(type_id)
) ;

INSERT INTO Menu VALUES
(1, 'Snow Onion Fried Chicken', 1, 300),
(2, 'Hot Snow Onion Fried Chicken', 1, 300),
(3, 'Curry Snow Onion Fried Chicken', 1, 300),
(4, 'Soy Sauce Tikkudak Fried Chicken', 2, 350),
(5, 'Gochujang Tikkudak Fried Chicken', 2, 350),
(6, 'Curry Tikkudak Fried Chicken', 2, 350),
(7, 'Garlic Tikkudak Fired Chicken', 2, 350),
(8, 'Mala Tikkudak Fried Chicken', 2, 350),
(9, 'Fried Chicken', 3, 250),
(10, 'Red Hot Fried Chicken', 3, 250),
(11, 'Kimchi Soup', 4, 125),
(12, 'Tteokbokki', 4, 150),
(13, 'Cheese Tteokbokki', 4, 175),
(14, 'Kimchi Fried Rice', 4, 125),
(15, 'Strawberry Sulbling', 5, 200),
(16, 'Mango Sulbing', 5, 200),
(17, 'Cheese Sulbing', 5, 200),
(18, 'Water', 6, 7),
(19, 'Sprite', 6, 20),
(20, 'Coke', 6, 20),
(21, 'Mango Smoothie', 6, 80),
(22, 'Watermelon Smoothie', 6, 80) ;

-- Table5 : Orders
CREATE TABLE Orders (
    order_id INT UNIQUE,
    order_date DATE,
    customer_id INT,
    location_id INT,
    total_price INT,
    PRIMARY KEY(order_id),
    FOREIGN KEY(customer_id) REFERENCES Customer(customer_id),
    FOREIGN KEY(location_id) REFERENCES Location(location_id)
);

INSERT INTO Orders VALUES
(1, '2022-08-05 19:30:50', 1, 1, 320),
(2, '2022-08-05 20:00:30', 2, 2, 390),
(3, '2022-08-05 20:30:50', 3, 4, 720),
(4, '2022-08-06 18:30:00', 4, 1, 425),
(5, '2022-08-06 18:45:30', 5, 1, 450),
(6, '2022-08-06 19:15:00', 6, 1, 350),
(7, '2022-08-06 20:45:10', 7, 6, 360),
(8, '2022-08-06 21:15:10', 8, 2, 410),
(9, '2022-08-06 21:30:30', 9, 5, 705),
(10, '2022-08-07 18:30:00', 10, 1, 620),
(11, '2022-08-12 18:00:30', 1, 2, 610),
(12, '2022-08-12 18:15:15', 2, 1, 470),
(13, '2022-08-12 18:20:30', 5, 1, 270),
(14, '2022-08-12 20:30:00', 6, 3, 510),
(15, '2022-08-12 20:35:40', 10, 3, 360) ;

-- Table6 : Order_Menu
CREATE TABLE Order_Menu(
    order_id INT,
    menu_id,
    FOREIGN KEY(order_id) REFERENCES Orders(order_id),
    FOREIGN KEY(menu_id) REFERENCES Menu(menu_id)
) ;

INSERT INTO Order_Menu VALUES
(1, 1),
(1, 20),
(2, 5),
(3, 1),
(3, 12),
(3, 16),
(3, 19),
(4, 1),
(4, 11),
(5, 10),
(5, 15),
(6, 4),
(7, 1),
(8, 8),
(8, 20),
(9, 1), 
(9, 7),
(10, 1), 
(10, 2), 
(10, 19),
(11, 1), 
(11, 10), 
(11, 20),
(12, 1), 
(12, 12), 
(12, 20),
(13, 10), 
(13, 19),
(14, 1), 
(14, 12), 
(14, 19),
(15, 1), 
(15, 19) ;


