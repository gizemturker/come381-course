# Hafta 13: Veritabanı kurtarma

Durum: Yakında

## Bu hafta ne işliyoruz

- Hata türleri: işlem hatası, sistem çökmesi, disk hatası
- Günlük (log) tabanlı kurtarma: undo, redo, checkpoint
- Önceden yazma günlüğü (WAL)
- ARIES kurtarma algoritmasına giriş
- Gölge sayfalama (shadow paging)
- Yedekleme ve geri yükleme (`pg_dump`, `pg_restore`)

## Hafta sonunda yapabileceklerin

- Bir çökme sonrası hangi işlemin undo, hangisinin redo edileceğini günlükten çıkarabilirsin
- Yedekten geri dönüş senaryosunu uygulayabilirsin
- WAL ile checkpoint'in rolünü anlatabilirsin

## Anahtar terimler

| English | Türkçe |
|---|---|
| write-ahead log (WAL) | önceden yazma günlüğü |
| checkpoint | kontrol noktası |
| undo / redo | geri alma / yeniden yapma |
| shadow paging | gölge sayfalama |
| backup / restore | yedekleme / geri yükleme |

## Laboratuvar

`pg_dump`/`pg_restore` tatbikatı: veritabanını yedekle, boz, geri yükle, süreyi ve adımları belgele.

## Okuma

Veritabanı kurtarma protokolleri bölümü.

## Ek kaynaklar

- PostgreSQL Backup and Restore: https://www.postgresql.org/docs/current/backup.html
- PostgreSQL WAL: https://www.postgresql.org/docs/current/wal-intro.html

## Kilometre taşı

Haftalık lab teslimi

## Ödev

Bu haftanın ödevi ayrıca eklenecek.
