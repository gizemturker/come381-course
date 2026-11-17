# Bölüm D: İlişkisel Cebir ve SQL

## D1 – Selection + Projection

**Soru:** Kapasitesi 50'den büyük etkinliklerin adları nelerdir?

**İlişkisel cebir:**

```text
π title ( σ capacity>50 (event) )
```

**SQL sonucu:**

```text
AI Seminar
City Run
Jazz Night
Swimming Day
```

**DISTINCT notu:** İlişkisel cebir küme semantiğiyle çalıştığı için tekrar üretmez. SQL tarafında aynı başlığa sahip birden fazla etkinlik bulunabileceği için `DISTINCT` kullanıldı.

**Tuple relational calculus:**

```text
{ t.title | event(t) ∧ t.capacity > 50 }
```

## D2 – Join

**Soru:** Sports kategorisindeki etkinlik kayıtlarının üye adları ve etkinlik adları nelerdir?

**İlişkisel cebir:**

```text
π full_name, title (
  σ name='Sports' (
    member ⋈ event_registration ⋈ event ⋈ category
  )
)
```

**SQL sonucu:**

```text
Ada Yilmaz   | Basketball Cup
Ada Yilmaz   | City Run
Ada Yilmaz   | Swimming Day
Bora Demir   | Basketball Cup
Bora Demir   | City Run
Ceren Kaya   | Basketball Cup
Ceren Kaya   | City Run
Ceren Kaya   | Swimming Day
```

**DISTINCT notu:** Küme semantiğini korumak için `DISTINCT` kullanıldı. Bu veri setinde `(member, event)` çifti unique constraint nedeniyle zaten tekrarlanmaz, ancak sorgu küme mantığını açıkça korur.

## D3 – Union

**Soru:** Sports veya Arts kategorisindeki en az bir etkinliğe katılmış üyeler kimlerdir?

**İlişkisel cebir:**

```text
π member_id, full_name (
  σ name='Sports' (member ⋈ event_registration ⋈ event ⋈ category)
)
∪
π member_id, full_name (
  σ name='Arts' (member ⋈ event_registration ⋈ event ⋈ category)
)
```

**SQL sonucu:**

```text
1 | Ada Yilmaz
2 | Bora Demir
3 | Ceren Kaya
4 | Deniz Arslan
```

**DISTINCT notu:** Ek olarak `DISTINCT` gerekli değildir; SQL'deki `UNION` zaten tekrar eden satırları kaldırır.

## D4 – Difference

**Soru:** Hiçbir etkinliğe kaydolmamış üyeler kimlerdir?

**İlişkisel cebir:**

```text
π member_id, full_name (member)
−
π member_id, full_name (member ⋈ event_registration)
```

**SQL sonucu – `EXCEPT`:**

```text
5 | Ece Sahin
```

**SQL sonucu – `NOT EXISTS`:**

```text
5 | Ece Sahin
```

İki SQL yaklaşımı aynı sonucu verdi.

**DISTINCT notu:** `EXCEPT` zaten küme semantiğiyle çalışır. `NOT EXISTS` sorgusunda ise dış sorgu doğrudan `member` tablosundan başladığı ve `member_id` primary key olduğu için her üye yalnızca bir kez döner; `DISTINCT` gerekli değildir.

## D5 – Rename + Self Join

**Soru:** Aynı şehirde yaşayan farklı üye çiftleri hangileridir?

**İlişkisel cebir:**

```text
π m1.member_id, m1.full_name, m2.member_id, m2.full_name, m1.city (
  σ m1.city=m2.city ∧ m1.member_id<m2.member_id (
    ρ m1(member) × ρ m2(member)
  )
)
```

**SQL sonucu:**

```text
Bora Demir  | Ece Sahin   | Ankara
Ada Yilmaz  | Ceren Kaya  | Istanbul
Ada Yilmaz  | Gizem Koc   | Istanbul
Ceren Kaya  | Gizem Koc   | Istanbul
```

**DISTINCT notu:** Gerekli değildir. `member_id` primary key olduğu ve `m1.member_id < m2.member_id` koşulu her çifti yalnızca bir kez ürettiği için tekrar oluşmaz.

## D6 – Division

**Soru:** Sports kategorisindeki tüm etkinliklere katılmış üyeler kimlerdir?

**İlişkisel cebir:**

```text
R = π member_id, event_id (event_registration)

S = π event_id (
      σ name='Sports' (
        event ⋈ category
      )
    )

Result = π member_id (R ÷ S)
```

**SQL sonucu:**

```text
1 | Ada Yilmaz
3 | Ceren Kaya
```

Bora Demir üç Sports etkinliğinin yalnızca ikisine kayıtlı olduğu için doğru sorgu tarafından elendi. Böylece D6 sonucu ne boş küme oldu ne de bütün üyeleri döndürdü.

**Neden çift `NOT EXISTS` seçildi?** SQL'de doğrudan division operatörü olmadığı için “eksik olduğu hiçbir Sports etkinliği bulunmayan üyeler” mantığı çift `NOT EXISTS` ile doğrudan ifade edildi. Bu yöntem yanlış kategori kayıtlarının sayılması gibi `COUNT` tabanlı hatalara karşı daha güvenlidir.

**DISTINCT notu:** Gerekli değildir. D6 sorgusu `member` tablosundan başlar ve her üye dış sorguda yalnızca bir kez değerlendirilir; `NOT EXISTS` tekrar satır üretmez.
