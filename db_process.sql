
# -Сколько проведено предметов учителями за дату (Учитель, Предмет, Кол-во уроков)
#
DROP PROCEDURE IF EXISTS count_lessons_by_Teacher;
DELIMITER //
CREATE PROCEDURE count_lessons_by_Teacher(delta INT)     # параметр определяет смещение даты отчёта в прошлое относительно "сегодня", 1 === "вчера"
BEGIN
  DECLARE log_date DATE DEFAULT (CURDATE());   # отчётная дата
  IF delta > 0 THEN SET log_date = SUBDATE(CURDATE(), delta);
  END IF;

  START TRANSACTION;
  SELECT t.lastName, t.firstName, t.patronym, s.name, COUNT(*) FROM tutors AS t LEFT JOIN  log AS l ON t.id = l.tutor LEFT JOIN subjects AS s ON l.subj = s.id WHERE (l.log_date = log_date) GROUP BY t.lastName, t.firstName, t.patronym, s.name ORDER BY t.lastName, t.firstName, t.patronym, s.name;
  COMMIT;
END
//
DELIMITER ;

CALL count_lessons_by_Teacher(0);



# -Учителя, которые не работали за дату (Учитель)
#
DROP PROCEDURE IF EXISTS count_idle_Teachers;
DELIMITER //
CREATE PROCEDURE count_idle_Teachers(delta INT)     # параметр определяет смещение даты отчёта в прошлое относительно "сегодня", 1 === "вчера"
BEGIN
  DECLARE log_date DATE DEFAULT (CURDATE());   # отчётная дата
  IF delta > 0 THEN SET log_date = SUBDATE(CURDATE(), delta);
  END IF;

  START TRANSACTION;
  SELECT log_date, t.lastName, t.firstName, t.patronym FROM tutors AS t WHERE NOT (SELECT COUNT(*) FROM log AS l WHERE (l.log_date = log_date AND l.tutor = t.id)) GROUP BY t.lastName, t.firstName, t.patronym ORDER BY t.lastName, t.firstName, t.patronym;
  COMMIT;
END
//
DELIMITER ;

# для целей этой задачи добавляем гарантированно не работавших учителей:
# Соня спит сегодня, но работала вчера,
# Ядвига не работала никогда.
# Запуск с параметром (0) покажет обеих,
# запуск с параметром (1) покажет только Ядвигу.
#
INSERT INTO tutors (lastName, firstName, patronym) VALUES ("Яндексон", "Соня", "Стахановна");
INSERT INTO tutors (lastName, firstName, patronym) VALUES ("Яндексон", "Ядвига", "Стахановна");
INSERT INTO log (log_date, time_slot, class, subj, tutor, size) VALUES (SUBDATE(CURDATE(), 1), 1, 1, 1, (SELECT id FROM tutors WHERE lastName = 'Яндексон' AND firstName = 'Соня' AND patronym = 'Стахановна' ), 11);

CALL count_idle_Teachers(0);




# -Отчет за дату (Класс, Предмет, Учитель, Всего детей в классе(сколько должно быть), Всего детей на уроке (сколько пришло))

DROP PROCEDURE IF EXISTS count_Pupils_attendance;
DELIMITER //
CREATE PROCEDURE count_Pupils_attendance(delta INT)     # параметр определяет смещение даты отчёта в прошлое относительно "сегодня", 1 === "вчера"
BEGIN
  DECLARE log_date DATE DEFAULT (CURDATE());   # отчётная дата
  IF delta > 0 THEN SET log_date = SUBDATE(CURDATE(), delta);
  END IF;

  START TRANSACTION;
  SELECT log_date, CONCAT(CAST(c.grade AS CHAR(2)), c.symbol) AS class, l.time_slot AS 'Lesson', s.name, t.lastName, t.firstName, t.patronym, l.size AS 'Pupils amount', c.size AS 'All' FROM log AS l LEFT JOIN classes AS c ON l.class = c.id LEFT JOIN tutors AS t ON l.tutor = t.id LEFT JOIN subjects AS s ON l.subj = s.id WHERE l.log_date = log_date GROUP BY log_date, c.grade, c.symbol, l.time_slot, s.name, t.lastName, t.firstName, t.patronym, c.size, l.size ORDER BY c.grade, c.symbol, l.time_slot;
  COMMIT;
END
//
DELIMITER ;

CALL count_Pupils_attendance(0);


# -Учитель и предмет за месяц, с наименьшей посещаемостью (процент от общего кол-ва. нужно найти запись с минимальным процентом).
# поскольку Предмет могут вести разные Учителя — имеет смысл разделить эти запросы, определить минимальные посещения отдельно для Учителей и для Предметов.
# сравниваем средние арифметические отношений посещаемости к списочной величине класса

# для Учителей
#
DROP PROCEDURE IF EXISTS count_denied_Tutors;
DELIMITER //
CREATE PROCEDURE count_denied_Tutors()
BEGIN
  DECLARE log_start_date DATE DEFAULT (SUBDATE(CURDATE(), INTERVAL 1 MONTH));
  DECLARE log_finish_date DATE DEFAULT (CURDATE());
  START TRANSACTION;
  SELECT t.lastName, t.firstName, t.patronym, cnt.count FROM tutors AS t, (SELECT AVG(l.size/c.size)*100 AS count, l.tutor AS tutor FROM log AS l, classes AS c WHERE l.class = c.id AND l.log_date BETWEEN log_start_date AND log_finish_date GROUP BY tutor ORDER BY count ASC LIMIT 1) AS cnt  WHERE t.id = cnt.tutor;
  COMMIT;
END
//
DELIMITER ;

CALL count_denied_Tutors();


# для Предметов
#
DROP PROCEDURE IF EXISTS count_denied_Subjects;
DELIMITER //
CREATE PROCEDURE count_denied_Subjects()
BEGIN
  DECLARE log_start_date DATE DEFAULT (SUBDATE(CURDATE(), INTERVAL 1 MONTH));
  DECLARE log_finish_date DATE DEFAULT (CURDATE());
  START TRANSACTION;
  SELECT s.grade, s.name, cnt.count FROM subjects AS s, (SELECT AVG(l.size/c.size)*100 AS count, l.subj AS subj FROM log AS l, classes AS c WHERE l.class = c.id AND l.log_date BETWEEN log_start_date AND log_finish_date GROUP BY subj ORDER BY count ASC LIMIT 1) AS cnt  WHERE s.id = cnt.subj;
  COMMIT;
END
//
DELIMITER ;

CALL count_denied_Subjects();


# для комбинации Учитель/Предмет
#
DROP PROCEDURE IF EXISTS count_denied_synthetic_Subjects_and_Tutors;
DELIMITER //
CREATE PROCEDURE count_denied_synthetic_Subjects_and_Tutors()
BEGIN
  DECLARE log_start_date DATE DEFAULT (SUBDATE(CURDATE(), INTERVAL 1 MONTH));
  DECLARE log_finish_date DATE DEFAULT (CURDATE());
  START TRANSACTION;

  SELECT s.grade, s.name, t.lastName, t.firstName, t.patronym, cnt.count FROM subjects AS s, tutors AS t, (SELECT AVG(l.size/c.size)*100 AS count, l.subj AS subj, l.tutor AS tutor FROM log AS l, classes AS c WHERE l.class = c.id AND l.log_date BETWEEN log_start_date AND log_finish_date GROUP BY subj, tutor ORDER BY count ASC LIMIT 10) AS cnt WHERE s.id = cnt.subj AND t.id = cnt.tutor ORDER BY cnt.count;
  COMMIT;
END
//
DELIMITER ;

CALL count_denied_synthetic_Subjects_and_Tutors();