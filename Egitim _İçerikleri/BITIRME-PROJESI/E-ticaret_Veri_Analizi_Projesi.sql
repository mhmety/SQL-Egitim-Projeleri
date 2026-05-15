--
--Toplam harcaması 5.000 TL üzerinde olan müşterilerin; kullanıcı adını, adını-soyadını, 
--toplam harcama miktarını ve sistemdeki en güncel (en son eklenen) adresini listeleyen sorguyu yaz.
SELECT 
    U.USERNAME_ AS KullanıcıAdı,
    U.NAMESURNAME AS MüşteriAdı, 
    SUM(O.TOTALPRICE) AS ToplamHarcama,
    (SELECT TOP 1 ADDRESSTEXT FROM ADDRESS WHERE USERID = U.ID ORDER BY ID DESC) AS SonAdres
FROM USERS U 
INNER JOIN ORDERS O ON U.ID = O.USERID
GROUP BY U.ID, U.NAMESURNAME, U.USERNAME_ 
HAVING SUM(O.TOTALPRICE) > 5000 
ORDER BY SUM(O.TOTALPRICE) DESC


--Her kategorinin adını ve bu kategorideki ürünlerin en çok hangi gün (Pazartesi, Salı vb.)
--satıldığını gösteren bir tablo
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
        COUNT(OD.ID) AS SatisAdedi,
        ROW_NUMBER() OVER(PARTITION BY IT.CATEGORY1 ORDER BY COUNT(OD.ID) DESC) AS Sira
    FROM ORDERS O
    INNER JOIN ORDERDETAILS OD ON O.ID = OD.ORDERID
    INNER JOIN ITEMS IT ON IT.ID = OD.ITEMID
    GROUP BY IT.CATEGORY1, DATEPART(DW, O.DATE_)
) AS Tablo
WHERE Sira = 1


--Kaybedilen Müşterileri Geri Kazanma
--Son 6 aydır (180 gün) sipariş vermeyen müşterilerin listesini ve iletişim bilgilerini getir.
SELECT 
    U.NAMESURNAME, 
    U.EMAIL, 
    U.TELNR1, 
    MAX(O.DATE_) AS SonSiparisTarihi,
    DATEDIFF(DAY, MAX(O.DATE_), (SELECT MAX(DATE_) FROM ORDERS)) AS GecenGunSayisi
FROM USERS U
INNER JOIN ORDERS O ON U.ID = O.USERID
GROUP BY U.NAMESURNAME, U.EMAIL, U.TELNR1
HAVING DATEDIFF(DAY, MAX(O.DATE_), (SELECT MAX(DATE_) FROM ORDERS)) > 180
ORDER BY GecenGunSayisi DESC


--Hiç satılmayan ürünleri "Kampanya Uygula" etiketiyle listele.
SELECT 
    IT.ITEMCODE AS [Ürün Kodu], 
    IT.ITEMNAME AS [Ürün Adı], 
    IT.CATEGORY1 AS [Kategori],
    'Kampanya Uygula' AS Durum
FROM ITEMS IT
LEFT JOIN ORDERDETAILS OD ON IT.ID = OD.ITEMID
WHERE OD.ID IS NULL -- Satış tablosunda hiç kaydı olmayanlar
ORDER BY IT.CATEGORY1