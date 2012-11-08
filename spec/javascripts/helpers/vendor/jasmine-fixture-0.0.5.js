/* jasmine-fixture Makes injecting HTML snippets into the DOM easy & clean!
 *  site: https://github.com/searls/jasmine-fixture   */
(function($){
  var originalJasmineFixture = window.jasmineFixture,
      defaultConfiguration = {
        el:'div',
        cssClass:'',
        id:'',
        text: '',
        html: '',
        defaultAttribute: 'class',
        attrs: {}
      };

  window.jasmineFixture = function($) {
    var isReady = false,
        rootId  = 'specContainer',
        defaults = $.extend({},defaultConfiguration);

    $.jasmine = {
      inject: function(arg,context) {
        if(isReady !== true) init();
        var parent = context ? context : $('#'+rootId),
            $toInject;
        if(itLooksLikeHtml(arg)) {
          $toInject = $(arg);
        } else {
          var config = $.extend({},defaults,arg,{ userString: arg });
          $toInject = $('<'+config.el+'></'+config.el+'>');
          applyAttributes($toInject,config);
          injectContents($toInject,config);
        }
        return $toInject.appendTo(parent);
      },
      configure: function(config) {
        $.extend(defaults,config);
      },
      restoreDefaults: function(){
        defaults = $.extend({},defaultConfiguration);
      },
      noConflict: function() {
        window.jasmineFixture = originalJasmineFixture;
        return this;
      }
    };

    $.fn.inject = function(html){
      return $.jasmine.inject(html,$(this));
    };

    var applyAttributes = function($html,config) {
      var attrs = $.extend({},{
        id: config.id,
        'class': config['class'] || config.cssClass
      }, config.attrs);
      if(isString(config.userString)) {
        attrs[config.defaultAttribute] = config.userString;
      }
      for(var key in attrs) {
        if(attrs[key]) {
          $html.attr(key,attrs[key]);
        }
      }
    };

    var injectContents = function($el,config){
      if(config.text && config.html) {
        throw "Error: because they conflict, you may only configure inject() to set `html` or `text`, not both! \n\nHTML was: "+config.html+" \n\n Text was: "+config.text
      } else if(config.text) {
        $el.text(config.text);
      } else if(config.html) {
        $el.html(config.html);
      }
    }

    var itLooksLikeHtml = function(arg) {
      return isString(arg) && arg.indexOf('<') !== -1
    };

    var isString = function(arg) {
      return arg && arg.constructor === String;
    };

    var init = function() {
      $('body').append('<div id="'+rootId+'"></div>');
      isReady = true;
    };

    var tidyUp = function() {
      $('#'+rootId).remove();
      isReady = false;
    };

    $(function(jQuery){
      init();
    });
    afterEach(function(){
      tidyUp();
    });

    return $.jasmine;
  };

  if(jQuery) {
    var jasmineFixture = window.jasmineFixture(jQuery);
    window.inject = window.inject || jasmineFixture.inject;
  }
})(jQuery);