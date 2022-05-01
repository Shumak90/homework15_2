
CREATE TABLE colors
(
    id INTEGER PRIMARY KEY AUTOINCREMENT,
    color VARCHAR(50)
);

INSERT INTO colors (color)
SELECT DISTINCT * FROM (
    SELECT DISTINCT
        color1 AS color
    FROM animals
    UNION ALL
    SELECT DISTINCT
        color2 AS color
    FROM animals
);

DELETE FROM colors WHERE color IS NULL;

CREATE TABLE IF NOT EXISTS animals_colors(
    animals_id INTEGER,
    colors_id INTEGER,
    FOREIGN KEY (animals_id) REFERENCES animals_final(id),
    FOREIGN KEY (colors_id) REFERENCES  colors(id)
);

INSERT INTO animals_colors (animals_id, colors_id)
SELECT DISTINCT animals."index", colors.id FROM animals
JOIN colors ON colors.color = animals.color1
UNION ALL
SELECT DISTINCT animals."index", colors.id FROM animals
JOIN colors ON colors.color = animals.color2
;

INSERT INTO animals_colors (animals_id, colors_id)
SELECT DISTINCT animals_final.id, colors.id
FROM animals
JOIN colors
    ON colors.color = animals.color1
JOIN animals_final
    ON animals_final.animal_id = animals.animal_id
UNION ALL
SELECT DISTINCT animals_final.id, colors.id
FROM animals
JOIN colors ON colors.color = animals.color2
JOIN animals_final
    ON animals_final.animal_id =animals.animal_id
;

CREATE TABLE breed
(
    id INTEGER PRIMARY KEY AUTOINCREMENT,
    breed VARCHAR(50)
);

INSERT INTO breed (breed)
SELECT DISTINCT
    animals.breed
FROM animals;

CREATE TABLE types
(
    id INTEGER PRIMARY KEY AUTOINCREMENT,
    types VARCHAR(50)
);

INSERT INTO types (types)
SELECT DISTINCT
    animals.animal_type
FROM animals;


CREATE TABLE outcome
(
    id INTEGER PRIMARY KEY AUTOINCREMENT,
    subtype VARCHAR(50),
    type VARCHAR(50),
    month INTEGER,
    year INTEGER
);

INSERT INTO outcome (subtype, type, month, year)
SELECT DISTINCT
    animals.outcome_subtype,
    animals.outcome_type,
    animals.outcome_month,
    animals.outcome_year
FROM animals;

CREATE TABLE IF NOT EXISTS animals_final (
    id INTEGER PRIMARY KEY AUTOINCREMENT,
    age_upon_outcome VARCHAR(50),
    animal_id VARCHAR(50),
    animal_type_id INTEGER,
    name VARCHAR(50),
    breed_id INTEGER,
    date_of_birth VARCHAR(50),
    outcome_id INTEGER,
    FOREIGN KEY (outcome_id) REFERENCES outcome(id),
    FOREIGN KEY (breed_id) REFERENCES breed(id),
    FOREIGN KEY (animal_type_id) REFERENCES types(id)
);

INSERT INTO animals_final (age_upon_outcome, animal_id, animal_type_id, name, breed_id, date_of_birth, outcome_id)
SELECT animals.age_upon_outcome,
       animals.animal_id,
       types.id,
       animals.name,
       breed.id,
       animals.date_of_birth,
       outcome.id
FROM animals
JOIN outcome
    ON outcome.subtype = animals.outcome_subtype
    AND outcome.type = animals.outcome_type
    AND outcome.month = animals.outcome_month
    AND outcome.year = animals.outcome_year
JOIN breed
    ON breed.breed = animals.breed
JOIN types
    ON types.types = animals.animal_type
;

UPDATE animals
SET color1 = TRIM(color1),
    color2 = TRIM(color2);

SELECT age_upon_outcome,
       animal_id,
       types.types,
       name,
       breed.breed,
       date_of_birth,
       outcome.subtype,
       outcome.type,
       outcome.month,
       outcome.year,
       colors.color
FROM animals_final
JOIN animals_colors
    ON animals_final.id = animals_colors.animals_id
JOIN colors
    ON animals_colors.colors_id = colors.id
JOIN types
    ON types.id = animals_final.animal_type_id
JOIN breed
    ON breed.id = animals_final.breed_id
LEFT JOIN outcome
    ON animals_final.outcome_id = outcome.id
WHERE animals_final.id = 2