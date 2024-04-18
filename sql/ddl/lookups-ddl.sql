/* Lookups */
/* Tables that hold stable categories of information, such as instrument names, etc. */

CREATE SCHEMA lookups;

-- Instrument Family
/* A family of musical instruments, such as Brass or Strings.
   Used for grouping instruments to aid in display and selection. */
CREATE TABLE lookups.instrument_family (
    family_id INT GENERATED ALWAYS AS IDENTITY PRIMARY KEY,
    family_name VARCHAR(12) NOT NULL UNIQUE
);

INSERT INTO lookups.instrument_family (family_name)
VALUES
    ('Woodwind'), ('Brass'), ('String'), ('Keyboard'), ('Percussion'), ('Voice'), ('Other');

-- Instrument Key
/* The musical key for a transposing instrument, used when
   describing detailed instrumentation for a composition */
CREATE TABLE lookups.instrument_key (
    key_id INT GENERATED ALWAYS AS IDENTITY PRIMARY KEY,
    key_name VARCHAR(8) NOT NULL UNIQUE
);

INSERT INTO lookups.instrument_key (key_name)
VALUES
    ('A'), ('A flat'), ('B'), ('B flat'), ('C'), ('D'), ('D flat'), ('E'), ('E flat'), ('F'), ('G');

-- Instrument Register
/* The register (i.e. Piccolo, Tenor, Contrabass) for a transposing instrument */
CREATE TABLE lookups.instrument_register (
    register_id INT GENERATED ALWAYS AS IDENTITY PRIMARY KEY,
    register_name VARCHAR(20) NOT NULL UNIQUE
);

INSERT INTO lookups.instrument_register (register_name)
VALUES
    ('Piccolo'), ('Treble'), ('Soprillo'), ('Sopranino'), ('Soprano'), ('Alto'), ('Contra-alto'), ('Tenor'),
    ('Baritone'), ('Bass'), ('Contrabass'), ('Subcontrabass'), ('Double contrabass');

-- Instrument
/* A single musical instrument, such as a trumpet or piano,
   can optionally include a register ID for instruments that have register variants
   such as a piccolo flute or bass trombone */
CREATE TABLE lookups.instrument(
    instrument_id INT GENERATED ALWAYS AS IDENTITY PRIMARY KEY,
    family_id INT NOT NULL REFERENCES lookups.instrument_family (family_id),
    register_id INT REFERENCES lookups.instrument_register (register_id),
    instrument_name TEXT NOT NULL,
    -- Alternative names used to refer to the same instrument (such as English Horn and Cor Anglais)
    instrument_aliases TEXT[],
    UNIQUE (register_id, instrument_name)
);

-- Transposing Instrument (Intersection Table)
/* A variant of an instrument that can be pitched to different keys,
   such as a French Horn in F or a Clarinet in A flat */
CREATE TABLE lookups.transposing_instrument (
    instrument_id INT NOT NULL REFERENCES lookups.instrument (instrument_id),
    key_id INT REFERENCES lookups.instrument_key (key_id),
    PRIMARY KEY (instrument_id, key_id)
);

-- Key Signature
/* The key signature for a given composition */
CREATE TABLE lookups.key_signature (
    key_id INT GENERATED ALWAYS AS IDENTITY PRIMARY KEY,
    key_name VARCHAR(16) NOT NULL UNIQUE,
    key_type VARCHAR(8) NOT NULL,
    CHECK (key_type = 'Major' OR key_type = 'Minor')
);

INSERT INTO lookups.key_signature (key_name, key_type)
VALUES
    ('C major', 'Major'), ('A minor', 'Minor'), ('G major', 'Major'), ('E minor', 'Minor'), ('F major', 'Major'),
    ('D minor', 'Minor'), ('D major', 'Major'), ('B minor', 'Minor'), ('B flat major', 'Major'), ('G minor', 'Minor'),
    ('A major', 'Major'), ('F sharp minor', 'Minor'), ('E flat major', 'Major'), ('C minor', 'Minor'),
    ('E major', 'Major'), ('C sharp minor', 'Minor'), ('A flat major', 'Major'), ('F minor', 'Minor'),
    ('B major', 'Major'),  ('G sharp minor', 'Minor'), ('D flat major', 'Major'), ('B flat minor', 'Minor'),
    ('F sharp major', 'Major'), ('D sharp minor', 'Minor'),  ('G flat major', 'Major'), ('E flat minor', 'Minor'),
    ('C sharp major', 'Major'), ('A sharp minor', 'Minor'), ('C flat major', 'Major'), ('A flat minor', 'Minor');

-- Style
/* The style (sometimes form or genre) of a given composition */
CREATE TABLE lookups.composition_style (
    style_id INT GENERATED ALWAYS AS IDENTITY PRIMARY KEY,
    style_name TEXT NOT NULL
);