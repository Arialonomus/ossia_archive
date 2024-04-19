import pgpromise from 'pg-promise';
import config from '../config/db-config.json' assert { type: 'json' };

const pgp = pgpromise();
const db = pgp(config.connection);

export default db;