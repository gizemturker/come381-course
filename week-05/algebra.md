# Bölüm D: İlişkisel Cebir ve İlişkisel Hesap (`algebra.md`)

Bu belgede, Kültür ve Sanat Merkezi Atölye Yönetim Sistemi şeması üzerinde tanımlanan altı ilişkisel cebir sorusu (`D1`–`D6`), ilişkisel hesap (tuple relational calculus) ifadeleri, küme/çanta (`DISTINCT`) analizleri, SQL karşılıkları ve `seed.sql` verisi üzerinde çalıştırıldıklarında ürettikleri gerçek `psql` sonuçları yer almaktadır.

---

## D1 — Seçim ($\sigma$) ve İzdüşüm ($\pi$)

- **Sorunun Türkçesi:** Kontenjanı (`quota`) 15'ten büyük olan atölyelerin başlıklarını, kategorilerini ve ücretlerini listele.
- **İlişkisel Cebir İfadesi:**
  $$\pi_{\text{title, category, fee}}\left(\sigma_{\text{quota} > 15}(\text{workshop})\right)$$
- **İlişkisel Hesap (Tuple Relational Calculus) İfadesi:**
  $$\{\, t.\text{title}, t.\text{category}, t.\text{fee} \mid \text{workshop}(t) \land t.\text{quota} > 15 \,\}$$
- **Küme mi, Çanta mı (`DISTINCT` Gerekli mi?):** `workshop` tablosunda her satır farklı bir atölyeyi temsil eder ve senaryomuzda her atölyenin başlığı (`title`) tekildir; dolayısıyla $\pi_{\text{title, category, fee}}$ izdüşümü tekrar eden satır üretmediği için SQL sorgusunda `DISTINCT` kullanılmasına gerek yoktur (ancak aynı başlık, kategori ve ücrete sahip iki ayrı atölye açılabilseydi `DISTINCT` gerekirdi).
- **SQL Karşılığı (`algebra.sql`):**
  ```sql
  SELECT title, category, fee
  FROM workshop
  WHERE quota > 15
  ORDER BY workshop_id;
  ```
- **Çalıştırma Sonucu:**
  ```text
                title              |  category   |   fee   
  ---------------------------------+-------------+---------
   El Ile Seramik Sekillendirme    | ceramics    | 1400.00
   Suluboya Peyzaj Atolyesi        | painting    | 1200.00
   Sokak Fotografciligi Teknikleri | photography | 1600.00
   Dogaclama Tiyatro Mutbagi       | theater     | 1100.00
  (4 rows)
  ```

---

## D2 — Birleştirme ($\bowtie$ Join)

- **Sorunun Türkçesi:** Her atölye kaydının kursiyer adını (`student_name`), atölye başlığını (`workshop_title`) ve katılım durumunu (`attendance_status`) listele.
- **İlişkisel Cebir İfadesi:**
  $$\pi_{\text{s.full\_name, w.title, e.attendance\_status}}\left(\rho_e(\text{enrollment}) \bowtie_{e.\text{student\_id} = s.\text{student\_id}} \rho_s(\text{student}) \bowtie_{e.\text{workshop\_id} = w.\text{workshop\_id}} \rho_w(\text{workshop})\right)$$
- **Küme mi, Çanta mı (`DISTINCT` Gerekli mi?):** `enrollment` tablosunda `(student_id, workshop_id)` çifti üzerinde `uq_enrollment_student_workshop` tekillik kısıtı bulunduğu için aynı kursiyer aynı atölyeye yalnızca bir kez kaydolabilir; bu nedenle birleştirme sonucunda aynı `(full_name, title, attendance_status)` satırı tekrar etmeyeceğinden `DISTINCT` gerekli değildir.
- **SQL Karşılığı (`algebra.sql`):**
  ```sql
  SELECT s.full_name AS student_name,
         w.title AS workshop_title,
         e.attendance_status
  FROM enrollment e
  JOIN student s ON s.student_id = e.student_id
  JOIN workshop w ON w.workshop_id = e.workshop_id
  ORDER BY e.enrollment_id
  LIMIT 10;
  ```
- **Çalıştırma Sonucu (İlk 10 Satır):**
  ```text
   student_name |        workshop_title        | attendance_status 
  --------------+------------------------------+-------------------
   Ayse Kaya    | Temel Seramik Tornasi        | completed
   Ayse Kaya    | Ileri Seramik Sir Teknikleri | completed
   Ayse Kaya    | El Ile Seramik Sekillendirme | attended
   Ayse Kaya    | Suluboya Peyzaj Atolyesi     | completed
   Mert Demir   | Temel Seramik Tornasi        | completed
   Mert Demir   | Ileri Seramik Sir Teknikleri | completed
   Mert Demir   | El Ile Seramik Sekillendirme | attended
   Zeynep Celik | Temel Seramik Tornasi        | completed
   Zeynep Celik | Ileri Seramik Sir Teknikleri | completed
   Zeynep Celik | Suluboya Peyzaj Atolyesi     | completed
  (10 rows)
  ```

---

## D3 — Birleşim ($\cup$ Union)

- **Sorunun Türkçesi:** Ya `'ceramics'` (seramik) ya da `'photography'` (fotoğrafçılık) kategorisindeki en az bir atölyeye kaydolmuş kursiyerlerin ID ve adlarını listele.
- **İlişkisel Cebir İfadesi:**
  $$\pi_{\text{student\_id, full\_name}}\left(\text{student} \bowtie \text{enrollment} \bowtie \sigma_{\text{category} = \text{'ceramics'}}(\text{workshop})\right) \;\cup\; \pi_{\text{student\_id, full\_name}}\left(\text{student} \bowtie \text{enrollment} \bowtie \sigma_{\text{category} = \text{'photography'}}(\text{workshop})\right)$$
- **Küme mi, Çanta mı (`DISTINCT` Gerekli mi?):** Bir kursiyer birden fazla seramik atölyesine veya hem seramik hem fotoğrafçılık atölyesine katılmış olabilir (örneğin `Zeynep Celik` ve `Canan Yilmaz`). Ancak SQL'deki `UNION` operatörü (`UNION ALL` değil) küme birleşimi yaptığı ve tekrar eden satırları otomatik olarak elediği için ayrıca `DISTINCT` yazmaya gerek yoktur.
- **SQL Karşılığı (`algebra.sql`):**
  ```sql
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
  ```
- **Çalıştırma Sonucu:**
  ```text
   student_id |  full_name   
  ------------+--------------
            1 | Ayse Kaya
            2 | Mert Demir
            3 | Zeynep Celik
            4 | Burak Ozkan
            6 | Canan Yilmaz
  (5 rows)
  ```

---

## D4 — Fark ($-$ Difference)

- **Sorunun Türkçesi:** Hiçbir atölyeye kaydolmamış kursiyerlerin ID ve adlarını listele.
- **İlişkisel Cebir İfadesi:**
  $$\pi_{\text{student\_id, full\_name}}(\text{student}) \;-\; \pi_{\text{student\_id, full\_name}}(\text{student} \bowtie \text{enrollment})$$
- **İlişkisel Hesap (Tuple Relational Calculus) İfadesi:**
  $$\{\, s.\text{student\_id}, s.\text{full\_name} \mid \text{student}(s) \land \neg \exists e \, (\text{enrollment}(e) \land e.\text{student\_id} = s.\text{student\_id}) \,\}$$
- **Küme mi, Çanta mı (`DISTINCT` Gerekli mi?):** Birinci yolda kullanılan `EXCEPT` operatörü SQL'de küme farkı alır ve tekrarları kendiliğinden atar; ikinci yolda ise sorgu doğrudan `student` tablosu üzerinden birincil anahtar (`student_id`) içererek çalıştığı ve `NOT EXISTS` yalnızca üst satırı filtrelediği için `DISTINCT` gerekli değildir.
- **SQL Karşılığı — Yol 1 (`EXCEPT`):**
  ```sql
  SELECT s.student_id, s.full_name
  FROM student s
  EXCEPT
  SELECT s.student_id, s.full_name
  FROM student s
  JOIN enrollment e ON e.student_id = s.student_id
  ORDER BY student_id;
  ```
- **SQL Karşılığı — Yol 2 (`NOT EXISTS`):**
  ```sql
  SELECT s.student_id, s.full_name
  FROM student s
  WHERE NOT EXISTS (
      SELECT 1
      FROM enrollment e
      WHERE e.student_id = s.student_id
  )
  ORDER BY s.student_id;
  ```
- **Çalıştırma Sonucu (Her İki Yol İçin Aynı):**
  ```text
   student_id |  full_name   
  ------------+--------------
            7 | Emre Koc
            8 | Selin Arslan
  (2 rows)
  ```

---

## D5 — Yeniden Adlandırma ($\rho$ Rename) ile Öz-Birleştirme (Self-Join)

- **Sorunun Türkçesi:** Aynı şehirde (`city`) yaşayan farklı kursiyer çiftlerini listele.
- **İlişkisel Cebir İfadesi:**
  $$\pi_{s_1.\text{city},\; s_1.\text{full\_name},\; s_2.\text{full\_name}}\left(\sigma_{s_1.\text{city} = s_2.\text{city} \;\land\; s_1.\text{student\_id} < s_2.\text{student\_id}}\left(\rho_{s_1}(\text{student}) \times \rho_{s_2}(\text{student})\right)\right)$$
- **Küme mi, Çanta mı (`DISTINCT` Gerekli mi?):** `s1.student_id < s2.student_id` koşulu hem bir kursiyerin kendisiyle eşleşmesini (`(Ayse, Ayse)`) hem de simetrik tekrarı (`(Ayse, Mert)` ve `(Mert, Ayse)`) engeller; her kursiyer çifti benzersiz bir `(s1.student_id, s2.student_id)` anahtar ikilisine karşılık geldiğinden `DISTINCT` gerekli değildir.
- **SQL Karşılığı (`algebra.sql`):**
  ```sql
  SELECT s1.city,
         s1.full_name AS student_1,
         s2.full_name AS student_2
  FROM student s1
  JOIN student s2
    ON s1.city = s2.city
   AND s1.student_id < s2.student_id
  ORDER BY s1.city, s1.student_id, s2.student_id;
  ```
- **Çalıştırma Sonucu:**
  ```text
     city   |  student_1   |  student_2   
  ----------+--------------+--------------
   Ankara   | Zeynep Celik | Burak Ozkan
   Istanbul | Ayse Kaya    | Mert Demir
   Istanbul | Ayse Kaya    | Selin Arslan
   Istanbul | Mert Demir   | Selin Arslan
   Izmir    | Elif Sahin   | Canan Yilmaz
  (5 rows)
  ```

---

## D6 — Bölme ($\div$ Division)

- **Sorunun Türkçesi:** `'ceramics'` (seramik) kategorisindeki **tüm** atölyelere kaydolmuş kursiyerlerin ID ve adlarını listele.
- **İlişkisel Cebir İfadesi:**
  $$\left(\pi_{\text{student\_id, workshop\_id}}(\text{enrollment}) \;\div\; \pi_{\text{workshop\_id}}\left(\sigma_{\text{category} = \text{'ceramics'}}(\text{workshop})\right)\right) \bowtie \pi_{\text{student\_id, full\_name}}(\text{student})$$
- **Neden İç İçe İki `NOT EXISTS` Seçildi?**
  İlişkisel cebirdeki bölme ($\div$) işleminin mantıksal tanımı olan evrensel nicelemeyi ($\forall w \in W_{\text{ceramics}} \equiv \neg \exists w \in W_{\text{ceramics}} \neg \dots$) doğrudan ifade ettiği, diğer kategorilerdeki kayıtlardan veya mükerrer satır sayımlarından etkilenmediği için iç içe iki `NOT EXISTS` yöntemini seçtim.
- **Küme mi, Çanta mı (`DISTINCT` Gerekli mi?):** Dış sorgu doğrudan `student` tablosundaki satırları birincil anahtar (`student_id`) ile birlikte seçtiği ve `WHERE NOT EXISTS (...)` yalnızca bir filtre (yarı-birleştirme / anti-join) görevi gördüğü için her kursiyer en fazla bir kez döner; bu nedenle `DISTINCT` gerekli değildir.
- **SQL Karşılığı (`algebra.sql`):**
  ```sql
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
  ```
- **Çalıştırma Sonucu:**
  ```text
   student_id | full_name  
  ------------+------------
            1 | Ayse Kaya
            2 | Mert Demir
  (2 rows)
  ```
  *(Not: `seed.sql` içindeki "neredeyse" aday olan `Zeynep Celik (student_id = 3)`, 3 seramik atölyesinin 2'sine katılıp 3. seramik atölyesine (`workshop_id = 3`) katılmadığı için sorgu tarafından doğru şekilde elenmiştir.)*
