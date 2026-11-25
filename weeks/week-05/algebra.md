# İlişkisel cebir

## D1 — 150 sayfadan uzun kitaplar

`π title (σ pages > 150 (book))`

```sql
SELECT DISTINCT title FROM book WHERE pages > 150;
```

## D2 — Okuyucu ve kitap eşleşmeleri

`π full_name,title (reader ⋈ loan ⋈ book)`

```sql
SELECT DISTINCT r.full_name,b.title FROM reader r JOIN loan l ON r.reader_id=l.reader_id JOIN book b ON b.book_id=l.book_id;
```

## D3 — Roman veya bilim kitabı alanlar

`π reader_id (σ name=Roman (loan ⋈ book ⋈ category)) ∪ π reader_id (σ name=Bilim (loan ⋈ book ⋈ category))`

```sql
SELECT l.reader_id FROM loan l JOIN book b ON l.book_id=b.book_id JOIN category c ON b.category_id=c.category_id WHERE c.name='Roman' UNION SELECT l.reader_id FROM loan l JOIN book b ON l.book_id=b.book_id JOIN category c ON b.category_id=c.category_id WHERE c.name='Bilim';
```

## D4 — Hiç kitap almayanlar

`π reader_id (reader) − π reader_id (loan)`

```sql
SELECT reader_id FROM reader EXCEPT SELECT reader_id FROM loan;
```

## D5 — Aynı kategoride farklı kitap çiftleri

`σ B1.category_id=B2.category_id ∧ B1.book_id<B2.book_id (ρ B1(book) × ρ B2(book))`

```sql
SELECT a.title,b.title FROM book a JOIN book b ON a.category_id=b.category_id AND a.book_id<b.book_id;
```

## D6 — Bütün romanları alanlar

`π reader_id,book_id (loan) ÷ π book_id (σ name=Roman (book ⋈ category))`

```sql
SELECT DISTINCT l.reader_id FROM loan l WHERE NOT EXISTS (SELECT 1 FROM book b JOIN category c ON b.category_id=c.category_id WHERE c.name='Roman' AND NOT EXISTS (SELECT 1 FROM loan x WHERE x.reader_id=l.reader_id AND x.book_id=b.book_id));
```

D4 alternatif: `SELECT r.reader_id FROM reader r WHERE NOT EXISTS (SELECT 1 FROM loan l WHERE l.reader_id=r.reader_id);`
