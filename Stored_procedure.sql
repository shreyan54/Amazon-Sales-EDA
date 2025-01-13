/*
Final Task
-- Store Procedure
create a function as soon as the product is sold the the same quantity should reduced from inventory table
after adding any sales records it should update the stock in the inventory table based on the product and qty purchased
-- 
*/



CREATE OR REPLACE PROCEDURE addsales(
p_order_id INT,
p_customer_id INT,
p_seller_id INT,
p_order_item_id INT,
p_product_id INT,
p_quantity INT
) 

LANGUAGE plpgsql
AS $$

DECLARE
--all variables
v_count INT;
v_price FLOAT;
v_product VARCHAR(50);
BEGIN

SELECT 
	price,product_name
FROM products 
	INTO v_price,v_product
WHERE  product_id=p_quantity;

--checking stock and product availability in inventory
SELECT 
	COUNT(*)
	INTO v_count
FROM inventory
WHERE 
product_id=p_product_id
AND
stock>=p_quantity;

IF v_count>0 THEN
--add into orders and order_items table

	INSERT INTO orders(order_id,order_date,customer_id,seller_id)
	Values	(p_order_id, CURRENT_DATE, p_customer_id, p_seller_id);

-- adding into order list
	INSERT INTO order_items(order_item_id, order_id, product_id, quantity, price_per_unit, total_sale)
	VALUES(p_order_item_id, p_order_id, p_product_id, p_quantity, v_price, v_price*p_quantity);

--updating inventory
	UPDATE inventory
	SET stock = stock - p_quantity
	WHERE product_id = p_product_id;

	RAISE NOTICE 'Thankyou product: % sale has been added and stock inventory is updated',v_product;

ELSE 
RAISE NOTICE 'Thankyou for your info the product : % is not available ',v_product;

END IF;


END;
$$

call addsales
(25000,2,5,25001,1,40);