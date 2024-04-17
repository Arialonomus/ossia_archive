/* Lookups */
/* Tables that hold stable categories of information, such as instrument names, etc. */

CREATE SCHEMA lookups;

-- Instrument Family
/* A family of musical instruments, such as Brass or Strings.
   Used for grouping instruments to aid in display and selection. */
CREATE TABLE lookups.instrument_family (
    family_id INT GENERATED ALWAYS AS IDENTITY PRIMARY KEY,
    family_name VARCHAR(12) NOT NULL
);

INSERT INTO lookups.instrument_family (family_name)
VALUES
    ('Woodwind'), ('Brass'), ('String'), ('Keyboard'), ('Percussion'), ('Voice'), ('Other');

-- Instrument Key
/* The musical key for a transposing instrument, used when describing detailed instrumentation for a composition */
CREATE TABLE lookups.instrument_key (
    key_id INT GENERATED ALWAYS AS IDENTITY PRIMARY KEY,
    key_name VARCHAR(8)
);

INSERT INTO lookups.instrument_key (key_name)
VALUES
    ('A'), ('A flat'), ('B'), ('B flat'), ('C'), ('D'), ('D flat'), ('E'), ('E flat'), ('F'), ('G');

-- Instrument Register
/* The register (i.e. Piccolo, Tenor, Contrabass) for a transposing instrument */
CREATE TABLE lookups.instrument_register (
    register_id INT GENERATED ALWAYS AS IDENTITY PRIMARY KEY,
    register_name VARCHAR(20)
);

INSERT INTO lookups.instrument_register (register_name)
VALUES
    ('Piccolo'), ('Treble'), ('Soprillo'), ('Sopranino'), ('Soprano'), ('Alto'), ('Contra-alto'), ('Tenor'),
    ('Baritone'), ('Bass'), ('Contrabass'), ('Subcontrabass'), ('Double contrabass');

-- Instrument
/* A general form of a single musical instrument, such as a trumpet or flute */
CREATE TABLE lookups.base_instrument(
    family_id INT NOT NULL REFERENCES lookups.instrument_family (family_id),
    base_inst_id INT GENERATED ALWAYS AS IDENTITY PRIMARY KEY,
    base_inst_name TEXT NOT NULL
);

-- Transposing Instrument
/* A variant form of a base instrument, such as a Piccolo Flute or Trumpet in B flat, used in the detailed
   instrumentation for a given composition.
   NOTE: Some transposing instruments, such as the English Horn, fall outside the standard naming conventions for
   transposing instruments and are thus considered Base Instruments for the purposes of the data model */
CREATE TABLE lookups.transposing_instrument (
    transposing_inst_id INT GENERATED ALWAYS AS IDENTITY PRIMARY KEY,
    base_inst_id INT NOT NULL REFERENCES lookups.base_instrument (base_inst_id)
        ON DELETE CASCADE,
    register_id INT REFERENCES lookups.instrument_register (register_id),
    key_id INT REFERENCES lookups.instrument_key (key_id),
    CHECK (register_id IS NOT NULL OR key_id IS NOT NULL),
    UNIQUE (base_inst_id, register_id, key_id)
);

-- Key Signature
/* The key signature for a given composition */
CREATE TABLE lookups.key_signature (
    key_id INT GENERATED ALWAYS AS IDENTITY PRIMARY KEY,
    key_name VARCHAR(16) NOT NULL,
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
