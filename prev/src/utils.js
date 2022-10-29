'use strict';

import { isReq } from '@nirv/utils';

export const getAll = (response) => (
  Array.isArray(response?._result)
    ?( Array.isArray(response._result[0]) && response._result.pop() || response._result )
    :[ response._result ]
);


export const getFirst = (response) => {
  const all = getAll(response);

  return Array.isArray(all)
    ? all.pop()
    : all;
};


export const incrementThing = ({
  collectionName = isReq('collectionName', 'incrementThing'),
  db = isReq('db', 'incrementThing'),
  dbName = 'arango',
  key = isReq('key', 'incrementThing'),
  prop = isReq('prop', 'incrementThing'),
  propValue = isReq('propValue', 'propValue'),
  type = 'incrementThing',
}) => ({
  data: { key, collectionName, prop, propValue },
  db,
  dbName,
  type,
});

export const getThingById = ({
  collectionName = isReq('collectionName', 'getThingById'),
  db = isReq('db', 'getThingById'),
  dbName = 'arango',
  key = isReq('key', 'getThingById'),
  type = 'byKey',
}) => ({
  data: { key, collectionName },
  db,
  dbName,
  type,
});


export const getThingsById = ({
  collectionName = isReq('collectionName', 'getThingById'),
  db = isReq('db', 'getThingById'),
  dbName = 'arango',
  idArray = isReq('idArray', 'getThingById'),
  type = 'filter',
}) => ({
  data: {
    collectionName,
    filter: `doc.id in [${idArray.map(i => JSON.stringify(i)).join(',')}]`
  },
  db,
  dbName,
  type,
});


export const getThingsByToField = ({
  collectionName = isReq('collectionName', 'getThingsByIdSortLimit'),
  db = isReq('db', 'getThingsByIdSortLimit'),
  dbName = 'arango',
  idArray = isReq('idArray', 'getThingsByIdSortLimit'),
  limit = 100,
  sort = 'doc.timestamp', // TODO: change to doc.ts to match convention
  type = 'filterSortLimit',
}) => ({
  data: {
    collectionName,
    filter: `doc.to in [${idArray.map(i => JSON.stringify(i)).join(',')}]`,
    limit,
    sort,
  },
  db,
  dbName,
  type,
});


export const getThingsByIdProjection = ({
  collectionName = isReq('collectionName', 'getThingByIdProjection'),
  db = isReq('db', 'getThingByIdProjection'),
  dbName = 'arango',
  idArray = isReq('idArray', 'getThingByIdProjection'),
  projection = isReq('projection', 'getThingByIdProjection'),
  type = 'filterProjection',
}) => ({
  data: {
    collectionName,
    projection,
    filter: `doc.id in [${idArray.map(i => JSON.stringify(i)).join(',')}]`
  },
  db,
  dbName,
  type,
});

export const getThingsByPlayerId = ({
  collectionName = isReq('collectionName', 'getThingByPlayerId'),
  db = isReq('db', 'getThingByPlayerId'),
  dbName = 'arango',
  playerId = isReq('playerId', 'getThingByPlayerId'),
  type = 'filter',
}) => ({
  data: { collectionName, filter: `'${playerId}' in doc.playerIds` },
  db,
  dbName,
  type,
});


export const getAllThings = ({
  collectionName = isReq('collectionName', 'getThings'),
  db = isReq('db', 'getThingById'),
  dbName = 'arango',
  limit = 500,
  sort = 'doc.ts',
  type = 'all',
}) => ({
  data: { collectionName },
  db,
  dbName,
  type,
});


export const upsertThing = ({
  collectionName = isReq('collectionName', 'upsertThing'),
  db = isReq('db', 'upsertThing'),
  dbName = 'arango',
  thing = isReq('thing', 'upsertThing'),
  type = 'update',
}) => ({
  data: { ...thing, collectionName },
  db,
  dbName,
  type,
});

export const upsertReturnThing = upsertThingParams => upsertThing({ ...upsertThingParams, type: 'updateReturn' });

export const upsertReturnUnionPlayerIdsThing = upsertThingParams => upsertThing({ ...upsertThingParams, type: 'updateReturnUnionPlayerIds' });

export const upsertReturnMinusPlayerIdsThing = upsertThingParams => upsertThing({ ...upsertThingParams, type: 'updateReturnMinusPlayerIds' });

export const upsertThings = ({
  collectionName = isReq('collectionName', 'upsertThings'),
  db = isReq('db', 'upsertThings'),
  dbName = 'arango',
  records = isReq('records', 'upsertThings'),
  type = 'bulk',
}) => ({
  data: { records, collectionName },
  db,
  dbName,
  type,
});

export const updateReturnDocArrayItem = ({
  collectionName = isReq('collectionName', 'updateReturnDocArrayItem'),
  docKey = isReq('docKey', 'updateReturnDocArrayItem'),
  itemId = isReq('itemId', 'updateReturnDocArrayItem'),
  obj = isReq('obj', 'updateReturnDocArrayItem'),
  prop = isReq('prop', 'updateReturnDocArrayItem'),

  db = isReq('db', 'updateReturnDocArrayItem'),
  dbName = 'arango',
  type = 'updateReturnDocArrayItem',
}) => ({
  data: {
    docKey,
    collectionName,
    itemId,
    obj,
    prop
  },
  db,
  dbName,
  type,
});
