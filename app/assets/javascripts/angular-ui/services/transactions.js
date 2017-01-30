'use strict';

bankingApp.factory('transactionService', ['$location', '$http', '$q', '$cookieStore', function($location, $http, $q, $cookieStore) {

  var service = {};

  /**
   * @ngdoc method
   * @name transactionService#deposit
   *
   * @description
   * Returns the promise of deposit amount
   *
   * @returns {Object} Promise of deposit amount
   */
  service.deposit = function(data) {
    var deferred = $q.defer(),
      start = new Date().getTime();

    $http.post('api/deposit', data)
      .success(function(responseJson) {
        console.log('Deposti: time taken for request - ' + (new Date().getTime() - start) + 'ms');
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
   * @name transactionService#otherAccount
   *
   * @description
   * Returns the promise of otherAccount deposit amount
   *
   * @returns {Object} Promise of otherAccount deposit amount
   */
  service.otherAccount = function(data) {
    var deferred = $q.defer(),
      start = new Date().getTime();

    $http.post('api/transfer', data)
      .success(function(responseJson) {
        console.log('Transfer: time taken for request - ' + (new Date().getTime() - start) + 'ms');
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
   * @name transactionService#withdraw
   *
   * @description
   * Returns the promise of withdraw deposited amount
   *
   * @returns {Object} Promise of withdraw deposited amount
   */
  service.withdraw = function(data) {
    var deferred = $q.defer(),
      start = new Date().getTime();

    $http.post('api/withdraw', data)
      .success(function(responseJson) {
        console.log('withdraw: time taken for request - ' + (new Date().getTime() - start) + 'ms');
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
   * @name transactionService#statement
   *
   * @description
   * Returns the promise of statement deposited amount
   *
   * @returns {Object} Promise of statement deposited amount
   */
  service.statement = function(data) {
    var deferred = $q.defer(),
      start = new Date().getTime();

    $http.get('/api/transactions', data)
      .success(function(responseJson) {
        console.log('withdraw: time taken for request - ' + (new Date().getTime() - start) + 'ms');
        deferred.resolve(responseJson);
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
