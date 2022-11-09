
# -Сколько проведено предметов учителями за дату (Учитель, Предмет, Кол-во уроков)
#
DROP PROCEDURE IF EXISTS count_lessons_by_Teacher;
DELIMITER //
CREATE PROCEDURE count_lessons_by_Teacher(delta INT)	# parameter keep an offset from current date
BEGIN
  DECLARE log_date DATE DEFAULT (CURDATE());   # отчётная дата, 1 === "вчера"
  IF delta > 0 THEN SET log_date = SUBDATE(CURDATE(), delta);
  END IF;

  START TRANSACTION;
  SELECT t.lastName, t.firstName, t.patronym, s.name, COUNT(*) FROM tutors AS t LEFT JOIN  log AS l ON t.id = l.tutor LEFT JOIN subjects AS s ON l.subj = s.id WHERE (l.log_date = log_date) GROUP BY t.lastName, t.firstName, t.patronym, s.name ORDER BY t.lastName, t.firstName, t.patronym, s.name;
  COMMIT;
END
//
DELIMITER ;

CALL count_lessons_by_Teacher(1);



# -Учителя, которые не работали за дату (Учитель)
#
DROP PROCEDURE IF EXISTS count_idle_Teachers;
DELIMITER //
CREATE PROCEDURE count_idle_Teachers(delta INT)	# parameter keep an offset from current date
BEGIN
  DECLARE log_date DATE DEFAULT (CURDATE());   # отчётная дата, 1 === "вчера"
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

CALL count_idle_Teachers(1);




# -Отчет за дату (Класс, Предмет, Учитель, Всего детей в классе(сколько должно быть), Всего детей на уроке (сколько пришло))

DROP PROCEDURE IF EXISTS count_Pupils_attendance;
DELIMITER //
CREATE PROCEDURE count_Pupils_attendance(delta INT)	# parameter keep an offset from current date
BEGIN
  DECLARE log_date DATE DEFAULT (CURDATE());   # отчётная дата, 1 === "вчера"
  IF delta > 0 THEN SET log_date = SUBDATE(CURDATE(), delta);
  END IF;

  START TRANSACTION;
  SELECT log_date, c.grade, c.symbol, l.time_slot, s.name, t.lastName, t.firstName, t.patronym, c.size, l.size FROM log AS l LEFT JOIN classes AS c ON l.class = c.id LEFT JOIN tutors AS t ON l.tutor = t.id LEFT JOIN subjects AS s ON l.subj = s.id WHERE l.log_date = log_date GROUP BY log_date, c.grade, c.symbol, l.time_slot, s.name, t.lastName, t.firstName, t.patronym, c.size, l.size ORDER BY c.grade, c.symbol, l.time_slot;
  COMMIT;
END
//
DELIMITER ;

CALL count_Pupils_attendance(1);


# -Учитель и предмет за месяц, с наименьшей посещаемостью (процент от общего кол-ва. нужно найти запись с минимальным процентом).

DROP PROCEDURE IF EXISTS count_denied;
DELIMITER //
CREATE PROCEDURE count_denied(delta INT)	# parameter keep an offset from current date
BEGIN
  DECLARE log_date DATE DEFAULT (CURDATE());   # отчётная дата, 1 === "вчера"
  IF delta > 0 THEN SET log_date = SUBDATE(CURDATE(), delta);
  END IF;

  START TRANSACTION;
#  SELECT log_date, c.grade, c.symbol, l.time_slot, s.name, t.lastName, t.firstName, t.patronym, c.size, l.size FROM log AS l LEFT JOIN classes AS c ON l.class = c.id LEFT JOIN tutors AS t ON l.tutor = t.id LEFT JOIN subjects AS s ON l.subj = s.id WHERE l.log_date = log_date GROUP BY log_date, c.grade, c.symbol, l.time_slot, s.name, t.lastName, t.firstName, t.patronym, c.size, l.size ORDER BY c.grade, c.symbol, l.time_slot;
  COMMIT;
END
//
DELIMITER ;

CALL count_denied(1);

