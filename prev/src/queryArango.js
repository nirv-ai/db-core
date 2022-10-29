'use strict';

import { aql } from 'arangojs';


// TODO
// many reads should be using projection|rojectFilter
// especially when retrieving to validate request and subsequently update items
// or we can force update items and handle the errors (maybe more efficient)
// add examples of each param so you dont have to hunt for this sht bich
const getDocKey = record => (
  record._key
    || record.key
    || record.id
    || record.name
    || record.handle
);

const query = (type) => ({
  data: {
    collectionName,
    docKey,
    filter,
    itemId,
    limit = 500,
    obj,
    projection,
    prop,
    propValue,
    sort = 'doc.ts',

    ...data
  },
  db
}) => {
  const thisDocKey = docKey || getDocKey(data);

  switch (type) {
    // should be upsert replace
    case 'bulk': return (
      aql`
        let records = ${data.records.map(r => ({ ...r, _key: getDocKey(r) }))}
        FOR record in records
        UPSERT { _key: record._key }
        INSERT MERGE(record, {ts: DATE_NOW()})
        UPDATE MERGE(record, {ts: DATE_NOW()})
        INTO ${db.collection(collectionName)}
      `
    );


    case 'update': {
      const record = {
        ...data,
        _key: thisDocKey,
      };

      return  (
        aql`
          let key = ${thisDocKey}
          let record = ${record}
          UPSERT { _key: key }
          INSERT MERGE(record, {ts: DATE_NOW()})
          UPDATE MERGE(record, {ts: DATE_NOW()})
          IN ${db.collection(collectionName)}
        `
      )
    };

    case 'updateReturn': {
      const record = {
        ...data,
        _key: thisDocKey,
      };

      return  (
        aql`
          let key = ${thisDocKey}
          let record = ${record}
          UPSERT { _key: key }
          INSERT MERGE(record, {ts: DATE_NOW()})
          UPDATE MERGE(record, {ts: DATE_NOW()})
          IN ${db.collection(collectionName)}
          RETURN UNSET(NEW, "_key", "_id", "_rev")
        `
      )
    };

    case 'incrementThing': {
      return  (
        aql`
          let key = ${thisDocKey}
          let prop = ${prop}
          let propValue = ${propValue}

          UPSERT { _key: key }
          INSERT { ts: DATE_NOW(), [prop]: propValue, id: key }
          UPDATE { ts: DATE_NOW(), [prop]: (OLD[prop] || 0) + propValue }
          IN ${db.collection(collectionName)}
          RETURN UNSET(NEW, "_key", "_id", "_rev")
        `
      );
    };

    // TODO
    // monitor this to ensure the order of playerIds does not change
    // as in many cases the first player is assumed owner
    case 'updateReturnUnionPlayerIds': {
      const record = {
        ...data,
        _key: thisDocKey,
      };

      return  (
        aql`
          let key = ${thisDocKey}
          let record = ${record}
          UPSERT { _key: key }
          INSERT MERGE(record, {ts: DATE_NOW()})
          UPDATE { ts: DATE_NOW(), playerIds: OLD.playerIds ? UNION_DISTINCT(record.playerIds, OLD.playerIds) : record.playerIds}
          IN ${db.collection(collectionName)}
          RETURN UNSET(NEW, "_key", "_id", "_rev")
        `
      );
    };

    case 'updateReturnMinusPlayerIds': {
      const record = {
        ...data,
        _key: thisDocKey,
      };

      return  (
        aql`
          let key = ${thisDocKey}
          let record = ${record}
          UPSERT { _key: key }
          INSERT MERGE(record, {ts: DATE_NOW()})
          UPDATE { ts: DATE_NOW(), playerIds: OLD.playerIds ? MINUS(OLD.playerIds, record.playerIds) : []}
          IN ${db.collection(collectionName)}
          RETURN UNSET(NEW, "_key", "_id", "_rev")
        `
      );
    };

    // TODO
    // need to check if an item will be updated
    // @see https://www.arangodb.com/docs/3.6/aql/examples-data-modification-queries.html
    case 'updateReturnDocArrayItem': {
      return  (
        aql`
          let colName = ${collectionName}
          let key = ${thisDocKey}
          LET doc = DOCUMENT(colName, key)
          let itemId = ${itemId}
          let obj = ${obj}
          let prop = ${prop}

          let updated = (
            FOR item in doc[prop]
            LET newItem = (item.id == itemId
              ? MERGE(item, obj, { ts: DATE_NOW() })
              : item
            )
            return newItem
          )
          UPDATE doc WITH { [prop]: updated, ts: DATE_NOW()} in ${db.collection(collectionName)}
          RETURN UNSET(NEW, "_key", "_id", "_rev")

        `
      );
    };

    case 'replace': {
      const record = {
        ...data,
        _key: thisDocKey,
      };

      return (
        aql`
          let key = ${thisDocKey}
          let record = ${record}
          UPSERT { _key: key }
          INSERT MERGE(record, {ts: DATE_NOW()})
          REPLACE MERGE(record, {ts: DATE_NOW()})
          IN ${db.collection(collectionName)}
        `
      )
    };


    case 'byKey': return (
      `
        RETURN UNSET(DOCUMENT("${collectionName}/${thisDocKey}"), "_key", "_id", "_rev")
      `
    );


    case 'filter': return (
      aql`
        FOR doc in ${db.collection(collectionName)}
        FILTER ${aql.literal(filter)}
        RETURN UNSET(doc, "_key", "_id", "_rev")
      `
    );

    case 'filterSortLimit': return (
      aql`
        FOR doc in ${db.collection(collectionName)}
        FILTER ${aql.literal(filter)}
        SORT ${aql.literal(sort)}
        LIMIT ${aql.literal(limit)}
        RETURN UNSET(doc, "_key", "_id", "_rev")
      `
    );

    case 'filterProjection': return (
      aql`
        FOR doc in ${db.collection(collectionName)}
        FILTER ${aql.literal(filter)}
        return ${aql.literal(projection)}
      `
    );

    case 'all': return (
      aql`
        for doc in ${db.collection(collectionName)}
        SORT ${aql.literal(sort)}
        LIMIT ${aql.literal(limit)}
        RETURN UNSET(doc, "_key", "_id", "_rev")
      `
    );


    default: throw `${type} not setup for qureyArango.query`
  }
}


export default {
  // utility
  // write
  bulk: query('bulk'),
  replace: query('replace'),
  update: query('update'),
  updateReturn: query('updateReturn'),
  updateReturnUnionPlayerIds: query('updateReturnUnionPlayerIds'),
  updateReturnMinusPlayerIds: query('updateReturnMinusPlayerIds'),
  updateReturnDocArrayItem: query('updateReturnDocArrayItem'),
  incrementThing: query('incrementThing'),

  // read
  all: query('all'),
  byKey: query('byKey'),
  filter: query('filter'),
  filterProjection: query('filterProjection'),
  filterSortLimit: query('filterSortLimit'),

  // specific - hoever should all use one of the above
  newActivityActionEvent: query('newActivityActionEvent'),
}
