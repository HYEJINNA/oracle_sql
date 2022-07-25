SELECT SUBSTR(a.sales_month, 1, 4)as years,
        a.employee_id,
        SUM(a.amount_sold)AS amount_sold
FROM sales a, 
     customers b,
     countries c
WHERE a.cust_id = b.CUST_ID 
  AND b.country_id = c.COUNTRY_ID
  AND c.country_name = 'Italy'
GROUP BY SUBSTR(a.sales_month, 1, 4), a.employee_id;


SELECT years, 
        MAX(amount_sold) AS max__sold
    FROM (SELECT SUBSTR(a.sales_month, 1,4) as years,
                    a.employee_id,
                    SUM(a.amount_sold) AS amount_sold
            FROM sales a,
                 customers b,
                 countries c
            WHERE a.cust_id = b.CUST_ID
                AND b.country_id = c.COUNTRY_ID
                AND c.country_name = 'Italy'
             GROUP BY SUBSTR(a.sales_month, 1, 4), a.employee_id
             )K
        GROUP BY years
        ORDER BY years;