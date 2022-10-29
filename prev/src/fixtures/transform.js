'use strict';

import activitySource from './activitySource';
import pathSource from './pathSource';
import skillzSource from './skillzSource';
import verbzSource from './verbzSource';

import {
  upsertActivity,
  upsertPath,
  upsertSkillz,
  upsertVerbz,
} from '@nirv/utils';


const transformConfig = {
  activity: { source: activitySource, fn: upsertActivity },
  path: { source: pathSource, fn: upsertPath },
  skillz: { source: skillzSource, fn: upsertSkillz },
  verbz: { source: verbzSource, fn: upsertVerbz },
};


const transformSource = ({ source, fn }) => (
  [...(new Set(source))]
    .filter(a => typeof a === 'string'
      ? a.trim().length
      : a
    )
    .map(thing => typeof thing === 'string'
      ? fn({ name: thing.toUpperCase() })
      : fn({...thing, name: thing.name.toUpperCase() })
    )
);


export const transformAll = () => (
  transformConfig.forEach(({ source, fn }) => (
    transformSource({ source, fn })
  ))
);


export const transform = (type) => (
  type in transformConfig
    ? transformSource(transformConfig[type])
    : throw `${type} not setup for transform`
);


export const resetScores = () => {
  const s = {};
  const a = {};

  pathSource.forEach(({ strategies }) => {
    strategies.forEach(({ activities, skillz }) => {
      activities.forEach(name => {
        if (name in a) a[name]++
        else a[name] = 1;
      });

      skillz.forEach(name => {
        if (name in s) s[name]++;
        else s[name] = 1
      });
    })
  });

  return { activity: a, skillz: s, };
}
