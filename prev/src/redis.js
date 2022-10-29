'use strict';

/**
 * node redis- https://github.com/NodeRedis/node_redis
 *
 * REMEMBER
 * When an inherited function is executed, the value of this points to the inheriting object, not to the prototype object where the function is an own property.
 * TODO
 * for somereadson MULTI throws error but still runs?
 * be careful with multiple args, send as an array, @see runnable.srem action thing where we concaat
 */
import redis from "redis";
import { time } from '@nirv/utils';




const Cache = {
  // TODO
  // the promise is never returned when using isMulti in async action method?
 async redisCb (fn, val) {
    return (
      new Promise(
        (resolve, reject) =>
          fn(
            val,
            (err, reply) => {
              if (err) reject(err)
              else resolve(reply)
            }
          )
      )
    );
  },

// need to cache this type of SET being used
// so that we can GET it with the correct command
  async action ({
    type,
    val,
    isMulti = undefined,
    multi = isMulti ? this.client.multi() : undefined,
  }) {
    if (multi) return val.length
      ? this.action({
        multi: ((thisVal = val.shift()) => multi[thisVal[0]](thisVal[1]))(),
        isMulti,
        val,
      })
      : this.redisCb(multi.exec.bind(multi), undefined)


    if (this.client[type]) {
      return this.redisCb(this.client[type].bind(this.client), val)
    }

  },

  createPushableActionEvent ({ event, handler, mins = 1}) {
    const eventDate = event.start.split('T')[0]; //time.utc(data.event.start).startOf('day').format().split('T');
    const eventEpoch = time.utc(event.start).unix();

    return {
      name: `${handler}.${eventDate}`,
      value: `${eventEpoch}.${event.id}`,
    }
  }
}

// so that cache.blah works
// @see https://stackoverflow.com/questions/14450731/why-is-javascript-prototype-property-undefined-on-new-objects
export default function createCache () {
  const thisCache = Object.create(Cache);

  thisCache.client = redis.createClient();

  return thisCache;
}
