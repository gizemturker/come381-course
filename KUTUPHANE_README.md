# COME381 — Ödev 1 ve 2

## Kütüphane ve Kitap Ödünç Alma Sistemi

Okuyucular kitapları ödünç alır; her kitap bir kategoriye bağlıdır.

## PostgreSQL

Boş bir test veritabanında, repo kökünden sırasıyla:

```sh
createdb kutuphane
psql -v ON_ERROR_STOP=1 -d kutuphane -f sql/schema.sql
psql -v ON_ERROR_STOP=1 -d kutuphane -f weeks/week-05/constraints.sql
psql -v ON_ERROR_STOP=1 -d kutuphane -f weeks/week-05/seed.sql
psql -d kutuphane -f weeks/week-05/algebra.sql
psql -d kutuphane -f weeks/week-05/violations.sql > weeks/week-05/violations_output.txt 2>&1
```

İhlal dosyasında hatalar beklenir.
PostgreSQL üzerinde çalıştırma doğrulaması henüz yapılmamıştır.
