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

INSERT INTO tutors (lastName, firstName, patronym) VALUES ('Рыбников', 'Иннокентий', 'Петрович'),('Линдгрен', 'Фрекен', 'Бок');

INSERT INTO log (time_slot, class, subj, tutor, size)
VALUES
(1, 1, 1, 1, 15),
(1, 1, 1, 2, 5),
(1, 1, 1, 1, 15),
(1, 1, 1, 2, 5),
(1, 1, 1, 1, 15),
(1, 1, 1, 2, 10),
(1, 1, 2, 1, 10),
(1, 1, 2, 2, 20),
(1, 1, 2, 1, 10),
(1, 1, 2, 2, 20),
(1, 1, 2, 1, 10),
(1, 1, 2, 2, 20);

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
INSERT INTO subjects (grade, name) VALUES
(1, 'Сказки'),
(1, 'Каляки-маляки'),
(1, 'Гуляшки'),
(2, 'Правописание'),
(2, 'ЛевоЧитание'),
(2, 'ФизКультура'),
(3, 'Чтение'),
(3, 'ФизКультура'),
(3, 'Лепка'),
(4, 'Природоведение'),
(4, 'Кругозор'),
(4, 'ФизКультура'),
(5, 'История'),
(5, 'ФизКультура'),
(5, 'Математика'),
(6, 'Физика'),
(6, 'Химия'),
(6, 'ФизКультура');


# наполняем таблицу classes
# 33 класса (с 1го по 11й, по 3 в параллели), в каждом классе от 10 до 25 учеников
# вручную заполнять лень — пишем процедуру
#
DROP PROCEDURE IF EXISTS fill_class;

CREATE OR REPLACE PROCEDURE fill_class() as
$$
DECLARE
    v_grade INT := 11;
BEGIN
  TRUNCATE TABLE classes;
  WHILE v_grade > 0 loop
	INSERT INTO classes (grade, symbol, chief, size) VALUES (v_grade, 'А', v_grade*3, ROUND(RANDOM()*15)+10);
	INSERT INTO classes (grade, symbol, chief, size) VALUES (v_grade, 'Б', v_grade*3-1, ROUND(RANDOM()*15)+10);
	INSERT INTO classes (grade, symbol, chief, size) VALUES (v_grade, 'В', v_grade*3-2, ROUND(RANDOM()*15)+10);
    v_grade := v_grade - 1;
 END loop;
END
$$ language plpgsql;

CALL fill_class();


# наполняем таблицу tutors
#
INSERT INTO tutors (lastName, firstName, patronym) VALUES
('Матвеева', 'Арина', 'Родионовна'),
('Рыбников', 'Иннокентий', 'Петрович'),
('Бардина', 'Чуча', ''),
('Линдгрен', 'Фрекен', 'Бок'),
('Поппинс', 'Мэри', 'Памела'),
('Достоевская', 'Алёна', 'Фроловна'),
('Пельтцер', 'Татьяна', 'Ивановна'),
('Прутковская', 'Вика', ''),
('Жиакомо', 'Жиан', ''),
('Бальзамо', 'Джузеппе', 'Петрович'),
('Киврин', 'Фёдор', 'Симеонович'),
('Хунта', 'Кристобаль', 'Хозевич'),
('Яндексон', 'Анна', 'Борисовна'),
('Яндексон', 'Борислава', 'Витальевна'),
('Яндексон', 'Валентина', 'Геннадьевна'),
('Яндексон', 'Галина', 'Демьяновна'),
('Яндексон', 'Дарья', 'Евгеньевна'),
('Яндексон', 'Евгения', 'Жиановна'),
('Яндексон', 'Жанна', 'Зиновьевна'),
('Яндексон', 'Зейнаб', 'Ибрагимовна'),
('Яндексон', 'Илона', 'Йоновна'),
('Яндексон', 'Йожи', 'Кальмановна'),
('Яндексон', 'Катрин', 'Лемовна'),
('Яндексон', 'Лайма', 'Максимовна'),
('Яндексон', 'Мария', 'Николаевна'),
('Яндексон', 'Нинель', 'Онуфриевна'),
('Яндексон', 'Оксана', 'Порфирьевна'),
('Яндексон', 'Павел', 'Романович'),
('Яндексон', 'Роксана', 'Станиславовна'),
('Яндексон', 'Сильвестр', 'Сталлонович'),
('Яндексон', 'Светлана', 'Тарасовна'),
('Яндексон', 'Терентий', 'Ульянович'),
('Яндексон', 'Уфим', 'Фёдорович'),
('Яндексон', 'Фаддей', 'Харитонович'),
('Яндексон', 'Хельга', 'Церберовна');


# наполняем таблицу log

# для большого набора данных пишем процедуру fill_log:
#  - сегодня и 10 дней в прошлое,
#  - у каждого класса 5 уроков в день,
#  - предметы и учителя задаются случайно, первому классу может выпасть урок для 11го, но для наших целей реалистичность не так важна
#
DROP PROCEDURE IF EXISTS fill_log;

CREATE OR REPLACE PROCEDURE fill_log() as
$$
    DECLARE curr_date DATE := CURRENT_DATE;
    DECLARE log_date DATE := CURRENT_DATE - interval '10 days';
    DECLARE time_slot SMALLINT := 1;
    DECLARE class SMALLINT := 1;
    DECLARE subj_num SMALLINT := (SELECT COUNT(*) FROM subjects);
    DECLARE tutor_num SMALLINT := (SELECT COUNT(*) FROM tutors);

BEGIN
    TRUNCATE TABLE log;

    WHILE log_date <= curr_date LOOP
        WHILE time_slot <= 5 LOOP
            WHILE class <= 33 LOOP
                INSERT INTO log (log_date, time_slot, class, subj, tutor, size) VALUES (log_date, time_slot, class, ROUND(1 + RANDOM() * (subj_num - 1)), ROUND(1 + RANDOM() * (tutor_num - 1)), ROUND(RANDOM() * (SELECT size FROM classes WHERE id = class)));
                class := class + 1;
            END LOOP;
            class := 1;
            time_slot := time_slot + 1;
        END LOOP;
        time_slot := 1;
        log_date:= log_date + INTERVAL '1 DAY';
    END LOOP;
END
$$ language plpgsql;

CALL fill_log();

