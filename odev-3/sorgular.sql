-- Q1: Fiyatı 50 TL'den yüksek ürünleri pahalıdan ucuza sırala.
-- Ne işe yarar: Kafe yöneticisinin yüksek fiyatlı ürünleri görerek menü fiyatlandırmasını ve kâr marjı yüksek kalemleri değerlendirmesine yarar.
SELECT name, category, price
FROM product
WHERE price > 50
ORDER BY price DESC;

-- Q2: 'YBS' bölümündeki müşterilerin adlarını alfabetik sırala.
-- Ne işe yarar: YBS bölümünden kafeye kayıtlı öğrencilerin yoklama veya bölüme özel kampanya listesini düzenli biçimde çıkarmaya yarar.
SELECT full_name
FROM customer
WHERE department = 'YBS'
ORDER BY full_name ASC;

-- Q3: Her siparişin numarasını, tarihini ve müşterinin adını listele.
-- Ne işe yarar: Hangi tarihte hangi müşterinin sipariş verdiğini tek tabloda takip ederek günlük satış akışını izlemeye yarar.
SELECT o.order_id, o.order_date, c.full_name
FROM orders o
INNER JOIN customer c ON c.customer_id = o.customer_id
ORDER BY o.order_id;

-- Q4: Her sipariş kaleminin ürün adını ve adedini listele.
-- Ne işe yarar: Siparişlerde hangi üründen kaç adet istendiğini görerek mutfak hazırlığını ve ürün bazlı tüketimi kontrol etmeye yarar.
SELECT oi.order_id, p.name, oi.quantity
FROM order_item oi
INNER JOIN product p ON p.product_id = oi.product_id
ORDER BY oi.order_id, oi.product_id;

-- Q5: Her müşterinin kaç sipariş verdiğini müşteri adıyla listele.
-- Ne işe yarar: Kafenin en sık alışveriş yapan sadık müşterilerini ve henüz hiç sipariş vermemiş kayıtlı müşterilerini tespit etmeye yarar.
SELECT c.full_name, COUNT(o.order_id) AS order_count
FROM customer c
LEFT JOIN orders o ON o.customer_id = c.customer_id
GROUP BY c.customer_id, c.full_name
ORDER BY order_count DESC, c.full_name ASC;

-- Q6: Her ürün kategorisinin ortalama fiyatını bul.
-- Ne işe yarar: Ürün kategorileri arasındaki fiyat seviyesini karşılaştırarak hangi grubun daha ekonomik veya daha maliyetli olduğunu görmeye yarar.
SELECT category, ROUND(AVG(price), 2) AS avg_price
FROM product
GROUP BY category
ORDER BY avg_price DESC;
