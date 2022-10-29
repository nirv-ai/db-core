'use strict';

import { time, isR } from '@nirv/utils';
import * as dbs from './dbs';
import * as query from './query'

export * as utils from './utils';


export const getDb = dbs.getDb;


// maps requests for updates to their executor
export const update = async ({
  data,
  db,
  dbName = 'arango',
  type,

}) => {
  switch (dbName) {
    case 'arango': return query.update(dbName)({data, db, type});
    case 'redis': return console.log('got request for updating redis')
    default: throw `${dbName} not setup for updating`
  }
}


// maps requests for reads to their executor
export const read = async ({
  data,
  db,
  dbName = 'arango',
  type,
}) => {
  switch (dbName) {
    case 'arango': return query.read(dbName)({data, db, type});
    case 'redis': return console.log('got request for reading redis')
    default: throw `${dbName} not setup for updating`
  }

}
