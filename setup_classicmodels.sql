USE classicmodels;

DROP TABLE IF EXISTS customers;

CREATE TABLE customers (
    customerNumber INT PRIMARY KEY,
    customerName VARCHAR(50) NOT NULL,
    contactLastName VARCHAR(50) NOT NULL,
    contactFirstName VARCHAR(50) NOT NULL,
    phone VARCHAR(50),
    addressLine1 VARCHAR(50),
    city VARCHAR(50),
    country VARCHAR(50)
);

INSERT INTO customers VALUES 
(103, 'Atelier graphique', 'Schmitt', 'Carine', '40.32.2555', '54, rue Royale', 'Nantes', 'France'),
(112, 'Signal Gift Stores', 'King', 'Jean', '7025551838', '8489 Strong St.', 'Las Vegas', 'USA'),
(114, 'Ferguson Collection', 'Ferguson', 'Peter', '03 9520 4555', '636 St Kilda Road', 'Melbourne', 'Australia'),
(119, 'Land of Toys Inc.', 'Hernandez', 'Maria', '2125557818', '897 Long Airport Avenue', 'NYC', 'USA'),
(121, 'Baane Mini Imports', 'Bergulfsen', 'Jonas', '07-98 9555', 'Erling Skakkes gate 78', 'Stavern', 'Norway');