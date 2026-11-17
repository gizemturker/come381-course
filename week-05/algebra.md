# Bölüm D: İlişkisel Cebir ve Hesap (`algebra.md`)

Veteriner Kliniği Evcil Hayvan ve Aşı/Tedavi Takip Sistemi şeması üzerinde hazırlanan altı ilişkisel cebir sorgusu, ilişkisel hesap ifadeleri, `DISTINCT` açıklamaları ve `psql` sonuçları aşağıdadır.

---

## D1: Seçim (σ) ve İzdüşüm (π)

1. **Sorunun Türkçesi:** Ağırlığı (`weight_kg`) 10 kg'dan fazla olan evcil hayvanların adlarını, türlerini ve kilolarını getir.
2. **İlişkisel Cebir İfadesi:**
   ```text
   π pet_name, species, weight_kg ( σ weight_kg > 10 (pet) )
   ```
   **İlişkisel Hesap (Tuple Relational Calculus) İfadesi:**
   ```text
   { t.pet_name, t.species, t.weight_kg | pet(t) ∧ t.weight_kg > 10 }
   ```
3. **SQL Karşılığı (`algebra.sql`):**
   ```sql
   SELECT pet_name, species, weight_kg
   FROM pet
   WHERE weight_kg > 10
   ORDER BY pet_id;
   ```
4. **Sonuç:**
   ```text
    pet_name | species | weight_kg 
   ----------+---------+-----------
    Karamel  | dog     |     14.50
    Cesur    | dog     |     22.00
    Pasa     | dog     |     18.30
   (3 rows)
   ```
- **`DISTINCT` Notu:** `pet` tablosundaki her hayvanın adı ve kilosu bu veri setinde farklı olduğu için tekrar eden satır oluşmaz; ancak aynı isim, tür ve kiloda iki farklı hayvan bulunabilseydi küme semantiğini korumak için `DISTINCT` gerekirdi.

---

## D2: Birleştirme (⋈ Join)

1. **Sorunun Türkçesi:** Uygulanan her tıbbi işlemin hayvan adını (`pet_name`), işlem adını (`treatment_name`) ve ziyaret tarihini (`visit_date`) listele.
2. **İlişkisel Cebir İfadesi:**
   ```text
   π p.pet_name, t.treatment_name, pt.visit_date (
       ρ pt (pet_treatment)
       ⋈ pt.pet_id = p.pet_id ρ p (pet)
       ⋈ pt.treatment_id = t.treatment_id ρ t (treatment)
   )
   ```
3. **SQL Karşılığı (`algebra.sql`):**
   ```sql
   SELECT p.pet_name,
          t.treatment_name,
          pt.visit_date
   FROM pet_treatment pt
   JOIN pet p ON p.pet_id = pt.pet_id
   JOIN treatment t ON t.treatment_id = pt.treatment_id
   ORDER BY pt.record_id
   LIMIT 10;
   ```
4. **Sonuç (İlk 10 Satır):**
   ```text
    pet_name |        treatment_name         | visit_date 
   ----------+-------------------------------+------------
    Boncuk   | Kuduz Asisi                   | 2026-02-10
    Boncuk   | Karma Koruma Asisi            | 2026-02-24
    Boncuk   | ViralBagisiklik Asisi         | 2026-03-10
    Boncuk   | Ultrasonik Dis Tasi Temizligi | 2026-03-20
    Karamel  | Kuduz Asisi                   | 2026-02-12
    Karamel  | Karma Koruma Asisi            | 2026-02-26
    Karamel  | ViralBagisiklik Asisi         | 2026-03-12
    Karamel  | Ic ve Dis Parazit Uygulamasi  | 2026-03-25
    Pamuk    | Kuduz Asisi                   | 2026-02-15
    Pamuk    | Karma Koruma Asisi            | 2026-03-01
   (10 rows)
   ```
- **`DISTINCT` Notu:** `pet_treatment` tablosunda `(pet_id, treatment_id)` üzerinde `uq_pet_treatment_pet_treatment` tekillik kısıtı bulunduğu için aynı hayvana aynı işlem iki kez girilemez; bu nedenle `DISTINCT` gerekli değildir.

---

## D3: Kesişim (∩ Intersection)

1. **Sorunun Türkçesi:** Hem `'core_vaccine'` (temel aşı) hem de `'dental'` (diş bakımı) işlemi uygulanmış evcil hayvanların ID ve adlarını listele.
2. **İlişkisel Cebir İfadesi:**
   ```text
   π pet_id, pet_name ( pet ⋈ pet_treatment ⋈ σ treatment_type = 'core_vaccine' (treatment) )
   ∩
   π pet_id, pet_name ( pet ⋈ pet_treatment ⋈ σ treatment_type = 'dental' (treatment) )
   ```
3. **SQL Karşılığı (`algebra.sql`):**
   ```sql
   SELECT p.pet_id, p.pet_name
   FROM pet p
   JOIN pet_treatment pt ON pt.pet_id = p.pet_id
   JOIN treatment t ON t.treatment_id = pt.treatment_id
   WHERE t.treatment_type = 'core_vaccine'
   INTERSECT
   SELECT p.pet_id, p.pet_name
   FROM pet p
   JOIN pet_treatment pt ON pt.pet_id = p.pet_id
   JOIN treatment t ON t.treatment_id = pt.treatment_id
   WHERE t.treatment_type = 'dental'
   ORDER BY pet_id;
   ```
4. **Sonuç:**
   ```text
    pet_id | pet_name 
   --------+----------
         1 | Boncuk
         3 | Pamuk
         4 | Cesur
   (3 rows)
   ```
- **`DISTINCT` Notu:** Bir hayvan birden fazla temel aşı almış olsa bile SQL'deki `INTERSECT` operatörü küme kesişimi uygular ve tekrar eden satırları kendiliğinden temizler; dolayısıyla `DISTINCT` yazmaya gerek yoktur.

---

## D4: Fark (− Difference)

1. **Sorunun Türkçesi:** Hiçbir tıbbi işlem veya aşı kaydı bulunmayan evcil hayvanların ID ve adlarını listele.
2. **İlişkisel Cebir İfadesi:**
   ```text
   π pet_id, pet_name (pet) − π pet_id, pet_name (pet ⋈ pet_treatment)
   ```
   **İlişkisel Hesap (Tuple Relational Calculus) İfadesi:**
   ```text
   { p.pet_id, p.pet_name | pet(p) ∧ ¬∃pt (pet_treatment(pt) ∧ pt.pet_id = p.pet_id) }
   ```
3. **SQL Karşılığı (`algebra.sql` — İki Yol):**
   ```sql
   -- Yol 1: EXCEPT ile
   SELECT p.pet_id, p.pet_name
   FROM pet p
   EXCEPT
   SELECT p.pet_id, p.pet_name
   FROM pet p
   JOIN pet_treatment pt ON pt.pet_id = p.pet_id
   ORDER BY pet_id;

   -- Yol 2: NOT EXISTS ile
   SELECT p.pet_id, p.pet_name
   FROM pet p
   WHERE NOT EXISTS (
       SELECT 1
       FROM pet_treatment pt
       WHERE pt.pet_id = p.pet_id
   )
   ORDER BY p.pet_id;
   ```
4. **Sonuç:**
   ```text
    pet_id | pet_name 
   --------+----------
         7 | Mavi
         8 | Tarcin
   (2 rows)
   ```
- **`DISTINCT` Notu:** `EXCEPT` küme farkı aldığı için tekrarları otomatik eler; `NOT EXISTS` ise birincil anahtarı (`pet_id`) olan `pet` tablosunu doğrudan filtrelediği için `DISTINCT` gerekli değildir.

---

## D5: Yeniden Adlandırma (ρ Rename) ile Öz-Birleştirme

1. **Sorunun Türkçesi:** Aynı ilçede (`district`) ikamet eden farklı hayvan sahibi çiftlerini listele.
2. **İlişkisel Cebir İfadesi:**
   ```text
   π o1.district, o1.full_name, o2.full_name (
       σ o1.district = o2.district ∧ o1.owner_id < o2.owner_id (
           ρ o1 (pet_owner) × ρ o2 (pet_owner)
       )
   )
   ```
3. **SQL Karşılığı (`algebra.sql`):**
   ```sql
   SELECT o1.district,
          o1.full_name AS owner_1,
          o2.full_name AS owner_2
   FROM pet_owner o1
   JOIN pet_owner o2
     ON o1.district = o2.district
    AND o1.owner_id < o2.owner_id
   ORDER BY o1.district, o1.owner_id, o2.owner_id;
   ```
4. **Sonuç:**
   ```text
    district |    owner_1    |   owner_2    
   ----------+---------------+--------------
    Besiktas | Seda Yildirim | Ozan Guler
    Kadikoy  | Deniz Karaca  | Baris Aydin
    Uskudar  | Pelin Mutlu   | Kaan Bozkurt
   (3 rows)
   ```
- **`DISTINCT` Notu:** `o1.owner_id < o2.owner_id` koşulu her iki tablodaki birincil anahtarları sıralı eşleştirdiği için aynı sahip çifti yalnızca bir kez üretilir; `DISTINCT` gerekmez.

---

## D6: Bölme (÷ Division)

1. **Sorunun Türkçesi:** `'core_vaccine'` (temel aşı) grubundaki **tüm** aşıları tamamlanmış evcil hayvanların ID ve adlarını listele.
2. **İlişkisel Cebir İfadesi:**
   ```text
   ( π pet_id, treatment_id (pet_treatment) ÷ π treatment_id ( σ treatment_type = 'core_vaccine' (treatment) ) )
   ⋈ π pet_id, pet_name (pet)
   ```
3. **Seçilen Yöntem ve SQL Karşılığı (`algebra.sql`):**
   Evrensel nicelemeyi ("yapılmamış hiçbir temel aşısı kalmayan hayvanlar") doğrudan ifade ettiği ve diğer tedavi türlerindeki kayıt sayılarından etkilenmediği için iç içe iki `NOT EXISTS` yöntemini tercih ettim:
   ```sql
   SELECT p.pet_id, p.pet_name
   FROM pet p
   WHERE NOT EXISTS (
       SELECT 1
       FROM treatment t
       WHERE t.treatment_type = 'core_vaccine'
         AND NOT EXISTS (
             SELECT 1
             FROM pet_treatment pt
             WHERE pt.pet_id = p.pet_id
               AND pt.treatment_id = t.treatment_id
         )
   )
   ORDER BY p.pet_id;
   ```
4. **Sonuç:**
   ```text
    pet_id | pet_name 
   --------+----------
         1 | Boncuk
         2 | Karamel
   (2 rows)
   ```
- **`DISTINCT` Notu:** Dış sorgu `pet` tablosundan `pet_id` birincil anahtarıyla seçim yaptığı için her hayvan en fazla bir kez listelenir; `DISTINCT` gerekli değildir. (`seed.sql` içindeki "neredeyse" aday olan `Pamuk (pet_id = 3)`, 3 temel aşıdan yalnızca 2'sini aldığı için sonuçtan elenmiştir.)
