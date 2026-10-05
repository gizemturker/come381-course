# Hafta 11: İşlem işleme: ACID, çizelge ve serileştirilebilirlik

Durum: Yakında

## Bu hafta ne işliyoruz

- İşlem (transaction) kavramı, durumları: aktif, kısmen tamamlanmış, tamamlanmış, başarısız, sonlanmış
- ACID özellikleri: atomiklik, tutarlılık, izolasyon, kalıcılık
- Çizelge (schedule): seri, serileştirilebilir (serializable) çizelge
- Çakışma serileştirilebilirliği ve öncelik grafiği (precedence graph)
- Kurtarılabilir (recoverable) ve basamaklı geri almayan (cascadeless) çizelgeler
- PostgreSQL'de `BEGIN`, `COMMIT`, `ROLLBACK`, `SAVEPOINT`

## Hafta sonunda yapabileceklerin

- ACID özelliklerini bir banka havalesi örneğiyle açıklayabilirsin
- Verilen bir çizelgenin serileştirilebilir olup olmadığını öncelik grafiğiyle kontrol edebilirsin
- Kurtarılabilir ve kurtarılamaz çizelge arasındaki farkı gösterebilirsin

## Anahtar terimler

| English | Türkçe |
|---|---|
| transaction | işlem |
| schedule | çizelge |
| serializability | serileştirilebilirlik |
| precedence graph | öncelik grafiği |
| recoverable schedule | kurtarılabilir çizelge |

## Laboratuvar

`BEGIN`, `COMMIT`, `ROLLBACK`, `SAVEPOINT` ile işlem deneyleri. Havale senaryosunda yarım kalan işlemi geri alma.

## Okuma

İşlem işleme kavramları ve işlem teorisi bölümleri (Elmasri & Navathe veya Silberschatz).

## Ek kaynaklar

- PostgreSQL Transactions: https://www.postgresql.org/docs/current/tutorial-transactions.html

## Kilometre taşı

Haftalık lab teslimi

## Ödev

Bu haftanın ödevi ayrıca eklenecek.
