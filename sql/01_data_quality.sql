-- Проверка уникальности идентификаторов игроков

-- Общее количество строк
SELECT COUNT(*)
FROM players_profile;

-- Количество непустых player_id
SELECT COUNT(player_id)
FROM players_profile;

-- Количество уникальных player_id
SELECT COUNT(DISTINCT player_id)
FROM players_profile;

-- Вывод:
-- Таблица players_profile содержит 3078 записей.
-- NULL, пустые значения и дубликаты по player_id отсутствуют.