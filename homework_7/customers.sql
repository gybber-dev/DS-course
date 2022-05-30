/* 1. Выберите заказчиков из Германии, Франции и Мадрида, выведите их название, страну и адрес. */
SELECT CustomerName, Country, Address FROM Customers;
/*
2. Выберите топ 3 страны по количеству заказчиков, выведите их названия и количество записей.
*/
SELECT Country, count(CustomerName) as Amount FROM Customers
GROUP BY Country
ORDER BY Amount DESC
LIMIT 3

/*
3. Выберите перевозчика, который отправил 10-й по времени заказ, выведите его название, и дату отправления.
*/
SELECT Shippers.ShipperName, Orders.OrderDate FROM Orders
INNER JOIN Shippers ON Orders.ShipperID = Shippers.ShipperID
WHERE Orders.OrderID = (SELECT OrderID from Orders LIMIT 1 OFFSET 9)

/*
4. Выберите самый дорогой заказ, выведите список товаров с их ценами.
*/
SELECT ProductName, Price FROM (
  SELECT OrderID, sum(OrderDetails.Quantity * Products.Price) as Total FROM ((Orders
  JOIN OrderDetails USING(OrderID))
  JOIN Products USING(ProductID))
  GROUP BY OrderID ORDER BY Total DESC LIMIT 1)
JOIN OrderDetails USING(OrderID)
JOIN Products USING(ProductID)

/*
5. Какой товар больше всего заказывали по количеству единиц товара, выведите его название и количество единиц в каждом из заказов.
*/
SELECT Products.ProductName, OrderID, OrderDetails.Quantity FROM (
  SELECT ProductID, sum(Quantity) as Amount FROM (Orders
  JOIN OrderDetails USING(OrderID))
  GROUP BY ProductID ORDER BY Amount DESC LIMIT 1)
JOIN Products USING(ProductID)
JOIN OrderDetails USING(ProductID)



/*
6. Выведите топ 5 поставщиков по количеству заказов, выведите их названия, страну, контактное лицо и телефон.
*/
SELECT SupplierName, Country, ContactName, Phone, Amount FROM (
  SELECT Products.SupplierID, count(OrderID) as Amount FROM ((Orders
  JOIN OrderDetails USING(OrderID))
  JOIN Products USING(ProductID)) GROUP BY CategoryID ORDER BY Amount DESC LIMIT 5)
JOIN Suppliers USING(SupplierID)

/*
7. Какую категорию товаров заказывали больше всего по стоимости в Бразилии, выведите страну, название категории и сумму.
*/
SELECT Customers.Country, Categories.CategoryName, sum(Products.Price * OrderDetails.Quantity) as Total FROM ((((Orders
  JOIN Customers ON Customers.CustomerID = Orders.CustomerID AND Customers.Country = 'Brazil')
  JOIN OrderDetails USING(OrderID))
  JOIN Products USING(ProductID))
  JOIN Categories USING(CategoryID))
GROUP BY CategoryName ORDER BY Total DESC LIMIT 1

/*
8. Какая разница в стоимости между самым дорогим и самым дешевым заказом из США.
*/
SELECT max(Total) - min(Total) as Answer FROM (
  SELECT Products.Price * OrderDetails.Quantity as Total FROM (((Orders
  JOIN Customers ON Customers.CustomerID = Orders.CustomerID AND Customers.Country = 'USA')
  JOIN OrderDetails USING(OrderID))
)
JOIN Products USING (ProductID))

/*
9. Выведите количество заказов у каждого их трех самых молодых сотрудников, а также имя и фамилию во второй колонке.
*/
SELECT count(OrderID) as Amount, (Employees.FirstName || ' ' || Employees.LastName) AS FullName FROM (Orders
    JOIN Employees USING(EmployeeID)
)
GROUP BY EmployeeID ORDER BY BirthDate DESC
LIMIT 3

/*
10. Сколько банок крабового мяса всего было заказано.
 */
SELECT sum(Quantity) FROM ((Orders
JOIN OrderDetails USING(OrderID))
JOIN Products ON Products.ProductID = OrderDetails.ProductID AND Products.ProductName LIKE '%Crab Meat%')
