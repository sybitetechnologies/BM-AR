bankingApp.factory('customInterceptor', ['$q', 'ipCookie', '$location',  function($q, ipCookie, $location) {
  return {
    request: function(config) {
      config.headers = config.headers || {};
      var authHeaders = ipCookie('auth_headers');
      if (authHeaders) {
        config.headers['access-token'] = authHeaders['access-token'];
        config.headers['client'] = authHeaders['client'];
        config.headers['uid'] = authHeaders['uid'];
        config.headers['expiry'] = authHeaders['expiry'];
      }
      return config;
    },
    responseError: function(response) {
      if (response.status === 401) {
        window.location = '/home';
        ipCookie.remove('access-token');
      }
      return $q.reject(response);
    }
  };
}])
