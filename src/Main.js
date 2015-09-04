// module Main

exports.updateProgress = function(n) {
    return function(h) {
        return function() {
            var progress = document.getElementById("progress");
            progress.style.width = ((n / h) * 100) + '%';
        };
    };
};
