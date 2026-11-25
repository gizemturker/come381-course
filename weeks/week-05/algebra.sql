-- D1: 150 sayfadan uzun kitaplar
SELECT DISTINCT title
FROM book
WHERE pages > 150;

-- D2: Okuyucu ve kitap eşleşmeleri
SELECT DISTINCT r.full_name, b.title
FROM reader r
JOIN loan l ON r.reader_id = l.reader_id
JOIN book b ON b.book_id = l.book_id;

-- D3: Roman veya bilim kitabı alanlar
SELECT l.reader_id
FROM loan l
JOIN book b ON l.book_id = b.book_id
JOIN category c ON b.category_id = c.category_id
WHERE c.name = 'Roman'
UNION
SELECT l.reader_id
FROM loan l
JOIN book b ON l.book_id = b.book_id
JOIN category c ON b.category_id = c.category_id
WHERE c.name = 'Bilim';

-- D4: Hiç kitap almayanlar
SELECT reader_id FROM reader
EXCEPT
SELECT reader_id FROM loan;

-- D5: Aynı kategorideki farklı kitaplar
SELECT a.title, b.title
FROM book a
JOIN book b ON a.category_id = b.category_id
AND a.book_id < b.book_id;

-- D6: Bütün romanları alanlar
SELECT DISTINCT l.reader_id
FROM loan l
WHERE NOT EXISTS (
    SELECT 1 FROM book b
    JOIN category c ON b.category_id = c.category_id
    WHERE c.name = 'Roman'
    AND NOT EXISTS (
        SELECT 1 FROM loan x
        WHERE x.reader_id = l.reader_id
        AND x.book_id = b.book_id
    )
);

-- D4 alternatif çözüm
SELECT r.reader_id
FROM reader r
WHERE NOT EXISTS (
    SELECT 1 FROM loan l
    WHERE l.reader_id = r.reader_id
);
