module.exports = {
  arango: {
    verbz: [
      {
        name: 'verbzNameIndex',
        collectionName: 'Verbz',

        fields: ['name'],
        inBackground: true,
        sparse: false,
        type: 'hash',
        unique: true,
      },
    ],

    skillz: [
      {
        name: 'skillzNameIndex',
        collectionName: 'Skillz',

        fields: ['name'],
        inBackground: true,
        sparse: false,
        type: 'hash',
        unique: true,
      },
    ],

    action: [
      {
        name: 'actionNameIndex',
        collectionName: 'Actions',

        fields: ['name'],
        inBackground: true,
        sparse: false,
        type: 'hash',
        unique: true,
      },
    ],

    activity: [
      {
        name: 'activityNameIndex',
        collectionName: 'Activities',

        fields: ['name'],
        inBackground: true,
        sparse: false,
        type: 'hash',
        deduplicate: true,
        unique: true,
      },
    ],

    event: [
      {
        name: 'eventPlayerIdsIndex',
        collectionName: 'Events',

        fields: ['playerIds[*]'],
        inBackground: true,
        sparse: false,
        type: 'hash',
        deduplicate: true,
        unique: false,
      },

      {
        name: 'eventDayIndex',
        collectionName: 'Events',

        fields: ['day'],
        inBackground: true,
        sparse: false,
        type: 'hash',
        unique: false,
      },
    ],

    player: [
      {
        name: 'playerIdIndex',
        collectionName: 'Players',

        fields: ['id'],
        inBackground: true,
        sparse: false,
        type: 'hash',
        unique: true,
      },
      {
        name: 'playerEmailIndex',
        collectionName: 'Players',

        fields: ['email'],
        inBackground: true,
        sparse: false,
        type: 'hash',
        unique: true,
      },
    ],

    msg: [
      {
        name: 'msgTimestampToIndex',
        collectionName: 'Msgs',

        fields: ['timestamp', 'to'],
        inBackground: true,
        sparse: false,
        type: 'skiplist',
        unique: false,
      },
    ],

    // TODO
    path: [
      {
        name: 'pathIdStrategyIdIndex',
        collectionName: 'Paths',

        fields: ['id', 'strategies[*].id'],
        inBackground: true,
        sparse: true,
        type: 'persistent',
        deduplicate: true,
        unique: true,
      },

      {
        name: 'pathNameIndex',
        collectionName: 'Paths',

        fields: ['name'],
        inBackground: true,
        sparse: false,
        type: 'hash',
        deduplicate: true,
        unique: true,
      },

      {
        name: 'pathPlayerIdsIndex',
        collectionName: 'Paths',

        fields: ['playerIds[*]'],
        inBackground: true,
        sparse: true,
        type: 'persistent',
        deduplicate: true,
        unique: false,
      },
    ],
  },
}
