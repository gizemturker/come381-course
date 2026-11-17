-- D1: Kapasitesi 50'den buyuk etkinliklerin adlari.
SELECT DISTINCT title
FROM event
WHERE capacity > 50
ORDER BY title;

-- D2: Spor kategorisindeki etkinlik kayitlarinin uye ve etkinlik adlari.
SELECT DISTINCT m.full_name, e.title
FROM event_registration er
JOIN member m ON m.member_id = er.member_id
JOIN event e ON e.event_id = er.event_id
JOIN category c ON c.category_id = e.category_id
WHERE c.name = 'Sports'
ORDER BY m.full_name, e.title;

-- D3: Spor veya Arts kategorisindeki en az bir etkinlige katilmis uyeler.
SELECT m.member_id, m.full_name
FROM member m
JOIN event_registration er ON er.member_id = m.member_id
JOIN event e ON e.event_id = er.event_id
JOIN category c ON c.category_id = e.category_id
WHERE c.name = 'Sports'
UNION
SELECT m.member_id, m.full_name
FROM member m
JOIN event_registration er ON er.member_id = m.member_id
JOIN event e ON e.event_id = er.event_id
JOIN category c ON c.category_id = e.category_id
WHERE c.name = 'Arts'
ORDER BY member_id;

-- D4a: Hicbir etkinlige kaydolmamis uyeler - EXCEPT.
SELECT member_id, full_name
FROM member
EXCEPT
SELECT m.member_id, m.full_name
FROM member m
JOIN event_registration er ON er.member_id = m.member_id
ORDER BY member_id;

-- D4b: Hicbir etkinlige kaydolmamis uyeler - NOT EXISTS.
SELECT m.member_id, m.full_name
FROM member m
WHERE NOT EXISTS (
    SELECT 1
    FROM event_registration er
    WHERE er.member_id = m.member_id
)
ORDER BY m.member_id;

-- D5: Ayni sehirde yasayan farkli uye ciftleri.
SELECT
    m1.member_id AS member1_id,
    m1.full_name AS member1_name,
    m2.member_id AS member2_id,
    m2.full_name AS member2_name,
    m1.city
FROM member m1
JOIN member m2
  ON m1.city = m2.city
 AND m1.member_id < m2.member_id
ORDER BY m1.city, m1.member_id, m2.member_id;

-- D6: Sports kategorisindeki tum etkinliklere katilmis uyeler.
-- Cift NOT EXISTS, "her Sports etkinligi icin eksik kayit yok" mantigini dogrudan ifade eder.
SELECT m.member_id, m.full_name
FROM member m
WHERE NOT EXISTS (
    SELECT 1
    FROM event e
    JOIN category c ON c.category_id = e.category_id
    WHERE c.name = 'Sports'
      AND NOT EXISTS (
          SELECT 1
          FROM event_registration er
          WHERE er.member_id = m.member_id
            AND er.event_id = e.event_id
      )
)
ORDER BY m.member_id;
