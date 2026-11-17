# Week 05

## Çalıştırma sırası

Windows CMD üzerinde:

```bash
psql -U postgres -d come381 -f sql/schema.sql
psql -U postgres -d come381 -f week-05/constraints.sql
psql -U postgres -d come381 -f week-05/violations.sql
psql -U postgres -d come381 -f week-05/seed.sql
psql -U postgres -d come381 -f week-05/algebra.sql
```

Sıra önemlidir. `violations.sql` testlerin her çalıştırmada aynı başlangıç durumundan başlaması için tabloları `TRUNCATE ... RESTART IDENTITY CASCADE` ile temizler. Bu nedenle gerçek sorgu verisini ekleyen `seed.sql`, ihlal testlerinden sonra çalıştırılır.

## NULL testi

`event_registration.rating` sütunu `NOT NULL` değildir, fakat `CHECK (rating BETWEEN 1 AND 5)` constraint'i vardır. `rating = NULL` olduğunda CHECK ifadesinin sonucu `FALSE` değil `UNKNOWN` olur; PostgreSQL CHECK constraint'i yalnızca ifade `FALSE` olduğunda satırı reddettiği için NULL değer kabul edilir. NULL değerini tamamen yasaklamak için ayrıca `NOT NULL` gerekir.

## Beklediğimden farklı çıkan şey

İlk parent DELETE testinde `ON DELETE RESTRICT` kullandığımda PostgreSQL `23001` SQLSTATE kodunu verdi. Ödevde foreign key ihlali için `23503` beklendiğinden ilişkiyi `NO ACTION` olarak değiştirdim ve aynı test `23503` verdi. Böylece `RESTRICT` ile `NO ACTION` benzer görünse de PostgreSQL'de davranış ve hata sınıflandırması açısından aynı olmadıklarını gördüm.
