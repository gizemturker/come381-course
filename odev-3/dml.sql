\set VERBOSITY verbose
BEGIN;

-- Önce: Sıcak İçecek fiyatları
SELECT name, price FROM product WHERE category = 'Sıcak İçecek' ORDER BY product_id;

-- Komut 1: 'Sıcak İçecek' ürünlerinin fiyatını 5 TL artır
UPDATE product
SET price = price + 5
WHERE category = 'Sıcak İçecek';

-- Sonra: Sıcak İçecek fiyatları (yukarıdaki SELECT'in aynısı)
SELECT name, price FROM product WHERE category = 'Sıcak İçecek' ORDER BY product_id;

-- Komut 2: Var olmayan 999 numaralı ürünü bir siparişe ekle (hata verecek)
INSERT INTO order_item (order_id, product_id, quantity)
VALUES (2, 999, 2);

ROLLBACK;

-- ROLLBACK sonrası: Sıcak İçecek fiyatları (yine aynı SELECT)
SELECT name, price FROM product WHERE category = 'Sıcak İçecek' ORDER BY product_id;
