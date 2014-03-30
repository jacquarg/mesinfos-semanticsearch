Tokenizer = require 'tokenizer'


rules = (t) ->
    #template
    #t.addRule /^$/,"rule"

    # Maybe useful
    #t.addRule /^"[^"]*"$/, "citation"
    # the 'maybe citation' rule is here to continue matching until
    # the closing quote is found
    #t.addRule /^"[^"]*$/, "maybe citation"

    # REFERENCES TO SELF AND POSSESSIONS
    t.addRule /^je$/i, "myself"
    t.addRule /^m'a$/i, "toSelf"
    t.addRule /^j'ai$/i, "myself"
    t.addRule /^je$/i, "myself"
    t.addRule /^mes$/, "my"

    # Ponctuation

    # REFERENCES TO OTHERS
    t.addRule /^qui$/i,"who"
    t.addRule /^avec$/i,"with"


    # QUANTITIES
    t.addRule /^combien$/i,"howMany"
    t.addRule /^plus$/i,"biggerThan"

    # ACTIONS
    t.addRule /^passe$/, "did"
    t.addRule /^fait$/, "did"



    # PHONE COMMUNICATIONS
    t.addRule /^appele$/,"phoneCall"
    t.addRule /^appelee$/,"phoneCall"
    t.addRule /^appel$/,"phoneCall"
    t.addRule /^appels$/,"phoneCall"
    t.addRule /^contacte$/,"phoneComLog"
    t.addRule /^contactee$/,"phoneComLog"
    t.addRule /^ecrit$/,"phoneText"

    # TEMPORAL OBJECTS
    ## Temporal helpers
    t.addRule /^cette annee$/, "currentTemporal"
    t.addRule /^ce$/, "currentTemporal"
    t.addRule /^cette$/, "currentTemporal"
    t.addRule /^dernier$/, "lastTemporal"
    t.addRule /^derniere$/, "lastTemporal"

    ## Years
    t.addRule /^\d{4}$/,"givenYear"
    t.addRule /^en(\d{4})$/,"givenYear"
    t.addRule /^annee$/,"year"
    ## Months
    t.addRule /^mois$/, "month"
    t.addRule /^mois-ci$/, "month"
    t.addRule /^janvier$/,"givenMonth"
    t.addRule /^fevrier$/,"givenMonth"
    t.addRule /^mars$/,"givenMonth"
    t.addRule /^avril/,"givenMonth"
    t.addRule /^mai$/,"givenMonth"
    t.addRule /^juin$/,"givenMonth"
    t.addRule /^juillet$/,"givenMonth"
    t.addRule /^aout$/,"givenMonth"
    t.addRule /^septembre$/,"givenMonth"
    t.addRule /^octobre$/,"givenMonth"
    t.addRule /^novembre$/,"givenMonth"
    t.addRule /^decembre$/,"givenMonth"
    ## Weeks
    t.addRule /^semaine$/, "week"
    ## Days
    ## Minute
    # TODO check if duration in abstracter.
    t.addRule /^minute$/, "minutes"
    t.addRule /^minutes$/, "minutes"

    ## Specific date : le 17-03-1997
    t.addRule /^(le(\s)\d{1,2})-(\d{1,2})-(\d{4})$/,"specificDate"
    ## Quand
    t.addRule /^quand$/, "when"

    # RECEIPTS
    t.addRule /^courses$/, "allArticles"
    t.addRule /^article$/, "article"
    # Prix
    t.addRule /^euros$/, "priceMarker"
    t.addRule /^euro$/, "priceMarker"
    # Floats
    t.addRule /^(?:[1-9]\d*|0)?(?:\.\d+)?$/, "float"

    ## BLACKLIST
    t.addRule /^a$/, "blacklist"
    t.addRule /^ai$/,"blacklist"
    t.addRule /^en$/, "blacklist"
    t.addRule /^d$/, "blacklist"
    t.addRule /^de$/, "blacklist"
    t.addRule /^la$/, "blacklist"


    # if it's a word and it's not been matched yet it's probably a name
    # wording for now
    t.addRule /^\w+$/, "wordToEvaluate"
    t.addRule /^(\s)+$/, "whitespace"
    t.ignore "whitespace"
    t.ignore "blacklist"
    t.ignore "ponctuation"
    t.addRule /^[',;.:!?-]$/, "ponctuation"


module.exports = (input, callback) ->
    tokens = []
    t = new Tokenizer()
    rules(t)
    t.on 'token', (tok) -> tokens.push tok
    t.on 'data', -> # do nothing, fuck stream API
    t.on 'error', (error) ->
        callback error
        callback = ->
    t.on 'end', ->
        callback null, tokens
        callback = ->
    t.write input
    t.end()