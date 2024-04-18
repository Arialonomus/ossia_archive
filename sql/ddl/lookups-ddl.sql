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
    is_major BOOL NOT NULL
);

INSERT INTO lookups.key_signature (key_name, is_major)
VALUES
    ('C major', true), ('A minor', false), ('G major', true), ('E minor', false), ('F major', true),
    ('D minor', false), ('D major', true), ('B minor', false), ('B flat major', true), ('G minor', false),
    ('A major', true), ('F sharp minor', false), ('E flat major', true), ('C minor', false),
    ('E major', true), ('C sharp minor', false), ('A flat major', true), ('F minor', false),
    ('B major', true),  ('G sharp minor', false), ('D flat major', true), ('B flat minor', false),
    ('F sharp major', true), ('D sharp minor', false),  ('G flat major', true), ('E flat minor', false),
    ('C sharp major', true), ('A sharp minor', false), ('C flat major', true), ('A flat minor', false);

-- Style
/* The style (sometimes form or genre) of a given composition */
CREATE TABLE lookups.composition_style (
    style_id INT GENERATED ALWAYS AS IDENTITY PRIMARY KEY,
    style_name TEXT NOT NULL
);