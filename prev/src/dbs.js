'use strict';

import * as indexes from './indexes';
import * as initDb from './initDb';
import { Database as ArangoDatabase } from 'arangojs';
import createCache from './redis';


// todo:
// sensitive information should be in env file
const selectDb = ({
  data = {},
  db,
  dbName,
  indexConfigs,
  type,
  uname,
  upass,
}) => {
  switch (type) {
    case 'redis': return createCache({ data });
    case 'arango': {
      db.useDatabase(dbName);
      db.useBasicAuth(uname, upass);

      indexes.ensureIndexes({
        db,
        dbName,
        type,
        indexConfigs
      })
      .then(() => initDb.hydrate({
        type,
        dbName,
        db,
      }))

      return db;
    }
  }
}


// move url process.env
const getArangoDb = ({
  dbName,
  indexConfigs,
  uname = 'root',
  upass = 'root',
}) => {
  const arangoDb = new ArangoDatabase({
    url: 'http://localhost:8529',
  });

  if (dbName, uname, upass) return selectDb({
    db: arangoDb,
    dbName,
    type: 'arango',
    uname,
    upass,
  });

  return arangoDb;
}


export const getDb =  ({ type, data = {} }) => {
  switch (type) {
    case 'arango': return getArangoDb({ ...data});
    case 'redis': return selectDb({ type, data });
    default: throw(`cannot get ${type} database`)
  }
}
