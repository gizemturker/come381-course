-- Q1: Fiyatı 50 TL'den yüksek ürünleri pahalıdan ucuza sırala.
-- Ne işe yarar: Pahalı ürünleri tek listede görürüz.
SELECT name, price
FROM product
WHERE price > 50
ORDER BY price DESC;

-- Q2: YBS bölümündeki müşterileri alfabetik sırala.
-- Ne işe yarar: YBS öğrencilerinin isimlerini kolayca buluruz.
SELECT full_name
FROM customer
WHERE department = 'YBS'
ORDER BY full_name ASC;

-- Q3: Her siparişin numarasını, tarihini ve müşteri adını listele.
-- Ne işe yarar: Hangi siparişi kimin verdiğini görürüz.
SELECT o.order_id, o.order_date, c.full_name
FROM customer c
INNER JOIN orders o ON o.customer_id = c.customer_id
ORDER BY o.order_id;

-- Q4: Her sipariş kaleminin ürün adını ve adedini listele.
-- Ne işe yarar: Siparişlerde hangi üründen kaç tane olduğunu öğreniriz.
SELECT oi.order_id, p.name, oi.quantity
FROM product p
INNER JOIN order_item oi ON oi.product_id = p.product_id
ORDER BY oi.order_id, oi.product_id;

-- Q5: Her müşterinin sipariş sayısını bul.
-- Ne işe yarar: Hiç sipariş vermeyen müşterileri de görebiliriz.
SELECT c.full_name, COUNT(o.order_id) AS toplam_siparis
FROM orders o
RIGHT JOIN customer c ON c.customer_id = o.customer_id
GROUP BY c.customer_id, c.full_name
ORDER BY c.customer_id;

-- Q6: Her ürün kategorisinin ortalama fiyatını bul.
-- Ne işe yarar: Kategorilerin fiyatlarını karşılaştırabiliriz.
SELECT category, AVG(price) AS fiyat_ortalamasi
FROM product
GROUP BY category
ORDER BY category;
