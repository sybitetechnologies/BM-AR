'use strict';

bankingApp.factory('sessionService', ['$rootScope', '$route', '$location', '$http', '$q', '$cookieStore', function($rootScope, $route, $location, $http, $q, $cookieStore) {

  var service = {};

  /**
   * @ngdoc method
   * @name sessionService#login
   *
   * @description
   * Returns the promise of a login attempt
   *
   * @param {Object} data - username and password for authentication
   * @returns {Object} Promise of login method
   */
  service.login = function(data) {
    var deferred = $q.defer(),
      start = new Date().getTime();

    $http.post('/auth/sign_in', data)
      .success(function(responseJson) {
        // $cookieStore.put('sessionToken', data.auth.token);
        $cookieStore.put('sessionUser', responseJson.data);
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

  /**
   * @ngdoc method
   * @name sessionService#getSession
   *
   * @description
   * Returns the promise of determining if token is still valid
   *
   * @returns {Object} Promise of session method
   */
  service.getSession = function() {
    var deferred = $q.defer(),
      start = new Date().getTime(),
      data = {
        'uid': "uid",
        'client': "client",
        'access-token': "access-token"
      };

    if (!$cookieStore.get('sessionToken')) {
      $timeout(function() {
        deferred.reject({});
      }, 300);
    } else {
      $http.post(apiPrefix + '/auth/validate_token', data)
        .success(function(data) {
          var now = new Date().getTime();
          console.log('GET SESSION: time taken for request - ' + (new Date().getTime() - start) + 'ms');
          deferred.resolve(data);
        })
        .error(function() {
          service.logout();
        });
    }

    return deferred.promise;
  };

  /**
   * @ngdoc method
   * @name sessionService#logout
   *
   * @description
   * Removes cookies for session token and user information
   */
  service.logout = function() {
    var deferred = $q.defer(),
      start = new Date().getTime();

    var headers = {
        'uid': "uid",
        'client': "client",
        'access-token': "access-token"
      };

    $http.delete(apiPrefix + '/auth/sign_out?access_token=' + $rootScope.sessionToken, {}, headers)
      .success(function(data) {
        console.log('LOGOUT: time taken for request - ' + (new Date().getTime() - start) + 'ms');
        deferred.resolve(data);
      })
      .error(function(data) {
        $location.path('/login');
        deferred.reject(data);
      });

    return deferred.promise;
  };

  return service;
}]);
