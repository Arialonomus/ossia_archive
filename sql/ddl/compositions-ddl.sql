/* Compositions */
/* Tables and functions related to compositions */

CREATE SCHEMA compositions;

-- Work
/* A composition or arrangement by a given composer. Work IDs are utilized so that
   compositions and arrangements can be treated distinctly, but can be catalogued together */
CREATE TABLE compositions.work (
    work_id INT GENERATED ALWAYS AS IDENTITY PRIMARY KEY
);

-- Composition
/* A single composition of one or more movements created by a composer */
CREATE TABLE compositions.composition (
    composition_id INT PRIMARY KEY REFERENCES compositions.work (work_id),
    composer_id INT NOT NULL REFERENCES artists.artist (artist_id)
        ON DELETE CASCADE,
    title TEXT NOT NULL,
    title_alternates TEXT[],
    subtitle TEXT,
    dedication TEXT,
    opus_number VARCHAR(8)[],
    composition_year INT NOT NULL,
    publication_year INT,
    key_id INT REFERENCES lookups.key_signature (key_id),
    style_id INT NOT NULL REFERENCES lookups.composition_style (style_id)
        ON DELETE SET NULL,
    instrumentation_id INT REFERENCES lookups.instrumentation (instrumentation_id),
    instrumentation_alias INT DEFAULT 0, -- Index of the alias used, 0 if using the default name
        CHECK (instrumentation_alias = 0 OR instrumentation_id IS NOT NULL)
);

-- Arrangement
/* An arrangement (or re-orchestration, including reductions) of an existing composition by a composer */
CREATE TABLE compositions.arrangement (
    arrangement_id INT PRIMARY KEY REFERENCES compositions.work (work_id),
    composition_id INT NOT NULL REFERENCES compositions.composition (composition_id)
        ON DELETE CASCADE,
    composer_id INT NOT NULL REFERENCES artists.artist (artist_id)
        ON DELETE CASCADE,
    dedication TEXT,
    opus_number VARCHAR(8)[],
    composition_year INT NOT NULL,
    publication_year INT,
    instrumentation_id INT REFERENCES lookups.instrumentation (instrumentation_id),
    instrumentation_alias INT DEFAULT 0, -- Index of the alias used, 0 if using the default name
        CHECK (instrumentation_alias = 0 OR instrumentation_id IS NOT NULL)
);

-- Movement
/* A single movement or section for a given composition */
CREATE TABLE compositions.movement (
    movement_id INT GENERATED ALWAYS AS IDENTITY PRIMARY KEY,
    composition_id INT NOT NULL REFERENCES compositions.composition (composition_id)
        ON DELETE CASCADE,
    number INT NOT NULL,
        CHECK (number > 0),
    title TEXT NOT NULL
);

-- Movement Passage
/* A passage in a movement denoted by a tempo and/or a key change */
CREATE TABLE compositions.movement_passage (
    passage_id INT GENERATED ALWAYS AS IDENTITY PRIMARY KEY,
    movement_id INT REFERENCES compositions.movement (movement_id)
        ON DELETE CASCADE,
    passage_number INT NOT NULL, -- Used for ordering passages
        CHECK (passage_number >= 0),
    tempo TEXT,
    key_id INT REFERENCES lookups.key_signature (key_id),
    CHECK (tempo IS NOT NULL OR key_id IS NOT NULL)
);

-- Catalogue
/* An ordering of a specific composer's body of work, assembled by an outside party (typically a musicologist) */
CREATE TABLE compositions.catalogue (
    catalogue_id INT GENERATED ALWAYS AS IDENTITY PRIMARY KEY,
    composer_id INT NOT NULL REFERENCES artists.artist (artist_id)
        ON DELETE CASCADE,
    title TEXT NOT NULL,
    symbol VARCHAR(16) NOT NULL, -- The identifier associated with the catalogue when numbering a composition
    authors full_name[] NOT NULL
        CHECK (cardinality(authors) > 0),
    publication_year INT NOT NULL
);

-- Catalogue Number
/* A catalogue number referring to a specific composition */
CREATE TABLE compositions.catalogue_number (
    work_id INT REFERENCES compositions.work (work_id)
        ON DELETE CASCADE,
    catalogue_id INT REFERENCES compositions.catalogue (catalogue_id)
        ON DELETE CASCADE,
    number VARCHAR(8) NOT NULL,
    PRIMARY KEY (catalogue_id, number)
);

-- Instrumentation Player
/* An entity representing a single player of one or more instruments,
   or a section, in the instrumentation of a given composition.
   Can optionally contain a key ID for transposing instruments */
CREATE TABLE compositions.instrumentation_player (
    player_id INT GENERATED ALWAYS AS IDENTITY PRIMARY KEY,
    work_id INT REFERENCES compositions.work (work_id)
        ON DELETE CASCADE,
    instrument_id INT NOT NULL REFERENCES lookups.instrument (instrument_id),
    instrument_alias INT DEFAULT 0, -- Index of the alias used, 0 if using the default name
    transposing_key_id INT REFERENCES lookups.instrument_key (key_id),
    chair_number INT NOT NULL,
        CHECK (chair_number >= 0), -- Should be zero for soloists, unassigned percussion, and un-numbered sections
    is_soloist BOOL DEFAULT false,
        CHECK (is_soloist = false OR chair_number = 0),
    is_section BOOL DEFAULT false,
    movements INT[] -- The movements the player performs in
);

-- Instrumentation Doubling
/* An additional instrument used by a player in the instrumentation for a given composition */
CREATE TABLE compositions.instrumentation_doubling (
    player_id INT REFERENCES compositions.instrumentation_player (player_id)
        ON DELETE CASCADE,
    instrument_id INT REFERENCES lookups.instrument (instrument_id),
    instrument_alias INT DEFAULT 0, -- Index of the alias used, 0 if using the default name
    transposing_key_id INT REFERENCES lookups.instrument_key (key_id),
    movements INT[], -- The movements where this doubling is utilized
    PRIMARY KEY (player_id, instrument_id, transposing_key_id)
);

/* Functions & Triggers */

-- FUNCTION: generate_work_id()
/* Generate a work ID for use as a primary key for an composition or arrangement */
CREATE FUNCTION compositions.generate_work_id()
    RETURNS TRIGGER AS $$
DECLARE
    new_work_id INT;
BEGIN
    -- Create a new entry in the work table and capture the work ID
    INSERT INTO compositions.work DEFAULT VALUES
    RETURNING work_id INTO new_work_id;
    -- Insert the work_id as the PK for the composition or arrangement
    IF TG_TABLE_NAME = 'composition' THEN
        NEW.composition_id := new_work_id;
    ELSIF TG_TABLE_NAME = 'arrangement' THEN
        NEW.arrangement_id := new_work_id;
    END IF;
    RETURN NEW;
END;
$$ LANGUAGE plpgsql;

-- TRIGGER: insert_composition_id
/* Generate a work_id to use as the PK for an composition entry */
CREATE TRIGGER insert_composition_id
    BEFORE INSERT ON compositions.composition
    FOR EACH ROW
EXECUTE FUNCTION compositions.generate_work_id();

-- TRIGGER: insert_arrangement_id
/* Generate a work_id to use as the PK for an arrangement entry */
CREATE TRIGGER insert_arrangement_id
    BEFORE INSERT ON compositions.arrangement
    FOR EACH ROW
EXECUTE FUNCTION compositions.generate_work_id();

-- FUNCTION: delete_work_id()
/* Remove the corresponding work ID from the work table when an composition or arrangement is deleted */
CREATE FUNCTION compositions.delete_work_id()
    RETURNS TRIGGER AS $$
BEGIN
    IF TG_TABLE_NAME = 'composition' THEN
        DELETE FROM compositions.work WHERE work_id = OLD.composition_id;
    ELSIF TG_TABLE_NAME = 'arrangement' THEN
        DELETE FROM compositions.work WHERE work_id = OLD.arrangement_id;
    END IF;
    RETURN OLD;
END;
$$ LANGUAGE plpgsql;

-- TRIGGER: delete_composition_work_id
/* Delete the work ID for an composition after the entity is deleted */
CREATE TRIGGER delete_composition_work_id
    AFTER DELETE ON compositions.composition
    FOR EACH ROW
EXECUTE FUNCTION compositions.delete_work_id();

-- TRIGGER: delete_arrangement_work_id
/* Delete the work ID for an arrangement after the entity is deleted */
CREATE TRIGGER delete_arrangement_work_id
    AFTER DELETE ON compositions.arrangement
    FOR EACH ROW
EXECUTE FUNCTION compositions.delete_work_id();

-- FUNCTION: validate_composer_ids_match()
/* Compares the composer ID of a catalogue and work to ensure they match, so that works
   are only added to catalogues associated with that composer */
CREATE FUNCTION compositions.validate_composer_ids_match()
RETURNS TRIGGER AS $$
DECLARE
    work_composer_id INT;
    catalogue_composer_id INT;
BEGIN
    -- Get composer ID of the catalogue
    SELECT composer_id INTO catalogue_composer_id
    FROM compositions.catalogue
    WHERE catalogue_id = NEW.catalogue_id;

    -- Get composer ID of the composition
    SELECT composer_id INTO work_composer_id
    FROM compositions.composition
    WHERE composition_id = NEW.work_id;

    -- Search the arrangements table if composer is not found
    IF work_composer_id IS NULL THEN
        SELECT composer_id INTO work_composer_id
        FROM compositions.arrangement
        WHERE arrangement_id = NEW.work_id;
    END IF;

    -- Validate composers match, otherwise raise exception to abort insert
    IF work_composer_id != catalogue_composer_id
    THEN
        RAISE EXCEPTION 'Composer of the work must match the composer associated with the catalogue';
    END IF;
END;
$$ LANGUAGE plpgsql;

-- TRIGGER: check_composer_ids
/* Ensure composer for composition and catalogue are the same before adding catalogue number */
CREATE TRIGGER check_composer_ids
    BEFORE INSERT ON compositions.catalogue_number
    FOR EACH ROW
EXECUTE FUNCTION compositions.validate_composer_ids_match();
