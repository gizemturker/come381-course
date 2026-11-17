-- ============================================================================
-- COME 381 - Odev 2 / Bolum D: Iliskisel Cebir Sorgularinin SQL Karsiliklari
-- ============================================================================

-- ----------------------------------------------------------------------------
-- D1 | Selection (sigma) ve Projection (pi)
-- Soru: Kontenjani (quota) 15'ten buyuk olan atolyelerin basliklari, kategorileri ve ucretleri
-- ----------------------------------------------------------------------------
SELECT title, category, fee
FROM workshop
WHERE quota > 15
ORDER BY workshop_id;

-- ----------------------------------------------------------------------------
-- D2 | Join (bowtie)
-- Soru: Her atolye kaydinin kursiyer adi, atolye basligi ve katilim durumu
-- ----------------------------------------------------------------------------
SELECT s.full_name AS student_name,
       w.title AS workshop_title,
       e.attendance_status
FROM enrollment e
JOIN student s ON s.student_id = e.student_id
JOIN workshop w ON w.workshop_id = e.workshop_id
ORDER BY e.enrollment_id
LIMIT 10;

-- ----------------------------------------------------------------------------
-- D3 | Union (cup)
-- Soru: Ya 'ceramics' (seramik) ya da 'photography' (fotografcilik) kategorisindeki
--       bir atolyeye kaydolmus kursiyerlerin ID ve adlari
-- ----------------------------------------------------------------------------
SELECT s.student_id, s.full_name
FROM student s
JOIN enrollment e ON e.student_id = s.student_id
JOIN workshop w ON w.workshop_id = e.workshop_id
WHERE w.category = 'ceramics'
UNION
SELECT s.student_id, s.full_name
FROM student s
JOIN enrollment e ON e.student_id = s.student_id
JOIN workshop w ON w.workshop_id = e.workshop_id
WHERE w.category = 'photography'
ORDER BY student_id;

-- ----------------------------------------------------------------------------
-- D4 (Yol 1 - EXCEPT) | Difference (-)
-- Soru: Hicbir atolyeye kaydolmamis kursiyerlerin ID ve adlari
-- ----------------------------------------------------------------------------
SELECT s.student_id, s.full_name
FROM student s
EXCEPT
SELECT s.student_id, s.full_name
FROM student s
JOIN enrollment e ON e.student_id = s.student_id
ORDER BY student_id;

-- ----------------------------------------------------------------------------
-- D4 (Yol 2 - NOT EXISTS) | Difference (-)
-- Soru: Hicbir atolyeye kaydolmamis kursiyerlerin ID ve adlari
-- ----------------------------------------------------------------------------
SELECT s.student_id, s.full_name
FROM student s
WHERE NOT EXISTS (
    SELECT 1
    FROM enrollment e
    WHERE e.student_id = s.student_id
)
ORDER BY s.student_id;

-- ----------------------------------------------------------------------------
-- D5 | Rename (rho) ile tablonun kendisiyle join'i (Self-Join)
-- Soru: Ayni sehirde yasayan farkli kursiyer ciftleri
-- ----------------------------------------------------------------------------
SELECT s1.city,
       s1.full_name AS student_1,
       s2.full_name AS student_2
FROM student s1
JOIN student s2
  ON s1.city = s2.city
 AND s1.student_id < s2.student_id
ORDER BY s1.city, s1.student_id, s2.student_id;

-- ----------------------------------------------------------------------------
-- D6 | Division (div)
-- Soru: 'ceramics' (seramik) kategorisindeki TUM atolyelere kaydolmus kursiyerlerin ID ve adlari
-- Yontem: Ic ice iki NOT EXISTS (Evrensel niceleme: katilmadigi hicbir seramik atolyesi olmayan kursiyerler)
-- ----------------------------------------------------------------------------
SELECT s.student_id, s.full_name
FROM student s
WHERE NOT EXISTS (
    SELECT 1
    FROM workshop w
    WHERE w.category = 'ceramics'
      AND NOT EXISTS (
          SELECT 1
          FROM enrollment e
          WHERE e.student_id = s.student_id
            AND e.workshop_id = w.workshop_id
      )
)
ORDER BY s.student_id;
