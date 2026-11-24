\# NULL Deneyleri



\## Deney 1 – COUNT(\*) ve COUNT(phone)



\*\*Tahminim:\*\* COUNT(\*) sonucunun 8, COUNT(phone) sonucunun 5 olacağını tahmin ettim.



\*\*Sonuç:\*\* COUNT(\*) = 8, COUNT(phone) = 5.



\*\*Yorum:\*\* Tahminim doğru çıktı. COUNT(\*) bütün satırları sayarken COUNT(phone) yalnızca telefon bilgisi NULL olmayan müşterileri saydı.



\## Deney 2 – AVG(age) ve SUM(age) / COUNT(\*)



\*\*Tahminim:\*\* AVG(age) sonucunun yaklaşık 20,83, SUM(age) / COUNT(\*) sonucunun 15 olacağını tahmin ettim.



\*\*Sonuç:\*\* AVG(age) = 20,8333333333333333, SUM(age) / COUNT(\*) = 15.



\*\*Yorum:\*\* Tahminim doğru çıktı. AVG(age) NULL değerleri hesaba katmadığı için yalnızca yaşı bulunan 6 müşterinin ortalamasını aldı. COUNT(\*) ise 8 müşterinin tamamını saydı. Ayrıca tam sayı bölmesi nedeniyle ikinci işlemin ondalık kısmı atıldı.

