USE Projects
 SELECT *
 FROM dbo.Amazon

 ---Change "Shipped - Delivered to Buyer" with Delivered  and "Shipped - Rejected by Buyer" with "Rejected -----
 UPDATE dbo.Amazon
 SET Status = REPLACE(Status,'Shipped - Delivered to Buyer','Delivered')
 UPDATE dbo.Amazon
 SET Status = REPLACE(Status,'Shipped - Rejected by Buyer','Rejected')
 UPDATE dbo.Amazon
 SET Status = REPLACE(Status,'Shipped - Returned to Seller','Returned')

 -----Use only shipped delivered cancelled,pending and rejected, DELETE THE REST-----

DELETE 
FROM dbo.Amazon
WHERE Status = 'Pending'

---DELETE rows with Quantity = 0 -----
DELETE 
FROM dbo.Amazon
WHERE Qty = 0

---DELETE rows with Amount = 0 -----
DELETE 
FROM dbo.Amazon
WHERE Amount = 0

------Drop unnecessary columns -----
 SELECT *
 FROM dbo.Amazon

ALTER TABLE dbo.Amazon
DROP COLUMN promotion_ids

ALTER TABLE dbo.Amazon
DROP COLUMN fulfilled_by

ALTER TABLE dbo.Amazon
DROP COLUMN Unnamed_22

ALTER TABLE dbo.Amazon
DROP COLUMN currency

ALTER TABLE dbo.Amazon
DROP COLUMN Sales_Channel


----Rename Column B2B ----

ALTER TABLE dbo.Amazon
ALTER COLUMN BusinessType nvarchar(50)

---- Replace the values in BusinessType column with business and customer----
 UPDATE dbo.Amazon
 SET BusinessType = REPLACE(BusinessType,'1','Business')

 UPDATE dbo.Amazon
 SET BusinessType = REPLACE(BusinessType,'0','Customer')

 SELECT *
 FROM dbo.Amazon

 SELECT ship_city
 FROM dbo.Amazon
 WHERE ship_city = NULL


 