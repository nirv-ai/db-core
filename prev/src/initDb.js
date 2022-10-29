'use strict';
// TODO
// move all this logic to separate server available at some endpoint
// will also allow initting ANY db with ANY of our data providing the right credentials
//
//
import * as utils from './utils';
import { read, update } from './main';
import { transform, resetScores } from './fixtures/transform';
import { upsertSkillz, upsertActivity } from '@nirv/utils';

// hacky reset scores, set to false to update
// const scores = resetScores();
const did = {
  skillz: true,
  activity: true,
}

// todo
// this should be kept in a config store
const initConfig = {
  activity: {
    statusKey: 'activity',
    collectionName: 'Activities',
  },
  skillz: {
    statusKey: 'skillz',
    collectionName: 'Skillz',
  },
  verbz: {
    statusKey: 'verbz',
    collectionName: 'Verbz',
  },
  path: {
    statusKey: 'path',
    collectionName: 'Paths',
  }
}

export const hydrate = async ({
  db,
  dbName,
  force = undefined,
  type = 'arango',
}) => {
  // if force is false return
  if (typeof force === 'bool' && !force || !initConfig[dbName]) return db;

  const dbConfig = initConfig[dbName];

  switch (dbName) {
    case 'path':
    case 'skillz':
    case 'verbz':
    case 'activity': {
      const status = utils.getFirst(await read({
        dbName: type,
        data: { collectionName: 'status', key: dbConfig.statusKey },
        type: 'byKey',
        db,
      }));

      if (status?.init !== 'complete') {
        console.log(`initializing ${dbName}`, status)
        const file = transform(dbName);

        update({
          db,
          dbName: type,
          type: 'bulk',
          data: {
            collectionName: dbConfig.collectionName,
            type: 'bulk',
            records: file,
          }
        })
        .then(() => update({
            db,
            dbName: type,
            type: 'update',
            data: {
              collectionName: 'status',
              docKey: dbConfig.statusKey,
              init: 'complete'
            },
        })).catch(e => console.error(`error initializing ${dbName}:\n ${e.message}`))
      }
    }
  }


  // resets scores for activity and skillz
  // super hacky
  if (dbName in did && !did[dbName]) {
    did[dbName] = true;
    const upsertFn = dbName === 'activity'
      ? upsertActivity
      : upsertSkillz;

    console.log('\n\n wtf', Object.entries(scores[dbName])[0]);

    return Object.entries(scores[dbName]).forEach(([name, pathStrategies]) => {
      update({
        db,
        dbName: type,
        type: 'update',
        data: {
          collectionName: dbConfig.collectionName,
          // type: 'update', // think this adds type to each record
          ...upsertFn({ name, pathStrategies })
        }
      })
    });
  }

  return db;
}


