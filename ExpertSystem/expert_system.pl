:-consult('./database.pl').
:-consult('./questions.pl').


% Наша экспертная система
recommend_movie():-
  ask_age(Age, CensorList), % Возраст опрашиваемого
  ask_watchers(Watchers), % Какая компания
  ask_actor(Actor, Watchers, Age), % Предпочитаемый актер или неважно
  ask_genre_list(GenreList, Watchers, Age), % Список возможных жанров на основе компании
  ask_genre_main(GenreMain, GenreList), % Выбор главного жанра
  ask_year_film(YearFilm), % Выбор Года фильма или не важно
  ask_time(Time), % Время просмотра
  ask_score(Score, Watchers),nl,!, % Важность оценки
  find_movie(CensorList, Actor, GenreMain, YearFilm, Time, Score).

  %% write(Age),nl,
  %% write(CensorList),nl,
  %% write(Watchers),nl,
  %% write(Actor),nl,
  %% write(GenreList),nl,
  %% write(GenreMain),nl,
  %% write(YearFilm),nl,
  %% write(Time),nl,
  %% write(Score).
