# Отчет по лабораторной работе
## по курсу "Искусственый интеллект"

### Студенты: 

| ФИО       | Роль в проекте                     | Оценка       |
|-----------|------------------------------------|--------------|
| Ваньков Денис Алексеевич | Сбор, обработка информации, создание базы знаний |
| Иванов Данила Владимирович | Разработка дерева вопросов и описание его на прологе |       |
| Дубинин Артем Олегович| Разработка алгоритма поиска и описание его на прологе |      |

## Результат проверки

| Преподаватель     | Дата         |  Оценка       |
|-------------------|--------------|---------------|
| Сошников Д.В. |              |               |

> *Комментарии проверяющих (обратите внимание, что более подробные комментарии возможны непосредственно в репозитории по тексту программы)*

## Тема работы

Экспертная система по рекомендации фильмов. Так как в настоящее время актульно сидеть дома и смотреть фильмы, мы решили выбрать эту тему. Из-за большого количества информации о фильмах, поиск, подходящего вам, занимает большое количество времени. Наша система предлагает вам сократить его и потратить время на сам просмотр.

## Концептуализация предметной области

Результаты концептуализации предметной области:
 - выделенные понятия - возраст, цензор, компания для просмотра, оценка, время фильма, год фильма, жанр, настроние сморящего, актер.
 - тип получившейся онтологии - сеть.
 - Статические - жанр, возраст, компания, время фильма, настроение. Динамические - цензор, оценка, год фильма, актер.
 - Каждый из участников определял какой жанр соответствует возрасту и настроению смотрящего, на основе мнений бралось среднее значение. Оценивание возрастных ограничений которые стоит учитывать (Например, это связано с такой особенностью, как PG-13, чтобы получить этот рейтинг добавляют два матерных слова и на высокой рекламе берут больше зрителей). Временная принадлежность фильма так же была определена дискуссионно.
Приведите графические иллюстрации:
![Концептуализация](img/ExpertSystem.png)

## Принцип реализации системы

Мы используем SWI Prolog так как в нем удобно работать с backtraking-ом и строить деревья. Пользователю задаются начальные вопросы, исходя из которых, определяются дальнейшие вопросы. После сбора информации происходит ее обработка и дальнейший поиск. 

## Механизм вывода

По введенным данным пользователя производится вывод вторичной информации.
Например на основе возраста определяется доступный цензор фильма.
```
ask_age(Age, CensorList):-
  write('How old are you?'),nl,
  read(Age),censor(CensorList,Age).
  
censor(CensorList, Age):-
  child(Age), CensorList = ['G'].
censor(CensorList, Age):-
  teenager(Age), CensorList = ['G', 'PG'].
censor(CensorList, Age):-
  adult_teenager(Age), CensorList = ['G','PG','NC-17'].
censor(CensorList, Age):-
  adult(Age), CensorList = ['G','PG', 'NC-17','R'].

```
```
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
```

По возрасту и компании (если человек смотрит один, то и по настроению) определяется список доступных жанров, далее человек выбирает наиболее интересный ему.
```
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

```

## Извлечение знаний и база знаний

Был взят датасет с Kaggle. Обрабтаны и получены нужные данные. Записаны в формате пролог в отдельном файле.

```
film('Avatar ', 'James Cameron', 2009, ['Action', 'Adventure', 'Fantasy', 'Sci-Fi'], 178, 'PG', 'CCH Pounder', 'Joel David Moore', 7.9, 'http://www.imdb.com/title/tt0499549/?ref_=fn_tt_tt_1').

```

## Протокол работы системы
```
?- recommend_movie().
How old are you?
|: 20
|: .
Who do you want to watch a movie with?
1. Alone
2. Family
3. Company
|: 1.
Want to see a specific actor?(y[es] or n[o])
|: y.
Select specific actor
1. Robert De Niro
2. Johnny Depp
3. Nicolas Cage
4. J.K. Simmons
5. Bruce Willis
6. Matt Damon
7. Denzel Washington
8. Liam Neeson
9. Harrison Ford
10. Steve Buscemi
11. Robin Williams
12. Jason Statham
13. Robert Downey Jr.
14. Bill Murray
15. Tom Cruise
16. Morgan Freeman
17. Tom Hanks
18. Keanu Reeves
19. Christian Bale
20. Kevin Spacey
|: 1.
Your mood?
1. Happy
2. Normal
3. Sad
|: 1.
Choose a suitable genre
1. Action
2. Adventure
3. Animation
4. Comedy
5. Fantasy
6. Horror
7. Musical
8. Romance
|: 6.
Is the year of release important?(y[es] or n[o])
|: n.
Do you have a lot of time?(y[es] or n[o])
|: y
|: .
Realy?(y[es] or n[o])
|: y.
Important score?(y[es] or n[o])
|: n.

Film: Godsend 
Director: Nick Hamm
Year: 2004
GenreList: ['Drama','Horror','Sci-Fi','Thriller']
Time: 102
Actor1: Robert De Niro
Actor2: Cameron Bright
Score: 4.8
Censor: PG
Site: http://www.imdb.com/title/tt0335121/?ref_=fn_tt_tt_1

true .

```
```
?- recommend_movie.
How old are you?
|: 5.
Who do you want to watch a movie with?
1. Alone
2. Family
3. Company
|: 2.
Choose a suitable genre
1. Adventure
2. Animation
3. Biography
4. Comedy
5. Drama
6. Family
7. Fantasy
8. History
9. Music
10. Musical
11. Mystery
12. News
13. Romance
14. Thriller
15. Western
|: 2.
Is the year of release important?(y[es] or n[o])
|: y.
Select year of manufacture
1. ....-1980
2. 1980-2000
3. 2000-2010
4. 2010-2020
|: 1.
Do you have a lot of time?(y[es] or n[o])
|: n.
Important score?(y[es] or n[o])
|: y.

Film: A Charlie Brown Christmas 
Director: Bill Melendez
Year: 1965
GenreList: ['Animation','Comedy','Family']
Time: 25
Actor1: Peter Robbins
Actor2: Bill Melendez
Score: 8.4
Censor: G
Site: http://www.imdb.com/title/tt0059026/?ref_=fn_tt_tt_1

true .

```
```
?- recommend_movie.
How old are you?
|: 15.
Who do you want to watch a movie with?
1. Alone
2. Family
3. Company
|: 3.
Choose a suitable genre
1. Action
2. Adventure
3. Animation
4. Biography
5. Comedy
6. Crime
7. Documentary
8. Drama
9. Fantasy
10. Film-Noir
11. History
12. Horror
13. Music
14. Musical
15. Mystery
16. Romance
17. Sci-Fi
18. Sport
19. Thriller
20. War
21. Western
|: 21.
Is the year of release important?(y[es] or n[o])
|: n.
Do you have a lot of time?(y[es] or n[o])
|: y.
Realy?(y[es] or n[o])
|: y.

Film: The Lone Ranger 
Director: Gore Verbinski
Year: 2013
GenreList: ['Action','Adventure','Western']
Time: 150
Actor1: Johnny Depp
Actor2: Ruth Wilson
Score: 6.5
Censor: PG
Site: http://www.imdb.com/title/tt1210819/?ref_=fn_tt_tt_1

true .

```
## Выводы

В данной лабораторной работе были полечны навыки работы в команде. Сомнения в ней нас не покидали. Работа была разделена на 3 части, которые выполнялись независимо. Каждый из нас научил чему-то новому другого, например использование git.  

Она нас заставила задумать над сложностью и поиском нужных нам вещей. Как огромен мир знаний в которым мы обитаем. Насколько сложно дать исчерпывающий ответ пользователю. Насколько незначительные факты влияют на картину в целом.

Основная сложность работы заключалось в построении отсекающих вопросов, фактов и установлении связей между ними. Было замечено, что вспомнить пролог оказалось проще, так как он основан на логике, а экспертная система подразумевает логический подход.

В какой-то степени лабораторная работа не прекращалась ни на час, так как у участников команды разные режимы дня и были задействованы все 24 часа в сутках, и даже в этих условиях мы смогли справиться с ней.
