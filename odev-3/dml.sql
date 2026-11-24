\set VERBOSITY verbose
BEGIN;

-- İşlem öncesi sıcak içecek fiyatları
SELECT name, price
FROM product
WHERE category = 'Sıcak İçecek'
ORDER BY product_id;

-- Komut 1: Sıcak içeceklerin fiyatını 5 TL artır.
UPDATE product
SET price = price + 5
WHERE category = 'Sıcak İçecek';

-- Güncelleme sonrası fiyatlar
SELECT name, price
FROM product
WHERE category = 'Sıcak İçecek'
ORDER BY product_id;

-- Komut 2: Var olmayan 999 numaralı ürünü siparişe ekle.
INSERT INTO order_item (order_id, product_id, quantity)
VALUES (1, 999, 1);

-- Bütün değişiklikleri geri al.
ROLLBACK;

-- ROLLBACK sonrası fiyatları tekrar kontrol et.
SELECT name, price
FROM product
WHERE category = 'Sıcak İçecek'
ORDER BY product_id;