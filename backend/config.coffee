
path = require 'path'

express = require 'express'
i18n = require 'i18n'
lessMiddleware = require 'less-middleware'
markdown = require 'node-markdown'
moment = require 'moment'
mongoose = require 'mongoose'

slug = require 'slug'
slug.charmap['('] = '-'
slug.charmap[')'] = '-'

i18n.configure
    locales: ['cs']
    directory: __dirname + '/locales'
    register: global
    updateFiles: true
i18n.setLocale 'cs'

moment.locale 'cs',
    months: ['ledna', 'února', 'března', 'dubna', 'května', 'června', 'července', 'srpna', 'září', 'října', 'listopadu', 'prosince']
    weekdays: ['neděle', 'pondělí', 'úterý', 'středa', 'čtvrtek', 'pátek', 'sobota']

mongoose.connect 'mongodb://localhost/lunchtimeandeldb'

module.exports = (app) ->
    app.locals
        __i: __
        __n: __n
        md: markdown.Markdown

    app.configure ->
        app.set 'port', process.env.PORT or 3000
        app.set 'views', __dirname + '/views'
        app.set 'view engine', 'jade'
        app.use express.logger 'default'
        app.use express.bodyParser()
        app.use i18n.init
        app.use app.router
        app.use lessMiddleware path.join __dirname, '..', 'public'
        app.use express.static path.join __dirname, '..', 'public'
        app.use (err, req, res, next) ->
            console.error err.stack
            next err

    app.configure 'development', ->
        app.use express.errorHandler()

    @
