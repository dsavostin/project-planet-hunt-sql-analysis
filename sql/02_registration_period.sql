/* 
Проверка периода регистрации пользователей

Бизнес-вопросы:
1. Какой временной период покрывают данные?
2. Есть ли пользователи без даты регистрации?
3. Соответствует ли количество регистраций общему количеству игроков?
*/

SELECT COUNT(registration_date) AS cnt_reg -- количество регистраций без NULL
     , SUM(CASE WHEN registration_date IS NULL THEN 1 ELSE 0 END) AS null_registration_dates -- пользователи без даты регистрации
     , MIN(registration_date) AS first_registration_date -- первая регистрация
     , MAX(registration_date) AS last_registration_date -- последняя регистрация
FROM planet_hunt.players_profile;