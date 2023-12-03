SELECT c.FirstName, c.LastName
FROM Customers c
JOIN (
    SELECT CustomerID, SUM(TotalAmount) AS TotalOrderAmount
    FROM Orders
    GROUP BY CustomerID
) AS topCustomers ON c.CustomerID = topCustomers.CustomerID
WHERE TotalOrderAmount = (
    SELECT MAX(TotalOrderAmount)
    FROM (
        SELECT SUM(TotalAmount) AS TotalOrderAmount
        FROM Orders
        GROUP BY CustomerID
    ) AS maxOrderAmounts
);


WITH RankedOrders AS (
    SELECT
        c.CustomerID,
        c.FirstName,
        c.LastName,
        o.OrderID,
        SUM(o.TotalAmount) OVER (PARTITION BY c.CustomerID) AS TotalOrderAmount
    FROM
        Customers c
    JOIN Orders o ON c.CustomerID = o.CustomerID
)

SELECT
    CustomerID,
    FirstName,
    LastName,
    OrderID,
    TotalOrderAmount
FROM
    RankedOrders
ORDER BY
    CustomerID, TotalOrderAmount DESC, OrderID;


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
