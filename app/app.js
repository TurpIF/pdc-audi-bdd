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
    else {
      $http.get('/api/audits/')
      .success(function(v) {
        $scope.audits = v.results;
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
    var tailleSGASerie = {name: 'Taille de la SGA (Go)', data: []};

    var ratioVuesSerie = {name: 'Vues / Tables (%)', data: []};
    var ratioIndexSerie = {name: 'Index / Tables (%)', data: []};
    var nbAttributsSerie = {name: 'Attributs / Tables', data: []};
    var nbTablespacesSerie = {name: 'Nb. tablespaces', data: []};
    var nbSegmentsSerie = {name: 'Nb. segments', data: []};
    var nbExtentsSerie = {name: 'Nb. extents', data: []};
    var nbBlocsSerie = {name: 'Nb. blocs (K)', data: []};
    var tailleBlocsSerie = {name: 'Taille des blocs', data: []};

    var nbTablesSerie = {name: 'Nb. tables', data: []};
    var ratioPKSerie = {name: 'Clés primaires / Tables (%)', data: []};
    var ratioFKSerie = {name: 'Clés étrangères / Tables (%)', data: []};
    var avgNbEntriesSerie = {name: 'Nb. moyen d\'entrées', data: []};
    var avgNbColumnSeries = {name: 'Nb. moyen de colonnes', data: []};

    var nbValeursDiffSeries = {name: 'Taux de valeurs diff. (%)', data: []};
    var nbValNullSeries = {name: 'Taux de valeurs NULL (%)', data: []};
    var largeurChampsSeries = {name: 'Largeur moyen des champs', data: []};

    // TODO répartition des types
    // TODO répartition des types non normalisés

    var v = function(val) {
        if (isNaN(val))
            return undefined;
        return val;
    }

    for (var i in $scope.audits) {
      var audit = $scope.audits[i];
      names.push(audit.name);
      console.log(audit);
      ctrlfilesSerie.data.push(v(parseInt(audit.nbCtrlfiles)));
      logfilesSerie.data.push(v(parseInt(audit.nbLogfiles)));
      datafilesSerie.data.push(v(parseInt(audit.nbDatafiles)));
      tailleSGASerie.data.push(v(((audit.tailleSGA / 1024.0 / 1024.0 * 10) | 0) / 10));

      ratioVuesSerie.data.push(v(parseInt(audit.ratioVues)));
      ratioIndexSerie.data.push(v(parseInt(audit.ratioIndex)));
      nbAttributsSerie.data.push(v(parseInt(audit.nbAttributs)));
      nbTablespacesSerie.data.push(v(parseInt(audit.nbTablespaces)));
      nbSegmentsSerie.data.push(v(parseInt(audit.nbSegments)));
      nbExtentsSerie.data.push(v(parseInt(audit.nbExtents)));
      nbBlocsSerie.data.push(v(parseInt(audit.nbBlocs)));
      tailleBlocsSerie.data.push(v(((audit.tailleBlocs * 10) | 0) / 10));

      nbTablesSerie.data.push(v(parseInt(audit.nbTable)));
      ratioPKSerie.data.push(v(((audit.ratioPK * 10) | 0) / 10));
      ratioFKSerie.data.push(v(((audit.ratioFK * 10) | 0) / 10));
      avgNbEntriesSerie.data.push(v(parseInt(audit.nbEntrees)));
      avgNbColumnSeries.data.push(v(parseInt(audit.nbColonne)));

      nbValeursDiffSeries.data.push(v(((audit.ratioValeursNULL * 10) | 0) / 10));
      nbValNullSeries.data.push(v(((audit.ratioValeursDifferentes * 10) | 0) / 10));
      largeurChampsSeries.data.push(v(parseInt(audit.largeurColonne)));
    }

    var physicalSeries = [
      ctrlfilesSerie,
      logfilesSerie,
      datafilesSerie,
      tailleSGASerie
    ];

    var logicalSeries = [
      ratioVuesSerie,
      ratioIndexSerie,
      nbAttributsSerie,
      nbTablespacesSerie,
      nbSegmentsSerie,
      nbExtentsSerie,
      nbBlocsSerie,
      tailleBlocsSerie
    ];

    var schemeQualitySeries = [
      nbTablesSerie,
      ratioPKSerie,
      ratioFKSerie,
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

  $scope.$watch('instances', function(newV) {
    var names = [];
    var ctrlfilesSerie = {name: 'Nb. Ctrl. Files', data: []};
    var logfilesSerie = {name: 'Nb. Log Files', data: []};
    var datafilesSerie = {name: 'Nb. Data Files', data: []};
    var tailleSGASerie = {name: 'Taille de la SGA (Go)', data: []};

    var ratioVuesSerie = {name: 'Vues / Tables (%)', data: []};
    var ratioIndexSerie = {name: 'Index / Tables (%)', data: []};
    var nbAttributsSerie = {name: 'Attributs / Tables', data: []};
    var nbTablespacesSerie = {name: 'Nb. tablespaces', data: []};
    var nbSegmentsSerie = {name: 'Nb. segments', data: []};
    var nbExtentsSerie = {name: 'Nb. extents', data: []};
    var nbBlocsSerie = {name: 'Nb. blocs (K)', data: []};
    var tailleBlocsSerie = {name: 'Taille des blocs', data: []};

    var nbTablesSerie = {name: 'Nb. tables', data: []};
    var ratioPKSerie = {name: 'Clés primaires / Tables (%)', data: []};
    var ratioFKSerie = {name: 'Clés étrangères / Tables (%)', data: []};
    var avgNbEntriesSerie = {name: 'Nb. moyen d\'entrées', data: []};
    var avgNbColumnSeries = {name: 'Nb. moyen de colonnes', data: []};

    var nbValeursDiffSeries = {name: 'Taux de valeurs diff. (%)', data: []};
    var nbValNullSeries = {name: 'Taux de valeurs NULL (%)', data: []};
    var largeurChampsSeries = {name: 'Largeur moyen des champs', data: []};

    var v = function(val) {
        if (isNaN(val))
            return undefined;
        return val;
    }

    for (var i in $scope.instances) {
      var e = $scope.instances[i];
      names.push('Instance n°' + e.id);
      console.log(e);
      ctrlfilesSerie.data.push(v(parseInt(e.nbCtrlfiles)));
      logfilesSerie.data.push(v(parseInt(e.nbLogfiles)));
      datafilesSerie.data.push(v(parseInt(e.nbDatafiles)));
      tailleSGASerie.data.push(v(((e.tailleSGA / 1024.0 / 1024.0 * 10) | 0) / 10));

      ratioVuesSerie.data.push(v(parseInt(e.ratioVues)));
      ratioIndexSerie.data.push(v(parseInt(e.ratioIndex)));
      nbAttributsSerie.data.push(v(parseInt(e.nbAttributs)));
      nbTablespacesSerie.data.push(v(parseInt(e.nbTablespaces)));
      nbSegmentsSerie.data.push(v(parseInt(e.nbSegments)));
      nbExtentsSerie.data.push(v(parseInt(e.nbExtents)));
      nbBlocsSerie.data.push(v(parseInt(e.nbBlocs)));
      tailleBlocsSerie.data.push(v(((e.tailleBlocs * 10) | 0) / 10));

      nbTablesSerie.data.push(v(parseInt(e.nbTable)));
      ratioPKSerie.data.push(v(((e.ratioPK * 10) | 0) / 10));
      ratioFKSerie.data.push(v(((e.ratioFK * 10) | 0) / 10));
      avgNbEntriesSerie.data.push(v(parseInt(e.nbEntrees)));
      avgNbColumnSeries.data.push(v(parseInt(e.nbColonne)));

      nbValeursDiffSeries.data.push(v(((e.ratioValeursNULL * 10) | 0) / 10));
      nbValNullSeries.data.push(v(((e.ratioValeursDifferentes * 10) | 0) / 10));
      largeurChampsSeries.data.push(v(parseInt(e.largeurColonne)));
    }

    var physicalSeries = [
      ctrlfilesSerie,
      logfilesSerie,
      datafilesSerie,
      tailleSGASerie
    ];

    var logicalSeries = [
      ratioVuesSerie,
      ratioIndexSerie,
      nbAttributsSerie,
      nbTablespacesSerie,
      nbSegmentsSerie,
      nbExtentsSerie,
      nbBlocsSerie,
      tailleBlocsSerie
    ];

    var schemeQualitySeries = [
      nbTablesSerie,
      ratioPKSerie,
      ratioFKSerie,
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

  $scope.$watch('tables', function(newV) {
    var names = [];
    var nbIndexSerie = {name: 'Nb. index', data: []};
    var nbAttributsSerie = {name: 'Nb. attributs', data: []};
    var nbPKSerie = {name: 'Nb. clés primaires', data: []};
    var nbFKSerie = {name: 'Nb. clés étrangères', data: []};
    var nbEntriesSerie = {name: 'Nb. d\'entrées', data: []};
    var nbColumnSeries = {name: 'Nb. colonnes', data: []};

    var nbValeursDiffSeries = {name: 'Taux de valeurs diff. (%)', data: []};
    var nbValNullSeries = {name: 'Taux de valeurs NULL (%)', data: []};
    var largeurChampsSeries = {name: 'Largeur moyen des champs', data: []};

    var v = function(val) {
        if (isNaN(val))
            return undefined;
        return val;
    }

    for (var i in $scope.tables) {
      if (i > 100) break;
      var e = $scope.tables[i];
      names.push(e.name);
      nbIndexSerie.data.push(v(parseInt(e.nbIndex)));
      nbAttributsSerie.data.push(v(parseInt(e.nbAttributs)));

      nbPKSerie.data.push(v(parseInt(e.nbPK)));
      nbFKSerie.data.push(v(parseInt(e.nbFK)));
      nbEntriesSerie.data.push(v(parseInt(e.nbEntrees)));
      nbColumnSeries.data.push(v(parseInt(e.nbColonne)));

      nbValeursDiffSeries.data.push(v(((e.ratioValeursNULL * 10) | 0) / 10));
      nbValNullSeries.data.push(v(((e.ratioValeursDifferentes * 10) | 0) / 10));
      largeurChampsSeries.data.push(v(parseInt(e.largeurColonne)));
    }

    var physicalSeries = [
    ];

    var logicalSeries = [
      nbIndexSerie,
      nbAttributsSerie,
    ];

    var schemeQualitySeries = [
      nbPKSerie,
      nbFKSerie,
      nbEntriesSerie,
      nbColumnSeries
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

  $scope.$watch('columns', function(newV) {
    var names = [];
    var nbValeursDiffSeries = {name: 'Taux de valeurs diff. (%)', data: []};
    var nbValNullSeries = {name: 'Taux de valeurs NULL (%)', data: []};
    var largeurChampsSeries = {name: 'Largeur des champs', data: []};

    var v = function(val) {
        if (isNaN(val))
            return undefined;
        return val;
    }

    for (var i in $scope.tables) {
      if (i > 100) break;
      var e = $scope.tables[i];
      names.push(e.name);

      nbValeursDiffSeries.data.push(v(((e.ratioValeursNULL * 10) | 0) / 10));
      nbValNullSeries.data.push(v(((e.ratioValeursDifferentes * 10) | 0) / 10));
      largeurChampsSeries.data.push(v(parseInt(e.largeurColonne)));
    }

    var physicalSeries = [
    ];

    var logicalSeries = [
    ];

    var schemeQualitySeries = [
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
