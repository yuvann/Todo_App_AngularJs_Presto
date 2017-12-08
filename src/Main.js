exports.parse = function(str) {
    return { "content":( JSON.parse(str) || [] )}
};
exports.logData = function(str) {
    console.log(str);
};
exports.strToJson = function(str1) {
	return function (str2){
		return { "data" : str1 , "date":str2 , "show" : true}
	}
};
exports.stringify = function(arrJson) {
    return JSON.stringify(arrJson) 
};