
goog.provide 'lta.Search'

goog.require 'goog.dom'
goog.require 'goog.dom.query'
goog.require 'goog.events'
goog.require 'goog.events.KeyCodes'
goog.require 'lta.Restaurants'


class lta.Search
    ###*
    @type {Object}
    @private
    ###
    searchinput: null

    ###*
    @type {Object}
    @private
    ###
    keywordmap: {
        'a': ['á', 'ä'],
        'c': ['č'],
        'd': ['ď'],
        'e': ['é', 'ě', 'ë'],
        'i': ['í', 'ï'],
        'n': ['ň'],
        'o': ['ó', 'ö'],
        'r': ['ř'],
        's': ['š'],
        't': ['ť'],
        'u': ['ú', 'ů', 'ü'],
        'y': ['ý']
        'z': ['ž'],
    }

    ###*
    @type {lta.Restaurants}
    @private
    ###
    restaurants: null

    ###*
    @type {?number}
    @private
    ###
    timeout: null

    ###*
    @param {string} searchboxId
    @param {lta.Restaurants} restaurants
    @constructor
    ###
    constructor: (searchboxId, @restaurants) ->
        that = @

        searchbox = goog.dom.getElement searchboxId
        @searchinput = goog.dom.getElementsByTagNameAndClass('input', null, searchbox)[0]
        searchbutton = goog.dom.getElementsByTagNameAndClass('button', null, searchbox)[0]

        @searchinput.focus()
        goog.events.listen @searchinput, goog.events.EventType.INPUT, (e) ->
            that.search()
        goog.events.listen @searchinput, goog.events.EventType.KEYUP, (e) ->
            if that.timeout
                window.clearTimeout that.timeout
                that.timeout = null
            if e.keyCode is goog.events.KeyCodes.ESC
                that.clear()
            else
                callback = () ->
                    that.trackSearch that.searchinput.value
                that.timeout = setTimeout callback, 2000
        goog.events.listen searchbutton, goog.events.EventType.CLICK, (e) ->
            that.clear()

    clear: () ->
        @searchinput.value = ''
        @searchinput.focus()
        # Remove highlight, show restaurant, ...
        @search()

    search: () ->
        @restaurants.search @getQuery()

    ###*
    @private
    ###
    getQuery: () ->
        keyword = ''
        for letter in @searchinput.value
            letters = @keywordmap[letter] || []
            letters = letters.slice(0)
            letters.push(letter)
            keyword += '[' + (letters).join('') + ']'
        keyword

    ###*
    @param {string} keyword
    @private
    ###
    trackSearch: (keyword) ->
        if window['_gaq']
            window['_gaq'].push ['_trackEvent', 'Search', 'Keyword', keyword]


window['lta'] = lta
lta['Search'] = lta.Search
