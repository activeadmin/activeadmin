import $ from "jquery";

import Rails from "@rails/ujs";

window.jQuery = $;

window.$ = $;

$.fn.serializeObject = function() {
  return this.serializeArray().reduce(((obj, item) => {
    obj[item.name] = item.value;
    return obj;
  }), {});
};

/*! jQuery UI - v1.14.0 - 2024-10-10
* https://jqueryui.com
* Includes: widget.js, position.js, data.js, disable-selection.js, focusable.js, form-reset-mixin.js, keycode.js, labels.js, scroll-parent.js, tabbable.js, unique-id.js, widgets/draggable.js, widgets/resizable.js, widgets/sortable.js, widgets/button.js, widgets/checkboxradio.js, widgets/controlgroup.js, widgets/datepicker.js, widgets/dialog.js, widgets/mouse.js, widgets/tabs.js
* Copyright OpenJS Foundation and other contributors; Licensed MIT */ (function(factory) {
  if (typeof define === "function" && define.amd) {
    define([ "jquery" ], factory);
  } else {
    factory(jQuery);
  }
})((function($) {
  $.ui = $.ui || {};
  $.ui.version = "1.14.0";
  /*!
 * jQuery UI Widget 1.14.0
 * https://jqueryui.com
 *
 * Copyright OpenJS Foundation and other contributors
 * Released under the MIT license.
 * https://jquery.org/license
 */  var widgetUuid = 0;
  var widgetHasOwnProperty = Array.prototype.hasOwnProperty;
  var widgetSlice = Array.prototype.slice;
  $.cleanData = function(orig) {
    return function(elems) {
      var events, elem, i;
      for (i = 0; (elem = elems[i]) != null; i++) {
        events = $._data(elem, "events");
        if (events && events.remove) {
          $(elem).triggerHandler("remove");
        }
      }
      orig(elems);
    };
  }($.cleanData);
  $.widget = function(name, base, prototype) {
    var existingConstructor, constructor, basePrototype;
    var proxiedPrototype = {};
    var namespace = name.split(".")[0];
    name = name.split(".")[1];
    var fullName = namespace + "-" + name;
    if (!prototype) {
      prototype = base;
      base = $.Widget;
    }
    if (Array.isArray(prototype)) {
      prototype = $.extend.apply(null, [ {} ].concat(prototype));
    }
    $.expr.pseudos[fullName.toLowerCase()] = function(elem) {
      return !!$.data(elem, fullName);
    };
    $[namespace] = $[namespace] || {};
    existingConstructor = $[namespace][name];
    constructor = $[namespace][name] = function(options, element) {
      if (!this || !this._createWidget) {
        return new constructor(options, element);
      }
      if (arguments.length) {
        this._createWidget(options, element);
      }
    };
    $.extend(constructor, existingConstructor, {
      version: prototype.version,
      _proto: $.extend({}, prototype),
      _childConstructors: []
    });
    basePrototype = new base;
    basePrototype.options = $.widget.extend({}, basePrototype.options);
    $.each(prototype, (function(prop, value) {
      if (typeof value !== "function") {
        proxiedPrototype[prop] = value;
        return;
      }
      proxiedPrototype[prop] = function() {
        function _super() {
          return base.prototype[prop].apply(this, arguments);
        }
        function _superApply(args) {
          return base.prototype[prop].apply(this, args);
        }
        return function() {
          var __super = this._super;
          var __superApply = this._superApply;
          var returnValue;
          this._super = _super;
          this._superApply = _superApply;
          returnValue = value.apply(this, arguments);
          this._super = __super;
          this._superApply = __superApply;
          return returnValue;
        };
      }();
    }));
    constructor.prototype = $.widget.extend(basePrototype, {
      widgetEventPrefix: existingConstructor ? basePrototype.widgetEventPrefix || name : name
    }, proxiedPrototype, {
      constructor: constructor,
      namespace: namespace,
      widgetName: name,
      widgetFullName: fullName
    });
    if (existingConstructor) {
      $.each(existingConstructor._childConstructors, (function(i, child) {
        var childPrototype = child.prototype;
        $.widget(childPrototype.namespace + "." + childPrototype.widgetName, constructor, child._proto);
      }));
      delete existingConstructor._childConstructors;
    } else {
      base._childConstructors.push(constructor);
    }
    $.widget.bridge(name, constructor);
    return constructor;
  };
  $.widget.extend = function(target) {
    var input = widgetSlice.call(arguments, 1);
    var inputIndex = 0;
    var inputLength = input.length;
    var key;
    var value;
    for (;inputIndex < inputLength; inputIndex++) {
      for (key in input[inputIndex]) {
        value = input[inputIndex][key];
        if (widgetHasOwnProperty.call(input[inputIndex], key) && value !== undefined) {
          if ($.isPlainObject(value)) {
            target[key] = $.isPlainObject(target[key]) ? $.widget.extend({}, target[key], value) : $.widget.extend({}, value);
          } else {
            target[key] = value;
          }
        }
      }
    }
    return target;
  };
  $.widget.bridge = function(name, object) {
    var fullName = object.prototype.widgetFullName || name;
    $.fn[name] = function(options) {
      var isMethodCall = typeof options === "string";
      var args = widgetSlice.call(arguments, 1);
      var returnValue = this;
      if (isMethodCall) {
        if (!this.length && options === "instance") {
          returnValue = undefined;
        } else {
          this.each((function() {
            var methodValue;
            var instance = $.data(this, fullName);
            if (options === "instance") {
              returnValue = instance;
              return false;
            }
            if (!instance) {
              return $.error("cannot call methods on " + name + " prior to initialization; " + "attempted to call method '" + options + "'");
            }
            if (typeof instance[options] !== "function" || options.charAt(0) === "_") {
              return $.error("no such method '" + options + "' for " + name + " widget instance");
            }
            methodValue = instance[options].apply(instance, args);
            if (methodValue !== instance && methodValue !== undefined) {
              returnValue = methodValue && methodValue.jquery ? returnValue.pushStack(methodValue.get()) : methodValue;
              return false;
            }
          }));
        }
      } else {
        if (args.length) {
          options = $.widget.extend.apply(null, [ options ].concat(args));
        }
        this.each((function() {
          var instance = $.data(this, fullName);
          if (instance) {
            instance.option(options || {});
            if (instance._init) {
              instance._init();
            }
          } else {
            $.data(this, fullName, new object(options, this));
          }
        }));
      }
      return returnValue;
    };
  };
  $.Widget = function() {};
  $.Widget._childConstructors = [];
  $.Widget.prototype = {
    widgetName: "widget",
    widgetEventPrefix: "",
    defaultElement: "<div>",
    options: {
      classes: {},
      disabled: false,
      create: null
    },
    _createWidget: function(options, element) {
      element = $(element || this.defaultElement || this)[0];
      this.element = $(element);
      this.uuid = widgetUuid++;
      this.eventNamespace = "." + this.widgetName + this.uuid;
      this.bindings = $();
      this.hoverable = $();
      this.focusable = $();
      this.classesElementLookup = {};
      if (element !== this) {
        $.data(element, this.widgetFullName, this);
        this._on(true, this.element, {
          remove: function(event) {
            if (event.target === element) {
              this.destroy();
            }
          }
        });
        this.document = $(element.style ? element.ownerDocument : element.document || element);
        this.window = $(this.document[0].defaultView || this.document[0].parentWindow);
      }
      this.options = $.widget.extend({}, this.options, this._getCreateOptions(), options);
      this._create();
      if (this.options.disabled) {
        this._setOptionDisabled(this.options.disabled);
      }
      this._trigger("create", null, this._getCreateEventData());
      this._init();
    },
    _getCreateOptions: function() {
      return {};
    },
    _getCreateEventData: $.noop,
    _create: $.noop,
    _init: $.noop,
    destroy: function() {
      var that = this;
      this._destroy();
      $.each(this.classesElementLookup, (function(key, value) {
        that._removeClass(value, key);
      }));
      this.element.off(this.eventNamespace).removeData(this.widgetFullName);
      this.widget().off(this.eventNamespace).removeAttr("aria-disabled");
      this.bindings.off(this.eventNamespace);
    },
    _destroy: $.noop,
    widget: function() {
      return this.element;
    },
    option: function(key, value) {
      var options = key;
      var parts;
      var curOption;
      var i;
      if (arguments.length === 0) {
        return $.widget.extend({}, this.options);
      }
      if (typeof key === "string") {
        options = {};
        parts = key.split(".");
        key = parts.shift();
        if (parts.length) {
          curOption = options[key] = $.widget.extend({}, this.options[key]);
          for (i = 0; i < parts.length - 1; i++) {
            curOption[parts[i]] = curOption[parts[i]] || {};
            curOption = curOption[parts[i]];
          }
          key = parts.pop();
          if (arguments.length === 1) {
            return curOption[key] === undefined ? null : curOption[key];
          }
          curOption[key] = value;
        } else {
          if (arguments.length === 1) {
            return this.options[key] === undefined ? null : this.options[key];
          }
          options[key] = value;
        }
      }
      this._setOptions(options);
      return this;
    },
    _setOptions: function(options) {
      var key;
      for (key in options) {
        this._setOption(key, options[key]);
      }
      return this;
    },
    _setOption: function(key, value) {
      if (key === "classes") {
        this._setOptionClasses(value);
      }
      this.options[key] = value;
      if (key === "disabled") {
        this._setOptionDisabled(value);
      }
      return this;
    },
    _setOptionClasses: function(value) {
      var classKey, elements, currentElements;
      for (classKey in value) {
        currentElements = this.classesElementLookup[classKey];
        if (value[classKey] === this.options.classes[classKey] || !currentElements || !currentElements.length) {
          continue;
        }
        elements = $(currentElements.get());
        this._removeClass(currentElements, classKey);
        elements.addClass(this._classes({
          element: elements,
          keys: classKey,
          classes: value,
          add: true
        }));
      }
    },
    _setOptionDisabled: function(value) {
      this._toggleClass(this.widget(), this.widgetFullName + "-disabled", null, !!value);
      if (value) {
        this._removeClass(this.hoverable, null, "ui-state-hover");
        this._removeClass(this.focusable, null, "ui-state-focus");
      }
    },
    enable: function() {
      return this._setOptions({
        disabled: false
      });
    },
    disable: function() {
      return this._setOptions({
        disabled: true
      });
    },
    _classes: function(options) {
      var full = [];
      var that = this;
      options = $.extend({
        element: this.element,
        classes: this.options.classes || {}
      }, options);
      function bindRemoveEvent() {
        var nodesToBind = [];
        options.element.each((function(_, element) {
          var isTracked = $.map(that.classesElementLookup, (function(elements) {
            return elements;
          })).some((function(elements) {
            return elements.is(element);
          }));
          if (!isTracked) {
            nodesToBind.push(element);
          }
        }));
        that._on($(nodesToBind), {
          remove: "_untrackClassesElement"
        });
      }
      function processClassString(classes, checkOption) {
        var current, i;
        for (i = 0; i < classes.length; i++) {
          current = that.classesElementLookup[classes[i]] || $();
          if (options.add) {
            bindRemoveEvent();
            current = $($.uniqueSort(current.get().concat(options.element.get())));
          } else {
            current = $(current.not(options.element).get());
          }
          that.classesElementLookup[classes[i]] = current;
          full.push(classes[i]);
          if (checkOption && options.classes[classes[i]]) {
            full.push(options.classes[classes[i]]);
          }
        }
      }
      if (options.keys) {
        processClassString(options.keys.match(/\S+/g) || [], true);
      }
      if (options.extra) {
        processClassString(options.extra.match(/\S+/g) || []);
      }
      return full.join(" ");
    },
    _untrackClassesElement: function(event) {
      var that = this;
      $.each(that.classesElementLookup, (function(key, value) {
        if ($.inArray(event.target, value) !== -1) {
          that.classesElementLookup[key] = $(value.not(event.target).get());
        }
      }));
      this._off($(event.target));
    },
    _removeClass: function(element, keys, extra) {
      return this._toggleClass(element, keys, extra, false);
    },
    _addClass: function(element, keys, extra) {
      return this._toggleClass(element, keys, extra, true);
    },
    _toggleClass: function(element, keys, extra, add) {
      add = typeof add === "boolean" ? add : extra;
      var shift = typeof element === "string" || element === null, options = {
        extra: shift ? keys : extra,
        keys: shift ? element : keys,
        element: shift ? this.element : element,
        add: add
      };
      options.element.toggleClass(this._classes(options), add);
      return this;
    },
    _on: function(suppressDisabledCheck, element, handlers) {
      var delegateElement;
      var instance = this;
      if (typeof suppressDisabledCheck !== "boolean") {
        handlers = element;
        element = suppressDisabledCheck;
        suppressDisabledCheck = false;
      }
      if (!handlers) {
        handlers = element;
        element = this.element;
        delegateElement = this.widget();
      } else {
        element = delegateElement = $(element);
        this.bindings = this.bindings.add(element);
      }
      $.each(handlers, (function(event, handler) {
        function handlerProxy() {
          if (!suppressDisabledCheck && (instance.options.disabled === true || $(this).hasClass("ui-state-disabled"))) {
            return;
          }
          return (typeof handler === "string" ? instance[handler] : handler).apply(instance, arguments);
        }
        if (typeof handler !== "string") {
          handlerProxy.guid = handler.guid = handler.guid || handlerProxy.guid || $.guid++;
        }
        var match = event.match(/^([\w:-]*)\s*(.*)$/);
        var eventName = match[1] + instance.eventNamespace;
        var selector = match[2];
        if (selector) {
          delegateElement.on(eventName, selector, handlerProxy);
        } else {
          element.on(eventName, handlerProxy);
        }
      }));
    },
    _off: function(element, eventName) {
      eventName = (eventName || "").split(" ").join(this.eventNamespace + " ") + this.eventNamespace;
      element.off(eventName);
      this.bindings = $(this.bindings.not(element).get());
      this.focusable = $(this.focusable.not(element).get());
      this.hoverable = $(this.hoverable.not(element).get());
    },
    _delay: function(handler, delay) {
      function handlerProxy() {
        return (typeof handler === "string" ? instance[handler] : handler).apply(instance, arguments);
      }
      var instance = this;
      return setTimeout(handlerProxy, delay || 0);
    },
    _hoverable: function(element) {
      this.hoverable = this.hoverable.add(element);
      this._on(element, {
        mouseenter: function(event) {
          this._addClass($(event.currentTarget), null, "ui-state-hover");
        },
        mouseleave: function(event) {
          this._removeClass($(event.currentTarget), null, "ui-state-hover");
        }
      });
    },
    _focusable: function(element) {
      this.focusable = this.focusable.add(element);
      this._on(element, {
        focusin: function(event) {
          this._addClass($(event.currentTarget), null, "ui-state-focus");
        },
        focusout: function(event) {
          this._removeClass($(event.currentTarget), null, "ui-state-focus");
        }
      });
    },
    _trigger: function(type, event, data) {
      var prop, orig;
      var callback = this.options[type];
      data = data || {};
      event = $.Event(event);
      event.type = (type === this.widgetEventPrefix ? type : this.widgetEventPrefix + type).toLowerCase();
      event.target = this.element[0];
      orig = event.originalEvent;
      if (orig) {
        for (prop in orig) {
          if (!(prop in event)) {
            event[prop] = orig[prop];
          }
        }
      }
      this.element.trigger(event, data);
      return !(typeof callback === "function" && callback.apply(this.element[0], [ event ].concat(data)) === false || event.isDefaultPrevented());
    }
  };
  $.each({
    show: "fadeIn",
    hide: "fadeOut"
  }, (function(method, defaultEffect) {
    $.Widget.prototype["_" + method] = function(element, options, callback) {
      if (typeof options === "string") {
        options = {
          effect: options
        };
      }
      var hasOptions;
      var effectName = !options ? method : options === true || typeof options === "number" ? defaultEffect : options.effect || defaultEffect;
      options = options || {};
      if (typeof options === "number") {
        options = {
          duration: options
        };
      } else if (options === true) {
        options = {};
      }
      hasOptions = !$.isEmptyObject(options);
      options.complete = callback;
      if (options.delay) {
        element.delay(options.delay);
      }
      if (hasOptions && $.effects && $.effects.effect[effectName]) {
        element[method](options);
      } else if (effectName !== method && element[effectName]) {
        element[effectName](options.duration, options.easing, callback);
      } else {
        element.queue((function(next) {
          $(this)[method]();
          if (callback) {
            callback.call(element[0]);
          }
          next();
        }));
      }
    };
  }));
  $.widget;
  /*!
 * jQuery UI Position 1.14.0
 * https://jqueryui.com
 *
 * Copyright OpenJS Foundation and other contributors
 * Released under the MIT license.
 * https://jquery.org/license
 *
 * https://api.jqueryui.com/position/
 */  (function() {
    var cachedScrollbarWidth, max = Math.max, abs = Math.abs, rhorizontal = /left|center|right/, rvertical = /top|center|bottom/, roffset = /[\+\-]\d+(\.[\d]+)?%?/, rposition = /^\w+/, rpercent = /%$/, _position = $.fn.position;
    function getOffsets(offsets, width, height) {
      return [ parseFloat(offsets[0]) * (rpercent.test(offsets[0]) ? width / 100 : 1), parseFloat(offsets[1]) * (rpercent.test(offsets[1]) ? height / 100 : 1) ];
    }
    function parseCss(element, property) {
      return parseInt($.css(element, property), 10) || 0;
    }
    function isWindow(obj) {
      return obj != null && obj === obj.window;
    }
    function getDimensions(elem) {
      var raw = elem[0];
      if (raw.nodeType === 9) {
        return {
          width: elem.width(),
          height: elem.height(),
          offset: {
            top: 0,
            left: 0
          }
        };
      }
      if (isWindow(raw)) {
        return {
          width: elem.width(),
          height: elem.height(),
          offset: {
            top: elem.scrollTop(),
            left: elem.scrollLeft()
          }
        };
      }
      if (raw.preventDefault) {
        return {
          width: 0,
          height: 0,
          offset: {
            top: raw.pageY,
            left: raw.pageX
          }
        };
      }
      return {
        width: elem.outerWidth(),
        height: elem.outerHeight(),
        offset: elem.offset()
      };
    }
    $.position = {
      scrollbarWidth: function() {
        if (cachedScrollbarWidth !== undefined) {
          return cachedScrollbarWidth;
        }
        var w1, w2, div = $("<div style=" + "'display:block;position:absolute;width:200px;height:200px;overflow:hidden;'>" + "<div style='height:300px;width:auto;'></div></div>"), innerDiv = div.children()[0];
        $("body").append(div);
        w1 = innerDiv.offsetWidth;
        div.css("overflow", "scroll");
        w2 = innerDiv.offsetWidth;
        if (w1 === w2) {
          w2 = div[0].clientWidth;
        }
        div.remove();
        return cachedScrollbarWidth = w1 - w2;
      },
      getScrollInfo: function(within) {
        var overflowX = within.isWindow || within.isDocument ? "" : within.element.css("overflow-x"), overflowY = within.isWindow || within.isDocument ? "" : within.element.css("overflow-y"), hasOverflowX = overflowX === "scroll" || overflowX === "auto" && within.width < within.element[0].scrollWidth, hasOverflowY = overflowY === "scroll" || overflowY === "auto" && within.height < within.element[0].scrollHeight;
        return {
          width: hasOverflowY ? $.position.scrollbarWidth() : 0,
          height: hasOverflowX ? $.position.scrollbarWidth() : 0
        };
      },
      getWithinInfo: function(element) {
        var withinElement = $(element || window), isElemWindow = isWindow(withinElement[0]), isDocument = !!withinElement[0] && withinElement[0].nodeType === 9, hasOffset = !isElemWindow && !isDocument;
        return {
          element: withinElement,
          isWindow: isElemWindow,
          isDocument: isDocument,
          offset: hasOffset ? $(element).offset() : {
            left: 0,
            top: 0
          },
          scrollLeft: withinElement.scrollLeft(),
          scrollTop: withinElement.scrollTop(),
          width: withinElement.outerWidth(),
          height: withinElement.outerHeight()
        };
      }
    };
    $.fn.position = function(options) {
      if (!options || !options.of) {
        return _position.apply(this, arguments);
      }
      options = $.extend({}, options);
      var atOffset, targetWidth, targetHeight, targetOffset, basePosition, dimensions, target = typeof options.of === "string" ? $(document).find(options.of) : $(options.of), within = $.position.getWithinInfo(options.within), scrollInfo = $.position.getScrollInfo(within), collision = (options.collision || "flip").split(" "), offsets = {};
      dimensions = getDimensions(target);
      if (target[0].preventDefault) {
        options.at = "left top";
      }
      targetWidth = dimensions.width;
      targetHeight = dimensions.height;
      targetOffset = dimensions.offset;
      basePosition = $.extend({}, targetOffset);
      $.each([ "my", "at" ], (function() {
        var pos = (options[this] || "").split(" "), horizontalOffset, verticalOffset;
        if (pos.length === 1) {
          pos = rhorizontal.test(pos[0]) ? pos.concat([ "center" ]) : rvertical.test(pos[0]) ? [ "center" ].concat(pos) : [ "center", "center" ];
        }
        pos[0] = rhorizontal.test(pos[0]) ? pos[0] : "center";
        pos[1] = rvertical.test(pos[1]) ? pos[1] : "center";
        horizontalOffset = roffset.exec(pos[0]);
        verticalOffset = roffset.exec(pos[1]);
        offsets[this] = [ horizontalOffset ? horizontalOffset[0] : 0, verticalOffset ? verticalOffset[0] : 0 ];
        options[this] = [ rposition.exec(pos[0])[0], rposition.exec(pos[1])[0] ];
      }));
      if (collision.length === 1) {
        collision[1] = collision[0];
      }
      if (options.at[0] === "right") {
        basePosition.left += targetWidth;
      } else if (options.at[0] === "center") {
        basePosition.left += targetWidth / 2;
      }
      if (options.at[1] === "bottom") {
        basePosition.top += targetHeight;
      } else if (options.at[1] === "center") {
        basePosition.top += targetHeight / 2;
      }
      atOffset = getOffsets(offsets.at, targetWidth, targetHeight);
      basePosition.left += atOffset[0];
      basePosition.top += atOffset[1];
      return this.each((function() {
        var collisionPosition, using, elem = $(this), elemWidth = elem.outerWidth(), elemHeight = elem.outerHeight(), marginLeft = parseCss(this, "marginLeft"), marginTop = parseCss(this, "marginTop"), collisionWidth = elemWidth + marginLeft + parseCss(this, "marginRight") + scrollInfo.width, collisionHeight = elemHeight + marginTop + parseCss(this, "marginBottom") + scrollInfo.height, position = $.extend({}, basePosition), myOffset = getOffsets(offsets.my, elem.outerWidth(), elem.outerHeight());
        if (options.my[0] === "right") {
          position.left -= elemWidth;
        } else if (options.my[0] === "center") {
          position.left -= elemWidth / 2;
        }
        if (options.my[1] === "bottom") {
          position.top -= elemHeight;
        } else if (options.my[1] === "center") {
          position.top -= elemHeight / 2;
        }
        position.left += myOffset[0];
        position.top += myOffset[1];
        collisionPosition = {
          marginLeft: marginLeft,
          marginTop: marginTop
        };
        $.each([ "left", "top" ], (function(i, dir) {
          if ($.ui.position[collision[i]]) {
            $.ui.position[collision[i]][dir](position, {
              targetWidth: targetWidth,
              targetHeight: targetHeight,
              elemWidth: elemWidth,
              elemHeight: elemHeight,
              collisionPosition: collisionPosition,
              collisionWidth: collisionWidth,
              collisionHeight: collisionHeight,
              offset: [ atOffset[0] + myOffset[0], atOffset[1] + myOffset[1] ],
              my: options.my,
              at: options.at,
              within: within,
              elem: elem
            });
          }
        }));
        if (options.using) {
          using = function(props) {
            var left = targetOffset.left - position.left, right = left + targetWidth - elemWidth, top = targetOffset.top - position.top, bottom = top + targetHeight - elemHeight, feedback = {
              target: {
                element: target,
                left: targetOffset.left,
                top: targetOffset.top,
                width: targetWidth,
                height: targetHeight
              },
              element: {
                element: elem,
                left: position.left,
                top: position.top,
                width: elemWidth,
                height: elemHeight
              },
              horizontal: right < 0 ? "left" : left > 0 ? "right" : "center",
              vertical: bottom < 0 ? "top" : top > 0 ? "bottom" : "middle"
            };
            if (targetWidth < elemWidth && abs(left + right) < targetWidth) {
              feedback.horizontal = "center";
            }
            if (targetHeight < elemHeight && abs(top + bottom) < targetHeight) {
              feedback.vertical = "middle";
            }
            if (max(abs(left), abs(right)) > max(abs(top), abs(bottom))) {
              feedback.important = "horizontal";
            } else {
              feedback.important = "vertical";
            }
            options.using.call(this, props, feedback);
          };
        }
        elem.offset($.extend(position, {
          using: using
        }));
      }));
    };
    $.ui.position = {
      fit: {
        left: function(position, data) {
          var within = data.within, withinOffset = within.isWindow ? within.scrollLeft : within.offset.left, outerWidth = within.width, collisionPosLeft = position.left - data.collisionPosition.marginLeft, overLeft = withinOffset - collisionPosLeft, overRight = collisionPosLeft + data.collisionWidth - outerWidth - withinOffset, newOverRight;
          if (data.collisionWidth > outerWidth) {
            if (overLeft > 0 && overRight <= 0) {
              newOverRight = position.left + overLeft + data.collisionWidth - outerWidth - withinOffset;
              position.left += overLeft - newOverRight;
            } else if (overRight > 0 && overLeft <= 0) {
              position.left = withinOffset;
            } else {
              if (overLeft > overRight) {
                position.left = withinOffset + outerWidth - data.collisionWidth;
              } else {
                position.left = withinOffset;
              }
            }
          } else if (overLeft > 0) {
            position.left += overLeft;
          } else if (overRight > 0) {
            position.left -= overRight;
          } else {
            position.left = max(position.left - collisionPosLeft, position.left);
          }
        },
        top: function(position, data) {
          var within = data.within, withinOffset = within.isWindow ? within.scrollTop : within.offset.top, outerHeight = data.within.height, collisionPosTop = position.top - data.collisionPosition.marginTop, overTop = withinOffset - collisionPosTop, overBottom = collisionPosTop + data.collisionHeight - outerHeight - withinOffset, newOverBottom;
          if (data.collisionHeight > outerHeight) {
            if (overTop > 0 && overBottom <= 0) {
              newOverBottom = position.top + overTop + data.collisionHeight - outerHeight - withinOffset;
              position.top += overTop - newOverBottom;
            } else if (overBottom > 0 && overTop <= 0) {
              position.top = withinOffset;
            } else {
              if (overTop > overBottom) {
                position.top = withinOffset + outerHeight - data.collisionHeight;
              } else {
                position.top = withinOffset;
              }
            }
          } else if (overTop > 0) {
            position.top += overTop;
          } else if (overBottom > 0) {
            position.top -= overBottom;
          } else {
            position.top = max(position.top - collisionPosTop, position.top);
          }
        }
      },
      flip: {
        left: function(position, data) {
          var within = data.within, withinOffset = within.offset.left + within.scrollLeft, outerWidth = within.width, offsetLeft = within.isWindow ? within.scrollLeft : within.offset.left, collisionPosLeft = position.left - data.collisionPosition.marginLeft, overLeft = collisionPosLeft - offsetLeft, overRight = collisionPosLeft + data.collisionWidth - outerWidth - offsetLeft, myOffset = data.my[0] === "left" ? -data.elemWidth : data.my[0] === "right" ? data.elemWidth : 0, atOffset = data.at[0] === "left" ? data.targetWidth : data.at[0] === "right" ? -data.targetWidth : 0, offset = -2 * data.offset[0], newOverRight, newOverLeft;
          if (overLeft < 0) {
            newOverRight = position.left + myOffset + atOffset + offset + data.collisionWidth - outerWidth - withinOffset;
            if (newOverRight < 0 || newOverRight < abs(overLeft)) {
              position.left += myOffset + atOffset + offset;
            }
          } else if (overRight > 0) {
            newOverLeft = position.left - data.collisionPosition.marginLeft + myOffset + atOffset + offset - offsetLeft;
            if (newOverLeft > 0 || abs(newOverLeft) < overRight) {
              position.left += myOffset + atOffset + offset;
            }
          }
        },
        top: function(position, data) {
          var within = data.within, withinOffset = within.offset.top + within.scrollTop, outerHeight = within.height, offsetTop = within.isWindow ? within.scrollTop : within.offset.top, collisionPosTop = position.top - data.collisionPosition.marginTop, overTop = collisionPosTop - offsetTop, overBottom = collisionPosTop + data.collisionHeight - outerHeight - offsetTop, top = data.my[1] === "top", myOffset = top ? -data.elemHeight : data.my[1] === "bottom" ? data.elemHeight : 0, atOffset = data.at[1] === "top" ? data.targetHeight : data.at[1] === "bottom" ? -data.targetHeight : 0, offset = -2 * data.offset[1], newOverTop, newOverBottom;
          if (overTop < 0) {
            newOverBottom = position.top + myOffset + atOffset + offset + data.collisionHeight - outerHeight - withinOffset;
            if (newOverBottom < 0 || newOverBottom < abs(overTop)) {
              position.top += myOffset + atOffset + offset;
            }
          } else if (overBottom > 0) {
            newOverTop = position.top - data.collisionPosition.marginTop + myOffset + atOffset + offset - offsetTop;
            if (newOverTop > 0 || abs(newOverTop) < overBottom) {
              position.top += myOffset + atOffset + offset;
            }
          }
        }
      },
      flipfit: {
        left: function() {
          $.ui.position.flip.left.apply(this, arguments);
          $.ui.position.fit.left.apply(this, arguments);
        },
        top: function() {
          $.ui.position.flip.top.apply(this, arguments);
          $.ui.position.fit.top.apply(this, arguments);
        }
      }
    };
  })();
  $.ui.position;
  /*!
 * jQuery UI :data 1.14.0
 * https://jqueryui.com
 *
 * Copyright OpenJS Foundation and other contributors
 * Released under the MIT license.
 * https://jquery.org/license
 */  $.extend($.expr.pseudos, {
    data: $.expr.createPseudo((function(dataName) {
      return function(elem) {
        return !!$.data(elem, dataName);
      };
    }))
  });
  /*!
 * jQuery UI Disable Selection 1.14.0
 * https://jqueryui.com
 *
 * Copyright OpenJS Foundation and other contributors
 * Released under the MIT license.
 * https://jquery.org/license
 */  $.fn.extend({
    disableSelection: function() {
      var eventType = "onselectstart" in document.createElement("div") ? "selectstart" : "mousedown";
      return function() {
        return this.on(eventType + ".ui-disableSelection", (function(event) {
          event.preventDefault();
        }));
      };
    }(),
    enableSelection: function() {
      return this.off(".ui-disableSelection");
    }
  });
  /*!
 * jQuery UI Focusable 1.14.0
 * https://jqueryui.com
 *
 * Copyright OpenJS Foundation and other contributors
 * Released under the MIT license.
 * https://jquery.org/license
 */  $.ui.focusable = function(element, hasTabindex) {
    var map, mapName, img, focusableIfVisible, fieldset, nodeName = element.nodeName.toLowerCase();
    if ("area" === nodeName) {
      map = element.parentNode;
      mapName = map.name;
      if (!element.href || !mapName || map.nodeName.toLowerCase() !== "map") {
        return false;
      }
      img = $("img[usemap='#" + mapName + "']");
      return img.length > 0 && img.is(":visible");
    }
    if (/^(input|select|textarea|button|object)$/.test(nodeName)) {
      focusableIfVisible = !element.disabled;
      if (focusableIfVisible) {
        fieldset = $(element).closest("fieldset")[0];
        if (fieldset) {
          focusableIfVisible = !fieldset.disabled;
        }
      }
    } else if ("a" === nodeName) {
      focusableIfVisible = element.href || hasTabindex;
    } else {
      focusableIfVisible = hasTabindex;
    }
    return focusableIfVisible && $(element).is(":visible") && $(element).css("visibility") === "visible";
  };
  $.extend($.expr.pseudos, {
    focusable: function(element) {
      return $.ui.focusable(element, $.attr(element, "tabindex") != null);
    }
  });
  $.ui.focusable;
  /*!
 * jQuery UI Form Reset Mixin 1.14.0
 * https://jqueryui.com
 *
 * Copyright OpenJS Foundation and other contributors
 * Released under the MIT license.
 * https://jquery.org/license
 */  $.ui.formResetMixin = {
    _formResetHandler: function() {
      var form = $(this);
      setTimeout((function() {
        var instances = form.data("ui-form-reset-instances");
        $.each(instances, (function() {
          this.refresh();
        }));
      }));
    },
    _bindFormResetHandler: function() {
      this.form = $(this.element.prop("form"));
      if (!this.form.length) {
        return;
      }
      var instances = this.form.data("ui-form-reset-instances") || [];
      if (!instances.length) {
        this.form.on("reset.ui-form-reset", this._formResetHandler);
      }
      instances.push(this);
      this.form.data("ui-form-reset-instances", instances);
    },
    _unbindFormResetHandler: function() {
      if (!this.form.length) {
        return;
      }
      var instances = this.form.data("ui-form-reset-instances");
      instances.splice($.inArray(this, instances), 1);
      if (instances.length) {
        this.form.data("ui-form-reset-instances", instances);
      } else {
        this.form.removeData("ui-form-reset-instances").off("reset.ui-form-reset");
      }
    }
  };
  /*!
 * jQuery UI Keycode 1.14.0
 * https://jqueryui.com
 *
 * Copyright OpenJS Foundation and other contributors
 * Released under the MIT license.
 * https://jquery.org/license
 */  $.ui.keyCode = {
    BACKSPACE: 8,
    COMMA: 188,
    DELETE: 46,
    DOWN: 40,
    END: 35,
    ENTER: 13,
    ESCAPE: 27,
    HOME: 36,
    LEFT: 37,
    PAGE_DOWN: 34,
    PAGE_UP: 33,
    PERIOD: 190,
    RIGHT: 39,
    SPACE: 32,
    TAB: 9,
    UP: 38
  };
  /*!
 * jQuery UI Labels 1.14.0
 * https://jqueryui.com
 *
 * Copyright OpenJS Foundation and other contributors
 * Released under the MIT license.
 * https://jquery.org/license
 */  $.fn.labels = function() {
    var ancestor, selector, id, labels, ancestors;
    if (!this.length) {
      return this.pushStack([]);
    }
    if (this[0].labels && this[0].labels.length) {
      return this.pushStack(this[0].labels);
    }
    labels = this.eq(0).parents("label");
    id = this.attr("id");
    if (id) {
      ancestor = this.eq(0).parents().last();
      ancestors = ancestor.add(ancestor.length ? ancestor.siblings() : this.siblings());
      selector = "label[for='" + CSS.escape(id) + "']";
      labels = labels.add(ancestors.find(selector).addBack(selector));
    }
    return this.pushStack(labels);
  };
  /*!
 * jQuery UI Scroll Parent 1.14.0
 * https://jqueryui.com
 *
 * Copyright OpenJS Foundation and other contributors
 * Released under the MIT license.
 * https://jquery.org/license
 */  $.fn.scrollParent = function(includeHidden) {
    var position = this.css("position"), excludeStaticParent = position === "absolute", overflowRegex = includeHidden ? /(auto|scroll|hidden)/ : /(auto|scroll)/, scrollParent = this.parents().filter((function() {
      var parent = $(this);
      if (excludeStaticParent && parent.css("position") === "static") {
        return false;
      }
      return overflowRegex.test(parent.css("overflow") + parent.css("overflow-y") + parent.css("overflow-x"));
    })).eq(0);
    return position === "fixed" || !scrollParent.length ? $(this[0].ownerDocument || document) : scrollParent;
  };
  /*!
 * jQuery UI Tabbable 1.14.0
 * https://jqueryui.com
 *
 * Copyright OpenJS Foundation and other contributors
 * Released under the MIT license.
 * https://jquery.org/license
 */  $.extend($.expr.pseudos, {
    tabbable: function(element) {
      var tabIndex = $.attr(element, "tabindex"), hasTabindex = tabIndex != null;
      return (!hasTabindex || tabIndex >= 0) && $.ui.focusable(element, hasTabindex);
    }
  });
  /*!
 * jQuery UI Unique ID 1.14.0
 * https://jqueryui.com
 *
 * Copyright OpenJS Foundation and other contributors
 * Released under the MIT license.
 * https://jquery.org/license
 */  $.fn.extend({
    uniqueId: function() {
      var uuid = 0;
      return function() {
        return this.each((function() {
          if (!this.id) {
            this.id = "ui-id-" + ++uuid;
          }
        }));
      };
    }(),
    removeUniqueId: function() {
      return this.each((function() {
        if (/^ui-id-\d+$/.test(this.id)) {
          $(this).removeAttr("id");
        }
      }));
    }
  });
  /*!
 * jQuery UI Mouse 1.14.0
 * https://jqueryui.com
 *
 * Copyright OpenJS Foundation and other contributors
 * Released under the MIT license.
 * https://jquery.org/license
 */  var mouseHandled = false;
  $(document).on("mouseup", (function() {
    mouseHandled = false;
  }));
  $.widget("ui.mouse", {
    version: "1.14.0",
    options: {
      cancel: "input, textarea, button, select, option",
      distance: 1,
      delay: 0
    },
    _mouseInit: function() {
      var that = this;
      this.element.on("mousedown." + this.widgetName, (function(event) {
        return that._mouseDown(event);
      })).on("click." + this.widgetName, (function(event) {
        if (true === $.data(event.target, that.widgetName + ".preventClickEvent")) {
          $.removeData(event.target, that.widgetName + ".preventClickEvent");
          event.stopImmediatePropagation();
          return false;
        }
      }));
      this.started = false;
    },
    _mouseDestroy: function() {
      this.element.off("." + this.widgetName);
      if (this._mouseMoveDelegate) {
        this.document.off("mousemove." + this.widgetName, this._mouseMoveDelegate).off("mouseup." + this.widgetName, this._mouseUpDelegate);
      }
    },
    _mouseDown: function(event) {
      if (mouseHandled) {
        return;
      }
      this._mouseMoved = false;
      if (this._mouseStarted) {
        this._mouseUp(event);
      }
      this._mouseDownEvent = event;
      var that = this, btnIsLeft = event.which === 1, elIsCancel = typeof this.options.cancel === "string" ? $(event.target).closest(this.options.cancel).length : false;
      if (!btnIsLeft || elIsCancel || !this._mouseCapture(event)) {
        return true;
      }
      this.mouseDelayMet = !this.options.delay;
      if (!this.mouseDelayMet) {
        this._mouseDelayTimer = setTimeout((function() {
          that.mouseDelayMet = true;
        }), this.options.delay);
      }
      if (this._mouseDistanceMet(event) && this._mouseDelayMet(event)) {
        this._mouseStarted = this._mouseStart(event) !== false;
        if (!this._mouseStarted) {
          event.preventDefault();
          return true;
        }
      }
      if (true === $.data(event.target, this.widgetName + ".preventClickEvent")) {
        $.removeData(event.target, this.widgetName + ".preventClickEvent");
      }
      this._mouseMoveDelegate = function(event) {
        return that._mouseMove(event);
      };
      this._mouseUpDelegate = function(event) {
        return that._mouseUp(event);
      };
      this.document.on("mousemove." + this.widgetName, this._mouseMoveDelegate).on("mouseup." + this.widgetName, this._mouseUpDelegate);
      event.preventDefault();
      mouseHandled = true;
      return true;
    },
    _mouseMove: function(event) {
      if (this._mouseMoved && !event.which) {
        if (event.originalEvent.altKey || event.originalEvent.ctrlKey || event.originalEvent.metaKey || event.originalEvent.shiftKey) {
          this.ignoreMissingWhich = true;
        } else if (!this.ignoreMissingWhich) {
          return this._mouseUp(event);
        }
      }
      if (event.which || event.button) {
        this._mouseMoved = true;
      }
      if (this._mouseStarted) {
        this._mouseDrag(event);
        return event.preventDefault();
      }
      if (this._mouseDistanceMet(event) && this._mouseDelayMet(event)) {
        this._mouseStarted = this._mouseStart(this._mouseDownEvent, event) !== false;
        if (this._mouseStarted) {
          this._mouseDrag(event);
        } else {
          this._mouseUp(event);
        }
      }
      return !this._mouseStarted;
    },
    _mouseUp: function(event) {
      this.document.off("mousemove." + this.widgetName, this._mouseMoveDelegate).off("mouseup." + this.widgetName, this._mouseUpDelegate);
      if (this._mouseStarted) {
        this._mouseStarted = false;
        if (event.target === this._mouseDownEvent.target) {
          $.data(event.target, this.widgetName + ".preventClickEvent", true);
        }
        this._mouseStop(event);
      }
      if (this._mouseDelayTimer) {
        clearTimeout(this._mouseDelayTimer);
        delete this._mouseDelayTimer;
      }
      this.ignoreMissingWhich = false;
      mouseHandled = false;
      event.preventDefault();
    },
    _mouseDistanceMet: function(event) {
      return Math.max(Math.abs(this._mouseDownEvent.pageX - event.pageX), Math.abs(this._mouseDownEvent.pageY - event.pageY)) >= this.options.distance;
    },
    _mouseDelayMet: function() {
      return this.mouseDelayMet;
    },
    _mouseStart: function() {},
    _mouseDrag: function() {},
    _mouseStop: function() {},
    _mouseCapture: function() {
      return true;
    }
  });
  $.ui.plugin = {
    add: function(module, option, set) {
      var i, proto = $.ui[module].prototype;
      for (i in set) {
        proto.plugins[i] = proto.plugins[i] || [];
        proto.plugins[i].push([ option, set[i] ]);
      }
    },
    call: function(instance, name, args, allowDisconnected) {
      var i, set = instance.plugins[name];
      if (!set) {
        return;
      }
      if (!allowDisconnected && (!instance.element[0].parentNode || instance.element[0].parentNode.nodeType === 11)) {
        return;
      }
      for (i = 0; i < set.length; i++) {
        if (instance.options[set[i][0]]) {
          set[i][1].apply(instance.element, args);
        }
      }
    }
  };
  /*!
 * jQuery UI Draggable 1.14.0
 * https://jqueryui.com
 *
 * Copyright OpenJS Foundation and other contributors
 * Released under the MIT license.
 * https://jquery.org/license
 */  $.widget("ui.draggable", $.ui.mouse, {
    version: "1.14.0",
    widgetEventPrefix: "drag",
    options: {
      addClasses: true,
      appendTo: "parent",
      axis: false,
      connectToSortable: false,
      containment: false,
      cursor: "auto",
      cursorAt: false,
      grid: false,
      handle: false,
      helper: "original",
      iframeFix: false,
      opacity: false,
      refreshPositions: false,
      revert: false,
      revertDuration: 500,
      scope: "default",
      scroll: true,
      scrollSensitivity: 20,
      scrollSpeed: 20,
      snap: false,
      snapMode: "both",
      snapTolerance: 20,
      stack: false,
      zIndex: false,
      drag: null,
      start: null,
      stop: null
    },
    _create: function() {
      if (this.options.helper === "original") {
        this._setPositionRelative();
      }
      if (this.options.addClasses) {
        this._addClass("ui-draggable");
      }
      this._setHandleClassName();
      this._mouseInit();
    },
    _setOption: function(key, value) {
      this._super(key, value);
      if (key === "handle") {
        this._removeHandleClassName();
        this._setHandleClassName();
      }
    },
    _destroy: function() {
      if ((this.helper || this.element).is(".ui-draggable-dragging")) {
        this.destroyOnClear = true;
        return;
      }
      this._removeHandleClassName();
      this._mouseDestroy();
    },
    _mouseCapture: function(event) {
      var o = this.options;
      if (this.helper || o.disabled || $(event.target).closest(".ui-resizable-handle").length > 0) {
        return false;
      }
      this.handle = this._getHandle(event);
      if (!this.handle) {
        return false;
      }
      this._blurActiveElement(event);
      this._blockFrames(o.iframeFix === true ? "iframe" : o.iframeFix);
      return true;
    },
    _blockFrames: function(selector) {
      this.iframeBlocks = this.document.find(selector).map((function() {
        var iframe = $(this);
        return $("<div>").css("position", "absolute").appendTo(iframe.parent()).outerWidth(iframe.outerWidth()).outerHeight(iframe.outerHeight()).offset(iframe.offset())[0];
      }));
    },
    _unblockFrames: function() {
      if (this.iframeBlocks) {
        this.iframeBlocks.remove();
        delete this.iframeBlocks;
      }
    },
    _blurActiveElement: function(event) {
      var activeElement = this.document[0].activeElement, target = $(event.target);
      if (target.closest(activeElement).length) {
        return;
      }
      $(activeElement).trigger("blur");
    },
    _mouseStart: function(event) {
      var o = this.options;
      this.helper = this._createHelper(event);
      this._addClass(this.helper, "ui-draggable-dragging");
      this._cacheHelperProportions();
      if ($.ui.ddmanager) {
        $.ui.ddmanager.current = this;
      }
      this._cacheMargins();
      this.cssPosition = this.helper.css("position");
      this.scrollParent = this.helper.scrollParent(true);
      this.offsetParent = this.helper.offsetParent();
      this.hasFixedAncestor = this.helper.parents().filter((function() {
        return $(this).css("position") === "fixed";
      })).length > 0;
      this.positionAbs = this.element.offset();
      this._refreshOffsets(event);
      this.originalPosition = this.position = this._generatePosition(event, false);
      this.originalPageX = event.pageX;
      this.originalPageY = event.pageY;
      if (o.cursorAt) {
        this._adjustOffsetFromHelper(o.cursorAt);
      }
      this._setContainment();
      if (this._trigger("start", event) === false) {
        this._clear();
        return false;
      }
      this._cacheHelperProportions();
      if ($.ui.ddmanager && !o.dropBehaviour) {
        $.ui.ddmanager.prepareOffsets(this, event);
      }
      this._mouseDrag(event, true);
      if ($.ui.ddmanager) {
        $.ui.ddmanager.dragStart(this, event);
      }
      return true;
    },
    _refreshOffsets: function(event) {
      this.offset = {
        top: this.positionAbs.top - this.margins.top,
        left: this.positionAbs.left - this.margins.left,
        scroll: false,
        parent: this._getParentOffset(),
        relative: this._getRelativeOffset()
      };
      this.offset.click = {
        left: event.pageX - this.offset.left,
        top: event.pageY - this.offset.top
      };
    },
    _mouseDrag: function(event, noPropagation) {
      if (this.hasFixedAncestor) {
        this.offset.parent = this._getParentOffset();
      }
      this.position = this._generatePosition(event, true);
      this.positionAbs = this._convertPositionTo("absolute");
      if (!noPropagation) {
        var ui = this._uiHash();
        if (this._trigger("drag", event, ui) === false) {
          this._mouseUp(new $.Event("mouseup", event));
          return false;
        }
        this.position = ui.position;
      }
      this.helper[0].style.left = this.position.left + "px";
      this.helper[0].style.top = this.position.top + "px";
      if ($.ui.ddmanager) {
        $.ui.ddmanager.drag(this, event);
      }
      return false;
    },
    _mouseStop: function(event) {
      var that = this, dropped = false;
      if ($.ui.ddmanager && !this.options.dropBehaviour) {
        dropped = $.ui.ddmanager.drop(this, event);
      }
      if (this.dropped) {
        dropped = this.dropped;
        this.dropped = false;
      }
      if (this.options.revert === "invalid" && !dropped || this.options.revert === "valid" && dropped || this.options.revert === true || typeof this.options.revert === "function" && this.options.revert.call(this.element, dropped)) {
        $(this.helper).animate(this.originalPosition, parseInt(this.options.revertDuration, 10), (function() {
          if (that._trigger("stop", event) !== false) {
            that._clear();
          }
        }));
      } else {
        if (this._trigger("stop", event) !== false) {
          this._clear();
        }
      }
      return false;
    },
    _mouseUp: function(event) {
      this._unblockFrames();
      if ($.ui.ddmanager) {
        $.ui.ddmanager.dragStop(this, event);
      }
      if (this.handleElement.is(event.target)) {
        this.element.trigger("focus");
      }
      return $.ui.mouse.prototype._mouseUp.call(this, event);
    },
    cancel: function() {
      if (this.helper.is(".ui-draggable-dragging")) {
        this._mouseUp(new $.Event("mouseup", {
          target: this.element[0]
        }));
      } else {
        this._clear();
      }
      return this;
    },
    _getHandle: function(event) {
      return this.options.handle ? !!$(event.target).closest(this.element.find(this.options.handle)).length : true;
    },
    _setHandleClassName: function() {
      this.handleElement = this.options.handle ? this.element.find(this.options.handle) : this.element;
      this._addClass(this.handleElement, "ui-draggable-handle");
    },
    _removeHandleClassName: function() {
      this._removeClass(this.handleElement, "ui-draggable-handle");
    },
    _createHelper: function(event) {
      var o = this.options, helperIsFunction = typeof o.helper === "function", helper = helperIsFunction ? $(o.helper.apply(this.element[0], [ event ])) : o.helper === "clone" ? this.element.clone().removeAttr("id") : this.element;
      if (!helper.parents("body").length) {
        helper.appendTo(o.appendTo === "parent" ? this.element[0].parentNode : o.appendTo);
      }
      if (helperIsFunction && helper[0] === this.element[0]) {
        this._setPositionRelative();
      }
      if (helper[0] !== this.element[0] && !/(fixed|absolute)/.test(helper.css("position"))) {
        helper.css("position", "absolute");
      }
      return helper;
    },
    _setPositionRelative: function() {
      if (!/^(?:r|a|f)/.test(this.element.css("position"))) {
        this.element[0].style.position = "relative";
      }
    },
    _adjustOffsetFromHelper: function(obj) {
      if (typeof obj === "string") {
        obj = obj.split(" ");
      }
      if (Array.isArray(obj)) {
        obj = {
          left: +obj[0],
          top: +obj[1] || 0
        };
      }
      if ("left" in obj) {
        this.offset.click.left = obj.left + this.margins.left;
      }
      if ("right" in obj) {
        this.offset.click.left = this.helperProportions.width - obj.right + this.margins.left;
      }
      if ("top" in obj) {
        this.offset.click.top = obj.top + this.margins.top;
      }
      if ("bottom" in obj) {
        this.offset.click.top = this.helperProportions.height - obj.bottom + this.margins.top;
      }
    },
    _isRootNode: function(element) {
      return /(html|body)/i.test(element.tagName) || element === this.document[0];
    },
    _getParentOffset: function() {
      var po = this.offsetParent.offset(), document = this.document[0];
      if (this.cssPosition === "absolute" && this.scrollParent[0] !== document && $.contains(this.scrollParent[0], this.offsetParent[0])) {
        po.left += this.scrollParent.scrollLeft();
        po.top += this.scrollParent.scrollTop();
      }
      if (this._isRootNode(this.offsetParent[0])) {
        po = {
          top: 0,
          left: 0
        };
      }
      return {
        top: po.top + (parseInt(this.offsetParent.css("borderTopWidth"), 10) || 0),
        left: po.left + (parseInt(this.offsetParent.css("borderLeftWidth"), 10) || 0)
      };
    },
    _getRelativeOffset: function() {
      if (this.cssPosition !== "relative") {
        return {
          top: 0,
          left: 0
        };
      }
      var p = this.element.position(), scrollIsRootNode = this._isRootNode(this.scrollParent[0]);
      return {
        top: p.top - (parseInt(this.helper.css("top"), 10) || 0) + (!scrollIsRootNode ? this.scrollParent.scrollTop() : 0),
        left: p.left - (parseInt(this.helper.css("left"), 10) || 0) + (!scrollIsRootNode ? this.scrollParent.scrollLeft() : 0)
      };
    },
    _cacheMargins: function() {
      this.margins = {
        left: parseInt(this.element.css("marginLeft"), 10) || 0,
        top: parseInt(this.element.css("marginTop"), 10) || 0,
        right: parseInt(this.element.css("marginRight"), 10) || 0,
        bottom: parseInt(this.element.css("marginBottom"), 10) || 0
      };
    },
    _cacheHelperProportions: function() {
      this.helperProportions = {
        width: this.helper.outerWidth(),
        height: this.helper.outerHeight()
      };
    },
    _setContainment: function() {
      var isUserScrollable, c, ce, o = this.options, document = this.document[0];
      this.relativeContainer = null;
      if (!o.containment) {
        this.containment = null;
        return;
      }
      if (o.containment === "window") {
        this.containment = [ $(window).scrollLeft() - this.offset.relative.left - this.offset.parent.left, $(window).scrollTop() - this.offset.relative.top - this.offset.parent.top, $(window).scrollLeft() + $(window).width() - this.helperProportions.width - this.margins.left, $(window).scrollTop() + ($(window).height() || document.body.parentNode.scrollHeight) - this.helperProportions.height - this.margins.top ];
        return;
      }
      if (o.containment === "document") {
        this.containment = [ 0, 0, $(document).width() - this.helperProportions.width - this.margins.left, ($(document).height() || document.body.parentNode.scrollHeight) - this.helperProportions.height - this.margins.top ];
        return;
      }
      if (o.containment.constructor === Array) {
        this.containment = o.containment;
        return;
      }
      if (o.containment === "parent") {
        o.containment = this.helper[0].parentNode;
      }
      c = $(o.containment);
      ce = c[0];
      if (!ce) {
        return;
      }
      isUserScrollable = /(scroll|auto)/.test(c.css("overflow"));
      this.containment = [ (parseInt(c.css("borderLeftWidth"), 10) || 0) + (parseInt(c.css("paddingLeft"), 10) || 0), (parseInt(c.css("borderTopWidth"), 10) || 0) + (parseInt(c.css("paddingTop"), 10) || 0), (isUserScrollable ? Math.max(ce.scrollWidth, ce.offsetWidth) : ce.offsetWidth) - (parseInt(c.css("borderRightWidth"), 10) || 0) - (parseInt(c.css("paddingRight"), 10) || 0) - this.helperProportions.width - this.margins.left - this.margins.right, (isUserScrollable ? Math.max(ce.scrollHeight, ce.offsetHeight) : ce.offsetHeight) - (parseInt(c.css("borderBottomWidth"), 10) || 0) - (parseInt(c.css("paddingBottom"), 10) || 0) - this.helperProportions.height - this.margins.top - this.margins.bottom ];
      this.relativeContainer = c;
    },
    _convertPositionTo: function(d, pos) {
      if (!pos) {
        pos = this.position;
      }
      var mod = d === "absolute" ? 1 : -1, scrollIsRootNode = this._isRootNode(this.scrollParent[0]);
      return {
        top: pos.top + this.offset.relative.top * mod + this.offset.parent.top * mod - (this.cssPosition === "fixed" ? -this.offset.scroll.top : scrollIsRootNode ? 0 : this.offset.scroll.top) * mod,
        left: pos.left + this.offset.relative.left * mod + this.offset.parent.left * mod - (this.cssPosition === "fixed" ? -this.offset.scroll.left : scrollIsRootNode ? 0 : this.offset.scroll.left) * mod
      };
    },
    _generatePosition: function(event, constrainPosition) {
      var containment, co, top, left, o = this.options, scrollIsRootNode = this._isRootNode(this.scrollParent[0]), pageX = event.pageX, pageY = event.pageY;
      if (!scrollIsRootNode || !this.offset.scroll) {
        this.offset.scroll = {
          top: this.scrollParent.scrollTop(),
          left: this.scrollParent.scrollLeft()
        };
      }
      if (constrainPosition) {
        if (this.containment) {
          if (this.relativeContainer) {
            co = this.relativeContainer.offset();
            containment = [ this.containment[0] + co.left, this.containment[1] + co.top, this.containment[2] + co.left, this.containment[3] + co.top ];
          } else {
            containment = this.containment;
          }
          if (event.pageX - this.offset.click.left < containment[0]) {
            pageX = containment[0] + this.offset.click.left;
          }
          if (event.pageY - this.offset.click.top < containment[1]) {
            pageY = containment[1] + this.offset.click.top;
          }
          if (event.pageX - this.offset.click.left > containment[2]) {
            pageX = containment[2] + this.offset.click.left;
          }
          if (event.pageY - this.offset.click.top > containment[3]) {
            pageY = containment[3] + this.offset.click.top;
          }
        }
        if (o.grid) {
          top = o.grid[1] ? this.originalPageY + Math.round((pageY - this.originalPageY) / o.grid[1]) * o.grid[1] : this.originalPageY;
          pageY = containment ? top - this.offset.click.top >= containment[1] || top - this.offset.click.top > containment[3] ? top : top - this.offset.click.top >= containment[1] ? top - o.grid[1] : top + o.grid[1] : top;
          left = o.grid[0] ? this.originalPageX + Math.round((pageX - this.originalPageX) / o.grid[0]) * o.grid[0] : this.originalPageX;
          pageX = containment ? left - this.offset.click.left >= containment[0] || left - this.offset.click.left > containment[2] ? left : left - this.offset.click.left >= containment[0] ? left - o.grid[0] : left + o.grid[0] : left;
        }
        if (o.axis === "y") {
          pageX = this.originalPageX;
        }
        if (o.axis === "x") {
          pageY = this.originalPageY;
        }
      }
      return {
        top: pageY - this.offset.click.top - this.offset.relative.top - this.offset.parent.top + (this.cssPosition === "fixed" ? -this.offset.scroll.top : scrollIsRootNode ? 0 : this.offset.scroll.top),
        left: pageX - this.offset.click.left - this.offset.relative.left - this.offset.parent.left + (this.cssPosition === "fixed" ? -this.offset.scroll.left : scrollIsRootNode ? 0 : this.offset.scroll.left)
      };
    },
    _clear: function() {
      this._removeClass(this.helper, "ui-draggable-dragging");
      if (this.helper[0] !== this.element[0] && !this.cancelHelperRemoval) {
        this.helper.remove();
      }
      this.helper = null;
      this.cancelHelperRemoval = false;
      if (this.destroyOnClear) {
        this.destroy();
      }
    },
    _trigger: function(type, event, ui) {
      ui = ui || this._uiHash();
      $.ui.plugin.call(this, type, [ event, ui, this ], true);
      if (/^(drag|start|stop)/.test(type)) {
        this.positionAbs = this._convertPositionTo("absolute");
        ui.offset = this.positionAbs;
      }
      return $.Widget.prototype._trigger.call(this, type, event, ui);
    },
    plugins: {},
    _uiHash: function() {
      return {
        helper: this.helper,
        position: this.position,
        originalPosition: this.originalPosition,
        offset: this.positionAbs
      };
    }
  });
  $.ui.plugin.add("draggable", "connectToSortable", {
    start: function(event, ui, draggable) {
      var uiSortable = $.extend({}, ui, {
        item: draggable.element
      });
      draggable.sortables = [];
      $(draggable.options.connectToSortable).each((function() {
        var sortable = $(this).sortable("instance");
        if (sortable && !sortable.options.disabled) {
          draggable.sortables.push(sortable);
          sortable.refreshPositions();
          sortable._trigger("activate", event, uiSortable);
        }
      }));
    },
    stop: function(event, ui, draggable) {
      var uiSortable = $.extend({}, ui, {
        item: draggable.element
      });
      draggable.cancelHelperRemoval = false;
      $.each(draggable.sortables, (function() {
        var sortable = this;
        if (sortable.isOver) {
          sortable.isOver = 0;
          draggable.cancelHelperRemoval = true;
          sortable.cancelHelperRemoval = false;
          sortable._storedCSS = {
            position: sortable.placeholder.css("position"),
            top: sortable.placeholder.css("top"),
            left: sortable.placeholder.css("left")
          };
          sortable._mouseStop(event);
          sortable.options.helper = sortable.options._helper;
        } else {
          sortable.cancelHelperRemoval = true;
          sortable._trigger("deactivate", event, uiSortable);
        }
      }));
    },
    drag: function(event, ui, draggable) {
      $.each(draggable.sortables, (function() {
        var innermostIntersecting = false, sortable = this;
        sortable.positionAbs = draggable.positionAbs;
        sortable.helperProportions = draggable.helperProportions;
        sortable.offset.click = draggable.offset.click;
        if (sortable._intersectsWith(sortable.containerCache)) {
          innermostIntersecting = true;
          $.each(draggable.sortables, (function() {
            this.positionAbs = draggable.positionAbs;
            this.helperProportions = draggable.helperProportions;
            this.offset.click = draggable.offset.click;
            if (this !== sortable && this._intersectsWith(this.containerCache) && $.contains(sortable.element[0], this.element[0])) {
              innermostIntersecting = false;
            }
            return innermostIntersecting;
          }));
        }
        if (innermostIntersecting) {
          if (!sortable.isOver) {
            sortable.isOver = 1;
            draggable._parent = ui.helper.parent();
            sortable.currentItem = ui.helper.appendTo(sortable.element).data("ui-sortable-item", true);
            sortable.options._helper = sortable.options.helper;
            sortable.options.helper = function() {
              return ui.helper[0];
            };
            event.target = sortable.currentItem[0];
            sortable._mouseCapture(event, true);
            sortable._mouseStart(event, true, true);
            sortable.offset.click.top = draggable.offset.click.top;
            sortable.offset.click.left = draggable.offset.click.left;
            sortable.offset.parent.left -= draggable.offset.parent.left - sortable.offset.parent.left;
            sortable.offset.parent.top -= draggable.offset.parent.top - sortable.offset.parent.top;
            draggable._trigger("toSortable", event);
            draggable.dropped = sortable.element;
            $.each(draggable.sortables, (function() {
              this.refreshPositions();
            }));
            draggable.currentItem = draggable.element;
            sortable.fromOutside = draggable;
          }
          if (sortable.currentItem) {
            sortable._mouseDrag(event);
            ui.position = sortable.position;
          }
        } else {
          if (sortable.isOver) {
            sortable.isOver = 0;
            sortable.cancelHelperRemoval = true;
            sortable.options._revert = sortable.options.revert;
            sortable.options.revert = false;
            sortable._trigger("out", event, sortable._uiHash(sortable));
            sortable._mouseStop(event, true);
            sortable.options.revert = sortable.options._revert;
            sortable.options.helper = sortable.options._helper;
            if (sortable.placeholder) {
              sortable.placeholder.remove();
            }
            ui.helper.appendTo(draggable._parent);
            draggable._refreshOffsets(event);
            ui.position = draggable._generatePosition(event, true);
            draggable._trigger("fromSortable", event);
            draggable.dropped = false;
            $.each(draggable.sortables, (function() {
              this.refreshPositions();
            }));
          }
        }
      }));
    }
  });
  $.ui.plugin.add("draggable", "cursor", {
    start: function(event, ui, instance) {
      var t = $("body"), o = instance.options;
      if (t.css("cursor")) {
        o._cursor = t.css("cursor");
      }
      t.css("cursor", o.cursor);
    },
    stop: function(event, ui, instance) {
      var o = instance.options;
      if (o._cursor) {
        $("body").css("cursor", o._cursor);
      }
    }
  });
  $.ui.plugin.add("draggable", "opacity", {
    start: function(event, ui, instance) {
      var t = $(ui.helper), o = instance.options;
      if (t.css("opacity")) {
        o._opacity = t.css("opacity");
      }
      t.css("opacity", o.opacity);
    },
    stop: function(event, ui, instance) {
      var o = instance.options;
      if (o._opacity) {
        $(ui.helper).css("opacity", o._opacity);
      }
    }
  });
  $.ui.plugin.add("draggable", "scroll", {
    start: function(event, ui, i) {
      if (!i.scrollParentNotHidden) {
        i.scrollParentNotHidden = i.helper.scrollParent(false);
      }
      if (i.scrollParentNotHidden[0] !== i.document[0] && i.scrollParentNotHidden[0].tagName !== "HTML") {
        i.overflowOffset = i.scrollParentNotHidden.offset();
      }
    },
    drag: function(event, ui, i) {
      var o = i.options, scrolled = false, scrollParent = i.scrollParentNotHidden[0], document = i.document[0];
      if (scrollParent !== document && scrollParent.tagName !== "HTML") {
        if (!o.axis || o.axis !== "x") {
          if (i.overflowOffset.top + scrollParent.offsetHeight - event.pageY < o.scrollSensitivity) {
            scrollParent.scrollTop = scrolled = scrollParent.scrollTop + o.scrollSpeed;
          } else if (event.pageY - i.overflowOffset.top < o.scrollSensitivity) {
            scrollParent.scrollTop = scrolled = scrollParent.scrollTop - o.scrollSpeed;
          }
        }
        if (!o.axis || o.axis !== "y") {
          if (i.overflowOffset.left + scrollParent.offsetWidth - event.pageX < o.scrollSensitivity) {
            scrollParent.scrollLeft = scrolled = scrollParent.scrollLeft + o.scrollSpeed;
          } else if (event.pageX - i.overflowOffset.left < o.scrollSensitivity) {
            scrollParent.scrollLeft = scrolled = scrollParent.scrollLeft - o.scrollSpeed;
          }
        }
      } else {
        if (!o.axis || o.axis !== "x") {
          if (event.pageY - $(document).scrollTop() < o.scrollSensitivity) {
            scrolled = $(document).scrollTop($(document).scrollTop() - o.scrollSpeed);
          } else if ($(window).height() - (event.pageY - $(document).scrollTop()) < o.scrollSensitivity) {
            scrolled = $(document).scrollTop($(document).scrollTop() + o.scrollSpeed);
          }
        }
        if (!o.axis || o.axis !== "y") {
          if (event.pageX - $(document).scrollLeft() < o.scrollSensitivity) {
            scrolled = $(document).scrollLeft($(document).scrollLeft() - o.scrollSpeed);
          } else if ($(window).width() - (event.pageX - $(document).scrollLeft()) < o.scrollSensitivity) {
            scrolled = $(document).scrollLeft($(document).scrollLeft() + o.scrollSpeed);
          }
        }
      }
      if (scrolled !== false && $.ui.ddmanager && !o.dropBehaviour) {
        $.ui.ddmanager.prepareOffsets(i, event);
      }
    }
  });
  $.ui.plugin.add("draggable", "snap", {
    start: function(event, ui, i) {
      var o = i.options;
      i.snapElements = [];
      $(o.snap.constructor !== String ? o.snap.items || ":data(ui-draggable)" : o.snap).each((function() {
        var $t = $(this), $o = $t.offset();
        if (this !== i.element[0]) {
          i.snapElements.push({
            item: this,
            width: $t.outerWidth(),
            height: $t.outerHeight(),
            top: $o.top,
            left: $o.left
          });
        }
      }));
    },
    drag: function(event, ui, inst) {
      var ts, bs, ls, rs, l, r, t, b, i, first, o = inst.options, d = o.snapTolerance, x1 = ui.offset.left, x2 = x1 + inst.helperProportions.width, y1 = ui.offset.top, y2 = y1 + inst.helperProportions.height;
      for (i = inst.snapElements.length - 1; i >= 0; i--) {
        l = inst.snapElements[i].left - inst.margins.left;
        r = l + inst.snapElements[i].width;
        t = inst.snapElements[i].top - inst.margins.top;
        b = t + inst.snapElements[i].height;
        if (x2 < l - d || x1 > r + d || y2 < t - d || y1 > b + d || !$.contains(inst.snapElements[i].item.ownerDocument, inst.snapElements[i].item)) {
          if (inst.snapElements[i].snapping) {
            if (inst.options.snap.release) {
              inst.options.snap.release.call(inst.element, event, $.extend(inst._uiHash(), {
                snapItem: inst.snapElements[i].item
              }));
            }
          }
          inst.snapElements[i].snapping = false;
          continue;
        }
        if (o.snapMode !== "inner") {
          ts = Math.abs(t - y2) <= d;
          bs = Math.abs(b - y1) <= d;
          ls = Math.abs(l - x2) <= d;
          rs = Math.abs(r - x1) <= d;
          if (ts) {
            ui.position.top = inst._convertPositionTo("relative", {
              top: t - inst.helperProportions.height,
              left: 0
            }).top;
          }
          if (bs) {
            ui.position.top = inst._convertPositionTo("relative", {
              top: b,
              left: 0
            }).top;
          }
          if (ls) {
            ui.position.left = inst._convertPositionTo("relative", {
              top: 0,
              left: l - inst.helperProportions.width
            }).left;
          }
          if (rs) {
            ui.position.left = inst._convertPositionTo("relative", {
              top: 0,
              left: r
            }).left;
          }
        }
        first = ts || bs || ls || rs;
        if (o.snapMode !== "outer") {
          ts = Math.abs(t - y1) <= d;
          bs = Math.abs(b - y2) <= d;
          ls = Math.abs(l - x1) <= d;
          rs = Math.abs(r - x2) <= d;
          if (ts) {
            ui.position.top = inst._convertPositionTo("relative", {
              top: t,
              left: 0
            }).top;
          }
          if (bs) {
            ui.position.top = inst._convertPositionTo("relative", {
              top: b - inst.helperProportions.height,
              left: 0
            }).top;
          }
          if (ls) {
            ui.position.left = inst._convertPositionTo("relative", {
              top: 0,
              left: l
            }).left;
          }
          if (rs) {
            ui.position.left = inst._convertPositionTo("relative", {
              top: 0,
              left: r - inst.helperProportions.width
            }).left;
          }
        }
        if (!inst.snapElements[i].snapping && (ts || bs || ls || rs || first)) {
          if (inst.options.snap.snap) {
            inst.options.snap.snap.call(inst.element, event, $.extend(inst._uiHash(), {
              snapItem: inst.snapElements[i].item
            }));
          }
        }
        inst.snapElements[i].snapping = ts || bs || ls || rs || first;
      }
    }
  });
  $.ui.plugin.add("draggable", "stack", {
    start: function(event, ui, instance) {
      var min, o = instance.options, group = $.makeArray($(o.stack)).sort((function(a, b) {
        return (parseInt($(a).css("zIndex"), 10) || 0) - (parseInt($(b).css("zIndex"), 10) || 0);
      }));
      if (!group.length) {
        return;
      }
      min = parseInt($(group[0]).css("zIndex"), 10) || 0;
      $(group).each((function(i) {
        $(this).css("zIndex", min + i);
      }));
      this.css("zIndex", min + group.length);
    }
  });
  $.ui.plugin.add("draggable", "zIndex", {
    start: function(event, ui, instance) {
      var t = $(ui.helper), o = instance.options;
      if (t.css("zIndex")) {
        o._zIndex = t.css("zIndex");
      }
      t.css("zIndex", o.zIndex);
    },
    stop: function(event, ui, instance) {
      var o = instance.options;
      if (o._zIndex) {
        $(ui.helper).css("zIndex", o._zIndex);
      }
    }
  });
  $.ui.draggable;
  /*!
 * jQuery UI Resizable 1.14.0
 * https://jqueryui.com
 *
 * Copyright OpenJS Foundation and other contributors
 * Released under the MIT license.
 * https://jquery.org/license
 */  $.widget("ui.resizable", $.ui.mouse, {
    version: "1.14.0",
    widgetEventPrefix: "resize",
    options: {
      alsoResize: false,
      animate: false,
      animateDuration: "slow",
      animateEasing: "swing",
      aspectRatio: false,
      autoHide: false,
      classes: {
        "ui-resizable-se": "ui-icon ui-icon-gripsmall-diagonal-se"
      },
      containment: false,
      ghost: false,
      grid: false,
      handles: "e,s,se",
      helper: false,
      maxHeight: null,
      maxWidth: null,
      minHeight: 10,
      minWidth: 10,
      zIndex: 90,
      resize: null,
      start: null,
      stop: null
    },
    _num: function(value) {
      return parseFloat(value) || 0;
    },
    _isNumber: function(value) {
      return !isNaN(parseFloat(value));
    },
    _hasScroll: function(el, a) {
      if ($(el).css("overflow") === "hidden") {
        return false;
      }
      var scroll = a && a === "left" ? "scrollLeft" : "scrollTop", has = false;
      if (el[scroll] > 0) {
        return true;
      }
      try {
        el[scroll] = 1;
        has = el[scroll] > 0;
        el[scroll] = 0;
      } catch (e) {}
      return has;
    },
    _create: function() {
      var margins, o = this.options, that = this;
      this._addClass("ui-resizable");
      $.extend(this, {
        _aspectRatio: !!o.aspectRatio,
        aspectRatio: o.aspectRatio,
        originalElement: this.element,
        _proportionallyResizeElements: [],
        _helper: o.helper || o.ghost || o.animate ? o.helper || "ui-resizable-helper" : null
      });
      if (this.element[0].nodeName.match(/^(canvas|textarea|input|select|button|img)$/i)) {
        this.element.wrap($("<div class='ui-wrapper'></div>").css({
          overflow: "hidden",
          position: this.element.css("position"),
          width: this.element.outerWidth(),
          height: this.element.outerHeight(),
          top: this.element.css("top"),
          left: this.element.css("left")
        }));
        this.element = this.element.parent().data("ui-resizable", this.element.resizable("instance"));
        this.elementIsWrapper = true;
        margins = {
          marginTop: this.originalElement.css("marginTop"),
          marginRight: this.originalElement.css("marginRight"),
          marginBottom: this.originalElement.css("marginBottom"),
          marginLeft: this.originalElement.css("marginLeft")
        };
        this.element.css(margins);
        this.originalResizeStyle = this.originalElement.css("resize");
        this.originalElement.css("resize", "none");
        this._proportionallyResizeElements.push(this.originalElement.css({
          position: "static",
          zoom: 1,
          display: "block"
        }));
        this._proportionallyResize();
      }
      this._setupHandles();
      if (o.autoHide) {
        $(this.element).on("mouseenter", (function() {
          if (o.disabled) {
            return;
          }
          that._removeClass("ui-resizable-autohide");
          that._handles.show();
        })).on("mouseleave", (function() {
          if (o.disabled) {
            return;
          }
          if (!that.resizing) {
            that._addClass("ui-resizable-autohide");
            that._handles.hide();
          }
        }));
      }
      this._mouseInit();
    },
    _destroy: function() {
      this._mouseDestroy();
      this._addedHandles.remove();
      var wrapper, _destroy = function(exp) {
        $(exp).removeData("resizable").removeData("ui-resizable").off(".resizable");
      };
      if (this.elementIsWrapper) {
        _destroy(this.element);
        wrapper = this.element;
        this.originalElement.css({
          position: wrapper.css("position"),
          width: wrapper.outerWidth(),
          height: wrapper.outerHeight(),
          top: wrapper.css("top"),
          left: wrapper.css("left")
        }).insertAfter(wrapper);
        wrapper.remove();
      }
      this.originalElement.css("resize", this.originalResizeStyle);
      _destroy(this.originalElement);
      return this;
    },
    _setOption: function(key, value) {
      this._super(key, value);
      switch (key) {
       case "handles":
        this._removeHandles();
        this._setupHandles();
        break;

       case "aspectRatio":
        this._aspectRatio = !!value;
        break;
      }
    },
    _setupHandles: function() {
      var o = this.options, handle, i, n, hname, axis, that = this;
      this.handles = o.handles || (!$(".ui-resizable-handle", this.element).length ? "e,s,se" : {
        n: ".ui-resizable-n",
        e: ".ui-resizable-e",
        s: ".ui-resizable-s",
        w: ".ui-resizable-w",
        se: ".ui-resizable-se",
        sw: ".ui-resizable-sw",
        ne: ".ui-resizable-ne",
        nw: ".ui-resizable-nw"
      });
      this._handles = $();
      this._addedHandles = $();
      if (this.handles.constructor === String) {
        if (this.handles === "all") {
          this.handles = "n,e,s,w,se,sw,ne,nw";
        }
        n = this.handles.split(",");
        this.handles = {};
        for (i = 0; i < n.length; i++) {
          handle = String.prototype.trim.call(n[i]);
          hname = "ui-resizable-" + handle;
          axis = $("<div>");
          this._addClass(axis, "ui-resizable-handle " + hname);
          axis.css({
            zIndex: o.zIndex
          });
          this.handles[handle] = ".ui-resizable-" + handle;
          if (!this.element.children(this.handles[handle]).length) {
            this.element.append(axis);
            this._addedHandles = this._addedHandles.add(axis);
          }
        }
      }
      this._renderAxis = function(target) {
        var i, axis, padPos, padWrapper;
        target = target || this.element;
        for (i in this.handles) {
          if (this.handles[i].constructor === String) {
            this.handles[i] = this.element.children(this.handles[i]).first().show();
          } else if (this.handles[i].jquery || this.handles[i].nodeType) {
            this.handles[i] = $(this.handles[i]);
            this._on(this.handles[i], {
              mousedown: that._mouseDown
            });
          }
          if (this.elementIsWrapper && this.originalElement[0].nodeName.match(/^(textarea|input|select|button)$/i)) {
            axis = $(this.handles[i], this.element);
            padWrapper = /sw|ne|nw|se|n|s/.test(i) ? axis.outerHeight() : axis.outerWidth();
            padPos = [ "padding", /ne|nw|n/.test(i) ? "Top" : /se|sw|s/.test(i) ? "Bottom" : /^e$/.test(i) ? "Right" : "Left" ].join("");
            target.css(padPos, padWrapper);
            this._proportionallyResize();
          }
          this._handles = this._handles.add(this.handles[i]);
        }
      };
      this._renderAxis(this.element);
      this._handles = this._handles.add(this.element.find(".ui-resizable-handle"));
      this._handles.disableSelection();
      this._handles.on("mouseover", (function() {
        if (!that.resizing) {
          if (this.className) {
            axis = this.className.match(/ui-resizable-(se|sw|ne|nw|n|e|s|w)/i);
          }
          that.axis = axis && axis[1] ? axis[1] : "se";
        }
      }));
      if (o.autoHide) {
        this._handles.hide();
        this._addClass("ui-resizable-autohide");
      }
    },
    _removeHandles: function() {
      this._addedHandles.remove();
    },
    _mouseCapture: function(event) {
      var i, handle, capture = false;
      for (i in this.handles) {
        handle = $(this.handles[i])[0];
        if (handle === event.target || $.contains(handle, event.target)) {
          capture = true;
        }
      }
      return !this.options.disabled && capture;
    },
    _mouseStart: function(event) {
      var curleft, curtop, cursor, o = this.options, el = this.element;
      this.resizing = true;
      this._renderProxy();
      curleft = this._num(this.helper.css("left"));
      curtop = this._num(this.helper.css("top"));
      if (o.containment) {
        curleft += $(o.containment).scrollLeft() || 0;
        curtop += $(o.containment).scrollTop() || 0;
      }
      this.offset = this.helper.offset();
      this.position = {
        left: curleft,
        top: curtop
      };
      this.size = this._helper ? {
        width: this.helper.width(),
        height: this.helper.height()
      } : {
        width: el.width(),
        height: el.height()
      };
      this.originalSize = this._helper ? {
        width: el.outerWidth(),
        height: el.outerHeight()
      } : {
        width: el.width(),
        height: el.height()
      };
      this.sizeDiff = {
        width: el.outerWidth() - el.width(),
        height: el.outerHeight() - el.height()
      };
      this.originalPosition = {
        left: curleft,
        top: curtop
      };
      this.originalMousePosition = {
        left: event.pageX,
        top: event.pageY
      };
      this.aspectRatio = typeof o.aspectRatio === "number" ? o.aspectRatio : this.originalSize.width / this.originalSize.height || 1;
      cursor = $(".ui-resizable-" + this.axis).css("cursor");
      $("body").css("cursor", cursor === "auto" ? this.axis + "-resize" : cursor);
      this._addClass("ui-resizable-resizing");
      this._propagate("start", event);
      return true;
    },
    _mouseDrag: function(event) {
      var data, props, smp = this.originalMousePosition, a = this.axis, dx = event.pageX - smp.left || 0, dy = event.pageY - smp.top || 0, trigger = this._change[a];
      this._updatePrevProperties();
      if (!trigger) {
        return false;
      }
      data = trigger.apply(this, [ event, dx, dy ]);
      this._updateVirtualBoundaries(event.shiftKey);
      if (this._aspectRatio || event.shiftKey) {
        data = this._updateRatio(data, event);
      }
      data = this._respectSize(data, event);
      this._updateCache(data);
      this._propagate("resize", event);
      props = this._applyChanges();
      if (!this._helper && this._proportionallyResizeElements.length) {
        this._proportionallyResize();
      }
      if (!$.isEmptyObject(props)) {
        this._updatePrevProperties();
        this._trigger("resize", event, this.ui());
        this._applyChanges();
      }
      return false;
    },
    _mouseStop: function(event) {
      this.resizing = false;
      var pr, ista, soffseth, soffsetw, s, left, top, o = this.options, that = this;
      if (this._helper) {
        pr = this._proportionallyResizeElements;
        ista = pr.length && /textarea/i.test(pr[0].nodeName);
        soffseth = ista && this._hasScroll(pr[0], "left") ? 0 : that.sizeDiff.height;
        soffsetw = ista ? 0 : that.sizeDiff.width;
        s = {
          width: that.helper.width() - soffsetw,
          height: that.helper.height() - soffseth
        };
        left = parseFloat(that.element.css("left")) + (that.position.left - that.originalPosition.left) || null;
        top = parseFloat(that.element.css("top")) + (that.position.top - that.originalPosition.top) || null;
        if (!o.animate) {
          this.element.css($.extend(s, {
            top: top,
            left: left
          }));
        }
        that.helper.height(that.size.height);
        that.helper.width(that.size.width);
        if (this._helper && !o.animate) {
          this._proportionallyResize();
        }
      }
      $("body").css("cursor", "auto");
      this._removeClass("ui-resizable-resizing");
      this._propagate("stop", event);
      if (this._helper) {
        this.helper.remove();
      }
      return false;
    },
    _updatePrevProperties: function() {
      this.prevPosition = {
        top: this.position.top,
        left: this.position.left
      };
      this.prevSize = {
        width: this.size.width,
        height: this.size.height
      };
    },
    _applyChanges: function() {
      var props = {};
      if (this.position.top !== this.prevPosition.top) {
        props.top = this.position.top + "px";
      }
      if (this.position.left !== this.prevPosition.left) {
        props.left = this.position.left + "px";
      }
      this.helper.css(props);
      if (this.size.width !== this.prevSize.width) {
        props.width = this.size.width + "px";
        this.helper.width(props.width);
      }
      if (this.size.height !== this.prevSize.height) {
        props.height = this.size.height + "px";
        this.helper.height(props.height);
      }
      return props;
    },
    _updateVirtualBoundaries: function(forceAspectRatio) {
      var pMinWidth, pMaxWidth, pMinHeight, pMaxHeight, b, o = this.options;
      b = {
        minWidth: this._isNumber(o.minWidth) ? o.minWidth : 0,
        maxWidth: this._isNumber(o.maxWidth) ? o.maxWidth : Infinity,
        minHeight: this._isNumber(o.minHeight) ? o.minHeight : 0,
        maxHeight: this._isNumber(o.maxHeight) ? o.maxHeight : Infinity
      };
      if (this._aspectRatio || forceAspectRatio) {
        pMinWidth = b.minHeight * this.aspectRatio;
        pMinHeight = b.minWidth / this.aspectRatio;
        pMaxWidth = b.maxHeight * this.aspectRatio;
        pMaxHeight = b.maxWidth / this.aspectRatio;
        if (pMinWidth > b.minWidth) {
          b.minWidth = pMinWidth;
        }
        if (pMinHeight > b.minHeight) {
          b.minHeight = pMinHeight;
        }
        if (pMaxWidth < b.maxWidth) {
          b.maxWidth = pMaxWidth;
        }
        if (pMaxHeight < b.maxHeight) {
          b.maxHeight = pMaxHeight;
        }
      }
      this._vBoundaries = b;
    },
    _updateCache: function(data) {
      this.offset = this.helper.offset();
      if (this._isNumber(data.left)) {
        this.position.left = data.left;
      }
      if (this._isNumber(data.top)) {
        this.position.top = data.top;
      }
      if (this._isNumber(data.height)) {
        this.size.height = data.height;
      }
      if (this._isNumber(data.width)) {
        this.size.width = data.width;
      }
    },
    _updateRatio: function(data) {
      var cpos = this.position, csize = this.size, a = this.axis;
      if (this._isNumber(data.height)) {
        data.width = data.height * this.aspectRatio;
      } else if (this._isNumber(data.width)) {
        data.height = data.width / this.aspectRatio;
      }
      if (a === "sw") {
        data.left = cpos.left + (csize.width - data.width);
        data.top = null;
      }
      if (a === "nw") {
        data.top = cpos.top + (csize.height - data.height);
        data.left = cpos.left + (csize.width - data.width);
      }
      return data;
    },
    _respectSize: function(data) {
      var o = this._vBoundaries, a = this.axis, ismaxw = this._isNumber(data.width) && o.maxWidth && o.maxWidth < data.width, ismaxh = this._isNumber(data.height) && o.maxHeight && o.maxHeight < data.height, isminw = this._isNumber(data.width) && o.minWidth && o.minWidth > data.width, isminh = this._isNumber(data.height) && o.minHeight && o.minHeight > data.height, dw = this.originalPosition.left + this.originalSize.width, dh = this.originalPosition.top + this.originalSize.height, cw = /sw|nw|w/.test(a), ch = /nw|ne|n/.test(a);
      if (isminw) {
        data.width = o.minWidth;
      }
      if (isminh) {
        data.height = o.minHeight;
      }
      if (ismaxw) {
        data.width = o.maxWidth;
      }
      if (ismaxh) {
        data.height = o.maxHeight;
      }
      if (isminw && cw) {
        data.left = dw - o.minWidth;
      }
      if (ismaxw && cw) {
        data.left = dw - o.maxWidth;
      }
      if (isminh && ch) {
        data.top = dh - o.minHeight;
      }
      if (ismaxh && ch) {
        data.top = dh - o.maxHeight;
      }
      if (!data.width && !data.height && !data.left && data.top) {
        data.top = null;
      } else if (!data.width && !data.height && !data.top && data.left) {
        data.left = null;
      }
      return data;
    },
    _getPaddingPlusBorderDimensions: function(element) {
      var i = 0, widths = [], borders = [ element.css("borderTopWidth"), element.css("borderRightWidth"), element.css("borderBottomWidth"), element.css("borderLeftWidth") ], paddings = [ element.css("paddingTop"), element.css("paddingRight"), element.css("paddingBottom"), element.css("paddingLeft") ];
      for (;i < 4; i++) {
        widths[i] = parseFloat(borders[i]) || 0;
        widths[i] += parseFloat(paddings[i]) || 0;
      }
      return {
        height: widths[0] + widths[2],
        width: widths[1] + widths[3]
      };
    },
    _proportionallyResize: function() {
      if (!this._proportionallyResizeElements.length) {
        return;
      }
      var prel, i = 0, element = this.helper || this.element;
      for (;i < this._proportionallyResizeElements.length; i++) {
        prel = this._proportionallyResizeElements[i];
        if (!this.outerDimensions) {
          this.outerDimensions = this._getPaddingPlusBorderDimensions(prel);
        }
        prel.css({
          height: element.height() - this.outerDimensions.height || 0,
          width: element.width() - this.outerDimensions.width || 0
        });
      }
    },
    _renderProxy: function() {
      var el = this.element, o = this.options;
      this.elementOffset = el.offset();
      if (this._helper) {
        this.helper = this.helper || $("<div></div>").css({
          overflow: "hidden"
        });
        this._addClass(this.helper, this._helper);
        this.helper.css({
          width: this.element.outerWidth(),
          height: this.element.outerHeight(),
          position: "absolute",
          left: this.elementOffset.left + "px",
          top: this.elementOffset.top + "px",
          zIndex: ++o.zIndex
        });
        this.helper.appendTo("body").disableSelection();
      } else {
        this.helper = this.element;
      }
    },
    _change: {
      e: function(event, dx) {
        return {
          width: this.originalSize.width + dx
        };
      },
      w: function(event, dx) {
        var cs = this.originalSize, sp = this.originalPosition;
        return {
          left: sp.left + dx,
          width: cs.width - dx
        };
      },
      n: function(event, dx, dy) {
        var cs = this.originalSize, sp = this.originalPosition;
        return {
          top: sp.top + dy,
          height: cs.height - dy
        };
      },
      s: function(event, dx, dy) {
        return {
          height: this.originalSize.height + dy
        };
      },
      se: function(event, dx, dy) {
        return $.extend(this._change.s.apply(this, arguments), this._change.e.apply(this, [ event, dx, dy ]));
      },
      sw: function(event, dx, dy) {
        return $.extend(this._change.s.apply(this, arguments), this._change.w.apply(this, [ event, dx, dy ]));
      },
      ne: function(event, dx, dy) {
        return $.extend(this._change.n.apply(this, arguments), this._change.e.apply(this, [ event, dx, dy ]));
      },
      nw: function(event, dx, dy) {
        return $.extend(this._change.n.apply(this, arguments), this._change.w.apply(this, [ event, dx, dy ]));
      }
    },
    _propagate: function(n, event) {
      $.ui.plugin.call(this, n, [ event, this.ui() ]);
      if (n !== "resize") {
        this._trigger(n, event, this.ui());
      }
    },
    plugins: {},
    ui: function() {
      return {
        originalElement: this.originalElement,
        element: this.element,
        helper: this.helper,
        position: this.position,
        size: this.size,
        originalSize: this.originalSize,
        originalPosition: this.originalPosition
      };
    }
  });
  $.ui.plugin.add("resizable", "animate", {
    stop: function(event) {
      var that = $(this).resizable("instance"), o = that.options, pr = that._proportionallyResizeElements, ista = pr.length && /textarea/i.test(pr[0].nodeName), soffseth = ista && that._hasScroll(pr[0], "left") ? 0 : that.sizeDiff.height, soffsetw = ista ? 0 : that.sizeDiff.width, style = {
        width: that.size.width - soffsetw,
        height: that.size.height - soffseth
      }, left = parseFloat(that.element.css("left")) + (that.position.left - that.originalPosition.left) || null, top = parseFloat(that.element.css("top")) + (that.position.top - that.originalPosition.top) || null;
      that.element.animate($.extend(style, top && left ? {
        top: top,
        left: left
      } : {}), {
        duration: o.animateDuration,
        easing: o.animateEasing,
        step: function() {
          var data = {
            width: parseFloat(that.element.css("width")),
            height: parseFloat(that.element.css("height")),
            top: parseFloat(that.element.css("top")),
            left: parseFloat(that.element.css("left"))
          };
          if (pr && pr.length) {
            $(pr[0]).css({
              width: data.width,
              height: data.height
            });
          }
          that._updateCache(data);
          that._propagate("resize", event);
        }
      });
    }
  });
  $.ui.plugin.add("resizable", "containment", {
    start: function() {
      var element, p, co, ch, cw, width, height, that = $(this).resizable("instance"), o = that.options, el = that.element, oc = o.containment, ce = oc instanceof $ ? oc.get(0) : /parent/.test(oc) ? el.parent().get(0) : oc;
      if (!ce) {
        return;
      }
      that.containerElement = $(ce);
      if (/document/.test(oc) || oc === document) {
        that.containerOffset = {
          left: 0,
          top: 0
        };
        that.containerPosition = {
          left: 0,
          top: 0
        };
        that.parentData = {
          element: $(document),
          left: 0,
          top: 0,
          width: $(document).width(),
          height: $(document).height() || document.body.parentNode.scrollHeight
        };
      } else {
        element = $(ce);
        p = [];
        $([ "Top", "Right", "Left", "Bottom" ]).each((function(i, name) {
          p[i] = that._num(element.css("padding" + name));
        }));
        that.containerOffset = element.offset();
        that.containerPosition = element.position();
        that.containerSize = {
          height: element.innerHeight() - p[3],
          width: element.innerWidth() - p[1]
        };
        co = that.containerOffset;
        ch = that.containerSize.height;
        cw = that.containerSize.width;
        width = that._hasScroll(ce, "left") ? ce.scrollWidth : cw;
        height = that._hasScroll(ce) ? ce.scrollHeight : ch;
        that.parentData = {
          element: ce,
          left: co.left,
          top: co.top,
          width: width,
          height: height
        };
      }
    },
    resize: function(event) {
      var woset, hoset, isParent, isOffsetRelative, that = $(this).resizable("instance"), o = that.options, co = that.containerOffset, cp = that.position, pRatio = that._aspectRatio || event.shiftKey, cop = {
        top: 0,
        left: 0
      }, ce = that.containerElement, continueResize = true;
      if (ce[0] !== document && /static/.test(ce.css("position"))) {
        cop = co;
      }
      if (cp.left < (that._helper ? co.left : 0)) {
        that.size.width = that.size.width + (that._helper ? that.position.left - co.left : that.position.left - cop.left);
        if (pRatio) {
          that.size.height = that.size.width / that.aspectRatio;
          continueResize = false;
        }
        that.position.left = o.helper ? co.left : 0;
      }
      if (cp.top < (that._helper ? co.top : 0)) {
        that.size.height = that.size.height + (that._helper ? that.position.top - co.top : that.position.top);
        if (pRatio) {
          that.size.width = that.size.height * that.aspectRatio;
          continueResize = false;
        }
        that.position.top = that._helper ? co.top : 0;
      }
      isParent = that.containerElement.get(0) === that.element.parent().get(0);
      isOffsetRelative = /relative|absolute/.test(that.containerElement.css("position"));
      if (isParent && isOffsetRelative) {
        that.offset.left = that.parentData.left + that.position.left;
        that.offset.top = that.parentData.top + that.position.top;
      } else {
        that.offset.left = that.element.offset().left;
        that.offset.top = that.element.offset().top;
      }
      woset = Math.abs(that.sizeDiff.width + (that._helper ? that.offset.left - cop.left : that.offset.left - co.left));
      hoset = Math.abs(that.sizeDiff.height + (that._helper ? that.offset.top - cop.top : that.offset.top - co.top));
      if (woset + that.size.width >= that.parentData.width) {
        that.size.width = that.parentData.width - woset;
        if (pRatio) {
          that.size.height = that.size.width / that.aspectRatio;
          continueResize = false;
        }
      }
      if (hoset + that.size.height >= that.parentData.height) {
        that.size.height = that.parentData.height - hoset;
        if (pRatio) {
          that.size.width = that.size.height * that.aspectRatio;
          continueResize = false;
        }
      }
      if (!continueResize) {
        that.position.left = that.prevPosition.left;
        that.position.top = that.prevPosition.top;
        that.size.width = that.prevSize.width;
        that.size.height = that.prevSize.height;
      }
    },
    stop: function() {
      var that = $(this).resizable("instance"), o = that.options, co = that.containerOffset, cop = that.containerPosition, ce = that.containerElement, helper = $(that.helper), ho = helper.offset(), w = helper.outerWidth() - that.sizeDiff.width, h = helper.outerHeight() - that.sizeDiff.height;
      if (that._helper && !o.animate && /relative/.test(ce.css("position"))) {
        $(this).css({
          left: ho.left - cop.left - co.left,
          width: w,
          height: h
        });
      }
      if (that._helper && !o.animate && /static/.test(ce.css("position"))) {
        $(this).css({
          left: ho.left - cop.left - co.left,
          width: w,
          height: h
        });
      }
    }
  });
  $.ui.plugin.add("resizable", "alsoResize", {
    start: function() {
      var that = $(this).resizable("instance"), o = that.options;
      $(o.alsoResize).each((function() {
        var el = $(this);
        el.data("ui-resizable-alsoresize", {
          width: parseFloat(el.css("width")),
          height: parseFloat(el.css("height")),
          left: parseFloat(el.css("left")),
          top: parseFloat(el.css("top"))
        });
      }));
    },
    resize: function(event, ui) {
      var that = $(this).resizable("instance"), o = that.options, os = that.originalSize, op = that.originalPosition, delta = {
        height: that.size.height - os.height || 0,
        width: that.size.width - os.width || 0,
        top: that.position.top - op.top || 0,
        left: that.position.left - op.left || 0
      };
      $(o.alsoResize).each((function() {
        var el = $(this), start = $(this).data("ui-resizable-alsoresize"), style = {}, css = el.parents(ui.originalElement[0]).length ? [ "width", "height" ] : [ "width", "height", "top", "left" ];
        $.each(css, (function(i, prop) {
          var sum = (start[prop] || 0) + (delta[prop] || 0);
          if (sum && sum >= 0) {
            style[prop] = sum || null;
          }
        }));
        el.css(style);
      }));
    },
    stop: function() {
      $(this).removeData("ui-resizable-alsoresize");
    }
  });
  $.ui.plugin.add("resizable", "ghost", {
    start: function() {
      var that = $(this).resizable("instance"), cs = that.size;
      that.ghost = that.originalElement.clone();
      that.ghost.css({
        opacity: .25,
        display: "block",
        position: "relative",
        height: cs.height,
        width: cs.width,
        margin: 0,
        left: 0,
        top: 0
      });
      that._addClass(that.ghost, "ui-resizable-ghost");
      if ($.uiBackCompat === true && typeof that.options.ghost === "string") {
        that.ghost.addClass(this.options.ghost);
      }
      that.ghost.appendTo(that.helper);
    },
    resize: function() {
      var that = $(this).resizable("instance");
      if (that.ghost) {
        that.ghost.css({
          position: "relative",
          height: that.size.height,
          width: that.size.width
        });
      }
    },
    stop: function() {
      var that = $(this).resizable("instance");
      if (that.ghost && that.helper) {
        that.helper.get(0).removeChild(that.ghost.get(0));
      }
    }
  });
  $.ui.plugin.add("resizable", "grid", {
    resize: function() {
      var outerDimensions, that = $(this).resizable("instance"), o = that.options, cs = that.size, os = that.originalSize, op = that.originalPosition, a = that.axis, grid = typeof o.grid === "number" ? [ o.grid, o.grid ] : o.grid, gridX = grid[0] || 1, gridY = grid[1] || 1, ox = Math.round((cs.width - os.width) / gridX) * gridX, oy = Math.round((cs.height - os.height) / gridY) * gridY, newWidth = os.width + ox, newHeight = os.height + oy, isMaxWidth = o.maxWidth && o.maxWidth < newWidth, isMaxHeight = o.maxHeight && o.maxHeight < newHeight, isMinWidth = o.minWidth && o.minWidth > newWidth, isMinHeight = o.minHeight && o.minHeight > newHeight;
      o.grid = grid;
      if (isMinWidth) {
        newWidth += gridX;
      }
      if (isMinHeight) {
        newHeight += gridY;
      }
      if (isMaxWidth) {
        newWidth -= gridX;
      }
      if (isMaxHeight) {
        newHeight -= gridY;
      }
      if (/^(se|s|e)$/.test(a)) {
        that.size.width = newWidth;
        that.size.height = newHeight;
      } else if (/^(ne)$/.test(a)) {
        that.size.width = newWidth;
        that.size.height = newHeight;
        that.position.top = op.top - oy;
      } else if (/^(sw)$/.test(a)) {
        that.size.width = newWidth;
        that.size.height = newHeight;
        that.position.left = op.left - ox;
      } else {
        if (newHeight - gridY <= 0 || newWidth - gridX <= 0) {
          outerDimensions = that._getPaddingPlusBorderDimensions(this);
        }
        if (newHeight - gridY > 0) {
          that.size.height = newHeight;
          that.position.top = op.top - oy;
        } else {
          newHeight = gridY - outerDimensions.height;
          that.size.height = newHeight;
          that.position.top = op.top + os.height - newHeight;
        }
        if (newWidth - gridX > 0) {
          that.size.width = newWidth;
          that.position.left = op.left - ox;
        } else {
          newWidth = gridX - outerDimensions.width;
          that.size.width = newWidth;
          that.position.left = op.left + os.width - newWidth;
        }
      }
    }
  });
  $.ui.resizable;
  /*!
 * jQuery UI Sortable 1.14.0
 * https://jqueryui.com
 *
 * Copyright OpenJS Foundation and other contributors
 * Released under the MIT license.
 * https://jquery.org/license
 */  $.widget("ui.sortable", $.ui.mouse, {
    version: "1.14.0",
    widgetEventPrefix: "sort",
    ready: false,
    options: {
      appendTo: "parent",
      axis: false,
      connectWith: false,
      containment: false,
      cursor: "auto",
      cursorAt: false,
      dropOnEmpty: true,
      forcePlaceholderSize: false,
      forceHelperSize: false,
      grid: false,
      handle: false,
      helper: "original",
      items: "> *",
      opacity: false,
      placeholder: false,
      revert: false,
      scroll: true,
      scrollSensitivity: 20,
      scrollSpeed: 20,
      scope: "default",
      tolerance: "intersect",
      zIndex: 1e3,
      activate: null,
      beforeStop: null,
      change: null,
      deactivate: null,
      out: null,
      over: null,
      receive: null,
      remove: null,
      sort: null,
      start: null,
      stop: null,
      update: null
    },
    _isOverAxis: function(x, reference, size) {
      return x >= reference && x < reference + size;
    },
    _isFloating: function(item) {
      return /left|right/.test(item.css("float")) || /inline|table-cell/.test(item.css("display"));
    },
    _create: function() {
      this.containerCache = {};
      this._addClass("ui-sortable");
      this.refresh();
      this.offset = this.element.offset();
      this._mouseInit();
      this._setHandleClassName();
      this.ready = true;
    },
    _setOption: function(key, value) {
      this._super(key, value);
      if (key === "handle") {
        this._setHandleClassName();
      }
    },
    _setHandleClassName: function() {
      var that = this;
      this._removeClass(this.element.find(".ui-sortable-handle"), "ui-sortable-handle");
      $.each(this.items, (function() {
        that._addClass(this.instance.options.handle ? this.item.find(this.instance.options.handle) : this.item, "ui-sortable-handle");
      }));
    },
    _destroy: function() {
      this._mouseDestroy();
      for (var i = this.items.length - 1; i >= 0; i--) {
        this.items[i].item.removeData(this.widgetName + "-item");
      }
      return this;
    },
    _mouseCapture: function(event, overrideHandle) {
      var currentItem = null, validHandle = false, that = this;
      if (this.reverting) {
        return false;
      }
      if (this.options.disabled || this.options.type === "static") {
        return false;
      }
      this._refreshItems(event);
      $(event.target).parents().each((function() {
        if ($.data(this, that.widgetName + "-item") === that) {
          currentItem = $(this);
          return false;
        }
      }));
      if ($.data(event.target, that.widgetName + "-item") === that) {
        currentItem = $(event.target);
      }
      if (!currentItem) {
        return false;
      }
      if (this.options.handle && !overrideHandle) {
        $(this.options.handle, currentItem).find("*").addBack().each((function() {
          if (this === event.target) {
            validHandle = true;
          }
        }));
        if (!validHandle) {
          return false;
        }
      }
      this.currentItem = currentItem;
      this._removeCurrentsFromItems();
      return true;
    },
    _mouseStart: function(event, overrideHandle, noActivation) {
      var i, body, o = this.options;
      this.currentContainer = this;
      this.refreshPositions();
      this.appendTo = $(o.appendTo !== "parent" ? o.appendTo : this.currentItem.parent());
      this.helper = this._createHelper(event);
      this._cacheHelperProportions();
      this._cacheMargins();
      this.offset = this.currentItem.offset();
      this.offset = {
        top: this.offset.top - this.margins.top,
        left: this.offset.left - this.margins.left
      };
      $.extend(this.offset, {
        click: {
          left: event.pageX - this.offset.left,
          top: event.pageY - this.offset.top
        },
        relative: this._getRelativeOffset()
      });
      this.helper.css("position", "absolute");
      this.cssPosition = this.helper.css("position");
      if (o.cursorAt) {
        this._adjustOffsetFromHelper(o.cursorAt);
      }
      this.domPosition = {
        prev: this.currentItem.prev()[0],
        parent: this.currentItem.parent()[0]
      };
      if (this.helper[0] !== this.currentItem[0]) {
        this.currentItem.hide();
      }
      this._createPlaceholder();
      this.scrollParent = this.placeholder.scrollParent();
      $.extend(this.offset, {
        parent: this._getParentOffset()
      });
      if (o.containment) {
        this._setContainment();
      }
      if (o.cursor && o.cursor !== "auto") {
        body = this.document.find("body");
        this._storedStylesheet = $("<style>*{ cursor: " + o.cursor + " !important; }</style>").appendTo(body);
      }
      if (o.zIndex) {
        if (this.helper.css("zIndex")) {
          this._storedZIndex = this.helper.css("zIndex");
        }
        this.helper.css("zIndex", o.zIndex);
      }
      if (o.opacity) {
        if (this.helper.css("opacity")) {
          this._storedOpacity = this.helper.css("opacity");
        }
        this.helper.css("opacity", o.opacity);
      }
      if (this.scrollParent[0] !== this.document[0] && this.scrollParent[0].tagName !== "HTML") {
        this.overflowOffset = this.scrollParent.offset();
      }
      this._trigger("start", event, this._uiHash());
      if (!this._preserveHelperProportions) {
        this._cacheHelperProportions();
      }
      if (!noActivation) {
        for (i = this.containers.length - 1; i >= 0; i--) {
          this.containers[i]._trigger("activate", event, this._uiHash(this));
        }
      }
      if ($.ui.ddmanager) {
        $.ui.ddmanager.current = this;
      }
      if ($.ui.ddmanager && !o.dropBehaviour) {
        $.ui.ddmanager.prepareOffsets(this, event);
      }
      this.dragging = true;
      this._addClass(this.helper, "ui-sortable-helper");
      if (!this.helper.parent().is(this.appendTo)) {
        this.helper.detach().appendTo(this.appendTo);
        this.offset.parent = this._getParentOffset();
      }
      this.position = this.originalPosition = this._generatePosition(event);
      this.originalPageX = event.pageX;
      this.originalPageY = event.pageY;
      this.lastPositionAbs = this.positionAbs = this._convertPositionTo("absolute");
      this._mouseDrag(event);
      return true;
    },
    _scroll: function(event) {
      var o = this.options, scrolled = false;
      if (this.scrollParent[0] !== this.document[0] && this.scrollParent[0].tagName !== "HTML") {
        if (this.overflowOffset.top + this.scrollParent[0].offsetHeight - event.pageY < o.scrollSensitivity) {
          this.scrollParent[0].scrollTop = scrolled = this.scrollParent[0].scrollTop + o.scrollSpeed;
        } else if (event.pageY - this.overflowOffset.top < o.scrollSensitivity) {
          this.scrollParent[0].scrollTop = scrolled = this.scrollParent[0].scrollTop - o.scrollSpeed;
        }
        if (this.overflowOffset.left + this.scrollParent[0].offsetWidth - event.pageX < o.scrollSensitivity) {
          this.scrollParent[0].scrollLeft = scrolled = this.scrollParent[0].scrollLeft + o.scrollSpeed;
        } else if (event.pageX - this.overflowOffset.left < o.scrollSensitivity) {
          this.scrollParent[0].scrollLeft = scrolled = this.scrollParent[0].scrollLeft - o.scrollSpeed;
        }
      } else {
        if (event.pageY - this.document.scrollTop() < o.scrollSensitivity) {
          scrolled = this.document.scrollTop(this.document.scrollTop() - o.scrollSpeed);
        } else if (this.window.height() - (event.pageY - this.document.scrollTop()) < o.scrollSensitivity) {
          scrolled = this.document.scrollTop(this.document.scrollTop() + o.scrollSpeed);
        }
        if (event.pageX - this.document.scrollLeft() < o.scrollSensitivity) {
          scrolled = this.document.scrollLeft(this.document.scrollLeft() - o.scrollSpeed);
        } else if (this.window.width() - (event.pageX - this.document.scrollLeft()) < o.scrollSensitivity) {
          scrolled = this.document.scrollLeft(this.document.scrollLeft() + o.scrollSpeed);
        }
      }
      return scrolled;
    },
    _mouseDrag: function(event) {
      var i, item, itemElement, intersection, o = this.options;
      this.position = this._generatePosition(event);
      this.positionAbs = this._convertPositionTo("absolute");
      if (!this.options.axis || this.options.axis !== "y") {
        this.helper[0].style.left = this.position.left + "px";
      }
      if (!this.options.axis || this.options.axis !== "x") {
        this.helper[0].style.top = this.position.top + "px";
      }
      if (o.scroll) {
        if (this._scroll(event) !== false) {
          this._refreshItemPositions(true);
          if ($.ui.ddmanager && !o.dropBehaviour) {
            $.ui.ddmanager.prepareOffsets(this, event);
          }
        }
      }
      this.dragDirection = {
        vertical: this._getDragVerticalDirection(),
        horizontal: this._getDragHorizontalDirection()
      };
      for (i = this.items.length - 1; i >= 0; i--) {
        item = this.items[i];
        itemElement = item.item[0];
        intersection = this._intersectsWithPointer(item);
        if (!intersection) {
          continue;
        }
        if (item.instance !== this.currentContainer) {
          continue;
        }
        if (itemElement !== this.currentItem[0] && this.placeholder[intersection === 1 ? "next" : "prev"]()[0] !== itemElement && !$.contains(this.placeholder[0], itemElement) && (this.options.type === "semi-dynamic" ? !$.contains(this.element[0], itemElement) : true)) {
          this.direction = intersection === 1 ? "down" : "up";
          if (this.options.tolerance === "pointer" || this._intersectsWithSides(item)) {
            this._rearrange(event, item);
          } else {
            break;
          }
          this._trigger("change", event, this._uiHash());
          break;
        }
      }
      this._contactContainers(event);
      if ($.ui.ddmanager) {
        $.ui.ddmanager.drag(this, event);
      }
      this._trigger("sort", event, this._uiHash());
      this.lastPositionAbs = this.positionAbs;
      return false;
    },
    _mouseStop: function(event, noPropagation) {
      if (!event) {
        return;
      }
      if ($.ui.ddmanager && !this.options.dropBehaviour) {
        $.ui.ddmanager.drop(this, event);
      }
      if (this.options.revert) {
        var that = this, cur = this.placeholder.offset(), axis = this.options.axis, animation = {};
        if (!axis || axis === "x") {
          animation.left = cur.left - this.offset.parent.left - this.margins.left + (this.offsetParent[0] === this.document[0].body ? 0 : this.offsetParent[0].scrollLeft);
        }
        if (!axis || axis === "y") {
          animation.top = cur.top - this.offset.parent.top - this.margins.top + (this.offsetParent[0] === this.document[0].body ? 0 : this.offsetParent[0].scrollTop);
        }
        this.reverting = true;
        $(this.helper).animate(animation, parseInt(this.options.revert, 10) || 500, (function() {
          that._clear(event);
        }));
      } else {
        this._clear(event, noPropagation);
      }
      return false;
    },
    cancel: function() {
      if (this.dragging) {
        this._mouseUp(new $.Event("mouseup", {
          target: null
        }));
        if (this.options.helper === "original") {
          this.currentItem.css(this._storedCSS);
          this._removeClass(this.currentItem, "ui-sortable-helper");
        } else {
          this.currentItem.show();
        }
        for (var i = this.containers.length - 1; i >= 0; i--) {
          this.containers[i]._trigger("deactivate", null, this._uiHash(this));
          if (this.containers[i].containerCache.over) {
            this.containers[i]._trigger("out", null, this._uiHash(this));
            this.containers[i].containerCache.over = 0;
          }
        }
      }
      if (this.placeholder) {
        if (this.placeholder[0].parentNode) {
          this.placeholder[0].parentNode.removeChild(this.placeholder[0]);
        }
        if (this.options.helper !== "original" && this.helper && this.helper[0].parentNode) {
          this.helper.remove();
        }
        $.extend(this, {
          helper: null,
          dragging: false,
          reverting: false,
          _noFinalSort: null
        });
        if (this.domPosition.prev) {
          $(this.domPosition.prev).after(this.currentItem);
        } else {
          $(this.domPosition.parent).prepend(this.currentItem);
        }
      }
      return this;
    },
    serialize: function(o) {
      var items = this._getItemsAsjQuery(o && o.connected), str = [];
      o = o || {};
      $(items).each((function() {
        var res = ($(o.item || this).attr(o.attribute || "id") || "").match(o.expression || /(.+)[\-=_](.+)/);
        if (res) {
          str.push((o.key || res[1] + "[]") + "=" + (o.key && o.expression ? res[1] : res[2]));
        }
      }));
      if (!str.length && o.key) {
        str.push(o.key + "=");
      }
      return str.join("&");
    },
    toArray: function(o) {
      var items = this._getItemsAsjQuery(o && o.connected), ret = [];
      o = o || {};
      items.each((function() {
        ret.push($(o.item || this).attr(o.attribute || "id") || "");
      }));
      return ret;
    },
    _intersectsWith: function(item) {
      var x1 = this.positionAbs.left, x2 = x1 + this.helperProportions.width, y1 = this.positionAbs.top, y2 = y1 + this.helperProportions.height, l = item.left, r = l + item.width, t = item.top, b = t + item.height, dyClick = this.offset.click.top, dxClick = this.offset.click.left, isOverElementHeight = this.options.axis === "x" || y1 + dyClick > t && y1 + dyClick < b, isOverElementWidth = this.options.axis === "y" || x1 + dxClick > l && x1 + dxClick < r, isOverElement = isOverElementHeight && isOverElementWidth;
      if (this.options.tolerance === "pointer" || this.options.forcePointerForContainers || this.options.tolerance !== "pointer" && this.helperProportions[this.floating ? "width" : "height"] > item[this.floating ? "width" : "height"]) {
        return isOverElement;
      } else {
        return l < x1 + this.helperProportions.width / 2 && x2 - this.helperProportions.width / 2 < r && t < y1 + this.helperProportions.height / 2 && y2 - this.helperProportions.height / 2 < b;
      }
    },
    _intersectsWithPointer: function(item) {
      var verticalDirection, horizontalDirection, isOverElementHeight = this.options.axis === "x" || this._isOverAxis(this.positionAbs.top + this.offset.click.top, item.top, item.height), isOverElementWidth = this.options.axis === "y" || this._isOverAxis(this.positionAbs.left + this.offset.click.left, item.left, item.width), isOverElement = isOverElementHeight && isOverElementWidth;
      if (!isOverElement) {
        return false;
      }
      verticalDirection = this.dragDirection.vertical;
      horizontalDirection = this.dragDirection.horizontal;
      return this.floating ? horizontalDirection === "right" || verticalDirection === "down" ? 2 : 1 : verticalDirection && (verticalDirection === "down" ? 2 : 1);
    },
    _intersectsWithSides: function(item) {
      var isOverBottomHalf = this._isOverAxis(this.positionAbs.top + this.offset.click.top, item.top + item.height / 2, item.height), isOverRightHalf = this._isOverAxis(this.positionAbs.left + this.offset.click.left, item.left + item.width / 2, item.width), verticalDirection = this.dragDirection.vertical, horizontalDirection = this.dragDirection.horizontal;
      if (this.floating && horizontalDirection) {
        return horizontalDirection === "right" && isOverRightHalf || horizontalDirection === "left" && !isOverRightHalf;
      } else {
        return verticalDirection && (verticalDirection === "down" && isOverBottomHalf || verticalDirection === "up" && !isOverBottomHalf);
      }
    },
    _getDragVerticalDirection: function() {
      var delta = this.positionAbs.top - this.lastPositionAbs.top;
      return delta !== 0 && (delta > 0 ? "down" : "up");
    },
    _getDragHorizontalDirection: function() {
      var delta = this.positionAbs.left - this.lastPositionAbs.left;
      return delta !== 0 && (delta > 0 ? "right" : "left");
    },
    refresh: function(event) {
      this._refreshItems(event);
      this._setHandleClassName();
      this.refreshPositions();
      return this;
    },
    _connectWith: function() {
      var options = this.options;
      return options.connectWith.constructor === String ? [ options.connectWith ] : options.connectWith;
    },
    _getItemsAsjQuery: function(connected) {
      var i, j, cur, inst, items = [], queries = [], connectWith = this._connectWith();
      if (connectWith && connected) {
        for (i = connectWith.length - 1; i >= 0; i--) {
          cur = $(connectWith[i], this.document[0]);
          for (j = cur.length - 1; j >= 0; j--) {
            inst = $.data(cur[j], this.widgetFullName);
            if (inst && inst !== this && !inst.options.disabled) {
              queries.push([ typeof inst.options.items === "function" ? inst.options.items.call(inst.element) : $(inst.options.items, inst.element).not(".ui-sortable-helper").not(".ui-sortable-placeholder"), inst ]);
            }
          }
        }
      }
      queries.push([ typeof this.options.items === "function" ? this.options.items.call(this.element, null, {
        options: this.options,
        item: this.currentItem
      }) : $(this.options.items, this.element).not(".ui-sortable-helper").not(".ui-sortable-placeholder"), this ]);
      function addItems() {
        items.push(this);
      }
      for (i = queries.length - 1; i >= 0; i--) {
        queries[i][0].each(addItems);
      }
      return $(items);
    },
    _removeCurrentsFromItems: function() {
      var list = this.currentItem.find(":data(" + this.widgetName + "-item)");
      this.items = $.grep(this.items, (function(item) {
        for (var j = 0; j < list.length; j++) {
          if (list[j] === item.item[0]) {
            return false;
          }
        }
        return true;
      }));
    },
    _refreshItems: function(event) {
      this.items = [];
      this.containers = [ this ];
      var i, j, cur, inst, targetData, _queries, item, queriesLength, items = this.items, queries = [ [ typeof this.options.items === "function" ? this.options.items.call(this.element[0], event, {
        item: this.currentItem
      }) : $(this.options.items, this.element), this ] ], connectWith = this._connectWith();
      if (connectWith && this.ready) {
        for (i = connectWith.length - 1; i >= 0; i--) {
          cur = $(connectWith[i], this.document[0]);
          for (j = cur.length - 1; j >= 0; j--) {
            inst = $.data(cur[j], this.widgetFullName);
            if (inst && inst !== this && !inst.options.disabled) {
              queries.push([ typeof inst.options.items === "function" ? inst.options.items.call(inst.element[0], event, {
                item: this.currentItem
              }) : $(inst.options.items, inst.element), inst ]);
              this.containers.push(inst);
            }
          }
        }
      }
      for (i = queries.length - 1; i >= 0; i--) {
        targetData = queries[i][1];
        _queries = queries[i][0];
        for (j = 0, queriesLength = _queries.length; j < queriesLength; j++) {
          item = $(_queries[j]);
          item.data(this.widgetName + "-item", targetData);
          items.push({
            item: item,
            instance: targetData,
            width: 0,
            height: 0,
            left: 0,
            top: 0
          });
        }
      }
    },
    _refreshItemPositions: function(fast) {
      var i, item, t, p;
      for (i = this.items.length - 1; i >= 0; i--) {
        item = this.items[i];
        if (this.currentContainer && item.instance !== this.currentContainer && item.item[0] !== this.currentItem[0]) {
          continue;
        }
        t = this.options.toleranceElement ? $(this.options.toleranceElement, item.item) : item.item;
        if (!fast) {
          item.width = t.outerWidth();
          item.height = t.outerHeight();
        }
        p = t.offset();
        item.left = p.left;
        item.top = p.top;
      }
    },
    refreshPositions: function(fast) {
      this.floating = this.items.length ? this.options.axis === "x" || this._isFloating(this.items[0].item) : false;
      if (this.offsetParent && this.helper) {
        this.offset.parent = this._getParentOffset();
      }
      this._refreshItemPositions(fast);
      var i, p;
      if (this.options.custom && this.options.custom.refreshContainers) {
        this.options.custom.refreshContainers.call(this);
      } else {
        for (i = this.containers.length - 1; i >= 0; i--) {
          p = this.containers[i].element.offset();
          this.containers[i].containerCache.left = p.left;
          this.containers[i].containerCache.top = p.top;
          this.containers[i].containerCache.width = this.containers[i].element.outerWidth();
          this.containers[i].containerCache.height = this.containers[i].element.outerHeight();
        }
      }
      return this;
    },
    _createPlaceholder: function(that) {
      that = that || this;
      var className, nodeName, o = that.options;
      if (!o.placeholder || o.placeholder.constructor === String) {
        className = o.placeholder;
        nodeName = that.currentItem[0].nodeName.toLowerCase();
        o.placeholder = {
          element: function() {
            var element = $("<" + nodeName + ">", that.document[0]);
            that._addClass(element, "ui-sortable-placeholder", className || that.currentItem[0].className)._removeClass(element, "ui-sortable-helper");
            if (nodeName === "tbody") {
              that._createTrPlaceholder(that.currentItem.find("tr").eq(0), $("<tr>", that.document[0]).appendTo(element));
            } else if (nodeName === "tr") {
              that._createTrPlaceholder(that.currentItem, element);
            } else if (nodeName === "img") {
              element.attr("src", that.currentItem.attr("src"));
            }
            if (!className) {
              element.css("visibility", "hidden");
            }
            return element;
          },
          update: function(container, p) {
            if (className && !o.forcePlaceholderSize) {
              return;
            }
            if (!p.height() || o.forcePlaceholderSize && (nodeName === "tbody" || nodeName === "tr")) {
              p.height(that.currentItem.innerHeight() - parseInt(that.currentItem.css("paddingTop") || 0, 10) - parseInt(that.currentItem.css("paddingBottom") || 0, 10));
            }
            if (!p.width()) {
              p.width(that.currentItem.innerWidth() - parseInt(that.currentItem.css("paddingLeft") || 0, 10) - parseInt(that.currentItem.css("paddingRight") || 0, 10));
            }
          }
        };
      }
      that.placeholder = $(o.placeholder.element.call(that.element, that.currentItem));
      that.currentItem.after(that.placeholder);
      o.placeholder.update(that, that.placeholder);
    },
    _createTrPlaceholder: function(sourceTr, targetTr) {
      var that = this;
      sourceTr.children().each((function() {
        $("<td>&#160;</td>", that.document[0]).attr("colspan", $(this).attr("colspan") || 1).appendTo(targetTr);
      }));
    },
    _contactContainers: function(event) {
      var i, j, dist, itemWithLeastDistance, posProperty, sizeProperty, cur, nearBottom, floating, axis, innermostContainer = null, innermostIndex = null;
      for (i = this.containers.length - 1; i >= 0; i--) {
        if ($.contains(this.currentItem[0], this.containers[i].element[0])) {
          continue;
        }
        if (this._intersectsWith(this.containers[i].containerCache)) {
          if (innermostContainer && $.contains(this.containers[i].element[0], innermostContainer.element[0])) {
            continue;
          }
          innermostContainer = this.containers[i];
          innermostIndex = i;
        } else {
          if (this.containers[i].containerCache.over) {
            this.containers[i]._trigger("out", event, this._uiHash(this));
            this.containers[i].containerCache.over = 0;
          }
        }
      }
      if (!innermostContainer) {
        return;
      }
      if (this.containers.length === 1) {
        if (!this.containers[innermostIndex].containerCache.over) {
          this.containers[innermostIndex]._trigger("over", event, this._uiHash(this));
          this.containers[innermostIndex].containerCache.over = 1;
        }
      } else {
        dist = 1e4;
        itemWithLeastDistance = null;
        floating = innermostContainer.floating || this._isFloating(this.currentItem);
        posProperty = floating ? "left" : "top";
        sizeProperty = floating ? "width" : "height";
        axis = floating ? "pageX" : "pageY";
        for (j = this.items.length - 1; j >= 0; j--) {
          if (!$.contains(this.containers[innermostIndex].element[0], this.items[j].item[0])) {
            continue;
          }
          if (this.items[j].item[0] === this.currentItem[0]) {
            continue;
          }
          cur = this.items[j].item.offset()[posProperty];
          nearBottom = false;
          if (event[axis] - cur > this.items[j][sizeProperty] / 2) {
            nearBottom = true;
          }
          if (Math.abs(event[axis] - cur) < dist) {
            dist = Math.abs(event[axis] - cur);
            itemWithLeastDistance = this.items[j];
            this.direction = nearBottom ? "up" : "down";
          }
        }
        if (!itemWithLeastDistance && !this.options.dropOnEmpty) {
          return;
        }
        if (this.currentContainer === this.containers[innermostIndex]) {
          if (!this.currentContainer.containerCache.over) {
            this.containers[innermostIndex]._trigger("over", event, this._uiHash());
            this.currentContainer.containerCache.over = 1;
          }
          return;
        }
        if (itemWithLeastDistance) {
          this._rearrange(event, itemWithLeastDistance, null, true);
        } else {
          this._rearrange(event, null, this.containers[innermostIndex].element, true);
        }
        this._trigger("change", event, this._uiHash());
        this.containers[innermostIndex]._trigger("change", event, this._uiHash(this));
        this.currentContainer = this.containers[innermostIndex];
        this.options.placeholder.update(this.currentContainer, this.placeholder);
        this.scrollParent = this.placeholder.scrollParent();
        if (this.scrollParent[0] !== this.document[0] && this.scrollParent[0].tagName !== "HTML") {
          this.overflowOffset = this.scrollParent.offset();
        }
        this.containers[innermostIndex]._trigger("over", event, this._uiHash(this));
        this.containers[innermostIndex].containerCache.over = 1;
      }
    },
    _createHelper: function(event) {
      var o = this.options, helper = typeof o.helper === "function" ? $(o.helper.apply(this.element[0], [ event, this.currentItem ])) : o.helper === "clone" ? this.currentItem.clone() : this.currentItem;
      if (!helper.parents("body").length) {
        this.appendTo[0].appendChild(helper[0]);
      }
      if (helper[0] === this.currentItem[0]) {
        this._storedCSS = {
          width: this.currentItem[0].style.width,
          height: this.currentItem[0].style.height,
          position: this.currentItem.css("position"),
          top: this.currentItem.css("top"),
          left: this.currentItem.css("left")
        };
      }
      if (!helper[0].style.width || o.forceHelperSize) {
        helper.width(this.currentItem.width());
      }
      if (!helper[0].style.height || o.forceHelperSize) {
        helper.height(this.currentItem.height());
      }
      return helper;
    },
    _adjustOffsetFromHelper: function(obj) {
      if (typeof obj === "string") {
        obj = obj.split(" ");
      }
      if (Array.isArray(obj)) {
        obj = {
          left: +obj[0],
          top: +obj[1] || 0
        };
      }
      if ("left" in obj) {
        this.offset.click.left = obj.left + this.margins.left;
      }
      if ("right" in obj) {
        this.offset.click.left = this.helperProportions.width - obj.right + this.margins.left;
      }
      if ("top" in obj) {
        this.offset.click.top = obj.top + this.margins.top;
      }
      if ("bottom" in obj) {
        this.offset.click.top = this.helperProportions.height - obj.bottom + this.margins.top;
      }
    },
    _getParentOffset: function() {
      this.offsetParent = this.helper.offsetParent();
      var po = this.offsetParent.offset();
      if (this.cssPosition === "absolute" && this.scrollParent[0] !== this.document[0] && $.contains(this.scrollParent[0], this.offsetParent[0])) {
        po.left += this.scrollParent.scrollLeft();
        po.top += this.scrollParent.scrollTop();
      }
      if (this.offsetParent[0] === this.document[0].body) {
        po = {
          top: 0,
          left: 0
        };
      }
      return {
        top: po.top + (parseInt(this.offsetParent.css("borderTopWidth"), 10) || 0),
        left: po.left + (parseInt(this.offsetParent.css("borderLeftWidth"), 10) || 0)
      };
    },
    _getRelativeOffset: function() {
      if (this.cssPosition === "relative") {
        var p = this.currentItem.position();
        return {
          top: p.top - (parseInt(this.helper.css("top"), 10) || 0) + this.scrollParent.scrollTop(),
          left: p.left - (parseInt(this.helper.css("left"), 10) || 0) + this.scrollParent.scrollLeft()
        };
      } else {
        return {
          top: 0,
          left: 0
        };
      }
    },
    _cacheMargins: function() {
      this.margins = {
        left: parseInt(this.currentItem.css("marginLeft"), 10) || 0,
        top: parseInt(this.currentItem.css("marginTop"), 10) || 0
      };
    },
    _cacheHelperProportions: function() {
      this.helperProportions = {
        width: this.helper.outerWidth(),
        height: this.helper.outerHeight()
      };
    },
    _setContainment: function() {
      var ce, co, over, o = this.options;
      if (o.containment === "parent") {
        o.containment = this.helper[0].parentNode;
      }
      if (o.containment === "document" || o.containment === "window") {
        this.containment = [ 0 - this.offset.relative.left - this.offset.parent.left, 0 - this.offset.relative.top - this.offset.parent.top, o.containment === "document" ? this.document.width() : this.window.width() - this.helperProportions.width - this.margins.left, (o.containment === "document" ? this.document.height() || document.body.parentNode.scrollHeight : this.window.height() || this.document[0].body.parentNode.scrollHeight) - this.helperProportions.height - this.margins.top ];
      }
      if (!/^(document|window|parent)$/.test(o.containment)) {
        ce = $(o.containment)[0];
        co = $(o.containment).offset();
        over = $(ce).css("overflow") !== "hidden";
        this.containment = [ co.left + (parseInt($(ce).css("borderLeftWidth"), 10) || 0) + (parseInt($(ce).css("paddingLeft"), 10) || 0) - this.margins.left, co.top + (parseInt($(ce).css("borderTopWidth"), 10) || 0) + (parseInt($(ce).css("paddingTop"), 10) || 0) - this.margins.top, co.left + (over ? Math.max(ce.scrollWidth, ce.offsetWidth) : ce.offsetWidth) - (parseInt($(ce).css("borderLeftWidth"), 10) || 0) - (parseInt($(ce).css("paddingRight"), 10) || 0) - this.helperProportions.width - this.margins.left, co.top + (over ? Math.max(ce.scrollHeight, ce.offsetHeight) : ce.offsetHeight) - (parseInt($(ce).css("borderTopWidth"), 10) || 0) - (parseInt($(ce).css("paddingBottom"), 10) || 0) - this.helperProportions.height - this.margins.top ];
      }
    },
    _convertPositionTo: function(d, pos) {
      if (!pos) {
        pos = this.position;
      }
      var mod = d === "absolute" ? 1 : -1, scroll = this.cssPosition === "absolute" && !(this.scrollParent[0] !== this.document[0] && $.contains(this.scrollParent[0], this.offsetParent[0])) ? this.offsetParent : this.scrollParent, scrollIsRootNode = /(html|body)/i.test(scroll[0].tagName);
      return {
        top: pos.top + this.offset.relative.top * mod + this.offset.parent.top * mod - (this.cssPosition === "fixed" ? -this.scrollParent.scrollTop() : scrollIsRootNode ? 0 : scroll.scrollTop()) * mod,
        left: pos.left + this.offset.relative.left * mod + this.offset.parent.left * mod - (this.cssPosition === "fixed" ? -this.scrollParent.scrollLeft() : scrollIsRootNode ? 0 : scroll.scrollLeft()) * mod
      };
    },
    _generatePosition: function(event) {
      var top, left, o = this.options, pageX = event.pageX, pageY = event.pageY, scroll = this.cssPosition === "absolute" && !(this.scrollParent[0] !== this.document[0] && $.contains(this.scrollParent[0], this.offsetParent[0])) ? this.offsetParent : this.scrollParent, scrollIsRootNode = /(html|body)/i.test(scroll[0].tagName);
      if (this.cssPosition === "relative" && !(this.scrollParent[0] !== this.document[0] && this.scrollParent[0] !== this.offsetParent[0])) {
        this.offset.relative = this._getRelativeOffset();
      }
      if (this.originalPosition) {
        if (this.containment) {
          if (event.pageX - this.offset.click.left < this.containment[0]) {
            pageX = this.containment[0] + this.offset.click.left;
          }
          if (event.pageY - this.offset.click.top < this.containment[1]) {
            pageY = this.containment[1] + this.offset.click.top;
          }
          if (event.pageX - this.offset.click.left > this.containment[2]) {
            pageX = this.containment[2] + this.offset.click.left;
          }
          if (event.pageY - this.offset.click.top > this.containment[3]) {
            pageY = this.containment[3] + this.offset.click.top;
          }
        }
        if (o.grid) {
          top = this.originalPageY + Math.round((pageY - this.originalPageY) / o.grid[1]) * o.grid[1];
          pageY = this.containment ? top - this.offset.click.top >= this.containment[1] && top - this.offset.click.top <= this.containment[3] ? top : top - this.offset.click.top >= this.containment[1] ? top - o.grid[1] : top + o.grid[1] : top;
          left = this.originalPageX + Math.round((pageX - this.originalPageX) / o.grid[0]) * o.grid[0];
          pageX = this.containment ? left - this.offset.click.left >= this.containment[0] && left - this.offset.click.left <= this.containment[2] ? left : left - this.offset.click.left >= this.containment[0] ? left - o.grid[0] : left + o.grid[0] : left;
        }
      }
      return {
        top: pageY - this.offset.click.top - this.offset.relative.top - this.offset.parent.top + (this.cssPosition === "fixed" ? -this.scrollParent.scrollTop() : scrollIsRootNode ? 0 : scroll.scrollTop()),
        left: pageX - this.offset.click.left - this.offset.relative.left - this.offset.parent.left + (this.cssPosition === "fixed" ? -this.scrollParent.scrollLeft() : scrollIsRootNode ? 0 : scroll.scrollLeft())
      };
    },
    _rearrange: function(event, i, a, hardRefresh) {
      if (a) {
        a[0].appendChild(this.placeholder[0]);
      } else {
        i.item[0].parentNode.insertBefore(this.placeholder[0], this.direction === "down" ? i.item[0] : i.item[0].nextSibling);
      }
      this.counter = this.counter ? ++this.counter : 1;
      var counter = this.counter;
      this._delay((function() {
        if (counter === this.counter) {
          this.refreshPositions(!hardRefresh);
        }
      }));
    },
    _clear: function(event, noPropagation) {
      this.reverting = false;
      var i, delayedTriggers = [];
      if (!this._noFinalSort && this.currentItem.parent().length) {
        this.placeholder.before(this.currentItem);
      }
      this._noFinalSort = null;
      if (this.helper[0] === this.currentItem[0]) {
        for (i in this._storedCSS) {
          if (this._storedCSS[i] === "auto" || this._storedCSS[i] === "static") {
            this._storedCSS[i] = "";
          }
        }
        this.currentItem.css(this._storedCSS);
        this._removeClass(this.currentItem, "ui-sortable-helper");
      } else {
        this.currentItem.show();
      }
      if (this.fromOutside && !noPropagation) {
        delayedTriggers.push((function(event) {
          this._trigger("receive", event, this._uiHash(this.fromOutside));
        }));
      }
      if ((this.fromOutside || this.domPosition.prev !== this.currentItem.prev().not(".ui-sortable-helper")[0] || this.domPosition.parent !== this.currentItem.parent()[0]) && !noPropagation) {
        delayedTriggers.push((function(event) {
          this._trigger("update", event, this._uiHash());
        }));
      }
      if (this !== this.currentContainer) {
        if (!noPropagation) {
          delayedTriggers.push((function(event) {
            this._trigger("remove", event, this._uiHash());
          }));
          delayedTriggers.push(function(c) {
            return function(event) {
              c._trigger("receive", event, this._uiHash(this));
            };
          }.call(this, this.currentContainer));
          delayedTriggers.push(function(c) {
            return function(event) {
              c._trigger("update", event, this._uiHash(this));
            };
          }.call(this, this.currentContainer));
        }
      }
      function delayEvent(type, instance, container) {
        return function(event) {
          container._trigger(type, event, instance._uiHash(instance));
        };
      }
      for (i = this.containers.length - 1; i >= 0; i--) {
        if (!noPropagation) {
          delayedTriggers.push(delayEvent("deactivate", this, this.containers[i]));
        }
        if (this.containers[i].containerCache.over) {
          delayedTriggers.push(delayEvent("out", this, this.containers[i]));
          this.containers[i].containerCache.over = 0;
        }
      }
      if (this._storedStylesheet) {
        this._storedStylesheet.remove();
        this._storedStylesheet = null;
      }
      if (this._storedOpacity) {
        this.helper.css("opacity", this._storedOpacity);
      }
      if (this._storedZIndex) {
        this.helper.css("zIndex", this._storedZIndex === "auto" ? "" : this._storedZIndex);
      }
      this.dragging = false;
      if (!noPropagation) {
        this._trigger("beforeStop", event, this._uiHash());
      }
      this.placeholder[0].parentNode.removeChild(this.placeholder[0]);
      if (!this.cancelHelperRemoval) {
        if (this.helper[0] !== this.currentItem[0]) {
          this.helper.remove();
        }
        this.helper = null;
      }
      if (!noPropagation) {
        for (i = 0; i < delayedTriggers.length; i++) {
          delayedTriggers[i].call(this, event);
        }
        this._trigger("stop", event, this._uiHash());
      }
      this.fromOutside = false;
      return !this.cancelHelperRemoval;
    },
    _trigger: function() {
      if ($.Widget.prototype._trigger.apply(this, arguments) === false) {
        this.cancel();
      }
    },
    _uiHash: function(_inst) {
      var inst = _inst || this;
      return {
        helper: inst.helper,
        placeholder: inst.placeholder || $([]),
        position: inst.position,
        originalPosition: inst.originalPosition,
        offset: inst.positionAbs,
        item: inst.currentItem,
        sender: _inst ? _inst.element : null
      };
    }
  });
  /*!
 * jQuery UI Controlgroup 1.14.0
 * https://jqueryui.com
 *
 * Copyright OpenJS Foundation and other contributors
 * Released under the MIT license.
 * https://jquery.org/license
 */  var controlgroupCornerRegex = /ui-corner-([a-z]){2,6}/g;
  $.widget("ui.controlgroup", {
    version: "1.14.0",
    defaultElement: "<div>",
    options: {
      direction: "horizontal",
      disabled: null,
      onlyVisible: true,
      items: {
        button: "input[type=button], input[type=submit], input[type=reset], button, a",
        controlgroupLabel: ".ui-controlgroup-label",
        checkboxradio: "input[type='checkbox'], input[type='radio']",
        selectmenu: "select",
        spinner: ".ui-spinner-input"
      }
    },
    _create: function() {
      this._enhance();
    },
    _enhance: function() {
      this.element.attr("role", "toolbar");
      this.refresh();
    },
    _destroy: function() {
      this._callChildMethod("destroy");
      this.childWidgets.removeData("ui-controlgroup-data");
      this.element.removeAttr("role");
      if (this.options.items.controlgroupLabel) {
        this.element.find(this.options.items.controlgroupLabel).find(".ui-controlgroup-label-contents").contents().unwrap();
      }
    },
    _initWidgets: function() {
      var that = this, childWidgets = [];
      $.each(this.options.items, (function(widget, selector) {
        var labels;
        var options = {};
        if (!selector) {
          return;
        }
        if (widget === "controlgroupLabel") {
          labels = that.element.find(selector);
          labels.each((function() {
            var element = $(this);
            if (element.children(".ui-controlgroup-label-contents").length) {
              return;
            }
            element.contents().wrapAll("<span class='ui-controlgroup-label-contents'></span>");
          }));
          that._addClass(labels, null, "ui-widget ui-widget-content ui-state-default");
          childWidgets = childWidgets.concat(labels.get());
          return;
        }
        if (!$.fn[widget]) {
          return;
        }
        if (that["_" + widget + "Options"]) {
          options = that["_" + widget + "Options"]("middle");
        } else {
          options = {
            classes: {}
          };
        }
        that.element.find(selector).each((function() {
          var element = $(this);
          var instance = element[widget]("instance");
          var instanceOptions = $.widget.extend({}, options);
          if (widget === "button" && element.parent(".ui-spinner").length) {
            return;
          }
          if (!instance) {
            instance = element[widget]()[widget]("instance");
          }
          if (instance) {
            instanceOptions.classes = that._resolveClassesValues(instanceOptions.classes, instance);
          }
          element[widget](instanceOptions);
          var widgetElement = element[widget]("widget");
          $.data(widgetElement[0], "ui-controlgroup-data", instance ? instance : element[widget]("instance"));
          childWidgets.push(widgetElement[0]);
        }));
      }));
      this.childWidgets = $($.uniqueSort(childWidgets));
      this._addClass(this.childWidgets, "ui-controlgroup-item");
    },
    _callChildMethod: function(method) {
      this.childWidgets.each((function() {
        var element = $(this), data = element.data("ui-controlgroup-data");
        if (data && data[method]) {
          data[method]();
        }
      }));
    },
    _updateCornerClass: function(element, position) {
      var remove = "ui-corner-top ui-corner-bottom ui-corner-left ui-corner-right ui-corner-all";
      var add = this._buildSimpleOptions(position, "label").classes.label;
      this._removeClass(element, null, remove);
      this._addClass(element, null, add);
    },
    _buildSimpleOptions: function(position, key) {
      var direction = this.options.direction === "vertical";
      var result = {
        classes: {}
      };
      result.classes[key] = {
        middle: "",
        first: "ui-corner-" + (direction ? "top" : "left"),
        last: "ui-corner-" + (direction ? "bottom" : "right"),
        only: "ui-corner-all"
      }[position];
      return result;
    },
    _spinnerOptions: function(position) {
      var options = this._buildSimpleOptions(position, "ui-spinner");
      options.classes["ui-spinner-up"] = "";
      options.classes["ui-spinner-down"] = "";
      return options;
    },
    _buttonOptions: function(position) {
      return this._buildSimpleOptions(position, "ui-button");
    },
    _checkboxradioOptions: function(position) {
      return this._buildSimpleOptions(position, "ui-checkboxradio-label");
    },
    _selectmenuOptions: function(position) {
      var direction = this.options.direction === "vertical";
      return {
        width: direction ? "auto" : false,
        classes: {
          middle: {
            "ui-selectmenu-button-open": "",
            "ui-selectmenu-button-closed": ""
          },
          first: {
            "ui-selectmenu-button-open": "ui-corner-" + (direction ? "top" : "tl"),
            "ui-selectmenu-button-closed": "ui-corner-" + (direction ? "top" : "left")
          },
          last: {
            "ui-selectmenu-button-open": direction ? "" : "ui-corner-tr",
            "ui-selectmenu-button-closed": "ui-corner-" + (direction ? "bottom" : "right")
          },
          only: {
            "ui-selectmenu-button-open": "ui-corner-top",
            "ui-selectmenu-button-closed": "ui-corner-all"
          }
        }[position]
      };
    },
    _resolveClassesValues: function(classes, instance) {
      var result = {};
      $.each(classes, (function(key) {
        var current = instance.options.classes[key] || "";
        current = String.prototype.trim.call(current.replace(controlgroupCornerRegex, ""));
        result[key] = (current + " " + classes[key]).replace(/\s+/g, " ");
      }));
      return result;
    },
    _setOption: function(key, value) {
      if (key === "direction") {
        this._removeClass("ui-controlgroup-" + this.options.direction);
      }
      this._super(key, value);
      if (key === "disabled") {
        this._callChildMethod(value ? "disable" : "enable");
        return;
      }
      this.refresh();
    },
    refresh: function() {
      var children, that = this;
      this._addClass("ui-controlgroup ui-controlgroup-" + this.options.direction);
      if (this.options.direction === "horizontal") {
        this._addClass(null, "ui-helper-clearfix");
      }
      this._initWidgets();
      children = this.childWidgets;
      if (this.options.onlyVisible) {
        children = children.filter(":visible");
      }
      if (children.length) {
        $.each([ "first", "last" ], (function(index, value) {
          var instance = children[value]().data("ui-controlgroup-data");
          if (instance && that["_" + instance.widgetName + "Options"]) {
            var options = that["_" + instance.widgetName + "Options"](children.length === 1 ? "only" : value);
            options.classes = that._resolveClassesValues(options.classes, instance);
            instance.element[instance.widgetName](options);
          } else {
            that._updateCornerClass(children[value](), value);
          }
        }));
        this._callChildMethod("refresh");
      }
    }
  });
  /*!
 * jQuery UI Checkboxradio 1.14.0
 * https://jqueryui.com
 *
 * Copyright OpenJS Foundation and other contributors
 * Released under the MIT license.
 * https://jquery.org/license
 */  $.widget("ui.checkboxradio", [ $.ui.formResetMixin, {
    version: "1.14.0",
    options: {
      disabled: null,
      label: null,
      icon: true,
      classes: {
        "ui-checkboxradio-label": "ui-corner-all",
        "ui-checkboxradio-icon": "ui-corner-all"
      }
    },
    _getCreateOptions: function() {
      var disabled, labels, labelContents;
      var options = this._super() || {};
      this._readType();
      labels = this.element.labels();
      this.label = $(labels[labels.length - 1]);
      if (!this.label.length) {
        $.error("No label found for checkboxradio widget");
      }
      this.originalLabel = "";
      labelContents = this.label.contents().not(this.element[0]);
      if (labelContents.length) {
        this.originalLabel += labelContents.clone().wrapAll("<div></div>").parent().html();
      }
      if (this.originalLabel) {
        options.label = this.originalLabel;
      }
      disabled = this.element[0].disabled;
      if (disabled != null) {
        options.disabled = disabled;
      }
      return options;
    },
    _create: function() {
      var checked = this.element[0].checked;
      this._bindFormResetHandler();
      if (this.options.disabled == null) {
        this.options.disabled = this.element[0].disabled;
      }
      this._setOption("disabled", this.options.disabled);
      this._addClass("ui-checkboxradio", "ui-helper-hidden-accessible");
      this._addClass(this.label, "ui-checkboxradio-label", "ui-button ui-widget");
      if (this.type === "radio") {
        this._addClass(this.label, "ui-checkboxradio-radio-label");
      }
      if (this.options.label && this.options.label !== this.originalLabel) {
        this._updateLabel();
      } else if (this.originalLabel) {
        this.options.label = this.originalLabel;
      }
      this._enhance();
      if (checked) {
        this._addClass(this.label, "ui-checkboxradio-checked", "ui-state-active");
      }
      this._on({
        change: "_toggleClasses",
        focus: function() {
          this._addClass(this.label, null, "ui-state-focus ui-visual-focus");
        },
        blur: function() {
          this._removeClass(this.label, null, "ui-state-focus ui-visual-focus");
        }
      });
    },
    _readType: function() {
      var nodeName = this.element[0].nodeName.toLowerCase();
      this.type = this.element[0].type;
      if (nodeName !== "input" || !/radio|checkbox/.test(this.type)) {
        $.error("Can't create checkboxradio on element.nodeName=" + nodeName + " and element.type=" + this.type);
      }
    },
    _enhance: function() {
      this._updateIcon(this.element[0].checked);
    },
    widget: function() {
      return this.label;
    },
    _getRadioGroup: function() {
      var group;
      var name = this.element[0].name;
      var nameSelector = "input[name='" + CSS.escape(name) + "']";
      if (!name) {
        return $([]);
      }
      if (this.form.length) {
        group = $(this.form[0].elements).filter(nameSelector);
      } else {
        group = $(nameSelector).filter((function() {
          return $($(this).prop("form")).length === 0;
        }));
      }
      return group.not(this.element);
    },
    _toggleClasses: function() {
      var checked = this.element[0].checked;
      this._toggleClass(this.label, "ui-checkboxradio-checked", "ui-state-active", checked);
      if (this.options.icon && this.type === "checkbox") {
        this._toggleClass(this.icon, null, "ui-icon-check ui-state-checked", checked)._toggleClass(this.icon, null, "ui-icon-blank", !checked);
      }
      if (this.type === "radio") {
        this._getRadioGroup().each((function() {
          var instance = $(this).checkboxradio("instance");
          if (instance) {
            instance._removeClass(instance.label, "ui-checkboxradio-checked", "ui-state-active");
          }
        }));
      }
    },
    _destroy: function() {
      this._unbindFormResetHandler();
      if (this.icon) {
        this.icon.remove();
        this.iconSpace.remove();
      }
    },
    _setOption: function(key, value) {
      if (key === "label" && !value) {
        return;
      }
      this._super(key, value);
      if (key === "disabled") {
        this._toggleClass(this.label, null, "ui-state-disabled", value);
        this.element[0].disabled = value;
        return;
      }
      this.refresh();
    },
    _updateIcon: function(checked) {
      var toAdd = "ui-icon ui-icon-background ";
      if (this.options.icon) {
        if (!this.icon) {
          this.icon = $("<span>");
          this.iconSpace = $("<span> </span>");
          this._addClass(this.iconSpace, "ui-checkboxradio-icon-space");
        }
        if (this.type === "checkbox") {
          toAdd += checked ? "ui-icon-check ui-state-checked" : "ui-icon-blank";
          this._removeClass(this.icon, null, checked ? "ui-icon-blank" : "ui-icon-check");
        } else {
          toAdd += "ui-icon-blank";
        }
        this._addClass(this.icon, "ui-checkboxradio-icon", toAdd);
        if (!checked) {
          this._removeClass(this.icon, null, "ui-icon-check ui-state-checked");
        }
        this.icon.prependTo(this.label).after(this.iconSpace);
      } else if (this.icon !== undefined) {
        this.icon.remove();
        this.iconSpace.remove();
        delete this.icon;
      }
    },
    _updateLabel: function() {
      var contents = this.label.contents().not(this.element[0]);
      if (this.icon) {
        contents = contents.not(this.icon[0]);
      }
      if (this.iconSpace) {
        contents = contents.not(this.iconSpace[0]);
      }
      contents.remove();
      this.label.append(this.options.label);
    },
    refresh: function() {
      var checked = this.element[0].checked, isDisabled = this.element[0].disabled;
      this._updateIcon(checked);
      this._toggleClass(this.label, "ui-checkboxradio-checked", "ui-state-active", checked);
      if (this.options.label !== null) {
        this._updateLabel();
      }
      if (isDisabled !== this.options.disabled) {
        this._setOptions({
          disabled: isDisabled
        });
      }
    }
  } ]);
  $.ui.checkboxradio;
  /*!
 * jQuery UI Button 1.14.0
 * https://jqueryui.com
 *
 * Copyright OpenJS Foundation and other contributors
 * Released under the MIT license.
 * https://jquery.org/license
 */  $.widget("ui.button", {
    version: "1.14.0",
    defaultElement: "<button>",
    options: {
      classes: {
        "ui-button": "ui-corner-all"
      },
      disabled: null,
      icon: null,
      iconPosition: "beginning",
      label: null,
      showLabel: true
    },
    _getCreateOptions: function() {
      var disabled, options = this._super() || {};
      this.isInput = this.element.is("input");
      disabled = this.element[0].disabled;
      if (disabled != null) {
        options.disabled = disabled;
      }
      this.originalLabel = this.isInput ? this.element.val() : this.element.html();
      if (this.originalLabel) {
        options.label = this.originalLabel;
      }
      return options;
    },
    _create: function() {
      if (!this.option.showLabel & !this.options.icon) {
        this.options.showLabel = true;
      }
      if (this.options.disabled == null) {
        this.options.disabled = this.element[0].disabled || false;
      }
      this.hasTitle = !!this.element.attr("title");
      if (this.options.label && this.options.label !== this.originalLabel) {
        if (this.isInput) {
          this.element.val(this.options.label);
        } else {
          this.element.html(this.options.label);
        }
      }
      this._addClass("ui-button", "ui-widget");
      this._setOption("disabled", this.options.disabled);
      this._enhance();
      if (this.element.is("a")) {
        this._on({
          keyup: function(event) {
            if (event.keyCode === $.ui.keyCode.SPACE) {
              event.preventDefault();
              if (this.element[0].click) {
                this.element[0].click();
              } else {
                this.element.trigger("click");
              }
            }
          }
        });
      }
    },
    _enhance: function() {
      if (!this.element.is("button")) {
        this.element.attr("role", "button");
      }
      if (this.options.icon) {
        this._updateIcon("icon", this.options.icon);
        this._updateTooltip();
      }
    },
    _updateTooltip: function() {
      this.title = this.element.attr("title");
      if (!this.options.showLabel && !this.title) {
        this.element.attr("title", this.options.label);
      }
    },
    _updateIcon: function(option, value) {
      var icon = option !== "iconPosition", position = icon ? this.options.iconPosition : value, displayBlock = position === "top" || position === "bottom";
      if (!this.icon) {
        this.icon = $("<span>");
        this._addClass(this.icon, "ui-button-icon", "ui-icon");
        if (!this.options.showLabel) {
          this._addClass("ui-button-icon-only");
        }
      } else if (icon) {
        this._removeClass(this.icon, null, this.options.icon);
      }
      if (icon) {
        this._addClass(this.icon, null, value);
      }
      this._attachIcon(position);
      if (displayBlock) {
        this._addClass(this.icon, null, "ui-widget-icon-block");
        if (this.iconSpace) {
          this.iconSpace.remove();
        }
      } else {
        if (!this.iconSpace) {
          this.iconSpace = $("<span> </span>");
          this._addClass(this.iconSpace, "ui-button-icon-space");
        }
        this._removeClass(this.icon, null, "ui-wiget-icon-block");
        this._attachIconSpace(position);
      }
    },
    _destroy: function() {
      this.element.removeAttr("role");
      if (this.icon) {
        this.icon.remove();
      }
      if (this.iconSpace) {
        this.iconSpace.remove();
      }
      if (!this.hasTitle) {
        this.element.removeAttr("title");
      }
    },
    _attachIconSpace: function(iconPosition) {
      this.icon[/^(?:end|bottom)/.test(iconPosition) ? "before" : "after"](this.iconSpace);
    },
    _attachIcon: function(iconPosition) {
      this.element[/^(?:end|bottom)/.test(iconPosition) ? "append" : "prepend"](this.icon);
    },
    _setOptions: function(options) {
      var newShowLabel = options.showLabel === undefined ? this.options.showLabel : options.showLabel, newIcon = options.icon === undefined ? this.options.icon : options.icon;
      if (!newShowLabel && !newIcon) {
        options.showLabel = true;
      }
      this._super(options);
    },
    _setOption: function(key, value) {
      if (key === "icon") {
        if (value) {
          this._updateIcon(key, value);
        } else if (this.icon) {
          this.icon.remove();
          if (this.iconSpace) {
            this.iconSpace.remove();
          }
        }
      }
      if (key === "iconPosition") {
        this._updateIcon(key, value);
      }
      if (key === "showLabel") {
        this._toggleClass("ui-button-icon-only", null, !value);
        this._updateTooltip();
      }
      if (key === "label") {
        if (this.isInput) {
          this.element.val(value);
        } else {
          this.element.html(value);
          if (this.icon) {
            this._attachIcon(this.options.iconPosition);
            this._attachIconSpace(this.options.iconPosition);
          }
        }
      }
      this._super(key, value);
      if (key === "disabled") {
        this._toggleClass(null, "ui-state-disabled", value);
        this.element[0].disabled = value;
        if (value) {
          this.element.trigger("blur");
        }
      }
    },
    refresh: function() {
      var isDisabled = this.element.is("input, button") ? this.element[0].disabled : this.element.hasClass("ui-button-disabled");
      if (isDisabled !== this.options.disabled) {
        this._setOptions({
          disabled: isDisabled
        });
      }
      this._updateTooltip();
    }
  });
  if ($.uiBackCompat === true) {
    $.widget("ui.button", $.ui.button, {
      options: {
        text: true,
        icons: {
          primary: null,
          secondary: null
        }
      },
      _create: function() {
        if (this.options.showLabel && !this.options.text) {
          this.options.showLabel = this.options.text;
        }
        if (!this.options.showLabel && this.options.text) {
          this.options.text = this.options.showLabel;
        }
        if (!this.options.icon && (this.options.icons.primary || this.options.icons.secondary)) {
          if (this.options.icons.primary) {
            this.options.icon = this.options.icons.primary;
          } else {
            this.options.icon = this.options.icons.secondary;
            this.options.iconPosition = "end";
          }
        } else if (this.options.icon) {
          this.options.icons.primary = this.options.icon;
        }
        this._super();
      },
      _setOption: function(key, value) {
        if (key === "text") {
          this._super("showLabel", value);
          return;
        }
        if (key === "showLabel") {
          this.options.text = value;
        }
        if (key === "icon") {
          this.options.icons.primary = value;
        }
        if (key === "icons") {
          if (value.primary) {
            this._super("icon", value.primary);
            this._super("iconPosition", "beginning");
          } else if (value.secondary) {
            this._super("icon", value.secondary);
            this._super("iconPosition", "end");
          }
        }
        this._superApply(arguments);
      }
    });
    $.fn.button = function(orig) {
      return function(options) {
        var isMethodCall = typeof options === "string";
        var args = Array.prototype.slice.call(arguments, 1);
        var returnValue = this;
        if (isMethodCall) {
          if (!this.length && options === "instance") {
            returnValue = undefined;
          } else {
            this.each((function() {
              var methodValue;
              var type = $(this).attr("type");
              var name = type !== "checkbox" && type !== "radio" ? "button" : "checkboxradio";
              var instance = $.data(this, "ui-" + name);
              if (options === "instance") {
                returnValue = instance;
                return false;
              }
              if (!instance) {
                return $.error("cannot call methods on button" + " prior to initialization; " + "attempted to call method '" + options + "'");
              }
              if (typeof instance[options] !== "function" || options.charAt(0) === "_") {
                return $.error("no such method '" + options + "' for button" + " widget instance");
              }
              methodValue = instance[options].apply(instance, args);
              if (methodValue !== instance && methodValue !== undefined) {
                returnValue = methodValue && methodValue.jquery ? returnValue.pushStack(methodValue.get()) : methodValue;
                return false;
              }
            }));
          }
        } else {
          if (args.length) {
            options = $.widget.extend.apply(null, [ options ].concat(args));
          }
          this.each((function() {
            var type = $(this).attr("type");
            var name = type !== "checkbox" && type !== "radio" ? "button" : "checkboxradio";
            var instance = $.data(this, "ui-" + name);
            if (instance) {
              instance.option(options || {});
              if (instance._init) {
                instance._init();
              }
            } else {
              if (name === "button") {
                orig.call($(this), options);
                return;
              }
              $(this).checkboxradio($.extend({
                icon: false
              }, options));
            }
          }));
        }
        return returnValue;
      };
    }($.fn.button);
    $.fn.buttonset = function() {
      if (!$.ui.controlgroup) {
        $.error("Controlgroup widget missing");
      }
      if (arguments[0] === "option" && arguments[1] === "items" && arguments[2]) {
        return this.controlgroup.apply(this, [ arguments[0], "items.button", arguments[2] ]);
      }
      if (arguments[0] === "option" && arguments[1] === "items") {
        return this.controlgroup.apply(this, [ arguments[0], "items.button" ]);
      }
      if (typeof arguments[0] === "object" && arguments[0].items) {
        arguments[0].items = {
          button: arguments[0].items
        };
      }
      return this.controlgroup.apply(this, arguments);
    };
  }
  $.ui.button;
  /*!
 * jQuery UI Datepicker 1.14.0
 * https://jqueryui.com
 *
 * Copyright OpenJS Foundation and other contributors
 * Released under the MIT license.
 * https://jquery.org/license
 */  $.extend($.ui, {
    datepicker: {
      version: "1.14.0"
    }
  });
  var datepicker_instActive;
  function datepicker_getZindex(elem) {
    var position, value;
    while (elem.length && elem[0] !== document) {
      position = elem.css("position");
      if (position === "absolute" || position === "relative" || position === "fixed") {
        value = parseInt(elem.css("zIndex"), 10);
        if (!isNaN(value) && value !== 0) {
          return value;
        }
      }
      elem = elem.parent();
    }
    return 0;
  }
  function Datepicker() {
    this._curInst = null;
    this._keyEvent = false;
    this._disabledInputs = [];
    this._datepickerShowing = false;
    this._inDialog = false;
    this._mainDivId = "ui-datepicker-div";
    this._inlineClass = "ui-datepicker-inline";
    this._appendClass = "ui-datepicker-append";
    this._triggerClass = "ui-datepicker-trigger";
    this._dialogClass = "ui-datepicker-dialog";
    this._disableClass = "ui-datepicker-disabled";
    this._unselectableClass = "ui-datepicker-unselectable";
    this._currentClass = "ui-datepicker-current-day";
    this._dayOverClass = "ui-datepicker-days-cell-over";
    this.regional = [];
    this.regional[""] = {
      closeText: "Done",
      prevText: "Prev",
      nextText: "Next",
      currentText: "Today",
      monthNames: [ "January", "February", "March", "April", "May", "June", "July", "August", "September", "October", "November", "December" ],
      monthNamesShort: [ "Jan", "Feb", "Mar", "Apr", "May", "Jun", "Jul", "Aug", "Sep", "Oct", "Nov", "Dec" ],
      dayNames: [ "Sunday", "Monday", "Tuesday", "Wednesday", "Thursday", "Friday", "Saturday" ],
      dayNamesShort: [ "Sun", "Mon", "Tue", "Wed", "Thu", "Fri", "Sat" ],
      dayNamesMin: [ "Su", "Mo", "Tu", "We", "Th", "Fr", "Sa" ],
      weekHeader: "Wk",
      dateFormat: "mm/dd/yy",
      firstDay: 0,
      isRTL: false,
      showMonthAfterYear: false,
      yearSuffix: "",
      selectMonthLabel: "Select month",
      selectYearLabel: "Select year"
    };
    this._defaults = {
      showOn: "focus",
      showAnim: "fadeIn",
      showOptions: {},
      defaultDate: null,
      appendText: "",
      buttonText: "...",
      buttonImage: "",
      buttonImageOnly: false,
      hideIfNoPrevNext: false,
      navigationAsDateFormat: false,
      gotoCurrent: false,
      changeMonth: false,
      changeYear: false,
      yearRange: "c-10:c+10",
      showOtherMonths: false,
      selectOtherMonths: false,
      showWeek: false,
      calculateWeek: this.iso8601Week,
      shortYearCutoff: "+10",
      minDate: null,
      maxDate: null,
      duration: "fast",
      beforeShowDay: null,
      beforeShow: null,
      onSelect: null,
      onChangeMonthYear: null,
      onClose: null,
      onUpdateDatepicker: null,
      numberOfMonths: 1,
      showCurrentAtPos: 0,
      stepMonths: 1,
      stepBigMonths: 12,
      altField: "",
      altFormat: "",
      constrainInput: true,
      showButtonPanel: false,
      autoSize: false,
      disabled: false
    };
    $.extend(this._defaults, this.regional[""]);
    this.regional.en = $.extend(true, {}, this.regional[""]);
    this.regional["en-US"] = $.extend(true, {}, this.regional.en);
    this.dpDiv = datepicker_bindHover($("<div id='" + this._mainDivId + "' class='ui-datepicker ui-widget ui-widget-content ui-helper-clearfix ui-corner-all'></div>"));
  }
  $.extend(Datepicker.prototype, {
    markerClassName: "hasDatepicker",
    maxRows: 4,
    _widgetDatepicker: function() {
      return this.dpDiv;
    },
    setDefaults: function(settings) {
      datepicker_extendRemove(this._defaults, settings || {});
      return this;
    },
    _attachDatepicker: function(target, settings) {
      var nodeName, inline, inst;
      nodeName = target.nodeName.toLowerCase();
      inline = nodeName === "div" || nodeName === "span";
      if (!target.id) {
        this.uuid += 1;
        target.id = "dp" + this.uuid;
      }
      inst = this._newInst($(target), inline);
      inst.settings = $.extend({}, settings || {});
      if (nodeName === "input") {
        this._connectDatepicker(target, inst);
      } else if (inline) {
        this._inlineDatepicker(target, inst);
      }
    },
    _newInst: function(target, inline) {
      var id = target[0].id.replace(/([^A-Za-z0-9_\-])/g, "\\\\$1");
      return {
        id: id,
        input: target,
        selectedDay: 0,
        selectedMonth: 0,
        selectedYear: 0,
        drawMonth: 0,
        drawYear: 0,
        inline: inline,
        dpDiv: !inline ? this.dpDiv : datepicker_bindHover($("<div class='" + this._inlineClass + " ui-datepicker ui-widget ui-widget-content ui-helper-clearfix ui-corner-all'></div>"))
      };
    },
    _connectDatepicker: function(target, inst) {
      var input = $(target);
      inst.append = $([]);
      inst.trigger = $([]);
      if (input.hasClass(this.markerClassName)) {
        return;
      }
      this._attachments(input, inst);
      input.addClass(this.markerClassName).on("keydown", this._doKeyDown).on("keypress", this._doKeyPress).on("keyup", this._doKeyUp);
      this._autoSize(inst);
      $.data(target, "datepicker", inst);
      if (inst.settings.disabled) {
        this._disableDatepicker(target);
      }
    },
    _attachments: function(input, inst) {
      var showOn, buttonText, buttonImage, appendText = this._get(inst, "appendText"), isRTL = this._get(inst, "isRTL");
      if (inst.append) {
        inst.append.remove();
      }
      if (appendText) {
        inst.append = $("<span>").addClass(this._appendClass).text(appendText);
        input[isRTL ? "before" : "after"](inst.append);
      }
      input.off("focus", this._showDatepicker);
      if (inst.trigger) {
        inst.trigger.remove();
      }
      showOn = this._get(inst, "showOn");
      if (showOn === "focus" || showOn === "both") {
        input.on("focus", this._showDatepicker);
      }
      if (showOn === "button" || showOn === "both") {
        buttonText = this._get(inst, "buttonText");
        buttonImage = this._get(inst, "buttonImage");
        if (this._get(inst, "buttonImageOnly")) {
          inst.trigger = $("<img>").addClass(this._triggerClass).attr({
            src: buttonImage,
            alt: buttonText,
            title: buttonText
          });
        } else {
          inst.trigger = $("<button type='button'>").addClass(this._triggerClass);
          if (buttonImage) {
            inst.trigger.html($("<img>").attr({
              src: buttonImage,
              alt: buttonText,
              title: buttonText
            }));
          } else {
            inst.trigger.text(buttonText);
          }
        }
        input[isRTL ? "before" : "after"](inst.trigger);
        inst.trigger.on("click", (function() {
          if ($.datepicker._datepickerShowing && $.datepicker._lastInput === input[0]) {
            $.datepicker._hideDatepicker();
          } else if ($.datepicker._datepickerShowing && $.datepicker._lastInput !== input[0]) {
            $.datepicker._hideDatepicker();
            $.datepicker._showDatepicker(input[0]);
          } else {
            $.datepicker._showDatepicker(input[0]);
          }
          return false;
        }));
      }
    },
    _autoSize: function(inst) {
      if (this._get(inst, "autoSize") && !inst.inline) {
        var findMax, max, maxI, i, date = new Date(2009, 12 - 1, 20), dateFormat = this._get(inst, "dateFormat");
        if (dateFormat.match(/[DM]/)) {
          findMax = function(names) {
            max = 0;
            maxI = 0;
            for (i = 0; i < names.length; i++) {
              if (names[i].length > max) {
                max = names[i].length;
                maxI = i;
              }
            }
            return maxI;
          };
          date.setMonth(findMax(this._get(inst, dateFormat.match(/MM/) ? "monthNames" : "monthNamesShort")));
          date.setDate(findMax(this._get(inst, dateFormat.match(/DD/) ? "dayNames" : "dayNamesShort")) + 20 - date.getDay());
        }
        inst.input.attr("size", this._formatDate(inst, date).length);
      }
    },
    _inlineDatepicker: function(target, inst) {
      var divSpan = $(target);
      if (divSpan.hasClass(this.markerClassName)) {
        return;
      }
      divSpan.addClass(this.markerClassName).append(inst.dpDiv);
      $.data(target, "datepicker", inst);
      this._setDate(inst, this._getDefaultDate(inst), true);
      this._updateDatepicker(inst);
      this._updateAlternate(inst);
      if (inst.settings.disabled) {
        this._disableDatepicker(target);
      }
      inst.dpDiv.css("display", "block");
    },
    _dialogDatepicker: function(input, date, onSelect, settings, pos) {
      var id, browserWidth, browserHeight, scrollX, scrollY, inst = this._dialogInst;
      if (!inst) {
        this.uuid += 1;
        id = "dp" + this.uuid;
        this._dialogInput = $("<input type='text' id='" + id + "' style='position: absolute; top: -100px; width: 0px;'/>");
        this._dialogInput.on("keydown", this._doKeyDown);
        $("body").append(this._dialogInput);
        inst = this._dialogInst = this._newInst(this._dialogInput, false);
        inst.settings = {};
        $.data(this._dialogInput[0], "datepicker", inst);
      }
      datepicker_extendRemove(inst.settings, settings || {});
      date = date && date.constructor === Date ? this._formatDate(inst, date) : date;
      this._dialogInput.val(date);
      this._pos = pos ? pos.length ? pos : [ pos.pageX, pos.pageY ] : null;
      if (!this._pos) {
        browserWidth = document.documentElement.clientWidth;
        browserHeight = document.documentElement.clientHeight;
        scrollX = document.documentElement.scrollLeft || document.body.scrollLeft;
        scrollY = document.documentElement.scrollTop || document.body.scrollTop;
        this._pos = [ browserWidth / 2 - 100 + scrollX, browserHeight / 2 - 150 + scrollY ];
      }
      this._dialogInput.css("left", this._pos[0] + 20 + "px").css("top", this._pos[1] + "px");
      inst.settings.onSelect = onSelect;
      this._inDialog = true;
      this.dpDiv.addClass(this._dialogClass);
      this._showDatepicker(this._dialogInput[0]);
      if ($.blockUI) {
        $.blockUI(this.dpDiv);
      }
      $.data(this._dialogInput[0], "datepicker", inst);
      return this;
    },
    _destroyDatepicker: function(target) {
      var nodeName, $target = $(target), inst = $.data(target, "datepicker");
      if (!$target.hasClass(this.markerClassName)) {
        return;
      }
      nodeName = target.nodeName.toLowerCase();
      $.removeData(target, "datepicker");
      if (nodeName === "input") {
        inst.append.remove();
        inst.trigger.remove();
        $target.removeClass(this.markerClassName).off("focus", this._showDatepicker).off("keydown", this._doKeyDown).off("keypress", this._doKeyPress).off("keyup", this._doKeyUp);
      } else if (nodeName === "div" || nodeName === "span") {
        $target.removeClass(this.markerClassName).empty();
      }
      $.datepicker._hideDatepicker();
      if (datepicker_instActive === inst) {
        datepicker_instActive = null;
        this._curInst = null;
      }
    },
    _enableDatepicker: function(target) {
      var nodeName, inline, $target = $(target), inst = $.data(target, "datepicker");
      if (!$target.hasClass(this.markerClassName)) {
        return;
      }
      nodeName = target.nodeName.toLowerCase();
      if (nodeName === "input") {
        target.disabled = false;
        inst.trigger.filter("button").each((function() {
          this.disabled = false;
        })).end().filter("img").css({
          opacity: "1.0",
          cursor: ""
        });
      } else if (nodeName === "div" || nodeName === "span") {
        inline = $target.children("." + this._inlineClass);
        inline.children().removeClass("ui-state-disabled");
        inline.find("select.ui-datepicker-month, select.ui-datepicker-year").prop("disabled", false);
      }
      this._disabledInputs = $.map(this._disabledInputs, (function(value) {
        return value === target ? null : value;
      }));
    },
    _disableDatepicker: function(target) {
      var nodeName, inline, $target = $(target), inst = $.data(target, "datepicker");
      if (!$target.hasClass(this.markerClassName)) {
        return;
      }
      nodeName = target.nodeName.toLowerCase();
      if (nodeName === "input") {
        target.disabled = true;
        inst.trigger.filter("button").each((function() {
          this.disabled = true;
        })).end().filter("img").css({
          opacity: "0.5",
          cursor: "default"
        });
      } else if (nodeName === "div" || nodeName === "span") {
        inline = $target.children("." + this._inlineClass);
        inline.children().addClass("ui-state-disabled");
        inline.find("select.ui-datepicker-month, select.ui-datepicker-year").prop("disabled", true);
      }
      this._disabledInputs = $.map(this._disabledInputs, (function(value) {
        return value === target ? null : value;
      }));
      this._disabledInputs[this._disabledInputs.length] = target;
    },
    _isDisabledDatepicker: function(target) {
      if (!target) {
        return false;
      }
      for (var i = 0; i < this._disabledInputs.length; i++) {
        if (this._disabledInputs[i] === target) {
          return true;
        }
      }
      return false;
    },
    _getInst: function(target) {
      try {
        return $.data(target, "datepicker");
      } catch (err) {
        throw "Missing instance data for this datepicker";
      }
    },
    _optionDatepicker: function(target, name, value) {
      var settings, date, minDate, maxDate, inst = this._getInst(target);
      if (arguments.length === 2 && typeof name === "string") {
        return name === "defaults" ? $.extend({}, $.datepicker._defaults) : inst ? name === "all" ? $.extend({}, inst.settings) : this._get(inst, name) : null;
      }
      settings = name || {};
      if (typeof name === "string") {
        settings = {};
        settings[name] = value;
      }
      if (inst) {
        if (this._curInst === inst) {
          this._hideDatepicker();
        }
        date = this._getDateDatepicker(target, true);
        minDate = this._getMinMaxDate(inst, "min");
        maxDate = this._getMinMaxDate(inst, "max");
        datepicker_extendRemove(inst.settings, settings);
        if (minDate !== null && settings.dateFormat !== undefined && settings.minDate === undefined) {
          inst.settings.minDate = this._formatDate(inst, minDate);
        }
        if (maxDate !== null && settings.dateFormat !== undefined && settings.maxDate === undefined) {
          inst.settings.maxDate = this._formatDate(inst, maxDate);
        }
        if ("disabled" in settings) {
          if (settings.disabled) {
            this._disableDatepicker(target);
          } else {
            this._enableDatepicker(target);
          }
        }
        this._attachments($(target), inst);
        this._autoSize(inst);
        this._setDate(inst, date);
        this._updateAlternate(inst);
        this._updateDatepicker(inst);
      }
    },
    _changeDatepicker: function(target, name, value) {
      this._optionDatepicker(target, name, value);
    },
    _refreshDatepicker: function(target) {
      var inst = this._getInst(target);
      if (inst) {
        this._updateDatepicker(inst);
      }
    },
    _setDateDatepicker: function(target, date) {
      var inst = this._getInst(target);
      if (inst) {
        this._setDate(inst, date);
        this._updateDatepicker(inst);
        this._updateAlternate(inst);
      }
    },
    _getDateDatepicker: function(target, noDefault) {
      var inst = this._getInst(target);
      if (inst && !inst.inline) {
        this._setDateFromField(inst, noDefault);
      }
      return inst ? this._getDate(inst) : null;
    },
    _doKeyDown: function(event) {
      var onSelect, dateStr, sel, inst = $.datepicker._getInst(event.target), handled = true, isRTL = inst.dpDiv.is(".ui-datepicker-rtl");
      inst._keyEvent = true;
      if ($.datepicker._datepickerShowing) {
        switch (event.keyCode) {
         case 9:
          $.datepicker._hideDatepicker();
          handled = false;
          break;

         case 13:
          sel = $("td." + $.datepicker._dayOverClass + ":not(." + $.datepicker._currentClass + ")", inst.dpDiv);
          if (sel[0]) {
            $.datepicker._selectDay(event.target, inst.selectedMonth, inst.selectedYear, sel[0]);
          }
          onSelect = $.datepicker._get(inst, "onSelect");
          if (onSelect) {
            dateStr = $.datepicker._formatDate(inst);
            onSelect.apply(inst.input ? inst.input[0] : null, [ dateStr, inst ]);
          } else {
            $.datepicker._hideDatepicker();
          }
          return false;

         case 27:
          $.datepicker._hideDatepicker();
          break;

         case 33:
          $.datepicker._adjustDate(event.target, event.ctrlKey ? -$.datepicker._get(inst, "stepBigMonths") : -$.datepicker._get(inst, "stepMonths"), "M");
          break;

         case 34:
          $.datepicker._adjustDate(event.target, event.ctrlKey ? +$.datepicker._get(inst, "stepBigMonths") : +$.datepicker._get(inst, "stepMonths"), "M");
          break;

         case 35:
          if (event.ctrlKey || event.metaKey) {
            $.datepicker._clearDate(event.target);
          }
          handled = event.ctrlKey || event.metaKey;
          break;

         case 36:
          if (event.ctrlKey || event.metaKey) {
            $.datepicker._gotoToday(event.target);
          }
          handled = event.ctrlKey || event.metaKey;
          break;

         case 37:
          if (event.ctrlKey || event.metaKey) {
            $.datepicker._adjustDate(event.target, isRTL ? +1 : -1, "D");
          }
          handled = event.ctrlKey || event.metaKey;
          if (event.originalEvent.altKey) {
            $.datepicker._adjustDate(event.target, event.ctrlKey ? -$.datepicker._get(inst, "stepBigMonths") : -$.datepicker._get(inst, "stepMonths"), "M");
          }
          break;

         case 38:
          if (event.ctrlKey || event.metaKey) {
            $.datepicker._adjustDate(event.target, -7, "D");
          }
          handled = event.ctrlKey || event.metaKey;
          break;

         case 39:
          if (event.ctrlKey || event.metaKey) {
            $.datepicker._adjustDate(event.target, isRTL ? -1 : +1, "D");
          }
          handled = event.ctrlKey || event.metaKey;
          if (event.originalEvent.altKey) {
            $.datepicker._adjustDate(event.target, event.ctrlKey ? +$.datepicker._get(inst, "stepBigMonths") : +$.datepicker._get(inst, "stepMonths"), "M");
          }
          break;

         case 40:
          if (event.ctrlKey || event.metaKey) {
            $.datepicker._adjustDate(event.target, +7, "D");
          }
          handled = event.ctrlKey || event.metaKey;
          break;

         default:
          handled = false;
        }
      } else if (event.keyCode === 36 && event.ctrlKey) {
        $.datepicker._showDatepicker(this);
      } else {
        handled = false;
      }
      if (handled) {
        event.preventDefault();
        event.stopPropagation();
      }
    },
    _doKeyPress: function(event) {
      var chars, chr, inst = $.datepicker._getInst(event.target);
      if ($.datepicker._get(inst, "constrainInput")) {
        chars = $.datepicker._possibleChars($.datepicker._get(inst, "dateFormat"));
        chr = String.fromCharCode(event.charCode == null ? event.keyCode : event.charCode);
        return event.ctrlKey || event.metaKey || (chr < " " || !chars || chars.indexOf(chr) > -1);
      }
    },
    _doKeyUp: function(event) {
      var date, inst = $.datepicker._getInst(event.target);
      if (inst.input.val() !== inst.lastVal) {
        try {
          date = $.datepicker.parseDate($.datepicker._get(inst, "dateFormat"), inst.input ? inst.input.val() : null, $.datepicker._getFormatConfig(inst));
          if (date) {
            $.datepicker._setDateFromField(inst);
            $.datepicker._updateAlternate(inst);
            $.datepicker._updateDatepicker(inst);
          }
        } catch (err) {}
      }
      return true;
    },
    _showDatepicker: function(input) {
      input = input.target || input;
      if (input.nodeName.toLowerCase() !== "input") {
        input = $("input", input.parentNode)[0];
      }
      if ($.datepicker._isDisabledDatepicker(input) || $.datepicker._lastInput === input) {
        return;
      }
      var inst, beforeShow, beforeShowSettings, isFixed, offset, showAnim, duration;
      inst = $.datepicker._getInst(input);
      if ($.datepicker._curInst && $.datepicker._curInst !== inst) {
        $.datepicker._curInst.dpDiv.stop(true, true);
        if (inst && $.datepicker._datepickerShowing) {
          $.datepicker._hideDatepicker($.datepicker._curInst.input[0]);
        }
      }
      beforeShow = $.datepicker._get(inst, "beforeShow");
      beforeShowSettings = beforeShow ? beforeShow.apply(input, [ input, inst ]) : {};
      if (beforeShowSettings === false) {
        return;
      }
      datepicker_extendRemove(inst.settings, beforeShowSettings);
      inst.lastVal = null;
      $.datepicker._lastInput = input;
      $.datepicker._setDateFromField(inst);
      if ($.datepicker._inDialog) {
        input.value = "";
      }
      if (!$.datepicker._pos) {
        $.datepicker._pos = $.datepicker._findPos(input);
        $.datepicker._pos[1] += input.offsetHeight;
      }
      isFixed = false;
      $(input).parents().each((function() {
        isFixed |= $(this).css("position") === "fixed";
        return !isFixed;
      }));
      offset = {
        left: $.datepicker._pos[0],
        top: $.datepicker._pos[1]
      };
      $.datepicker._pos = null;
      inst.dpDiv.empty();
      inst.dpDiv.css({
        position: "absolute",
        display: "block",
        top: "-1000px"
      });
      $.datepicker._updateDatepicker(inst);
      offset = $.datepicker._checkOffset(inst, offset, isFixed);
      inst.dpDiv.css({
        position: $.datepicker._inDialog && $.blockUI ? "static" : isFixed ? "fixed" : "absolute",
        display: "none",
        left: offset.left + "px",
        top: offset.top + "px"
      });
      if (!inst.inline) {
        showAnim = $.datepicker._get(inst, "showAnim");
        duration = $.datepicker._get(inst, "duration");
        inst.dpDiv.css("z-index", datepicker_getZindex($(input)) + 1);
        $.datepicker._datepickerShowing = true;
        if ($.effects && $.effects.effect[showAnim]) {
          inst.dpDiv.show(showAnim, $.datepicker._get(inst, "showOptions"), duration);
        } else {
          inst.dpDiv[showAnim || "show"](showAnim ? duration : null);
        }
        if ($.datepicker._shouldFocusInput(inst)) {
          inst.input.trigger("focus");
        }
        $.datepicker._curInst = inst;
      }
    },
    _updateDatepicker: function(inst) {
      this.maxRows = 4;
      datepicker_instActive = inst;
      inst.dpDiv.empty().append(this._generateHTML(inst));
      this._attachHandlers(inst);
      var origyearshtml, numMonths = this._getNumberOfMonths(inst), cols = numMonths[1], width = 17, activeCell = inst.dpDiv.find("." + this._dayOverClass + " a"), onUpdateDatepicker = $.datepicker._get(inst, "onUpdateDatepicker");
      if (activeCell.length > 0) {
        datepicker_handleMouseover.apply(activeCell.get(0));
      }
      inst.dpDiv.removeClass("ui-datepicker-multi-2 ui-datepicker-multi-3 ui-datepicker-multi-4").width("");
      if (cols > 1) {
        inst.dpDiv.addClass("ui-datepicker-multi-" + cols).css("width", width * cols + "em");
      }
      inst.dpDiv[(numMonths[0] !== 1 || numMonths[1] !== 1 ? "add" : "remove") + "Class"]("ui-datepicker-multi");
      inst.dpDiv[(this._get(inst, "isRTL") ? "add" : "remove") + "Class"]("ui-datepicker-rtl");
      if (inst === $.datepicker._curInst && $.datepicker._datepickerShowing && $.datepicker._shouldFocusInput(inst)) {
        inst.input.trigger("focus");
      }
      if (inst.yearshtml) {
        origyearshtml = inst.yearshtml;
        setTimeout((function() {
          if (origyearshtml === inst.yearshtml && inst.yearshtml) {
            inst.dpDiv.find("select.ui-datepicker-year").first().replaceWith(inst.yearshtml);
          }
          origyearshtml = inst.yearshtml = null;
        }), 0);
      }
      if (onUpdateDatepicker) {
        onUpdateDatepicker.apply(inst.input ? inst.input[0] : null, [ inst ]);
      }
    },
    _shouldFocusInput: function(inst) {
      return inst.input && inst.input.is(":visible") && !inst.input.is(":disabled");
    },
    _checkOffset: function(inst, offset, isFixed) {
      var dpWidth = inst.dpDiv.outerWidth(), dpHeight = inst.dpDiv.outerHeight(), inputWidth = inst.input ? inst.input.outerWidth() : 0, inputHeight = inst.input ? inst.input.outerHeight() : 0, viewWidth = document.documentElement.clientWidth + (isFixed ? 0 : $(document).scrollLeft()), viewHeight = document.documentElement.clientHeight + (isFixed ? 0 : $(document).scrollTop());
      offset.left -= this._get(inst, "isRTL") ? dpWidth - inputWidth : 0;
      offset.left -= isFixed && offset.left === inst.input.offset().left ? $(document).scrollLeft() : 0;
      offset.top -= isFixed && offset.top === inst.input.offset().top + inputHeight ? $(document).scrollTop() : 0;
      offset.left -= Math.min(offset.left, offset.left + dpWidth > viewWidth && viewWidth > dpWidth ? Math.abs(offset.left + dpWidth - viewWidth) : 0);
      offset.top -= Math.min(offset.top, offset.top + dpHeight > viewHeight && viewHeight > dpHeight ? Math.abs(dpHeight + inputHeight) : 0);
      return offset;
    },
    _findPos: function(obj) {
      var position, inst = this._getInst(obj), isRTL = this._get(inst, "isRTL");
      while (obj && (obj.type === "hidden" || obj.nodeType !== 1 || $.expr.pseudos.hidden(obj))) {
        obj = obj[isRTL ? "previousSibling" : "nextSibling"];
      }
      position = $(obj).offset();
      return [ position.left, position.top ];
    },
    _hideDatepicker: function(input) {
      var showAnim, duration, postProcess, onClose, inst = this._curInst;
      if (!inst || input && inst !== $.data(input, "datepicker")) {
        return;
      }
      if (this._datepickerShowing) {
        showAnim = this._get(inst, "showAnim");
        duration = this._get(inst, "duration");
        postProcess = function() {
          $.datepicker._tidyDialog(inst);
        };
        if ($.effects && $.effects.effect[showAnim]) {
          inst.dpDiv.hide(showAnim, $.datepicker._get(inst, "showOptions"), duration, postProcess);
        } else {
          inst.dpDiv[showAnim === "slideDown" ? "slideUp" : showAnim === "fadeIn" ? "fadeOut" : "hide"](showAnim ? duration : null, postProcess);
        }
        if (!showAnim) {
          postProcess();
        }
        this._datepickerShowing = false;
        onClose = this._get(inst, "onClose");
        if (onClose) {
          onClose.apply(inst.input ? inst.input[0] : null, [ inst.input ? inst.input.val() : "", inst ]);
        }
        this._lastInput = null;
        if (this._inDialog) {
          this._dialogInput.css({
            position: "absolute",
            left: "0",
            top: "-100px"
          });
          if ($.blockUI) {
            $.unblockUI();
            $("body").append(this.dpDiv);
          }
        }
        this._inDialog = false;
      }
    },
    _tidyDialog: function(inst) {
      inst.dpDiv.removeClass(this._dialogClass).off(".ui-datepicker-calendar");
    },
    _checkExternalClick: function(event) {
      if (!$.datepicker._curInst) {
        return;
      }
      var $target = $(event.target), inst = $.datepicker._getInst($target[0]);
      if ($target[0].id !== $.datepicker._mainDivId && $target.parents("#" + $.datepicker._mainDivId).length === 0 && !$target.hasClass($.datepicker.markerClassName) && !$target.closest("." + $.datepicker._triggerClass).length && $.datepicker._datepickerShowing && !($.datepicker._inDialog && $.blockUI) || $target.hasClass($.datepicker.markerClassName) && $.datepicker._curInst !== inst) {
        $.datepicker._hideDatepicker();
      }
    },
    _adjustDate: function(id, offset, period) {
      var target = $(id), inst = this._getInst(target[0]);
      if (this._isDisabledDatepicker(target[0])) {
        return;
      }
      this._adjustInstDate(inst, offset, period);
      this._updateDatepicker(inst);
    },
    _gotoToday: function(id) {
      var date, target = $(id), inst = this._getInst(target[0]);
      if (this._get(inst, "gotoCurrent") && inst.currentDay) {
        inst.selectedDay = inst.currentDay;
        inst.drawMonth = inst.selectedMonth = inst.currentMonth;
        inst.drawYear = inst.selectedYear = inst.currentYear;
      } else {
        date = new Date;
        inst.selectedDay = date.getDate();
        inst.drawMonth = inst.selectedMonth = date.getMonth();
        inst.drawYear = inst.selectedYear = date.getFullYear();
      }
      this._notifyChange(inst);
      this._adjustDate(target);
    },
    _selectMonthYear: function(id, select, period) {
      var target = $(id), inst = this._getInst(target[0]);
      inst["selected" + (period === "M" ? "Month" : "Year")] = inst["draw" + (period === "M" ? "Month" : "Year")] = parseInt(select.options[select.selectedIndex].value, 10);
      this._notifyChange(inst);
      this._adjustDate(target);
    },
    _selectDay: function(id, month, year, td) {
      var inst, target = $(id);
      if ($(td).hasClass(this._unselectableClass) || this._isDisabledDatepicker(target[0])) {
        return;
      }
      inst = this._getInst(target[0]);
      inst.selectedDay = inst.currentDay = parseInt($("a", td).attr("data-date"));
      inst.selectedMonth = inst.currentMonth = month;
      inst.selectedYear = inst.currentYear = year;
      this._selectDate(id, this._formatDate(inst, inst.currentDay, inst.currentMonth, inst.currentYear));
    },
    _clearDate: function(id) {
      var target = $(id);
      this._selectDate(target, "");
    },
    _selectDate: function(id, dateStr) {
      var onSelect, target = $(id), inst = this._getInst(target[0]);
      dateStr = dateStr != null ? dateStr : this._formatDate(inst);
      if (inst.input) {
        inst.input.val(dateStr);
      }
      this._updateAlternate(inst);
      onSelect = this._get(inst, "onSelect");
      if (onSelect) {
        onSelect.apply(inst.input ? inst.input[0] : null, [ dateStr, inst ]);
      } else if (inst.input) {
        inst.input.trigger("change");
      }
      if (inst.inline) {
        this._updateDatepicker(inst);
      } else {
        this._hideDatepicker();
        this._lastInput = inst.input[0];
        if (typeof inst.input[0] !== "object") {
          inst.input.trigger("focus");
        }
        this._lastInput = null;
      }
    },
    _updateAlternate: function(inst) {
      var altFormat, date, dateStr, altField = this._get(inst, "altField");
      if (altField) {
        altFormat = this._get(inst, "altFormat") || this._get(inst, "dateFormat");
        date = this._getDate(inst);
        dateStr = this.formatDate(altFormat, date, this._getFormatConfig(inst));
        $(document).find(altField).val(dateStr);
      }
    },
    noWeekends: function(date) {
      var day = date.getDay();
      return [ day > 0 && day < 6, "" ];
    },
    iso8601Week: function(date) {
      var time, checkDate = new Date(date.getTime());
      checkDate.setDate(checkDate.getDate() + 4 - (checkDate.getDay() || 7));
      time = checkDate.getTime();
      checkDate.setMonth(0);
      checkDate.setDate(1);
      return Math.floor(Math.round((time - checkDate) / 864e5) / 7) + 1;
    },
    parseDate: function(format, value, settings) {
      if (format == null || value == null) {
        throw "Invalid arguments";
      }
      value = typeof value === "object" ? value.toString() : value + "";
      if (value === "") {
        return null;
      }
      var iFormat, dim, extra, iValue = 0, shortYearCutoffTemp = (settings ? settings.shortYearCutoff : null) || this._defaults.shortYearCutoff, shortYearCutoff = typeof shortYearCutoffTemp !== "string" ? shortYearCutoffTemp : (new Date).getFullYear() % 100 + parseInt(shortYearCutoffTemp, 10), dayNamesShort = (settings ? settings.dayNamesShort : null) || this._defaults.dayNamesShort, dayNames = (settings ? settings.dayNames : null) || this._defaults.dayNames, monthNamesShort = (settings ? settings.monthNamesShort : null) || this._defaults.monthNamesShort, monthNames = (settings ? settings.monthNames : null) || this._defaults.monthNames, year = -1, month = -1, day = -1, doy = -1, literal = false, date, lookAhead = function(match) {
        var matches = iFormat + 1 < format.length && format.charAt(iFormat + 1) === match;
        if (matches) {
          iFormat++;
        }
        return matches;
      }, getNumber = function(match) {
        var isDoubled = lookAhead(match), size = match === "@" ? 14 : match === "!" ? 20 : match === "y" && isDoubled ? 4 : match === "o" ? 3 : 2, minSize = match === "y" ? size : 1, digits = new RegExp("^\\d{" + minSize + "," + size + "}"), num = value.substring(iValue).match(digits);
        if (!num) {
          throw "Missing number at position " + iValue;
        }
        iValue += num[0].length;
        return parseInt(num[0], 10);
      }, getName = function(match, shortNames, longNames) {
        var index = -1, names = $.map(lookAhead(match) ? longNames : shortNames, (function(v, k) {
          return [ [ k, v ] ];
        })).sort((function(a, b) {
          return -(a[1].length - b[1].length);
        }));
        $.each(names, (function(i, pair) {
          var name = pair[1];
          if (value.substr(iValue, name.length).toLowerCase() === name.toLowerCase()) {
            index = pair[0];
            iValue += name.length;
            return false;
          }
        }));
        if (index !== -1) {
          return index + 1;
        } else {
          throw "Unknown name at position " + iValue;
        }
      }, checkLiteral = function() {
        if (value.charAt(iValue) !== format.charAt(iFormat)) {
          throw "Unexpected literal at position " + iValue;
        }
        iValue++;
      };
      for (iFormat = 0; iFormat < format.length; iFormat++) {
        if (literal) {
          if (format.charAt(iFormat) === "'" && !lookAhead("'")) {
            literal = false;
          } else {
            checkLiteral();
          }
        } else {
          switch (format.charAt(iFormat)) {
           case "d":
            day = getNumber("d");
            break;

           case "D":
            getName("D", dayNamesShort, dayNames);
            break;

           case "o":
            doy = getNumber("o");
            break;

           case "m":
            month = getNumber("m");
            break;

           case "M":
            month = getName("M", monthNamesShort, monthNames);
            break;

           case "y":
            year = getNumber("y");
            break;

           case "@":
            date = new Date(getNumber("@"));
            year = date.getFullYear();
            month = date.getMonth() + 1;
            day = date.getDate();
            break;

           case "!":
            date = new Date((getNumber("!") - this._ticksTo1970) / 1e4);
            year = date.getFullYear();
            month = date.getMonth() + 1;
            day = date.getDate();
            break;

           case "'":
            if (lookAhead("'")) {
              checkLiteral();
            } else {
              literal = true;
            }
            break;

           default:
            checkLiteral();
          }
        }
      }
      if (iValue < value.length) {
        extra = value.substr(iValue);
        if (!/^\s+/.test(extra)) {
          throw "Extra/unparsed characters found in date: " + extra;
        }
      }
      if (year === -1) {
        year = (new Date).getFullYear();
      } else if (year < 100) {
        year += (new Date).getFullYear() - (new Date).getFullYear() % 100 + (year <= shortYearCutoff ? 0 : -100);
      }
      if (doy > -1) {
        month = 1;
        day = doy;
        do {
          dim = this._getDaysInMonth(year, month - 1);
          if (day <= dim) {
            break;
          }
          month++;
          day -= dim;
        } while (true);
      }
      date = this._daylightSavingAdjust(new Date(year, month - 1, day));
      if (date.getFullYear() !== year || date.getMonth() + 1 !== month || date.getDate() !== day) {
        throw "Invalid date";
      }
      return date;
    },
    ATOM: "yy-mm-dd",
    COOKIE: "D, dd M yy",
    ISO_8601: "yy-mm-dd",
    RFC_822: "D, d M y",
    RFC_850: "DD, dd-M-y",
    RFC_1036: "D, d M y",
    RFC_1123: "D, d M yy",
    RFC_2822: "D, d M yy",
    RSS: "D, d M y",
    TICKS: "!",
    TIMESTAMP: "@",
    W3C: "yy-mm-dd",
    _ticksTo1970: ((1970 - 1) * 365 + Math.floor(1970 / 4) - Math.floor(1970 / 100) + Math.floor(1970 / 400)) * 24 * 60 * 60 * 1e7,
    formatDate: function(format, date, settings) {
      if (!date) {
        return "";
      }
      var iFormat, dayNamesShort = (settings ? settings.dayNamesShort : null) || this._defaults.dayNamesShort, dayNames = (settings ? settings.dayNames : null) || this._defaults.dayNames, monthNamesShort = (settings ? settings.monthNamesShort : null) || this._defaults.monthNamesShort, monthNames = (settings ? settings.monthNames : null) || this._defaults.monthNames, lookAhead = function(match) {
        var matches = iFormat + 1 < format.length && format.charAt(iFormat + 1) === match;
        if (matches) {
          iFormat++;
        }
        return matches;
      }, formatNumber = function(match, value, len) {
        var num = "" + value;
        if (lookAhead(match)) {
          while (num.length < len) {
            num = "0" + num;
          }
        }
        return num;
      }, formatName = function(match, value, shortNames, longNames) {
        return lookAhead(match) ? longNames[value] : shortNames[value];
      }, output = "", literal = false;
      if (date) {
        for (iFormat = 0; iFormat < format.length; iFormat++) {
          if (literal) {
            if (format.charAt(iFormat) === "'" && !lookAhead("'")) {
              literal = false;
            } else {
              output += format.charAt(iFormat);
            }
          } else {
            switch (format.charAt(iFormat)) {
             case "d":
              output += formatNumber("d", date.getDate(), 2);
              break;

             case "D":
              output += formatName("D", date.getDay(), dayNamesShort, dayNames);
              break;

             case "o":
              output += formatNumber("o", Math.round((new Date(date.getFullYear(), date.getMonth(), date.getDate()).getTime() - new Date(date.getFullYear(), 0, 0).getTime()) / 864e5), 3);
              break;

             case "m":
              output += formatNumber("m", date.getMonth() + 1, 2);
              break;

             case "M":
              output += formatName("M", date.getMonth(), monthNamesShort, monthNames);
              break;

             case "y":
              output += lookAhead("y") ? date.getFullYear() : (date.getFullYear() % 100 < 10 ? "0" : "") + date.getFullYear() % 100;
              break;

             case "@":
              output += date.getTime();
              break;

             case "!":
              output += date.getTime() * 1e4 + this._ticksTo1970;
              break;

             case "'":
              if (lookAhead("'")) {
                output += "'";
              } else {
                literal = true;
              }
              break;

             default:
              output += format.charAt(iFormat);
            }
          }
        }
      }
      return output;
    },
    _possibleChars: function(format) {
      var iFormat, chars = "", literal = false, lookAhead = function(match) {
        var matches = iFormat + 1 < format.length && format.charAt(iFormat + 1) === match;
        if (matches) {
          iFormat++;
        }
        return matches;
      };
      for (iFormat = 0; iFormat < format.length; iFormat++) {
        if (literal) {
          if (format.charAt(iFormat) === "'" && !lookAhead("'")) {
            literal = false;
          } else {
            chars += format.charAt(iFormat);
          }
        } else {
          switch (format.charAt(iFormat)) {
           case "d":
           case "m":
           case "y":
           case "@":
            chars += "0123456789";
            break;

           case "D":
           case "M":
            return null;

           case "'":
            if (lookAhead("'")) {
              chars += "'";
            } else {
              literal = true;
            }
            break;

           default:
            chars += format.charAt(iFormat);
          }
        }
      }
      return chars;
    },
    _get: function(inst, name) {
      return inst.settings[name] !== undefined ? inst.settings[name] : this._defaults[name];
    },
    _setDateFromField: function(inst, noDefault) {
      if (inst.input.val() === inst.lastVal) {
        return;
      }
      var dateFormat = this._get(inst, "dateFormat"), dates = inst.lastVal = inst.input ? inst.input.val() : null, defaultDate = this._getDefaultDate(inst), date = defaultDate, settings = this._getFormatConfig(inst);
      try {
        date = this.parseDate(dateFormat, dates, settings) || defaultDate;
      } catch (event) {
        dates = noDefault ? "" : dates;
      }
      inst.selectedDay = date.getDate();
      inst.drawMonth = inst.selectedMonth = date.getMonth();
      inst.drawYear = inst.selectedYear = date.getFullYear();
      inst.currentDay = dates ? date.getDate() : 0;
      inst.currentMonth = dates ? date.getMonth() : 0;
      inst.currentYear = dates ? date.getFullYear() : 0;
      this._adjustInstDate(inst);
    },
    _getDefaultDate: function(inst) {
      return this._restrictMinMax(inst, this._determineDate(inst, this._get(inst, "defaultDate"), new Date));
    },
    _determineDate: function(inst, date, defaultDate) {
      var offsetNumeric = function(offset) {
        var date = new Date;
        date.setDate(date.getDate() + offset);
        return date;
      }, offsetString = function(offset) {
        try {
          return $.datepicker.parseDate($.datepicker._get(inst, "dateFormat"), offset, $.datepicker._getFormatConfig(inst));
        } catch (e) {}
        var date = (offset.toLowerCase().match(/^c/) ? $.datepicker._getDate(inst) : null) || new Date, year = date.getFullYear(), month = date.getMonth(), day = date.getDate(), pattern = /([+\-]?[0-9]+)\s*(d|D|w|W|m|M|y|Y)?/g, matches = pattern.exec(offset);
        while (matches) {
          switch (matches[2] || "d") {
           case "d":
           case "D":
            day += parseInt(matches[1], 10);
            break;

           case "w":
           case "W":
            day += parseInt(matches[1], 10) * 7;
            break;

           case "m":
           case "M":
            month += parseInt(matches[1], 10);
            day = Math.min(day, $.datepicker._getDaysInMonth(year, month));
            break;

           case "y":
           case "Y":
            year += parseInt(matches[1], 10);
            day = Math.min(day, $.datepicker._getDaysInMonth(year, month));
            break;
          }
          matches = pattern.exec(offset);
        }
        return new Date(year, month, day);
      }, newDate = date == null || date === "" ? defaultDate : typeof date === "string" ? offsetString(date) : typeof date === "number" ? isNaN(date) ? defaultDate : offsetNumeric(date) : new Date(date.getTime());
      newDate = newDate && newDate.toString() === "Invalid Date" ? defaultDate : newDate;
      if (newDate) {
        newDate.setHours(0);
        newDate.setMinutes(0);
        newDate.setSeconds(0);
        newDate.setMilliseconds(0);
      }
      return this._daylightSavingAdjust(newDate);
    },
    _daylightSavingAdjust: function(date) {
      if (!date) {
        return null;
      }
      date.setHours(date.getHours() > 12 ? date.getHours() + 2 : 0);
      return date;
    },
    _setDate: function(inst, date, noChange) {
      var clear = !date, origMonth = inst.selectedMonth, origYear = inst.selectedYear, newDate = this._restrictMinMax(inst, this._determineDate(inst, date, new Date));
      inst.selectedDay = inst.currentDay = newDate.getDate();
      inst.drawMonth = inst.selectedMonth = inst.currentMonth = newDate.getMonth();
      inst.drawYear = inst.selectedYear = inst.currentYear = newDate.getFullYear();
      if ((origMonth !== inst.selectedMonth || origYear !== inst.selectedYear) && !noChange) {
        this._notifyChange(inst);
      }
      this._adjustInstDate(inst);
      if (inst.input) {
        inst.input.val(clear ? "" : this._formatDate(inst));
      }
    },
    _getDate: function(inst) {
      var startDate = !inst.currentYear || inst.input && inst.input.val() === "" ? null : this._daylightSavingAdjust(new Date(inst.currentYear, inst.currentMonth, inst.currentDay));
      return startDate;
    },
    _attachHandlers: function(inst) {
      var stepMonths = this._get(inst, "stepMonths"), id = "#" + inst.id.replace(/\\\\/g, "\\");
      inst.dpDiv.find("[data-handler]").map((function() {
        var handler = {
          prev: function() {
            $.datepicker._adjustDate(id, -stepMonths, "M");
          },
          next: function() {
            $.datepicker._adjustDate(id, +stepMonths, "M");
          },
          hide: function() {
            $.datepicker._hideDatepicker();
          },
          today: function() {
            $.datepicker._gotoToday(id);
          },
          selectDay: function() {
            $.datepicker._selectDay(id, +this.getAttribute("data-month"), +this.getAttribute("data-year"), this);
            return false;
          },
          selectMonth: function() {
            $.datepicker._selectMonthYear(id, this, "M");
            return false;
          },
          selectYear: function() {
            $.datepicker._selectMonthYear(id, this, "Y");
            return false;
          }
        };
        $(this).on(this.getAttribute("data-event"), handler[this.getAttribute("data-handler")]);
      }));
    },
    _generateHTML: function(inst) {
      var maxDraw, prevText, prev, nextText, next, currentText, gotoDate, controls, buttonPanel, firstDay, showWeek, dayNames, dayNamesMin, monthNames, monthNamesShort, beforeShowDay, showOtherMonths, selectOtherMonths, defaultDate, html, dow, row, group, col, selectedDate, cornerClass, calender, thead, day, daysInMonth, leadDays, curRows, numRows, printDate, dRow, tbody, daySettings, otherMonth, unselectable, tempDate = new Date, today = this._daylightSavingAdjust(new Date(tempDate.getFullYear(), tempDate.getMonth(), tempDate.getDate())), isRTL = this._get(inst, "isRTL"), showButtonPanel = this._get(inst, "showButtonPanel"), hideIfNoPrevNext = this._get(inst, "hideIfNoPrevNext"), navigationAsDateFormat = this._get(inst, "navigationAsDateFormat"), numMonths = this._getNumberOfMonths(inst), showCurrentAtPos = this._get(inst, "showCurrentAtPos"), stepMonths = this._get(inst, "stepMonths"), isMultiMonth = numMonths[0] !== 1 || numMonths[1] !== 1, currentDate = this._daylightSavingAdjust(!inst.currentDay ? new Date(9999, 9, 9) : new Date(inst.currentYear, inst.currentMonth, inst.currentDay)), minDate = this._getMinMaxDate(inst, "min"), maxDate = this._getMinMaxDate(inst, "max"), drawMonth = inst.drawMonth - showCurrentAtPos, drawYear = inst.drawYear;
      if (drawMonth < 0) {
        drawMonth += 12;
        drawYear--;
      }
      if (maxDate) {
        maxDraw = this._daylightSavingAdjust(new Date(maxDate.getFullYear(), maxDate.getMonth() - numMonths[0] * numMonths[1] + 1, maxDate.getDate()));
        maxDraw = minDate && maxDraw < minDate ? minDate : maxDraw;
        while (this._daylightSavingAdjust(new Date(drawYear, drawMonth, 1)) > maxDraw) {
          drawMonth--;
          if (drawMonth < 0) {
            drawMonth = 11;
            drawYear--;
          }
        }
      }
      inst.drawMonth = drawMonth;
      inst.drawYear = drawYear;
      prevText = this._get(inst, "prevText");
      prevText = !navigationAsDateFormat ? prevText : this.formatDate(prevText, this._daylightSavingAdjust(new Date(drawYear, drawMonth - stepMonths, 1)), this._getFormatConfig(inst));
      if (this._canAdjustMonth(inst, -1, drawYear, drawMonth)) {
        prev = $("<a>").attr({
          class: "ui-datepicker-prev ui-corner-all",
          "data-handler": "prev",
          "data-event": "click",
          title: prevText
        }).append($("<span>").addClass("ui-icon ui-icon-circle-triangle-" + (isRTL ? "e" : "w")).text(prevText))[0].outerHTML;
      } else if (hideIfNoPrevNext) {
        prev = "";
      } else {
        prev = $("<a>").attr({
          class: "ui-datepicker-prev ui-corner-all ui-state-disabled",
          title: prevText
        }).append($("<span>").addClass("ui-icon ui-icon-circle-triangle-" + (isRTL ? "e" : "w")).text(prevText))[0].outerHTML;
      }
      nextText = this._get(inst, "nextText");
      nextText = !navigationAsDateFormat ? nextText : this.formatDate(nextText, this._daylightSavingAdjust(new Date(drawYear, drawMonth + stepMonths, 1)), this._getFormatConfig(inst));
      if (this._canAdjustMonth(inst, +1, drawYear, drawMonth)) {
        next = $("<a>").attr({
          class: "ui-datepicker-next ui-corner-all",
          "data-handler": "next",
          "data-event": "click",
          title: nextText
        }).append($("<span>").addClass("ui-icon ui-icon-circle-triangle-" + (isRTL ? "w" : "e")).text(nextText))[0].outerHTML;
      } else if (hideIfNoPrevNext) {
        next = "";
      } else {
        next = $("<a>").attr({
          class: "ui-datepicker-next ui-corner-all ui-state-disabled",
          title: nextText
        }).append($("<span>").attr("class", "ui-icon ui-icon-circle-triangle-" + (isRTL ? "w" : "e")).text(nextText))[0].outerHTML;
      }
      currentText = this._get(inst, "currentText");
      gotoDate = this._get(inst, "gotoCurrent") && inst.currentDay ? currentDate : today;
      currentText = !navigationAsDateFormat ? currentText : this.formatDate(currentText, gotoDate, this._getFormatConfig(inst));
      controls = "";
      if (!inst.inline) {
        controls = $("<button>").attr({
          type: "button",
          class: "ui-datepicker-close ui-state-default ui-priority-primary ui-corner-all",
          "data-handler": "hide",
          "data-event": "click"
        }).text(this._get(inst, "closeText"))[0].outerHTML;
      }
      buttonPanel = "";
      if (showButtonPanel) {
        buttonPanel = $("<div class='ui-datepicker-buttonpane ui-widget-content'>").append(isRTL ? controls : "").append(this._isInRange(inst, gotoDate) ? $("<button>").attr({
          type: "button",
          class: "ui-datepicker-current ui-state-default ui-priority-secondary ui-corner-all",
          "data-handler": "today",
          "data-event": "click"
        }).text(currentText) : "").append(isRTL ? "" : controls)[0].outerHTML;
      }
      firstDay = parseInt(this._get(inst, "firstDay"), 10);
      firstDay = isNaN(firstDay) ? 0 : firstDay;
      showWeek = this._get(inst, "showWeek");
      dayNames = this._get(inst, "dayNames");
      dayNamesMin = this._get(inst, "dayNamesMin");
      monthNames = this._get(inst, "monthNames");
      monthNamesShort = this._get(inst, "monthNamesShort");
      beforeShowDay = this._get(inst, "beforeShowDay");
      showOtherMonths = this._get(inst, "showOtherMonths");
      selectOtherMonths = this._get(inst, "selectOtherMonths");
      defaultDate = this._getDefaultDate(inst);
      html = "";
      for (row = 0; row < numMonths[0]; row++) {
        group = "";
        this.maxRows = 4;
        for (col = 0; col < numMonths[1]; col++) {
          selectedDate = this._daylightSavingAdjust(new Date(drawYear, drawMonth, inst.selectedDay));
          cornerClass = " ui-corner-all";
          calender = "";
          if (isMultiMonth) {
            calender += "<div class='ui-datepicker-group";
            if (numMonths[1] > 1) {
              switch (col) {
               case 0:
                calender += " ui-datepicker-group-first";
                cornerClass = " ui-corner-" + (isRTL ? "right" : "left");
                break;

               case numMonths[1] - 1:
                calender += " ui-datepicker-group-last";
                cornerClass = " ui-corner-" + (isRTL ? "left" : "right");
                break;

               default:
                calender += " ui-datepicker-group-middle";
                cornerClass = "";
                break;
              }
            }
            calender += "'>";
          }
          calender += "<div class='ui-datepicker-header ui-widget-header ui-helper-clearfix" + cornerClass + "'>" + (/all|left/.test(cornerClass) && row === 0 ? isRTL ? next : prev : "") + (/all|right/.test(cornerClass) && row === 0 ? isRTL ? prev : next : "") + this._generateMonthYearHeader(inst, drawMonth, drawYear, minDate, maxDate, row > 0 || col > 0, monthNames, monthNamesShort) + "</div><table class='ui-datepicker-calendar'><thead>" + "<tr>";
          thead = showWeek ? "<th class='ui-datepicker-week-col'>" + this._get(inst, "weekHeader") + "</th>" : "";
          for (dow = 0; dow < 7; dow++) {
            day = (dow + firstDay) % 7;
            thead += "<th scope='col'" + ((dow + firstDay + 6) % 7 >= 5 ? " class='ui-datepicker-week-end'" : "") + ">" + "<span title='" + dayNames[day] + "'>" + dayNamesMin[day] + "</span></th>";
          }
          calender += thead + "</tr></thead><tbody>";
          daysInMonth = this._getDaysInMonth(drawYear, drawMonth);
          if (drawYear === inst.selectedYear && drawMonth === inst.selectedMonth) {
            inst.selectedDay = Math.min(inst.selectedDay, daysInMonth);
          }
          leadDays = (this._getFirstDayOfMonth(drawYear, drawMonth) - firstDay + 7) % 7;
          curRows = Math.ceil((leadDays + daysInMonth) / 7);
          numRows = isMultiMonth ? this.maxRows > curRows ? this.maxRows : curRows : curRows;
          this.maxRows = numRows;
          printDate = this._daylightSavingAdjust(new Date(drawYear, drawMonth, 1 - leadDays));
          for (dRow = 0; dRow < numRows; dRow++) {
            calender += "<tr>";
            tbody = !showWeek ? "" : "<td class='ui-datepicker-week-col'>" + this._get(inst, "calculateWeek")(printDate) + "</td>";
            for (dow = 0; dow < 7; dow++) {
              daySettings = beforeShowDay ? beforeShowDay.apply(inst.input ? inst.input[0] : null, [ printDate ]) : [ true, "" ];
              otherMonth = printDate.getMonth() !== drawMonth;
              unselectable = otherMonth && !selectOtherMonths || !daySettings[0] || minDate && printDate < minDate || maxDate && printDate > maxDate;
              tbody += "<td class='" + ((dow + firstDay + 6) % 7 >= 5 ? " ui-datepicker-week-end" : "") + (otherMonth ? " ui-datepicker-other-month" : "") + (printDate.getTime() === selectedDate.getTime() && drawMonth === inst.selectedMonth && inst._keyEvent || defaultDate.getTime() === printDate.getTime() && defaultDate.getTime() === selectedDate.getTime() ? " " + this._dayOverClass : "") + (unselectable ? " " + this._unselectableClass + " ui-state-disabled" : "") + (otherMonth && !showOtherMonths ? "" : " " + daySettings[1] + (printDate.getTime() === currentDate.getTime() ? " " + this._currentClass : "") + (printDate.getTime() === today.getTime() ? " ui-datepicker-today" : "")) + "'" + ((!otherMonth || showOtherMonths) && daySettings[2] ? " title='" + daySettings[2].replace(/'/g, "&#39;") + "'" : "") + (unselectable ? "" : " data-handler='selectDay' data-event='click' data-month='" + printDate.getMonth() + "' data-year='" + printDate.getFullYear() + "'") + ">" + (otherMonth && !showOtherMonths ? "&#xa0;" : unselectable ? "<span class='ui-state-default'>" + printDate.getDate() + "</span>" : "<a class='ui-state-default" + (printDate.getTime() === today.getTime() ? " ui-state-highlight" : "") + (printDate.getTime() === currentDate.getTime() ? " ui-state-active" : "") + (otherMonth ? " ui-priority-secondary" : "") + "' href='#' aria-current='" + (printDate.getTime() === currentDate.getTime() ? "true" : "false") + "' data-date='" + printDate.getDate() + "'>" + printDate.getDate() + "</a>") + "</td>";
              printDate.setDate(printDate.getDate() + 1);
              printDate = this._daylightSavingAdjust(printDate);
            }
            calender += tbody + "</tr>";
          }
          drawMonth++;
          if (drawMonth > 11) {
            drawMonth = 0;
            drawYear++;
          }
          calender += "</tbody></table>" + (isMultiMonth ? "</div>" + (numMonths[0] > 0 && col === numMonths[1] - 1 ? "<div class='ui-datepicker-row-break'></div>" : "") : "");
          group += calender;
        }
        html += group;
      }
      html += buttonPanel;
      inst._keyEvent = false;
      return html;
    },
    _generateMonthYearHeader: function(inst, drawMonth, drawYear, minDate, maxDate, secondary, monthNames, monthNamesShort) {
      var inMinYear, inMaxYear, month, years, thisYear, determineYear, year, endYear, changeMonth = this._get(inst, "changeMonth"), changeYear = this._get(inst, "changeYear"), showMonthAfterYear = this._get(inst, "showMonthAfterYear"), selectMonthLabel = this._get(inst, "selectMonthLabel"), selectYearLabel = this._get(inst, "selectYearLabel"), html = "<div class='ui-datepicker-title'>", monthHtml = "";
      if (secondary || !changeMonth) {
        monthHtml += "<span class='ui-datepicker-month'>" + monthNames[drawMonth] + "</span>";
      } else {
        inMinYear = minDate && minDate.getFullYear() === drawYear;
        inMaxYear = maxDate && maxDate.getFullYear() === drawYear;
        monthHtml += "<select class='ui-datepicker-month' aria-label='" + selectMonthLabel + "' data-handler='selectMonth' data-event='change'>";
        for (month = 0; month < 12; month++) {
          if ((!inMinYear || month >= minDate.getMonth()) && (!inMaxYear || month <= maxDate.getMonth())) {
            monthHtml += "<option value='" + month + "'" + (month === drawMonth ? " selected='selected'" : "") + ">" + monthNamesShort[month] + "</option>";
          }
        }
        monthHtml += "</select>";
      }
      if (!showMonthAfterYear) {
        html += monthHtml + (secondary || !(changeMonth && changeYear) ? "&#xa0;" : "");
      }
      if (!inst.yearshtml) {
        inst.yearshtml = "";
        if (secondary || !changeYear) {
          html += "<span class='ui-datepicker-year'>" + drawYear + "</span>";
        } else {
          years = this._get(inst, "yearRange").split(":");
          thisYear = (new Date).getFullYear();
          determineYear = function(value) {
            var year = value.match(/c[+\-].*/) ? drawYear + parseInt(value.substring(1), 10) : value.match(/[+\-].*/) ? thisYear + parseInt(value, 10) : parseInt(value, 10);
            return isNaN(year) ? thisYear : year;
          };
          year = determineYear(years[0]);
          endYear = Math.max(year, determineYear(years[1] || ""));
          year = minDate ? Math.max(year, minDate.getFullYear()) : year;
          endYear = maxDate ? Math.min(endYear, maxDate.getFullYear()) : endYear;
          inst.yearshtml += "<select class='ui-datepicker-year' aria-label='" + selectYearLabel + "' data-handler='selectYear' data-event='change'>";
          for (;year <= endYear; year++) {
            inst.yearshtml += "<option value='" + year + "'" + (year === drawYear ? " selected='selected'" : "") + ">" + year + "</option>";
          }
          inst.yearshtml += "</select>";
          html += inst.yearshtml;
          inst.yearshtml = null;
        }
      }
      html += this._get(inst, "yearSuffix");
      if (showMonthAfterYear) {
        html += (secondary || !(changeMonth && changeYear) ? "&#xa0;" : "") + monthHtml;
      }
      html += "</div>";
      return html;
    },
    _adjustInstDate: function(inst, offset, period) {
      var year = inst.selectedYear + (period === "Y" ? offset : 0), month = inst.selectedMonth + (period === "M" ? offset : 0), day = Math.min(inst.selectedDay, this._getDaysInMonth(year, month)) + (period === "D" ? offset : 0), date = this._restrictMinMax(inst, this._daylightSavingAdjust(new Date(year, month, day)));
      inst.selectedDay = date.getDate();
      inst.drawMonth = inst.selectedMonth = date.getMonth();
      inst.drawYear = inst.selectedYear = date.getFullYear();
      if (period === "M" || period === "Y") {
        this._notifyChange(inst);
      }
    },
    _restrictMinMax: function(inst, date) {
      var minDate = this._getMinMaxDate(inst, "min"), maxDate = this._getMinMaxDate(inst, "max"), newDate = minDate && date < minDate ? minDate : date;
      return maxDate && newDate > maxDate ? maxDate : newDate;
    },
    _notifyChange: function(inst) {
      var onChange = this._get(inst, "onChangeMonthYear");
      if (onChange) {
        onChange.apply(inst.input ? inst.input[0] : null, [ inst.selectedYear, inst.selectedMonth + 1, inst ]);
      }
    },
    _getNumberOfMonths: function(inst) {
      var numMonths = this._get(inst, "numberOfMonths");
      return numMonths == null ? [ 1, 1 ] : typeof numMonths === "number" ? [ 1, numMonths ] : numMonths;
    },
    _getMinMaxDate: function(inst, minMax) {
      return this._determineDate(inst, this._get(inst, minMax + "Date"), null);
    },
    _getDaysInMonth: function(year, month) {
      return 32 - this._daylightSavingAdjust(new Date(year, month, 32)).getDate();
    },
    _getFirstDayOfMonth: function(year, month) {
      return new Date(year, month, 1).getDay();
    },
    _canAdjustMonth: function(inst, offset, curYear, curMonth) {
      var numMonths = this._getNumberOfMonths(inst), date = this._daylightSavingAdjust(new Date(curYear, curMonth + (offset < 0 ? offset : numMonths[0] * numMonths[1]), 1));
      if (offset < 0) {
        date.setDate(this._getDaysInMonth(date.getFullYear(), date.getMonth()));
      }
      return this._isInRange(inst, date);
    },
    _isInRange: function(inst, date) {
      var yearSplit, currentYear, minDate = this._getMinMaxDate(inst, "min"), maxDate = this._getMinMaxDate(inst, "max"), minYear = null, maxYear = null, years = this._get(inst, "yearRange");
      if (years) {
        yearSplit = years.split(":");
        currentYear = (new Date).getFullYear();
        minYear = parseInt(yearSplit[0], 10);
        maxYear = parseInt(yearSplit[1], 10);
        if (yearSplit[0].match(/[+\-].*/)) {
          minYear += currentYear;
        }
        if (yearSplit[1].match(/[+\-].*/)) {
          maxYear += currentYear;
        }
      }
      return (!minDate || date.getTime() >= minDate.getTime()) && (!maxDate || date.getTime() <= maxDate.getTime()) && (!minYear || date.getFullYear() >= minYear) && (!maxYear || date.getFullYear() <= maxYear);
    },
    _getFormatConfig: function(inst) {
      var shortYearCutoff = this._get(inst, "shortYearCutoff");
      shortYearCutoff = typeof shortYearCutoff !== "string" ? shortYearCutoff : (new Date).getFullYear() % 100 + parseInt(shortYearCutoff, 10);
      return {
        shortYearCutoff: shortYearCutoff,
        dayNamesShort: this._get(inst, "dayNamesShort"),
        dayNames: this._get(inst, "dayNames"),
        monthNamesShort: this._get(inst, "monthNamesShort"),
        monthNames: this._get(inst, "monthNames")
      };
    },
    _formatDate: function(inst, day, month, year) {
      if (!day) {
        inst.currentDay = inst.selectedDay;
        inst.currentMonth = inst.selectedMonth;
        inst.currentYear = inst.selectedYear;
      }
      var date = day ? typeof day === "object" ? day : this._daylightSavingAdjust(new Date(year, month, day)) : this._daylightSavingAdjust(new Date(inst.currentYear, inst.currentMonth, inst.currentDay));
      return this.formatDate(this._get(inst, "dateFormat"), date, this._getFormatConfig(inst));
    }
  });
  function datepicker_bindHover(dpDiv) {
    var selector = "button, .ui-datepicker-prev, .ui-datepicker-next, .ui-datepicker-calendar td a";
    return dpDiv.on("mouseout", selector, (function() {
      $(this).removeClass("ui-state-hover");
      if (this.className.indexOf("ui-datepicker-prev") !== -1) {
        $(this).removeClass("ui-datepicker-prev-hover");
      }
      if (this.className.indexOf("ui-datepicker-next") !== -1) {
        $(this).removeClass("ui-datepicker-next-hover");
      }
    })).on("mouseover", selector, datepicker_handleMouseover);
  }
  function datepicker_handleMouseover() {
    if (!$.datepicker._isDisabledDatepicker(datepicker_instActive.inline ? datepicker_instActive.dpDiv.parent()[0] : datepicker_instActive.input[0])) {
      $(this).parents(".ui-datepicker-calendar").find("a").removeClass("ui-state-hover");
      $(this).addClass("ui-state-hover");
      if (this.className.indexOf("ui-datepicker-prev") !== -1) {
        $(this).addClass("ui-datepicker-prev-hover");
      }
      if (this.className.indexOf("ui-datepicker-next") !== -1) {
        $(this).addClass("ui-datepicker-next-hover");
      }
    }
  }
  function datepicker_extendRemove(target, props) {
    $.extend(target, props);
    for (var name in props) {
      if (props[name] == null) {
        target[name] = props[name];
      }
    }
    return target;
  }
  $.fn.datepicker = function(options) {
    if (!this.length) {
      return this;
    }
    if (!$.datepicker.initialized) {
      $(document).on("mousedown", $.datepicker._checkExternalClick);
      $.datepicker.initialized = true;
    }
    if ($("#" + $.datepicker._mainDivId).length === 0) {
      $("body").append($.datepicker.dpDiv);
    }
    var otherArgs = Array.prototype.slice.call(arguments, 1);
    if (typeof options === "string" && (options === "isDisabled" || options === "getDate" || options === "widget")) {
      return $.datepicker["_" + options + "Datepicker"].apply($.datepicker, [ this[0] ].concat(otherArgs));
    }
    if (options === "option" && arguments.length === 2 && typeof arguments[1] === "string") {
      return $.datepicker["_" + options + "Datepicker"].apply($.datepicker, [ this[0] ].concat(otherArgs));
    }
    return this.each((function() {
      if (typeof options === "string") {
        $.datepicker["_" + options + "Datepicker"].apply($.datepicker, [ this ].concat(otherArgs));
      } else {
        $.datepicker._attachDatepicker(this, options);
      }
    }));
  };
  $.datepicker = new Datepicker;
  $.datepicker.initialized = false;
  $.datepicker.uuid = (new Date).getTime();
  $.datepicker.version = "1.14.0";
  $.datepicker;
  /*!
 * jQuery UI Dialog 1.14.0
 * https://jqueryui.com
 *
 * Copyright OpenJS Foundation and other contributors
 * Released under the MIT license.
 * https://jquery.org/license
 */  $.widget("ui.dialog", {
    version: "1.14.0",
    options: {
      appendTo: "body",
      autoOpen: true,
      buttons: [],
      classes: {
        "ui-dialog": "ui-corner-all",
        "ui-dialog-titlebar": "ui-corner-all"
      },
      closeOnEscape: true,
      closeText: "Close",
      draggable: true,
      hide: null,
      height: "auto",
      maxHeight: null,
      maxWidth: null,
      minHeight: 150,
      minWidth: 150,
      modal: false,
      position: {
        my: "center",
        at: "center",
        of: window,
        collision: "fit",
        using: function(pos) {
          var topOffset = $(this).css(pos).offset().top;
          if (topOffset < 0) {
            $(this).css("top", pos.top - topOffset);
          }
        }
      },
      resizable: true,
      show: null,
      title: null,
      width: 300,
      beforeClose: null,
      close: null,
      drag: null,
      dragStart: null,
      dragStop: null,
      focus: null,
      open: null,
      resize: null,
      resizeStart: null,
      resizeStop: null
    },
    sizeRelatedOptions: {
      buttons: true,
      height: true,
      maxHeight: true,
      maxWidth: true,
      minHeight: true,
      minWidth: true,
      width: true
    },
    resizableRelatedOptions: {
      maxHeight: true,
      maxWidth: true,
      minHeight: true,
      minWidth: true
    },
    _create: function() {
      this.originalCss = {
        display: this.element[0].style.display,
        width: this.element[0].style.width,
        minHeight: this.element[0].style.minHeight,
        maxHeight: this.element[0].style.maxHeight,
        height: this.element[0].style.height
      };
      this.originalPosition = {
        parent: this.element.parent(),
        index: this.element.parent().children().index(this.element)
      };
      this.originalTitle = this.element.attr("title");
      if (this.options.title == null && this.originalTitle != null) {
        this.options.title = this.originalTitle;
      }
      if (this.options.disabled) {
        this.options.disabled = false;
      }
      this._createWrapper();
      this.element.show().removeAttr("title").appendTo(this.uiDialog);
      this._addClass("ui-dialog-content", "ui-widget-content");
      this._createTitlebar();
      this._createButtonPane();
      if (this.options.draggable && $.fn.draggable) {
        this._makeDraggable();
      }
      if (this.options.resizable && $.fn.resizable) {
        this._makeResizable();
      }
      this._isOpen = false;
      this._trackFocus();
    },
    _init: function() {
      if (this.options.autoOpen) {
        this.open();
      }
    },
    _appendTo: function() {
      var element = this.options.appendTo;
      if (element && (element.jquery || element.nodeType)) {
        return $(element);
      }
      return this.document.find(element || "body").eq(0);
    },
    _destroy: function() {
      var next, originalPosition = this.originalPosition;
      this._untrackInstance();
      this._destroyOverlay();
      this.element.removeUniqueId().css(this.originalCss).detach();
      this.uiDialog.remove();
      if (this.originalTitle) {
        this.element.attr("title", this.originalTitle);
      }
      next = originalPosition.parent.children().eq(originalPosition.index);
      if (next.length && next[0] !== this.element[0]) {
        next.before(this.element);
      } else {
        originalPosition.parent.append(this.element);
      }
    },
    widget: function() {
      return this.uiDialog;
    },
    disable: $.noop,
    enable: $.noop,
    close: function(event) {
      var that = this;
      if (!this._isOpen || this._trigger("beforeClose", event) === false) {
        return;
      }
      this._isOpen = false;
      this._focusedElement = null;
      this._destroyOverlay();
      this._untrackInstance();
      if (!this.opener.filter(":focusable").trigger("focus").length) {
        $(this.document[0].activeElement).trigger("blur");
      }
      this._hide(this.uiDialog, this.options.hide, (function() {
        that._trigger("close", event);
      }));
    },
    isOpen: function() {
      return this._isOpen;
    },
    moveToTop: function() {
      this._moveToTop();
    },
    _moveToTop: function(event, silent) {
      var moved = false, zIndices = this.uiDialog.siblings(".ui-front:visible").map((function() {
        return +$(this).css("z-index");
      })).get(), zIndexMax = Math.max.apply(null, zIndices);
      if (zIndexMax >= +this.uiDialog.css("z-index")) {
        this.uiDialog.css("z-index", zIndexMax + 1);
        moved = true;
      }
      if (moved && !silent) {
        this._trigger("focus", event);
      }
      return moved;
    },
    open: function() {
      var that = this;
      if (this._isOpen) {
        if (this._moveToTop()) {
          this._focusTabbable();
        }
        return;
      }
      this._isOpen = true;
      this.opener = $(this.document[0].activeElement);
      this._size();
      this._position();
      this._createOverlay();
      this._moveToTop(null, true);
      if (this.overlay) {
        this.overlay.css("z-index", this.uiDialog.css("z-index") - 1);
      }
      this._show(this.uiDialog, this.options.show, (function() {
        that._focusTabbable();
        that._trigger("focus");
      }));
      this._makeFocusTarget();
      this._trigger("open");
    },
    _focusTabbable: function() {
      var hasFocus = this._focusedElement;
      if (!hasFocus) {
        hasFocus = this.element.find("[autofocus]");
      }
      if (!hasFocus.length) {
        hasFocus = this.element.find(":tabbable");
      }
      if (!hasFocus.length) {
        hasFocus = this.uiDialogButtonPane.find(":tabbable");
      }
      if (!hasFocus.length) {
        hasFocus = this.uiDialogTitlebarClose.filter(":tabbable");
      }
      if (!hasFocus.length) {
        hasFocus = this.uiDialog;
      }
      hasFocus.eq(0).trigger("focus");
    },
    _restoreTabbableFocus: function() {
      var activeElement = this.document[0].activeElement, isActive = this.uiDialog[0] === activeElement || $.contains(this.uiDialog[0], activeElement);
      if (!isActive) {
        this._focusTabbable();
      }
    },
    _keepFocus: function(event) {
      event.preventDefault();
      this._restoreTabbableFocus();
    },
    _createWrapper: function() {
      this.uiDialog = $("<div>").hide().attr({
        tabIndex: -1,
        role: "dialog",
        "aria-modal": this.options.modal ? "true" : null
      }).appendTo(this._appendTo());
      this._addClass(this.uiDialog, "ui-dialog", "ui-widget ui-widget-content ui-front");
      this._on(this.uiDialog, {
        keydown: function(event) {
          if (this.options.closeOnEscape && !event.isDefaultPrevented() && event.keyCode && event.keyCode === $.ui.keyCode.ESCAPE) {
            event.preventDefault();
            this.close(event);
            return;
          }
          if (event.keyCode !== $.ui.keyCode.TAB || event.isDefaultPrevented()) {
            return;
          }
          var tabbables = this.uiDialog.find(":tabbable"), first = tabbables.first(), last = tabbables.last();
          if ((event.target === last[0] || event.target === this.uiDialog[0]) && !event.shiftKey) {
            this._delay((function() {
              first.trigger("focus");
            }));
            event.preventDefault();
          } else if ((event.target === first[0] || event.target === this.uiDialog[0]) && event.shiftKey) {
            this._delay((function() {
              last.trigger("focus");
            }));
            event.preventDefault();
          }
        },
        mousedown: function(event) {
          if (this._moveToTop(event)) {
            this._focusTabbable();
          }
        }
      });
      if (!this.element.find("[aria-describedby]").length) {
        this.uiDialog.attr({
          "aria-describedby": this.element.uniqueId().attr("id")
        });
      }
    },
    _createTitlebar: function() {
      var uiDialogTitle;
      this.uiDialogTitlebar = $("<div>");
      this._addClass(this.uiDialogTitlebar, "ui-dialog-titlebar", "ui-widget-header ui-helper-clearfix");
      this._on(this.uiDialogTitlebar, {
        mousedown: function(event) {
          if (!$(event.target).closest(".ui-dialog-titlebar-close")) {
            this.uiDialog.trigger("focus");
          }
        }
      });
      this.uiDialogTitlebarClose = $("<button type='button'></button>").button({
        label: $("<a>").text(this.options.closeText).html(),
        icon: "ui-icon-closethick",
        showLabel: false
      }).appendTo(this.uiDialogTitlebar);
      this._addClass(this.uiDialogTitlebarClose, "ui-dialog-titlebar-close");
      this._on(this.uiDialogTitlebarClose, {
        click: function(event) {
          event.preventDefault();
          this.close(event);
        }
      });
      uiDialogTitle = $("<span>").uniqueId().prependTo(this.uiDialogTitlebar);
      this._addClass(uiDialogTitle, "ui-dialog-title");
      this._title(uiDialogTitle);
      this.uiDialogTitlebar.prependTo(this.uiDialog);
      this.uiDialog.attr({
        "aria-labelledby": uiDialogTitle.attr("id")
      });
    },
    _title: function(title) {
      if (this.options.title) {
        title.text(this.options.title);
      } else {
        title.html("&#160;");
      }
    },
    _createButtonPane: function() {
      this.uiDialogButtonPane = $("<div>");
      this._addClass(this.uiDialogButtonPane, "ui-dialog-buttonpane", "ui-widget-content ui-helper-clearfix");
      this.uiButtonSet = $("<div>").appendTo(this.uiDialogButtonPane);
      this._addClass(this.uiButtonSet, "ui-dialog-buttonset");
      this._createButtons();
    },
    _createButtons: function() {
      var that = this, buttons = this.options.buttons;
      this.uiDialogButtonPane.remove();
      this.uiButtonSet.empty();
      if ($.isEmptyObject(buttons) || Array.isArray(buttons) && !buttons.length) {
        this._removeClass(this.uiDialog, "ui-dialog-buttons");
        return;
      }
      $.each(buttons, (function(name, props) {
        var click, buttonOptions;
        props = typeof props === "function" ? {
          click: props,
          text: name
        } : props;
        props = $.extend({
          type: "button"
        }, props);
        click = props.click;
        buttonOptions = {
          icon: props.icon,
          iconPosition: props.iconPosition,
          showLabel: props.showLabel,
          icons: props.icons,
          text: props.text
        };
        delete props.click;
        delete props.icon;
        delete props.iconPosition;
        delete props.showLabel;
        delete props.icons;
        if (typeof props.text === "boolean") {
          delete props.text;
        }
        $("<button></button>", props).button(buttonOptions).appendTo(that.uiButtonSet).on("click", (function() {
          click.apply(that.element[0], arguments);
        }));
      }));
      this._addClass(this.uiDialog, "ui-dialog-buttons");
      this.uiDialogButtonPane.appendTo(this.uiDialog);
    },
    _makeDraggable: function() {
      var that = this, options = this.options;
      function filteredUi(ui) {
        return {
          position: ui.position,
          offset: ui.offset
        };
      }
      this.uiDialog.draggable({
        cancel: ".ui-dialog-content, .ui-dialog-titlebar-close",
        handle: ".ui-dialog-titlebar",
        containment: "document",
        start: function(event, ui) {
          that._addClass($(this), "ui-dialog-dragging");
          that._blockFrames();
          that._trigger("dragStart", event, filteredUi(ui));
        },
        drag: function(event, ui) {
          that._trigger("drag", event, filteredUi(ui));
        },
        stop: function(event, ui) {
          var left = ui.offset.left - that.document.scrollLeft(), top = ui.offset.top - that.document.scrollTop();
          options.position = {
            my: "left top",
            at: "left" + (left >= 0 ? "+" : "") + left + " " + "top" + (top >= 0 ? "+" : "") + top,
            of: that.window
          };
          that._removeClass($(this), "ui-dialog-dragging");
          that._unblockFrames();
          that._trigger("dragStop", event, filteredUi(ui));
        }
      });
    },
    _makeResizable: function() {
      var that = this, options = this.options, handles = options.resizable, position = this.uiDialog.css("position"), resizeHandles = typeof handles === "string" ? handles : "n,e,s,w,se,sw,ne,nw";
      function filteredUi(ui) {
        return {
          originalPosition: ui.originalPosition,
          originalSize: ui.originalSize,
          position: ui.position,
          size: ui.size
        };
      }
      this.uiDialog.resizable({
        cancel: ".ui-dialog-content",
        containment: "document",
        alsoResize: this.element,
        maxWidth: options.maxWidth,
        maxHeight: options.maxHeight,
        minWidth: options.minWidth,
        minHeight: this._minHeight(),
        handles: resizeHandles,
        start: function(event, ui) {
          that._addClass($(this), "ui-dialog-resizing");
          that._blockFrames();
          that._trigger("resizeStart", event, filteredUi(ui));
        },
        resize: function(event, ui) {
          that._trigger("resize", event, filteredUi(ui));
        },
        stop: function(event, ui) {
          var offset = that.uiDialog.offset(), left = offset.left - that.document.scrollLeft(), top = offset.top - that.document.scrollTop();
          options.height = that.uiDialog.height();
          options.width = that.uiDialog.width();
          options.position = {
            my: "left top",
            at: "left" + (left >= 0 ? "+" : "") + left + " " + "top" + (top >= 0 ? "+" : "") + top,
            of: that.window
          };
          that._removeClass($(this), "ui-dialog-resizing");
          that._unblockFrames();
          that._trigger("resizeStop", event, filteredUi(ui));
        }
      }).css("position", position);
    },
    _trackFocus: function() {
      this._on(this.widget(), {
        focusin: function(event) {
          this._makeFocusTarget();
          this._focusedElement = $(event.target);
        }
      });
    },
    _makeFocusTarget: function() {
      this._untrackInstance();
      this._trackingInstances().unshift(this);
    },
    _untrackInstance: function() {
      var instances = this._trackingInstances(), exists = $.inArray(this, instances);
      if (exists !== -1) {
        instances.splice(exists, 1);
      }
    },
    _trackingInstances: function() {
      var instances = this.document.data("ui-dialog-instances");
      if (!instances) {
        instances = [];
        this.document.data("ui-dialog-instances", instances);
      }
      return instances;
    },
    _minHeight: function() {
      var options = this.options;
      return options.height === "auto" ? options.minHeight : Math.min(options.minHeight, options.height);
    },
    _position: function() {
      var isVisible = this.uiDialog.is(":visible");
      if (!isVisible) {
        this.uiDialog.show();
      }
      this.uiDialog.position(this.options.position);
      if (!isVisible) {
        this.uiDialog.hide();
      }
    },
    _setOptions: function(options) {
      var that = this, resize = false, resizableOptions = {};
      $.each(options, (function(key, value) {
        that._setOption(key, value);
        if (key in that.sizeRelatedOptions) {
          resize = true;
        }
        if (key in that.resizableRelatedOptions) {
          resizableOptions[key] = value;
        }
      }));
      if (resize) {
        this._size();
        this._position();
      }
      if (this.uiDialog.is(":data(ui-resizable)")) {
        this.uiDialog.resizable("option", resizableOptions);
      }
    },
    _setOption: function(key, value) {
      var isDraggable, isResizable, uiDialog = this.uiDialog;
      if (key === "disabled") {
        return;
      }
      this._super(key, value);
      if (key === "appendTo") {
        this.uiDialog.appendTo(this._appendTo());
      }
      if (key === "buttons") {
        this._createButtons();
      }
      if (key === "closeText") {
        this.uiDialogTitlebarClose.button({
          label: $("<a>").text("" + this.options.closeText).html()
        });
      }
      if (key === "draggable") {
        isDraggable = uiDialog.is(":data(ui-draggable)");
        if (isDraggable && !value) {
          uiDialog.draggable("destroy");
        }
        if (!isDraggable && value) {
          this._makeDraggable();
        }
      }
      if (key === "position") {
        this._position();
      }
      if (key === "resizable") {
        isResizable = uiDialog.is(":data(ui-resizable)");
        if (isResizable && !value) {
          uiDialog.resizable("destroy");
        }
        if (isResizable && typeof value === "string") {
          uiDialog.resizable("option", "handles", value);
        }
        if (!isResizable && value !== false) {
          this._makeResizable();
        }
      }
      if (key === "title") {
        this._title(this.uiDialogTitlebar.find(".ui-dialog-title"));
      }
      if (key === "modal") {
        uiDialog.attr("aria-modal", value ? "true" : null);
      }
    },
    _size: function() {
      var nonContentHeight, minContentHeight, maxContentHeight, options = this.options;
      this.element.show().css({
        width: "auto",
        minHeight: 0,
        maxHeight: "none",
        height: 0
      });
      if (options.minWidth > options.width) {
        options.width = options.minWidth;
      }
      nonContentHeight = this.uiDialog.css({
        height: "auto",
        width: options.width
      }).outerHeight();
      minContentHeight = Math.max(0, options.minHeight - nonContentHeight);
      maxContentHeight = typeof options.maxHeight === "number" ? Math.max(0, options.maxHeight - nonContentHeight) : "none";
      if (options.height === "auto") {
        this.element.css({
          minHeight: minContentHeight,
          maxHeight: maxContentHeight,
          height: "auto"
        });
      } else {
        this.element.height(Math.max(0, options.height - nonContentHeight));
      }
      if (this.uiDialog.is(":data(ui-resizable)")) {
        this.uiDialog.resizable("option", "minHeight", this._minHeight());
      }
    },
    _blockFrames: function() {
      this.iframeBlocks = this.document.find("iframe").map((function() {
        var iframe = $(this);
        return $("<div>").css({
          position: "absolute",
          width: iframe.outerWidth(),
          height: iframe.outerHeight()
        }).appendTo(iframe.parent()).offset(iframe.offset())[0];
      }));
    },
    _unblockFrames: function() {
      if (this.iframeBlocks) {
        this.iframeBlocks.remove();
        delete this.iframeBlocks;
      }
    },
    _allowInteraction: function(event) {
      if ($(event.target).closest(".ui-dialog").length) {
        return true;
      }
      return !!$(event.target).closest(".ui-datepicker").length;
    },
    _createOverlay: function() {
      if (!this.options.modal) {
        return;
      }
      var isOpening = true;
      this._delay((function() {
        isOpening = false;
      }));
      if (!this.document.data("ui-dialog-overlays")) {
        this.document.on("focusin.ui-dialog", function(event) {
          if (isOpening) {
            return;
          }
          var instance = this._trackingInstances()[0];
          if (!instance._allowInteraction(event)) {
            event.preventDefault();
            instance._focusTabbable();
          }
        }.bind(this));
      }
      this.overlay = $("<div>").appendTo(this._appendTo());
      this._addClass(this.overlay, null, "ui-widget-overlay ui-front");
      this._on(this.overlay, {
        mousedown: "_keepFocus"
      });
      this.document.data("ui-dialog-overlays", (this.document.data("ui-dialog-overlays") || 0) + 1);
    },
    _destroyOverlay: function() {
      if (!this.options.modal) {
        return;
      }
      if (this.overlay) {
        var overlays = this.document.data("ui-dialog-overlays") - 1;
        if (!overlays) {
          this.document.off("focusin.ui-dialog");
          this.document.removeData("ui-dialog-overlays");
        } else {
          this.document.data("ui-dialog-overlays", overlays);
        }
        this.overlay.remove();
        this.overlay = null;
      }
    }
  });
  if ($.uiBackCompat === true) {
    $.widget("ui.dialog", $.ui.dialog, {
      options: {
        dialogClass: ""
      },
      _createWrapper: function() {
        this._super();
        this.uiDialog.addClass(this.options.dialogClass);
      },
      _setOption: function(key, value) {
        if (key === "dialogClass") {
          this.uiDialog.removeClass(this.options.dialogClass).addClass(value);
        }
        this._superApply(arguments);
      }
    });
  }
  $.ui.dialog;
  /*!
 * jQuery UI Tabs 1.14.0
 * https://jqueryui.com
 *
 * Copyright OpenJS Foundation and other contributors
 * Released under the MIT license.
 * https://jquery.org/license
 */  $.widget("ui.tabs", {
    version: "1.14.0",
    delay: 300,
    options: {
      active: null,
      classes: {
        "ui-tabs": "ui-corner-all",
        "ui-tabs-nav": "ui-corner-all",
        "ui-tabs-panel": "ui-corner-bottom",
        "ui-tabs-tab": "ui-corner-top"
      },
      collapsible: false,
      event: "click",
      heightStyle: "content",
      hide: null,
      show: null,
      activate: null,
      beforeActivate: null,
      beforeLoad: null,
      load: null
    },
    _isLocal: function() {
      var rhash = /#.*$/;
      return function(anchor) {
        var anchorUrl, locationUrl;
        anchorUrl = anchor.href.replace(rhash, "");
        locationUrl = location.href.replace(rhash, "");
        try {
          anchorUrl = decodeURIComponent(anchorUrl);
        } catch (error) {}
        try {
          locationUrl = decodeURIComponent(locationUrl);
        } catch (error) {}
        return anchor.hash.length > 1 && anchorUrl === locationUrl;
      };
    }(),
    _create: function() {
      var that = this, options = this.options;
      this.running = false;
      this._addClass("ui-tabs", "ui-widget ui-widget-content");
      this._toggleClass("ui-tabs-collapsible", null, options.collapsible);
      this._processTabs();
      options.active = this._initialActive();
      if (Array.isArray(options.disabled)) {
        options.disabled = $.uniqueSort(options.disabled.concat($.map(this.tabs.filter(".ui-state-disabled"), (function(li) {
          return that.tabs.index(li);
        })))).sort();
      }
      if (this.options.active !== false && this.anchors.length) {
        this.active = this._findActive(options.active);
      } else {
        this.active = $();
      }
      this._refresh();
      if (this.active.length) {
        this.load(options.active);
      }
    },
    _initialActive: function() {
      var active = this.options.active, collapsible = this.options.collapsible, locationHash = location.hash.substring(1);
      if (active === null) {
        if (locationHash) {
          this.tabs.each((function(i, tab) {
            if ($(tab).attr("aria-controls") === locationHash) {
              active = i;
              return false;
            }
          }));
        }
        if (active === null) {
          active = this.tabs.index(this.tabs.filter(".ui-tabs-active"));
        }
        if (active === null || active === -1) {
          active = this.tabs.length ? 0 : false;
        }
      }
      if (active !== false) {
        active = this.tabs.index(this.tabs.eq(active));
        if (active === -1) {
          active = collapsible ? false : 0;
        }
      }
      if (!collapsible && active === false && this.anchors.length) {
        active = 0;
      }
      return active;
    },
    _getCreateEventData: function() {
      return {
        tab: this.active,
        panel: !this.active.length ? $() : this._getPanelForTab(this.active)
      };
    },
    _tabKeydown: function(event) {
      var focusedTab = $(this.document[0].activeElement).closest("li"), selectedIndex = this.tabs.index(focusedTab), goingForward = true;
      if (this._handlePageNav(event)) {
        return;
      }
      switch (event.keyCode) {
       case $.ui.keyCode.RIGHT:
       case $.ui.keyCode.DOWN:
        selectedIndex++;
        break;

       case $.ui.keyCode.UP:
       case $.ui.keyCode.LEFT:
        goingForward = false;
        selectedIndex--;
        break;

       case $.ui.keyCode.END:
        selectedIndex = this.anchors.length - 1;
        break;

       case $.ui.keyCode.HOME:
        selectedIndex = 0;
        break;

       case $.ui.keyCode.SPACE:
        event.preventDefault();
        clearTimeout(this.activating);
        this._activate(selectedIndex);
        return;

       case $.ui.keyCode.ENTER:
        event.preventDefault();
        clearTimeout(this.activating);
        this._activate(selectedIndex === this.options.active ? false : selectedIndex);
        return;

       default:
        return;
      }
      event.preventDefault();
      clearTimeout(this.activating);
      selectedIndex = this._focusNextTab(selectedIndex, goingForward);
      if (!event.ctrlKey && !event.metaKey) {
        focusedTab.attr("aria-selected", "false");
        this.tabs.eq(selectedIndex).attr("aria-selected", "true");
        this.activating = this._delay((function() {
          this.option("active", selectedIndex);
        }), this.delay);
      }
    },
    _panelKeydown: function(event) {
      if (this._handlePageNav(event)) {
        return;
      }
      if (event.ctrlKey && event.keyCode === $.ui.keyCode.UP) {
        event.preventDefault();
        this.active.trigger("focus");
      }
    },
    _handlePageNav: function(event) {
      if (event.altKey && event.keyCode === $.ui.keyCode.PAGE_UP) {
        this._activate(this._focusNextTab(this.options.active - 1, false));
        return true;
      }
      if (event.altKey && event.keyCode === $.ui.keyCode.PAGE_DOWN) {
        this._activate(this._focusNextTab(this.options.active + 1, true));
        return true;
      }
    },
    _findNextTab: function(index, goingForward) {
      var lastTabIndex = this.tabs.length - 1;
      function constrain() {
        if (index > lastTabIndex) {
          index = 0;
        }
        if (index < 0) {
          index = lastTabIndex;
        }
        return index;
      }
      while ($.inArray(constrain(), this.options.disabled) !== -1) {
        index = goingForward ? index + 1 : index - 1;
      }
      return index;
    },
    _focusNextTab: function(index, goingForward) {
      index = this._findNextTab(index, goingForward);
      this.tabs.eq(index).trigger("focus");
      return index;
    },
    _setOption: function(key, value) {
      if (key === "active") {
        this._activate(value);
        return;
      }
      this._super(key, value);
      if (key === "collapsible") {
        this._toggleClass("ui-tabs-collapsible", null, value);
        if (!value && this.options.active === false) {
          this._activate(0);
        }
      }
      if (key === "event") {
        this._setupEvents(value);
      }
      if (key === "heightStyle") {
        this._setupHeightStyle(value);
      }
    },
    _sanitizeSelector: function(hash) {
      return hash ? hash.replace(/[!"$%&'()*+,.\/:;<=>?@\[\]\^`{|}~]/g, "\\$&") : "";
    },
    refresh: function() {
      var options = this.options, lis = this.tablist.children(":has(a[href])");
      options.disabled = $.map(lis.filter(".ui-state-disabled"), (function(tab) {
        return lis.index(tab);
      }));
      this._processTabs();
      if (options.active === false || !this.anchors.length) {
        options.active = false;
        this.active = $();
      } else if (this.active.length && !$.contains(this.tablist[0], this.active[0])) {
        if (this.tabs.length === options.disabled.length) {
          options.active = false;
          this.active = $();
        } else {
          this._activate(this._findNextTab(Math.max(0, options.active - 1), false));
        }
      } else {
        options.active = this.tabs.index(this.active);
      }
      this._refresh();
    },
    _refresh: function() {
      this._setOptionDisabled(this.options.disabled);
      this._setupEvents(this.options.event);
      this._setupHeightStyle(this.options.heightStyle);
      this.tabs.not(this.active).attr({
        "aria-selected": "false",
        "aria-expanded": "false",
        tabIndex: -1
      });
      this.panels.not(this._getPanelForTab(this.active)).hide().attr({
        "aria-hidden": "true"
      });
      if (!this.active.length) {
        this.tabs.eq(0).attr("tabIndex", 0);
      } else {
        this.active.attr({
          "aria-selected": "true",
          "aria-expanded": "true",
          tabIndex: 0
        });
        this._addClass(this.active, "ui-tabs-active", "ui-state-active");
        this._getPanelForTab(this.active).show().attr({
          "aria-hidden": "false"
        });
      }
    },
    _processTabs: function() {
      var that = this, prevTabs = this.tabs, prevAnchors = this.anchors, prevPanels = this.panels;
      this.tablist = this._getList().attr("role", "tablist");
      this._addClass(this.tablist, "ui-tabs-nav", "ui-helper-reset ui-helper-clearfix ui-widget-header");
      this.tablist.on("mousedown" + this.eventNamespace, "> li", (function(event) {
        if ($(this).is(".ui-state-disabled")) {
          event.preventDefault();
        }
      }));
      this.tabs = this.tablist.find("> li:has(a[href])").attr({
        role: "tab",
        tabIndex: -1
      });
      this._addClass(this.tabs, "ui-tabs-tab", "ui-state-default");
      this.anchors = this.tabs.map((function() {
        return $("a", this)[0];
      })).attr({
        tabIndex: -1
      });
      this._addClass(this.anchors, "ui-tabs-anchor");
      this.panels = $();
      this.anchors.each((function(i, anchor) {
        var selector, panel, panelId, anchorId = $(anchor).uniqueId().attr("id"), tab = $(anchor).closest("li"), originalAriaControls = tab.attr("aria-controls");
        if (that._isLocal(anchor)) {
          selector = anchor.hash;
          panelId = selector.substring(1);
          panel = that.element.find(that._sanitizeSelector(selector));
        } else {
          panelId = tab.attr("aria-controls") || $({}).uniqueId()[0].id;
          selector = "#" + panelId;
          panel = that.element.find(selector);
          if (!panel.length) {
            panel = that._createPanel(panelId);
            panel.insertAfter(that.panels[i - 1] || that.tablist);
          }
          panel.attr("aria-live", "polite");
        }
        if (panel.length) {
          that.panels = that.panels.add(panel);
        }
        if (originalAriaControls) {
          tab.data("ui-tabs-aria-controls", originalAriaControls);
        }
        tab.attr({
          "aria-controls": panelId,
          "aria-labelledby": anchorId
        });
        panel.attr("aria-labelledby", anchorId);
      }));
      this.panels.attr("role", "tabpanel");
      this._addClass(this.panels, "ui-tabs-panel", "ui-widget-content");
      if (prevTabs) {
        this._off(prevTabs.not(this.tabs));
        this._off(prevAnchors.not(this.anchors));
        this._off(prevPanels.not(this.panels));
      }
    },
    _getList: function() {
      return this.tablist || this.element.find("ol, ul").eq(0);
    },
    _createPanel: function(id) {
      return $("<div>").attr("id", id).data("ui-tabs-destroy", true);
    },
    _setOptionDisabled: function(disabled) {
      var currentItem, li, i;
      if (Array.isArray(disabled)) {
        if (!disabled.length) {
          disabled = false;
        } else if (disabled.length === this.anchors.length) {
          disabled = true;
        }
      }
      for (i = 0; li = this.tabs[i]; i++) {
        currentItem = $(li);
        if (disabled === true || $.inArray(i, disabled) !== -1) {
          currentItem.attr("aria-disabled", "true");
          this._addClass(currentItem, null, "ui-state-disabled");
        } else {
          currentItem.removeAttr("aria-disabled");
          this._removeClass(currentItem, null, "ui-state-disabled");
        }
      }
      this.options.disabled = disabled;
      this._toggleClass(this.widget(), this.widgetFullName + "-disabled", null, disabled === true);
    },
    _setupEvents: function(event) {
      var events = {};
      if (event) {
        $.each(event.split(" "), (function(index, eventName) {
          events[eventName] = "_eventHandler";
        }));
      }
      this._off(this.anchors.add(this.tabs).add(this.panels));
      this._on(true, this.anchors, {
        click: function(event) {
          event.preventDefault();
        }
      });
      this._on(this.anchors, events);
      this._on(this.tabs, {
        keydown: "_tabKeydown"
      });
      this._on(this.panels, {
        keydown: "_panelKeydown"
      });
      this._focusable(this.tabs);
      this._hoverable(this.tabs);
    },
    _setupHeightStyle: function(heightStyle) {
      var maxHeight, parent = this.element.parent();
      if (heightStyle === "fill") {
        maxHeight = parent.height();
        maxHeight -= this.element.outerHeight() - this.element.height();
        this.element.siblings(":visible").each((function() {
          var elem = $(this), position = elem.css("position");
          if (position === "absolute" || position === "fixed") {
            return;
          }
          maxHeight -= elem.outerHeight(true);
        }));
        this.element.children().not(this.panels).each((function() {
          maxHeight -= $(this).outerHeight(true);
        }));
        this.panels.each((function() {
          $(this).height(Math.max(0, maxHeight - $(this).innerHeight() + $(this).height()));
        })).css("overflow", "auto");
      } else if (heightStyle === "auto") {
        maxHeight = 0;
        this.panels.each((function() {
          maxHeight = Math.max(maxHeight, $(this).height("").height());
        })).height(maxHeight);
      }
    },
    _eventHandler: function(event) {
      var options = this.options, active = this.active, anchor = $(event.currentTarget), tab = anchor.closest("li"), clickedIsActive = tab[0] === active[0], collapsing = clickedIsActive && options.collapsible, toShow = collapsing ? $() : this._getPanelForTab(tab), toHide = !active.length ? $() : this._getPanelForTab(active), eventData = {
        oldTab: active,
        oldPanel: toHide,
        newTab: collapsing ? $() : tab,
        newPanel: toShow
      };
      event.preventDefault();
      if (tab.hasClass("ui-state-disabled") || tab.hasClass("ui-tabs-loading") || this.running || clickedIsActive && !options.collapsible || this._trigger("beforeActivate", event, eventData) === false) {
        return;
      }
      options.active = collapsing ? false : this.tabs.index(tab);
      this.active = clickedIsActive ? $() : tab;
      if (this.xhr) {
        this.xhr.abort();
      }
      if (!toHide.length && !toShow.length) {
        $.error("jQuery UI Tabs: Mismatching fragment identifier.");
      }
      if (toShow.length) {
        this.load(this.tabs.index(tab), event);
      }
      this._toggle(event, eventData);
    },
    _toggle: function(event, eventData) {
      var that = this, toShow = eventData.newPanel, toHide = eventData.oldPanel;
      this.running = true;
      function complete() {
        that.running = false;
        that._trigger("activate", event, eventData);
      }
      function show() {
        that._addClass(eventData.newTab.closest("li"), "ui-tabs-active", "ui-state-active");
        if (toShow.length && that.options.show) {
          that._show(toShow, that.options.show, complete);
        } else {
          toShow.show();
          complete();
        }
      }
      if (toHide.length && this.options.hide) {
        this._hide(toHide, this.options.hide, (function() {
          that._removeClass(eventData.oldTab.closest("li"), "ui-tabs-active", "ui-state-active");
          show();
        }));
      } else {
        this._removeClass(eventData.oldTab.closest("li"), "ui-tabs-active", "ui-state-active");
        toHide.hide();
        show();
      }
      toHide.attr("aria-hidden", "true");
      eventData.oldTab.attr({
        "aria-selected": "false",
        "aria-expanded": "false"
      });
      if (toShow.length && toHide.length) {
        eventData.oldTab.attr("tabIndex", -1);
      } else if (toShow.length) {
        this.tabs.filter((function() {
          return $(this).attr("tabIndex") === 0;
        })).attr("tabIndex", -1);
      }
      toShow.attr("aria-hidden", "false");
      eventData.newTab.attr({
        "aria-selected": "true",
        "aria-expanded": "true",
        tabIndex: 0
      });
    },
    _activate: function(index) {
      var anchor, active = this._findActive(index);
      if (active[0] === this.active[0]) {
        return;
      }
      if (!active.length) {
        active = this.active;
      }
      anchor = active.find(".ui-tabs-anchor")[0];
      this._eventHandler({
        target: anchor,
        currentTarget: anchor,
        preventDefault: $.noop
      });
    },
    _findActive: function(index) {
      return index === false ? $() : this.tabs.eq(index);
    },
    _getIndex: function(index) {
      if (typeof index === "string") {
        index = this.anchors.index(this.anchors.filter("[href$='" + CSS.escape(index) + "']"));
      }
      return index;
    },
    _destroy: function() {
      if (this.xhr) {
        this.xhr.abort();
      }
      this.tablist.removeAttr("role").off(this.eventNamespace);
      this.anchors.removeAttr("role tabIndex").removeUniqueId();
      this.tabs.add(this.panels).each((function() {
        if ($.data(this, "ui-tabs-destroy")) {
          $(this).remove();
        } else {
          $(this).removeAttr("role tabIndex " + "aria-live aria-busy aria-selected aria-labelledby aria-hidden aria-expanded");
        }
      }));
      this.tabs.each((function() {
        var li = $(this), prev = li.data("ui-tabs-aria-controls");
        if (prev) {
          li.attr("aria-controls", prev).removeData("ui-tabs-aria-controls");
        } else {
          li.removeAttr("aria-controls");
        }
      }));
      this.panels.show();
      if (this.options.heightStyle !== "content") {
        this.panels.css("height", "");
      }
    },
    enable: function(index) {
      var disabled = this.options.disabled;
      if (disabled === false) {
        return;
      }
      if (index === undefined) {
        disabled = false;
      } else {
        index = this._getIndex(index);
        if (Array.isArray(disabled)) {
          disabled = $.map(disabled, (function(num) {
            return num !== index ? num : null;
          }));
        } else {
          disabled = $.map(this.tabs, (function(li, num) {
            return num !== index ? num : null;
          }));
        }
      }
      this._setOptionDisabled(disabled);
    },
    disable: function(index) {
      var disabled = this.options.disabled;
      if (disabled === true) {
        return;
      }
      if (index === undefined) {
        disabled = true;
      } else {
        index = this._getIndex(index);
        if ($.inArray(index, disabled) !== -1) {
          return;
        }
        if (Array.isArray(disabled)) {
          disabled = $.merge([ index ], disabled).sort();
        } else {
          disabled = [ index ];
        }
      }
      this._setOptionDisabled(disabled);
    },
    load: function(index, event) {
      index = this._getIndex(index);
      var that = this, tab = this.tabs.eq(index), anchor = tab.find(".ui-tabs-anchor"), panel = this._getPanelForTab(tab), eventData = {
        tab: tab,
        panel: panel
      }, complete = function(jqXHR, status) {
        if (status === "abort") {
          that.panels.stop(false, true);
        }
        that._removeClass(tab, "ui-tabs-loading");
        panel.removeAttr("aria-busy");
        if (jqXHR === that.xhr) {
          delete that.xhr;
        }
      };
      if (this._isLocal(anchor[0])) {
        return;
      }
      this.xhr = $.ajax(this._ajaxSettings(anchor, event, eventData));
      if (this.xhr.statusText !== "canceled") {
        this._addClass(tab, "ui-tabs-loading");
        panel.attr("aria-busy", "true");
        this.xhr.done((function(response, status, jqXHR) {
          panel.html(response);
          that._trigger("load", event, eventData);
          complete(jqXHR, status);
        })).fail((function(jqXHR, status) {
          complete(jqXHR, status);
        }));
      }
    },
    _ajaxSettings: function(anchor, event, eventData) {
      var that = this;
      return {
        url: anchor.attr("href"),
        beforeSend: function(jqXHR, settings) {
          return that._trigger("beforeLoad", event, $.extend({
            jqXHR: jqXHR,
            ajaxSettings: settings
          }, eventData));
        }
      };
    },
    _getPanelForTab: function(tab) {
      var id = $(tab).attr("aria-controls");
      return this.element.find(this._sanitizeSelector("#" + id));
    }
  });
  if ($.uiBackCompat === true) {
    $.widget("ui.tabs", $.ui.tabs, {
      _processTabs: function() {
        this._superApply(arguments);
        this._addClass(this.tabs, "ui-tab");
      }
    });
  }
  $.ui.tabs;
}));

$.ui.dialog.prototype._focusTabbable = function() {
  this.uiDialog.focus();
};

function ModalDialog(message, inputs, callback) {
  let html = `<form id="dialog_confirm" title="${message}"><ul>`;
  for (let name in inputs) {
    var opts, wrapper;
    let type = inputs[name];
    if (/^(datepicker|checkbox|text|number)$/.test(type)) {
      wrapper = "input";
    } else if (type === "textarea") {
      wrapper = "textarea";
    } else if ($.isArray(type)) {
      [wrapper, opts, type] = [ "select", type, "" ];
    } else {
      throw new Error(`Unsupported input type: {${name}: ${type}}`);
    }
    let klass = type === "datepicker" ? type : "";
    html += `<li>\n      <label>${name.charAt(0).toUpperCase() + name.slice(1)}</label>\n      <${wrapper} name="${name}" class="${klass}" type="${type}">` + (opts ? (() => {
      const result = [];
      opts.forEach((v => {
        const $elem = $("<option></option>");
        if ($.isArray(v)) {
          $elem.text(v[0]).val(v[1]);
        } else {
          $elem.text(v);
        }
        result.push($elem.wrap("<div></div>").parent().html());
      }));
      return result;
    })().join("") : "") + `</${wrapper}>` + "</li>";
    [wrapper, opts, type, klass] = [];
  }
  html += "</ul></form>";
  const form = $(html).appendTo("body");
  $("body").trigger("modal_dialog:before_open", [ form ]);
  form.dialog({
    modal: true,
    open(_event, _ui) {
      $("body").trigger("modal_dialog:after_open", [ form ]);
    },
    dialogClass: "active_admin_dialog",
    buttons: {
      OK() {
        callback($(this).serializeObject());
        $(this).dialog("close");
      },
      Cancel() {
        $(this).dialog("close").remove();
      }
    }
  });
}

const onDOMReady$2 = function() {
  $(".batch_actions_selector li a").off("click confirm:complete");
  $(".batch_actions_selector li a").on("click", (function(event) {
    let message;
    event.stopPropagation();
    event.preventDefault();
    if (message = $(this).data("confirm")) {
      ModalDialog(message, $(this).data("inputs"), (inputs => {
        $(this).trigger("confirm:complete", inputs);
      }));
    } else {
      $(this).trigger("confirm:complete");
    }
  }));
  $(".batch_actions_selector li a").on("confirm:complete", (function(event, inputs) {
    let val;
    if (val = JSON.stringify(inputs)) {
      $("#batch_action_inputs").removeAttr("disabled").val(val);
    } else {
      $("#batch_action_inputs").attr("disabled", "disabled");
    }
    $("#batch_action").val($(this).data("action"));
    $("#collection_selection").submit();
  }));
  if ($(".batch_actions_selector").length && $(":checkbox.toggle_all").length) {
    if ($(".paginated_collection table.index_table").length) {
      $(".paginated_collection table.index_table").tableCheckboxToggler();
    } else {
      $(".paginated_collection").checkboxToggler();
    }
    $(document).on("change", ".paginated_collection :checkbox", (function() {
      if ($(".paginated_collection :checkbox:checked").length && $(".dropdown_menu_list").children().length) {
        $(".batch_actions_selector").each((function() {
          $(this).aaDropdownMenu("enable");
        }));
      } else {
        $(".batch_actions_selector").each((function() {
          $(this).aaDropdownMenu("disable");
        }));
      }
    }));
  }
};

$(document).ready(onDOMReady$2).on("page:load turbolinks:load", onDOMReady$2);

class CheckboxToggler {
  constructor(options, container) {
    this.options = options;
    this.container = container;
    this._init();
    this._bind();
  }
  option(_key, _value) {}
  _init() {
    if (!this.container) {
      throw new Error("Container element not found");
    } else {
      this.$container = $(this.container);
    }
    if (!this.$container.find(".toggle_all").length) {
      throw new Error('"toggle all" checkbox not found');
    } else {
      this.toggle_all_checkbox = this.$container.find(".toggle_all");
    }
    this.checkboxes = this.$container.find(":checkbox").not(this.toggle_all_checkbox);
  }
  _bind() {
    this.checkboxes.change((event => this._didChangeCheckbox(event.target)));
    this.toggle_all_checkbox.change((() => this._didChangeToggleAllCheckbox()));
  }
  _didChangeCheckbox(_checkbox) {
    const numChecked = this.checkboxes.filter(":checked").length;
    const allChecked = numChecked === this.checkboxes.length;
    const someChecked = numChecked > 0 && numChecked < this.checkboxes.length;
    this.toggle_all_checkbox.prop({
      checked: allChecked,
      indeterminate: someChecked
    });
  }
  _didChangeToggleAllCheckbox() {
    const setting = this.toggle_all_checkbox.prop("checked");
    this.checkboxes.prop({
      checked: setting
    });
    return setting;
  }
}

$.widget.bridge("checkboxToggler", CheckboxToggler);

($ => {
  $(document).on("focus", "input.datepicker:not(.hasDatepicker)", (function() {
    const input = $(this);
    if (input[0].type === "date") {
      return;
    }
    const defaults = {
      dateFormat: "yy-mm-dd"
    };
    const options = input.data("datepicker-options");
    input.datepicker($.extend(defaults, options));
  }));
})($);

class DropdownMenu {
  constructor(options, element) {
    this.options = options;
    this.element = element;
    this.$element = $(this.element);
    const defaults = {
      fadeInDuration: 20,
      fadeOutDuration: 100,
      onClickActionItemCallback: null
    };
    this.options = $.extend(defaults, this.options);
    this.isOpen = false;
    this.$menuButton = this.$element.find(".dropdown_menu_button");
    this.$menuList = this.$element.find(".dropdown_menu_list_wrapper");
    this._buildMenuList();
    this._bind();
  }
  open() {
    this.isOpen = true;
    this.$menuList.fadeIn(this.options.fadeInDuration);
    this._position();
    return this;
  }
  close() {
    this.isOpen = false;
    this.$menuList.fadeOut(this.options.fadeOutDuration);
    return this;
  }
  destroy() {
    this.$element = null;
    return this;
  }
  isDisabled() {
    return this.$menuButton.hasClass("disabled");
  }
  disable() {
    this.$menuButton.addClass("disabled");
  }
  enable() {
    this.$menuButton.removeClass("disabled");
  }
  option(key, value) {
    if ($.isPlainObject(key)) {
      return this.options = $.extend(true, this.options, key);
    } else if (key != null) {
      return this.options[key];
    } else {
      return this.options[key] = value;
    }
  }
  _buildMenuList() {
    this.$nipple = $('<div class="dropdown_menu_nipple"></div>');
    this.$menuList.prepend(this.$nipple);
    this.$menuList.hide();
  }
  _bind() {
    $("body").click((() => {
      if (this.isOpen) {
        this.close();
      }
    }));
    this.$menuButton.click((() => {
      if (!this.isDisabled()) {
        if (this.isOpen) {
          this.close();
        } else {
          this.open();
        }
      }
      return false;
    }));
  }
  _position() {
    this.$menuList.css("top", this.$menuButton.position().top + this.$menuButton.outerHeight() + 10);
    const button_left = this.$menuButton.position().left;
    const button_center = this.$menuButton.outerWidth() / 2;
    const button_right = button_left + button_center * 2;
    const menu_center = this.$menuList.outerWidth() / 2;
    const nipple_center = this.$nipple.outerWidth() / 2;
    const window_right = $(window).width();
    const centered_menu_left = button_left + button_center - menu_center;
    const centered_menu_right = button_left + button_center + menu_center;
    if (centered_menu_left < 0) {
      this.$menuList.css("left", button_left);
      this.$nipple.css("left", button_center - nipple_center);
    } else if (centered_menu_right > window_right) {
      this.$menuList.css("right", window_right - button_right);
      this.$nipple.css("right", button_center - nipple_center);
    } else {
      this.$menuList.css("left", centered_menu_left);
      this.$nipple.css("left", menu_center - nipple_center);
    }
  }
}

$.widget.bridge("aaDropdownMenu", DropdownMenu);

const onDOMReady$1 = () => $(".dropdown_menu").aaDropdownMenu();

$(document).ready(onDOMReady$1).on("page:load turbolinks:load", onDOMReady$1);

function hasTurbolinks() {
  return typeof Turbolinks !== "undefined" && Turbolinks.supported;
}

function turbolinksVisit(params) {
  const path = [ window.location.pathname, "?", toQueryString(params) ].join("");
  Turbolinks.visit(path);
}

function queryString() {
  return (window.location.search || "").replace(/^\?/, "");
}

function queryStringToParams() {
  const decode = value => decodeURIComponent((value || "").replace(/\+/g, "%20"));
  return queryString().split("&").map((pair => pair.split("="))).map((([key, value]) => ({
    name: decode(key),
    value: decode(value)
  })));
}

function toQueryString(params) {
  const encode = value => encodeURIComponent(value || "");
  return params.map((({name: name, value: value}) => [ encode(name), encode(value) ])).map((pair => pair.join("="))).join("&");
}

class Filters {
  static _clearForm(event) {
    const regex = /^(q\[|q%5B|q%5b|page|utf8|commit)/;
    const params = queryStringToParams().filter((({name: name}) => !name.match(regex)));
    event.preventDefault();
    if (hasTurbolinks()) {
      turbolinksVisit(params);
    } else {
      window.location.search = toQueryString(params);
    }
  }
  static _disableEmptyInputFields(event) {
    const params = $(this).find(":input").filter(((i, input) => input.value === "")).prop({
      disabled: true
    }).end().serializeArray();
    if (hasTurbolinks()) {
      event.preventDefault();
      turbolinksVisit(params);
    }
  }
  static _setSearchType() {
    $(this).siblings("input").prop({
      name: `q[${this.value}]`
    });
  }
}

($ => {
  $(document).on("click", ".clear_filters_btn", Filters._clearForm).on("submit", ".filter_form", Filters._disableEmptyInputFields).on("change", ".filter_form_field.select_and_search select", Filters._setSearchType);
})($);

$((function() {
  $(document).on("click", "a.button.has_many_remove", (function(event) {
    event.preventDefault();
    const parent = $(this).closest(".has_many_container");
    const to_remove = $(this).closest("fieldset");
    recompute_positions(parent);
    parent.trigger("has_many_remove:before", [ to_remove, parent ]);
    to_remove.remove();
    return parent.trigger("has_many_remove:after", [ to_remove, parent ]);
  }));
  $(document).on("click", "a.button.has_many_add", (function(event) {
    let before_add;
    event.preventDefault();
    const parent = $(this).closest(".has_many_container");
    parent.trigger(before_add = $.Event("has_many_add:before"), [ parent ]);
    if (!before_add.isDefaultPrevented()) {
      let index = parent.data("has_many_index") || parent.children("fieldset").length - 1;
      parent.data({
        has_many_index: ++index
      });
      const regex = new RegExp($(this).data("placeholder"), "g");
      const html = $(this).data("html").replace(regex, index);
      const fieldset = $(html).insertBefore(this);
      recompute_positions(parent);
      return parent.trigger("has_many_add:after", [ fieldset, parent ]);
    }
  }));
  $(document).on("change", '.has_many_container[data-sortable] :input[name$="[_destroy]"]', (function() {
    recompute_positions($(this).closest(".has_many"));
  }));
  $(document).on("has_many_add:after", ".has_many_container", init_sortable);
}));

var init_sortable = function() {
  const elems = $(".has_many_container[data-sortable]:not(.ui-sortable)");
  elems.sortable({
    items: "> fieldset",
    handle: "> ol > .handle",
    start: (ev, ui) => {
      ui.item.css({
        opacity: .3
      });
    },
    stop: function(ev, ui) {
      ui.item.css({
        opacity: 1
      });
      recompute_positions($(this));
    }
  });
  elems.each(recompute_positions);
};

var recompute_positions = function(parent) {
  parent = parent instanceof $ ? parent : $(this);
  const input_name = parent.data("sortable");
  let position = parseInt(parent.data("sortable-start") || 0, 10);
  parent.children("fieldset").each((function() {
    const destroy_input = $(this).find("> ol > .input > :input[name$='[_destroy]']");
    const sortable_input = $(this).find(`> ol > .input > :input[name$='[${input_name}]']`);
    if (sortable_input.length) {
      sortable_input.val(destroy_input.is(":checked") ? "" : position++);
    }
  }));
};

$(document).ready(init_sortable).on("page:load turbolinks:load", init_sortable);

class PerPage {
  constructor(element) {
    this.element = element;
  }
  update() {
    const params = queryStringToParams().filter((({name: name}) => name != "per_page" || name != "page"));
    params.push({
      name: "per_page",
      value: this.element.value
    });
    if (hasTurbolinks()) {
      turbolinksVisit(params);
    } else {
      window.location.search = toQueryString(params);
    }
  }
  static _jQueryInterface(config) {
    return this.each((function() {
      const $this = $(this);
      let data = $this.data("perPage");
      if (!data) {
        data = new PerPage(this);
        $this.data("perPage", data);
      }
      if (config === "update") {
        data[config]();
      }
    }));
  }
}

($ => {
  $(document).on("change", ".pagination_per_page > select", (function(_event) {
    PerPage._jQueryInterface.call($(this), "update");
  }));
  $.fn["perPage"] = PerPage._jQueryInterface;
  $.fn["perPage"].Constructor = PerPage;
})($);

class TableCheckboxToggler extends CheckboxToggler {
  _bind() {
    super._bind(...arguments);
    this.$container.find("tbody td").click((event => {
      if (event.target.type !== "checkbox") {
        this._didClickCell(event.target);
      }
    }));
  }
  _didChangeCheckbox(checkbox) {
    super._didChangeCheckbox(...arguments);
    $(checkbox).parents("tr").toggleClass("selected", checkbox.checked);
  }
  _didChangeToggleAllCheckbox() {
    this.$container.find("tbody tr").toggleClass("selected", super._didChangeToggleAllCheckbox(...arguments));
  }
  _didClickCell(cell) {
    $(cell).parent("tr").find(":checkbox").click();
  }
}

$.widget.bridge("tableCheckboxToggler", TableCheckboxToggler);

let onDOMReady = () => $("#active_admin_content .tabs").tabs();

$(document).ready(onDOMReady).on("page:load turbolinks:load", onDOMReady);

Rails.start();

function modal_dialog(message, inputs, callback) {
  console.warn("ActiveAdmin.modal_dialog is deprecated in favor of ActiveAdmin.ModalDialog, please update usage.");
  return ModalDialog(message, inputs, callback);
}

export { ModalDialog, modal_dialog };
