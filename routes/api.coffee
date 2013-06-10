
module.exports = (app, models) ->
    app.get '/api/listall', (req, res) ->
        models.Restaurant.find {}, (err, restaurants) ->
            result = []
            for restaurant in restaurants
                meals = []
                for meal in restaurant.meals
                    meals.push getMealAttributes meal
                restaurant = getRestaurantAttributes restaurant
                restaurant.meals = meals
                result.push restaurant
            res.json result

    app.get '/api/meal/random', (req, res) ->
        models.Restaurant.random (err, restaurant) ->
            meal = restaurant.getRandomMeal()
            res.json
                restaurant: getRestaurantAttributes restaurant
                meal: getMealAttributes meal

    getRestaurantAttributes = (restaurant) ->
        name: restaurant.name
        url: restaurant.url
        lunchmenuUrl: restaurant.lunchmenuUrl
        lastUpdate: restaurant.lastUpdate
        map: restaurant.map

    getMealAttributes = (meal) ->
        name: meal.name
        price: meal.getPrintablePrice()

    @