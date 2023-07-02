var stats = (() => {
  var __create = Object.create;
  var __defProp = Object.defineProperty;
  var __defProps = Object.defineProperties;
  var __getOwnPropDesc = Object.getOwnPropertyDescriptor;
  var __getOwnPropDescs = Object.getOwnPropertyDescriptors;
  var __getOwnPropNames = Object.getOwnPropertyNames;
  var __getOwnPropSymbols = Object.getOwnPropertySymbols;
  var __getProtoOf = Object.getPrototypeOf;
  var __hasOwnProp = Object.prototype.hasOwnProperty;
  var __propIsEnum = Object.prototype.propertyIsEnumerable;
  var __defNormalProp = (obj, key, value) => key in obj ? __defProp(obj, key, { enumerable: true, configurable: true, writable: true, value }) : obj[key] = value;
  var __spreadValues = (a, b) => {
    for (var prop in b || (b = {}))
      if (__hasOwnProp.call(b, prop))
        __defNormalProp(a, prop, b[prop]);
    if (__getOwnPropSymbols)
      for (var prop of __getOwnPropSymbols(b)) {
        if (__propIsEnum.call(b, prop))
          __defNormalProp(a, prop, b[prop]);
      }
    return a;
  };
  var __spreadProps = (a, b) => __defProps(a, __getOwnPropDescs(b));
  var __objRest = (source, exclude) => {
    var target = {};
    for (var prop in source)
      if (__hasOwnProp.call(source, prop) && exclude.indexOf(prop) < 0)
        target[prop] = source[prop];
    if (source != null && __getOwnPropSymbols)
      for (var prop of __getOwnPropSymbols(source)) {
        if (exclude.indexOf(prop) < 0 && __propIsEnum.call(source, prop))
          target[prop] = source[prop];
      }
    return target;
  };
  var __commonJS = (cb, mod) => function __require() {
    return mod || (0, cb[__getOwnPropNames(cb)[0]])((mod = { exports: {} }).exports, mod), mod.exports;
  };
  var __export = (target, all) => {
    for (var name in all)
      __defProp(target, name, { get: all[name], enumerable: true });
  };
  var __copyProps = (to, from, except, desc) => {
    if (from && typeof from === "object" || typeof from === "function") {
      for (let key of __getOwnPropNames(from))
        if (!__hasOwnProp.call(to, key) && key !== except)
          __defProp(to, key, { get: () => from[key], enumerable: !(desc = __getOwnPropDesc(from, key)) || desc.enumerable });
    }
    return to;
  };
  var __toESM = (mod, isNodeMode, target) => (target = mod != null ? __create(__getProtoOf(mod)) : {}, __copyProps(
    isNodeMode || !mod || !mod.__esModule ? __defProp(target, "default", { value: mod, enumerable: true }) : target,
    mod
  ));
  var __toCommonJS = (mod) => __copyProps(__defProp({}, "__esModule", { value: true }), mod);

  // external-global-plugin:react
  var require_react = __commonJS({
    "external-global-plugin:react"(exports, module) {
      module.exports = Spicetify.React;
    }
  });

  // external-global-plugin:react-dom
  var require_react_dom = __commonJS({
    "external-global-plugin:react-dom"(exports, module) {
      module.exports = Spicetify.ReactDOM;
    }
  });

  // node_modules/spicetify-creator/dist/temp/index.jsx
  var temp_exports = {};
  __export(temp_exports, {
    default: () => render
  });

  // src/app.tsx
  var import_react13 = __toESM(require_react());

  // node_modules/spcr-navigation-bar/useNavigationBar.tsx
  var import_react3 = __toESM(require_react());

  // node_modules/spcr-navigation-bar/navBar.tsx
  var import_react2 = __toESM(require_react());
  var import_react_dom = __toESM(require_react_dom());

  // node_modules/spcr-navigation-bar/optionsMenu.tsx
  var import_react = __toESM(require_react());
  var OptionsMenuItemIcon = /* @__PURE__ */ import_react.default.createElement("svg", {
    width: 16,
    height: 16,
    viewBox: "0 0 16 16",
    fill: "currentColor"
  }, /* @__PURE__ */ import_react.default.createElement("path", {
    d: "M13.985 2.383L5.127 12.754 1.388 8.375l-.658.77 4.397 5.149 9.618-11.262z"
  }));
  var OptionsMenuItem = import_react.default.memo((props) => {
    return /* @__PURE__ */ import_react.default.createElement(Spicetify.ReactComponent.MenuItem, {
      onClick: props.onSelect,
      icon: props.isSelected ? OptionsMenuItemIcon : null
    }, props.value);
  });
  var OptionsMenu = import_react.default.memo((props) => {
    const menuRef = import_react.default.useRef(null);
    const menu = /* @__PURE__ */ import_react.default.createElement(Spicetify.ReactComponent.Menu, null, props.options.map(
      (option) => /* @__PURE__ */ import_react.default.createElement(OptionsMenuItem, {
        value: option.link,
        isSelected: option.isActive,
        onSelect: () => {
          props.onSelect(option.link);
          menuRef.current?.click();
        }
      })
    ));
    return /* @__PURE__ */ import_react.default.createElement(Spicetify.ReactComponent.ContextMenu, {
      menu,
      trigger: "click",
      action: "toggle",
      renderInLine: true
    }, /* @__PURE__ */ import_react.default.createElement("button", {
      className: navBar_module_default.optionsMenuDropBox,
      ref: menuRef
    }, /* @__PURE__ */ import_react.default.createElement("span", {
      className: props.bold ? "main-type-mestoBold" : "main-type-mesto"
    }, props.options.find((o) => o.isActive)?.link || props.defaultValue), /* @__PURE__ */ import_react.default.createElement("svg", {
      width: 16,
      height: 16,
      viewBox: "0 0 16 16",
      fill: "currentColor"
    }, /* @__PURE__ */ import_react.default.createElement("path", {
      d: "M3 6l5 5.794L13 6z"
    }))));
  });
  var optionsMenu_default = OptionsMenu;

  // postcss-module:C:\Users\user\AppData\Local\Temp\tmp-11352-xL26BU56BtHl\187dc1300a41\navBar.module.css
  var navBar_module_default = { "topBarHeaderItem": "navBar-module__topBarHeaderItem___v29bR_stats", "topBarHeaderItemLink": "navBar-module__topBarHeaderItemLink___VeyBY_stats", "topBarActive": "navBar-module__topBarActive___-qYPu_stats", "topBarNav": "navBar-module__topBarNav___1OtdR_stats", "optionsMenuDropBox": "navBar-module__optionsMenuDropBox___tD9mA_stats" };

  // node_modules/spcr-navigation-bar/navBar.tsx
  var NavbarItem2 = class {
    constructor(link, isActive) {
      this.link = link;
      this.isActive = isActive;
    }
  };
  var NavbarItemComponent = (props) => {
    return /* @__PURE__ */ import_react2.default.createElement("li", {
      className: navBar_module_default.topBarHeaderItem,
      onClick: (e) => {
        e.preventDefault();
        props.switchTo(props.item.link);
      }
    }, /* @__PURE__ */ import_react2.default.createElement("a", {
      className: `${navBar_module_default.topBarHeaderItemLink} queue-tabBar-headerItemLink ${props.item.isActive ? `${navBar_module_default.topBarActive} queue-tabBar-active` : ""}`,
      "aria-current": "page",
      draggable: false,
      href: ""
    }, /* @__PURE__ */ import_react2.default.createElement("span", {
      className: "main-type-mestoBold"
    }, props.item.link)));
  };
  var NavbarMore = import_react2.default.memo(({ items, switchTo }) => {
    return /* @__PURE__ */ import_react2.default.createElement("li", {
      className: `${navBar_module_default.topBarHeaderItem} ${items.find((item) => item.isActive) ? navBar_module_default.topBarActive : ""}`
    }, /* @__PURE__ */ import_react2.default.createElement(optionsMenu_default, {
      options: items,
      onSelect: switchTo,
      defaultValue: "More",
      bold: true
    }));
  });
  var NavbarContent = (props) => {
    const resizeHost = document.querySelector(".Root__main-view .os-resize-observer-host");
    const [windowSize, setWindowSize] = (0, import_react2.useState)(resizeHost.clientWidth);
    const resizeHandler = () => setWindowSize(resizeHost.clientWidth);
    (0, import_react2.useEffect)(() => {
      const observer = new ResizeObserver(resizeHandler);
      observer.observe(resizeHost);
      return () => {
        observer.disconnect();
      };
    }, [resizeHandler]);
    return /* @__PURE__ */ import_react2.default.createElement(NavbarContext, null, /* @__PURE__ */ import_react2.default.createElement(Navbar, {
      ...props,
      windowSize
    }));
  };
  var NavbarContext = (props) => {
    return import_react_dom.default.createPortal(
      /* @__PURE__ */ import_react2.default.createElement("div", {
        className: "main-topbar-topbarContent"
      }, props.children),
      document.querySelector(".main-topBar-topbarContentWrapper")
    );
  };
  var Navbar = (props) => {
    const navBarListRef = import_react2.default.useRef(null);
    const [childrenSizes, setChildrenSizes] = (0, import_react2.useState)([]);
    const [availableSpace, setAvailableSpace] = (0, import_react2.useState)(0);
    const [outOfRangeItemIndexes, setOutOfRangeItemIndexes] = (0, import_react2.useState)([]);
    let items = props.links.map((link) => new NavbarItem2(link, link === props.activeLink));
    (0, import_react2.useEffect)(() => {
      if (!navBarListRef.current)
        return;
      const children = Array.from(navBarListRef.current.children);
      const navBarItemSizes = children.map((child) => child.clientWidth);
      setChildrenSizes(navBarItemSizes);
    }, []);
    (0, import_react2.useEffect)(() => {
      if (!navBarListRef.current)
        return;
      setAvailableSpace(navBarListRef.current.clientWidth);
    }, [props.windowSize]);
    (0, import_react2.useEffect)(() => {
      if (!navBarListRef.current)
        return;
      let totalSize = childrenSizes.reduce((a, b) => a + b, 0);
      if (totalSize <= availableSpace) {
        setOutOfRangeItemIndexes([]);
        return;
      }
      const viewMoreButtonSize = Math.max(...childrenSizes);
      const itemsToHide = [];
      let stopWidth = viewMoreButtonSize;
      childrenSizes.forEach((childWidth, i) => {
        if (availableSpace >= stopWidth + childWidth) {
          stopWidth += childWidth;
        } else if (i !== items.length) {
          itemsToHide.push(i);
        }
      });
      setOutOfRangeItemIndexes(itemsToHide);
    }, [availableSpace, childrenSizes]);
    return /* @__PURE__ */ import_react2.default.createElement("nav", {
      className: navBar_module_default.topBarNav
    }, /* @__PURE__ */ import_react2.default.createElement("ul", {
      className: `${navBar_module_default.topBarHeader} queue-tabBar-header`,
      ref: navBarListRef
    }, items.filter((_, id) => !outOfRangeItemIndexes.includes(id)).map(
      (item) => /* @__PURE__ */ import_react2.default.createElement(NavbarItemComponent, {
        item,
        switchTo: props.switchCallback
      })
    ), outOfRangeItemIndexes.length ? /* @__PURE__ */ import_react2.default.createElement(NavbarMore, {
      items: outOfRangeItemIndexes.map((i) => items[i]),
      switchTo: props.switchCallback
    }) : null));
  };
  var navBar_default = NavbarContent;

  // node_modules/spcr-navigation-bar/useNavigationBar.tsx
  var useNavigationBar = (links) => {
    const [activeLink, setActiveLink] = (0, import_react3.useState)(links[0]);
    const navbar = /* @__PURE__ */ import_react3.default.createElement(navBar_default, {
      links,
      activeLink,
      switchCallback: (link) => setActiveLink(link)
    });
    return [navbar, activeLink, setActiveLink];
  };
  var useNavigationBar_default = useNavigationBar;

  // src/pages/top_artists.tsx
  var import_react6 = __toESM(require_react());

  // src/components/dropdown.tsx
  var import_react4 = __toESM(require_react());
  var activeStyle = {
    backgroundColor: "rgba(var(--spice-rgb-selected-row),.1)"
  };
  var Icon = (props) => {
    return /* @__PURE__ */ import_react4.default.createElement(Spicetify.ReactComponent.IconComponent, __spreadProps(__spreadValues({}, props), {
      className: "Svg-sc-ytk21e-0 Svg-img-16-icon",
      "data-encore-id": "icon",
      viewBox: "0 0 16 16",
      height: "16",
      width: "16"
    }), /* @__PURE__ */ import_react4.default.createElement("path", {
      d: "M15.53 2.47a.75.75 0 0 1 0 1.06L4.907 14.153.47 9.716a.75.75 0 0 1 1.06-1.06l3.377 3.376L14.47 2.47a.75.75 0 0 1 1.06 0z"
    }));
  };
  var DropdownMenu = ({ links, switchCallback }) => {
    console.log("DropdownMenu render");
    const [activeOption, setActiveOption] = import_react4.default.useState(links[0]);
    const updateOption = import_react4.default.useCallback((value) => {
      return () => {
        switchCallback(value);
        setActiveOption(value);
      };
    }, []);
    const MenuItem = (_a) => {
      var _b = _a, { label } = _b, props = __objRest(_b, ["label"]);
      const isChecked = label === activeOption;
      return /* @__PURE__ */ import_react4.default.createElement(Spicetify.ReactComponent.MenuItem, __spreadProps(__spreadValues({}, props), {
        trigger: "click",
        onClick: updateOption(label),
        "data-checked": isChecked,
        trailingIcon: isChecked && /* @__PURE__ */ import_react4.default.createElement(Icon, null),
        style: isChecked ? activeStyle : void 0
      }), label);
    };
    const optionItems = links.map((label, index) => {
      return /* @__PURE__ */ import_react4.default.createElement(MenuItem, {
        label,
        key: index
      });
    });
    const MenuWrapper2 = (props) => {
      return /* @__PURE__ */ import_react4.default.createElement(import_react4.default.Fragment, null, /* @__PURE__ */ import_react4.default.createElement(Spicetify.ReactComponent.Menu, __spreadValues({}, props), optionItems));
    };
    return /* @__PURE__ */ import_react4.default.createElement(import_react4.default.Fragment, null, /* @__PURE__ */ import_react4.default.createElement(Spicetify.ReactComponent.ContextMenu, {
      menu: /* @__PURE__ */ import_react4.default.createElement(MenuWrapper2, null),
      trigger: "click"
    }, /* @__PURE__ */ import_react4.default.createElement("button", {
      className: "x-sortBox-sortDropdown",
      type: "button",
      role: "combobox",
      "aria-controls": "sortboxlist-29ad4489-2ff4-4a03-8c0c-ffc6f90c2fed",
      "aria-expanded": "false"
    }, /* @__PURE__ */ import_react4.default.createElement("span", {
      className: "Type__TypeElement-sc-goli3j-0 TypeElement-mesto-type cvTLPmjt6T7M85EKcB8w",
      "data-encore-id": "type"
    }, activeOption), /* @__PURE__ */ import_react4.default.createElement("svg", {
      role: "img",
      height: "16",
      width: "16",
      "aria-hidden": "true",
      className: "Svg-sc-ytk21e-0 Svg-img-16-icon SbDHY3fVADNJ4l9qOLQ2",
      viewBox: "0 0 16 16",
      "data-encore-id": "icon"
    }, /* @__PURE__ */ import_react4.default.createElement("path", {
      d: "m14 6-6 6-6-6h12z"
    })))));
  };
  var dropdown_default = import_react4.default.memo(DropdownMenu);

  // src/components/artist_card.tsx
  var import_react5 = __toESM(require_react());
  var MenuWrapper = import_react5.default.memo((props) => /* @__PURE__ */ import_react5.default.createElement(Spicetify.ReactComponent.ArtistMenu, __spreadValues({}, props)));
  var Card = ({ name, image, uri, subtext }) => {
    const goToArtist = (uriString) => {
      const uriObj = Spicetify.URI.fromString(uriString);
      const url = uriObj.toURLPath(true);
      Spicetify.Platform.History.push(url);
      Spicetify.Platform.History.goForward();
    };
    return /* @__PURE__ */ import_react5.default.createElement(import_react5.default.Fragment, null, /* @__PURE__ */ import_react5.default.createElement(Spicetify.ReactComponent.ContextMenu, {
      menu: /* @__PURE__ */ import_react5.default.createElement(MenuWrapper, {
        uri
      }),
      trigger: "right-click"
    }, /* @__PURE__ */ import_react5.default.createElement("div", {
      className: "main-card-card",
      onClick: () => goToArtist(uri)
    }, /* @__PURE__ */ import_react5.default.createElement("div", {
      draggable: "true",
      className: "main-card-draggable"
    }, /* @__PURE__ */ import_react5.default.createElement("div", {
      className: "main-card-imageContainer"
    }, /* @__PURE__ */ import_react5.default.createElement("div", {
      className: "main-cardImage-imageWrapper main-cardImage-circular"
    }, /* @__PURE__ */ import_react5.default.createElement("div", {
      className: ""
    }, /* @__PURE__ */ import_react5.default.createElement("img", {
      "aria-hidden": "false",
      draggable: "false",
      loading: "lazy",
      src: image,
      className: "main-image-image main-cardImage-image main-cardImage-circular main-image-loaded"
    }))), /* @__PURE__ */ import_react5.default.createElement("div", {
      className: "main-card-PlayButtonContainer"
    }, /* @__PURE__ */ import_react5.default.createElement("div", {
      className: "main-playButton-PlayButton"
    }, /* @__PURE__ */ import_react5.default.createElement("button", {
      "data-encore-id": "buttonPrimary",
      className: "Button-sc-qlcn5g-0 Button-md-buttonPrimary-useBrowserDefaultFocusStyle"
    }, /* @__PURE__ */ import_react5.default.createElement("span", {
      className: "ButtonInner-sc-14ud5tc-0 ButtonInner-md-iconOnly encore-bright-accent-set"
    }, /* @__PURE__ */ import_react5.default.createElement("span", {
      "aria-hidden": "true",
      className: "IconWrapper__Wrapper-sc-1hf1hjl-0 Wrapper-md-24-only"
    }, /* @__PURE__ */ import_react5.default.createElement("svg", {
      role: "img",
      height: "24",
      width: "24",
      "aria-hidden": "true",
      viewBox: "0 0 24 24",
      "data-encore-id": "icon",
      className: "Svg-sc-ytk21e-0 Svg-img-24-icon"
    }, /* @__PURE__ */ import_react5.default.createElement("path", {
      d: "m7.05 3.606 13.49 7.788a.7.7 0 0 1 0 1.212L7.05 20.394A.7.7 0 0 1 6 19.788V4.212a.7.7 0 0 1 1.05-.606z"
    })))))))), /* @__PURE__ */ import_react5.default.createElement("div", {
      className: "main-card-cardMetadata"
    }, /* @__PURE__ */ import_react5.default.createElement("a", {
      draggable: "false",
      className: "main-cardHeader-link",
      dir: "auto"
    }, /* @__PURE__ */ import_react5.default.createElement("div", {
      className: "Type__TypeElement-sc-goli3j-0 TypeElement-balladBold-textBase-4px-type main-cardHeader-text",
      "data-encore-id": "type"
    }, name)), /* @__PURE__ */ import_react5.default.createElement("div", {
      className: "Type__TypeElement-sc-goli3j-0 TypeElement-mesto-textSubdued-type main-cardSubHeader-root",
      "data-encore-id": "type"
    }, /* @__PURE__ */ import_react5.default.createElement("span", null, subtext))), /* @__PURE__ */ import_react5.default.createElement("div", {
      className: "main-card-cardLink"
    })))));
  };
  var artist_card_default = import_react5.default.memo(Card);

  // src/pages/top_artists.tsx
  var ArtistsPage = () => {
    const [topArtists, setTopArtists] = import_react6.default.useState([]);
    console.log(" artists page render");
    console.log(topArtists);
    const fetchTopArtists = async (time_range) => {
      const start = window.performance.now();
      Spicetify.CosmosAsync.get(`https://api.spotify.com/v1/me/top/artists?limit=50&offset=0&time_range=${time_range}`).then(
        (fetched_artists) => setTopArtists(fetched_artists.items)
      );
      const end = window.performance.now();
      console.log(end - start);
    };
    import_react6.default.useEffect(() => {
      fetchTopArtists("short_term");
    }, []);
    const handleDropdownChange = import_react6.default.useCallback((value) => {
      const timePeriods = {
        "Past 4 Weeks": "short_term",
        "Past 6 Months": "medium_term",
        "All Time": "long_term"
      };
      fetchTopArtists(timePeriods[value]);
    }, []);
    const artistCards = import_react6.default.useMemo(
      () => topArtists.map((artist, index) => /* @__PURE__ */ import_react6.default.createElement(artist_card_default, {
        key: artist.id,
        name: artist.name,
        image: artist.images[2].url,
        uri: artist.uri,
        subtext: "Artist"
      })),
      [topArtists]
    );
    return /* @__PURE__ */ import_react6.default.createElement(import_react6.default.Fragment, null, /* @__PURE__ */ import_react6.default.createElement("section", {
      className: "contentSpacing"
    }, /* @__PURE__ */ import_react6.default.createElement("div", {
      className: `collection-collection-header stats-header`
    }, /* @__PURE__ */ import_react6.default.createElement("h1", {
      "data-encore-id": "type",
      className: "Type__TypeElement-sc-goli3j-0 TypeElement-canon-type"
    }, "Top Artists"), /* @__PURE__ */ import_react6.default.createElement("div", {
      className: "collection-searchBar-searchBar"
    }, /* @__PURE__ */ import_react6.default.createElement(dropdown_default, {
      links: ["Past 4 Weeks", "Past 6 Months", "All Time"],
      switchCallback: handleDropdownChange
    }))), /* @__PURE__ */ import_react6.default.createElement("div", null, /* @__PURE__ */ import_react6.default.createElement("div", {
      className: `main-gridContainer-gridContainer stats-grid`
    }, artistCards))));
  };
  var top_artists_default = import_react6.default.memo(ArtistsPage);

  // src/pages/top_tracks.tsx
  var import_react8 = __toESM(require_react());

  // src/components/track_row.tsx
  var import_react7 = __toESM(require_react());
  function formatDuration(durationMs) {
    const totalSeconds = Math.floor(durationMs / 1e3);
    const minutes = Math.floor(totalSeconds / 60);
    const seconds = totalSeconds % 60;
    return `${minutes.toString().padStart(1, "0")}:${seconds.toString().padStart(2, "0")}`;
  }
  var ArtistLink = (props) => {
    return /* @__PURE__ */ import_react7.default.createElement(import_react7.default.Fragment, null, /* @__PURE__ */ import_react7.default.createElement("a", {
      draggable: "true",
      dir: "auto",
      href: props.uri,
      tabIndex: -1
    }, props.name), props.index === props.length ? null : ", ");
  };
  var ExplicitBadge = import_react7.default.memo(() => {
    return /* @__PURE__ */ import_react7.default.createElement(import_react7.default.Fragment, null, /* @__PURE__ */ import_react7.default.createElement("span", {
      className: "Type__TypeElement-sc-goli3j-0 TypeElement-ballad-textSubdued-type main-trackList-rowBadges",
      "data-encore-id": "type"
    }, /* @__PURE__ */ import_react7.default.createElement("span", {
      "aria-label": "Explicit",
      className: "main-tag-container",
      title: "Explicit"
    }, "E")));
  });
  var LikedIcon = ({ active, id }) => {
    const [liked, setLiked] = import_react7.default.useState(active);
    const toggleLike = () => {
      if (liked) {
        Spicetify.CosmosAsync.del("https://api.spotify.com/v1/me/tracks?ids=" + id);
        Spicetify.showNotification("Removed from your Liked Songs");
      } else {
        Spicetify.CosmosAsync.put("https://api.spotify.com/v1/me/tracks?ids=" + id);
        Spicetify.showNotification("Added to your Liked Songs");
      }
      setLiked(!liked);
    };
    import_react7.default.useEffect(() => {
      setLiked(active);
    }, [active]);
    return /* @__PURE__ */ import_react7.default.createElement("button", {
      type: "button",
      role: "switch",
      "aria-checked": liked,
      "aria-label": "Remove from Your Library",
      onClick: toggleLike,
      className: liked ? "main-addButton-button main-trackList-rowHeartButton main-addButton-active" : "main-addButton-button main-trackList-rowHeartButton",
      tabIndex: -1
    }, /* @__PURE__ */ import_react7.default.createElement("svg", {
      role: "img",
      height: "16",
      width: "16",
      "aria-hidden": "true",
      viewBox: "0 0 16 16",
      "data-encore-id": "icon",
      className: "Svg-sc-ytk21e-0 Svg-img-16-icon"
    }, /* @__PURE__ */ import_react7.default.createElement("path", {
      d: liked ? "M15.724 4.22A4.313 4.313 0 0 0 12.192.814a4.269 4.269 0 0 0-3.622 1.13.837.837 0 0 1-1.14 0 4.272 4.272 0 0 0-6.21 5.855l5.916 7.05a1.128 1.128 0 0 0 1.727 0l5.916-7.05a4.228 4.228 0 0 0 .945-3.577z" : "M1.69 2A4.582 4.582 0 0 1 8 2.023 4.583 4.583 0 0 1 11.88.817h.002a4.618 4.618 0 0 1 3.782 3.65v.003a4.543 4.543 0 0 1-1.011 3.84L9.35 14.629a1.765 1.765 0 0 1-2.093.464 1.762 1.762 0 0 1-.605-.463L1.348 8.309A4.582 4.582 0 0 1 1.689 2zm3.158.252A3.082 3.082 0 0 0 2.49 7.337l.005.005L7.8 13.664a.264.264 0 0 0 .311.069.262.262 0 0 0 .09-.069l5.312-6.33a3.043 3.043 0 0 0 .68-2.573 3.118 3.118 0 0 0-2.551-2.463 3.079 3.079 0 0 0-2.612.816l-.007.007a1.501 1.501 0 0 1-2.045 0l-.009-.008a3.082 3.082 0 0 0-2.121-.861z"
    })));
  };
  var TrackRow = (props) => {
    const ArtistLinks = props.artists.map((artist, index) => {
      return /* @__PURE__ */ import_react7.default.createElement(ArtistLink, __spreadValues({
        index,
        length: props.artists.length - 1
      }, artist));
    });
    return /* @__PURE__ */ import_react7.default.createElement(import_react7.default.Fragment, null, /* @__PURE__ */ import_react7.default.createElement("div", {
      role: "row",
      "aria-rowindex": 2,
      "aria-selected": "false"
    }, /* @__PURE__ */ import_react7.default.createElement("div", {
      className: "main-trackList-trackListRow main-trackList-trackListRowGrid",
      draggable: "true",
      role: "presentation"
    }, /* @__PURE__ */ import_react7.default.createElement("div", {
      className: "main-trackList-rowSectionIndex",
      role: "gridcell",
      "aria-colindex": 1,
      tabIndex: -1
    }, /* @__PURE__ */ import_react7.default.createElement("div", {
      className: "main-trackList-rowMarker"
    }, /* @__PURE__ */ import_react7.default.createElement("span", {
      className: "Type__TypeElement-sc-goli3j-0 TypeElement-ballad-type main-trackList-number",
      "data-encore-id": "type"
    }, props.index + 1), /* @__PURE__ */ import_react7.default.createElement("button", {
      className: "main-trackList-rowImagePlayButton",
      "aria-label": "Play Odd Ways by MIKE, Wiki, The Alchemist",
      tabIndex: -1,
      onClick: () => Spicetify.Player.playUri(props.uri)
    }, /* @__PURE__ */ import_react7.default.createElement("svg", {
      role: "img",
      height: "24",
      width: "24",
      "aria-hidden": "true",
      className: "Svg-sc-ytk21e-0 Svg-img-24-icon main-trackList-rowPlayPauseIcon",
      viewBox: "0 0 24 24",
      "data-encore-id": "icon"
    }, /* @__PURE__ */ import_react7.default.createElement("path", {
      d: "m7.05 3.606 13.49 7.788a.7.7 0 0 1 0 1.212L7.05 20.394A.7.7 0 0 1 6 19.788V4.212a.7.7 0 0 1 1.05-.606z"
    }))))), /* @__PURE__ */ import_react7.default.createElement("div", {
      className: "main-trackList-rowSectionStart",
      role: "gridcell",
      "aria-colindex": 2,
      tabIndex: -1
    }, /* @__PURE__ */ import_react7.default.createElement("img", {
      "aria-hidden": "false",
      draggable: "false",
      loading: "eager",
      src: props.album.images[2].url,
      alt: "",
      className: "main-image-image main-trackList-rowImage main-image-loaded",
      width: "40",
      height: "40"
    }), /* @__PURE__ */ import_react7.default.createElement("div", {
      className: "main-trackList-rowMainContent"
    }, /* @__PURE__ */ import_react7.default.createElement("div", {
      dir: "auto",
      className: "Type__TypeElement-sc-goli3j-0 TypeElement-ballad-textBase-type main-trackList-rowTitle standalone-ellipsis-one-line",
      "data-encore-id": "type"
    }, props.name), props.explicit && /* @__PURE__ */ import_react7.default.createElement(ExplicitBadge, null), /* @__PURE__ */ import_react7.default.createElement("span", {
      className: "Type__TypeElement-sc-goli3j-0 TypeElement-mesto-textSubdued-type main-trackList-rowSubTitle standalone-ellipsis-one-line",
      "data-encore-id": "type"
    }, ArtistLinks))), /* @__PURE__ */ import_react7.default.createElement("div", {
      className: "main-trackList-rowSectionVariable",
      role: "gridcell",
      "aria-colindex": 3,
      tabIndex: -1
    }, /* @__PURE__ */ import_react7.default.createElement("span", {
      "data-encore-id": "type",
      className: "Type__TypeElement-sc-goli3j-0 TypeElement-mesto-type"
    }, /* @__PURE__ */ import_react7.default.createElement("a", {
      draggable: "true",
      className: "standalone-ellipsis-one-line",
      dir: "auto",
      href: props.album.uri,
      tabIndex: -1
    }, props.album.name))), /* @__PURE__ */ import_react7.default.createElement("div", {
      className: "main-trackList-rowSectionEnd",
      role: "gridcell",
      "aria-colindex": 5,
      tabIndex: -1
    }, props.liked ? /* @__PURE__ */ import_react7.default.createElement(LikedIcon, {
      active: props.liked,
      id: props.id
    }) : "", /* @__PURE__ */ import_react7.default.createElement("div", {
      className: "Type__TypeElement-sc-goli3j-0 TypeElement-mesto-textSubdued-type main-trackList-rowDuration",
      "data-encore-id": "type"
    }, formatDuration(props.duration_ms)), /* @__PURE__ */ import_react7.default.createElement("button", {
      type: "button",
      "aria-haspopup": "menu",
      "aria-label": "More options for Odd Ways by MIKE, Wiki, The Alchemist",
      className: "main-moreButton-button main-trackList-rowMoreButton",
      tabIndex: -1
    }, /* @__PURE__ */ import_react7.default.createElement("svg", {
      role: "img",
      height: "16",
      width: "16",
      "aria-hidden": "true",
      viewBox: "0 0 16 16",
      "data-encore-id": "icon",
      className: "Svg-sc-ytk21e-0 Svg-img-16-icon"
    }, /* @__PURE__ */ import_react7.default.createElement("path", {
      d: "M3 8a1.5 1.5 0 1 1-3 0 1.5 1.5 0 0 1 3 0zm6.5 0a1.5 1.5 0 1 1-3 0 1.5 1.5 0 0 1 3 0zM16 8a1.5 1.5 0 1 1-3 0 1.5 1.5 0 0 1 3 0z"
    })))))));
  };
  var track_row_default = import_react7.default.memo(TrackRow);

  // src/pages/top_tracks.tsx
  var checkLiked = async (tracks) => {
    return Spicetify.CosmosAsync.get(`https://api.spotify.com/v1/me/tracks/contains?ids=${tracks.join(",")}`);
  };
  var TracksPage = () => {
    const [topTracks, setTopTracks] = import_react8.default.useState({ tracks: [], liked: [] });
    console.log(" tracks page render");
    console.log(topTracks);
    const fetchTopTracks = async (time_range) => {
      const start = window.performance.now();
      if (!time_range)
        return;
      const { items: fetchedTracks } = await Spicetify.CosmosAsync.get(`https://api.spotify.com/v1/me/top/tracks?limit=50&offset=0&time_range=${time_range}`);
      const fetchedLikedArray = await checkLiked(fetchedTracks.map((track) => track.id));
      setTopTracks({ tracks: fetchedTracks, liked: fetchedLikedArray });
      const end = window.performance.now();
      console.log(end - start);
    };
    import_react8.default.useEffect(() => {
      fetchTopTracks("short_term");
    }, []);
    if (!topTracks.tracks.length)
      return /* @__PURE__ */ import_react8.default.createElement(import_react8.default.Fragment, null);
    const createPlaylist = async () => {
      var _a;
      const newPlaylist = await Spicetify.CosmosAsync.post("sp://core-playlist/v1/rootlist", {
        operation: "create",
        name: `Top Songs - ${(_a = document.querySelector(".x-sortBox-sortDropdown > span")) == null ? void 0 : _a.innerHTML}`,
        playlist: true,
        public: false,
        uris: topTracks.tracks.map((track) => track.uri)
      });
    };
    const handleDropdownChange = (value) => {
      const timePeriods = {
        "Past 4 Weeks": "short_term",
        "Past 6 Months": "medium_term",
        "All Time": "long_term"
      };
      fetchTopTracks(timePeriods[value]);
    };
    const trackRows = topTracks.tracks.map((track, index) => /* @__PURE__ */ import_react8.default.createElement(track_row_default, __spreadValues({
      index,
      liked: topTracks.liked[index]
    }, track)));
    return /* @__PURE__ */ import_react8.default.createElement(import_react8.default.Fragment, null, /* @__PURE__ */ import_react8.default.createElement("section", {
      className: "contentSpacing"
    }, /* @__PURE__ */ import_react8.default.createElement("div", {
      className: `collection-collection-header stats-header`
    }, /* @__PURE__ */ import_react8.default.createElement("div", {
      className: "stats-trackPageTitle"
    }, /* @__PURE__ */ import_react8.default.createElement("h1", {
      "data-encore-id": "type",
      className: "Type__TypeElement-sc-goli3j-0 TypeElement-canon-type"
    }, "Top Tracks"), /* @__PURE__ */ import_react8.default.createElement("button", {
      className: "stats-createPlaylistButton",
      "data-encore-id": "buttonSecondary",
      "aria-expanded": "false",
      onClick: createPlaylist
    }, "Turn Into Playlist")), /* @__PURE__ */ import_react8.default.createElement("div", {
      className: "collection-searchBar-searchBar"
    }, /* @__PURE__ */ import_react8.default.createElement(dropdown_default, {
      links: ["Past 4 Weeks", "Past 6 Months", "All Time"],
      switchCallback: handleDropdownChange
    }))), /* @__PURE__ */ import_react8.default.createElement("div", null, /* @__PURE__ */ import_react8.default.createElement("div", {
      role: "grid",
      "aria-rowcount": 50,
      "aria-colcount": 4,
      className: "main-trackList-trackList main-trackList-indexable",
      tabIndex: 0
    }, /* @__PURE__ */ import_react8.default.createElement("div", {
      className: "main-trackList-trackListHeader",
      role: "presentation"
    }, /* @__PURE__ */ import_react8.default.createElement("div", {
      className: "main-trackList-trackListHeaderRow main-trackList-trackListRowGrid",
      role: "row",
      "aria-rowindex": 1
    }, /* @__PURE__ */ import_react8.default.createElement("div", {
      className: "main-trackList-rowSectionIndex",
      role: "columnheader",
      "aria-colindex": 1,
      "aria-sort": "none",
      tabIndex: -1
    }, "#"), /* @__PURE__ */ import_react8.default.createElement("div", {
      className: "main-trackList-rowSectionStart",
      role: "columnheader",
      "aria-colindex": 2,
      "aria-sort": "none",
      tabIndex: -1
    }, /* @__PURE__ */ import_react8.default.createElement("button", {
      className: "main-trackList-column main-trackList-sortable",
      tabIndex: -1
    }, /* @__PURE__ */ import_react8.default.createElement("span", {
      className: "Type__TypeElement-sc-goli3j-0 TypeElement-mesto-type standalone-ellipsis-one-line",
      "data-encore-id": "type"
    }, "Title"))), /* @__PURE__ */ import_react8.default.createElement("div", {
      className: "main-trackList-rowSectionVariable",
      role: "columnheader",
      "aria-colindex": 3,
      "aria-sort": "none",
      tabIndex: -1
    }, /* @__PURE__ */ import_react8.default.createElement("button", {
      className: "main-trackList-column main-trackList-sortable",
      tabIndex: -1
    }, /* @__PURE__ */ import_react8.default.createElement("span", {
      className: "Type__TypeElement-sc-goli3j-0 TypeElement-mesto-type standalone-ellipsis-one-line",
      "data-encore-id": "type"
    }, "Album"))), /* @__PURE__ */ import_react8.default.createElement("div", {
      className: "main-trackList-rowSectionEnd",
      role: "columnheader",
      "aria-colindex": 5,
      "aria-sort": "none",
      tabIndex: -1
    }, /* @__PURE__ */ import_react8.default.createElement("button", {
      "aria-label": "Duration",
      className: "main-trackList-column main-trackList-durationHeader main-trackList-sortable",
      tabIndex: -1
    }, /* @__PURE__ */ import_react8.default.createElement("svg", {
      role: "img",
      height: "16",
      width: "16",
      "aria-hidden": "true",
      viewBox: "0 0 16 16",
      "data-encore-id": "icon",
      className: "Svg-sc-ytk21e-0 Svg-img-16-icon"
    }, /* @__PURE__ */ import_react8.default.createElement("path", {
      d: "M8 1.5a6.5 6.5 0 1 0 0 13 6.5 6.5 0 0 0 0-13zM0 8a8 8 0 1 1 16 0A8 8 0 0 1 0 8z"
    }), /* @__PURE__ */ import_react8.default.createElement("path", {
      d: "M8 3.25a.75.75 0 0 1 .75.75v3.25H11a.75.75 0 0 1 0 1.5H7.25V4A.75.75 0 0 1 8 3.25z"
    })))))), /* @__PURE__ */ import_react8.default.createElement("div", {
      className: "main-rootlist-wrapper",
      role: "presentation",
      style: { height: 50 * 56 }
    }, /* @__PURE__ */ import_react8.default.createElement("div", {
      role: "presentation"
    }, trackRows))))));
  };
  var top_tracks_default = import_react8.default.memo(TracksPage);

  // src/pages/top_genres.tsx
  var import_react11 = __toESM(require_react());

  // src/components/stat_card.tsx
  var import_react9 = __toESM(require_react());
  var StatCard = (props) => {
    return /* @__PURE__ */ import_react9.default.createElement(import_react9.default.Fragment, null, /* @__PURE__ */ import_react9.default.createElement("div", {
      className: "main-card-card"
    }, /* @__PURE__ */ import_react9.default.createElement("div", {
      draggable: "true",
      className: "main-card-draggable"
    }, /* @__PURE__ */ import_react9.default.createElement("div", {
      className: "stats-cardValue"
    }, props.value), /* @__PURE__ */ import_react9.default.createElement("div", null, /* @__PURE__ */ import_react9.default.createElement("div", {
      className: `Type__TypeElement-sc-goli3j-0 TypeElement-balladBold-textBase-4px-type main-cardHeader-text stats-cardText`,
      "data-encore-id": "type"
    }, props.stat)))));
  };
  var stat_card_default = import_react9.default.memo(StatCard);

  // src/components/genres_card.tsx
  var import_react10 = __toESM(require_react());
  var genreLine = (name, value, limit) => {
    return /* @__PURE__ */ import_react10.default.createElement("div", {
      className: "stats-genreRow"
    }, /* @__PURE__ */ import_react10.default.createElement("div", {
      className: "stats-genreRowFill",
      style: {
        width: `calc(${value / limit * 100}% + ${(limit - value) / (limit - 1) * 100}px)`
      }
    }, /* @__PURE__ */ import_react10.default.createElement("span", {
      className: "stats-genreText"
    }, name)), /* @__PURE__ */ import_react10.default.createElement("span", {
      className: "stats-genreValue"
    }, Math.round(value / 50 * 100) + "%"));
  };
  var genreLines = (genres) => {
    return genres.map(([genre, value]) => {
      return genreLine(genre, value, genres[0][1]);
    });
  };
  var genresCard = ({ genres }) => {
    const genresArray = genres.sort(([, a], [, b]) => b - a).slice(0, 10);
    return /* @__PURE__ */ import_react10.default.createElement("div", {
      className: `main-card-card stats-genreCard`
    }, genreLines(genresArray));
  };
  var genres_card_default = import_react10.default.memo(genresCard);

  // src/pages/top_genres.tsx
  var GenresPage = () => {
    const [topGenres, setTopGenres] = import_react11.default.useState({ genres: [], features: {} });
    const fetchTopGenres = async (timeRange) => {
      const start = window.performance.now();
      const [fetchedArtists, fetchedTracks] = await Promise.all([
        Spicetify.CosmosAsync.get(`https://api.spotify.com/v1/me/top/artists?limit=50&offset=0&time_range=${timeRange}`).then((res) => res.items),
        Spicetify.CosmosAsync.get(`https://api.spotify.com/v1/me/top/tracks?limit=50&offset=0&time_range=${timeRange}`).then((res) => res.items)
      ]);
      console.log(fetchedArtists);
      const genres = fetchedArtists.reduce((acc, artist) => {
        artist.genres.forEach((genre) => {
          const index = acc.findIndex(([g]) => g === genre);
          if (index !== -1) {
            acc[index][1] += 1;
          } else {
            acc.push([genre, 1]);
          }
        });
        return acc;
      }, []);
      let trackPopularity = 0;
      const topTracks = fetchedTracks.map((track) => {
        trackPopularity += track.popularity;
        return track.id;
      });
      const featureData = await fetchAudioFeatures(topTracks);
      const audioFeatures = featureData.audio_features.reduce(
        (acc, track) => {
          acc["danceability"] += track["danceability"];
          acc["energy"] += track["energy"];
          acc["valence"] += track["valence"];
          acc["speechiness"] += track["speechiness"];
          acc["acousticness"] += track["acousticness"];
          acc["instrumentalness"] += track["instrumentalness"];
          acc["liveness"] += track["liveness"];
          acc["tempo"] += track["tempo"];
          acc["loudness"] += track["loudness"];
          return acc;
        },
        {
          danceability: 0,
          energy: 0,
          valence: 0,
          speechiness: 0,
          acousticness: 0,
          instrumentalness: 0,
          liveness: 0,
          tempo: 0,
          loudness: 0,
          popularity: trackPopularity
        }
      );
      for (let key in audioFeatures) {
        audioFeatures[key] = audioFeatures[key] / 50;
      }
      const end = window.performance.now();
      console.log(end - start);
      setTopGenres({ genres, features: audioFeatures });
    };
    const fetchAudioFeatures = async (ids) => {
      const data = Spicetify.CosmosAsync.get(`https://api.spotify.com/v1/audio-features?ids=${ids.join(",")}`);
      return data;
    };
    import_react11.default.useEffect(() => {
      fetchTopGenres("short_term");
    }, []);
    if (!topGenres.genres.length)
      return /* @__PURE__ */ import_react11.default.createElement(import_react11.default.Fragment, null);
    const timePeriods = {
      "Past 4 Weeks": "short_term",
      "Past 6 Months": "medium_term",
      "All Time": "long_term"
    };
    const handleDropdownChange = (value) => {
      fetchTopGenres(timePeriods[value]);
    };
    const parseVal = (key) => {
      switch (key) {
        case "tempo":
          return Math.round(topGenres.features[key]) + "bpm";
        case "loudness":
          return Math.round(topGenres.features[key]) + "dB";
        case "popularity":
          return Math.round(topGenres.features[key]) + "%";
        default:
          return Math.round(topGenres.features[key] * 100) + "%";
      }
    };
    const statCards = [];
    for (let key in topGenres.features) {
      statCards.push(/* @__PURE__ */ import_react11.default.createElement(stat_card_default, {
        stat: key[0].toUpperCase() + key.slice(1),
        value: parseVal(key)
      }));
    }
    return /* @__PURE__ */ import_react11.default.createElement(import_react11.default.Fragment, null, /* @__PURE__ */ import_react11.default.createElement("section", {
      className: "contentSpacing"
    }, /* @__PURE__ */ import_react11.default.createElement("div", {
      className: `collection-collection-header stats-header`
    }, /* @__PURE__ */ import_react11.default.createElement("h1", {
      "data-encore-id": "type",
      className: "Type__TypeElement-sc-goli3j-0 TypeElement-canon-type"
    }, "Top Genres"), /* @__PURE__ */ import_react11.default.createElement("div", {
      className: "collection-searchBar-searchBar"
    }, /* @__PURE__ */ import_react11.default.createElement(dropdown_default, {
      links: ["Past 4 Weeks", "Past 6 Months", "All Time"],
      switchCallback: handleDropdownChange
    }))), /* @__PURE__ */ import_react11.default.createElement("div", {
      className: "stats-page"
    }, /* @__PURE__ */ import_react11.default.createElement("section", null, /* @__PURE__ */ import_react11.default.createElement(genres_card_default, {
      genres: topGenres.genres
    })), /* @__PURE__ */ import_react11.default.createElement("section", null, /* @__PURE__ */ import_react11.default.createElement("div", {
      className: `main-gridContainer-gridContainer stats-grid`
    }, statCards)))));
  };
  var top_genres_default = import_react11.default.memo(GenresPage);

  // src/pages/library.tsx
  var import_react12 = __toESM(require_react());
  var LibraryPage = () => {
    const [library, setLibrary] = import_react12.default.useState(null);
    const fetchData = async () => {
      const start = window.performance.now();
      let dart = window.performance.now();
      const rootlistItems = await Spicetify.CosmosAsync.get("sp://core-playlist/v1/rootlist");
      console.log("rootlist fetch time: " + (window.performance.now() - dart) + "ms");
      console.log(rootlistItems.rows);
      const flattenPlaylists = (items) => {
        const playlists2 = [];
        items.forEach((row) => {
          if (row.type === "playlist") {
            playlists2.push(row);
          } else if (row.type === "folder") {
            if (!row.rows)
              return;
            const folderPlaylists = flattenPlaylists(row.rows);
            playlists2.push(...folderPlaylists);
          }
        });
        return playlists2;
      };
      const playlists = flattenPlaylists(rootlistItems.rows);
      console.log(playlists);
      let playlistUris = [];
      let trackCount = 0;
      playlists.forEach((playlist) => {
        if (playlist.totalLength === 0)
          return;
        playlistUris.push(playlist.link);
        trackCount += playlist.totalLength;
      }, 0);
      dart = window.performance.now();
      const playlistsMeta = await Promise.all(
        playlistUris.map((uri) => {
          return Spicetify.CosmosAsync.get(`sp://core-playlist/v1/playlist/${uri}?responseFormat=protobufJson`);
        })
      );
      console.log("playlist fetch time: " + (window.performance.now() - dart) + "ms");
      let totalDuration = 0;
      let trackUids = [];
      let artists = {};
      let allTracks = [];
      let totalObscurity = 0;
      playlistsMeta.forEach((playlist) => {
        totalDuration += Number(playlist.duration);
        playlist.item.forEach((item) => {
          trackUids.push(item.trackMetadata.link.split(":")[2]);
          allTracks.push(item);
          totalObscurity += item.trackMetadata.popularity;
          item.trackMetadata.artist.forEach((artist) => {
            if (!artists[artist.link.split(":")[2]]) {
              artists[artist.link.split(":")[2]] = 1;
            } else {
              artists[artist.link.split(":")[2]] += 1;
            }
          });
        });
      });
      const topArtists = Object.keys(artists).sort((a, b) => artists[b] - artists[a]).slice(0, 10);
      dart = window.performance.now();
      const artistsMeta = await Spicetify.CosmosAsync.get(`https://api.spotify.com/v1/artists?ids=${topArtists.join(",")}`);
      console.log("artists fetch time: " + (window.performance.now() - dart) + "ms");
      const topGenres = artistsMeta.artists.reduce((acc, artist) => {
        artist.numTracks = artists[artist.id];
        artist.genres.forEach((genre) => {
          const index = acc.findIndex(([g]) => g === genre);
          if (index !== -1) {
            acc[index][1] += 1;
          } else {
            acc.push([genre, 1]);
          }
        });
        return acc;
      }, []);
      dart = window.performance.now();
      const fetchedFeatures = await fetchAudioFeatures(trackUids);
      console.log("audio features fetch time: " + (window.performance.now() - dart) + "ms");
      const audioFeatures = {
        danceability: 0,
        energy: 0,
        valence: 0,
        speechiness: 0,
        acousticness: 0,
        instrumentalness: 0,
        liveness: 0,
        tempo: 0,
        loudness: 0,
        popularity: totalObscurity
      };
      for (let i = 0; i < fetchedFeatures.length; i++) {
        if (!fetchedFeatures[i])
          continue;
        const track = fetchedFeatures[i];
        audioFeatures["danceability"] += track["danceability"];
        audioFeatures["energy"] += track["energy"];
        audioFeatures["valence"] += track["valence"];
        audioFeatures["speechiness"] += track["speechiness"];
        audioFeatures["acousticness"] += track["acousticness"];
        audioFeatures["instrumentalness"] += track["instrumentalness"];
        audioFeatures["liveness"] += track["liveness"];
        audioFeatures["tempo"] += track["tempo"];
        audioFeatures["loudness"] += track["loudness"];
      }
      for (let key in audioFeatures) {
        audioFeatures[key] /= fetchedFeatures.length;
      }
      setLibrary({
        audioFeatures,
        trackCount,
        totalDuration,
        artists: artistsMeta.artists,
        artistCount: Object.keys(artists).length,
        genres: topGenres,
        playlistCount: playlists.length
      });
      console.log("total fetch time: " + (window.performance.now() - start) + "ms");
    };
    const fetchAudioFeatures = async (ids) => {
      const batchSize = 100;
      const batches = [];
      for (let i = 0; i < ids.length; i += batchSize) {
        const batch = ids.slice(i, i + batchSize);
        batches.push(batch);
      }
      const promises = batches.map((batch) => {
        const url = `https://api.spotify.com/v1/audio-features?ids=${batch.join(",")}`;
        return Spicetify.CosmosAsync.get(url);
      });
      const responses = await Promise.all(promises);
      const data = responses.reduce((acc, response) => {
        return acc.concat(response.audio_features);
      }, []);
      return data;
    };
    import_react12.default.useEffect(() => {
      fetchData();
    }, []);
    if (!library)
      return /* @__PURE__ */ import_react12.default.createElement(import_react12.default.Fragment, null, /* @__PURE__ */ import_react12.default.createElement("div", {
        className: "stats-loadingWrapper"
      }, /* @__PURE__ */ import_react12.default.createElement("svg", {
        role: "img",
        height: "46",
        width: "46",
        "aria-hidden": "true",
        viewBox: "0 0 24 24",
        "data-encore-id": "icon",
        className: "Svg-sc-ytk21e-0 Svg-img-24-icon"
      }, /* @__PURE__ */ import_react12.default.createElement("path", {
        d: "M14.5 2.134a1 1 0 0 1 1 0l6 3.464a1 1 0 0 1 .5.866V21a1 1 0 0 1-1 1h-6a1 1 0 0 1-1-1V3a1 1 0 0 1 .5-.866zM16 4.732V20h4V7.041l-4-2.309zM3 22a1 1 0 0 1-1-1V3a1 1 0 0 1 2 0v18a1 1 0 0 1-1 1zm6 0a1 1 0 0 1-1-1V3a1 1 0 0 1 2 0v18a1 1 0 0 1-1 1z"
      })), /* @__PURE__ */ import_react12.default.createElement("h1", null, "Analysing Your Library")));
    const parseVal = (obj) => {
      switch (obj[0]) {
        case "tempo":
          return Math.round(obj[1]) + "bpm";
        case "loudness":
          return Math.round(obj[1]) + "dB";
        case "popularity":
          return Math.round(obj[1]) + "%";
        default:
          return Math.round(obj[1] * 100) + "%";
      }
    };
    const statCards = [];
    Object.entries(library.audioFeatures).forEach((obj) => {
      statCards.push(/* @__PURE__ */ import_react12.default.createElement(stat_card_default, {
        stat: obj[0][0].toUpperCase() + obj[0].slice(1),
        value: parseVal(obj)
      }));
    });
    const artistCards = library.artists.slice(0, 10).map((artist) => /* @__PURE__ */ import_react12.default.createElement(artist_card_default, {
      name: artist.name,
      image: artist.images[2].url,
      uri: artist.uri,
      subtext: `Appears in ${artist.numTracks} tracks`
    }));
    const scrollGrid = (event) => {
      const grid = event.target.parentNode.querySelector("div");
      grid.scrollLeft += grid.clientWidth;
    };
    const scrollGridLeft = (event) => {
      const grid = event.target.parentNode.querySelector("div");
      grid.scrollLeft -= grid.clientWidth;
    };
    return /* @__PURE__ */ import_react12.default.createElement(import_react12.default.Fragment, null, /* @__PURE__ */ import_react12.default.createElement("section", {
      className: "contentSpacing"
    }, /* @__PURE__ */ import_react12.default.createElement("div", {
      className: `collection-collection-header stats-header`
    }, /* @__PURE__ */ import_react12.default.createElement("h1", {
      "data-encore-id": "type",
      className: "Type__TypeElement-sc-goli3j-0 TypeElement-canon-type"
    }, "Library Analysis")), /* @__PURE__ */ import_react12.default.createElement("div", {
      className: "stats-page"
    }, /* @__PURE__ */ import_react12.default.createElement("section", {
      className: "stats-libraryOverview"
    }, /* @__PURE__ */ import_react12.default.createElement(stat_card_default, {
      stat: "Total Playlists",
      value: library.playlistCount
    }), /* @__PURE__ */ import_react12.default.createElement(stat_card_default, {
      stat: "Total Tracks",
      value: library.trackCount
    }), /* @__PURE__ */ import_react12.default.createElement(stat_card_default, {
      stat: "Total Artists",
      value: library.artistCount
    }), /* @__PURE__ */ import_react12.default.createElement(stat_card_default, {
      stat: "Total Minutes",
      value: Math.floor(library.totalDuration / 60)
    }), /* @__PURE__ */ import_react12.default.createElement(stat_card_default, {
      stat: "Total Hours",
      value: (library.totalDuration / (60 * 60)).toFixed(1)
    })), /* @__PURE__ */ import_react12.default.createElement("section", null, /* @__PURE__ */ import_react12.default.createElement("div", {
      className: "main-shelf-header"
    }, /* @__PURE__ */ import_react12.default.createElement("div", {
      className: "main-shelf-topRow"
    }, /* @__PURE__ */ import_react12.default.createElement("div", {
      className: "main-shelf-titleWrapper"
    }, /* @__PURE__ */ import_react12.default.createElement("h2", {
      className: "Type__TypeElement-sc-goli3j-0 TypeElement-canon-textBase-type main-shelf-title"
    }, "Most Frequent Genres")))), /* @__PURE__ */ import_react12.default.createElement(genres_card_default, {
      genres: library.genres
    }), /* @__PURE__ */ import_react12.default.createElement("section", {
      className: "stats-gridInlineSection"
    }, /* @__PURE__ */ import_react12.default.createElement("button", {
      className: "stats-scrollButton",
      onClick: scrollGridLeft
    }, "<"), /* @__PURE__ */ import_react12.default.createElement("button", {
      className: "stats-scrollButton",
      onClick: scrollGrid
    }, ">"), /* @__PURE__ */ import_react12.default.createElement("div", {
      className: `main-gridContainer-gridContainer stats-gridInline`
    }, statCards))), /* @__PURE__ */ import_react12.default.createElement("section", {
      className: "main-shelf-shelf Shelf"
    }, /* @__PURE__ */ import_react12.default.createElement("div", {
      className: "main-shelf-header"
    }, /* @__PURE__ */ import_react12.default.createElement("div", {
      className: "main-shelf-topRow"
    }, /* @__PURE__ */ import_react12.default.createElement("div", {
      className: "main-shelf-titleWrapper"
    }, /* @__PURE__ */ import_react12.default.createElement("h2", {
      className: "Type__TypeElement-sc-goli3j-0 TypeElement-canon-textBase-type main-shelf-title"
    }, "Most Frequent Artists")))), /* @__PURE__ */ import_react12.default.createElement("section", {
      className: "stats-gridInlineSection"
    }, /* @__PURE__ */ import_react12.default.createElement("button", {
      className: "stats-scrollButton",
      onClick: scrollGridLeft
    }, "<"), /* @__PURE__ */ import_react12.default.createElement("button", {
      className: "stats-scrollButton",
      onClick: scrollGrid
    }, ">"), /* @__PURE__ */ import_react12.default.createElement("div", {
      className: `main-gridContainer-gridContainer stats-gridInline`
    }, artistCards))))));
  };
  var library_default = import_react12.default.memo(LibraryPage);

  // src/app.tsx
  var pages = {
    ["Artists"]: /* @__PURE__ */ import_react13.default.createElement(top_artists_default, null),
    ["Tracks"]: /* @__PURE__ */ import_react13.default.createElement(top_tracks_default, null),
    ["Genres"]: /* @__PURE__ */ import_react13.default.createElement(top_genres_default, null),
    ["Library"]: /* @__PURE__ */ import_react13.default.createElement(library_default, null)
  };
  var App = () => {
    const [navBar, activeLink, setActiveLink] = useNavigationBar_default(["Artists", "Tracks", "Genres", "Library"]);
    console.log("app render");
    import_react13.default.useEffect(() => {
      setActiveLink("Artists");
    }, []);
    if (!activeLink)
      return /* @__PURE__ */ import_react13.default.createElement(import_react13.default.Fragment, null);
    return /* @__PURE__ */ import_react13.default.createElement(import_react13.default.Fragment, null, navBar, pages[activeLink]);
  };
  var app_default = App;

  // node_modules/spicetify-creator/dist/temp/index.jsx
  var import_react14 = __toESM(require_react());
  function render() {
    return /* @__PURE__ */ import_react14.default.createElement(app_default, null);
  }
  return __toCommonJS(temp_exports);
})();
const render=()=>stats.default();
