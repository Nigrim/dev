SELECT c.FirstName, c.LastName
FROM Customers c
JOIN Orders o ON c.CustomerID = o.CustomerID
GROUP BY c.CustomerID, c.FirstName, c.LastName
ORDER BY SUM(o.TotalAmount) DESC
LIMIT 1;

SELECT c.CustomerID, c.FirstName, c.LastName, o.OrderID, SUM(o.TotalAmount) AS OrderTotal
FROM Customers c
JOIN Orders o ON c.CustomerID = o.CustomerID
GROUP BY c.CustomerID, c.FirstName, c.LastName, o.OrderID
ORDER BY OrderTotal DESC;

WITH CustomerTotalOrders AS (
    SELECT c.CustomerID, c.FirstName, c.LastName, SUM(o.TotalAmount) AS TotalOrders
    FROM Customers c
    JOIN Orders o ON c.CustomerID = o.CustomerID
    GROUP BY c.CustomerID, c.FirstName, c.LastName
)

SELECT CustomerID, FirstName, LastName, TotalOrders
FROM CustomerTotalOrders
WHERE TotalOrders > (
    SELECT AVG(TotalOrders)
    FROM CustomerTotalOrders
);
