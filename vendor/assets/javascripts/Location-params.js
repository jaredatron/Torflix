Location = window.location.constructor

Object.defineProperty(Location.prototype, 'params', {
  get: function(){
   'use strict';
    var regex = /([^&=]+)=?([^&]*)/g;
    var match, params = {};

    var search = this.search
    search = search.substring(search.indexOf('?') + 1, search.length);

    while ((match = regex.exec(search))) {
      params[decodeURIComponent(match[1])] = match[2] === "" ? undefined : decodeURIComponent(match[2]);
    }

    return params;
  },

  set: function(params){
    if ('object' !== typeof params) return;
    this.search = Object.keys(params).map(function(key){
      var value = params[key]
      return value == null ? key : key+'='+value;
    }).join('&')
  }
});

