create database quiz;
use quiz;


/*islem tablosu olusturma kodu*/
CREATE TABLE `quiz`.`islem` (
  `islemno` INT ,
  `ogrno` INT ,
  `kitapno` INT ,
  `atarih` VARCHAR(45) ,
  `vtarih` VARCHAR(45) ,
  PRIMARY KEY (`islemno`));
  
  
  
  /*ogrenci tablosu olusturma kodu*/
  CREATE TABLE `quiz`.`ogrenci` (
  `ogrencino` INT NOT NULL,
  `ograd` VARCHAR(45) NULL,
  `ogrsoyad` VARCHAR(45) NULL,
  `cinsiyet` VARCHAR(45) NULL,
  `dtarih` VARCHAR(45) NULL,
  `sinif` VARCHAR(45) NULL,
  PRIMARY KEY (`ogrencino`));
  
  
  
/*kitap tablosu olusturma kodu*/
  CREATE TABLE `quiz`.`kitap` (
  `kitapno` INT NOT NULL,
  `isbnno` INT NULL,
  `kitapadi` VARCHAR(100) NULL,
  `yazarno` INT NULL,
  `turno` INT NULL,
  `sayfasayisi` INT NULL,
  `puan` INT NULL,
  PRIMARY KEY (`kitapno`));
  
  
  /*yazar tablosu olusturma kodu*/
  CREATE TABLE `quiz`.`yazar` (
  `yazarno` INT NOT NULL,
  `yazarad` VARCHAR(100) NULL,
  `yazarsoyad` VARCHAR(100) NULL,
  PRIMARY KEY (`yazarno`));
  
    /*kitap tablosuna 3 tane veri ekleyelim*/
 select*from kitap;
INSERT INTO kitap (kitapno, isbnno, kitapadi, yazarno, turno, sayfasayisi, puan)
VALUES (1, 123456, 'Kitap Adı 1', 1, 1, 100, 15000),
       (2, 234567, 'Kitap Adı 2', 2, 2, 200, 2000),
       (3, 234567, 'Kitap Adı 3', 2, 2, 200, 7000);
       
   /*ogrenci tablosuna 3 tane veri ekleyelim*/    
INSERT INTO ogrenci (ogrencino, ograd, ogrsoyad, cinsiyet, dtarih, sinif)
VALUES (1, 'Ali', 'Karakaya', 'Erkek', '2000-01-01', '1-A'),
       (2, 'Tolga', 'Aydac', 'Erkek', '2001-02-02', '2-B'),
       (3, 'Kerem', 'Cinar', 'Erkek', '2002-03-03', '3-C');
       
  /*islem tablosuna 3 tane veri ekleyelim*/      
INSERT INTO islem (islemno, ogrno, kitapno, atarih, vtarih)
VALUES (1, 1, 1, '2022-01-01', '2022-01-15'),
       (2, 2, 2, '2022-02-01', '2022-02-15'),
       (3, 3, 3, '2022-03-01', '2022-03-15');
  /*yazar tablosuna 3 tane veri ekleyelim*/        
INSERT INTO yazar (yazarno, yazarad, yazarsoyad)
VALUES (1, 'Orhan', 'Pamuk'),
       (2, 'Yasar', 'Kemal'),
       (3, 'Namık', 'Kemal');
       /*tur tablosuna 3 tane veri ekleyelim*/
INSERT INTO tur (turno, turadi) VALUES (1, 'Roman'),
 (2, 'Ask'),
(3, 'Korku');
  
  
  
  /*tur tablosu olusturma kodu*/
  CREATE TABLE `quiz`.`tur` (
  `turno` INT NOT NULL,
  `turadi` VARCHAR(45) NULL,
  PRIMARY KEY (`turno`));
  
  /*tablolar arası iliski kuralım*/
  /*1)islem tablosundaki ogrno ile ogrenci tablosundaki ogrno arasında iliski kuralım*/
  ALTER TABLE islem
  ADD FOREIGN KEY (ogrno) REFERENCES ogrenci(ogrencino);
  
  /*2)islem tablosundaki kitapno ile kitap tablosundaki kitapno arasında ilişki kuralım*/ 
  ALTER TABLE islem
  ADD FOREIGN KEY (kitapno) REFERENCES kitap(kitapno);
  
  /*3)kitap tablosundaki turno ile tur tablosundaki turno arasında ilişki kuralım*/
  ALTER TABLE kitap
  ADD FOREIGN KEY (turno) REFERENCES tur(turno);

  /*4)kitap tablosundaki yazarno ile yazar tablosundaki yazarno arasına ilişki kuralım*/
  ALTER TABLE kitap
  ADD FOREIGN KEY (yazarno) REFERENCES yazar(yazarno);

       
/*kitap no su parametre olarak verilen kitabın puanın ortalaması 10000 ve üstü olanlara trend 5000 altında olanları vasat diğerine normal çıktısı veren STORE PROCEDURU YAZDIRMA*/
DELIMITER //
CREATE PROCEDURE kitap_puan_ortalama (IN kitap_no INT)
BEGIN
  SELECT AVG(puan) as ortalama FROM kitap WHERE kitapno = kitap_no;
  SET @ortalama = (SELECT AVG(puan) FROM kitap WHERE kitapno = kitap_no);
  IF @ortalama >= 10000 THEN
    SELECT 'TREND' as durum;
  ELSEIF @ortalama < 5000 THEN
    SELECT 'VASAT' as durum;
  ELSE
    SELECT 'NORMAL' as durum;
  END IF;
END //
DELIMITER ;
/*1 olan kitap için puan ortalamasını hesaplayacak ve çıktısını gösterecektir.*/
CALL kitap_puan_ortalama(2);

select*from ogrenci,islem limit 3;


/*yazarad , yazarsoyad,kitapadi,puan bu sütunları puana sıralıyarak tek bir değişkene aktaran ve sql sorgudan çağıracak prasüdürü yazınız*/


DELIMITER $$
CREATE PROCEDURE get_sorted_authors_books_scores()
BEGIN
    DECLARE authors_books_scores VARCHAR(5000);
    SET authors_books_scores = '';
    
    SELECT CONCAT(yazarad, ' ', yazarsoyad, ' - ', kitapadi, ' - ', puan)
    INTO authors_books_scores
    FROM kitap
    INNER JOIN yazar ON kitap.yazarno = yazar.yazarno
    ORDER BY puan DESC;
    
    SELECT authors_books_scores;
END $$
DELIMITER ;

CALL get_sorted_authors_books_scores;


/*quiz veri tabanı üzerinde SELECT INSERT işlemleri yapabilen MUSTERI adında , ALERT-DROP islemleri yapabilen GELİSTİRİCİ ve tüm yetkilere sahip ADMIN adında üç kullanıcı oluştur*/
CREATE USER 'ADMIN'@'localhost' IDENTIFIED BY 'parola';
GRANT SELECT, INSERT, UPDATE, DELETE, CREATE ON quiz.* TO 'Gelistirici'@'localhost';
CREATE USER 'ADMIN2'@'localhost' IDENTIFIED BY 'parola';
GRANT SELECT, INSERT, UPDATE, DELETE, CREATE ON quiz.* TO 'Gelistirici'@'localhost';
CREATE USER 'ADMIN3'@'localhost' IDENTIFIED BY 'parola';
GRANT SELECT, INSERT, UPDATE, DELETE, CREATE ON quiz.* TO 'Gelistirici'@'localhost';





















  
  
  
  
  
  
  
  
  
  
  
  
  
  
  
