-- phpMyAdmin SQL Dump
-- version 5.2.1
-- https://www.phpmyadmin.net/
--
-- Хост: 127.0.0.1
-- Время создания: Ноя 21 2026 г., 09:05
-- Версия сервера: 10.4.28-MariaDB
-- Версия PHP: 8.2.4

SET SQL_MODE = "NO_AUTO_VALUE_ON_ZERO";
START TRANSACTION;
SET time_zone = "+00:00";


/*!40101 SET @OLD_CHARACTER_SET_CLIENT=@@CHARACTER_SET_CLIENT */;
/*!40101 SET @OLD_CHARACTER_SET_RESULTS=@@CHARACTER_SET_RESULTS */;
/*!40101 SET @OLD_COLLATION_CONNECTION=@@COLLATION_CONNECTION */;
/*!40101 SET NAMES utf8mb4 */;

--
-- База данных: `restaran_db`
--

-- --------------------------------------------------------

--
-- Структура таблицы `guests`
--

CREATE TABLE `guests` (
  `id` int(11) NOT NULL AUTO_INCREMENT,
  `phone` varchar(20) DEFAULT NULL,
  `name` varchar(20) DEFAULT NULL,
  `is_regular` tinyint(1) DEFAULT NULL,
  PRIMARY KEY (`id`),
  UNIQUE KEY `phone` (`phone`)
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_general_ci;

--
-- Дамп данных таблицы `guests`
--

INSERT INTO `guests` (`id`, `phone`, `name`, `is_regular`) VALUES
(1, '+7 900 111-22-33', 'Арсений', 1),
(2, '+7 900 222-33-44', 'Алина', 1),
(3, '+7 900 333-44-55', 'Василий', 0),
(4, '+7 940 111-22-33', 'Лина', 1),
(5, '+7 920 223-33-44', 'Зоя', 0),
(6, '+7 950 334-44-55', 'Даня', 0),
(7, '+7 945 321-44-21', 'Алёна', 1),
(8, '+7 943 354-44-23', 'Егор', 1),
(9, '+7 923 334-44-53', 'Артём', 0);

-- --------------------------------------------------------

--
-- Структура таблицы `reserv`
--

CREATE TABLE `reserv` (
  `id` int(11) NOT NULL,
  `table_id` int(11) DEFAULT NULL,
  `guest_id` int(11) DEFAULT NULL,
  `res_date` datetime DEFAULT NULL,
  `persons` int(11) DEFAULT NULL,
  `statuss` varchar(50) DEFAULT NULL,
  `notes` varchar(255) DEFAULT NULL
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_general_ci;

--
-- Дамп данных таблицы `reserv`
--

INSERT INTO `reserv` (`id`, `table_id`, `guest_id`, `res_date`, `persons`, `statuss`, `notes`) VALUES
(1, 1, 1, '2026-11-01 18:00:00', 4, 'Пришёл', NULL),
(3, 3, 2, '2026-11-02 20:00:00', 2, 'Подтверждена', NULL),
(4, 1, 3, '2026-11-03 18:30:00', 4, 'Подтверждена', NULL),
(5, 2, 4, '2026-11-04 19:00:00', 2, 'Гость в зале', NULL),
(6, 3, 8, '2026-11-05 21:00:00', 6, 'Отменена', NULL);

-- --------------------------------------------------------

--
-- Структура таблицы `tables`
--

CREATE TABLE `tables` (
  `id` int(11) NOT NULL,
  `capacity` int(11) DEFAULT NULL,
  `location` varchar(100) DEFAULT NULL,
  `is_combinable` tinyint(1) DEFAULT NULL
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_general_ci;

--
-- Дамп данных таблицы `tables`
--

INSERT INTO `tables` (`id`, `capacity`, `location`, `is_combinable`) VALUES
(1, 4, 'у окна', 1),
(2, 2, 'у сцены', 0),
(3, 6, 'в центре', 1);

--
-- Индексы сохранённых таблиц
--

--
-- Индексы таблицы `guests`
--
ALTER TABLE `guests`
  ADD PRIMARY KEY (`id`),
  ADD UNIQUE KEY `phone` (`phone`);

--
-- Индексы таблицы `reserv`
--
ALTER TABLE `reserv`
  ADD PRIMARY KEY (`id`),
  ADD KEY `table_id` (`table_id`),
  ADD KEY `guest_id` (`guest_id`);

--
-- Индексы таблицы `tables`
--
ALTER TABLE `tables`
  ADD PRIMARY KEY (`id`);

--
-- Ограничения внешнего ключа сохраненных таблиц
--

--
-- Ограничения внешнего ключа таблицы `reserv`
--
ALTER TABLE `reserv`
  ADD CONSTRAINT `reserv_ibfk_1` FOREIGN KEY (`table_id`) REFERENCES `tables` (`id`),
  ADD CONSTRAINT `reserv_ibfk_2` FOREIGN KEY (`guest_id`) REFERENCES `guests` (`id`);
COMMIT;

/*!40101 SET CHARACTER_SET_CLIENT=@OLD_CHARACTER_SET_CLIENT */;
/*!40101 SET CHARACTER_SET_RESULTS=@OLD_CHARACTER_SET_RESULTS */;
/*!40101 SET COLLATION_CONNECTION=@OLD_COLLATION_CONNECTION */;


SELECT 
    Guests.name AS Имя_гостя,
    Guests.phone AS Телефон
FROM Guests
WHERE Guests.is_regular = 1
ORDER BY Guests.name ASC;

SELECT 
    Guests.name AS Имя_гостя,
    Tables.location AS Место_стола,
    Reserv.res_date AS Дата_визита,
    Reserv.persons AS Гостей,
    Reserv.statuss AS Статус
FROM Reserv
JOIN Guests ON Guests.id = Reserv.guest_id
JOIN Tables ON Tables.id = Reserv.table_id
WHERE Reserv.statuss = 'Подтверждена'
ORDER BY Reserv.res_date ASC;

SELECT 
    Guests.name AS Имя_гостя,
    COUNT(Reserv.id) AS Количество_броней
FROM Guests
JOIN Reserv ON Guests.id = Reserv.guest_id
GROUP BY Guests.id, Guests.name
HAVING COUNT(Reserv.id) > 1
ORDER BY Количество_броней DESC;

SELECT 
    SUM(persons) AS Всего_гостей,
    AVG(persons) AS Среднее_гостей,
    MAX(persons) AS Максимум_гостей,
    MIN(persons) AS Минимум_гостей,
    COUNT(*) AS Всего_броней
FROM reserv;

SELECT 
    SUM(persons) AS Всего_гостей,
    AVG(persons) AS Среднее_гостей,
    MAX(persons) AS Максимум_гостей,
    MIN(persons) AS Минимум_гостей,
    COUNT(*) AS Всего_броней
FROM reserv;

SELECT 
    Guests.name AS Имя_гостя,
    Reserv.res_date AS Дата_визита,
    Reserv.statuss AS Статус,
    CASE 
        WHEN Reserv.statuss IN ('Пришёл', 'Гость в зале') THEN 'Обслуживается'
        WHEN Reserv.statuss = 'Подтверждена' THEN 'Ожидается'
        WHEN Reserv.statuss = 'Отменена' THEN 'Отменено'
        ELSE 'Неизвестно'
    END AS Состояние
FROM Reserv
JOIN Guests ON Guests.id = Reserv.guest_id
ORDER BY Reserv.res_date;


SELECT name AS Имя_гостя, phone AS Телефон
FROM guests
WHERE id IN (
    SELECT guest_id 
    FROM reserv 
    JOIN tables ON reserv.table_id = tables.id
    WHERE tables.capacity > ALL (
        SELECT capacity 
        FROM tables 
        WHERE location = 'у сцены'
    )
);

DELIMITER //
CREATE PROCEDURE calculate_reserv_stats()
BEGIN
    DECLARE avg_persons DECIMAL(10,2);
    DECLARE sum_persons INT;
    DECLARE min_persons INT;
    DECLARE max_persons INT;

    SELECT AVG(persons), SUM(persons), MIN(persons), MAX(persons)
    INTO avg_persons, sum_persons, min_persons, max_persons
    FROM reserv;
 
    INSERT INTO stats_log (metric_name, metric_value, calculated_at) VALUES
        ('avg_persons', avg_persons, NOW()),
        ('sum_persons', sum_persons, NOW()),
        ('min_persons', min_persons, NOW()),
        ('max_persons', max_persons, NOW());
END //
DELIMITER ;

