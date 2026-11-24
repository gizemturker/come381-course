-- Q1: Fiyatı 50 TL'den yüksek ürünleri pahalıdan ucuza sırala.
-- Ne işe yarar: 50 TL üzerindeki ürünleri en pahalıdan başlayarak görmeyi sağlar.

SELECT name, price
FROM product
WHERE price > 50
ORDER BY price DESC;
-- Q2: 'YBS' bölümündeki müşterilerin adlarını alfabetik sırala.
-- Ne işe yarar: YBS bölümündeki müşterileri isimlerine göre alfabetik olarak listeler.

SELECT full_name
FROM customer
WHERE department = 'YBS'
ORDER BY full_name ASC;
-- Q3: Her siparişin numarasını, tarihini ve müşterinin adını listele.
-- Ne işe yarar: Siparişleri hangi müşterinin verdiğini görmemizi sağlar.

SELECT
    o.order_id,
    o.order_date,
    c.full_name
FROM orders o
INNER JOIN customer c
    ON o.customer_id = c.customer_id
ORDER BY o.order_id;
-- Q4: Her sipariş kaleminin ürün adını ve adedini listele.
-- Ne işe yarar: Siparişlerde hangi ürünlerden kaç adet bulunduğunu gösterir.

SELECT
    p.name,
    oi.quantity
FROM order_item oi
INNER JOIN product p
    ON oi.product_id = p.product_id
ORDER BY oi.order_id, oi.product_id;
-- Q5: Her müşterinin kaç sipariş verdiğini müşteri adıyla listele.
-- Ne işe yarar: Her müşterinin sipariş sayısını gösterir ve hiç sipariş vermeyenleri de listeler.

SELECT
    c.full_name,
    COUNT(o.order_id) AS order_count
FROM customer c
LEFT JOIN orders o
    ON c.customer_id = o.customer_id
GROUP BY c.customer_id, c.full_name
ORDER BY c.full_name ASC;
-- Q6: Her ürün kategorisinin ortalama fiyatını bul.
-- Ne işe yarar: Kategorilere göre ortalama ürün fiyatlarını karşılaştırmayı sağlar.

SELECT
    category,
    AVG(price) AS average_price
FROM product
GROUP BY category
ORDER BY category ASC;