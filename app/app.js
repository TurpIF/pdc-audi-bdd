'use strict';

// Declare app level module which depends on views, and components
angular.module('myApp', [
    'ngResource',
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

  $scope.$watch('audits', function(newV) {
    var names = [];
    var ctrlfilesSerie = {name: 'Nb. Ctrl. Files', data: []};
    var logfilesSerie = {name: 'Nb. Log Files', data: []};
    var datafilesSerie = {name: 'Nb. Data Files', data: []};
    var tailleSGASerie = {name: 'Taille de la SGA (Mo)', data: []};
    var nbVuesSerie = {name: 'Vues / Tables (%)', data: []};
    var nbIndexSerie = {name: 'Index / Tables (%)', data: []};
    var nbAttributsSerie = {name: 'Attributs / Tables', data: []};
    var nbTablespacesSerie = {name: 'Nb. tablespaces', data: []};
    var nbSegmentsSerie = {name: 'Nb. segments', data: []};
    var nbExtentsSerie = {name: 'Nb. extents', data: []};
    var nbBlocsSerie = {name: 'Nb. blocs', data: []};
    var tailleBlocsSerie = {name: 'Taille des blocs', data: []};
    var nbTablesSerie = {name: 'Nb. tables', data: []};
    var nbPKSerie = {name: 'Clés primaires / Tables (%)', data: []};
    var nbFKSerie = {name: 'Clés étrangères / Tables (%)', data: []};
    var avgNbEntriesSerie = {name: 'Nb. moyen d\'entrées', data: []};
    var avgNbColumnSeries = {name: 'Nb. moyen de colonnes', data: []};
    var nbValeursDiffSeries = {name: 'Taux de valeurs diff. (%)', data: []};
    var nbValNullSeries = {name: 'Taux de valeurs NULL (%)', data: []};
    var largeurChampsSeries = {name: 'Largeur moyen des champs', data: []};

    // TODO répartition des types
    // TODO répartition des types non normalisés

    for (var i in $scope.audits) {
      var audit = $scope.audits[i];
      names.push(audit.name);
      console.log(audit);
      ctrlfilesSerie.data.push(audit.nbCtrlfiles);
      logfilesSerie.data.push(audit.nbLogfiles);
      datafilesSerie.data.push(audit.nbDatafiles);
      tailleSGASerie.data.push(((audit.tailleSGA / 1024.0 * 10) | 0) / 10);
      nbTablespacesSerie.data.push(audit.nbTablespaces);
      nbSegmentsSerie.data.push(audit.nbSegments);
      nbExtentsSerie.data.push(audit.nbExtents);
      nbBlocsSerie.data.push(audit.nbBlocs);
      // nbVuesSerie.data.push(audit.nbVues);
      tailleBlocsSerie.data.push(((audit.tailleBlocs / 1024.0 * 10) | 0) / 10);
    }

    var physicalSeries = [
      ctrlfilesSerie,
      logfilesSerie,
      datafilesSerie,
      tailleSGASerie
    ];

    var logicalSeries = [
      nbVuesSerie,
      nbIndexSerie,
      nbAttributsSerie,
      nbTablespacesSerie,
      nbSegmentsSerie,
      nbExtentsSerie,
      nbBlocsSerie,
      tailleBlocsSerie
    ];

    var schemeQualitySeries = [
      nbTablesSerie,
      nbPKSerie,
      nbFKSerie,
      avgNbEntriesSerie,
      avgNbColumnSeries
    ];

    var dataQualitySeries = [
      nbValeursDiffSeries,
      nbValNullSeries,
      largeurChampsSeries
    ];

    $('#chart-physical-structure').highcharts({
        chart: { type: 'column' },
        title: { text: 'Structure physique', x: -20 },
        legend: {
            layout: 'vertical',
            align: 'right',
            verticalAlign: 'middle',
            borderWidth: 0
        },
        xAxis: { categories: names },
        // yAxis: { title: { text: 'Nombre de fichiers' }, },
        series: physicalSeries
    });

    $('#chart-logical-structure').highcharts({
        chart: { type: 'column' },
        title: { text: 'Structure logique', x: -20 },
        legend: {
            layout: 'vertical',
            align: 'right',
            verticalAlign: 'middle',
            borderWidth: 0
        },
        xAxis: { categories: names },
        // yAxis: { title: { text: 'Nombre de fichiers' }, },
        series: logicalSeries
    });

    $('#chart-scheme-quality').highcharts({
        chart: { type: 'column' },
        title: { text: 'Qualité des schémas', x: -20 },
        legend: {
            layout: 'vertical',
            align: 'right',
            verticalAlign: 'middle',
            borderWidth: 0
        },
        xAxis: { categories: names },
        // yAxis: { title: { text: 'Nombre de fichiers' }, },
        series: schemeQualitySeries
    });

    $('#chart-data-quality').highcharts({
        chart: { type: 'column' },
        title: { text: 'Qualité des données', x: -20 },
        legend: {
            layout: 'vertical',
            align: 'right',
            verticalAlign: 'middle',
            borderWidth: 0
        },
        xAxis: { categories: names },
        // yAxis: { title: { text: 'Nombre de fichiers' }, },
        series: dataQualitySeries
    });
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
