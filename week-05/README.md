# Hafta 5 — Bütünlük Kısıtları, İhlal Testleri ve İlişkisel Cebir

## 1. Çalıştırma Sırası

Betikleri aşağıdaki sırayla çalıştırın (`violations.sql` tabloları `TRUNCATE` ile boşaltarak başladığı için `seed.sql` mutlaka ondan sonra çalıştırılmalıdır; Windows ortamında komutlara `-U postgres` ekleyin):

```bash
psql -d come381 -f sql/schema.sql
psql -d come381 -f week-05/constraints.sql
psql -d come381 -f week-05/violations.sql
psql -d come381 -f week-05/seed.sql
psql -d come381 -f week-05/algebra.sql
```

## 2. Bölüm B'deki `NULL` Testinin Açıklaması (`T25`)

`enrollment` tablosundaki `rating` sütununda `CHECK (rating BETWEEN 1 AND 5)` kısıtı (`chk_enrollment_rating_range`) bulunmasına rağmen `NOT NULL` kısıtı yoktur. `T25` testinde `rating` sütununa `NULL` eklendiğinde PostgreSQL işlemi reddetmez ve `INSERT 0 1` ile kabul eder; çünkü SQL'in üç değerli mantığında (`TRUE`, `FALSE`, `UNKNOWN`) `NULL BETWEEN 1 AND 5` ifadesi `UNKNOWN` üretir ve `CHECK` kısıtları yalnızca koşul `FALSE` döndüğünde ihlal sayılır.

## 3. Beklediğimden Farklı Çıkan Durum ve Öğrendiğim

Bölüm B'de yabancı anahtarların silme yönünü (`DELETE`) test ederken, `ON DELETE RESTRICT` olarak tanımladığım `fk_workshop_instructor` kısıtının da `23503 (foreign_key_violation)` hata kodu döndüreceğini bekliyordum; ancak `\set VERBOSITY verbose` ile gerçek çıktıyı aldığımda PostgreSQL'in `ON DELETE RESTRICT` için `23001 (restrict_violation)` ve `ON DELETE NO ACTION` için `23503 (foreign_key_violation)` döndürdüğünü gördüm. Ayrıca başarısız olan `INSERT` denemelerinin bile `GENERATED ALWAYS AS IDENTITY` sayaçlarını ilerlettiğini (sequence değerlerinin geri alınmadığını) fark ederek başlangıç test verilerini `TRUNCATE ... RESTART IDENTITY` bloğunun hemen altına yerleştirmeyi öğrendim.
