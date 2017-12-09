
handleScreenAction = (state) => {
  switch (state.tag) {
    case "InitScreenInit":break;
    case "InitScreenAddTodo":
      update(state.contents);
      break;
    case "InitScreenRemoveTodo":
      update(state.contents); 
      break;
    case "InitScreenUpdateTodo":
      update(state.contents);
      break;
    default: console.log("Invalid Tag Passed", state.tag);

  }
}

update = (val) => {
  if(val==="FAILURE") {
    alert("Server Doesn't respond ; Try to start server using 'npm start' ;")
  }
 var app = angular.element(document.getElementById('app')).scope()
 app.todos = JSON.parse(localStorage.getItem('todos') || "[]");
 app.count = JSON.parse(localStorage.getItem('todos') || "[]").length;
 app.$applyAsync()

}

window.showScreen = function (callBack, data) {
    window.callBack = callBack;
    handleScreenAction(data);
};
