
moment = require 'moment'

module.exports = (models) ->
    LunchmenuLoader = require('./lunchmenuLoader')(models)

    class HlubinaLoader extends LunchmenuLoader
        constructor: () ->
            @name = 'Hlubina'
            @homepage = 'http://www.restaurace-hlubina.cz/'
            @downloadUrl = 'http://www.lunchtime.cz/hlubina/pw/denni-menu/'
            @phoneNumber = '+420 257 328 184'
            @address =
                street: 'Lidická 311/37'
                city: 'Praha 5'
                zip: 15000
                map:
                    lat: 50.072111
                    lng: 14.405276

        parse: (meals, $) ->
            today = moment().format('YYYY-MM-DD')
            $('#restDailyMenu'+today+'Ajax tr').each (i, elem) ->
                meals.push new models.Meal
                    name: $(this).find('td').first().text().trim()
                    price: $(this).find('td').last().text().trim()

    return HlubinaLoader
