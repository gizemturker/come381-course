# Bölüm 2: NULL Deneyi (`null_deneyi.md`)

## Deney 1

```sql
SELECT COUNT(*), COUNT(phone) FROM customer;
```

- **Tahminim:** `customer` tablosunda toplam 8 müşteri olduğu için `COUNT(*)` 8 dönecektir; ancak `Mehmet Kaya`, `Can Arslan` ve `Selin Öztürk` satırlarında telefon numarası `NULL` olduğu için `COUNT(phone)` yalnızca dolu olan 5 satırı sayıp 5 dönecektir.
- **Sonuç:**
  ```text
   count | count 
  -------+-------
       8 |     5
  (1 row)
  ```
- **Yorum:** Tahminim tuttu. SQL'de `COUNT(*)` tablodaki tüm satırları (`NULL` içerip içermediğine bakmaksızın) sayarken, `COUNT(sütun_adı)` yalnızca o sütunda `NULL` olmayan değerleri sayar.

---

## Deney 2

```sql
SELECT AVG(age), SUM(age) / COUNT(*) FROM customer;
```

- **Tahminim:** Yaşların toplamı `20 + 21 + 22 + 19 + 23 + 20 = 125`'tir; `AVG(age)` yaş bilgisi `NULL` olan 2 müşteriyi (`Elif Yıldız` ve `Can Arslan`) paydaya katmayıp `125 / 6 = 20.83` bulurken, `SUM(age) / COUNT(*)` ifadesi `125` toplamını tüm müşteri sayısı olan `8`'e tam sayı bölmesiyle bölerek `15` döndürecektir.
- **Sonuç:**
  ```text
           avg         | ?column? 
  ---------------------+----------
   20.8333333333333333 |       15
  (1 row)
  ```
- **Yorum:** Tahminim tuttu. `AVG(age)` fonksiyonu `NULL` olan satırları tamamen yok sayıp yalnızca yaşı bilinen 6 kişinin ortalamasını (`20.83`) hesaplarken, `SUM(age) / COUNT(*)` ifadesi `NULL` satırların yaşını `0` kabul etmiş gibi toplamı 8 kişiye bölmüş ve ortalamayı yapay olarak düşürmüştür.
