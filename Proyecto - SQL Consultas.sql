-- 2. Muestra los nombres de todas las películas con una clasificación por edades de ‘R’.
SELECT title AS titulo
FROM film
WHERE rating = 'R';

-- 3. Encuentra los nombres de los actores que tengan un “actor_id” entre 30 y 40.
SELECT first_name AS nombre, last_name AS apellido
FROM actor
WHERE actor_id BETWEEN 30 AND 40;

-- 4. Obtén las películas cuyo idioma coincide con el idioma original.
SELECT f.title, l.name AS idioma
FROM film f
JOIN language l ON f.language_id = l.language_id;

-- 5. Ordena las películas por duración de forma ascendente.
SELECT title AS titulo, length AS duracion_minutos
FROM film
ORDER BY length ASC;

-- 6. Encuentra el nombre y apellido de los actores que tengan ‘Allen’ en su apellido.
SELECT first_name AS nombre, last_name AS apellido
FROM actor
WHERE LOWER(last_name) LIKE '%allen%';


-- 7. Encuentra la cantidad total de películas en cada clasificación de la tabla “film” y muestra la clasificación junto con el recuento.
SELECT rating AS clasificacion, COUNT(*) AS total_peliculas
FROM film
GROUP BY rating;

-- 9. Encuentra la variabilidad de lo que costaría reemplazar las películas.
SELECT VAR_SAMP(replacement_cost) AS varianble_de_costo
FROM film;

-- 10. Encuentra la mayor y menor duración de una película de nuestra BBDD.
SELECT MAX(length) AS duracion_maxima, MIN(length) AS duracion_minima
FROM film;

-- 11. Coste del antepenúltimo alquiler ordenado por fecha
SELECT amount AS coste
FROM payment
ORDER BY payment_date
OFFSET 2 LIMIT 1;

-- 12. Películas que no tienen clasificación 'NC17' ni 'G'
SELECT title AS titulo, rating AS clasificacion
FROM film
WHERE rating::text NOT IN ('NC-17', 'G');

-- 13. Promedio de duración por clasificación
SELECT rating AS clasificacion, AVG(length) AS duracion_promedio
FROM film
GROUP BY rating;

-- 14. Películas con duración mayor a 180 minutos
SELECT title AS titulo, length AS duracion_minutos
FROM film
WHERE length > 180;

-- Consulta 15: Total de ingresos generados
SELECT SUM(amount) AS ingresos_totales
FROM payment;

-- 16. 10 clientes con mayor ID
SELECT customer_id, first_name AS nombre, last_name AS apellido
FROM customer
ORDER BY customer_id DESC
LIMIT 10;

-- 17. Actores de la película 'Egg Igby'
SELECT a.first_name AS nombre, a.last_name AS apellido
FROM actor a
JOIN film_actor fa ON a.actor_id = fa.actor_id
JOIN film f ON fa.film_id = f.film_id
WHERE f.title ILIKE '%egg igby%';

-- 18. Nombres únicos de películas
SELECT DISTINCT title AS titulo
FROM film;

-- 19. Películas de categoría 'Comedy' con duración > 180 min
SELECT f.title AS titulo, f.length AS duracion_minutos
FROM film f
JOIN film_category fc ON f.film_id = fc.film_id
JOIN category c ON fc.category_id = c.category_id
WHERE c.name = 'Comedy' AND f.length > 180;

-- 20. Categorías con promedio de duración > 110 min
SELECT c.name AS categoria, AVG(f.length) AS duracion_promedio
FROM film f
JOIN film_category fc ON f.film_id = fc.film_id
JOIN category c ON fc.category_id = c.category_id
GROUP BY c.name
HAVING AVG(f.length) > 110;

-- 21. ¿Cuál es la media de duración del alquiler de las películas?
SELECT AVG(return_date - rental_date) AS promedio_alquiler
FROM rental
WHERE return_date IS NOT NULL;

-- 22. Crea una columna con el nombre y apellidos de todos los actores y actrices.
SELECT actor_id, first_name || ' ' || last_name AS nombre_completo
FROM actor;

-- 23. Números de alquiler por día, ordenados por cantidad de alquiler de forma descendente.
SELECT rental_date::date AS dia, COUNT(*) AS total_alquileres
FROM rental
GROUP BY dia
ORDER BY total_alquileres DESC;

-- 24. Encuentra las películas con una duración superior al promedio.
SELECT title, length
FROM film
WHERE length > (SELECT AVG(length) FROM film);

-- 25. Averigua el número de alquileres registrados por mes.
SELECT DATE_TRUNC('month', rental_date) AS mes, COUNT(*) AS total_alquileres
FROM rental
GROUP BY mes
ORDER BY mes;

-- 26. Encuentra el promedio, la desviación estándar y varianza del total pagado.
SELECT AVG(amount) AS promedio, STDDEV(amount) AS desviacion_estandar, VARIANCE(amount) AS varianza
FROM payment;

-- 27. ¿Qué películas se alquilan por encima del precio medio?
SELECT DISTINCT f.title
FROM payment p
JOIN rental r ON p.rental_id = r.rental_id
JOIN inventory i ON r.inventory_id = i.inventory_id
JOIN film f ON i.film_id = f.film_id
WHERE p.amount > (SELECT AVG(amount) FROM payment);

-- 28. Muestra el id de los actores que hayan participado en más de 40 películas.
SELECT actor_id
FROM film_actor
GROUP BY actor_id
HAVING COUNT(film_id) > 40;

-- 29. Obtener todas las películas y, si están disponibles en el inventario, mostrar la cantidad disponible.
SELECT f.film_id, f.title, COUNT(i.inventory_id) AS cantidad_disponible
FROM film f
LEFT JOIN inventory i ON f.film_id = i.film_id AND i.store_id IS NOT NULL
GROUP BY f.film_id, f.title;

-- 30. Obtener los actores y el número de películas en las que ha actuado.
SELECT a.actor_id, a.first_name, a.last_name, COUNT(fa.film_id) AS num_peliculas
FROM actor a
LEFT JOIN film_actor fa ON a.actor_id = fa.actor_id
GROUP BY a.actor_id, a.first_name, a.last_name;

-- 31. Obtener todas las películas y mostrar los actores que han actuado en ellas, incluso si algunas películas no tienen actores asociados.
SELECT f.title, a.first_name, a.last_name
FROM film f
LEFT JOIN film_actor fa ON f.film_id = fa.film_id
LEFT JOIN actor a ON fa.actor_id = a.actor_id
ORDER BY f.title;

-- 32. Obtener todos los actores y mostrar las películas en las que han actuado, incluso si algunos actores no han actuado en ninguna película.
SELECT a.first_name, a.last_name, f.title
FROM actor a
LEFT JOIN film_actor fa ON a.actor_id = fa.actor_id
LEFT JOIN film f ON fa.film_id = f.film_id
ORDER BY a.last_name, a.first_name;

-- 33. Obtener todas las películas que tenemos y todos los registros de alquiler.
SELECT f.title, r.rental_date, r.return_date
FROM film f
LEFT JOIN inventory i ON f.film_id = i.film_id
LEFT JOIN rental r ON i.inventory_id = r.inventory_id
ORDER BY f.title, r.rental_date;

-- 34. Encuentra los 5 clientes que más dinero se hayan gastado con nosotros.
SELECT c.customer_id, c.first_name, c.last_name, SUM(p.amount) AS total_gastado
FROM customer c
JOIN payment p ON c.customer_id = p.customer_id
GROUP BY c.customer_id, c.first_name, c.last_name
ORDER BY total_gastado DESC
LIMIT 5;

-- 35. Selecciona todos los actores cuyo primer nombre es 'Johnny'.
SELECT *
FROM actor
WHERE LOWER(first_name) = 'johnny';

-- 36. Renombra la columna “first_name” como Nombre y “last_name” como Apellido.
SELECT actor_id, first_name AS Nombre, last_name AS Apellido
FROM actor;

-- 37. Encuentra el ID del actor más bajo y más alto en la tabla actor.
SELECT MIN(actor_id) AS id_minimo, MAX(actor_id) AS id_maximo
FROM actor;

-- 38. Cuenta cuántos actores hay en la tabla “actor”.
SELECT COUNT(*) AS total_actores
FROM actor;


-- 39. Selecciona todos los actores y ordénalos por apellido en orden ascendente.
SELECT *
FROM actor
ORDER BY last_name ASC;

-- 40. Selecciona las primeras 5 películas de la tabla “film”.
SELECT *
FROM film
LIMIT 5;

-- 41. Agrupa los actores por su nombre y cuenta cuántos actores tienen el mismo nombre. ¿Cuál es el nombre más repetido?
SELECT first_name, COUNT(*) AS cantidad
FROM actor
GROUP BY first_name
ORDER BY cantidad DESC
LIMIT 1;

-- 42. Encuentra todos los alquileres y los nombres de los clientes que los realizaron.
SELECT r.rental_id, c.first_name, c.last_name, r.rental_date
FROM rental r
JOIN customer c ON r.customer_id = c.customer_id
ORDER BY r.rental_date;

-- 43. Muestra todos los clientes y sus alquileres si existen, incluyendo aquellos que no tienen alquileres.
SELECT c.customer_id, c.first_name, c.last_name, r.rental_id, r.rental_date
FROM customer c
LEFT JOIN rental r ON c.customer_id = r.customer_id
ORDER BY c.last_name, c.first_name;

-- 44. Realiza un CROSS JOIN entre las tablas film y category. ¿Aporta valor esta consulta? ¿Por qué? Deja después de la consulta la contestación.
SELECT f.title, cat.name
FROM film f
CROSS JOIN category cat;
/*
Respuesta: 
El CROSS JOIN combina cada película con todas las categorías posibles, 
creando muchas combinaciones que normalmente no tienen sentido real. 
Por eso, en la mayoría de los casos, esta consulta no aporta información útil.
*/

-- 45. Encuentra los actores que han participado en películas de la categoría 'Action'.
SELECT DISTINCT a.first_name, a.last_name
FROM actor a
JOIN film_actor fa ON a.actor_id = fa.actor_id
JOIN film_category fc ON fa.film_id = fc.film_id
JOIN category c ON fc.category_id = c.category_id
WHERE c.name = 'Action';


-- 46. Encuentra todos los actores que no han participado en películas.
SELECT a.first_name, a.last_name
FROM actor a
LEFT JOIN film_actor fa ON a.actor_id = fa.actor_id
WHERE fa.actor_id IS null;


-- 47. Selecciona el nombre de los actores y la cantidad de películas en las que han participado.
SELECT a.first_name, a.last_name, COUNT(fa.film_id) AS num_peliculas
FROM actor a
LEFT JOIN film_actor fa ON a.actor_id = fa.actor_id
GROUP BY a.first_name, a.last_name;

-- 48. Crea una vista llamada “actor_num_peliculas” que muestre los nombres de los actores y el número de películas en las que han participado.
CREATE OR REPLACE VIEW actor_num_peliculas as 
SELECT a.actor_id, a.first_name, a.last_name, COUNT(fa.film_id) AS num_peliculas
FROM actor a
LEFT JOIN film_actor fa ON a.actor_id = fa.actor_id
GROUP BY a.actor_id, a.first_name, a.last_name;

SELECT * 
FROM actor_num_peliculas


-- 49. Calcula el número total de alquileres realizados por cada cliente.
SELECT c.customer_id, c.first_name, c.last_name, COUNT(r.rental_id) AS total_alquileres
FROM customer c
LEFT JOIN rental r ON c.customer_id = r.customer_id
GROUP BY c.customer_id, c.first_name, c.last_name
ORDER BY total_alquileres DESC;

-- 50. Calcula la duración total de las películas en la categoría 'Action'.
SELECT c.name, SUM(f.length) AS duracion_total
FROM film f
JOIN film_category fc ON f.film_id = fc.film_id
JOIN category c ON fc.category_id = c.category_id
WHERE c.name = 'Action'
GROUP BY c.name;

-- 51. Crea una tabla temporal llamada “cliente_rentas_temporal” para almacenar el total de alquileres por cliente.
CREATE TEMPORARY TABLE cliente_rentas_temporal AS
SELECT customer_id, COUNT(*) AS total_alquileres
FROM rental
GROUP BY customer_id;

-- 52. Crea una tabla temporal llamada “peliculas_alquiladas” que almacene las películas que han sido alquiladas al menos 10 veces.
CREATE TEMPORARY TABLE peliculas_alquiladas AS
SELECT f.film_id, f.title, COUNT(r.rental_id) AS num_alquileres
FROM film f
JOIN inventory i ON f.film_id = i.film_id
JOIN rental r ON i.inventory_id = r.inventory_id
GROUP BY f.film_id, f.title
HAVING COUNT(r.rental_id) >= 10;

-- 53. Encuentra el título de las películas que han sido alquiladas por el cliente con el nombre ‘Tammy Sanders’ y que aún no se han devuelto. Ordena los resultados alfabéticamente por título de película.
SELECT f.title
FROM film f
JOIN inventory i ON f.film_id = i.film_id
JOIN rental r ON i.inventory_id = r.inventory_id
JOIN customer c ON r.customer_id = c.customer_id
WHERE c.first_name = 'Tammy' AND c.last_name = 'SANDERS'
  AND r.return_date IS NULL
ORDER BY f.title;

-- 54. Encuentra los nombres de los actores que han actuado en al menos una película que pertenece a la categoría ‘Sci-Fi’. Ordena los resultados alfabéticamente por apellido.
SELECT DISTINCT a.first_name, a.last_name
FROM actor a
JOIN film_actor fa ON a.actor_id = fa.actor_id
JOIN film_category fc ON fa.film_id = fc.film_id
JOIN category c ON fc.category_id = c.category_id
WHERE c.name = 'Sci-Fi'
ORDER BY a.last_name;

-- 55. Encuentra el nombre y apellido de los actores que han actuado en películas que se alquilaron después de que la película ‘Spartacus Cheaper’ se alquilara por primera vez. Ordena los resultados por apellido.
SELECT DISTINCT a.first_name, a.last_name
FROM actor a
JOIN film_actor fa ON a.actor_id = fa.actor_id
JOIN film f ON f.film_id = fa.film_id
JOIN inventory i ON f.film_id = i.film_id
JOIN rental r ON i.inventory_id = r.inventory_id
WHERE r.rental_date > (
    SELECT MIN(r2.rental_date)
    FROM film f2
    JOIN inventory i2 ON f2.film_id = i2.film_id
    JOIN rental r2 ON i2.inventory_id = r2.inventory_id
    WHERE f2.title = 'SPARTACUS CHEAPER'
)
ORDER BY a.last_name;

-- 56. Encuentra el nombre y apellido de los actores que no han actuado en ninguna película de la categoría ‘Music’.
SELECT a.first_name, a.last_name
FROM actor a
WHERE a.actor_id NOT IN (
    SELECT fa.actor_id
    FROM film_actor fa
    JOIN film_category fc ON fa.film_id = fc.film_id
    JOIN category c ON fc.category_id = c.category_id
    WHERE c.name = 'Music'
);

-- 57. Encuentra el título de todas las películas que fueron alquiladas por más de 8 días.
SELECT DISTINCT f.title
FROM film f
JOIN inventory i ON f.film_id = i.film_id
JOIN rental r ON i.inventory_id = r.inventory_id
WHERE r.return_date IS NOT NULL
  AND r.return_date - r.rental_date > INTERVAL '8 days';

-- 58. Encuentra el título de todas las películas que son de la misma categoría que ‘Animation’.
SELECT f.title
FROM film f
JOIN film_category fc ON f.film_id = fc.film_id
WHERE fc.category_id = (
    SELECT category_id
    FROM category
    WHERE name = 'Animation'
);

-- 59. Encuentra los nombres de las películas que tienen la misma duración que la película con el título ‘Dancing Fever’. Ordena los resultados por título.
SELECT title
FROM film
WHERE length = (
    SELECT length
    FROM film
    WHERE title = 'DANCING FEVER'
)
ORDER BY title;

-- 60. Encuentra los nombres de los clientes que han alquilado al menos 7 películas distintas. Ordena los resultados por apellido.
SELECT c.first_name, c.last_name
FROM customer c
JOIN rental r ON c.customer_id = r.customer_id
JOIN inventory i ON r.inventory_id = i.inventory_id
JOIN film f ON i.film_id = f.film_id
GROUP BY c.customer_id
HAVING COUNT(DISTINCT f.film_id) >= 7
ORDER BY c.last_name;

-- 61. Encuentra la cantidad total de películas alquiladas por categoría y muestra el nombre de la categoría junto con el recuento de alquileres.
SELECT c.name AS categoria, COUNT(r.rental_id) AS total_alquileres
FROM category c
JOIN film_category fc ON c.category_id = fc.category_id
JOIN inventory i ON fc.film_id = i.film_id
JOIN rental r ON i.inventory_id = r.inventory_id
GROUP BY c.name
ORDER BY total_alquileres DESC;

-- 62. Encuentra el número de películas por categoría estrenadas en 2006.
SELECT c.name AS categoria, COUNT(f.film_id) AS cantidad_peliculas
FROM category c
JOIN film_category fc ON c.category_id = fc.category_id
JOIN film f ON fc.film_id = f.film_id
WHERE f.release_year = 2006
GROUP BY c.name
ORDER BY cantidad_peliculas DESC;

-- 63. Obtén todas las combinaciones posibles de trabajadores con las tiendas que tenemos.
SELECT s.staff_id, s.first_name, s.last_name, st.store_id
FROM staff s
CROSS JOIN store st;

-- 64. Encuentra la cantidad total de películas alquiladas por cada cliente y muestra el ID del cliente, su nombre y apellido junto con la cantidad de películas alquiladas.
SELECT c.customer_id, c.first_name, c.last_name, COUNT(r.rental_id) AS total_alquileres
FROM customer c
JOIN rental r ON c.customer_id = r.customer_id
GROUP BY c.customer_id
ORDER BY total_alquileres DESC;
