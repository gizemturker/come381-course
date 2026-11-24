\set VERBOSITY verbose
\set ON_ERROR_STOP off
BEGIN;

-- Güncellemeden önce
SELECT name, price FROM product
WHERE category = 'Sıcak İçecek'
ORDER BY product_id;

-- Sıcak içeceklere 5 TL ekle
UPDATE product
SET price = price + 5
WHERE category = 'Sıcak İçecek';

-- Güncellemeden sonra
SELECT name, price FROM product
WHERE category = 'Sıcak İçecek'
ORDER BY product_id;

-- Olmayan ürünle yabancı anahtar deneyi
INSERT INTO order_item (order_id, product_id, quantity)
VALUES (3, 999, 1);

ROLLBACK;

-- Fiyatların eski halini kontrol et
SELECT name, price FROM product
WHERE category = 'Sıcak İçecek'
ORDER BY product_id;
