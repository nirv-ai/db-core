'use strict';

import queryArango from './queryArango';

// permits overriding for special cases
const callArango = async ({
  data,
  db,
  type,
}) => {
  let queryType = type;

  if (!queryArango[queryType]) throw `WTF! ${queryType} is an invalid query for ${JSON.stringify(data)}`;


  const thisQuery = queryArango[queryType]({ data, db });

  return db.query(thisQuery)
    .catch(e => console.error(`
      data: ${JSON.stringify(data, null, 2)} \n\n
      error executing ${data.collectionName}/${data.id}.\n
      query: ${JSON.stringify(thisQuery, null, 2)} \n\n
      error: ${e}
      `) || throw e
    );
}

//  all updates use this function
//  maps dbNames  to update logic
export const update = (dbName) => {
  switch (dbName) {
    case 'arango': return callArango;
    default: throw `$(dbName} not setup for updating`
  }
}


// all reads use this function
// maps dbNames to read logic
export const read = (dbName) => {
  switch (dbName) {
    case 'arango': return callArango;
    default: throw `${dbName} not setup for reading`
  }
}



