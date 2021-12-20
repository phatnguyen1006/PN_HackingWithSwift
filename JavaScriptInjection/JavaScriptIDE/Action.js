var Action = function () {};

Action.prototype = {
    run : (parameters) {
        parameters.completionFunction({"URL": document.URL, "title": document.title});
    },
    finallize: (parameters) {
        var customJavaScript = parameters["customJavaScript"];
        eval(customJavaScript);
    },
};


var ExtensionPreprocessingJS = new Action;
