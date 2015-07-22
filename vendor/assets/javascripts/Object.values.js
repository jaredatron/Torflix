if (!Object.values) {
  Object.defineProperty(Object, 'values', {
    enumerable: false,
    configurable: true,
    writable: true,
    value: function(target) {
      'use strict';
      if (target === undefined || target === null) {
        throw new TypeError('Cannot convert first argument to object');
      }

      return Object.keys(target).map(function(key){
        return target[key]
      });
    }
  });
}