# Hafta 6: SQL ile soru sormak

Durum: Yakında

## Bu hafta ne işliyoruz

- `SELECT`, `WHERE`, `ORDER BY`
- `JOIN` türleri: inner, left, right, full outer
- `GROUP BY`, `HAVING` ve aggregate fonksiyonlar
- Alt sorgular (subquery) ve küme işlemleri: `UNION`, `INTERSECT`, `EXCEPT`
- `NULL` ile çalışmak: `IS NULL`, `COALESCE`, üç değerli mantık
- CTE (`WITH`) ve window fonksiyonlarına giriş
- `INSERT`, `UPDATE`, `DELETE` ve constraint ihlalleri

## Hafta sonunda yapabileceklerin

- Birden çok tabloyu join ederek soru sorabilirsin
- Gruplayıp özet çıkarabilir, `HAVING` ile grubu filtreleyebilirsin
- Karmaşık bir soruyu CTE ile parçalara bölebilirsin
- `NULL`'ın sonucu nasıl değiştirdiğini açıklayabilirsin
- Yapay zekanın yazdığı bir sorguyu kendi verinde test edip doğru olup olmadığını gösterebilirsin

## Anahtar terimler

| English | Türkçe |
|---|---|
| aggregate function | toplama fonksiyonu |
| subquery | alt sorgu |
| common table expression (CTE) | ortak tablo ifadesi |
| window function | pencere fonksiyonu |

## Laboratuvar

Kendi senaryon için seed verisi ve sorgu seti. Bir yapay zeka aracına sorgu yazdır, sonucu elle doğrula.

## Okuma

SQL bölümleri (Elmasri & Navathe veya Silberschatz).

## Ek kaynaklar

- SQL Murder Mystery: https://mystery.knightlab.com
- PostgreSQL SQL Commands: https://www.postgresql.org/docs/current/sql-commands.html

## Ödev

Ödev 3: Kampüs Kafe'ye SQL ile soru sormak. Yönergesi: [odev-3.md](odev-3.md). Hazır veri: [kafe.sql](kafe.sql). Rapor şablonu: [RAPOR-SABLONU.md](../../RAPOR-SABLONU.md). Son teslim: 25 Kasım Çarşamba (şube 2) ve 26 Kasım Perşembe (şube 3), ders saatinde.
