\set VERBOSITY verbose
BEGIN;

-- İlk fiyatları göster
SELECT name, price
FROM product
WHERE category = 'Sıcak İçecek';

-- İçecek fiyatlarına 5 TL ekle
UPDATE product
SET price = price + 5
WHERE category = 'Sıcak İçecek';

-- Yeni fiyatları göster
SELECT name, price
FROM product
WHERE category = 'Sıcak İçecek';

-- Sistemde olmayan ürünü eklemeyi dene
INSERT INTO order_item (order_id, product_id, quantity)
VALUES (1, 999, 1);

ROLLBACK;

-- Fiyatların eski halini kontrol et
SELECT name, price
FROM product
WHERE category = 'Sıcak İçecek';
