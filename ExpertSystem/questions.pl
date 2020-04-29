:-consult('./facts.pl').
:-consult('./predicates.pl').
% Возрат
ask_age(Age, CensorList):-
  write('How old are you?'),nl,
  read(Age),censor(CensorList,Age).

%Кто смотрит
ask_watchers(Watchers):-
  write('Who do you want to watch a movie with?'),nl,
  write('1. Alone'),nl,
  write('2. Family'),nl,
  write('3. Company'),nl,
  read(WatchersNumber),
  watchers_number(Watchers,WatchersNumber).


%Актер
ask_actor(Actor,Watchers,Age):-
  alone(Watchers),
  (teenager(Age);adult_teenager(Age);adult(Age)),
  write('Want to see a specific actor?(y[es] or n[o])'),nl,
  yes_or_no(),
  ask_specific_actor(Actor).

ask_actor(Actor,_, _):-
  all_actors(Actor).

ask_specific_actor(Actor):-
  write('Select specific actor'),nl,
  top_actors(Actors),
  write_list_number(Actors,1),
  read(ActorNumber),
  indexOf(Actors,Actor,ActorNumber).


% Список жанров
ask_genre_list(GenreList,Watchers, Age):-
% можно расширять по опредлению личности
  alone(Watchers),
  ask_mood(Mood),
  genre_mood(GenreListMood,Mood),
  genre_age(GenreListAge, Age),
  intersection(GenreListMood, GenreListAge, GenreList).

ask_genre_list(GenreList, Watchers,_):-
  family(Watchers),
  genre_family(GenreList).

ask_genre_list(GenreList, Watchers, _):-
  company(Watchers),
  genre_company(GenreList).

%  Настроение если один
ask_mood(Result):-
  write('Your mood?'),nl,
  write('1. Happy'),nl,
  write('2. Normal'),nl,
  write('3. Sad'),nl,
  read(MoodNumber),
  mood_number(Result,MoodNumber).

% Главный жанр
ask_genre_main(Genre, GenreList):-
  write('Choose a suitable genre'),nl,
  write_list_number(GenreList,1),
  read(GenreNumber),
  indexOf(GenreList,Genre, GenreNumber).



% Год выхода фильма
ask_year_film(YearFilm):-
  write('Is the year of release important?(y[es] or n[o])'),nl,
  yes_or_no(),
  write('Select year of manufacture'),nl,
  write('1. ....-1980'),nl,
  write('2. 1980-2000'),nl,
  write('3. 2000-2010'),nl,
  write('4. 2010-2020'),nl,
  read(YearFilmNumber),
  year_film_number(YearFilm, YearFilmNumber).



ask_year_film(YearFilm):-
  all_year_film(YearFilm).

% Сколько времени у смотрящего
ask_time(Time):-
  write('Do you have a lot of time?(y[es] or n[o])'),nl,
  yes_or_no(),
  ask_realy_time(Time).

ask_time(Time):-few_time(Time).

ask_realy_time(Time):-
  write('Realy?(y[es] or n[o])'),nl,
  yes_or_no(),
  lot_time(Time).

ask_realy_time(Time):-
  medium_time(Time).



% Оценка фильма если один
ask_score(Score, Watchers):-
  (alone(Watchers);family(Watchers)),
  write('Important score?(y[es] or n[o])'),nl,
  yes_or_no(),
  important_score(Score).


ask_score(Score, _):-
    non_important_score(Score).

% Вспомогательный для узнание факта из списка
write_list_number([],_).

write_list_number([H|Tail], N):-
    format('~w. ~w',[N,H]),nl,
    N1 is N+1,
    write_list_number(Tail,N1).

% Предикат списка.
indexOf([Element|_], Element, 1). % We found the element
indexOf([_|Tail], Element, Index):-
  indexOf(Tail, Element, Index1), % Check in the tail of the list
  Index is Index1+1.
