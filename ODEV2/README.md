# Hafta 5: Ödev 2

## Çalıştırma sırası

```bash
psql -d come381 -f sql/schema.sql
psql -d come381 -f week-05/constraints.sql
psql -d come381 -f week-05/violations.sql > week-05/violations_output.txt 2>&1
psql -d come381 -f week-05/seed.sql
psql -d come381 -f week-05/algebra.sql
```

`violations.sql` tabloları boşaltarak başlar, `seed.sql` da kendi başına tabloları boşaltıp veriyi yükler; bu yüzden sıra önemlidir. Windows'ta komutlara `-U postgres` ekle.

## NULL testi (T16)

`chk_loan_return_order` (`return_date >= loan_date`) olan `return_date` sütununa `NULL` eklediğimde kayıt kabul edildi. Çünkü `NULL >= tarih` ifadesi `false` değil `NULL` ("bilinmiyor") döner ve `CHECK` yalnızca `false` sonucunu reddeder. Bu aslında istediğim davranış (kitap henüz iade edilmedi), ama kuralı `NOT NULL` ile birlikte düşünmezsem boş değerin CHECK'ten kaçabileceğini gösteriyor.

## Beklediğimden farklı çıkan

> BURAYI KENDİN YAZ: `violations.sql`'i kendi bilgisayarında çalıştırdığında beklenenden farklı çıkan bir şey oldu mu? İki üç cümleyle anlat. Örnek bir konu: `member_id` `GENERATED ALWAYS AS IDENTITY` olduğu için `UPDATE member SET member_id = ...` doğrudan hata verir (foreign key'e hiç ulaşmaz); bu yüzden FK'nin UPDATE yönünü `loan.member_id` üzerinden test ettim.

## Not: CHECK ile yazılamayan kural

"Üyenin aynı anda en fazla 5 ödünç kitabı olabilir" kuralı birden çok satıra bakar; `CHECK` yalnızca kendi satırını görür. PostgreSQL `CREATE ASSERTION` desteklemediği için bunu Hafta 8'de trigger ile yazmak gerekecek.
