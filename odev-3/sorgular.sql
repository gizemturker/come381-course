-- Q1: Fiyatı 50 TL'den yüksek ürünleri pahalıdan ucuza sırala.
-- Ne işe yarar: Menüdeki üst fiyat grubunda yer alan ürünleri belirleyip fiyat-performans veya indirim planlaması yapmaya yarar.
SELECT name, price
FROM product
WHERE price > 50
ORDER BY price DESC;

-- Q2: 'YBS' bölümündeki müşterilerin adlarını alfabetik sırala.
-- Ne işe yarar: Yönetim Bilişim Sistemleri bölümünde okuyan kafe müşterilerinin isim listesini düzenli şekilde görmeye yarar.
SELECT full_name
FROM customer
WHERE department = 'YBS'
ORDER BY full_name;

-- Q3: Her siparişin numarasını, tarihini ve müşterinin adını listele.
-- Ne işe yarar: Sipariş kayıtlarını müşteri isimleriyle eşleştirerek hangi siparişi kimin hangi günde verdiğini raporlamaya yarar.
SELECT o.order_id, o.order_date, c.full_name
FROM orders o
INNER JOIN customer c ON o.customer_id = c.customer_id
ORDER BY o.order_id;

-- Q4: Her sipariş kaleminin ürün adını ve adedini listele.
-- Ne işe yarar: Satılan ürünlerin sipariş kalemlerindeki dağılımını ve miktarlarını görerek stok takibi yapmaya yarar.
SELECT p.name, oi.quantity
FROM order_item oi
INNER JOIN product p ON oi.product_id = p.product_id
ORDER BY oi.order_id, p.product_id;

-- Q5: Her müşterinin kaç sipariş verdiğini müşteri adıyla listele.
-- Ne işe yarar: Sipariş veren müşterilerin kafeyi hangi sıklıkla kullandığını karşılaştırarak müşteri bağlılığını ölçmeye yarar.
SELECT c.full_name, COUNT(*) AS siparis_sayisi
FROM orders o
INNER JOIN customer c ON o.customer_id = c.customer_id
GROUP BY c.customer_id, c.full_name
ORDER BY siparis_sayisi DESC, c.full_name;

-- Q6: Her ürün kategorisinin ortalama fiyatını bul.
-- Ne işe yarar: Kategorilerin ortalama satış fiyatlarını hesaplayarak hangi ürün grubunun daha yüksek fiyatlı olduğunu analiz etmeye yarar.
SELECT category, AVG(price) AS ortalama_fiyat
FROM product
GROUP BY category
ORDER BY ortalama_fiyat DESC;
