'use strict';

/**
 * @ngdoc function
 */

bankingApp.controller('MainCtrl', ['$scope', '$auth', function($scope, $auth) {
  $scope.logout = function() {
    $auth.signOut()
      .then(function(resp) {
        window.location = '/home';
      })
      .catch(function(resp) {
        window.location = '/home';
      });
  };
}]);
