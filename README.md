①新規作成
```ruby
rails new TaskApp
cd TaskApp
```
②rails g scaffold Task body:string done:boolean

③Gemfileを編集
```ruby
#以下を追加
gem 'bootstrap-sass'
gem 'angularjs-rails'
gem 'angular-ui-bootstrap-rails'
以下をコメント
#gem 'turbolinks'
以下をコメントアウト
#gem 'therubyracer',  platforms: :ruby
```

④bundle intall

⑤TaskApp/app/assets/javascripts/application.jsを以下のように編集
```ruby
//= require jquery
//= require jquery_ujs
//= require angular
//= require angular-route
//= require angular-resource
//= require angular-ui-bootstrap-tpls
//= require ./angular/app
//= require_tree ./angular
```

⑥TaskApp/app/assets/stylesheetsの下に「costom.css.scss」ファイルを新規作成
以下を追加
```ruby
@import "bootstrap";
```

⑦TaskApp/config/routes.rbを編集。
```ruby
  resources :tasks
  root :to => "layouts#index"
```

⑧コントローラー作成(viewを表示するためのコントローラー)
rails g controller layouts index

⑨TaskApp/app/controllers/tasks_controller.rbを編集。以下を追加
render "layouts/application"

⑩TaskApp/app/assetsの下にtemplatesフォルダを新規作成。
　さらにこの下にtasksフォルダを新規作成。
　このフォルダの下にindex.htmlを作成。

⑪TaskApp/app/assets/templates/tasks/index.htmlを以下のように編集
```ruby
<h1>Todo list</h1>
<div ng-controller="TasksIndexCtrl">
	<p>
		Finished Task: {{getDoneCount()}} / {{tasks.length}}
		<button ng-click="deleteDone()">
			Delete Finished
		</button>
	</p>
	<ul>
		<li ng-repeat="task in tasks">
			<input type="checkbox" ng-model="task.done">
			<span class="done-{{task.done}}">{{task.body}}</span>
			<a href ng-click="tasks.splice($index,1)">[x]</a>
		</li>
	</ul>
	<form ng-submit="addNew()">
		<input type="text" ng-model="newTaskBody">
		<input type="submit" value="add">
	</form>
</div>
```

⑫TaskApp/app/assets/javascriptsの下にapp.js.erbを新規作成。
　以下のコードを書く
 ```ruby
 var app = angular.module("Tasks", ['ngRoute','ngResource']);

app.config(function($routeProvider) {
  $routeProvider
    .when("/dummy", { templateUrl: "<%= asset_path('tasks/dummy.html') %>", controller: "TasksDummyCtrl" })
    .otherwise({ templateUrl: "<%= asset_path('tasks/index.html') %>", controller: "TasksIndexCtrl" })
});
 ```
 
 ⑬TaskApp/app/assets/javascriptsの下にangularフォルダを作成
 　さらにこの下にcontrollersフォルダを作成
 　このフォルダの下にTasksIndexCtrl.jsを新規作成。
 
 ⑭TaskApp/app/assets/javascripts/controllers/TasksIndexCtrl.jsに以下のコードを書く
 ```ruby
 app.controller("TasksIndexCtrl", function($scope,$resource) {
  var rtn = $resource('/tasks.json');
  $scope.tasks = rtn.query();
  
  
  $scope.addNew = function() {
        $scope.tasks.push({"body":$scope.newTaskBody,"done":false});
        $scope.newTaskBody = '';
    }
    $scope.getDoneCount = function() {
        var count = 0;
        angular.forEach($scope.tasks, function(task) {
            count += task.done ? 1 : 0;
        });
        return count;
    }
    $scope.deleteDone = function() {
        var oldTasks = $scope.tasks;
        $scope.tasks = [];
        angular.forEach(oldTasks, function(task) {
            if (!task.done) $scope.tasks.push(task);
        });
    } 
});
 ```
 
 ⑮TaskApp/app/controllers/tasks_controller.rbのindexアクションの所を以下のように編集
 
 ```ruby
  respond_to :json

  def index
    @tasks = Task.all
    respond_with @tasks  
  end
 ```
 ⑯TaskApp/app/views/layouts/application.html.erbを編集
 ```ruby
 <!DOCTYPE html>
<html ng-app="Tasks">
<head>
  <title>TaskApp</title>
  <%= stylesheet_link_tag    'application', media: 'all' %>
  <%= javascript_include_tag 'application' %>
  <%= csrf_meta_tags %>
</head>
<body>
<div ng-view></div> #ここに結果を出す
</body>
</html>
 ```
 
 ⑰TaskApp/app/views/tasks/index.htmlを削除
 
 ⑱http://localhost:3000にアクセス




