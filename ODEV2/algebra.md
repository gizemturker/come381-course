# Bölüm D: İlişkisel cebir ve hesap

Veri: `seed.sql` (7 kitap, 7 yazar, 8 üye, 14 ödünç kaydı). SQL karşılıkları `algebra.sql` içinde, aynı numaralarla.

Kısaltmalar: `Loan`, `Member`, `BookCopy`, `Book`, `BookAuthor`, `Author` ilişkileri, ilgili tabloları gösterir.

---

## D1: σ ve π

**Soru:** 1950'den önce yayımlanmış kitapların adları.

**Cebir:**
```
π title ( σ publication_year < 1950 (Book) )
```

**Sonuç:**

| title |
|---|
| 1984 |
| Kurk Mantolu Madonna |
| Kuyucakli Yusuf |

**DISTINCT:** Cebir sonucu küme olduğu için tekrar yoktur. Projeksiyonda `book_id` atıldığı için iki farklı kitap aynı başlığı taşırsa SQL tekrar döndürürdü. Cebirle birebir aynı olsun diye `DISTINCT` kullandım.

**Tuple relational calculus:**
```
{ t.title | Book(t) ∧ t.publication_year < 1950 }
```

---

## D2: ⋈ (join)

**Soru:** 1 Mayıs 2026 ve sonrasında ödünç alınan kitaplar için üye adı ve kitap adı.

**Cebir:**
```
π full_name, title (
  σ loan_date ≥ '2026-05-01' ( Loan ⋈ Member ⋈ BookCopy ⋈ Book )
)
```

**Sonuç:**

| full_name | title |
|---|---|
| Burak Sahin | 1984 |
| Can Yilmaz | 1984 |
| Can Yilmaz | Kar |
| Can Yilmaz | Kurk Mantolu Madonna |
| Mehmet Kaya | 1984 |

**DISTINCT:** Gerekli. Bir üye aynı kitabı bu dönemde iki kez ödünç alsa (farklı nüsha ya da gün), projeksiyondan sonra aynı `(full_name, title)` çifti iki kez çıkardı. Cebir tekrarı atar, SQL atmaz.

---

## D3: ∪ (union)

**Soru:** Orhan Pamuk'un ya da Elif Safak'ın bir kitabını ödünç almış üyeler.

**Cebir:**
```
π full_name ( σ author.full_name = 'Orhan Pamuk' ( Member ⋈ Loan ⋈ BookCopy ⋈ BookAuthor ⋈ Author ) )
  ∪
π full_name ( σ author.full_name = 'Elif Safak'  ( Member ⋈ Loan ⋈ BookCopy ⋈ BookAuthor ⋈ Author ) )
```

**Sonuç:**

| full_name |
|---|
| Burak Sahin |
| Can Yilmaz |
| Elif Celik |

**DISTINCT:** Gerekmez. SQL'deki `UNION` zaten tekrarları atar (`UNION ALL` atmazdı). Elif Celik iki yazarı da aldığı halde sonuçta bir kez görünür.

---

## D4: − (difference)

**Soru:** Hiçbir kitap ödünç almamış üyeler.

**Cebir:**
```
π member_id ( Member ) − π member_id ( Loan )
```
(Üye bilgilerini görmek için sonucu `Member` ile join'ledim.)

**Sonuç (iki SQL yolu da aynı):**

| member_id | full_name |
|---|---|
| 7 | Deniz Aydin |
| 8 | Selin Ozturk |

**İlişkisel hesap:**
```
{ t.full_name | Member(t) ∧ ¬∃l ( Loan(l) ∧ l.member_id = t.member_id ) }
```

**DISTINCT:** Gerekmez. `EXCEPT` tekrarları kendiliğinden atar; `NOT EXISTS` yolunda `member` tablosundan birincil anahtarıyla seçtiğimiz için her üye zaten bir kez görünür.

---

## D5: ρ (rename) ve tablonun kendisiyle join'i

**Soru:** Aynı ülkeden farklı yazar çiftleri.

**Cebir:**
```
π a1.full_name, a2.full_name, a1.country (
  ρ a1 (Author) ⋈ a1.country = a2.country ∧ a1.author_id < a2.author_id ρ a2 (Author)
)
```
`a1.author_id < a2.author_id` koşulu hem yazarın kendisiyle eşleşmesini hem de (A,B) ile (B,A) çiftlerinin ikisinin birden gelmesini engeller.

**Sonuç:**

| author_1 | author_2 | country |
|---|---|---|
| George Orwell | Neil Gaiman | GB |
| George Orwell | Terry Pratchett | GB |
| Neil Gaiman | Terry Pratchett | GB |
| Sabahattin Ali | Orhan Pamuk | TR |
| Sabahattin Ali | Elif Safak | TR |
| Orhan Pamuk | Elif Safak | TR |

**DISTINCT:** Gerekmez. Her çift `author_id` değerleriyle yalnızca bir kez üretilir (`<` koşulu sayesinde).

---

## D6: ÷ (division)

**Soru:** Sabahattin Ali'nin **tüm** kitaplarını ödünç almış üyeler.

**Cebir:**
```
π member_id, book_id ( Loan ⋈ BookCopy )
  ÷
π book_id ( σ full_name = 'Sabahattin Ali' ( BookAuthor ⋈ Author ) )
```

**Sonuç:**

| member_id | full_name |
|---|---|
| 1 | Ayse Demir |
| 2 | Mehmet Kaya |

**Neden iç içe `NOT EXISTS`:** Mantığı doğrudan division tanımını izler ("Ali'nin öyle bir kitabı yok ki bu üye onu almamış olsun") ve bir kitabın iki kez ödünç alınması ya da başka yazarların kitaplarının alınması sonucu bozmaz. `COUNT` ile yazılan yöntemde `COUNT(DISTINCT ...)` ve yazar filtresi unutulursa yanlış sonuç çıkar (bkz. `AI_LOG.md`).

**Veri tuzakları (seed'de bilerek var):**
- Zeynep Arslan, Ali'nin yalnızca 1. kitabını iki farklı nüshayla aldı. Ali'nin 2 kitabı var, o da 2 kayıt sahibi; `COUNT(*)` ile kıyaslayan sorgu onu yanlışlıkla seçer.
- Can Yilmaz Ali'nin tek kitabını aldı, ayrıca başka kitaplar da aldı; filtresiz sayım onu yanıltabilir.

**DISTINCT:** Gerekmez. Sonuç `member` tablosundan birincil anahtarla seçiliyor.
