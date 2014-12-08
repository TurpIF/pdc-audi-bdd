'use strict';

// Declare app level module which depends on views, and components
angular.module('myApp', [
    'ngResource',
    'highcharts-ng',
    'ui.bootstrap'
])
.controller('MyCtrl', ['$scope', '$http',
    function($scope, $http) {
  $scope.cur_audit = undefined;
  $scope.cur_instance = undefined;
  $scope.cur_server = undefined;
  $scope.cur_table = undefined;
  $scope.cur_column = undefined;

  $scope.audits = [];
  $scope.instances = [];
  $scope.servers = [];
  $scope.tables = [];
  $scope.columns = [];

  // $scope.audits = Audit.query();
  $http.get('/api/audits/')
  .success(function(v) {
    $scope.audits = v.results;
  });
  // $scope.audits = [{date: "01/01/1970", name: "coucou"}, {date: '02/02/1994', name: "nomarallongequifaitvraimenttropchier"}];

  $scope.$watch('cur_audit', function(newV, oldV) {
    // Empty the instances and unselect current instance
    $scope.instances = [];
    $scope.cur_instance = undefined;

    // Update the instances list
    if (newV !== undefined) {
      $http.get('/api/audits/' + newV.id + '/instances/')
      .success(function(v) {
        $scope.instances = v.results;
      });
    }
  });

  $scope.$watch('cur_instance', function(newV, oldV) {
    // Empty the servers/tables and unselect current server/table
    $scope.tables = [];
    $scope.servers = [];
    $scope.cur_table = undefined;
    $scope.cur_server = undefined;

    // Update the tables/servers list
    if (newV !== undefined) {
      $http.get('/api/audits/' + $scope.cur_audit.id + '/instances/' + $scope.cur_instance.id + '/servers/')
      .success(function(v) {
        $scope.servers = v.results;
      });
      $http.get('/api/audits/' + $scope.cur_audit.id + '/instances/' + $scope.cur_instance.id + '/tables/')
      .success(function(v) {
        $scope.tables = v.results;
      });
    }
  });

  $scope.$watch('cur_table', function(newV, oldV) {
    // Empty the columns and unselect current column
    $scope.columns = [];
    $scope.cur_column = undefined;

    // Update the columns list
    if (newV !== undefined) {
      $http.get('/api/audits/' + $scope.cur_audit.id + '/instances/' + $scope.cur_instance.id + '/tables/' + $scope.cur_table.id + '/columns/')
      .success(function(v) {
        $scope.columns = v.results;
      });
    }
  });

  $scope.selectAudit = function(sel) {
    $scope.cur_audit = sel;
  };

  $scope.selectInstance = function(sel) {
    $scope.cur_instance = sel;
  };

  $scope.selectServer = function(sel) {
    $scope.cur_server = sel;
  };

  $scope.selectTable = function(sel) {
    $scope.cur_table = sel;
  };

  $scope.selectColumn = function(sel) {
    $scope.cur_column = sel;
  };
}]);
