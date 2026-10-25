-- D1: Kapasitesi 5'ten büyük staj ilanları.
SELECT title, capacity
FROM internship
WHERE capacity > 5;

-- D2: Öğrencilerin başvurdukları staj ilanları.
SELECT s.full_name, i.title
FROM student s
JOIN application a ON s.student_id = a.student_id
JOIN internship i ON a.internship_id = i.internship_id;

-- D3: Teknoloji veya finans şirketlerine başvuran öğrenciler (UNION).
SELECT s.student_id, s.full_name
FROM student s
WHERE s.student_id IN (
    SELECT a.student_id
    FROM application a
    JOIN internship i ON a.internship_id = i.internship_id
    JOIN company c ON i.company_id = c.company_id
    WHERE c.industry = 'technology'
    UNION
    SELECT a.student_id
    FROM application a
    JOIN internship i ON a.internship_id = i.internship_id
    JOIN company c ON i.company_id = c.company_id
    WHERE c.industry = 'finance'
);

-- D3 ek: Hem teknoloji hem finans şirketlerine başvuran öğrenciler (INTERSECT).
SELECT a.student_id
FROM application a
JOIN internship i ON a.internship_id = i.internship_id
JOIN company c ON i.company_id = c.company_id
WHERE c.industry = 'technology'
INTERSECT
SELECT a.student_id
FROM application a
JOIN internship i ON a.internship_id = i.internship_id
JOIN company c ON i.company_id = c.company_id
WHERE c.industry = 'finance';

-- D4: Hiç başvuru yapmamış öğrenciler (EXCEPT).
SELECT student_id, full_name
FROM student
EXCEPT
SELECT s.student_id, s.full_name
FROM student s
JOIN application a ON s.student_id = a.student_id;

-- D4 ek: Aynı sonuç (NOT EXISTS).
SELECT s.student_id, s.full_name
FROM student s
WHERE NOT EXISTS (
    SELECT 1
    FROM application a
    WHERE a.student_id = s.student_id
);

-- D5: Aynı şehirde yaşayan farklı öğrenci çiftleri (self-join).
SELECT s1.full_name AS student_one,
       s2.full_name AS student_two,
       s1.city
FROM student s1
JOIN student s2
  ON s1.city = s2.city
 AND s1.student_id < s2.student_id;

-- D6: Sportly şirketinin bütün stajlarına başvuran öğrenciler.
SELECT s.student_id, s.full_name
FROM student s
WHERE NOT EXISTS (
    SELECT 1
    FROM internship i
    JOIN company c ON c.company_id = i.company_id
    WHERE c.company_name = 'Sportly'
      AND NOT EXISTS (
          SELECT 1
          FROM application a
          WHERE a.student_id = s.student_id
            AND a.internship_id = i.internship_id
      )
);