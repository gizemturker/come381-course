# COME 381 Veritabanı Sistemleri — Vize Projesi

## Senaryo: Kültür ve Sanat Merkezi Atölye Yönetim Sistemi

Bu veritabanı, bir kültür ve sanat merkezinde düzenlenen uygulamalı sanat atölyelerini (`workshop`), bu atölyeleri veren eğitmenleri (`instructor`), çalışmaların yapıldığı stüdyo/salonları (`room`), merkeze kayıtlı kursiyerleri (`student`) ve kursiyerlerin atölye kayıtlarını (`enrollment`) yönetmek için tasarlanmıştır.

## Tasarım Kararı

Bir kursiyer birden fazla atölyeye katılabildiği ve bir atölyede birden fazla kursiyer yer alabildiği için `student` ile `workshop` arasındaki çoktan-çoğa (M:N) ilişki `enrollment` adlı ara tablo ile modellenmiştir; katılım durumu (`attendance_status`), ödenen ücret (`paid_amount`) ve kursiyerin atölyeye verdiği değerlendirme puanı (`rating`) doğrudan bu kayıt ilişkisine ait nitelikler olduğu için `enrollment` tablosunda tutulmuştur. Ayrıca bazı atölyeler çevrimiçi yapılabildiği veya fiziksel bir stüdyo tadilata girip kapatılabildiği için `workshop` tablosundaki `room_id` yabancı anahtarı boş bırakılabilir (`NULL` olabilir) şekilde tasarlanmıştır.
