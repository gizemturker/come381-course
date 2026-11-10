# Silme politikası

Şemadaki altı foreign key için `ON DELETE` kararları (`constraints.sql` ile aynı):

| Foreign key | Ebeveyn → çocuk | Seçimim | Neden | Diğer seçenek neden olmadı |
|---|---|---|---|---|
| `fk_book_publisher` | publisher → book | `SET NULL` | Yayınevi kaydı silinse bile kitap kütüphanede durur; sadece yayınevi bilgisi boşalır. | `CASCADE` yayınevini silince kitapları da yok ederdi. `RESTRICT` ise yayınevi silmeyi gereksiz yere engellerdi. |
| `fk_book_author_book` | book → book_author | `CASCADE` | Kitap silinince "bu kitabı şu yazar yazdı" bağlantısının anlamı kalmaz. | `RESTRICT` önce bağlantıları elle silmeyi gerektirirdi, ek iş çıkarırdı. |
| `fk_book_author_author` | author → book_author | `CASCADE` | Yazar silinince yalnızca bağlantı satırları gider, kitaplar kalır. | `SET NULL` olamaz: bağlantı sütunları birincil anahtarın parçası, NULL olamaz. |
| `fk_book_copy_book` | book → book_copy | `RESTRICT` | Rafta fiziksel nüshası olan kitabın kaydı silinmemeli; önce nüshalar elden çıkarılmalı. | `CASCADE` nüshaları ve onların ödünç geçmişini sessizce silerdi. |
| `fk_loan_member` | member → loan | `RESTRICT` | Ödünç geçmişi kütüphanenin kaydıdır (kim hangi kitabı aldı); üye gitse de geçmiş korunmalı. | `CASCADE` geçmişi silerdi. `SET NULL` olamaz: `loan.member_id` `NOT NULL`. |
| `fk_loan_copy` | book_copy → loan | `NO ACTION` | Geçmişte ödünç verilmiş nüsha silinemez; sonuç `RESTRICT` ile aynı, burada varsayılan davranışı da denemek için seçtim. | `CASCADE` ödünç geçmişini silerdi. |

Kullanılan politikalar: `SET NULL`, `CASCADE`, `RESTRICT`, `NO ACTION` (dört farklı politika).

## CASCADE kanıtı

`fk_book_author_author` (author → book_author): "Terry Pratchett" (`author_id = 7`) silinir.
Good Omens'in iki yazarı vardı; yazar silinince yalnızca bağlantı satırı gider, kitap kalır.

```sql
-- Önce seed.sql çalıştırılmış olmalı
SELECT count(*) FROM author;       -- silmeden önce
SELECT count(*) FROM book_author;
SELECT count(*) FROM book;

DELETE FROM author WHERE author_id = 7;

SELECT count(*) FROM author;       -- sildikten sonra
SELECT count(*) FROM book_author;
SELECT count(*) FROM book;
```

| Tablo | Silmeden önce | Sildikten sonra |
|---|---|---|
| author | 7 | 6 |
| book_author | 8 | 7 |
| book | 7 | 7 |

> Bu sayılar `seed.sql` verisiyle hesaplandı. Teslimden önce komutları kendi `psql` oturumunda çalıştırıp çıktıyı buraya yapıştırarak doğrula.

## SET NULL kanıtı

```sql
SELECT publisher_id FROM book WHERE book_id = 6;   -- 5 (Metis)
DELETE FROM publisher WHERE publisher_id = 5;
SELECT publisher_id FROM book WHERE book_id = 6;   -- NULL, kitap silinmedi
```

## RESTRICT ile NO ACTION farkı

İkisi de silmeyi engeller. Fark zamanlamadır: `NO ACTION` kontrolü deyimin sonunda yapar ve constraint `DEFERRABLE` ise işlem (transaction) sonuna ertelenebilir; `RESTRICT` ise kontrolü hemen yapar ve ertelenemez.
