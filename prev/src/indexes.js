'use strict';


import defaultIndexConfigs from './defaultIndexConfigs';


export const ensureIndexes = async ({
  db,
  type = 'arango',
  dbName,
  indexConfigs = defaultIndexConfigs,
}) => {
  if (type === 'arango' && indexConfigs[type] && indexConfigs[type][dbName] && indexConfigs[type][dbName].length)
    indexConfigs[type][dbName].forEach(({collectionName, ...rest}) => (
      db.collection(collectionName).createIndex({
        ...rest
      }).catch(e => console.error(`
        unable to create in ${collectionName}; \n\n
        index data: ${JSON.stringify(rest, null, 2)} \n\n
        error: ${e}
      `))
    ))
  else console.log()

  return db;
}
