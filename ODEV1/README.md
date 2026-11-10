# come381-midterm

Bu proje bir mahalle kütüphanesinin veritabanıdır: üyeler, kitaplar, yazarlar, yayınevleri ve ödünç alma kayıtları tutulur. Bir kitabın birden fazla yazarı olabildiği ve bir yazarın birden fazla kitap yazabildiği için kitap ile yazar arasındaki M:N ilişkiyi `book_author` ara tablosuyla kurdum. Kitabı (`book`) ve raftaki fiziksel nüshasını (`book_copy`) ayrı tablolara böldüm, çünkü ödünç verilen şey kitabın kendisi değil, belirli bir nüshasıdır. Böylece aynı kitaptan üç kopya varsa her biri ayrı ayrı takip edilebilir.
