// cleanup after running
// manually fix htese dupes
// remember they were split on ',' and 'and' so do your best
/*
  'construction',  'technicians',
  'aides',         'mechanics',
  'electrical',    'repairers',
  'agricultural',  'compensation',
  'computer',      'medical',
  'social',        'training',
  'food',          'police',
  'investigators'
*/
// search for [""] replace with []


const fs = require('fs');
const { upsertStrategy } = require('@nirv/utils');

// @see https://gist.github.com/iwek/7154706
(() => {
  const file = fs.readFileSync('./paths.tsv', 'utf8');

  const lines = file.split('\n');
  const headers = lines.slice(0, 1)[0].split('\t').map(id => id === 'discipline'
    ? 'disciplines'
    : id === 'onething'
    ? 'oneThing'
    : id === 'children_paths'
    ? 'childPaths'
    : id === 'strategy'
    ? 'strategies'
    : (id === '' || id === '\r')
    ? false
    : id
  ).filter(id => id);

  console.log('\n\n headers', headers);

  const finalData = [];

  const all = [];
  const dupes = [];

  lines.slice(1).forEach((line, i, arr) => {
    const data = line.split('\t');
    const pathNames = data[0].split(',').flatMap(pathName => pathName.split('and'));

    pathNames.forEach(name => {
      const thisName = name.trim();
      if (!thisName) return null;

      if (all.includes(thisName) && !dupes.includes(thisName)) dupes.push(thisName);
      else all.push(thisName);

      finalData.push(headers.reduce(
        (obj, nextKey, index) => {
          let record;
          if (index === 0) {
            record = thisName;
            // wont work, as you need to search in pathnames with pathNames.find(blah = blah.name === name)
            // if (record in obj) throw `duplicate name: ${record}`
          }
          else if (nextKey === 'childPaths') record = data[index].split(',').map(s => s.trim());
          else if (nextKey === 'oneThing') record = data[index].trim();
          else { // push everything else into the first strategy
            const thisKey = nextKey === 'strategies'
              ? 'activities'
              : nextKey

            obj.strategies[0] = {
              ...obj.strategies[0],
              [thisKey]: thisKey === 'activities'
                ? data[index].split(/\.|,/g).map(s => s.trim())
                : data[index].split(',').map(s => s.trim())
            }

            return obj;
          }

          obj[nextKey] = record;
          return obj;
        },
        { playerIds: ['nirv'], strategies: [upsertStrategy({ id: 'base', name: 'base', playerIds: ['nirv'] })]}
      ));
    });
  });

  console.log('\n\n\n dupes', dupes);
  fs.writeFileSync('./pathSource.js', 'export default ' + JSON.stringify(finalData));
})();

