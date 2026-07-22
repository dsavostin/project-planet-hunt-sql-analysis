/* 
Проверка качества данных

Задача:
Определить наличие пропусков и повторных регистраций пользователей.
*/

SELECT COUNT(*) AS cnt_players -- общее количество регистраций
     , COUNT(player_id) AS cnt_players_all -- проверка наличия регистраций без player_id
     , COUNT(DISTINCT player_id) AS uniq_players -- проверка на повторные регистрации
FROM planet_hunt.players_profile;

/*
Вывод:
Количество записей, заполненных player_id и уникальных игроков совпадает.
Повторные регистрации и пропуски в player_id отсутствуют.
*/

