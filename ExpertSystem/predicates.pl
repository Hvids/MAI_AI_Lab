:-consult('./facts.pl').

yes_or_no():-
  read(Y),
  (Y = yes; Y = y).

% Достпупные цензоры для каждого возраста
censor(CensorList, Age):-
  child(Age), CensorList = ['G'].
censor(CensorList, Age):-
  teenager(Age), CensorList = ['G', 'PG'].
censor(CensorList, Age):-
  adult_teenager(Age), CensorList = ['G','PG','NC-17'].
censor(CensorList, Age):-
  adult(Age), CensorList = ['G','PG', 'NC-17','R'].

% Соответствие сморящих и выбранного номера в списке
watchers_number(Watchers,1):-alone(Watchers).
watchers_number(Watchers,2):-family(Watchers).
watchers_number(Watchers,3):-company(Watchers).

% Соответствие настрония и выбранного номера в списке
mood_number(Mood, 1):-happy(Mood).
mood_number(Mood, 2):-normal(Mood).
mood_number(Mood, 3):-sad(Mood).

% Год фильма и выбранного номера в списке
year_film_number(YearFilm, 1):-over_old_film(YearFilm).
year_film_number(YearFilm, 2):-old_film(YearFilm).
year_film_number(YearFilm, 3):-near_present_film(YearFilm).
year_film_number(YearFilm, 4):-new_film(YearFilm).

% Возраст целовека
child(Age):-
  Age >=0, Age<13.
teenager(Age):-
  Age > 12, Age<17.
adult_teenager(Age):-
  Age = 17.
adult(Age):-
  Age >= 18.


%% Предикаты для работы с поиском фильма
%%
find_censor(MyCensorList, Censor):-
  member(Censor, MyCensorList).

find_score(important, Score):-
  Score > 7.

find_score(non_important, _).

find_actor(all, _, _).

find_actor(MyActor, Actor1, Actor2):-
  MyActor = Actor1;
  MyActor = Actor2.

% Временной промежуток и год значения в базе
find_year(all, _).

find_year(MyYear, Year):-
  over_old_film_value(Year),
  over_old_film(MyYear).


find_year(MyYear, Year):-
  old_film_value(Year),
  old_film(MyYear).


find_year(MyYear, Year):-
  near_present_film_value(Year),
  near_present_film(MyYear).


find_year(MyYear, Year):-
  new_film_value(Year),
  new_film(MyYear).

% Временной промежуток и продолжительность фильма в базе
find_time(MyTime,Time):-
  few_time_value(Time),
  few_time(MyTime).

find_time(MyTime,Time):-
  medium_time_value(Time),
  medium_time(MyTime).

find_time(MyTime,Time):-
  lot_time_value(Time),
  lot_time(MyTime).

find_genre(MyGenre, GenreList):-
  member(MyGenre, GenreList).


% Жанр по настронию
genre_mood(GenreList,Mood):-
  happy(Mood),
  genre_happy(GenreList).

genre_mood(GenreList,Mood):-
  sad(Mood),
  genre_sad(GenreList).

genre_mood(GenreList,Mood):-
  normal(Mood),
  genre_normal(GenreList).

% Жанр по ворасту
genre_age(GenreList,Age):-
  child(Age),
  genre_child(GenreList).

genre_age(GenreList,Age):-
  teenager(Age),
  genre_teenager(GenreList).

genre_age(GenreList,Age):-
  adult_teenager(Age),
  genre_adult_tenager(GenreList).

genre_age(GenreList,Age):-
  adult(Age),
  genre_adult(GenreList).


% Время просмотра
few_time_value(Time):-
  Time < 100.

medium_time_value(Time):-
  Time>=100,Time<140.

lot_time_value(Time):-
  Time>=140.


% Важность года выпуска фильма
over_old_film_value(Val):-
  Val < 1980.

old_film_value(Val):-
  Val >= 1980 , Val < 2000.

near_present_film_value(Val):-
  Val >= 2000 , Val < 2010.

new_film_value(Val):-
  Val >=2010.


print_film(Film, Director, Year, GenreList, Time, Actor1, Actor2, Score, Censor, Site):-
  format("Film: ~w",Film),nl,
  format("Director: ~w",Director),nl,
  format("Year: ~w",Year),nl,
  write("GenreList: "),
  print(GenreList),nl,
  format("Time: ~w",Time),nl,
  format("Actor1: ~w",Actor1),nl,
  format("Actor2: ~w",Actor2),nl,
  format("Score: ~w",Score),nl,
  format("Censor: ~w",Censor),nl,
  format("Site: ~w\n",Site),nl.

find_movie(MyCensorList, MyActor, MyGenre, MyYear, MyTime, MyScore):-
  film(Film, Director, Year, GenreList, Time, Censor, Actor1, Actor2, Score, Site),
  find_score(MyScore, Score),
  find_actor(MyActor, Actor1, Actor2),
  find_time(MyTime, Time),
  find_year(MyYear, Year),
  find_genre(MyGenre, GenreList),
  find_censor(MyCensorList, Censor),
  print_film(Film, Director, Year, GenreList, Time, Actor1, Actor2, Score, Censor, Site).
  

find_movie(MyCensorList, MyActor, MyGenre, MyYear, _, MyScore):-
  film(Film, Director, Year, GenreList, Time, Censor, Actor1, Actor2, Score, Site),
  find_score(MyScore, Score),
  find_actor(MyActor, Actor1, Actor2),
  %% find_time(MyTime, Time),
  find_year(MyYear, Year),
  find_genre(MyGenre, GenreList),
  find_censor(MyCensorList, Censor),
  print_film(Film, Director, Year, GenreList, Time, Actor1, Actor2, Score, Censor, Site).

find_movie(MyCensorList, MyActor, MyGenre, _, _, MyScore):-
  film(Film, Director, Year, GenreList, Time, Censor, Actor1, Actor2, Score, Site),
  find_score(MyScore, Score),
  find_actor(MyActor, Actor1, Actor2),
  %% find_time(MyTime, Time),
  %% find_year(MyYear, Year),
  find_genre(MyGenre, GenreList),
  find_censor(MyCensorList, Censor),
  print_film(Film, Director, Year, GenreList, Time, Actor1, Actor2, Score, Censor, Site).

find_movie(MyCensorList, _, MyGenre, _, _, MyScore):-
  film(Film, Director, Year, GenreList, Time, Censor, Actor1, Actor2, Score, Site),
  find_score(MyScore, Score),
  %% find_actor(MyActor, Actor1, Actor2),
  %% find_time(MyTime, Time),
  %% find_year(MyYear, Year),
  find_genre(MyGenre, GenreList),
  find_censor(MyCensorList, Censor),
  print_film(Film, Director, Year, GenreList, Time, Actor1, Actor2, Score, Censor, Site).

find_movie(MyCensorList, _, MyGenre, _, _, _):-
  film(Film, Director, Year, GenreList, Time, Censor, Actor1, Actor2, Score, Site),
  %% find_score(MyScore, Score),
  %% find_actor(MyActor, Actor1, Actor2),
  %% find_time(MyTime, Time),
  %% find_year(MyYear, Year),
  find_genre(MyGenre, GenreList),
  find_censor(MyCensorList, Censor),
  print_film(Film, Director, Year, GenreList, Time, Actor1, Actor2, Score, Censor, Site).

find_movie(MyCensorList, _, _, _, _, _):-
  film(Film, Director, Year, GenreList, Time, Censor, Actor1, Actor2, Score, Site),
  %% find_score(MyScore, Score),
  %% find_actor(MyActor, Actor1, Actor2),
  %% find_time(MyTime, Time),
  %% find_year(MyYear, Year),
  %% find_genre(MyGenre, GenreList),
  find_censor(MyCensorList, Censor),
  print_film(Film, Director, Year, GenreList, Time, Actor1, Actor2, Score, Censor, Site).