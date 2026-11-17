# Hafta 5 Çalıştırma Kılavuzu ve Notlar

## 1. Çalıştırma Sırası

Dosyalar aşağıdaki sırayla çalıştırılmalıdır (`violations.sql` tabloları boşaltarak başladığı için `seed.sql` ondan sonra gelir; Windows'ta `-U postgres` parametresi eklenir):

```bash
psql -d come381 -f sql/schema.sql
psql -d come381 -f week-05/constraints.sql
psql -d come381 -f week-05/violations.sql
psql -d come381 -f week-05/seed.sql
psql -d come381 -f week-05/algebra.sql
```

## 2. Bölüm B'deki `NULL` Testinin Açıklaması (`T26`)

`pet_treatment` tablosundaki `follow_up_score` sütununda `CHECK (follow_up_score BETWEEN 1 AND 10)` kısıtı (`chk_pet_treatment_score_range`) tanımlıdır ancak sütun `NOT NULL` değildir. `T26` testinde bu sütuna `NULL` değer gönderildiğinde kayıt hata vermeden (`INSERT 0 1`) eklenmiştir; çünkü SQL'in üç değerli mantığında `NULL` ile yapılan karşılaştırmalar `FALSE` değil `UNKNOWN` döndürür ve `CHECK` kısıtları yalnızca ifade `FALSE` olduğunda işlemi reddeder.

## 3. Beklediğimden Farklı Çıkan Durum ve Öğrendiğim

İki sütunlu `CHECK (next_due_date >= visit_date)` kısıtını (`chk_pet_treatment_dates`) yazarken, kontrol tarihi girilmeyen (`next_due_date = NULL`) tek seferlik işlemlerde bu kuralın sorun çıkarabileceğini düşünmüştüm; ancak `NULL >= visit_date` ifadesinin `UNKNOWN` olarak değerlendirilmesi sayesinde ek bir `OR next_due_date IS NULL` koşulu yazmaya gerek kalmadan tek seferlik işlemlerin sorunsuz kaydedildiğini gördüm. Ayrıca `ON DELETE RESTRICT` ile `ON DELETE NO ACTION` politikalarının PostgreSQL'de farklı `SQLSTATE` kodları (`23001` ve `23503`) ürettiğini test çıktısından öğrendim.
