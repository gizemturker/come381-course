Relational Algebra Queries — Week 05



D1 — Staj kapasitesi 5'ten büyük olan ilanlar



Soru: Kapasitesi 5'ten büyük olan staj ilanlarının başlıklarını ve kapasitelerini bulun.



İlişkisel cebir:



\[

\\pi\_{title, capacity}(\\sigma\_{capacity > 5}(INTERNSHIP))

]



SQL: SELECT title, capacity FROM internship WHERE capacity > 5;



Beklenen sonuç: Software Developer Intern — 8.



DISTINCT: Gerekli değildir; her staj ilanının birincil anahtarı farklıdır ve her ilan bir kez listelenir.



D2 — Öğrenci ve başvurduğu staj ilanı



Soru: Başvuru yapan öğrencilerin adlarını ve başvurdukları staj ilanlarının başlıklarını listeleyin.



İlişkisel cebir:



\[

\\pi\_{full\_name, title}(STUDENT \\bowtie APPLICATION \\bowtie INTERNSHIP)

]



SQL: SELECT s.full\_name, i.title FROM student s JOIN application a ON s.student\_id = a.student\_id JOIN internship i ON a.internship\_id = i.internship\_id;



Beklenen sonuç: Ali Yilmaz — Software Developer Intern; Ali Yilmaz — Financial Analyst Intern; Ali Yilmaz — Sports Data Intern; diğer başvurular da listelenir.



DISTINCT: Gerekli değildir; her satır ayrı bir başvuru ilişkisini temsil eder.



D3 — Teknoloji veya finans sektörüne başvuran öğrenciler



Soru: Teknoloji veya finans şirketlerinin stajlarına başvuran öğrencileri bulun. UNION ve INTERSECT işlemlerini gösterin.



İlişkisel cebir:



\[

T \\cup F

]



Burada (T), teknoloji şirketlerine; (F), finans şirketlerine başvuran öğrenci kimliklerini ifade eder. Ortak öğrenciler için (T \\cap F) kesişimi de hesaplanabilir.



SQL:



SELECT s.student\_id, s.full\_name

FROM student s

WHERE s.student\_id IN (

&#x20;   SELECT a.student\_id

&#x20;   FROM application a

&#x20;   JOIN internship i ON a.internship\_id = i.internship\_id

&#x20;   JOIN company c ON i.company\_id = c.company\_id

&#x20;   WHERE c.industry = 'technology'

&#x20;   UNION

&#x20;   SELECT a.student\_id

&#x20;   FROM application a

&#x20;   JOIN internship i ON a.internship\_id = i.internship\_id

&#x20;   JOIN company c ON i.company\_id = c.company\_id

&#x20;   WHERE c.industry = 'finance'

);



Beklenen sonuç: Ali Yilmaz, Ayse Demir, Mehmet Kaya, Zeynep Aydin ve Emre Celik.



DISTINCT: UNION tekrarları otomatik kaldırır. Aynı öğrenci her iki sektöre de başvursa bile bir kez listelenir.



D4 — Hiç başvuru yapmayan öğrenciler



Soru: Hiçbir staj ilanına başvurmamış öğrencileri bulun.



İlişkisel cebir:



\\pi\_{student\_id, full\_name}(STUDENT \\bowtie APPLICATION)

]



SQL — EXCEPT:



SELECT student\_id, full\_name FROM student

EXCEPT

SELECT s.student\_id, s.full\_name

FROM student s

JOIN application a ON s.student\_id = a.student\_id;



SQL — NOT EXISTS:



SELECT s.student\_id, s.full\_name

FROM student s

WHERE NOT EXISTS (

&#x20;   SELECT 1

&#x20;   FROM application a

&#x20;   WHERE a.student\_id = s.student\_id

);



Beklenen sonuç: Elif Sahin.



DISTINCT: EXCEPT tekrarları kaldırır. NOT EXISTS de her öğrenci satırını bir kez döndürür; öğrenci kimliği birincil anahtardır.



Tuple Relational Calculus:



\[

{s \\mid STUDENT(s) \\land \\neg \\exists a (APPLICATION(a) \\land a.student\_id=s.student\_id)}

]



Bu ifade, kendisiyle eşleşen hiçbir başvuru kaydı bulunmayan öğrencileri seçer.



D5 — Aynı şehirde yaşayan öğrenci çiftleri



Soru: Aynı şehirde yaşayan, birbirinden farklı öğrenci çiftlerini bulun.



İlişkisel cebir:



\[

\\pi\_{S1.full\_name,S2.full\_name}

(\\sigma\_{S1.city=S2.city \\land S1.student\_id<S2.student\_id}

(\\rho\_{S1}(STUDENT)\\times\\rho\_{S2}(STUDENT)))

]



SQL:



SELECT s1.full\_name AS student\_one,

&#x20;      s2.full\_name AS student\_two,

&#x20;      s1.city

FROM student s1

JOIN student s2

&#x20; ON s1.city = s2.city

&#x20;AND s1.student\_id < s2.student\_id;



Beklenen sonuç: Ali Yilmaz — Mehmet Kaya (Istanbul); Ali Yilmaz — Elif Sahin (Istanbul); Mehmet Kaya — Elif Sahin (Istanbul); Ayse Demir — Emre Celik (Ankara).



DISTINCT: Gerekli değildir; student\_id < student\_id koşulu öğrencinin kendisiyle eşleşmesini ve çiftlerin ters sırada tekrar edilmesini önler.



D6 — Tüm spor şirketi stajlarına başvuran öğrenciler



Soru: Sportly şirketinin bütün staj ilanlarına başvuran öğrencileri bulun.



İlişkisel cebir: Bu sorgu bölme (division) işleminin mantığını kullanır. Öğrencinin, Sportly şirketinin ilan kümesindeki her ilana başvurmuş olması gerekir.



SQL — NOT EXISTS:



SELECT s.student\_id, s.full\_name

FROM student s

WHERE NOT EXISTS (

&#x20;   SELECT 1

&#x20;   FROM internship i

&#x20;   JOIN company c ON c.company\_id = i.company\_id

&#x20;   WHERE c.company\_name = 'Sportly'

&#x20;     AND NOT EXISTS (

&#x20;         SELECT 1

&#x20;         FROM application a

&#x20;         WHERE a.student\_id = s.student\_id

&#x20;           AND a.internship\_id = i.internship\_id

&#x20;     )

);



Beklenen sonuç: Ali Yilmaz.



DISTINCT: Gerekli değildir; öğrenci tablosundaki her öğrenci sorguda bir kez değerlendirilir ve her öğrenci en fazla bir kez döner.



Mantık: Ali Yilmaz, Sportly şirketinin iki ilanına da başvurmuştur. Diğer öğrencilerden hiçbiri iki ilana birden başvurmadığı için sonuçta yer almaz.

