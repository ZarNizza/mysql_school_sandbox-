# создаём таблицы
#

CREATE TABLE IF NOT EXISTS subjects (id SERIAL PRIMARY KEY, grade SMALLINT DEFAULT 0, name VARCHAR(20) DEFAULT '');
CREATE TABLE IF NOT EXISTS classes (id SERIAL PRIMARY KEY, grade SMALLINT DEFAULT 0, symbol VARCHAR(1) DEFAULT '', chief INT DEFAULT 0, size SMALLINT DEFAULT 0);
CREATE TABLE IF NOT EXISTS tutors (id SERIAL PRIMARY KEY, lastName VARCHAR(20) DEFAULT '', firstName VARCHAR(20) DEFAULT '', patronym VARCHAR(20) DEFAULT '');
CREATE TABLE IF NOT EXISTS log (id SERIAL PRIMARY KEY, log_date DATE DEFAULT (CURRENT_DATE), time_slot SMALLINT DEFAULT 0, class SMALLINT DEFAULT 0, subj SMALLINT DEFAULT 0, tutor SMALLINT DEFAULT 0, size SMALLINT DEFAULT 0);



# тестовый набор заранее определённых данных для проверки алгоритмов вводим вручную
# далее есть вариант обильного наполнения случайными данными

INSERT INTO classes (grade, symbol, chief, size) VALUES (1, 'А', 1, 20);
INSERT INTO classes (grade, symbol, chief, size) VALUES (1, 'Б', 2, 20);

INSERT INTO subjects (grade, name) VALUES (1, 'Химия');
INSERT INTO subjects (grade, name) VALUES (1, 'Физика');

INSERT INTO tutors (lastName, firstName, patronym) VALUES ('Рыбников', 'Иннокентий', 'Петрович');
INSERT INTO tutors (lastName, firstName, patronym) VALUES ('Линдгрен', 'Фрекен', 'Бок');

INSERT INTO log (time_slot, class, subj, tutor, size) VALUES (1, 1, 1, 1, 15);
INSERT INTO log (time_slot, class, subj, tutor, size) VALUES (1, 1, 1, 2, 5);
INSERT INTO log (time_slot, class, subj, tutor, size) VALUES (1, 1, 1, 1, 15);
INSERT INTO log (time_slot, class, subj, tutor, size) VALUES (1, 1, 1, 2, 5);
INSERT INTO log (time_slot, class, subj, tutor, size) VALUES (1, 1, 1, 1, 15);
INSERT INTO log (time_slot, class, subj, tutor, size) VALUES (1, 1, 1, 2, 10);
INSERT INTO log (time_slot, class, subj, tutor, size) VALUES (1, 1, 2, 1, 10);
INSERT INTO log (time_slot, class, subj, tutor, size) VALUES (1, 1, 2, 2, 20);
INSERT INTO log (time_slot, class, subj, tutor, size) VALUES (1, 1, 2, 1, 10);
INSERT INTO log (time_slot, class, subj, tutor, size) VALUES (1, 1, 2, 2, 20);
INSERT INTO log (time_slot, class, subj, tutor, size) VALUES (1, 1, 2, 1, 10);
INSERT INTO log (time_slot, class, subj, tutor, size) VALUES (1, 1, 2, 2, 20);

# ожидаемый результат посещаемости по учителям:
# 1 (Рыбников Иннокентий Петрович) - 62,5%
# 2 (Линдгрен Фрекен Бок) - 66,7%

# ожидаемый результат посещаемости по предметам:
# 1 (Химия) - 54,2%
# 2 (Физика) - 75,0%

# ожидаемый результат посещаемости по синтетическому критерию Учитель/Предмет:
# 1/1 (Химия/Рыбников) - 75%
# 1/2 (Физика/Рыбников) - 50%
# 2/1 (Химия/Линдгрен) - 33%
# 2/2 (Физика/Линдгрен) - 100%

# см. скриншоты результатов на этом объёме данных



# вариант с большими наборами данных
#
#
# наполняем таблицу subjects
#
INSERT INTO subjects (grade, name) VALUES (1, 'Сказки');
INSERT INTO subjects (grade, name) VALUES (1, 'Каляки-маляки');
INSERT INTO subjects (grade, name) VALUES (1, 'Гуляшки');
INSERT INTO subjects (grade, name) VALUES (2, 'Правописание');
INSERT INTO subjects (grade, name) VALUES (2, 'ЛевоЧитание');
INSERT INTO subjects (grade, name) VALUES (2, 'ФизКультура');
INSERT INTO subjects (grade, name) VALUES (3, 'Чтение');
INSERT INTO subjects (grade, name) VALUES (3, 'ФизКультура');
INSERT INTO subjects (grade, name) VALUES (3, 'Лепка');
INSERT INTO subjects (grade, name) VALUES (4, 'Природоведение');
INSERT INTO subjects (grade, name) VALUES (4, 'Кругозор');
INSERT INTO subjects (grade, name) VALUES (4, 'ФизКультура');
INSERT INTO subjects (grade, name) VALUES (5, 'История');
INSERT INTO subjects (grade, name) VALUES (5, 'ФизКультура');
INSERT INTO subjects (grade, name) VALUES (5, 'Математика');
INSERT INTO subjects (grade, name) VALUES (6, 'Физика');
INSERT INTO subjects (grade, name) VALUES (6, 'Химия');
INSERT INTO subjects (grade, name) VALUES (6, 'ФизКультура');


# наполняем таблицу classes
# 33 класса (с 1го по 11й, по 3 в параллели), в каждом классе от 10 до 25 учеников
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
	INSERT INTO classes (grade, symbol, chief, size) VALUES (v_grade, 'А', v_grade*3, ROUND(RAND()*15)+10);
	INSERT INTO classes (grade, symbol, chief, size) VALUES (v_grade, 'Б', v_grade*3-1, ROUND(RAND()*15)+10);
	INSERT INTO classes (grade, symbol, chief, size) VALUES (v_grade, 'В', v_grade*3-2, ROUND(RAND()*15)+10);
  SET v_grade = v_grade - 1;
 END WHILE;
 COMMIT;
END
//
DELIMITER ;
CALL fill_class();


# наполняем таблицу tutors
#
INSERT INTO tutors (lastName, firstName, patronym) VALUES ('Матвеева', 'Арина', 'Родионовна');
INSERT INTO tutors (lastName, firstName, patronym) VALUES ('Рыбников', 'Иннокентий', 'Петрович');
INSERT INTO tutors (lastName, firstName, patronym) VALUES ('Бардина', 'Чуча', '');
INSERT INTO tutors (lastName, firstName, patronym) VALUES ('Линдгрен', 'Фрекен', 'Бок');
INSERT INTO tutors (lastName, firstName, patronym) VALUES ('Поппинс', 'Мэри', 'Памела');
INSERT INTO tutors (lastName, firstName, patronym) VALUES ('Достоевская', 'Алёна', 'Фроловна');
INSERT INTO tutors (lastName, firstName, patronym) VALUES ('Пельтцер', 'Татьяна', 'Ивановна');
INSERT INTO tutors (lastName, firstName, patronym) VALUES ('Прутковская', 'Вика', '');
INSERT INTO tutors (lastName, firstName, patronym) VALUES ('Жиакомо', 'Жиан', '');
INSERT INTO tutors (lastName, firstName, patronym) VALUES ('Бальзамо', 'Джузеппе', 'Петрович');
INSERT INTO tutors (lastName, firstName, patronym) VALUES ('Киврин', 'Фёдор', 'Симеонович');
INSERT INTO tutors (lastName, firstName, patronym) VALUES ('Хунта', 'Кристобаль', 'Хозевич');
INSERT INTO tutors (lastName, firstName, patronym) VALUES ('Яндексон', 'Анна', 'Борисовна');
INSERT INTO tutors (lastName, firstName, patronym) VALUES ('Яндексон', 'Борислава', 'Витальевна');
INSERT INTO tutors (lastName, firstName, patronym) VALUES ('Яндексон', 'Валентина', 'Геннадьевна');
INSERT INTO tutors (lastName, firstName, patronym) VALUES ('Яндексон', 'Галина', 'Демьяновна');
INSERT INTO tutors (lastName, firstName, patronym) VALUES ('Яндексон', 'Дарья', 'Евгеньевна');
INSERT INTO tutors (lastName, firstName, patronym) VALUES ('Яндексон', 'Евгения', 'Жиановна');
INSERT INTO tutors (lastName, firstName, patronym) VALUES ('Яндексон', 'Жанна', 'Зиновьевна');
INSERT INTO tutors (lastName, firstName, patronym) VALUES ('Яндексон', 'Зейнаб', 'Ибрагимовна');
INSERT INTO tutors (lastName, firstName, patronym) VALUES ('Яндексон', 'Илона', 'Йоновна');
INSERT INTO tutors (lastName, firstName, patronym) VALUES ('Яндексон', 'Йожи', 'Кальмановна');
INSERT INTO tutors (lastName, firstName, patronym) VALUES ('Яндексон', 'Катрин', 'Лемовна');
INSERT INTO tutors (lastName, firstName, patronym) VALUES ('Яндексон', 'Лайма', 'Максимовна');
INSERT INTO tutors (lastName, firstName, patronym) VALUES ('Яндексон', 'Мария', 'Николаевна');
INSERT INTO tutors (lastName, firstName, patronym) VALUES ('Яндексон', 'Нинель', 'Онуфриевна');
INSERT INTO tutors (lastName, firstName, patronym) VALUES ('Яндексон', 'Оксана', 'Порфирьевна');
INSERT INTO tutors (lastName, firstName, patronym) VALUES ('Яндексон', 'Павел', 'Романович');
INSERT INTO tutors (lastName, firstName, patronym) VALUES ('Яндексон', 'Роксана', 'Станиславовна');
INSERT INTO tutors (lastName, firstName, patronym) VALUES ('Яндексон', 'Сильвестр', 'Сталлонович');
INSERT INTO tutors (lastName, firstName, patronym) VALUES ('Яндексон', 'Светлана', 'Тарасовна');
INSERT INTO tutors (lastName, firstName, patronym) VALUES ('Яндексон', 'Терентий', 'Ульянович');
INSERT INTO tutors (lastName, firstName, patronym) VALUES ('Яндексон', 'Уфим', 'Фёдорович');
INSERT INTO tutors (lastName, firstName, patronym) VALUES ('Яндексон', 'Фаддей', 'Харитонович');
INSERT INTO tutors (lastName, firstName, patronym) VALUES ('Яндексон', 'Хельга', 'Церберовна');


# наполняем таблицу log

# для большого набора данных пишем процедуру fill_log:
#  - сегодня и 10 дней в прошлое,
#  - у каждого класса 5 уроков в день,
#  - предметы и учителя задаются случайно, первому классу может выпасть урок для 11го, но для наших целей реалистичность не так важна
#
DROP PROCEDURE IF EXISTS fill_log;
DELIMITER //
CREATE PROCEDURE fill_log()
BEGIN
    DECLARE curr_date DATE DEFAULT (CURRENT_DATE);
    DECLARE log_date DATE DEFAULT SUBDATE(CURRENT_DATE, 10);
    DECLARE time_slot SMALLINT DEFAULT 1;
    DECLARE class SMALLINT DEFAULT 1;
    DECLARE subj_num SMALLINT DEFAULT (SELECT COUNT(*) FROM subjects);
    DECLARE tutor_num SMALLINT DEFAULT (SELECT COUNT(*) FROM tutors);

    TRUNCATE TABLE log;
    START TRANSACTION;

    WHILE log_date <= curr_date DO
        WHILE time_slot <= 5 DO
            WHILE class <= 33 DO
                INSERT INTO log (log_date, time_slot, class, subj, tutor, size) VALUES (log_date, time_slot, class, ROUND(1 + RAND() * (subj_num - 1)), ROUND(1 + RAND() * (tutor_num - 1)), ROUND(RAND() * (SELECT size FROM classes WHERE id = class)));
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

