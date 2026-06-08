# 🚀 Uygulamalarla SQL Veri Analizi ve E-Ticaret Yönetimi

Bu depo, **BTK Akademi** bünyesinde tamamladığım "Uygulamalarla SQL Öğreniyorum" eğitim sürecindeki kapsamlı çalışma notlarımı ve gerçek bir e-ticaret veritabanı (`ETRADE`) üzerinden kurguladığım **Bitirme Projesi** analizlerini içermektedir.

Sertifika ve İletişim için:
[![LinkedIn](https://img.shields.io/badge/LinkedIn-0077B5?style=for-the-badge&logo=linkedin&logoColor=white)](https://www.linkedin.com/in/mehmetyildizbst/)

---

## 📚 Eğitim Süreci ve Kazanımlar
Eğitim boyunca SQL dünyasının temelinden ileri seviyesine kadar geniş bir yelpazede çalışmalar yürüterek şu yetkinlikleri portfolyoma dahil ettim:

* **Veri Entegrasyonu ve Yönetimi:** SQL Server ile **Excel arasında dinamik bağlantılar kurma**, Excel'den veritabanına veri aktarma (Import/Export) ve dış kaynaklı verileri ilişkisel tablo yapısına dönüştürme süreçlerini yönettim.
* **İleri Seviye Fonksiyonlar:** `CONCAT`, `CHARINDEX`, `ASCII` ve `CHAR` gibi string fonksiyonları ile veri temizleme; `CASE WHEN` yapısıyla dinamik anlamlandırma çalışmaları yaptım.
* **Zaman ve Performans Analizi:** `DATEPART`, `DATEDIFF` ve `CONVERT` fonksiyonlarını kullanarak dönemsel performans ölçümleme tekniklerini uyguladım.
* **Sorgu Optimizasyonu:** Büyük veri setleri üzerinde `GROUP BY`, `HAVING` ve karmaşık `JOIN` yapılarını kullanarak yüksek performanslı sorgular yazdım.

---

## 📌 Proje Hakkında
Projenin temel amacı, yaklaşık 20.000 satırlık ham veriyi işleyerek anlamlı iş içgörüleri (business insights) üretmektir. Analizler sırasında T-SQL'in ileri seviye özellikleri bizzat iş problemlerini çözmek için kullanılmıştır.

### 🛠 Teknik Yetkinlikler
* **Dil:** T-SQL (Transact-SQL)
* **İleri Teknikler:** `Window Functions` (ROW_NUMBER, PARTITION BY), `Subqueries`, `Complex Joins`
* **Analitik Yaklaşım:** Zaman serisi analizi, müşteri segmentasyonu ve Churn yönetimi.

---

## 📊 Bitirme Projesi Analiz Senaryoları

| Senaryo | Yapılan İşlem | Teknik Detay / Fonksiyonlar |
| :--- | :--- | :--- |
| **VIP Müşteri Analizi** | 5000 TL üzeri harcama yapanların en güncel adreslerini raporlama | `SUM`, `Subquery`, `TOP 1` |
| **Satış Trendleri** | Kategorilerin en çok satış yaptığı günü tespit etme | `PARTITION BY`, `ROW_NUMBER` |
| **Churn (Kayıp) Analizi** | 180 gündür sipariş vermeyen müşterileri listeleme | `DATEDIFF`, `MAX`, `HAVING` |
| **Stok Verimliliği** | Hiç satılmayan ürünleri kampanya listesine alma | `LEFT JOIN`, `IS NULL` |

---

## 📂 Klasör Yapısı
* 📁 **ORNEKLER:** Eğitim içerikleri ve süresince yazılan uygulama dosyaları (`EXAMPLE1.sql` - `EXAMPLE7.sql`). String fonksiyonları, Excel bağlantı örnekleri ve temel sorgu yapılarını içerir.
* 📁 **BITIRME-PROJESI:** Yukarıdaki 4 ana senaryonun, iş mantığına uygun olarak kurgulanmış SQL kodları.

---

## 🚀 Örnek Bir Sorgu (Kategori Analizi)
Aşağıdaki kod bloğu, kategorilerin en popüler satış günlerini nasıl hesapladığımı ve `Window Functions` kullanımını göstermektedir:

```sql
SELECT Kategori, GunAdi, SatisAdedi FROM (
    SELECT 
        IT.CATEGORY1 AS Kategori,
        CASE DATEPART(DW, O.DATE_)
            WHEN 1 THEN 'Pazar' 
            WHEN 2 THEN 'Pazartesi'
            WHEN 3 THEN 'Salı'
            WHEN 4 THEN 'Çarşamba'
            WHEN 5 THEN 'Perşembe'
            WHEN 6 THEN 'Cuma'
            WHEN 7 THEN 'Cumartesi'
        END AS GunAdi,
        ROW_NUMBER() OVER(PARTITION BY IT.CATEGORY1 ORDER BY COUNT(OD.ID) DESC) AS Sira,
        COUNT(OD.ID) AS SatisAdedi
    FROM ORDERS O
    INNER JOIN ORDERDETAILS OD ON O.ID = OD.ORDERID
    INNER JOIN ITEMS IT ON IT.ID = OD.ITEMID
    GROUP BY IT.CATEGORY1, DATEPART(DW, O.DATE_)
) AS Tablo WHERE Sira = 1
