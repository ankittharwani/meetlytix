'use strict';

app.controller('DataboxesCtrl', [
    '$rootScope', '$scope', '$http', function($rootScope, $scope, $http) {
        $scope.RTRSVPTotal = {};
        $scope.BTRSVPResponse = {};
        $scope.BTRSVPPercentage = 0;
        $scope.BTTopicCount = {};
        $scope.BTTopicTop = [];

        $scope.getRTRSVPTotal = function(){
          $http.get('http://api.meetlytix.com:8080/getTotalRSVP')
            .success(function(data) {
              $scope.RTRSVPTotal = data.rows[0].count;
              //console.log($scope.RTRSVPTotal);
            });
        };
        $scope.getRTRSVPTotal();
        setInterval($scope.getRTRSVPTotal, 3000);

        $scope.getBTRSVPResponse = function(){
          $http.get('http://api.meetlytix.com:8080/getResponse')
            .success(function(data) {
              $scope.BTRSVPResponse = data.rows;
              $scope.BTRSVPPercentage = Math.floor((data.rows[0].count / (data.rows[0].count + data.rows[1].count)) * 100);
              console.log($scope.BTRSVPPercentage);
            });
        };
        $scope.getBTRSVPResponse();
        //setInterval($scope.getData, 3000);

        $scope.getBTTopicCount = function(){
          $http.get('http://api.meetlytix.com:8080/getTopics')
            .success(function(data) {
              $scope.BTTopicCount = data;
              for(i=0;i<5;i++)
              {
                var topic = {};
                topic['group_topics'] = $scope.BTTopicCount.rows[i].group_topics;
                topic['count'] = $scope.BTTopicCount.rows[i].count;
                $scope.BTTopicTop.push(topic);
              }
            });
        };
        $scope.getBTTopicCount();

        var i = 5;

        $scope.getBTTopicTop = function(){
          if (i >= $scope.BTTopicCount.rows.length)
          {
            i = 0;
          }
          $scope.BTTopicTop.splice(0,1);
          var topic = {};
          topic['group_topics'] = $scope.BTTopicCount.rows[i].group_topics;
          topic['count'] = $scope.BTTopicCount.rows[i].count;
          $scope.BTTopicTop.push(topic);
          i++;
          //console.log(i,$scope.BTTopicTop);
        };

        setInterval($scope.getBTTopicTop, 2000);


    }
]);
