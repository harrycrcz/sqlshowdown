-- Seleccionar DisplayName, Location, Reputation y clasificar descendentemente por Reputacion
SELECT DisplayName,
Location,
Reputation
FROM Users
ORDER BY Reputation DESC


-- Seleccionar DisplayName de Users y Title de Posts y  unir ambas tablas, cargando estos datos siempre que el Post tenga propietario
SELECT Posts.Title, Users.DisplayName
FROM Posts
INNER JOIN Users ON Posts.OwnerUserId = Users.Id
WHERE Posts.OwnerUserId IS NOT NULL;

-- Promediar puntajes obtenidos en la tabla Posts y mostrar los promedios en una tabla junto con los  nombres de usuario (en Users).
SELECT AVG(Posts.Score), Users.DisplayName
FROM Posts
INNER JOIN Users ON Posts.OwnerUserId = Users.Id
GROUP BY Users.DisplayName

--Mostrar los Ids de los usuarios que han alcanzado mas de 100 comentarios:
SELECT Users.DisplayName
FROM Users
WHERE Users.Id IN (
SELECT Posts.OwnerUserId
FROM Posts 
GROUP BY Posts.OwnerUserId
HAVING COUNT(Posts.CommentCount) >100);

-- Cargar todas las celdas vacias de la columna 'Location' con la cadena de caracteres 'Desconocido'
UPDATE Users
SET Location = 'Desconocido'
WHERE Location IS NULL;

ALTER TABLE Users
ADD CONSTRAINT DF_Location DEFAULT 'Desconocido' FOR Location;



--Eliminar todos los comentarios que hicieron usuarios con menos de 100 de reputacion
DELETE FROM Comments 
WHERE UserId IN (
	SELECT Users.Id
	FROM Users
	WHERE Reputation < 100
	);

--Mostrar la cantidad de comentarios, posts y badges de cada usuario.
SELECT 
    Users.DisplayName,
    COALESCE(Posts.OwnerUserId, 0) AS PostCount,
    COALESCE(Comments.UserId, 0) AS CommentCount,
    COALESCE(Badges.UserId, 0) AS BadgeCount
FROM 
    Users
LEFT JOIN (
    SELECT 
        OwnerUserId, 
        COUNT(*) AS PostCount
    FROM 
        Posts
    GROUP BY 
        OwnerUserId
) AS Posts ON Users.Id = Posts.OwnerUserId
LEFT JOIN (
    SELECT 
        UserId, 
        COUNT(*) AS CommentCount
    FROM 
        Comments
    GROUP BY 
        UserId
) AS Comments ON Users.Id = Comments.UserId
LEFT JOIN (
    SELECT 
        UserId, 
        COUNT(*) AS BadgeCount
    FROM 
        Badges
    GROUP BY 
        UserId
) AS Badges ON Users.Id = Badges.UserId;

--Mostrar los 10 comentarios mas populares y sus respectivos titulos
SELECT TOP 10 Posts.Title, Posts.Score
FROM Posts
ORDER BY Posts.Score DESC

--Mostrar los 5 comentarios mas recientes y sus fechas
SELECT TOP 5 Comments.Text, Comments.CreationDate
FROM Comments
ORDER BY Comments.CreationDate DESC
