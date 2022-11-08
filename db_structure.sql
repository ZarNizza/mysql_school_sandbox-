
CREATE TABLE IF NOT EXISTS subjects (id INT UNSIGNED NOT NULL AUTO_INCREMENT PRIMARY KEY, grade SMALLINT DEFAULT 0, name VARCHAR(20) DEFAULT "");
CREATE TABLE IF NOT EXISTS classes (id INT UNSIGNED NOT NULL AUTO_INCREMENT PRIMARY KEY, grade SMALLINT DEFAULT 0, symbol VARCHAR(1) DEFAULT "", chief INT DEFAULT 0, size SMALLINT DEFAULT 0);
CREATE TABLE IF NOT EXISTS tutors (id INT UNSIGNED NOT NULL AUTO_INCREMENT PRIMARY KEY, lastName VARCHAR(20) DEFAULT "", firstName VARCHAR(20) DEFAULT "", patronym VARCHAR(20) DEFAULT "");
CREATE TABLE IF NOT EXISTS log (id SERIAL PRIMARY KEY, log_date DATE DEFAULT (CURDATE()), time_slot SMALLINT DEFAULT 0, class SMALLINT DEFAULT 0, subj SMALLINT DEFAULT 0, tutor SMALLINT DEFAULT 0, size SMALLINT DEFAULT 0);


# наполняем таблицу subjects
#
INSERT INTO subjects (grade, name) VALUES (1, "Сказки");
INSERT INTO subjects (grade, name) VALUES (1, "Каляки-маляки");
INSERT INTO subjects (grade, name) VALUES (1, "Гуляшки");
INSERT INTO subjects (grade, name) VALUES (2, "Правописание");
INSERT INTO subjects (grade, name) VALUES (2, "ЛевоЧитание");
INSERT INTO subjects (grade, name) VALUES (2, "ФизКультура");
INSERT INTO subjects (grade, name) VALUES (3, "Чтение");
INSERT INTO subjects (grade, name) VALUES (3, "ФизКультура");
INSERT INTO subjects (grade, name) VALUES (3, "Лепка");
INSERT INTO subjects (grade, name) VALUES (4, "Природоведение");
INSERT INTO subjects (grade, name) VALUES (4, "Кругозор");
INSERT INTO subjects (grade, name) VALUES (4, "ФизКультура");
INSERT INTO subjects (grade, name) VALUES (5, "История");
INSERT INTO subjects (grade, name) VALUES (5, "ФизКультура");
INSERT INTO subjects (grade, name) VALUES (5, "Математика");
INSERT INTO subjects (grade, name) VALUES (6, "Физика");
INSERT INTO subjects (grade, name) VALUES (6, "Химия");
INSERT INTO subjects (grade, name) VALUES (6, "ФизКультура");


# наполняем таблицу classes
# 33 класса (с 1го по 11й, по 3 в параллели), в каждом классе от 15 до 25 учеников
# вручную заполнять лень — пишем процедуру
#
DROP PROCEDURE IF EXISTS fill_class;
DELIMITER //
CREATE PROCEDURE fill_class()
BEGIN
  DECLARE v_grade INT UNSIGNED DEFAULT 11;
  TRUNCATE TABLE classes;
  START TRANSACTION;
  WHILE v_grade DO
	INSERT INTO classes (grade, symbol, chief, size) VALUES (v_grade, "А", v_grade*3, ROUND(RAND()*15)+10);
	INSERT INTO classes (grade, symbol, chief, size) VALUES (v_grade, "Б", v_grade*3-1, ROUND(RAND()*15)+10);
	INSERT INTO classes (grade, symbol, chief, size) VALUES (v_grade, "В", v_grade*3-2, ROUND(RAND()*15)+10);
  SET v_grade = v_grade - 1;
 END WHILE;
 COMMIT;
END
//
DELIMITER ;
CALL fill_class();


# наполняем таблицу tutors
#
INSERT INTO tutors (lastName, firstName, patronym) VALUES ("Матвеева", "Арина", "Родионовна");
INSERT INTO tutors (lastName, firstName, patronym) VALUES ("Рыбников", "Иннокентий", "Петрович");
INSERT INTO tutors (lastName, firstName, patronym) VALUES ("Бардина", "Чуча", "");
INSERT INTO tutors (lastName, firstName, patronym) VALUES ("Линдгрен", "Фрекен", "Бок");
INSERT INTO tutors (lastName, firstName, patronym) VALUES ("Поппинс", "Мэри", "Памела");
INSERT INTO tutors (lastName, firstName, patronym) VALUES ("Достоевская", "Алёна", "Фроловна");
INSERT INTO tutors (lastName, firstName, patronym) VALUES ("Пельтцер", "Татьяна", "Ивановна");
INSERT INTO tutors (lastName, firstName, patronym) VALUES ("Прутковская", "Вика", "");
INSERT INTO tutors (lastName, firstName, patronym) VALUES ("Жиакомо", "Жиан", "");
INSERT INTO tutors (lastName, firstName, patronym) VALUES ("Бальзамо", "Джузеппе", "Петрович");
INSERT INTO tutors (lastName, firstName, patronym) VALUES ("Киврин", "Фёдор", "Симеонович");
INSERT INTO tutors (lastName, firstName, patronym) VALUES ("Хунта", "Кристобаль", "Хозевич");
INSERT INTO tutors (lastName, firstName, patronym) VALUES ("Яндекс", "Анна", "Борисовна");
INSERT INTO tutors (lastName, firstName, patronym) VALUES ("Яндекс", "Борислава", "Витальевна");
INSERT INTO tutors (lastName, firstName, patronym) VALUES ("Яндекс", "Валентина", "Геннадьевна");
INSERT INTO tutors (lastName, firstName, patronym) VALUES ("Яндекс", "Галина", "Демьяновна");
INSERT INTO tutors (lastName, firstName, patronym) VALUES ("Яндекс", "Дарья", "Евгеньевна");
INSERT INTO tutors (lastName, firstName, patronym) VALUES ("Яндекс", "Евгения", "Жиановна");
INSERT INTO tutors (lastName, firstName, patronym) VALUES ("Яндекс", "Жанна", "Зиновьевна");
INSERT INTO tutors (lastName, firstName, patronym) VALUES ("Яндекс", "Зейнаб", "Ибрагимовна");
INSERT INTO tutors (lastName, firstName, patronym) VALUES ("Яндекс", "Илона", "Йоновна");
INSERT INTO tutors (lastName, firstName, patronym) VALUES ("Яндекс", "Йожи", "Кальмановна");
INSERT INTO tutors (lastName, firstName, patronym) VALUES ("Яндекс", "Катрин", "Лемовна");
INSERT INTO tutors (lastName, firstName, patronym) VALUES ("Яндекс", "Лайма", "Максимовна");
INSERT INTO tutors (lastName, firstName, patronym) VALUES ("Яндекс", "Мария", "Николаевна");
INSERT INTO tutors (lastName, firstName, patronym) VALUES ("Яндекс", "Нинель", "Онуфриевна");
INSERT INTO tutors (lastName, firstName, patronym) VALUES ("Яндекс", "Оксана", "Порфирьевна");
INSERT INTO tutors (lastName, firstName, patronym) VALUES ("Яндекс", "Павел", "Романович");
INSERT INTO tutors (lastName, firstName, patronym) VALUES ("Яндекс", "Роксана", "Станиславовна");
INSERT INTO tutors (lastName, firstName, patronym) VALUES ("Яндекс", "Сильвестр", "Сталлонович");
INSERT INTO tutors (lastName, firstName, patronym) VALUES ("Яндекс", "Светлана", "Тарасовна");
INSERT INTO tutors (lastName, firstName, patronym) VALUES ("Яндекс", "Терентий", "Ульянович");
INSERT INTO tutors (lastName, firstName, patronym) VALUES ("Яндекс", "Уфим", "Фёдорович");
INSERT INTO tutors (lastName, firstName, patronym) VALUES ("Яндекс", "Фаддей", "Харитонович");
INSERT INTO tutors (lastName, firstName, patronym) VALUES ("Яндекс", "Хельга", "Церберовна");


# наполняем таблицу log
# пишем процедуру:
# сегодня и 10 дней в прошлое,
# у каждого класса 5 уроков в день,
# предметы и учителя задаются случайно, для наших целей реалистичность не важна
#
DROP PROCEDURE IF EXISTS fill_log;
DELIMITER //
CREATE PROCEDURE fill_log()
BEGIN
    DECLARE curr_date DATE DEFAULT (CURDATE());
    DECLARE log_date DATE DEFAULT SUBDATE(CURDATE(), 10);
    DECLARE time_slot SMALLINT DEFAULT 1;
    DECLARE class SMALLINT DEFAULT 1;
    DECLARE subj_num SMALLINT DEFAULT (SELECT COUNT(*) FROM subjects);
    DECLARE tutor_num SMALLINT DEFAULT (SELECT COUNT(*) FROM tutors);

    TRUNCATE TABLE log;
    START TRANSACTION;

    WHILE log_date <= curr_date DO
        WHILE time_slot <= 5 DO
            WHILE class <= 33 DO
                INSERT INTO log (log_date, time_slot, class, subj, tutor, size) VALUES (log_date, time_slot, class, ROUND(RAND()*subj_num), ROUND(RAND()*tutor_num), ROUND(RAND()*(SELECT size FROM classes WHERE id = class)));
                SET class = class + 1;
            END WHILE;
            SET class = 1;
            SET time_slot = time_slot + 1;
        END WHILE;
        SET time_slot = 1;
        SET log_date = DATE_ADD(log_date, INTERVAL 1 DAY);
    END WHILE;
    COMMIT;
END
//
DELIMITER ;
CALL fill_log();

