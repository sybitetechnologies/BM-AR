'use strict';

bankingApp.factory('registerService', ['$rootScope', '$route', '$location', '$http', '$q', '$cookieStore', function($rootScope, $route, $location, $http, $q, $cookieStore) {

  var service = {};

  /**
   * @ngdoc method
   * @name registerService#userCreate
   *
   * @description
   * Returns the promise of a User creation attempt
   *
   * @returns {Object} Promise of user creation method
   */
  service.userCreate = function(data) {
    var deferred = $q.defer(),
      start = new Date().getTime();

    $http.post('/auth', data)
      .success(function(responseJson) {
        // $cookieStore.put('sessionToken', data.auth.token);
        console.log('LOGIN: time taken for request - ' + (new Date().getTime() - start) + 'ms');
        deferred.resolve(data);
      })
      .error(function(data, status) {
        deferred.reject({
          'status': status,
          'data': data
        });
      });

    return deferred.promise;
  };

  return service;
}]);
