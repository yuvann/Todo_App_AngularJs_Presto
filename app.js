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
    application.todos = JSON.parse(localStorage.getItem("todos"))
}

window.showScreen = function (callBack, data) {
    window.callBack = callBack;
    handleScreenAction(data);
};
