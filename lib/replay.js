(function() {
  (function(root, ns, factory) {
    if (typeof exports === 'object' && typeof module === 'object') {
      return module.exports = factory();
    } else if (typeof define === 'function' && define.amd) {
      return define(factory);
    } else {
      return root[ns] = factory();
    }
  })((typeof window === 'object' ? window : this), 'ReplayJS', function() {
    var ReplayJS;
    return new (ReplayJS = (function() {
      function ReplayJS() {}

      ReplayJS.prototype.num = 0;

      ReplayJS.prototype.recordings = {};

      ReplayJS.prototype.recorder = function() {
        var fn;
        this.recordings[this.num] = [];
        fn = (function(_this) {
          return function() {
            return _this.recordings[arguments.callee.num].push(arguments);
          };
        })(this);
        fn.num = this.num++;
        fn.replay = this;
        return fn;
      };

      ReplayJS.prototype.play = function(recorder, targetFn, targetScope) {
        var args, arr;
        if (targetScope == null) {
          targetScope = null;
        }
        arr = this.recordings[recorder != null ? recorder.num : void 0];
        if (typeof arr === 'undefined') {
          throw {
            message: 'Given recorder unknown'
          };
        }
        if (recorder.replay !== this) {
          throw {
            message: 'Given recorder from different ReplayJS'
          };
        }
        if (typeof targetFn !== 'function') {
          throw {
            message: 'Given target function is not a function'
          };
        }
        while ((args = arr.shift())) {
          if (targetFn != null) {
            targetFn.apply(targetScope, args);
          }
        }
      };

      return ReplayJS;

    })());
  });

}).call(this);

//# sourceMappingURL=replay.js.map
