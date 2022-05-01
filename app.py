import sqlite3


def connect(id):
    con = sqlite3.connect("animal.db")
    cur = con.cursor()
    cur.execute(f"""
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
            WHERE animals_final.id = {id}
    """)
    result = cur.fetchall()
    con.close()
    result_json = {
        'age_upon_outcome': result[0][0],
        'animal_id': result[0][1],
        'types': result[0][2],
        'name': result[0][3],
        'breed': result[0][4],
        'date_of_birth': result[0][5],
        'subtype': result[0][6],
        'type': result[0][7],
        'month': result[0][8],
        'year': result[0][9],
        'color': result[0][10]
}
    if len(result) != 1:
        result_json.update({'color2': result[1][10]})
    return result_json

