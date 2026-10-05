# Hafta 12: Eşzamanlılık denetimi

Durum: Yakında

## Bu hafta ne işliyoruz

- Eşzamanlı çalışmanın sorunları: kayıp güncelleme (lost update), kirli okuma (dirty read), tekrarlanamayan okuma, hayalet satır
- Kilit tabanlı protokoller: paylaşılan ve özel kilit, iki aşamalı kilitleme (2PL)
- Kilitlenme (deadlock): tespit, önleme, beklemeli çizelge grafiği
- Zaman damgası sıralaması (timestamp ordering)
- Çok sürümlü denetim (MVCC) ve iyimser (optimistic) yaklaşım
- İzolasyon seviyeleri ve hangi anomaliyi önledikleri

## Hafta sonunda yapabileceklerin

- İki oturumla anomali ve kilitlenme üretebilirsin
- Hangi izolasyon seviyesinin hangi anomaliyi önlediğini açıklayabilirsin
- 2PL ile zaman damgası sıralamasını karşılaştırabilirsin

## Anahtar terimler

| English | Türkçe |
|---|---|
| concurrency control | eşzamanlılık denetimi |
| two-phase locking (2PL) | iki aşamalı kilitleme |
| deadlock | kilitlenme |
| timestamp ordering | zaman damgası sıralaması |
| isolation level | izolasyon seviyesi |

## Laboratuvar

İki `psql` oturumuyla anomali ve kilitlenme deneyi.

## Okuma

Eşzamanlılık denetimi protokolleri bölümü.

## Ek kaynaklar

- PostgreSQL Concurrency Control: https://www.postgresql.org/docs/current/mvcc.html

## Kilometre taşı

Capstone ara kontrol (Pull Request incelemesi)

## Ödev

Bu haftanın ödevi ayrıca eklenecek.
