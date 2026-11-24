-- Q1: Fiyatı 50 TL'den yüksek ürünler.
-- Ne işe yarar: Pahalı ürünleri görmemizi sağlar.
SELECT name, price
FROM product
WHERE price > 50
ORDER BY price DESC;

-- Q2: YBS bölümündeki müşteriler.
-- Ne işe yarar: YBS öğrencilerini alfabetik listeler.
SELECT full_name
FROM customer
WHERE department = 'YBS'
ORDER BY full_name;

-- Q3: Sipariş numarası, tarihi ve müşteri adı.
-- Ne işe yarar: Siparişin kime ait olduğunu gösterir.
SELECT o.order_id, o.order_date, c.full_name
FROM orders o
INNER JOIN customer c
ON o.customer_id = c.customer_id;

-- Q4: Siparişlerdeki ürün adları ve adetleri.
-- Ne işe yarar: Hangi üründen kaç adet alındığını gösterir.
SELECT oi.order_id, p.name, oi.quantity
FROM order_item oi
INNER JOIN product p
ON oi.product_id = p.product_id;

-- Q5: Her müşterinin sipariş sayısı.
-- Ne işe yarar: Müşterilerin kaç sipariş verdiğini gösterir.
SELECT c.full_name, COUNT(o.order_id)
FROM customer c
LEFT JOIN orders o
ON c.customer_id = o.customer_id
GROUP BY c.customer_id, c.full_name;

-- Q6: Kategorilerin ortalama fiyatları.
-- Ne işe yarar: Kategorilerin fiyatlarını karşılaştırmayı sağlar.
SELECT category, AVG(price)
FROM product
GROUP BY category;
