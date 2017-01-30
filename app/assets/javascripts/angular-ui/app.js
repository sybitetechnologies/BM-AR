/* jshint unused:false */

var bankingApp = angular.module('bankingApp', [
  'ngRoute',
  'ngAnimate',
  'ngCookies',
  'ipCookie',
  'ngFlash',
  'ng-token-auth'
]);

bankingApp.config(['$httpProvider', function($httpProvider) {
  $httpProvider.interceptors.push('customInterceptor');
}]);