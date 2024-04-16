/* Artists & Ensembles */
/* Tables and procedures related to artists and ensembles */

CREATE SCHEMA artists;

-- Performer
/* A solo artist or ensemble that can be credited in one or more recordings.
   Performer IDs are utilized so that artists and ensembles can be treated
   equivalently for use in recording credits but treated distinctly when needed */
CREATE TABLE artists.performer (
   performer_id INT GENERATED ALWAYS AS IDENTITY PRIMARY KEY
);

-- Artist
/* A conductor, composer, musician, singer, or other type of
   solo artist involved in the production of a composition or recording */
CREATE TABLE artists.artist (
    artist_id INT PRIMARY KEY REFERENCES artists.performer (performer_id)
        ON DELETE CASCADE,
    first_name VARCHAR(50) NOT NULL,
    last_name VARCHAR(50) NOT NULL,
    birth_date DATE NOT NULL,
    death_date DATE
);

-- Artist Instrument (Intersection Table)
/* An instrument associated with a specific artist, used to query performing artists such as pianists or violinists
   by their associated instrument */
CREATE TABLE artists.artist_instrument (
    artist_id INT NOT NULL REFERENCES artists.artist (artist_id)
        ON DELETE CASCADE,
    instrument_id INT NOT NULL REFERENCES lookups.base_instrument (base_inst_id)
        ON DELETE CASCADE,
    PRIMARY KEY (artist_id, instrument_id)
);

-- Ensemble
/* A group of musicians or performing artists considered as a single entity */
CREATE TABLE artists.ensemble (
    ensemble_id INT PRIMARY KEY REFERENCES artists.performer (performer_id)
        ON DELETE CASCADE,
    ensemble_name VARCHAR(255),
    year_founded INT NOT NULL
);

-- Ensemble Member
/* An artist associated with an ensemble, such as a conductor of an orchestra or member of a quartet */
CREATE TABLE artists.ensemble_member (
    ensemble_member_id INT GENERATED ALWAYS AS IDENTITY PRIMARY KEY,
    ensemble_id INT NOT NULL REFERENCES artists.ensemble (ensemble_id)
        ON DELETE CASCADE,
    artist_id INT NOT NULL REFERENCES artists.artist (artist_id)
        ON DELETE CASCADE,
    year_joined INT NOT NULL,
    year_departed INT,
    role VARCHAR(100),
    UNIQUE (ensemble_id, artist_id, year_joined)
);

/* Functions & Triggers */

-- generate_performer_id
/* Generate a performer ID for use as a primary key for an artist or ensemble */
CREATE FUNCTION artists.generate_performer_id()
    RETURNS TRIGGER AS $$
DECLARE
    new_performer_id INT;
BEGIN
    -- Create a new entry in the performer table and capture the performer ID
    INSERT INTO artists.performer DEFAULT VALUES
    RETURNING performer_id INTO new_performer_id;
    -- Insert the performer_id as the PK for the artist or ensemble
    IF TG_TABLE_NAME = 'artist' THEN
        NEW.artist_id := new_performer_id;
    ELSIF TG_TABLE_NAME = 'ensemble' THEN
        NEW.ensemble_id := new_performer_id;
    END IF;
    RETURN NEW;
END;
$$ LANGUAGE plpgsql;

-- TRIGGER: insert_artist_id
/* Generate a performer_id to use as the PK for an artist entry */
CREATE TRIGGER insert_artist_id
    BEFORE INSERT ON artists.artist
    FOR EACH ROW
EXECUTE FUNCTION artists.generate_performer_id();

-- TRIGGER: insert_ensemble_id
/* Generate a performer_id to use as the PK for an ensemble entry */
CREATE TRIGGER insert_ensemble_id
    BEFORE INSERT ON artists.ensemble
    FOR EACH ROW
EXECUTE FUNCTION artists.generate_performer_id();

-- delete_performer_id
/* Remove the corresponding performer ID from the performer table when an artist or ensemble is deleted */
CREATE FUNCTION artists.delete_performer_id()
    RETURNS TRIGGER AS $$
BEGIN
    IF TG_TABLE_NAME = 'artist' THEN
        DELETE FROM artists.performer WHERE performer_id = OLD.artist_id;
    ELSIF TG_TABLE_NAME = 'ensemble' THEN
        DELETE FROM artists.performer WHERE performer_id = OLD.ensemble_id;
    END IF;
    RETURN OLD;
END;
$$ LANGUAGE plpgsql;

-- TRIGGER: delete_artist_performer_id
/* Delete the performer ID for an artist after the entity is deleted */
CREATE TRIGGER delete_artist_performer_id
    AFTER DELETE ON artists.artist
    FOR EACH ROW
EXECUTE FUNCTION artists.delete_performer_id();

-- TRIGGER: delete_ensemble_performer_id
/* Delete the performer ID for an ensemble after the entity is deleted */
CREATE TRIGGER delete_ensemble_performer_id
    AFTER DELETE ON artists.ensemble
    FOR EACH ROW
EXECUTE FUNCTION artists.delete_performer_id();
