# Hafta 10: Gelişmiş SQL ve indekse giriş

Durum: Yakında

## Bu hafta ne işliyoruz

- Karmaşık sorgular: iç içe ve ilişkili alt sorgu (correlated subquery), `EXISTS`, dış birleştirme (outer join)
- View ve materialized view
- Trigger (tetikleyici) ve saklı fonksiyon (stored function)
- Kısıtların assertion ve trigger ile tanımlanması (PostgreSQL'de `CREATE ASSERTION` yoktur, aynı iş `CHECK` ve trigger ile yapılır)
- Şema değişikliği (`ALTER TABLE`)
- İndekse giriş: B-tree indeks, `EXPLAIN ANALYZE` ile planı okuma

## Hafta sonunda yapabileceklerin

- View ile yetki ve sadelik sağlayabilirsin
- Trigger ile veritabanı içinde kural uygulayabilirsin
- Mevcut tabloyu `ALTER TABLE` ile değiştirebilirsin
- Bir indeksin sorgu planını nasıl değiştirdiğini ölçebilirsin

## Anahtar terimler

| English | Türkçe |
|---|---|
| view / materialized view | görünüm / gerçekleştirilmiş görünüm |
| trigger | tetikleyici |
| assertion | iddia (genel bütünlük kısıtı) |
| query plan | sorgu planı |
| B-tree index | B-ağacı indeksi |

## Laboratuvar

View, trigger ve `ALTER TABLE` uygulaması. `EXPLAIN ANALYZE` ile bir sorguyu indeksten önce ve sonra ölçme.

## Okuma

Gelişmiş SQL bölümü (tetikleyiciler, görünümler, şema değişikliği). İndeksleme bölümünün giriş kısmı.

## Ek kaynaklar

- Use The Index, Luke: https://use-the-index-luke.com
- PostgreSQL Triggers: https://www.postgresql.org/docs/current/triggers.html

## Kilometre taşı

Capstone önerisi (GitHub Issue)

## Ödev

Bu haftanın ödevi ayrıca eklenecek.
