const JBridge = {};
JBridge.getFromSharedPrefs = function(key) {
    return localStorage.getItem(key) 
};

JBridge.setInSharedPrefs = function(key,value) {
    localStorage.setItem(key,value)
};
 