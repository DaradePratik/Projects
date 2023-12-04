~~~ SQL
SELECT * from Data;
~~~ 
	
~~~ SQL	
--Total Revenue Generated
Select 
	 CAST(SUM(revenue_generated) as decimal(8,2)) as Revenue 
from Data 
;
~~~
| **Revenue**   |
|-----------|
| 577604.82 |

~~~ SQL
-- Revenue by Product Type
SELECT 
	 product_type,
	 CAST(SUM(revenue_generated) as DECIMAL(8,2)) AS Revenue 
FROM Data
Group by product_type 
order by Revenue DESC

~~~
| **Product Type** | **Revenue**   |
|--------------|-----------|
| skincare     | 241628.16 |
| haircare     | 174455.39 |
| cosmetics    | 161521.27 |

~~~ SQL
--Revenue by Location
SELECT 
	 location,
	 CAST(SUM(revenue_generated) as DECIMAL(8,2)) AS Revenue
from Data
Group by location
order by Revenue DESC
~~~
| **cocation**  | **Revenue**   |
|-----------|-----------|
| Mumbai    | 137755.03 |
| Kolkata   | 137077.55 |
| Chennai   | 119142.82 |
| Bangalore | 102601.72 |
| Delhi     | 81027.70  |
|           |           |

~~~SQL
--Revenue Contribution Percentage
SELECT location, 
	   CAST(SUM(revenue_generated) as DECIMAL(8,2)) AS Revenue,
	   CAST(SUM(revenue_generated)*100 / (SELECT SUM(revenue_generated) from Data) 
       AS DECIMAL(4,2)) as Revenue_percentage
from Data
Group by location
order by Revenue_percentage DESC
~~~
| **location**  | **Revenue**   | **Revenue_percentage** |
|-----------|-----------|-----------------------|
| Mumbai    | 137755.03 | 23.85                 |
| Kolkata   | 137077.55 | 23.73                 |
| Chennai   | 119142.82 | 20.63                 |
| Bangalore | 102601.72 | 17.76                 |
| Delhi     | 81027.7   | 14.03                 |
|           |           |                       |


~~~ SQL
--Order Quantities 
SELECT SUM(order_quantities) 'Order Quantities'
from Data
~~~
| **Order Quantities** |
|------------------|
| 4922             |
|                  |

~~~ SQL
--Order Quantites by Location
SELECT 
	 location,
	 SUM(order_quantities) 'Order Quantities'
From Data
GROUP by location
order by 'Order Quantities' DESC
~~~

| **location** | **Order Quantities** |
|-----------|------------------|
| Kolkata   | 1228             |
| Chennai   | 1109             |
| Mumbai    | 1083             |
| Bangalore | 769              |
| Delhi     | 733              |

~~~ SQL
--Cost of Manufacturing 
SELECT product_type,
	   cast(SUM(manufacturing_costs) as DECIMAL(8,2)) 'Manufacturing Costs'
FROM Data
group by product_type
order by 'Manufacturing Costs' DESC
;
~~~
| **product_type** | **Manufacturing costs** |
|--------------|---------------------|
| skincare     | 1959.73             |
| haircare     | 1647.57             |
| cosmetics    | 1119.37             |
|              |                     |

~~~ SQL
--Relation between manufacturing cost and selling price
SELECT 
	 product_type,
     CAST(SUM(price) As DECIMAL(6,2)) AS 'Selling Price',
     CAST(SUM(manufacturing_costs) AS DECIMAL(6,2)) AS 'Manufacturing Cost',
     CAST(SUM(price) - SUM(manufacturing_costs) AS DECIMAL(6,2)) AS 'Relation between Selling Price and Manufacturing costs'
from Data
group by product_type
~~~
| **product_type** | **Selling Price**   | **Manufacturing Cost** | **Relation between Selling Price and Manufacturing costs** |
|--------------|---------|---------------------|---------------------------------------------------|
| cosmetics    | 1491.39 | 1119.37             | 372.02                                            |
| haircare     | 1564.49 | 1647.57             | -83.09                                            |
| skincare     | 1890.37 | 1959.73             | -69.35                                            |
|              |         |                     |                                                   |

~~~ SQL
--Overall Profitability 
SELECT 
	  product_type,
	  CAST(SUM(revenue_generated) AS DECIMAL(8,2)) AS Revenue,
      CAST(SUM(costs) AS DECIMAL(82)) AS Cost,
      CAST(SUM(revenue_generated) - SUM(costs) AS DECIMAL(8,2)) AS Profit
FROM Data
GROUP BY product_type
;
~~~
| **product_type** | **Revenue**   | **Cost**  | **Profit**    |
|--------------|-----------|-------|-----------|
| cosmetics    | 161521.27 | 13365 | 148156.27 |
| haircare     | 174455.39 | 17330 | 157125.39 |
| skincare     | 241628.16 | 22229 | 219399.16 |

~~~ SQL
--Profit By Product 
SELECT 
      product_type, 
      CAST(SUM(revenue_generated) - SUM(costs) AS DECIMAL(8,2)) AS Profit
FROM Data
GROUP BY product_type
ORDER BY Profit DESC
;
~~~
| **product_type** | **Profit** |
|--------------|--------|
| skincare     | 219400 |
| haircare     | 157125 |
| cosmetics    | 148156 |

~~~ SQL
--Profit by Location
SELECT 
      location, 
      CAST(SUM(revenue_generated) - SUM(costs) AS DECIMAL(8,2)) AS Profit
FROM Data
GROUP BY location
ORDER BY Profit DESC
~~~
| **location**  | **Profit** |
|-----------|--------|
| Mumbai    | 128332 |
| Kolkata   | 124794 |
| Chennai   | 106707 |
| Bangalore | 92041  |
| Delhi     | 72807  |
|           |        |

~~~ SQL
--Profit by location with percentage contribution
SELECT
	 location,
     CAST(SUM(revenue_generated) - SUM(costs) AS DECIMAL(8,2)) AS Profit,
     CAST((SUM(revenue_generated) - SUM(costs))*100 / (SELECT (SUM(revenue_generated) - SUM(costs)) from Data) 
     as DECIMAL(4,2)) As Percentage
from Data
group by location
ORDER by Percentage DESC
;
~~~

| **location**  | **Profit** | **Percentage** |
|-----------|--------|----------------------|
| Mumbai    | 128332 | 24.46                |
| Kolkata   | 124794 | 23.78                |
| Chennai   | 106707 | 20.34                |
| Bangalore | 92041  | 17.54                |
| Delhi     | 72807  | 13.88                |


~~~ SQL
--Most Common Transport routes used
select
	 MAX(transportation_modes) As Most_Common_Transport_route
from Data
~~~
| **Most_Common_Transport_route** |
|----------------------|
| Sea                  |

~~~ SQL
--Corelation betweeen Transport route and cost
SELECT
	 transportation_modes,
     CAST(SUM(costs) AS INT) 'costs'
from Data
GROUP by transportation_modes
order by costs DESC
~~~
| **transportation_modes** | **costs**  |
|----------------------|-------|
| Road                 | 16047 |
| Rail                 | 15169 |
| Air                  | 14604 |
| Sea                  | 7102  |

~~~ SQL
--Most common route used 
SELECT
	 MAX(routes) AS 'Most Common Route'
from Data
~~~
| **Most Common Route**   |
|---------|
| Route C |

~~~ SQL
--Effect of routes on costs
SELECT
	 routes,
     SUM(costs) 'Cost'
from Data
GROUP by routes
~~~
| **Routes**  | **Cost**  |
|---------|-------|
| Route B | 22040 |
| Route A | 20875 |
| Route C | 10009 |

