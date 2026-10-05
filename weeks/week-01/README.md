# Hafta 1: Neden veritabanı? Dosyadan sisteme

Durum: Yayında

## Bu hafta ne işliyoruz

- Dosya tabanlı sistemlerin altı problemi: tutarsızlık (inconsistency), sorgulama zorluğu, gömülü kurallar (integrity), yarım kalan işler (atomicity), eşzamanlı düzenleme (concurrency), yetkilendirme (security)
- Veri (data), bilgi (information), bilgi birikimi (knowledge)
- Veritabanı (database), VTYS (DBMS), veritabanı sistemi (database system)
- Üç şemalı mimari (three-schema architecture) ve veri bağımsızlığı (data independence)
- Veri modellerinin tarihi: gezinmeli, ilişkisel, NoSQL, vektör
- İlişki, satır, nitelik, birincil anahtar (relation, tuple, attribute, primary key)
- DBMS iç yapısı: sorgu işlemcisi, depolama yöneticisi, işlem yöneticisi
- Buyurgan (imperative) ve bildirimsel (declarative) yaklaşım, PostgreSQL seçimi

## Hafta sonunda yapabileceklerin

- Aynı bilginin birden çok dosyada tutulmasının neden tutarsızlık ürettiğini örnekle açıklayabilirsin
- Veritabanı, VTYS ve veritabanı sistemi arasındaki farkı söyleyebilirsin
- İç, kavramsal ve dış seviyenin ne işe yaradığını anlatabilirsin
- Bilgisayarında PostgreSQL çalıştırıp ilk SQL sorgunu yazabilirsin

## Anahtar terimler

| English | Türkçe |
|---|---|
| redundancy / inconsistency | veri tekrarı / tutarsızlık |
| schema / view / mapping | şema / görünüm / eşleme |
| data independence | veri bağımsızlığı |
| index | indeks (dizin) |
| declarative / imperative | bildirimsel / buyurgan |

## Laboratuvar

GitHub hesabı ve 2FA, Git/VS Code/PostgreSQL 18 kurulumu, `psql` ile ilk sorgu (`SELECT LEAST(7,3,9,1,5);`), ilk özel (private) repo ve ilk commit. Adım adım anlatım: [SETUP.md](../../SETUP.md).

## Okuma

Elmasri & Navathe, Silberschatz vb. kitaplarda "veritabanı sistemlerine giriş" ve "veritabanı sistem mimarisi" bölümleri. E. F. Codd'un 1970 makalesinin giriş kısmı (isteğe bağlı).

## Ek kaynaklar

- E. F. Codd, "A Relational Model of Data for Large Shared Data Banks" (1970): https://www.comp.nus.edu.sg/~lingtw/papers/codd.pdf
- Pro Git, 1-2. bölümler: https://git-scm.com/book

## Kilometre taşı

GitHub kullanıcı adı, kayıt formu, ilk repo

## Ödev

Bu haftanın ödevi ayrıca eklenecek.
