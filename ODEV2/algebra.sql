-- Bölüm D: ilişkisel cebir sorularının SQL karşılıkları.
-- Önce seed.sql çalıştırılmış olmalı.

-- D1 | σ ve π: 1950'den önce yayımlanmış kitapların adları
SELECT DISTINCT title
FROM book
WHERE publication_year < 1950
ORDER BY title;

-- D2 | ⋈: 1 Mayıs 2026 ve sonrasında ödünç alınan kitaplar için üye adı ve kitap adı
SELECT DISTINCT m.full_name, b.title
FROM loan l
JOIN member    m  ON m.member_id = l.member_id
JOIN book_copy bc ON bc.copy_id  = l.copy_id
JOIN book      b  ON b.book_id   = bc.book_id
WHERE l.loan_date >= DATE '2026-05-01'
ORDER BY m.full_name, b.title;

-- D3 | ∪: Orhan Pamuk'un ya da Elif Safak'ın bir kitabını ödünç almış üyeler
SELECT m.full_name
FROM member m
JOIN loan l        ON l.member_id = m.member_id
JOIN book_copy bc  ON bc.copy_id  = l.copy_id
JOIN book_author ba ON ba.book_id = bc.book_id
JOIN author a      ON a.author_id = ba.author_id
WHERE a.full_name = 'Orhan Pamuk'
UNION
SELECT m.full_name
FROM member m
JOIN loan l        ON l.member_id = m.member_id
JOIN book_copy bc  ON bc.copy_id  = l.copy_id
JOIN book_author ba ON ba.book_id = bc.book_id
JOIN author a      ON a.author_id = ba.author_id
WHERE a.full_name = 'Elif Safak'
ORDER BY 1;

-- D4 | −: Hiçbir kitap ödünç almamış üyeler (yol 1: EXCEPT)
SELECT member_id, full_name
FROM member
WHERE member_id IN (
    SELECT member_id FROM member
    EXCEPT
    SELECT member_id FROM loan
)
ORDER BY member_id;

-- D4 | −: aynı soru (yol 2: NOT EXISTS)
SELECT m.member_id, m.full_name
FROM member m
WHERE NOT EXISTS (
    SELECT 1 FROM loan l WHERE l.member_id = m.member_id
)
ORDER BY m.member_id;

-- D5 | ρ ve kendisiyle join: aynı ülkeden farklı yazar çiftleri
SELECT a1.full_name AS author_1, a2.full_name AS author_2, a1.country
FROM author a1
JOIN author a2
  ON a1.country = a2.country
 AND a1.author_id < a2.author_id
ORDER BY a1.country, a1.author_id, a2.author_id;

-- D6 | ÷: Sabahattin Ali'nin TÜM kitaplarını ödünç almış üyeler
-- (iç içe iki NOT EXISTS: "Ali'nin öyle bir kitabı yok ki, bu üye onu almamış olsun")
SELECT m.member_id, m.full_name
FROM member m
WHERE NOT EXISTS (
    SELECT 1
    FROM book_author ba
    JOIN author a ON a.author_id = ba.author_id
    WHERE a.full_name = 'Sabahattin Ali'
      AND NOT EXISTS (
          SELECT 1
          FROM loan l
          JOIN book_copy bc ON bc.copy_id = l.copy_id
          WHERE l.member_id = m.member_id
            AND bc.book_id  = ba.book_id
      )
)
ORDER BY m.member_id;
