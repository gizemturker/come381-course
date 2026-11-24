# NULL Deneyi

## Deney 1

Sorgu:
SELECT COUNT(*), COUNT(phone) FROM customer;

Tahminim: [İki sayma işleminin farklı sonuç vereceğini düşünüyorum..]

Sonuç: Beklenen değerler 8 ve 5.

Yorum: COUNT(*) bütün müşterileri sayar.
COUNT(phone) telefon bilgisi boş olanları saymaz.

## Deney 2

Sorgu:
SELECT AVG(age), SUM(age) / COUNT(*) FROM customer;

Tahminim: [ Yaş bilgisi boş olan müşteriler nedeniyle iki ortalamanın farklı çıkacağını düşünüyorum .]

Sonuç: Beklenen değerler 20.8333 ve 15.

Yorum: AVG(age) yaşı boş olan müşterileri hesaba
katmaz. COUNT(*) ise bütün müşterileri sayar.
Bu yüzden sonuçlar farklı çıkar.
