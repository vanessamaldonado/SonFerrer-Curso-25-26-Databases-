# Lab10. Movie collection - 23 Exercises

Trabajaremos con la Base de datos `sample_mflix` colección `movies`.

1. Find all movies with full information from the 'movies' collection that released in the year 1893.
2. Find all movies with full information from the 'movies' collection that have a runtime greater than 120 minutes.
3. Find all movies with full information from the 'movies' collection that have "Short" genre.
4. Retrieve all movies from the 'movies' collection that were directed by "William K.L. Dickson" and include complete information for each movie.
5. Retrieve all movies from the 'movies' collection that were released in the USA and include complete information for each movie.
6. Retrieve all movies from the 'movies' collection that have complete information and are rated as "UNRATED".
7. Retrieve all movies from the 'movies' collection that have complete information and have received more than 1000 votes on IMDb.
8. Retrieve all movies from the 'movies' collection that have complete information and have an IMDb rating higher than 7.
9. Retrieve all movies from the 'movies' collection that have complete information and have a viewer rating higher than 4 on Tomatoes.
10. Retrieve all movies from the 'movies' collection that have received an award.
11. Find all movies with title, languages, released, directors, writers, awards, year, genres, runtime, cast, countries from the 'movies' collection in MongoDB that have at least one nomination.
12. Find all movies with title, languages, released, directors, writers, awards, year, genres, runtime, cast, countries from the 'movies' collection in MongoDB with cast including "Charles Kayser".
13. Retrieve all movies with title, languages, released, directors, writers, countries from the 'movies' collection in MongoDB that released on May 9, 1893.
14. Retrieve all movies with title, languages, released, directors, writers, countries from the 'movies' collection in MongoDB that have a word "scene" in the title.
15. Find all movies with title, languages, released, directors, viewer, writers, countries from the 'movies' collection in MongoDB that have a viewer rating of at least 3 and less than 4 on Tomatoes.
16. Find all movies with title, languages, released, runtime, directors, writers, countries, imdb from the 'movies' collection in MongoDB for the top 5 movies with the highest IMDb ratings.
17. Find all movies from the 'movies' collection in MongoDB with the average runtime of movies released in each country.
18. Find from the 'movies' collection in MongoDB with the most common genre among the movies.
19. Find the movies released in the year with the highest average IMDb rating from the 'movies' collection in MongoDB.
20. Find the top 10 directors with the most movies from the 'movies' collection in MongoDB.
21.  Write a query in MongoDB to find the average IMDb rating for movies with different ratings (e.g., 'PG', 'R', 'G') from the 'movies' collection.
22.  Write a query in MongoDB to find the oldest movie with an award win from the 'movies' collection.
23.  Write a query in MongoDB to find the movie with the highest IMDb rating and viewer rating on Tomatoes from the 'movies' collection.

---


<details><summary>Mostrar Solución</summary>

```javascript

//1. Find all movies with full information from the 'movies' collection that released in the year 1893.
db.movies.find({ year: 1893 })

//2. Find all movies with full information from the 'movies' collection that have a runtime greater than 120 minutes.
db.movies.find({ "runtime": { $gt: 120 } })

//3. Find all movies with full information from the 'movies' collection that have "Short" genre.
db.movies.find({ "genres": "Short" })

//4. Retrieve all movies from the 'movies' collection that were directed by "William K.L. Dickson" and include complete information for each movie.
db.movies.find({ directors: "William K.L. Dickson" })

//5. Retrieve all movies from the 'movies' collection that were released in the USA and include complete information for each movie.
db.movies.find({ countries: "USA" })

//6. Retrieve all movies from the 'movies' collection that have complete information and are rated as "UNRATED".
db.movies.find({ rated: "UNRATED" })

//7. Retrieve all movies from the 'movies' collection that have complete information and have received more than 1000 votes on IMDb.
db.movies.find({ "imdb.votes": { $gt: 1000 } })

//8. Retrieve all movies from the 'movies' collection that have complete information and have an IMDb rating higher than 7.
db.movies.find({ "imdb.rating": { $gt: 7 } })

//9. Retrieve all movies from the 'movies' collection that have complete information and have a viewer rating higher than 4 on Tomatoes.
db.movies.find({
  "tomatoes.viewer.rating": { $gt: 4 }
})

//10. Retrieve all movies from the 'movies' collection that have received an award.
db.movies.find(
{'awards.wins': {$gt: 0}
})

//11. Find all movies with title, languages, released, directors, writers, awards, year, genres, runtime, cast, countries from the 'movies' collection in MongoDB that have at least one nomination.
db.movies.find({
  "awards.nominations": { $gt: 0 }
}, {
  "title": 1,
  "languages": 1,
  "released": 1,
  "directors": 1,
  "writers": 1,
  "awards": 1,
  "year": 1,
  "genres": 1,
  "runtime": 1,
  "cast": 1,
  "countries": 1
})

//12. Find all movies with title, languages, released, directors, writers, awards, year, genres, runtime, cast, countries from the 'movies' collection in MongoDB with cast including "Charles Kayser".
db.movies.find({
  "cast": "Charles Kayser"
}, {
  "title": 1,
  "languages": 1,
  "released": 1,
  "directors": 1,
  "writers": 1,
  "awards": 1,
  "year": 1,
  "genres": 1,
  "runtime": 1,
  "cast": 1,
  "countries": 1
})

//13. Retrieve all movies with title, languages, released, directors, writers, countries from the 'movies' collection in MongoDB that released on May 9, 1893.
db.movies.find({
released: ISODate("1893-05-09T00:00:00.000Z")
},
{
title: 1,
languages: 1,
released: 1,
directors: 1,
writers: 1,
countries: 1
})

//14. Retrieve all movies with title, languages, released, directors, writers, countries from the 'movies' collection in MongoDB that have a word "scene" in the title.
db.movies.find(
{ title: { $regex: /scene/i } },
{ title: 1, languages: 1, released: 1, directors: 1, writers: 1, countries: 1 }
)

//15. Find all movies with title, languages, released, directors, viewer, writers, countries from the 'movies' collection in MongoDB that have a viewer rating of at least 3 and less than 4 on Tomatoes.
db.movies.find(
{ 'tomatoes.viewer.rating': { $gte: 3, $lt: 4 } },
{ title: 1, languages: 1, released: 1, directors: 1, 'tomatoes.viewer': 1, writers: 1, countries: 1 }
)

//16. Find all movies with title, languages, released, runtime, directors, writers, countries, imdb from the 'movies' collection in MongoDB for the top 5 movies with the highest IMDb ratings.
db.movies.find(
{ 'tomatoes.viewer.rating': { $gte: 3, $lt: 4 } },
{ title: 1, languages: 1, released: 1, directors: 1, 'tomatoes.viewer': 1, writers: 1, countries: 1 }
)

//17. Find all movies from the 'movies' collection in MongoDB with the average runtime of movies released in each country.
db.movies.aggregate([
  {
    $match: { type: 'movie' }
  },
  {
    $group: {
      _id: '$countries',
averageRuntime: { $avg: '$runtime' }
    }
  }
])

//18. Find from the 'movies' collection in MongoDB with the most common genre among the movies.
db.movies.aggregate([
  {
    $unwind: '$genres'
  },
  {
    $group: {
      _id: '$genres',
count: { $sum: 1 }
    }
  },
  {
    $sort: { count: -1 }
  },
  {
    $limit: 1
  }
])

//19. Find the movies released in the year with the highest average IMDb rating from the 'movies' collection in MongoDB.
db.movies.aggregate([
  {
    $group: {
      _id: "$year",
averageRating: { $avg: "$imdb.rating" },
movies: { $push: "$$ROOT" }
    }
  },
  {
    $sort: { averageRating: -1 }
  },
  {
    $limit: 1
  },
  {
    $unwind: "$movies"
  },
  {
    $replaceRoot: { newRoot: "$movies" }
  }
])

//20. Find the top 10 directors with the most movies from the 'movies' collection in MongoDB.
db.movies.aggregate([
  {
    $group: {
      _id: "$directors",
movieCount: { $sum: 1 }
    }
  },
  {
    $sort: { movieCount: -1 }
  },
  {
    $limit: 10
  }
])

//21. Write a query in MongoDB to find the average IMDb rating for movies with different ratings (e.g., 'PG', 'R', 'G') from the 'movies' collection.
db.movies.aggregate([
  {
    $group: {
      _id: "$rated",
averageRating: { $avg: "$imdb.rating" }
    }
  }
])

//22.  Write a query in MongoDB to find the oldest movie with an award win from the 'movies' collection.
db.movies.find({ "awards.wins": { $gt: 0 } }).sort({ year: 1 }).limit(1)

//23.  Write a query in MongoDB to find the movie with the highest IMDb rating and viewer rating on Tomatoes from the 'movies' collection.
db.movies.aggregate([
  {
    $project: {
      _id: 1,
title: 1,
imdbRating: "$imdb.rating",
tomatoViewerRating: "$tomatoes.viewer.rating"
    }
  },
  {
    $sort: {
imdbRating: -1,
tomatoViewerRating: -1
    }
  },
  {
    $limit: 1
  }
])


```
</details>
